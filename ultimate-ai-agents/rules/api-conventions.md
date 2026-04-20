---
paths:
  - "src/api/**/*.ts"
  - "src/handlers/**/*.ts"
  - "src/server/**/*.ts"
  - "app/api/**/*.ts"
---

# API Design Rules

- All handlers return `{ data, error }` shape
- Use Zod for request body validation on every endpoint
- Never expose internal error details to clients
- Use tRPC for type-safe API routes
- Implement proper error codes and messages
- Rate limit public endpoints
- Validate and sanitize all user input
