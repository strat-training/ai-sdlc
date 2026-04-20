# TaskFlow Project Rules

## Stack
- Backend: Node.js 20 LTS, Express 4, better-sqlite3, JWT (jsonwebtoken), bcrypt
- Frontend: React 18, Vite, React Router v6, Tailwind CSS, Axios
- Testing: Jest + Supertest (backend), Vitest + RTL (frontend)
- NO Redis, NO PostgreSQL, NO session-based auth in v1

## Coding Standards

### Backend
- All routes must use express-validator for input validation
- All errors must use standard format: { success: false, error: { code, message } }
- Never expose password_hash, reset_token, or reset_expires in API responses
- All database queries must use parameterized statements (no string concatenation)
- Use soft delete (is_deleted = 1) — never hard delete tasks
- Always check is_active = 1 when querying users for auth purposes

### Frontend
- Never mutate state directly — always use functional updates with setX(prev => ...)
- All API calls go through src/api/client.js — never use fetch() directly
- Token stored in localStorage as 'token', user as 'user' (JSON)
- All forms must show loading state while submitting
- All forms must show error messages returned from API

### Security
- Never log passwords, tokens, or PII to console in production paths
- Never commit .env files — use .env.example as template
- Rate limiting is applied on /api/auth/* routes

### Git
- Commit messages must reference task ID: "T-021: Implement POST /api/tasks"
- One task per commit where possible
- Do not commit node_modules, .env, or data/*.db files

## Role Permissions Reference
- admin: all actions on all resources
- team_lead: view all team tasks, all regular user actions
- user: create/edit own tasks, update status on assigned tasks, view own tasks only

## Quality Gates
- All endpoints must have at least one test before merge
- No PR merges with failing tests
- No hardcoded credentials or API keys in source code
