# Socduacl - Technical & Product Risks

## 1. Technical Risks

### Concurrent Inventory Updates (Race Conditions)
- **Risk**: High traffic during a product drop ("hype" items) could lead to overselling if inventory checks and deductions are not atomic.
- **Mitigation**: Use database-level row locks (`SELECT ... FOR UPDATE`), optimistic locking (`@Version` in JPA), or Redis-based distributed locks during checkout.

### Multi-Agent Coordination
- **Risk**: Different AI agents (IntelliJ, VS Code, PyCharm, Devin) might step on each other's toes or misinterpret interface contracts, causing integration failures.
- **Mitigation**: Strictly enforce API-first design. Backend and Frontend must agree on the Swagger definitions before implementation. Devin (Integration Engineer) oversees end-to-end builds.

### Local Resource Limits
- **Risk**: Running PostgreSQL, Redis, RabbitMQ, MinIO, Backend, and Frontend simultaneously via Docker Compose may consume significant CPU and RAM, causing local environments to crash or slow down.
- **Mitigation**: Define resource limits in `docker-compose.yml`. Use lightweight Alpine images where possible.

## 2. Product Risks

### Scope Creep
- **Risk**: The MVP scope is extended with new payment gateways or complex promotion rules before launch.
- **Mitigation**: Strictly adhere to `MVP_SCOPE.md`. Defer all out-of-scope requests to V2.

### Brand Tone Interpretation
- **Risk**: AI generating frontend copy or error messages might revert to formal Vietnamese, breaking the required "streetwear" brand identity.
- **Mitigation**: Frontend Developer (VS Code agent) must use predefined string resources or strictly follow the `FRONTEND_DESIGN.md` tone guide. Human PO review is required for UI text.
