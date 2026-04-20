# TaskFlow Coding Standards Rules

These rules are loaded into Claude Code via `.claude/CLAUDE.md`. Documented here with rationale.

---

## Backend Rules

**Rule:** All routes must use express-validator for input validation.
**Rationale:** Prevents SQL injection and invalid data reaching the database. Standardizes error responses.
**How to verify:** Check that every route handler calls `validationResult(req)` before processing.

---

**Rule:** All errors must use format: `{ success: false, error: { code, message } }`.
**Rationale:** Frontend relies on `error.code` for conditional handling. Inconsistent formats break error display.
**How to verify:** Search for `res.status(4` — every one should use this format.

---

**Rule:** Never expose `password_hash`, `reset_token`, or `reset_expires` in API responses.
**Rationale:** Security. These fields exist in the users table and will appear if you do `SELECT *`.
**How to verify:** Grep for `password_hash` in route files — should only appear in auth comparisons, never in responses.

---

**Rule:** All DB queries must use parameterized statements — no string concatenation.
**Rationale:** SQL injection prevention. SQLite with better-sqlite3 supports `?` placeholders natively.
**How to verify:** Grep for backtick template literals inside `db.prepare(` calls.

---

**Rule:** Use soft delete (`is_deleted = 1`) — never hard delete tasks.
**Rationale:** Audit trail and data recovery. Hard deletes also break foreign key references in activity_log.
**How to verify:** No `DELETE FROM tasks` should exist outside test cleanup.

---

## Frontend Rules

**Rule:** Never mutate state directly — use functional updates (`setX(prev => ...)`).
**Rationale:** React uses referential equality for change detection. Direct mutation causes missed re-renders.
**How to verify:** Search for patterns like `array[index].field = value` followed by `setState(array)`.

---

**Rule:** All API calls go through `src/api/client.js` — never use `fetch()` directly.
**Rationale:** Centralizes auth token injection, base URL config, and error handling.
**How to verify:** Grep for `fetch(` in `src/` — should return zero results.

---

## Security Rules

**Rule:** Never log passwords, tokens, or PII to console in production paths.
**Rationale:** Logs are often shipped to external systems. Credentials in logs = credentials exposed.
**How to verify:** Grep for `console.log` in route files — review every match.

---

**Rule:** Never commit `.env` files — use `.env.example` as template.
**Rationale:** `.env` contains real credentials. `.env.example` shows structure without values.
**How to verify:** Check `.gitignore` includes `.env`. Check repo history has no `.env` commits.
