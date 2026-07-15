# Socduacl - Definition of Done (DoD)

A task or User Story is considered "Done" only when it meets all the following criteria:

## 1. Code Quality
- Code compiles and builds successfully locally and in CI.
- No critical or blocker issues reported by static analysis tools (e.g., SonarQube/ESLint).
- Follows the agreed-upon [Coding Guidelines](CODING_GUIDELINES.md).

## 2. Testing
- Unit tests are written and pass.
- Minimum acceptable code coverage (e.g., 80%) is maintained.
- Integration tests for critical API paths pass.

## 3. Documentation
- OpenAPI/Swagger documentation is updated for new or modified endpoints.
- Database schemas (Flyway) are accurately reflected in the migration scripts.
- README.md or related docs updated if infrastructure or setup instructions changed.

## 4. Functionality
- Acceptance Criteria defined in the task are fully met.
- The feature functions correctly in the local Docker Compose environment.
- No new UI/UX regressions on the frontend.

## 5. Review & Integration
- Code is reviewed and approved via Pull Request.
- Merged into the `develop` branch without conflicts.
- Verified by QA Automation (PyCharm agent) where applicable.
