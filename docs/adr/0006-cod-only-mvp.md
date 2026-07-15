# ADR 0006: Cash on Delivery Only MVP

## Status
Accepted

## Context
Integrating payment gateways (Stripe, VNPay, Momo) involves complex webhook handling, reconciliation, testing in sandboxes, and regulatory/business setup which significantly delays the MVP launch.

## Decision
The MVP will exclusively support "Cash on Delivery" (COD). When a user checks out, the order is immediately created with a status of `PENDING` and stock is deducted. No external payment API integration will be built.

## Consequences
- **Positive**: Vastly accelerates time to market for the MVP.
- **Negative**: Higher risk of order cancellation/returns from customers. We will need to implement payment gateways in V2.
