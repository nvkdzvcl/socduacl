# Socduacl - Implementation Tasks (MVP Backlog)

This document contains the complete MVP backlog.
Time estimate per task: 30 minutes to 4 hours.

## Sprint 1: Infrastructure & Foundation

### TSK-001: Initialize Local Infrastructure
- **Sprint**: 1
- **Owner**: Devin
- **Reviewer**: Antigravity
- **Objective**: Set up `docker-compose.yml` and `minio-setup` script.
- **Allowed Directories**: `/`, `infrastructure/`, `scripts/`
- **Dependencies**: None
- **Implementation Notes**: Expose Postgres (5432), Redis (6379), RabbitMQ (5672, 15672), MinIO (9000, 9001). Create `minio-setup` container to auto-create `socduacl-public` bucket with public-read policy.
- **Acceptance Criteria**: `docker-compose up` starts all services. MinIO bucket is accessible publicly.
- **Required Tests**: Bash script pinging ports and checking MinIO bucket policy.
- **Expected Output**: `docker-compose.yml`, `scripts/minio_setup.sh`.

### TSK-002: Backend Spring Boot Foundation
- **Sprint**: 1
- **Owner**: IntelliJ
- **Reviewer**: Antigravity
- **Objective**: Bootstrap modular monolith, add core dependencies, configure Flyway.
- **Allowed Directories**: `backend/`
- **Dependencies**: TSK-001
- **Implementation Notes**: Java 21, Spring Boot 3. Web, Data JPA, Security, Validation, AMQP, Data Redis, Flyway. Setup packages for IAM, Catalog, Sales, Inventory.
- **Acceptance Criteria**: App starts, connects to DB, Flyway baseline runs. Swagger available at `/api/v1/swagger-ui.html`.
- **Required Tests**: Spring context load test.
- **Expected Output**: `pom.xml`, `Application.java`, `application.yml`.

### TSK-003: Frontend Next.js Foundation
- **Sprint**: 1
- **Owner**: VS Code
- **Reviewer**: Antigravity
- **Objective**: Bootstrap App Router, Tailwind, Zustand, TanStack Query.
- **Allowed Directories**: `frontend/`
- **Dependencies**: None
- **Implementation Notes**: Next 14/15. Configure tailwind theme with brand colors. Set up basic layouts.
- **Acceptance Criteria**: App runs on port 3000. Next font (e.g. Inter) loaded.
- **Required Tests**: None.
- **Expected Output**: `package.json`, `tailwind.config.ts`, `app/layout.tsx`.

### TSK-004: Transactional Outbox Foundation
- **Sprint**: 1
- **Owner**: IntelliJ
- **Reviewer**: Antigravity
- **Objective**: Implement Outbox pattern core entity and scheduler.
- **Allowed Directories**: `backend/src/main/java/.../common/outbox/`, `backend/src/main/resources/db/migration/`
- **Dependencies**: TSK-002
- **Implementation Notes**: Flyway script for `outbox_events` and `idempotent_consumer_log`. Create `@Scheduled` publisher to RabbitMQ `socduacl.topic`.
- **Acceptance Criteria**: Outbox poller runs. Saving an event to DB publishes it to RabbitMQ and marks `processed_at`.
- **Required Tests**: Outbox publisher integration test.
- **Expected Output**: `OutboxEvent` entity, `OutboxPublisher` component.

## Sprint 2: IAM & Authentication

### TSK-005: IAM Schema and Auth API
- **Sprint**: 2
- **Owner**: IntelliJ
- **Reviewer**: Antigravity
- **Objective**: Implement user schema, registration, and login.
- **Allowed Directories**: `backend/.../iam/`
- **Dependencies**: TSK-002
- **Implementation Notes**: `iam_users`, `iam_roles`. JWT generation. BCrypt. Endpoints: `POST /auth/register`, `POST /auth/login`. Rate limiting via Redis for login.
- **Acceptance Criteria**: Users can register and login. Passwords hashed. JWT returned. Rate limit blocks >5 attempts/15min.
- **Required Tests**: MockMvc for auth endpoints.
- **Expected Output**: Controllers, Services, Security Config.

