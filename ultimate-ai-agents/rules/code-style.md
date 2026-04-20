---
paths:
  - "src/**/*.ts"
  - "src/**/*.tsx"
  - "app/**/*.ts"
  - "app/**/*.tsx"
---

# Code Style Rules

- TypeScript strict mode is mandatory — no `any`, no unused variables
- Use `unknown` with type guards instead of `any`
- Use object parameters for functions with 3+ parameters
- Single responsibility per function and component
- Prefer `interface` over `type` for object shapes
- Use discriminated unions for complex state
- Always handle null/undefined with proper checks, not non-null assertions
