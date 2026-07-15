# Socduacl - Transactional Outbox Pattern

## 1. Concept
To ensure reliable event publishing without two-phase commit (2PC) distributed transactions, we use the Transactional Outbox pattern. 
When a business entity (like an Order) is created or modified, the domain event is saved to an `outbox_events` table within the same database transaction. A separate asynchronous worker polls this table and publishes the events to RabbitMQ.

## 2. Table Schema
- **`outbox_events`**:
  - `id` (UUID, Primary Key)
  - `aggregate_type` (String, e.g., 'Order')
  - `aggregate_id` (UUID)
  - `event_type` (String, e.g., 'OrderCreated')
  - `payload` (JSONB)
  - `created_at` (Timestamp)
  - `processed_at` (Timestamp, Nullable)
  - `correlation_id` (UUID)
  - `causation_id` (UUID, Optional)
  - `version` (Integer, default 1)

## 3. Publication Lifecycle
1. **Insert**: Business transaction saves state + inserts `outbox_events` record.
2. **Poll**: A Scheduled Task (e.g., Spring `@Scheduled(fixedDelay = 5000)`) polls for records where `processed_at IS NULL` (limit 100).
3. **Publish**: The task publishes the payload to RabbitMQ (`socduacl.topic`).
4. **Mark Processed**: Upon successful ACK from RabbitMQ, the task updates `processed_at = NOW()`.

## 4. Error Handling & Retry Strategy
- **Retry**: If publishing fails, the record remains `processed_at IS NULL` and will be retried in the next polling cycle.
- **Retry Limits**: Add a `retry_count` column if needed. For the MVP, continuous retry is acceptable assuming broker connectivity issues are temporary.
- **Dead-Letter Queue (DLQ)**: RabbitMQ queues must be configured with a DLQ for messages that fail to be processed by consumers.
- **Consumer Idempotency**: Because outbox retries or network issues can cause a message to be published multiple times, **all RabbitMQ consumers must be idempotent**.
- **Processed Event Tracking (Idempotency)**: Consumers should maintain an `idempotent_consumer_log` table storing `event_id` to prevent processing the same event twice.

## 5. Replay Procedure
If a consumer fails due to a bug, the bug is fixed, and we need to replay events:
1. Update `processed_at = NULL` in `outbox_events` for the specific `aggregate_id` and `event_type`.
2. The outbox worker will automatically pick it up and republish.
