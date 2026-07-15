# Socduacl - Module Boundaries

The backend is structured as a Modular Monolith. Modules must communicate via well-defined internal Java interfaces or asynchronously via RabbitMQ. Cross-module database queries (joins across module schemas) are strictly forbidden.

## 1. Modules

### `iam` (Identity & Access Management)
- **Responsibilities**: User registration, login, JWT issuance, token validation, role management, password hashing.
- **Entities**: User, Role.

### `catalog` (Product Catalog)
- **Responsibilities**: Categories, Brands, Products, Variants, Stock keeping.
- **Entities**: Category, Brand, Product, ProductVariant, ProductImage.

### `sales` (Orders & Cart)
- **Responsibilities**: Shopping cart operations, checkout processing, order creation, order status management.
- **Entities**: Order, OrderItem, DeliveryAddress.

### `inventory` (Stock Management)
- **Responsibilities**: Deducting stock upon order creation, restocking upon order cancellation, tracking low stock. Listens to sales events.
- **Entities**: InventoryTransaction.

### `media` (Storage)
- **Responsibilities**: Interacting with MinIO, generating presigned URLs, validating file types and sizes.

### `notification` (System Notifications)
- **Responsibilities**: Sending emails or system alerts based on events (e.g., Order Created).

## 2. Interaction Rules
- **Synchronous**: Modules may call each other synchronously via internal `@Service` interfaces only if an immediate response is required (e.g., `Sales` checking `Catalog` for current price and stock before checkout).
- **Asynchronous**: For non-blocking workflows, modules emit events to RabbitMQ (e.g., `Sales` emits `OrderCreatedEvent`, which `Inventory` and `Notification` consume).
- **Data Isolation**: Each module has its own Flyway migration scripts and ideally its own database schema or specific table prefixes (e.g., `iam_users`, `catalog_products`). No direct `@OneToMany` entity mappings across modules.
