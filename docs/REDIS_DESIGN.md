# Socduacl - Redis Design

Redis is used for caching, transient state, and rate limiting.

## 1. Key Spaces & TTL Policies

### Guest Carts
- **Key**: `cart:{sessionId}` (e.g., `cart:abc123xyz`)
- **Data Structure**: Hash or JSON string representing the cart items.
- **TTL**: 7 days (604800 seconds). Refreshed on every interaction.
- **Usage**: Stores cart items for users who have not logged in. Upon login, this cart is merged with the user's database-backed cart.

### Category / Product Cache
- **Key**: `cache:categories:all` or `cache:product:{slug}`
- **Data Structure**: String (JSON).
- **TTL**: 1 hour.
- **Invalidation**: Cleared or updated when an admin modifies a category or product via the Admin API.

### Rate Limiting
- **Key**: `rate_limit:login:{ip_address}`
- **Data Structure**: Integer (counter).
- **TTL**: 15 minutes.
- **Usage**: Prevents brute-force login attempts (e.g., max 5 attempts per 15 mins).

### JWT Blacklist (Optional for MVP)
- **Key**: `auth:blacklist:{jwt_jti}`
- **Data Structure**: String (empty or arbitrary value).
- **TTL**: Matches the remaining expiration time of the blacklisted JWT.
- **Usage**: Prevents usage of tokens that were explicitly invalidated (e.g., on logout).

### Checkout Idempotency
- **Key**: `checkout:idempotency:{idempotency_key}`
- **Data Structure**: String (Order ID).
- **TTL**: 24 hours.
- **Usage**: Prevents double-charging or double-order creation if the client retries a checkout request.
