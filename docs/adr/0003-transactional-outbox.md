# ADR 0003: Transactional Outbox

## Status
Accepted

## Context
When an order is created synchronously (ADR 0002), we need to notify other parts of the system (e.g., Notification module, Analytics) via RabbitMQ. Dual writing (writing to the database and publishing to RabbitMQ) in a single operation can fail, leading to inconsistencies (e.g., database commits but message fails to publish, or message publishes but database transaction rolls back).

## Decision
We will implement the Transactional Outbox Pattern. When a business transaction commits (e.g., saving an Order), we simultaneously insert an event record into an `outbox_events` table within the same transaction. A separate asynchronous process (e.g., a Spring `@Scheduled` task) polls the `outbox_events` table and publishes the events to RabbitMQ. After successful publication, the event is marked as processed.

## Consequences
- **Positive**: Guarantees at-least-once delivery of domain events. Prevents dual-write inconsistencies.
- **Negative**: Adds database overhead (writing and polling the outbox table). RabbitMQ consumers must be idempotent because outbox retries can result in duplicate message delivery.
