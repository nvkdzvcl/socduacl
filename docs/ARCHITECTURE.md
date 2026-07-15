# Socduacl - Architecture

## 1. Architectural Style
**Modular Monolith**: The application is built as a single deployable unit (Spring Boot application) divided into distinct logical modules with strict boundaries. 

*Rationale*: Avoids the operational complexity of microservices while maintaining clean boundaries for future extraction if needed. Suitable for independent AI developer tasks.

## 2. Technology Stack
- **Backend**: Java 21, Spring Boot 3, Spring Security, Spring Data JPA.
- **Frontend**: Next.js (App Router), TypeScript, Tailwind CSS, TanStack Query, Zustand, React Hook Form, Zod.
- **Database**: PostgreSQL (Relational Data). Database migrations managed by Flyway.
- **Message Broker**: RabbitMQ (Asynchronous events).
- **Cache / Transient Store**: Redis (Guest carts, rate limiting, token blacklists).
- **Object Storage**: MinIO (Product images, banners).
- **Infrastructure**: Docker Compose for local development and execution.

## 3. High-Level Architecture
```
[ Frontend (Next.js) ]
          |
    (REST API / JSON)
          |
[ Backend (Spring Boot Modular Monolith) ]
          |
    +-----+-----+-----+-----+
    |           |           |
[PostgreSQL] [Redis] [RabbitMQ] --> [Async Consumers]
                            |
                         [MinIO]
```

## 4. Key Design Principles
1. **API First**: The frontend and backend communicate strictly via REST APIs defined by OpenAPI/Swagger.
2. **Event-Driven Internals**: Cross-module communication that does not require an immediate synchronous response uses RabbitMQ (Domain Events).
3. **Stateless Backend**: JWT authentication is used. Session state is managed either in the frontend or in Redis (e.g., guest cart).
4. **Snapshotting**: Domain models that represent historical transactions (like Orders) must capture snapshots of referenced entities (Product details, price) to prevent historical data corruption.
