# Socduacl Commerce - Project Context

*This document is the stable, long-term context for the Socduacl e-commerce platform. It provides high-level alignment for all AI agents. Do not update this file for routine task progress.*

## 1. Project Identity
- **Project Name**: Socduacl
- **Domain**: Men's fashion e-commerce and streetwear.
- **Target Users**: Young men looking for bold streetwear.
- **Brand Tone**: Urban, rebellious, playful, bold, street-inspired, energetic, premium.
- **Customer-Facing Language**: Vietnamese (e.g., "Đồ mới vừa đáp", "Chốt fit này").
- **Technical Language**: English (Code, DB, API, Documentation).

## 2. Product Scope
- **Customer Capabilities**: Browse products, filter by size/color, view details, manage guest/authenticated carts, checkout (COD only), view order status.
- **Admin Capabilities**: Manage categories, brands, products, variants, stock, upload MinIO images, update order statuses.
- **Explicit MVP Exclusions**: Online payments (Stripe/VNPay), advanced search (Elasticsearch), multi-language, complex promotions, social login, shipping carrier API integrations.

## 3. Required Technology Stack
- **Backend**: Java 21, Spring Boot 3, Spring Data JPA, Spring Security, Flyway.
- **Frontend**: Next.js (App Router), TypeScript, Tailwind CSS, TanStack Query, Zustand, Zod.
- **QA**: Python, Pytest, Playwright.
- **Infrastructure**: Docker Compose, PostgreSQL, Redis, RabbitMQ, MinIO.

## 4. Accepted Architecture
- **Modular Monolith**: Strict logical boundaries (`iam`, `catalog`, `sales`, `inventory`, `media`, `notification`). No cross-module DB joins.
- **Synchronous Checkout**: Validating cart, reserving/deducting stock, and creating the order happens in **one atomic database transaction** to prevent overselling.
- **Transactional Outbox**: Domain events (e.g., `OrderCreatedEvent`) are saved to an `outbox_events` table in the same transaction, then published asynchronously to RabbitMQ.
- **RabbitMQ**: Used strictly for non-critical async workflows (notifications, cache invalidation, audit).
- **Redis**: Transient state only (Guest carts, login rate limiting, checkout idempotency keys, catalog cache). Graceful degradation if unavailable.
- **MinIO**: Stores media. `socduacl-public` bucket has a public-read policy for fast frontend delivery. Uploads use backend-generated presigned URLs.
- **PostgreSQL**: The single source of truth for all critical business data.

## 5. Important Domain Rules
- **Product Variants**: Stock and pricing overrides exist at the *Variant* level (SKU, Size, Color), not just the base product.
- **Inventory Ownership**: Handled entirely by the `inventory` module.
- **Immutable Snapshots**: Order items and order shipping addresses must save snapshot data (name, price, text) at checkout time to prevent historical corruption.
- **Checkout Idempotency**: Required to prevent duplicate orders on client retries.
- **Payment Strategy**: Cash on Delivery (COD) is the *only* payment method for MVP.

## 6. AI Team Structure
- **Product Owner**: Human
- **Tech Lead**: Antigravity (Architecture, context, reviews).
- **Backend Developer**: IntelliJ (Spring Boot, APIs, Flyway).
- **Frontend Developer**: VS Code (Next.js, UI, Tailwind).
- **QA Automation**: PyCharm (Pytest, Playwright).
- **Integration/Release**: Devin (Docker, CI/CD, Scripts).

## 7. Directory Ownership
- `/docs/`, `/AGENTS.md`, `/CONTEXT.md`, `/CURRENT_STATE.md`: **Antigravity**
- `/backend/`: **IntelliJ**
- `/frontend/`: **VS Code**
- `/qa/`: **PyCharm**
- `/docker-compose.yml`, `/infrastructure/`, `/scripts/`, `/.github/`: **Devin**
- *Rule*: Agents are strictly forbidden from modifying files in another agent's directory without an explicit integration task.

## 8. Collaboration Rules
- Work in dedicated task branches (e.g., `task/tsk-002-backend-foundation`).
- Obey directory enforcement boundaries.
- No direct commits to `main`.
- Do not silently alter API/Event/DB contracts. Raise a block if missing.
- Provide a clear task completion report.
- Fail or report `BLOCKED` instead of hallucinating business rules.

## 9. Definition of Done Summary
- Code compiles and passes CI (no SonarQube criticals, ESLint passes).
- Unit/Integration tests pass. Code coverage maintained.
- Swagger/OpenAPI updated. Flyway migrations verified.
- Acceptance Criteria in `TASKS.md` fully met.

## 10. Context Maintenance Policy
- **DO NOT** update `CONTEXT.md` after every small task.
- Update this file *only* after major milestones, architecture pivots, or before moving to a new chat session.
- Routine progress tracking belongs in `CURRENT_STATE.md` and `docs/TASKS.md`.
