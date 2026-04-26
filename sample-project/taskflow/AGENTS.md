# TaskFlow — AGENTS.md

> **Cross-tool project rules.** This file is read by Claude Code, Cursor, Google
> Antigravity, and other AI coding tools that support the AGENTS.md cross-tool
> standard. Tool-specific overrides may live in CLAUDE.md (Claude Code),
> GEMINI.md (Antigravity), or .cursor/rules/ (Cursor) — but the rules below
> apply universally.

## Project

TaskFlow is a lightweight internal task management web application used as the
sample project for Stratpoint's AI Foundational Training. ~50 users.
Role-based access (user, team_lead, admin). Soft-delete model.

## Stack

- **Backend:** Node.js 20 LTS, Express 4, better-sqlite3, JWT (jsonwebtoken), bcrypt
- **Frontend:** React 18, Vite, React Router v6, Tailwind CSS, Axios
- **Testing:** Jest + Supertest (backend), Vitest + React Testing Library (frontend)
- **Forbidden in v1:** Redis, PostgreSQL, session-based auth, ORM

## Coding Standards

### Backend

- All routes must use express-validator for input validation.
- All errors must use the standard format: `{ success: false, error: { code, message } }`.
- Never expose `password_hash`, `reset_token`, or `reset_expires` in API responses.
- All database queries must use parameterized statements — no string concatenation.
- Use soft delete (`is_deleted = 1`) — never hard delete tasks.
- Always check `is_active = 1` when querying users for auth purposes.

### Frontend

- Never mutate state directly. Always use functional updates: `setX(prev => ...)`.
- All API calls go through `src/api/client.js` — never call `fetch()` directly.
- Token stored in `localStorage` as `token`, user as `user` (JSON).
- All forms must show loading state while submitting.
- All forms must show error messages returned from the API.

### Security

- Never log passwords, tokens, or PII to console in production paths.
- Never commit `.env` files — use `.env.example` as the template.
- Rate limiting is applied on `/api/auth/*` routes.

### Git

- Commit messages must reference the task ID: `T-021: Implement POST /api/tasks`.
- One task per commit where possible.
- Do not commit `node_modules`, `.env`, or `data/*.db` files.

## Role Permissions

| Role | Permissions |
|---|---|
| `admin` | All actions on all resources |
| `team_lead` | View all team tasks; all regular user actions |
| `user` | Create/edit own tasks; update status on assigned tasks; view own tasks only |

## Quality Gates

- All endpoints must have at least one test before merge.
- No PR merges with failing tests.
- No hardcoded credentials or API keys in source code.

## Working with AI on This Project

- Load relevant artifacts (PRD, Architecture Document, Dev Tasks) as context
  before starting any non-trivial task.
- Reference acceptance criteria by user story ID (US-01, US-02, …) when working
  on features.
- Reference task IDs (T-001, T-021, …) in commits and PR descriptions for
  traceability.
- Use the seed prompts in `knowledge/prompts/{role}/` as starting points; extend
  them and contribute back when you find improvements.
- For known bugs to practice on, see `docs/known-issues.md`.
- For deliberate teaching artifacts (planted bugs, poisoned-context examples),
  see `docs/training-props/`.

## Cross-tool File Layering

If a teammate is on a different AI tool, the rules in this file still apply.
Tool-specific overrides:

- **Claude Code** — `.claude/CLAUDE.md` may add Claude-Code-specific rules
  (subagent invocation patterns, slash commands, etc.).
- **Antigravity** — `GEMINI.md` may add Antigravity-specific rules (workflow
  triggers, agent autonomy preferences).
- **Cursor** — `.cursor/rules/*.mdc` may add Cursor-specific rules (rule types,
  file pattern attachments).

The cross-tool baseline (this file) wins on shared concerns. Tool-specific
files only override when there's a genuine tool-specific need.
