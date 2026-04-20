# Architecture Decision Records
## TaskFlow

---

## ADR-001: SQLite over PostgreSQL for v1

**Date:** March 2026  
**Status:** Accepted  
**Deciders:** Solutions Architect, Tech Lead

### Context
TaskFlow v1 serves ~50 concurrent users (professional services firm, office hours only). We need a database that is reliable, easy to set up, and requires minimal operational overhead within the fixed-price engagement budget.

### Decision
Use SQLite (via `better-sqlite3`) instead of PostgreSQL.

### Rationale
| Factor | SQLite | PostgreSQL |
|--------|--------|-----------|
| Setup time | Zero — file-based | Requires separate server/RDS |
| Ops overhead | None | Backups, patching, monitoring |
| Concurrency | Sufficient for 50 users | Overkill for v1 |
| Cost | Free | RDS ~$30–50/month |
| Migration path | Export to PostgreSQL if needed | N/A |

SQLite handles up to ~1,000 concurrent writes and millions of reads — well beyond v1 requirements. Nightly S3 backup provides sufficient data protection.

### Consequences
- **Positive:** Faster setup, zero DB ops cost, simpler local development.
- **Negative:** Not suitable if v2 requires horizontal scaling or >1,000 concurrent users.
- **Migration trigger:** If concurrent users exceed 200 or v2 requires multi-region writes, migrate to RDS PostgreSQL. Migration path is straightforward (schema is already PostgreSQL-compatible SQL).

---

## ADR-002: JWT Stateless Authentication over Session-Based

**Date:** March 2026  
**Status:** Accepted  
**Deciders:** Solutions Architect

### Context
We need to authenticate API requests from the React SPA. Options are server-side sessions (with session store) or stateless JWT tokens.

### Decision
Use JWT (JSON Web Tokens) with 8-hour expiry stored in memory (not localStorage) on the client.

### Rationale
- No session store needed — reduces infrastructure dependencies.
- Stateless — works with future horizontal scaling.
- 8-hour expiry aligns with business hours use pattern.
- Simpler to implement within the engagement timeline.

### Consequences
- **Positive:** No session storage needed, simpler backend.
- **Negative:** Token revocation is not immediate — if a user is deactivated, their token remains valid until expiry (max 8 hours). Acceptable for v1 business risk.
- **Risk mitigation:** Admin deactivation checks `is_active` on every protected request.

---

## ADR-003: Monorepo Structure (Frontend + Backend in One Repo)

**Date:** March 2026  
**Status:** Accepted  
**Deciders:** Tech Lead

### Context
We're a small team building a tightly coupled frontend and backend. Decision: separate repos or monorepo?

### Decision
Single monorepo with `backend/` and `frontend/` directories.

### Rationale
- Single PR for full-stack changes (e.g., new API endpoint + UI that uses it).
- Shared `.env.example`, README, CI pipeline.
- Simpler for training — one repo to clone and run.
- No cross-repo dependency management.

### Structure
```
taskflow/
├── backend/        # Node.js/Express API
├── frontend/       # React + Vite SPA
├── docs/           # All project documentation
├── .claude/        # Claude Code rules and context
└── README.md
```

### Consequences
- **Positive:** Simpler developer experience, single source of truth.
- **Negative:** If teams grow independently, repo may need splitting. Acceptable for v1.

---

## ADR-004: Soft Delete over Hard Delete for Tasks

**Date:** March 2026  
**Status:** Accepted  
**Deciders:** Solutions Architect, Product Manager

### Context
Business Rule 3 (BRD): "Only the task creator or an admin can delete a task." The business also mentioned that deleted tasks may be needed for performance review purposes (BRD Section 2.2).

### Decision
Implement soft delete — set `is_deleted = 1` on the task record rather than removing the row from the database.

### Rationale
- Deleted tasks are retained for audit/reporting purposes (BRD requirement).
- Admin can potentially restore tasks if deleted in error (future feature).
- Prevents orphaned activity_log and comment records.
- No change to schema required for future undelete feature.

### Implementation
- All task queries include `WHERE is_deleted = 0` filter.
- DELETE endpoint sets `is_deleted = 1` and logs the action in `activity_log`.
- No UI to view deleted tasks in v1 — admin-only DB query if needed.

### Consequences
- **Positive:** Data retention, audit trail, safer deletions.
- **Negative:** DB grows over time with deleted records. Acceptable at v1 scale.
