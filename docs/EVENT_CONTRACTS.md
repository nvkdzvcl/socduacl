# Socduacl - Event Contracts (RabbitMQ)

RabbitMQ is used for asynchronous domain events to decouple modules.

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
  - `Inventory` module: Deduct stock for the ordered variants.
  - `Notification` module: Send order confirmation email.

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
  - `Inventory` module: If status is `CANCELLED`, restore stock.

## 3. Queues
Queues are bound to the `socduacl.topic` exchange with specific binding keys.
- `inventory.order_created.queue` bound to `sales.order.created`
- `notification.order_created.queue` bound to `sales.order.created`
- `inventory.order_cancelled.queue` bound to `sales.order.status_changed` (filtered by payload or specific routing key like `sales.order.cancelled`)

## 4. Error Handling
- Dead Letter Exchanges (DLX) must be configured for all queues.
- Retry mechanisms with exponential backoff should be implemented using Spring AMQP.
