# Socduacl

Socduacl is a bold Vietnamese streetwear fashion brand targeting young men. This repository contains the source code for the Socduacl e-commerce platform.

## Project Structure
- `docs/` - Architectural documentation and Sprint 0 planning.
- `backend/` - Spring Boot 3 modular monolith (Java 21).
- `frontend/` - Next.js App Router frontend application.
- `qa/` - End-to-end and integration tests (Python).

## Local Development
To run the project locally, you need Docker and Docker Compose installed.

1. Copy the environment variables:
   ```bash
   cp .env.example .env
   ```
2. Start the infrastructure (PostgreSQL, Redis, RabbitMQ, MinIO):
   ```bash
   docker-compose up -d
   ```
3. *(To be updated once backend/frontend apps are initialized)*

## Documentation
Please read the [Architecture Guide](docs/ARCHITECTURE.md) and [Product Requirements](docs/PRODUCT_REQUIREMENTS.md) before contributing.
