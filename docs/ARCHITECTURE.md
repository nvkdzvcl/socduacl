# Socduacl - Architecture

## 1. Architectural Style
**Modular Monolith**: The application is a single deployable unit divided into strict logical modules (IAM, Catalog, Sales, Inventory, Media). Cross-module database queries are forbidden. Modules communicate via internal Java interfaces or asynchronously via RabbitMQ. (See ADR-0001).

## 2. Technology Stack
- **Backend**: Java 21, Spring Boot 3, Spring Security, Spring Data JPA.
- **Frontend**: Next.js (App Router), TypeScript, Tailwind CSS, TanStack Query, Zustand.
- **Database**: PostgreSQL.
- **Message Broker**: RabbitMQ.
- **Cache**: Redis.
- **Object Storage**: MinIO.

## 3. High-Level Architecture
```
[ Frontend (Next.js) ]
          |
    (REST API)
          |
[ Backend (Spring Boot Modular Monolith) ]
          |
    +-----+-----+-----+-----+
    |           |           |
[PostgreSQL] [Redis] [RabbitMQ] --> [Async Consumers]
                            |
                         [MinIO]
```

## 4. Checkout & Inventory Workflow (Synchronous)
To prevent overselling and complex compensation logic, the MVP implements a synchronous checkout workflow (See ADR-0002).

**Transaction Boundary (One atomic database transaction):**
1. User submits checkout request.
2. Sales module calls Inventory module internally.
3. Inventory module checks `inventory_stock` and deducts stock (using `SELECT ... FOR UPDATE` or `@Version` optimistic locking).
4. Sales module creates `sales_orders`, `sales_order_addresses`, and `sales_order_items`.
5. Sales module writes an `OrderCreatedEvent` to the `outbox_events` table (Transactional Outbox pattern).
6. Transaction Commits.

**If stock is unavailable, the entire transaction rolls back, and a 400 Bad Request is returned to the user.**

**Cancellation & Stock Release:**
When an order is cancelled (either by Admin or User), an `OrderStatusChangedEvent` is written to the outbox. The Inventory module (or Sales module calling Inventory synchronously) will restore the deducted quantity back to `inventory_stock`. For MVP, restoring stock synchronously during the cancellation transaction is preferred for simplicity.

## 5. Asynchronous Processing (RabbitMQ & Outbox)
RabbitMQ is used exclusively for non-critical, side-effect processing (See ADR-0003).
1. A background worker polls the `outbox_events` table.
2. Events are published to RabbitMQ.
3. Consumers listen to RabbitMQ for:
   - Customer Notifications (Emails/SMS - out of scope for MVP but architected for it).
   - Audit/Activity processing.
   - Cache invalidation (e.g., clearing Redis catalog cache when a `ProductUpdatedEvent` is fired).
4. Consumers use `idempotent_consumer_log` to prevent duplicate processing.
