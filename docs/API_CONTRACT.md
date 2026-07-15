# Socduacl - API Contracts

The REST API follows standard conventions and is documented via OpenAPI/Swagger.

## 1. Base URL
All API endpoints are prefixed with `/api/v1`.

## 2. Authentication
- Secured endpoints require an `Authorization: Bearer <JWT>` header.
- Responses to unauthorized requests: `401 Unauthorized`.
- Responses to forbidden requests: `403 Forbidden`.

## 3. Core Endpoints (MVP)

### Authentication
- `POST /api/v1/auth/register` - Register a new customer.
- `POST /api/v1/auth/login` - Authenticate and receive JWT.

### Catalog (Public)
- `GET /api/v1/categories` - List categories.
- `GET /api/v1/products` - List products (supports filters: `category`, `size`, `color`, `minPrice`, `maxPrice`, `page`, `size`).
- `GET /api/v1/products/{slug}` - Get product details including variants and images.

### Cart
- `GET /api/v1/cart` - Get current cart.
- `POST /api/v1/cart/items` - Add item to cart.
- `PUT /api/v1/cart/items/{itemId}` - Update item quantity.
- `DELETE /api/v1/cart/items/{itemId}` - Remove item.

### Checkout & Orders
- `POST /api/v1/checkout` - Submit an order (COD).
- `GET /api/v1/orders` - Get current user's order history.
- `GET /api/v1/orders/{orderNumber}` - Get order details.

### Admin
- `POST, PUT, DELETE` on catalog endpoints prefixed with `/api/v1/admin/`.
- `GET /api/v1/admin/orders` - List all orders.
- `PATCH /api/v1/admin/orders/{orderId}/status` - Update order status.

## 4. Response Format
Standardized error responses:
```json
{
  "timestamp": "2026-07-16T01:12:31+07:00",
  "status": 400,
  "error": "Bad Request",
  "message": "Validation failed",
  "details": ["color must not be null"]
}
```
