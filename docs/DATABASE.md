# Socduacl - Database Design

The database is PostgreSQL. Each module manages its own tables, identified by prefixes.

## 1. Tables Overview

### IAM Module
- **`iam_users`**: `id`, `email`, `password_hash`, `first_name`, `last_name`, `phone`, `created_at`, `updated_at`.
- **`iam_roles`**: `id`, `name` (ROLE_USER, ROLE_ADMIN).
- **`iam_user_roles`**: `user_id`, `role_id`.

### Catalog Module
- **`catalog_categories`**: `id`, `name`, `slug`, `description`, `parent_id`, `created_at`.
- **`catalog_brands`**: `id`, `name`, `slug`, `logo_url`.
- **`catalog_products`**: `id`, `brand_id`, `category_id`, `name`, `slug`, `description`, `base_price`, `status`, `created_at`.
- **`catalog_product_variants`**: `id`, `product_id`, `sku`, `size`, `color`, `price_override`, `stock_quantity`.
- **`catalog_product_images`**: `id`, `product_id`, `minio_object_key`, `is_primary`, `sort_order`.

### Sales Module
- **`sales_orders`**: `id`, `user_id` (nullable for guest checkout), `order_number`, `status` (PENDING, PROCESSING, SHIPPING, DELIVERED, CANCELLED), `total_amount`, `payment_method` (COD), `shipping_address_json`, `created_at`, `updated_at`.
- **`sales_order_items`**: `id`, `order_id`, `product_id` (reference), `variant_id` (reference), `snapshot_sku`, `snapshot_name`, `snapshot_size`, `snapshot_color`, `unit_price`, `quantity`, `subtotal`.

## 2. Key Constraints
- Soft deletes are not used by default unless specifically required; use `status` fields instead.
- Use UUIDs or Snowflake IDs for primary keys exposed to the client to avoid enumeration.
- Indexes must be created on `slug`, `email`, `sku`, and `user_id` for performance.
