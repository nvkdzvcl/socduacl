# ADR 0004: Redis Responsibilities

## Status
Accepted

## Context
We need caching and transient state management for the application.

## Decision
Redis will be used for specific, non-critical, or transient state management scenarios:
1. **Guest Carts**: Storing carts for unauthenticated users.
2. **Checkout Idempotency**: Storing idempotency keys to prevent duplicate order creation upon client retries.
3. **Login Rate Limiting**: Tracking failed login attempts.
4. **Token Revocation (Optional)**: Blacklisting JWTs before they expire.
5. **Product/Category Cache**: Caching catalog data to reduce database load.

Redis will **NOT** be used as the sole source of truth for critical order, inventory, or user data. If Redis goes down, the system should gracefully degrade (e.g., bypassing cache, losing guest carts) but core operations (authenticated checkout, order management) must survive or fail cleanly without data corruption.

## Consequences
- **Positive**: High performance for frequent transient operations.
- **Negative**: Requires handling Redis connection failures gracefully.
