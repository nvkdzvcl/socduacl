# Socduacl - Product Requirements

## 1. Project Overview
**Project Name**: Socduacl
**Business Domain**: Men's fashion e-commerce and streetwear.
**Brand Identity**: A bold Vietnamese streetwear fashion brand targeting young men.
**Visual & Content Style**: Urban, rebellious, playful, bold, street-inspired, youthful, energetic, slightly provocative but not offensive, premium.
**Customer-facing Language**: Vietnamese.
**Technical Language**: English (source code, classes, database, API, documentation).

## 2. Brand Tone (Vietnamese Examples)
- "Đồ mới vừa đáp." (New arrivals just landed)
- "Mặc chất, khỏi cần nói nhiều." (Dress dope, no need to say much)
- "Lên đồ rồi xuống phố." (Dress up and hit the streets)
- "Quăng vào giỏ." (Toss into cart)
- "Chốt fit này." (Lock in this fit)

*Constraint*: Do not overuse slang in critical flows (checkout, payments, auth errors, policies). These must remain clear.

## 3. Business Capabilities

### Customer
- Browse products, categories, and collections.
- Search products.
- Filter by category, price, size, color, and availability.
- View product details.
- Select size and color variants.
- Add products to cart.
- Update cart quantities.
- Register and log in.
- Manage delivery addresses.
- Checkout using Cash on Delivery (COD) for MVP.
- View order history and order status.

### Administrator
- Manage categories and brands.
- Manage products and product variants.
- Manage size, color, SKU, and stock.
- Upload and manage product images (MinIO).
- Manage orders and update order statuses.
- View basic sales and inventory information.

## 4. Product Model Requirements
- A **Product** can have multiple **Variants**.
- Each **Variant** has its own SKU, size, color, price, and stock quantity.
- Product images are stored in **MinIO**.
- PostgreSQL stores MinIO object keys and metadata (not binary data).
- **Order Items** must store a snapshot of product name, SKU, size, color, and unit price at the time of purchase.
