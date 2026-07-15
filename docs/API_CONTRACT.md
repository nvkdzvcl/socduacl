# Socduacl - API Contracts

All endpoints are prefixed with `/api/v1`.

## Common Formats
- **Pagination**: Query params `page=0` (0-indexed), `pageSize=20`.
- **Validation Errors**: 400 status. `{"status": 400, "message": "Validation failed", "errors": {"field": "error detail"}}`
- **Domain Errors**: 400/409 status. `{"status": 400, "code": "OUT_OF_STOCK", "message": "Variant XYZ is out of stock."}`
- **Timestamps**: ISO-8601 (e.g., `2026-07-16T01:24:12Z`).
- **Money**: Decimal representing standard currency units (VND).
- **UUIDs**: Standard 36-character representation.

## 1. IAM / Authentication
- `POST /auth/register`: Public. Body: `{email, password, firstName, lastName, phone}`.
- `POST /auth/login`: Public. Body: `{email, password}`. Returns `{accessToken, refreshToken, expiresIn}`.
- `POST /auth/refresh`: Public. Body: `{refreshToken}`. Returns new token pair.
- `POST /auth/logout`: Auth required. Body: `{refreshToken}`.
- `GET /account/addresses`: Auth required. Returns list of saved addresses.
- `POST /account/addresses`: Auth required. Body: `{recipientName, phone, street, city, district, ward, isDefault}`.

## 2. Catalog (Public)
- `GET /categories`: Public. Returns hierarchical categories.
- `GET /brands`: Public. Returns list of brands.
- `GET /products`: Public. Query params: `categoryId`, `sizes` (e.g. `M,L`), `colors`, `minPrice`, `maxPrice`, `page`, `pageSize`. Returns paginated products.
- `GET /products/{slug}`: Public. Returns product details, variants, images, and base stock status.

## 3. Admin Catalog Management
- **Auth**: Required. **Role**: `ROLE_ADMIN`.
- `POST /admin/categories`, `PUT /admin/categories/{id}`, `DELETE /admin/categories/{id}`
- `POST /admin/brands`, `PUT /admin/brands/{id}`, `DELETE /admin/brands/{id}`
- `POST /admin/products`: Body: `{name, categoryId, brandId, description, basePrice}`.
- `POST /admin/products/{id}/variants`: Body: `{sku, size, color, priceOverride, initialStock}`.
- `POST /admin/media/presigned-url`: Request a MinIO upload URL. Body `{filename, contentType}`. Returns `{uploadUrl, objectKey}`.
- `POST /admin/products/{id}/images`: Confirm image upload. Body `{objectKey, isPrimary}`.
- `DELETE /admin/products/{id}/images/{imageId}`: Delete image.
- `POST /admin/inventory/adjust`: Body: `{variantId, quantityChange, reason}`.

## 4. Cart & Checkout
- `GET /cart`: Uses `Authorization` header if logged in, or `X-Guest-Session-Id` header for guests.
- `POST /cart/items`: Body: `{variantId, quantity}`.
- `PUT /cart/items/{variantId}`: Body: `{quantity}`.
- `DELETE /cart/items/{variantId}`
- `POST /checkout`: 
  - **Auth**: Required for user checkout, Optional for guest.
  - **Headers**: `Idempotency-Key: <uuid>` (Required).
  - **Body**: `{shippingAddress: {recipientName, phone, street, city, district, ward}, paymentMethod: "COD"}`.
  - **Success**: 201 Created. Returns `{orderId, orderNumber, totalAmount, status}`.
  - **Errors**: 400 `OUT_OF_STOCK`, 409 `DUPLICATE_REQUEST` (if idempotency key reused with different payload).

## 5. Orders
- `GET /orders`: Auth required. Returns current user's order history.
- `GET /orders/{orderNumber}`: Auth required.
- `GET /admin/orders`: Admin required. Params: `status`, `page`, `pageSize`.
- `PATCH /admin/orders/{id}/status`: Admin required. Body `{status: "PROCESSING|SHIPPING|DELIVERED|CANCELLED", note: "..."}`.
