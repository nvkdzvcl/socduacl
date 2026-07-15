# Socduacl - Security Guidelines

## 1. Authentication
- **Method**: JSON Web Tokens (JWT).
- **Header**: `Authorization: Bearer <token>`
- **Token Claims**:
  - `sub`: User ID (UUID).
  - `email`: User's email.
  - `roles`: Array of strings (e.g., `["ROLE_USER"]`).
  - `exp`: Expiration time (e.g., 2 hours).

## 2. Authorization (Role-Based Access Control)
- **`ROLE_USER`**: Can access own profile, own orders, and perform checkout.
- **`ROLE_ADMIN`**: Can access catalog management, order management, and all user data.
- **Public**: Endpoints like `/api/v1/products`, `/api/v1/categories`, and `/api/v1/auth/` do not require a token.

## 3. Password Management
- Passwords must be hashed using **BCrypt** with a strength/cost of at least 10.
- Raw passwords must never be logged or stored.

## 4. CORS (Cross-Origin Resource Sharing)
- Spring Security must be configured to allow CORS from the specific frontend domains (e.g., `http://localhost:3000` for local development).
- Allowed methods: `GET, POST, PUT, PATCH, DELETE, OPTIONS`.
- Allowed headers: `Authorization, Content-Type, Accept`.

## 5. Vulnerability Protection
- **SQL Injection**: Prevented by using Spring Data JPA and Hibernate (parameterized queries).
- **XSS**: Frontend (React/Next.js) automatically escapes content. Backend must validate incoming payload lengths and formats.
- **CSRF**: Since JWT is used (stateless authentication) and not cookies, CSRF protection can generally be disabled in Spring Security, provided tokens are not stored in cookies that are automatically sent by the browser. If HTTP-only cookies are used for JWT later, CSRF must be enabled.
