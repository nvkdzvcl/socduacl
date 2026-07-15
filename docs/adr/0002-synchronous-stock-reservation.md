# ADR 0002: Synchronous Stock Reservation

## Status
Accepted

## Context
During checkout, the system must ensure that the user does not purchase an item that is out of stock. Some architectures use asynchronous stock reservation via a message broker. However, for the MVP, an asynchronous flow introduces complex compensation logic (Sagas) and the risk of taking an order successfully while silently failing to secure inventory.

## Decision
We will validate the cart, reserve/deduct stock, and create the order **synchronously** within the same reliable database transaction. The checkout request will fail immediately if the stock is unavailable.

## Consequences
- **Positive**: Strong consistency. No risk of overselling or complex rollback logic. The user gets immediate feedback on out-of-stock items.
- **Negative**: The checkout transaction is longer and relies on database row locks (e.g., `SELECT ... FOR UPDATE`), potentially limiting throughput during extreme hype drops.
