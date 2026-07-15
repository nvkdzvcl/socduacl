# Socduacl - Redis Design

Redis is used for caching, transient state, and rate limiting. It is **NOT** the sole source of truth for critical order or inventory data. If Redis is unavailable, the application should gracefully degrade (e.g., bypassing cache, rejecting guest carts) but authenticated checkout must survive.

## 1. Key Naming Conventions & Policies

### Guest Carts
- **Key**: `cart:guest:{sessionId}` (e.g., `cart:guest:abc123xyz`)
- **Format**: JSON String representing an array of `{variantId, quantity}`.
- **TTL**: 7 days (604800 seconds).
- **Ownership**: Sales Module.
- **Invalidation**: Deleted upon successful login (merged to DB cart) or successful checkout.
- **Failure Behavior**: If Redis is down, guest users cannot add items to the cart. Authenticated users (who use DB-backed carts if implemented, or failover gracefully) might be affected depending on the fallback strategy. For MVP, guest cart relies on Redis.

### Token Revocation (Blacklist)
- **Key**: `auth:revoked_token:{jti}` (JWT ID)
- **Format**: String (empty `""`).
- **TTL**: Matches the remaining expiration time of the JWT.
- **Ownership**: IAM Module.
- **Invalidation**: Auto-expires.
- **Failure Behavior**: If Redis is down, recently revoked tokens might still be accepted until they naturally expire. Acceptable risk for MVP.

### Checkout Idempotency
- **Key**: `checkout:idempotency:{idempotencyKey}`
- **Format**: JSON String `{status: "PROCESSING|COMPLETED", orderId: "uuid"}`.
- **TTL**: 24 hours.
- **Ownership**: Sales Module.
- **Invalidation**: Auto-expires.
- **Failure Behavior**: If Redis is down, the system should either query the DB for the idempotency key (if stored in `sales_orders`) or reject the checkout to be safe. Since `sales_orders` has `idempotency_key` as a unique constraint, the DB provides the ultimate safeguard; Redis is an optimization layer.

### Login Rate Limiting
- **Key**: `rate_limit:login:{ip_address}`
- **Format**: Integer (counter).
- **TTL**: 15 minutes.
- **Ownership**: IAM Module.
- **Invalidation**: Auto-expires.
- **Failure Behavior**: If Redis is down, allow login attempts (fail open) to prevent locking out legitimate users due to cache failure.

### Product/Category Cache
- **Key**: `cache:catalog:categories`, `cache:catalog:product:{slug}`
- **Format**: JSON String.
- **TTL**: 1 hour.
- **Ownership**: Catalog Module.
- **Invalidation**: Cleared explicitly via RabbitMQ event `ProductUpdatedEvent` or `CategoryUpdatedEvent` consumed by the cache listener, or via direct Admin API interaction.
- **Failure Behavior**: If Redis is down, queries bypass cache and hit PostgreSQL directly.