### TSK-006: User Addresses and Profile
- **Sprint**: 2
- **Owner**: IntelliJ
- **Reviewer**: VS Code
- **Objective**: Manage customer addresses.
- **Allowed Directories**: `backend/.../iam/`
- **Dependencies**: TSK-005
- **Implementation Notes**: Schema `iam_addresses`. CRUD endpoints under `/account/addresses`.
- **Acceptance Criteria**: Authenticated user can save and list delivery addresses.
- **Required Tests**: Unit and integration tests for address CRUD.
- **Expected Output**: API endpoints for addresses.

## Sprint 3: Catalog & Inventory (Admin)

### TSK-007: Catalog Schema & Admin API
- **Sprint**: 3
- **Owner**: IntelliJ
- **Reviewer**: Antigravity
- **Objective**: Admin endpoints for Categories, Brands, Products, Variants.
- **Allowed Directories**: `backend/.../catalog/`
- **Dependencies**: TSK-002, TSK-005
- **Implementation Notes**: Flyway `catalog_` tables. Admin-only endpoints. No image logic yet.
- **Acceptance Criteria**: Admin can create a Product and its Variants (Size/Color/SKU).
- **Required Tests**: Admin role access tests.
- **Expected Output**: Catalog entities, repositories, admin controllers.

### TSK-008: MinIO Presigned URL Flow
- **Sprint**: 3
- **Owner**: IntelliJ
- **Reviewer**: Devin
- **Objective**: Implement secure MinIO upload flow.
- **Allowed Directories**: `backend/.../media/`, `backend/.../catalog/`
- **Dependencies**: TSK-007
- **Implementation Notes**: `POST /admin/media/presigned-url`. `POST /admin/products/{id}/images`. Save metadata to `catalog_product_images`.
- **Acceptance Criteria**: Admin gets presigned URL, confirms upload, DB saves object key.
- **Required Tests**: Mock S3 client tests.
- **Expected Output**: MediaService, MediaController.

### TSK-009: Inventory Management Foundation
- **Sprint**: 3
- **Owner**: IntelliJ
- **Reviewer**: Antigravity
- **Objective**: Schema and Admin API for Stock tracking.
- **Allowed Directories**: `backend/.../inventory/`
- **Dependencies**: TSK-007
- **Implementation Notes**: `inventory_stock`, `inventory_movements`. `POST /admin/inventory/adjust`.
- **Acceptance Criteria**: Admin can adjust stock for a variant. Movement history recorded.
- **Required Tests**: Concurrency tests for stock adjustment.
- **Expected Output**: Inventory entities and services.

## Sprint 4: Shopping Experience

### TSK-010: Catalog Public API & Caching
- **Sprint**: 4
- **Owner**: IntelliJ
- **Reviewer**: VS Code
- **Objective**: Public product endpoints with Redis caching.
- **Allowed Directories**: `backend/.../catalog/`
- **Dependencies**: TSK-007
- **Implementation Notes**: Paginated `GET /products` with filters. `GET /products/{slug}`. Cache results in Redis.
- **Acceptance Criteria**: Products searchable by size, category, price. Results cached.
- **Required Tests**: Cache hit/miss tests.
- **Expected Output**: Public CatalogController.

### TSK-011: Redis Guest Cart API
- **Sprint**: 4
- **Owner**: IntelliJ
- **Reviewer**: VS Code
- **Objective**: Manage shopping cart in Redis.
- **Allowed Directories**: `backend/.../sales/`
- **Dependencies**: TSK-010
- **Implementation Notes**: Read/Write `cart:guest:{sessionId}`. If user logged in, use `cart:user:{userId}` (also in Redis for MVP).
- **Acceptance Criteria**: Add/update/delete items from cart. Cart TTL extends on action.
- **Required Tests**: Redis cart integration tests.
- **Expected Output**: CartController, CartService.

## Sprint 5: Checkout & Orders

### TSK-012: Synchronous Checkout Core
- **Sprint**: 5
- **Owner**: IntelliJ
- **Reviewer**: Antigravity
- **Objective**: Implement COD checkout workflow with idempotency.
- **Allowed Directories**: `backend/.../sales/`, `backend/.../inventory/`
- **Dependencies**: TSK-009, TSK-011
- **Implementation Notes**: `POST /checkout`. Check idempotency key in Redis. Open transaction -> check stock -> deduct stock -> create order -> write Outbox event -> commit.
- **Acceptance Criteria**: Order created successfully. Stock deducted. Duplicate requests rejected. Out-of-stock fails cleanly.
- **Required Tests**: Transaction rollback test on stock failure. Idempotency test.
- **Expected Output**: CheckoutService.

