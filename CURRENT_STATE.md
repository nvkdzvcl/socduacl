# Socduacl Commerce - Current State

*This is the short-lived operational handoff document reflecting the exact current repository state.*

## 1. Last Verified Date & Commit
- **Date**: 2026-07-16
- **Commit**: `a60751c` (Merge branch 'task/tsk-003-frontend-foundation')

## 2. Current Phase & Sprint
- **Phase**: MVP Execution
- **Sprint**: Sprint 1 (Infrastructure & Foundation)

## 3. Sprint 0 Gate Status
- **DONE**. Architecture, contracts, and backlog are fully formalized in `/docs`.

## 4. Current Runnable State
- **Docker Infrastructure**: Runnable.
- **Frontend**: Runnable (Boilerplate with Providers and Env validation wired up).
- **Backend**: Not started.

## 5. Existing Directories & Initialized Applications
- `/docs/`: Sprint 0 Architecture and Backlog.
- `/scripts/`: Infrastructure verification and MinIO setup scripts.
- `/frontend/`: Next.js App Router initialized (Tailwind, React Query, Zustand, Zod env).
- `docker-compose.yml`: Root infrastructure definitions.

## 6. Infrastructure Status
- **PostgreSQL**: Configured in docker-compose.
- **Redis**: Configured in docker-compose.
- **RabbitMQ**: Configured in docker-compose.
- **MinIO**: Configured in docker-compose with `minio-setup` auto-configuring the `socduacl-public` bucket.

## 7. Completed Tasks
- **TSK-001 (Devin)**: Initialize Local Infrastructure [DONE]
- **TSK-003 (VS Code)**: Frontend Next.js Foundation [DONE]

## 8. Active Tasks
- *None currently active. Moving to next chat.*

## 9. Tasks Approved to Start Next
- **TSK-002 (IntelliJ)**: Backend Spring Boot Foundation
  - *Branch*: `task/tsk-002-backend-foundation`
  - *Allowed Dirs*: `backend/`
  - *Dependencies*: TSK-001 (Completed)
  - *Validation*: Spring app boots and connects to DB via Flyway.

## 10. Tasks Blocked by Dependencies
- **TSK-004 (IntelliJ)**: Transactional Outbox Foundation (Blocked by TSK-002)

## 11. Current Branches
- `main`

## 12. Known Blockers
- None.

## 13. Known Documentation Inconsistencies
- None known.

## 14. Unresolved Product Owner Questions
1. **Admin Initial Access**: Should the first Admin user be seeded automatically via Flyway, or through a hidden bootstrap endpoint?
2. **Guest Cart Expiration**: Is a 7-day Redis TTL acceptable for guest carts, or do we require long-term PostgreSQL persistence?

## 15. Important Recent Decisions
- **Synchronous Checkout**: Atomic DB transaction to prevent overselling (ADR-0002).
- **Outbox Pattern**: Reliable domain event publishing to RabbitMQ (ADR-0003).
- **MinIO Access**: Presigned URLs for backend-free Admin uploads, but public-read for fast frontend delivery (ADR-0005).

## 16. Exact Next Execution Order
1. **IntelliJ** must claim and execute **TSK-002**.

## 17. Commands That Currently Work
- `docker-compose up -d`
- `cd frontend && npm run dev`

## 18. Expected But Not Yet Available Commands
- `./mvnw spring-boot:run` (Backend not initialized)
- `pytest` (QA not initialized)

## 19. Files a New Chat Should Read First
1. `CONTEXT.md`
2. `CURRENT_STATE.md`
3. `AGENTS.md`
4. `docs/TASKS.md`

---

## New Chat Bootstrap

*Product Owner: Copy and paste the text below into the new AI conversation to seamlessly resume development.*

```text
Hello Team! We are continuing the development of the Socduacl Commerce platform.

Please perform your startup sequence:
1. Read `CONTEXT.md` to understand the project architecture, boundaries, and rules.
2. Read `CURRENT_STATE.md` to understand exactly where we left off.
3. Read `AGENTS.md` to confirm your persona and directory ownership.
4. Inspect the latest repository state to verify the facts.
5. Do NOT assume any conversational history outside of what is written in the repository files.

We are currently in Sprint 1.
IntelliJ, your task is TSK-002 (Backend Spring Boot Foundation). 
Please review the requirements for TSK-002 in `docs/TASKS.md`, create the branch `task/tsk-002-backend-foundation`, and begin implementation. Let me know if you are blocked.
```
