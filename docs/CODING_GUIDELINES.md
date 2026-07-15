# Socduacl - Coding Guidelines

## 1. Backend (Java / Spring Boot)
- **Formatting**: Use standard Google Java Style formatting.
- **Naming**:
  - Classes: `PascalCase`
  - Variables/Methods: `camelCase`
  - Constants: `UPPER_SNAKE_CASE`
  - Database Tables/Columns: `snake_case`
- **Structure**:
  - Group by feature/module, not by technical layer (e.g., `com.socduacl.catalog.product`, NOT `com.socduacl.controllers`).
- **Lombok**: Use `@Data`, `@Getter`, `@Setter`, `@Builder`, `@NoArgsConstructor`, `@AllArgsConstructor` to reduce boilerplate, but avoid `@Data` on JPA Entities due to `hashCode/equals` issues with lazy loading. Use `@Getter`/`@Setter` on Entities.
- **Validation**: Use `jakarta.validation.constraints` on DTOs. Never expose internal Entities directly via REST API. Use DTOs for Request and Response.

## 2. Frontend (TypeScript / Next.js)
- **Formatting**: Use Prettier and ESLint (standard rules).
- **Naming**:
  - Components: `PascalCase` (e.g., `ProductCard.tsx`)
  - Hooks: `camelCase` starting with `use` (e.g., `useCart.ts`)
  - Utility functions: `camelCase`
- **Components**:
  - Prefer functional components.
  - Define `Props` interface for every component.
  - Separate UI components (dumb) from container components (data fetching).
- **Types**:
  - Always use TypeScript interfaces or types. Avoid `any`.
  - Use Zod schemas to infer types for form data.

## 3. Git & Comments
- Comments should explain *why*, not *what*. Code should be self-documenting.
- English only for code, variables, and technical documentation. Vietnamese is strictly for UI text.
