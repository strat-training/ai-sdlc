# Agents Reference

The TaskFlow training project includes a simple sample agent (`code-reviewer.md`) for training purposes.

For **real client projects**, use the professional agents from the shared agent library:

```
/Users/ronalddelacruz/Training/ai-sdlc/ultimate-ai-agents/
```

Or install them into any project via the library's install script.

---

## SDLC-Mapped Agent Reference

The table below maps each SDLC phase to the professional agents best suited for that work.

### Phase 1 — Requirements

| Agent | Path | Use for |
|-------|------|---------|
| `business-analyst` | `agents/claude/project-management/business-analyst.md` | Gathering requirements, writing BRDs/FRDs, user stories with AC, gap analysis, traceability matrices |
| `project-manager` | `agents/claude/project-management/project-manager.md` | Sprint planning, stakeholder updates, risk management |

### Phase 2 — Architecture

| Agent | Path | Use for |
|-------|------|---------|
| `solution-architect` | `agents/claude/engineering/architecture/solution-architect.md` | System design, tech stack decisions, integration patterns |
| `software-architect` | `agents/claude/engineering/architecture/software-architect.md` | App-level architecture, design patterns, code structure, API design |
| `database` | `agents/claude/engineering/cross-cutting/database.md` | Schema design, Prisma ORM, migrations, query optimization, indexing |

### Phase 3 — Design

| Agent | Path | Use for |
|-------|------|---------|
| `product-designer` | `agents/claude/product-design/product-designer.md` | UI/UX design, component specs, design systems |
| `frontend-ui` | `agents/claude/engineering/javascript/frontend-ui.md` | Figma-to-code, Tailwind CSS, shadcn/ui, pixel-perfect implementation |

### Phase 4 — Development

| Agent | Path | Use for |
|-------|------|---------|
| `task-planner` | `agents/claude/engineering/cross-cutting/task-planner.md` | Breaking PRD into dev tasks, sprint breakdown |
| `backend-api` | `agents/claude/engineering/javascript/backend-api.md` | REST/tRPC APIs, NextAuth, route handlers, middleware |
| `frontend-ui` | `agents/claude/engineering/javascript/frontend-ui.md` | React components, state management, accessibility |
| `fullstack-nextjs` | `agents/claude/engineering/javascript/fullstack-nextjs.md` | Full-stack Next.js features end-to-end |
| `code-reviewer` | `agents/claude/engineering/cross-cutting/code-reviewer.md` | Code quality, best practices, design patterns, TypeScript safety |
| `security` | `agents/claude/engineering/cross-cutting/security.md` | OWASP Top 10, auth/authz, input validation, secrets management |

### Phase 5 — Testing & QA

| Agent | Path | Use for |
|-------|------|---------|
| `qa-tester` | `agents/claude/engineering/cross-cutting/qa-tester.md` | Playwright E2E, Vitest unit tests, RTL, test coverage strategy |
| `test-planner` | `agents/claude/engineering/cross-cutting/test-planner.md` | Test strategy, test plan from acceptance criteria |
| `security` | `agents/claude/engineering/cross-cutting/security.md` | Security review, penetration testing guidance |
| `performance` | `agents/claude/engineering/cross-cutting/performance.md` | Performance profiling, bundle size, Core Web Vitals |

### Phase 6 — DevOps & Deployment

| Agent | Path | Use for |
|-------|------|---------|
| `deployment` | `agents/claude/engineering/cross-cutting/deployment.md` | Vercel, Docker, Kubernetes, GitHub Actions, CI/CD pipelines |
| `monitoring` | `agents/claude/engineering/cross-cutting/monitoring.md` | Observability, logging, alerting, error tracking |

---

## Commands (Workflow Slash Commands)

The library also includes workflow commands in `ultimate-ai-agents/commands/`. These are slash commands that orchestrate multiple agents for common workflows:

| Command | Use for |
|---------|---------|
| `workflow-implement-backend.md` | Full backend feature implementation workflow |
| `workflow-implement-frontend.md` | Full frontend feature implementation workflow |
| `workflow-implement-fullstack.md` | Full-stack feature end-to-end |
| `workflow-review-code.md` | Structured code review workflow |
| `workflow-review-security.md` | Security audit workflow |
| `workflow-review-performance.md` | Performance review workflow |
| `workflow-qa-e2e.md` | E2E test writing workflow |
| `workflow-write-docs.md` | Documentation generation workflow |
| `workflow-deploy.md` | Deployment workflow |
| `workflow-design-architecture.md` | Architecture design workflow |

---

## Rules

The library also includes reusable project rules in `ultimate-ai-agents/rules/`:

| Rule file | Use for |
|-----------|---------|
| `code-style.md` | TypeScript, React, naming conventions |
| `security.md` | Security guardrails — load on every project |
| `testing.md` | Test patterns and coverage expectations |
| `api-conventions.md` | REST/API design standards |

---

## How to Use in Claude Code

**Option 1 — Load an agent as context:**
```
/read ../../ultimate-ai-agents/agents/claude/engineering/cross-cutting/code-reviewer.md
```
Then ask Claude to act as that agent.

**Option 2 — Install into the project:**
```bash
cd /Users/ronalddelacruz/Training/ai-sdlc/ultimate-ai-agents
./install.sh
```
This installs agents into `.claude/agents/` so Claude Code can invoke them automatically.

**Option 3 — Reference in CLAUDE.md:**
Add the relevant agent paths to your project's CLAUDE.md so Claude loads the right agent for each task type.
