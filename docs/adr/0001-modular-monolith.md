# ADR 0001: Modular Monolith Architecture

## Status
Accepted

## Context
We need to build a new e-commerce system from scratch. We anticipate a small AI developer team working independently on backend, frontend, and QA tasks. Using microservices introduces significant operational complexity (service discovery, distributed tracing, network latency, complex deployment). A traditional monolith can become a "Big Ball of Mud".

## Decision
We will use a Modular Monolith architecture implemented with Java 21 and Spring Boot 3. The system will be divided into strict logical modules (IAM, Catalog, Sales, Inventory, Media, Notification). Each module will have its own database tables (prefixed by module name) and will communicate via internal Java interfaces or asynchronously via RabbitMQ domain events. Cross-module database queries are forbidden.

## Consequences
- **Positive**: Simple local deployment via Docker Compose. No network latency between modules. Single repository simplifies CI/CD. Refactoring module boundaries is easier at the compiler level than across network boundaries.
- **Negative**: Careful discipline is required to maintain module boundaries. We must rely on package visibility and architectural tests to enforce rules.
