# Socduacl - Database Design

The database is PostgreSQL. Each module manages its own tables, identified by prefixes. We use UUIDs consistently for primary keys.

## 1. IAM Module
Owns user identity, roles, saved customer addresses, and refresh tokens.

- **`iam_users`**: 
  - `id` (UUID, PK), `email` (Varchar, Unique, Index), `password_hash` (Varchar, Not Null), `first_name` (Varchar), `last_name` (Varchar), `phone` (Varchar), `created_at` (Timestamp).
- **`iam_roles`**: 
  - `id` (UUID, PK), `name` (Varchar, Unique).
- **`iam_user_roles`**: 
  - `user_id` (UUID, FK to iam_users), `role_id` (UUID, FK to iam_roles). (Composite PK).
- **`iam_addresses`**: 
  - `id` (UUID, PK), `user_id` (UUID, FK to iam_users, Index), `recipient_name` (Varchar), `phone` (Varchar), `street` (Varchar), `city` (Varchar), `district` (Varchar), `ward` (Varchar), `is_default` (Boolean).
- **`iam_refresh_tokens`**: 
  - `id` (UUID, PK), `user_id` (UUID, FK to iam_users), `token_hash` (Varchar, Unique), `expires_at` (Timestamp, Not Null), `revoked` (Boolean, Default false).

## 2. Catalog Module
Owns categories, brands, products, variants, and product images.

- **`catalog_categories`**: 
  - `id` (UUID, PK), `name` (Varchar, Not Null), `slug` (Varchar, Unique, Index), `parent_id` (UUID, Nullable, FK to catalog_categories).
- **`catalog_brands`**: 
  - `id` (UUID, PK), `name` (Varchar, Not Null), `slug` (Varchar, Unique).
- **`catalog_products`**: 
  - `id` (UUID, PK), `brand_id` (UUID, FK to catalog_brands), `category_id` (UUID, FK to catalog_categories), `name` (Varchar, Not Null), `slug` (Varchar, Unique, Index), `description` (Text), `base_price` (Decimal, Not Null), `status` (Varchar: ACTIVE, DRAFT).
- **`catalog_product_variants`**: 
  - `id` (UUID, PK), `product_id` (UUID, FK to catalog_products, Index), `sku` (Varchar, Unique, Index), `size` (Varchar), `color` (Varchar), `price_override` (Decimal, Nullable).
- **`catalog_product_images`**: 
  - `id` (UUID, PK), `product_id` (UUID, FK to catalog_products), `minio_object_key` (Varchar, Not Null), `is_primary` (Boolean), `sort_order` (Integer).
- **`catalog_banners`**: 
  - `id` (UUID, PK), `title` (Varchar), `minio_object_key` (Varchar, Not Null), `target_url` (Varchar), `is_active` (Boolean).

## 3. Inventory Module
Owns current stock, reservations, and movement history.

- **`inventory_stock`**: 
  - `id` (UUID, PK), `variant_id` (UUID, Unique, Index), `available_quantity` (Integer, Not Null, Constraint >= 0).
- **`inventory_reservations`**: 
  - `id` (UUID, PK), `variant_id` (UUID, FK to inventory_stock), `order_id` (UUID, Index), `quantity` (Integer, Not Null), `expires_at` (Timestamp), `status` (Varchar: PENDING, CONFIRMED, CANCELLED).
- **`inventory_movements`**: 
  - `id` (UUID, PK), `variant_id` (UUID, Index), `quantity_change` (Integer), `reason` (Varchar: RESTOCK, ORDER_FULFILLMENT, ADJUSTMENT), `reference_id` (UUID, Nullable), `created_at` (Timestamp).

## 4. Sales Module
Owns carts (if persisted), orders, items, status history.

- **`sales_carts`** (Optional, Redis preferred for MVP, but defined if DB persistence is needed): 
  - `id` (UUID, PK), `user_id` (UUID, Unique, Nullable), `session_id` (Varchar, Unique, Nullable), `updated_at` (Timestamp).
- **`sales_cart_items`**: 
  - `id` (UUID, PK), `cart_id` (UUID, FK to sales_carts), `variant_id` (UUID), `quantity` (Integer).
- **`sales_orders`**: 
  - `id` (UUID, PK), `user_id` (UUID, Nullable, Index), `order_number` (Varchar, Unique, Index), `status` (Varchar: PENDING, PROCESSING, SHIPPING, DELIVERED, CANCELLED), `total_amount` (Decimal), `payment_method` (Varchar), `created_at` (Timestamp), `idempotency_key` (Varchar, Unique, Nullable).
- **`sales_order_addresses`**: 
  - `id` (UUID, PK), `order_id` (UUID, Unique, FK to sales_orders), `recipient_name` (Varchar), `phone` (Varchar), `street` (Varchar), `city` (Varchar), `district` (Varchar), `ward` (Varchar). *This is a snapshot, not an FK to iam_addresses.*
- **`sales_order_items`**: 
  - `id` (UUID, PK), `order_id` (UUID, FK to sales_orders), `variant_id` (UUID), `snapshot_sku` (Varchar), `snapshot_name` (Varchar), `snapshot_size` (Varchar), `snapshot_color` (Varchar), `unit_price` (Decimal), `quantity` (Integer), `subtotal` (Decimal).
- **`sales_order_status_history`**: 
  - `id` (UUID, PK), `order_id` (UUID, FK to sales_orders), `status` (Varchar), `note` (Varchar, Nullable), `created_at` (Timestamp), `created_by` (UUID, Nullable).

## 5. Cross-Cutting (Outbox & Idempotency)
- **`outbox_events`**: 
  - `id` (UUID, PK), `aggregate_type` (Varchar), `aggregate_id` (UUID), `event_type` (Varchar), `payload` (JSONB), `created_at` (Timestamp), `processed_at` (Timestamp, Nullable).
- **`idempotent_consumer_log`**: 
  - `event_id` (UUID, PK), `consumer_name` (Varchar, PK), `processed_at` (Timestamp). (Composite PK to track processed events per consumer).
