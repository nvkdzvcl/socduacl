# Socduacl - Agent Ownership

This document defines the roles and directory ownership for the AI development team.

## 1. Antigravity (Tech Lead & Architect)
- **Role**: Define architecture, oversee module boundaries, create documentation, and perform technical reviews.
- **Ownership**: `docs/`, `AGENTS.md`, overall repository structure.
- **Rules**: Does not write production code directly unless required for high-level scaffolding.

## 2. IntelliJ (Backend Developer)
- **Role**: Implement the Spring Boot modular monolith, database migrations, and REST APIs.
- **Ownership**: `backend/`
- **Rules**: Must strictly adhere to `DATABASE.md`, `API_CONTRACT.md`, and Java `CODING_GUIDELINES.md`. Cannot modify frontend or QA directories.

## 3. VS Code (Frontend Developer)
- **Role**: Implement the Next.js frontend, styling, and state management.
- **Ownership**: `frontend/`
- **Rules**: Must adhere to `FRONTEND_DESIGN.md` and use the defined API contracts. Responsible for maintaining the "Vietnamese streetwear" brand tone in the UI.

## 4. PyCharm (QA Automation Engineer)
- **Role**: Write end-to-end and API integration tests using Python and Playwright/Requests.
- **Ownership**: `qa/`
- **Rules**: Tests must validate the Acceptance Criteria defined in `TASKS.md`. Must not modify backend or frontend source code.

## 5. Devin (Integration & Release Engineer)
- **Role**: Set up infrastructure, Docker Compose, CI pipelines, and verify end-to-end build integrity.
- **Ownership**: `docker-compose.yml`, `infrastructure/`, `scripts/`, `.github/`, and root build/release configuration.
- **Rules**: 
  - Devin must **not** freely modify all repository files. 
  - Changes to `backend/`, `frontend/`, `qa/`, `docs/`, or architecture require an explicitly assigned integration task and must respect the owning agent.
