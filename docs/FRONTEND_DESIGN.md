# Socduacl - Frontend Design

## 1. Information Architecture
The frontend is built with Next.js (App Router).

### Public Routes
- `/` - Home (Hero banner, featured collections, "Đồ mới vừa đáp").
- `/shop` - Product Listing (Filters: Category, Price, Size).
- `/product/[slug]` - Product Details (Images, Size/Color selection, Add to Cart).
- `/cart` - Shopping Cart review.
- `/checkout` - Address input and COD confirmation.
- `/login`, `/register` - Authentication.

### Protected Routes (Customer)
- `/account` - Dashboard.
- `/account/orders` - Order history.
- `/account/orders/[id]` - Order status.

### Admin Routes
- `/admin` - Dashboard summary.
- `/admin/products`, `/admin/products/new` - Catalog management.
- `/admin/orders` - Order fulfillment.

## 2. Design Direction & Brand Tone
- **Aesthetic**: Urban, rebellious, minimalist but bold. Dark mode or high-contrast monochromatic themes with a strong accent color (e.g., neon green or bright orange).
- **Typography**: Sans-serif, bold, geometric fonts (e.g., Inter, Roboto, or custom web fonts) for headings.
- **Copywriting**: Use the specified Vietnamese street tone:
  - "Quăng vào giỏ" instead of "Thêm vào giỏ hàng".
  - "Chốt fit này" instead of "Thanh toán".
- **Visuals**: Large, high-quality images. Edge-to-edge designs.

## 3. Technology & State Management
- **Framework**: Next.js App Router (`app/`).
- **Styling**: Tailwind CSS.
- **Server State**: TanStack Query (React Query) for fetching, caching, and updating API data.
- **Client State**: Zustand for global UI state (e.g., mobile menu toggle, temporary cart state before sync).
- **Forms**: React Hook Form coupled with Zod for schema validation.