### TSK-013: Order Management API
- **Sprint**: 5
- **Owner**: IntelliJ
- **Reviewer**: VS Code
- **Objective**: User order history and Admin status updates.
- **Allowed Directories**: `backend/.../sales/`
- **Dependencies**: TSK-012
- **Implementation Notes**: `GET /orders`, `PATCH /admin/orders/{id}/status`. Handle cancellation stock release.
- **Acceptance Criteria**: Users view history. Admin updates status. Cancelled orders restore stock.
- **Required Tests**: Status transition validation.
- **Expected Output**: OrderController.

## Sprint 6: Storefront UI

### TSK-014: Frontend Storefront Pages
- **Sprint**: 6
- **Owner**: VS Code
- **Reviewer**: IntelliJ
- **Objective**: Build Home, Shop, and Product Details pages.
- **Allowed Directories**: `frontend/`
- **Dependencies**: TSK-003, TSK-010
- **Implementation Notes**: Implement brand tone. Fetch data via React Query. Integrate Zustand for mobile menu. Use public MinIO URLs.
- **Acceptance Criteria**: User can browse products and view details cleanly.
- **Required Tests**: None (UI visual verification).
- **Expected Output**: Next.js pages and components.

### TSK-015: Frontend Cart & Checkout Flow
- **Sprint**: 6
- **Owner**: VS Code
- **Reviewer**: IntelliJ
- **Objective**: Build Cart UI and Checkout address form.
- **Allowed Directories**: `frontend/`
- **Dependencies**: TSK-011, TSK-012, TSK-014
- **Implementation Notes**: Cart slide-over or page. Checkout form with React Hook Form + Zod. Send `Idempotency-Key` header.
- **Acceptance Criteria**: User can add to cart, fill address, and submit COD order.
- **Required Tests**: Client-side validation logic tests.
- **Expected Output**: Cart and Checkout components.

## Sprint 7: Admin UI

### TSK-016: Frontend Admin Dashboard
- **Sprint**: 7
- **Owner**: VS Code
- **Reviewer**: Antigravity
- **Objective**: Build Admin UI for Catalog and Orders.
- **Allowed Directories**: `frontend/`
- **Dependencies**: TSK-008, TSK-013
- **Implementation Notes**: Protected route `/admin`. Product CRUD. Direct MinIO upload via presigned URL.
- **Acceptance Criteria**: Admin can upload images, create variants, and process orders.
- **Required Tests**: None.
- **Expected Output**: Admin pages.

## Sprint 8: QA & Release

### TSK-017: API Automation Tests
- **Sprint**: 8
- **Owner**: PyCharm
- **Reviewer**: IntelliJ
- **Objective**: Write Pytest/Requests suite for core API flows.
- **Allowed Directories**: `qa/`
- **Dependencies**: TSK-013
- **Implementation Notes**: Test Registration -> Login -> Add Cart -> Checkout.
- **Acceptance Criteria**: Test suite passes against local backend.
- **Required Tests**: End-to-end API tests.
- **Expected Output**: `qa/tests/api/`.

### TSK-018: Playwright E2E Tests
- **Sprint**: 8
- **Owner**: PyCharm
- **Reviewer**: VS Code
- **Objective**: Write UI tests for critical user journeys.
- **Allowed Directories**: `qa/`
- **Dependencies**: TSK-015, TSK-016
- **Implementation Notes**: Automate browser checkout flow.
- **Acceptance Criteria**: Playwright tests pass against local frontend/backend.
- **Required Tests**: UI E2E tests.
- **Expected Output**: `qa/tests/ui/`.

### TSK-019: CI Pipeline & Integration Verification
- **Sprint**: 8
- **Owner**: Devin
- **Reviewer**: Antigravity
- **Objective**: Setup GitHub Actions to run tests and build.
- **Allowed Directories**: `.github/`
- **Dependencies**: TSK-017, TSK-018
- **Implementation Notes**: Job to build backend, build frontend, run Pytest APIs, run Playwright.
- **Acceptance Criteria**: PRs to `main` and `develop` trigger CI. CI passes.
- **Required Tests**: CI execution.
- **Expected Output**: `.github/workflows/ci.yml`.
