# Ultimate AI Agents

An organization-wide library of AI agent definitions, rules, and workflows — shared across **Claude Code**, **Cursor**, **ChatGPT**, **Gemini**, **Amp**, **Windsurf**, and more. One repo, every department, every platform.

**[Read the full docs](https://ultimate-ai-agents-docs.pages.dev)** | Run locally: `cd docs && npm run dev`

## Who This Is For

| Department | Agents Available |
|------------|-----------------|
| **Engineering** | Software/Solution Architect, Code Reviewer, Security, QA, Database, Deployment, Monitoring, Performance, Full-stack, Frontend, Backend, React Native, Flutter, Java/Spring |
| **Product & Design** | Product Manager, Product Designer, UX Researcher, UX Writer |
| **Project Management** | Project Manager, Scrum Master, Business Analyst |
| **Sales** | Sales Strategist, Pre-Sales Engineer, Account Manager |
| **Marketing** | Content Strategist, Digital Marketer, Brand Manager, Social Media Manager |
| **HR** | HR Generalist, Recruiter, People Ops |
| **L&D** | Training Designer, Knowledge Manager, Executive Coach |
| **Finance** | Financial Analyst, Procurement |
| **Operations** | Operations Manager, Quality Assurance |
| **Admin** | Executive Assistant, Corporate Communications |
| **Leadership** | Strategy Consultant, Chief of Staff |

## Repo Structure

```
ultimate-ai-agents/
│
├── agents/                          # SOURCE OF TRUTH — organized by LLM × department
│   ├── claude/                      #   Claude Code agents (.md files)
│   │   ├── engineering/
│   │   │   ├── architecture/        #     Software/solution architects, designers
│   │   │   ├── cross-cutting/       #     Code review, security, QA, DB, devops
│   │   │   ├── javascript/          #     Next.js, React, backend, React Native
│   │   │   └── savants/             #     Full-stack specialists
│   │   ├── product-design/
│   │   ├── project-management/
│   │   ├── sales/
│   │   ├── marketing/
│   │   ├── hr/
│   │   ├── l-and-d/
│   │   ├── finance/
│   │   ├── operations/
│   │   ├── admin/
│   │   └── leadership/
│   ├── chatgpt/                     #   ChatGPT Custom GPTs (.md, no frontmatter)
│   │   └── ...                      #     Same dept structure as claude/
│   ├── claude-projects/             #   Claude.ai Projects (.md, clean prompts)
│   │   └── ...                      #     Same dept structure as claude/
│   ├── codex/                       #   Codex CLI (AGENTS.md files, rules + persona)
│   │   └── ...                      #     Same dept structure as claude/
│   ├── cursor/                      #   Cursor rules (.mdc files)
│   │   ├── engineering/             #     Path-scoped rules (code-style, testing, etc.)
│   │   └── business/                #     On-demand rules (proposals, HR docs, etc.)
│   └── gemini/                      #   Gemini Gems (.md files)
│       └── ...                      #     Same dept structure as claude/
│
├── commands/                        # Workflow slash commands
├── rules/                           # Shared rules & conventions
│
├── .claude/                         # OUTPUT — auto-synced by install.sh / sync.sh
│   ├── settings.json
│   ├── agents/                      #   ← flattened from agents/claude/
│   ├── commands/                    #   ← synced from commands/
│   ├── rules/                       #   ← synced from rules/
│   └── skills/                      #   Auto-invoked workflows
│
├── .cursor/                         # OUTPUT — auto-synced by install.sh / sync.sh
│   └── rules/                       #   ← flattened from agents/cursor/
│
├── index.html                       # Agent browser — open locally to browse & copy
├── install.sh                       # One-liner installer for CLI tools
├── update.sh                        # Pull latest + re-install
├── uninstall.sh                     # Clean removal
├── sync.sh                          # Quick sync for Claude Code + Cursor
├── generate-browser.sh              # Regenerate index.html after adding agents
├── generate-platforms.sh            # Regenerate chatgpt/ and claude-projects/ from claude/
├── docs/                            # Nextra documentation site
│   ├── content/                     #   MDX pages (install, platforms, agents, reference)
│   ├── app/                         #   Next.js App Router layout
│   └── package.json                 #   npm run dev / build / start
└── CLAUDE.md                        # Claude Code project instructions
```

## Install

### CLI Tools (Claude Code, Cursor, Amp, Windsurf, Gemini CLI)

One command to set up all agents and workflows:

```bash
curl -fsSL https://raw.githubusercontent.com/stratpoint-engineering/ultimate-ai-agents/main/install.sh | bash
```

The installer auto-detects which tools you have installed (Claude Code, Cursor, Amp, Windsurf, Gemini CLI) and deploys the right files to each one.

### Options

Control the install with environment variables:

```bash
# Install only engineering agents
DEPT=engineering curl -fsSL .../install.sh | bash

# Install globally (~/.claude/) instead of current project
SCOPE=global curl -fsSL .../install.sh | bash

# Force install for a specific tool (skip auto-detect)
TOOLS=claude curl -fsSL .../install.sh | bash

# Combine options
DEPT=sales SCOPE=global TOOLS=claude curl -fsSL .../install.sh | bash
```

| Variable | Options | Default |
|----------|---------|---------|
| `SCOPE` | `project`, `global` | `project` |
| `DEPT` | `all`, `engineering`, `sales`, `marketing`, `hr`, `l-and-d`, `finance`, `operations`, `admin`, `leadership`, `product-design`, `project-management` | `all` |
| `TOOLS` | `auto`, `all`, `claude`, `cursor`, `codex`, `amp`, `windsurf`, `gemini` | `auto` |
| `BRANCH` | any git branch | `main` |

### Update

```bash
./update.sh                   # Pull latest + re-install (interactive)
TOOLS=claude ./update.sh      # Pull latest + re-install (non-interactive)
```

If running from a cloned repo, `update.sh` does `git pull` first, shows what changed, then re-runs the installer. If running standalone, it re-fetches from remote.

### Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/stratpoint-engineering/ultimate-ai-agents/main/uninstall.sh | bash
```

Or if you cloned the repo:

```bash
./uninstall.sh                # Remove from current project
SCOPE=global ./uninstall.sh   # Remove global install
```

### Browser & Desktop Apps (Claude.ai, ChatGPT, Gemini, AI Studio)

**Option A: Agent Browser (recommended)**

Open `index.html` in your browser — browse all agents, pick your platform, and copy with one click.

```bash
# If you cloned the repo
open index.html

# Or regenerate after adding agents
./generate-browser.sh && open index.html
```

**Option B: Copy from files directly**

Each platform has its own directory with ready-to-paste prompts:

| Platform | Directory | How to use |
|----------|-----------|------------|
| **Claude.ai** | `agents/claude-projects/` | Project → Custom instructions → Paste |
| **ChatGPT** | `agents/chatgpt/` | Create GPT → Instructions → Paste |
| **Gemini** | `agents/gemini/` | Gems → Create → System Instruction → Paste |
| **AI Studio** | `agents/claude-projects/` | System instructions → Paste |
| **Any LLM** | `agents/claude-projects/` | System prompt → Paste |

**Option C: Regenerate platform files**

If you edit agents in `agents/claude/` (the source of truth), regenerate the other platforms:

```bash
./generate-platforms.sh   # Regenerate chatgpt/ and claude-projects/
./generate-browser.sh     # Regenerate index.html
```

---

## Quick Start by Tool

### Claude Code

```bash
# Use any agent directly
claude --agent sales-strategist
claude --agent project-manager
claude --agent financial-analyst

# Or invoke inside a session
@code-reviewer review this PR
@product-manager write a PRD for user onboarding
@hr-generalist write a JD for a senior engineer

# Run workflow commands
/project:workflow-review-code
/project:workflow-deploy
```

After editing files in `agents/`, run `./sync.sh` to update `.claude/`.

### Cursor

Rules in `.cursor/rules/` are loaded automatically. Engineering rules are path-scoped (activate when editing matching files). Business rules (`proposals.mdc`, `hr-documents.mdc`, etc.) are manually activated.

| Rule | Scope |
|------|-------|
| `project.mdc` | Always — project context |
| `writing-style.mdc` | Always — all business documents |
| `code-style.mdc` | `src/**`, `app/**` |
| `testing.mdc` | `*.test.*`, `*.spec.*` |
| `api-conventions.mdc` | `src/api/**`, `app/api/**` |
| `security.mdc` | Always |
| `nextjs.mdc` | `app/**` |
| `code-review.mdc` | Always |
| `react-components.mdc` | `components/**` |
| `database.mdc` | `prisma/**`, `src/server/**` |
| `performance.mdc` | `src/**`, `app/**` |
| `proposals.mdc` | On demand — sales/business proposals |
| `hr-documents.mdc` | On demand — HR documents |
| `marketing-content.mdc` | On demand — marketing content |
| `financial-docs.mdc` | On demand — financial documents |
| `project-docs.mdc` | On demand — PM documents |
| `strategy-docs.mdc` | On demand — strategy documents |

### Gemini Gems

Each file in `agents/gemini/` is ready to paste into Google Gemini:

1. Open [Gemini](https://gemini.google.com) → **Gems** → **Create a Gem**
2. Open the gem file (e.g., `agents/gemini/sales/sales-strategist.md`)
3. Copy the **Description** into the description field
4. Copy the **System Instruction** into the instructions field
5. Save

For Gemini CLI, the installer auto-converts gems to TOML commands.

### Codex CLI

Codex uses a single `AGENTS.md` file (not multiple agents). The installer deploys rules to `AGENTS.md`. To use a specific agent persona:

```bash
# Install rules globally
TOOLS=codex SCOPE=global ./install.sh

# Then pick an agent for your project
cp agents/codex/sales/sales-strategist.md ./AGENTS.md
codex "draft a proposal for Acme Corp"
```

Pre-built agent files in `agents/codex/` include project rules + the agent persona in one file.

### ChatGPT

```bash
# Open the agent file
cat agents/chatgpt/sales/sales-strategist.md

# Copy contents → chatgpt.com → Create GPT → paste into Instructions
```

## All Agents

### Engineering

| Agent | Purpose |
|-------|---------|
| `software-architect` | Application-level design patterns and structure |
| `solution-architect` | Enterprise multi-system integration |
| `solution-designer` | Detailed specs, API design, DB schemas |
| `code-reviewer` | Code quality, best practices, refactoring |
| `database` | PostgreSQL/Prisma schema and query optimization |
| `deployment` | CI/CD, Vercel, Docker, Kubernetes |
| `monitoring` | Sentry, logging, APM, OpenTelemetry |
| `performance` | Core Web Vitals, bundle size, caching |
| `product-manager` | PRDs, feature specs, acceptance criteria |
| `qa-tester` | Vitest, Playwright, test strategies |
| `security` | OWASP Top 10, auth, input validation |
| `task-planner` | Dev task generation from PRDs |
| `tech-writer` | Technical documentation, API docs |
| `test-planner` | Test case generation from PRDs |
| `backend-api` | tRPC/REST, Next.js Route Handlers |
| `frontend-ui` | React components, shadcn/ui, forms |
| `fullstack-nextjs` | Next.js 16+, Server Components, App Router |
| `react-native` | Native modules, offline-first patterns |
| `savant-flutter` | Flutter iOS/Android specialist |
| `savant-fullstack-js` | Full-stack JS/TS master architect |
| `savant-java-spring` | Java/Spring Boot microservices |
| `savant-react-native` | React Native specialist |

### Product & Design (3 agents)

| Agent | Purpose |
|-------|---------|
| `product-designer` | UI/UX, design systems, wireframes, accessibility |
| `ux-researcher` | User interviews, usability testing, personas, journey maps |
| `ux-writer` | Microcopy, error messages, onboarding flows, voice & tone |

### Project Management (3 agents)

| Agent | Purpose |
|-------|---------|
| `project-manager` | Sprint planning, risk mgmt, status reports, RACI |
| `scrum-master` | Ceremonies, burndown, retrospectives, agile metrics |
| `business-analyst` | Requirements, BRD/FRD, user stories, process mapping |

### Sales (3 agents)

| Agent | Purpose |
|-------|---------|
| `sales-strategist` | Proposals, pitch decks, battle cards, MEDDIC/BANT |
| `pre-sales-engineer` | Technical proposals, RFP/RFI, demo scripts, POC plans |
| `account-manager` | QBRs, renewals, client health, escalation handling |

### Marketing (4 agents)

| Agent | Purpose |
|-------|---------|
| `content-strategist` | Content calendars, blogs, case studies, SEO strategy |
| `digital-marketer` | Campaigns, ad copy, email sequences, funnels |
| `brand-manager` | Brand guidelines, messaging frameworks, positioning |
| `social-media-manager` | Platform-specific content, community mgmt, crisis comms |

### HR (3 agents)

| Agent | Purpose |
|-------|---------|
| `hr-generalist` | Job descriptions, policies, performance reviews, PIPs |
| `recruiter` | Job postings, screening rubrics, interview scorecards |
| `people-ops` | Onboarding/offboarding, engagement surveys, culture |

### L&D (3 agents)

| Agent | Purpose |
|-------|---------|
| `training-designer` | Course design (ADDIE), lesson plans, assessments |
| `knowledge-manager` | Knowledge bases, SOPs, runbooks, documentation standards |
| `coach` | Coaching (GROW/OSKAR), leadership development, OKRs |

### Finance (2 agents)

| Agent | Purpose |
|-------|---------|
| `financial-analyst` | Budgets, forecasting, P&L, ROI, cost-benefit analysis |
| `procurement` | RFPs, vendor evaluation, contract review, SLAs |

### Operations (2 agents)

| Agent | Purpose |
|-------|---------|
| `operations-manager` | SOPs, KPIs, capacity planning, DMAIC, change mgmt |
| `quality-assurance` | Audits, CAPA, root cause analysis, ISO compliance |

### Admin (2 agents)

| Agent | Purpose |
|-------|---------|
| `executive-assistant` | Agendas, minutes, briefings, event planning |
| `corporate-comms` | Press releases, internal announcements, crisis comms |

### Leadership (2 agents)

| Agent | Purpose |
|-------|---------|
| `strategy-consultant` | SWOT, OKRs, market sizing, GTM, business model canvas |
| `chief-of-staff` | Board decks, exec reporting, strategic initiatives, ops rhythm |

## Adding or Editing Agents

1. Edit the canonical file in `agents/<tool>/<department>/`
2. Run `./install.sh` to deploy everywhere (or `./sync.sh` for Claude Code + Cursor only)

## Creating a New Agent

1. Create the agent for each tool you want to support:
   - **Claude Code**: `agents/claude/<dept>/agent-name.md`
     ```yaml
     ---
     name: agent-name
     description: When to use this agent (include trigger keywords)
     tools: Read, Write, Edit, Bash, Grep, Glob
     model: sonnet
     ---
     ```
   - **Gemini**: `agents/gemini/<dept>/agent-name.md` (description + system instruction)
   - **Cursor**: `agents/cursor/engineering/rule-name.mdc` (if applicable)
2. Write the system prompt with templates and checklists
3. Run `./install.sh` to deploy
