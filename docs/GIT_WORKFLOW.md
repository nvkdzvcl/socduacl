# Socduacl - Git Workflow

## 1. Branching Strategy
We use a lightweight feature-branch workflow.

- `main` - Production-ready state.
- `develop` - Integration branch for ongoing development.
- `feature/*` - New features (e.g., `feature/cart-management`).
- `bugfix/*` - Bug fixes (e.g., `bugfix/login-rate-limit`).
- `hotfix/*` - Emergency fixes for production.

## 2. Commit Conventions
Commits must follow Conventional Commits format to facilitate automated changelogs.

Format: `<type>(<scope>): <subject>`

Types:
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `test`: Adding missing tests or correcting existing tests
- `chore`: Changes to the build process or auxiliary tools

Example: `feat(catalog): add product variant schema`

## 3. Collaboration & Pull Requests
- All changes must go through a Pull Request (PR) targeting `develop`.
- PR titles must follow the commit convention.
- At least one code review (by Antigravity or a designated human reviewer) is required.
- CI pipelines must pass (build, tests, linting) before merging.
