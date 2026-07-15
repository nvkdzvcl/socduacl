# Socduacl - Event Contracts (RabbitMQ)

RabbitMQ is used for asynchronous domain events to decouple modules.
**Important**: Events are NEVER published directly during a business transaction. They are written to the `outbox_events` table and published asynchronously by the Outbox Publisher.

## 1. Exchanges
- `socduacl.topic` (Type: Topic): Main exchange for routing all domain events.

## 2. Events & Routing Keys

### `OrderCreatedEvent`
- **Routing Key**: `sales.order.created`
- **Payload**:
  ```json
  {
    "eventId": "uuid",
    "timestamp": "ISO-8601",
    "orderId": "uuid",
    "orderNumber": "SOC-12345",
    "userId": "uuid",
    "totalAmount": 500000.0,
    "items": [
      {
        "variantId": "uuid",
        "quantity": 2
      }
    ]
  }
  ```
- **Consumers**: 
  - `Notification` module: Send order confirmation email.
  - `Analytics` module (Future).

### `OrderStatusChangedEvent`
- **Routing Key**: `sales.order.status_changed`
- **Payload**:
  ```json
  {
    "eventId": "uuid",
    "orderId": "uuid",
    "oldStatus": "PENDING",
    "newStatus": "PROCESSING"
  }
  ```
- **Consumers**:
  - `Notification` module: Send update to customer.
  - *(Note: Stock restoration on CANCELLED is done synchronously via DB transaction, not asynchronously via this event, to prevent race conditions).*

### `ProductUpdatedEvent`
- **Routing Key**: `catalog.product.updated`
- **Payload**:
  ```json
  {
    "eventId": "uuid",
    "productId": "uuid",
    "slug": "product-slug"
  }
  ```
- **Consumers**:
  - `Cache` invalidator: Removes `cache:catalog:product:{slug}` from Redis.

## 3. Queues & Consumer Requirements
- Queues are bound to the `socduacl.topic` exchange.
- **Idempotency**: Because the Outbox Publisher might retry sending an event if RabbitMQ doesn't ACK in time, consumers **must** be idempotent. They should check the `idempotent_consumer_log` table using the `eventId` before processing.
- **Dead Letter Exchanges (DLX)**: Must be configured for all queues to catch poison messages.
