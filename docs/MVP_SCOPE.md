# Socduacl - MVP Scope

## 1. In Scope for MVP

The Minimum Viable Product (MVP) focuses on launching the core e-commerce flow for the brand, allowing customers to browse, add to cart, and checkout using Cash on Delivery (COD).

### Customer Features
- **Authentication**: JWT-based email/password registration and login.
- **Browsing**: Home page with latest collections, product listing page with basic filters (category, price, size, color), and product details.
- **Cart**: Guest cart (Redis-backed) and authenticated cart.
- **Checkout**: Cash on Delivery (COD) only. Address management during checkout.
- **Order Management**: View order history and order status (Pending, Processing, Shipping, Delivered, Cancelled).

### Admin Features
- **Catalog Management**: CRUD operations for Categories, Brands, Products, and Product Variants (SKU, Size, Color, Price, Stock).
- **Media Management**: Upload product images via MinIO.
- **Order Management**: View orders and update their statuses.
- **Basic Dashboard**: View total orders and current low stock.

## 2. Explicitly Out of Scope for MVP
- **Online Payments**: Stripe, VNPay, Momo, PayPal, etc., are excluded for the MVP.
- **Complex Search**: No Elasticsearch or AI-based recommendations. Simple database text search only.
- **Multi-language / Multi-currency**: Only Vietnamese language and VND currency.
- **Promotions / Discount Codes**: Vouchers and complex discount engines.
- **Loyalty Programs**: Points, tiers, or rewards.
- **Social Login**: Google, Facebook, Apple login.
- **Advanced Shipping Integration**: Direct API integration with GHTK, Viettel Post, etc. (Shipping status is manually updated by admin).
- **Microservices Architecture**: The system must be a modular monolith.
