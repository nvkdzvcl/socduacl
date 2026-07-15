# Socduacl - Implementation Tasks

Below is the initial breakdown of tasks for Sprint 1 execution. 
*Note: Each task represents approximately 30m to 4h of focused work.*

## Task 1: Initialize Local Infrastructure
- **ID**: TSK-001
- **Owner**: Devin (Integration & Release Engineer)
- **Objective**: Set up `docker-compose.yml` to run PostgreSQL, Redis, RabbitMQ, and MinIO.
- **Allowed Directories**: `/`
- **Dependencies**: None
- **Implementation Notes**: Expose standard ports. Include `.env` mapping. Use lightweight images.
- **Acceptance Criteria**: All 4 services start successfully. Databases/queues are accessible from host.
- **Required Tests**: Bash script testing ping/connection to all 4 ports.
- **Expected Output**: `docker-compose.yml`, updated `README.md`.

## Task 2: Initialize Backend Spring Boot Project
- **ID**: TSK-002
- **Owner**: IntelliJ (Backend Developer)
- **Objective**: Bootstrap the Spring Boot 3 modular monolith structure.
- **Allowed Directories**: `backend/`
- **Dependencies**: TSK-001
- **Implementation Notes**: Use Maven. Add dependencies: Web, Data JPA, Security, Flyway, PostgreSQL Driver, Validation, AMQP, Data Redis. Create module packages: `iam`, `catalog`, `sales`, `inventory`, `media`, `notification`.
- **Acceptance Criteria**: App compiles and starts successfully. Connects to local PostgreSQL. Swagger UI is available at `/swagger-ui.html`.
- **Required Tests**: Application Context Load Test.
- **Expected Output**: `pom.xml`, `Application.java`, basic package structure, `application.yml`.

## Task 3: Initialize Frontend Next.js Project
- **ID**: TSK-003
- **Owner**: VS Code (Frontend Developer)
- **Objective**: Bootstrap the Next.js App Router project with Tailwind CSS.
- **Allowed Directories**: `frontend/`
- **Dependencies**: None
- **Implementation Notes**: Use `npx create-next-app@latest`. Configure Tailwind. Set up basic folder structure for components, hooks, lib, store. Install Zustand and React Query.
- **Acceptance Criteria**: App compiles and runs on port 3000. Tailwind styles are applied.
- **Required Tests**: None (setup only).
- **Expected Output**: Next.js project files, `tailwind.config.ts`, `package.json`.

## Task 4: IAM Database Migrations and Entities
- **ID**: TSK-004
- **Owner**: IntelliJ (Backend Developer)
- **Objective**: Create Flyway migrations and JPA Entities for Users and Roles.
- **Allowed Directories**: `backend/src/main/resources/db/migration`, `backend/src/main/java/.../iam/`
- **Dependencies**: TSK-002
- **Implementation Notes**: Create `V1__init_iam.sql`. Create `User` and `Role` entities. Set up Spring Data Repositories.
- **Acceptance Criteria**: Flyway executes successfully on startup. Tables `iam_users`, `iam_roles`, `iam_user_roles` exist.
- **Required Tests**: Repository save/find unit tests using Testcontainers or H2.
- **Expected Output**: SQL migration file, JPA Entities, Repositories.

## Task 5: IAM Registration and Login API
- **ID**: TSK-005
- **Owner**: IntelliJ (Backend Developer)
- **Objective**: Implement JWT-based auth endpoints (`/api/v1/auth/register`, `/api/v1/auth/login`).
- **Allowed Directories**: `backend/src/main/java/.../iam/`
- **Dependencies**: TSK-004
- **Implementation Notes**: Configure Spring Security. Implement JWT generation/validation. Hash passwords using BCrypt.
- **Acceptance Criteria**: User can register. Login returns a valid JWT. Accessing a secured mock endpoint with JWT succeeds.
- **Required Tests**: MockMvc tests for register (200, 400) and login (200, 401).
- **Expected Output**: AuthController, AuthService, JwtUtil, SecurityConfig.

*(Further tasks for Catalog, Sales, UI implementation, and QA automation will follow this pattern).*
