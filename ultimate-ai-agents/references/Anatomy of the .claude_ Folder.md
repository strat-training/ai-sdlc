# Anatomy of the .claude/ Folder

#

**A Complete Guide to CLAUDE.md, Custom Commands, Skills, Agents, and Permissions**

***

Most Claude Code users know the `.claude` folder exists. They have seen it appear in their project root. But very few have ever opened it, let alone understood what every file inside it does.

That is a missed opportunity.

The `.claude` folder is the control center for how Claude behaves in your project. It holds your instructions, your custom commands, your permission rules, your hooks, and even Claude's memory across sessions. Once you understand what lives where and why, you can configure Claude Code to behave exactly the way your team needs it to.

This guide walks through the entire anatomy of the folder, from the files you will use daily to the ones you will set once and never think about again.

***

## Two Folders, Not One

Before diving in, one important detail: there are actually **two**`.claude` directories, not one.

* The **project-level folder** lives inside your project and holds team configuration. You commit it to Git, and everyone on the team gets the same rules, commands, and permission policies.
* The **global folder** at `~/.claude/` holds your personal preferences and machine-local state, such as session history and auto-memory.

Understanding which folder to put things in — and how they interact when both exist — is the foundation for everything that follows.

***

## CLAUDE.md: The Instruction Manual

This is the most important file in the entire system. When you start a Claude Code session, the first thing it reads is `CLAUDE.md`. It loads this file straight into the system prompt and keeps it in mind for the entire conversation.

The principle is simple: whatever you write in CLAUDE.md, Claude will follow. If you instruct it to always write tests before implementation, it will. If you say "never use console.log for error handling, always use the custom logger module," it will respect that every time.

Placing `CLAUDE.md` at your project root is the most common setup. You can also have one at `~/.claude/CLAUDE.md` for global preferences that apply across all projects, and even one inside subdirectories for folder-specific rules. Claude reads all of them and combines the instructions. When project-level and user-level instructions conflict, the project-level file takes precedence.

### What Belongs in CLAUDE.md

Most people either write too much or too little. Here is what works well.

**Include:**

* Build, test, and lint commands (e.g., `npm run test`, `make build`)
* Key architectural decisions ("we use a monorepo with Turborepo")
* Non-obvious gotchas ("TypeScript strict mode is on; unused variables are errors")
* Import conventions, naming patterns, and error handling styles
* File and folder structure for the main modules

**Exclude:**

* Anything that already belongs in a linter or formatter config
* Full documentation you can already link to
* Long paragraphs explaining theory

Keep CLAUDE.md under 200 lines. This is not arbitrary — files longer than that consume too much context, and Claude's instruction adherence actually drops. If you find rules being ignored, check the file length first.

Here is a minimal but effective example:

```
# Project: Acme API

## Commands
npm run dev          # Start dev server
npm run test         # Run tests (Jest)
npm run lint         # ESLint + Prettier check
npm run build        # Production build

## Architecture
- Express REST API, Node 20
- PostgreSQL via Prisma ORM
- All handlers live in src/handlers/
- Shared types in src/types/

## Conventions
- Use zod for request validation in every handler
- Return shape is always { data, error }
- Never expose stack traces to the client
- Use the logger module, not console.log

## Watch out for
- Tests use a real local DB, not mocks. Run `npm run db:test:reset` first
- Strict TypeScript: no unused imports, ever

```

That is roughly 20 lines. It gives Claude everything it needs to work productively in this codebase without constant clarification.

### CLAUDE.local.md for Personal Overrides

Sometimes you have a preference that is specific to you, not the whole team. Perhaps you prefer a different test runner or you want Claude to always open files using a specific pattern.

Create `CLAUDE.local.md` in your project root. Claude reads it alongside the main `CLAUDE.md`, and it is automatically gitignored so your personal tweaks never land in the repository.

***

## The rules/ Folder: Modular Instructions That Scale

CLAUDE.md works well for a single project. But once your team grows, you can end up with a 300-line file that nobody maintains and everyone ignores. The `rules/` folder solves this problem.

Every Markdown file inside `.claude/rules/` gets loaded alongside your CLAUDE.md automatically. Instead of one monolithic file, you split instructions by concern:

```
.claude/rules/
├── code-style.md
├── testing.md
├── api-conventions.md
└── security.md

```

Each file stays focused and easy to update. The team member who owns API conventions edits `api-conventions.md`. The person who owns testing standards edits `testing.md`. Nobody steps on each other.

### Path-Scoped Rules

The real power comes from path-scoped rules. Add a YAML frontmatter block to a rule file and it only activates when Claude is working with matching files:

```
---
paths:
  - "src/api/**/*.ts"
  - "src/handlers/**/*.ts"
---

# API Design Rules
- All handlers return { data, error } shape
- Use zod for request body validation
- Never expose internal error details to clients

```

Claude will not load this file when it is editing a React component. It only loads when working inside `src/api/` or `src/handlers/`. Rules without a `paths` field load unconditionally in every session.

This is the right pattern once your CLAUDE.md starts feeling crowded.

***

## The commands/ Folder: Custom Slash Commands

Out of the box, Claude Code has built-in slash commands like `/help` and `/compact`. The `commands/` folder lets you add your own.

Every Markdown file you drop into `.claude/commands/` becomes a slash command. A file named `review.md` creates `/project:review`. A file named `fix-issue.md` creates `/project:fix-issue`. The filename is the command name.

Here is a simple example. Create `.claude/commands/review.md`:

```
---
description: Review the current branch diff for issues before merging
---

## Changes to Review
!`git diff --name-only main...HEAD`

## Detailed Diff
!`git diff main...HEAD`

Review the above changes for:
- Code quality issues
- Security vulnerabilities
- Missing test coverage
- Performance concerns

Give specific, actionable feedback per file.

```

Running `/project:review` in Claude Code automatically injects the real Git diff into the prompt before Claude sees it. The `` !`backtick` `` syntax runs shell commands and embeds the output, which is what makes these commands genuinely useful rather than just saved text.

### Passing Arguments to Commands

Use `$ARGUMENTS` to pass text after the command name:

```
---
description: Investigate and fix a GitHub issue
argument-hint: [issue-number]
---

Look at issue #$ARGUMENTS in this repo.
!`gh issue view $ARGUMENTS`

Understand the bug, trace it to the root cause, fix it, and write a
test that would have caught it.

```

Running `/project:fix-issue 234` feeds issue 234's content directly into the prompt.

### Personal vs. Project Commands

Project commands in `.claude/commands/` are committed and shared with your team. For commands you want everywhere regardless of project, put them in `~/.claude/commands/`. Those show up as `/user:command-name` instead.

Useful personal commands include a daily standup helper, a command for generating commit messages following your convention, or a quick security scan.

***

## The skills/ Folder: Reusable Workflows on Demand

Skills look similar to commands on the surface, but the trigger mechanism is fundamentally different. Skills are workflows that Claude can invoke on its own, without you typing a slash command, when the task matches the skill's description. Commands wait for you. Skills watch the conversation and act when the moment is right.

Each skill lives in its own subdirectory with a `SKILL.md` file:

```
.claude/skills/
├── security-review/
│   ├── SKILL.md
│   └── DETAILED_GUIDE.md
└── deploy/
    ├── SKILL.md
    └── templates/
        └── release-notes.md

```

The `SKILL.md` uses YAML frontmatter to describe when to use it:

```
---
name: security-review
description: Comprehensive security audit. Use when reviewing code for
  vulnerabilities, before deployments, or when the user mentions security.
allowed-tools: Read, Grep, Glob
---

Analyze the codebase for security vulnerabilities:
- SQL injection and XSS risks
- Exposed credentials or secrets
- Insecure configurations
- Authentication and authorization gaps

Report findings with severity ratings and specific remediation steps.
Reference @DETAILED_GUIDE.md for our security standards.

```

When you say "review this PR for security issues," Claude reads the description, recognizes it matches, and invokes the skill automatically. You can also call it explicitly.

The key difference from commands: **skills can bundle supporting files alongside them**. The `@DETAILED_GUIDE.md` reference pulls in a detailed document that lives right next to `SKILL.md`. Commands are single files. Skills are packages.

One thing to keep in mind: if a skill's `description` field is too vague, Claude may not recognize when to invoke it. Include concrete keywords that match the kinds of requests you expect.

Personal skills go in `~/.claude/skills/` and are available across all projects.

***

## The agents/ Folder: Specialized Subagent Personas

Subagents are one of Claude Code's most powerful features. They are specialized personas that Claude can delegate work to, each with its own system prompt, tool restrictions, model selection, and even persistent memory.

Each agent is defined as a Markdown file with YAML frontmatter in `.claude/agents/` (project-level, shared with the team) or `~/.claude/agents/` (personal, available across all projects).

Here is a practical example of a code reviewer agent:

```
---
name: code-reviewer
description: Reviews code for quality, performance, and best practices
tools: Read, Grep, Glob
model: sonnet
memory: user
---

You are a senior code reviewer. Focus on:
- Logic errors and edge cases
- Performance bottlenecks
- Security vulnerabilities
- Adherence to project conventions

As you review code, update your agent memory with patterns,
conventions, and recurring issues you discover.

```

### Key Agent Features

Agents support several frontmatter fields that make them more than just saved prompts:

* **model** — Route the agent to a specific Claude model (e.g., `sonnet` for speed, `opus` for complex reasoning). This lets you balance cost and quality per task.
* **tools** — Restrict which tools the agent can use. A documentation agent might only need `Read` and `Grep`, while a refactoring agent needs `Write` and `Edit` too.
* **memory** — Give the agent a persistent memory directory that survives across sessions. Set to `project` to store memories in `.claude/agent-memory/` (shared with team) or `local` for personal gitignored memory.
* **skills** — Inject specific skill content into the agent's context at startup so it has domain knowledge without needing to discover and load skills during execution.

### How to Invoke Agents

You can invoke a subagent in several ways:

* Type `@agent-name` in your message to have Claude delegate the current task to that agent.
* Ask Claude explicitly: "Use the code-reviewer agent to analyze my latest commits."
* Use the `/agents` command to create and manage agents interactively.
* Start an entire session as an agent with `claude --agent code-reviewer`.

When naming conflicts occur between project and global agents, project-specific agents take priority.

***

## settings.json: Permissions and Configuration

The `settings.json` file controls what Claude is and is not allowed to do without asking for your confirmation. It uses an allow/deny list structure:

```
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": [
      "Bash(npm run *)",
      "Bash(git *)",
      "Read",
      "Write",
      "Edit"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(curl *)",
      "Read(./.env)",
      "Read(./.env.*)"
    ]
  }
}

```

Here is what each part does:

* The **\$schema** line enables autocomplete and inline validation in VS Code or Cursor. Always include it.
* The **allow list** contains commands that run without Claude asking for confirmation. A good allow list covers your run scripts, read-only Git commands, and basic file operations.
* The **deny list** contains commands that are blocked entirely, no matter what. A sensible deny list blocks destructive shell commands, direct network commands, and sensitive files like `.env`.

If something is not in either list, Claude asks before proceeding. That middle ground is intentional — it gives you a safety net without having to anticipate every possible command upfront.

As with CLAUDE.md, create `.claude/settings.local.json` for personal permission changes you do not want committed. It is auto-gitignored.

***

## Configuration Precedence: What Wins When Settings Conflict

With multiple configuration files across multiple scopes, conflicts are inevitable. Claude Code resolves them with a strict hierarchy. From highest to lowest priority:

1. **Managed settings** — Enterprise policies deployed by IT/DevOps. These cannot be overridden by anything below.
2. **Command-line flags** — Flags like `--model opus` override all file-based settings for that session.
3. **Local project settings** — `.claude/settings.local.json` (personal, gitignored).
4. **Shared project settings** — `.claude/settings.json` (committed, shared with team).
5. **User settings** — `~/.claude/settings.json` (global defaults, lowest priority).

A practical example: if your user settings allow `Bash(curl *)` but the project settings deny it, the project setting takes precedence and the command is blocked. If you need curl for your machine specifically, add the allow rule to `.claude/settings.local.json` instead — local scope beats project scope.

One critical detail: for permissions, a deny in any scope cannot be overridden by an allow in any other scope. Deny rules are absolute. This is a deliberate safety design, not a bug.

You can run `/status` inside Claude Code to see every configuration layer and where each rule originates, which is invaluable for debugging unexpected behavior.

***

## Hooks: Event-Driven Automation

Hooks let you attach shell scripts or HTTP endpoints that fire automatically when specific events occur in Claude Code, such as before or after a tool runs, when a conversation starts, or when Claude sends a notification.

Common use cases include:

* Auto-formatting code after Claude writes or edits a file (e.g., running Prettier on save)
* Validating bash commands before Claude executes them
* Sending desktop notifications when a long-running task completes
* Logging tool usage for auditing or debugging

Hooks are configured in `settings.json` rather than as standalone files. They support both shell commands and HTTP endpoints (using `"type": "http"`), making them flexible enough for both local development workflows and team-wide automation pipelines.

***

## The Memory System: How Claude Remembers

Claude Code has a persistent memory system that is responsible for the feeling that Claude "knows" your project across sessions. There are two main components:

* **Auto-memory** lives in `~/.claude/projects/<project-hash>/memory/`. As Claude works in your project, it automatically saves useful observations — commands it discovers, patterns it notices, architecture insights. These persist across sessions and are indexed by a `MEMORY.md` file.
* **Agent memory** gives subagents their own persistent knowledge base. Agents configured with `memory: project` store memories in `.claude/agent-memory/<agent-name>/` (shared with the team), while `memory: local` stores in `.claude/agent-memory-local/<agent-name>/` (personal, gitignored).

You can browse, edit, and manage auto-memory with the `/memory` command. This is useful when Claude seems to "remember" something you never told it, or when you want to wipe a project's accumulated context and start fresh.

Memory files use a specific format with YAML frontmatter that categorizes memories by type: `user` (about the person), `feedback` (corrections and preferences), `project` (ongoing work context), and `reference` (pointers to external resources).

***

## The Global \~/.claude/ Folder

Here is a summary of what lives in the global directory:

* `~/.claude/CLAUDE.md` — Loads into every Claude Code session across all your projects. A good place for your personal coding principles and preferred style.
* `~/.claude/settings.json` — Global permission rules and configuration (lowest-priority scope in the hierarchy).
* `~/.claude/projects/` — Session transcripts and auto-memory per project.
* `~/.claude/commands/`, `skills/`, `agents/` — Personal commands, skills, and agents available across all projects.

***

## The Full Directory Structure

Here is how everything comes together:

```
your-project/
├── CLAUDE.md                  # Team instructions (committed)
├── CLAUDE.local.md            # Personal overrides (gitignored)
│
└── .claude/
    ├── settings.json          # Permissions + config (committed)
    ├── settings.local.json    # Personal permission overrides (gitignored)
    ├── .mcp.json              # MCP server configurations
    │
    ├── commands/              # Custom slash commands
    │   ├── review.md          # → /project:review
    │   ├── fix-issue.md       # → /project:fix-issue
    │   └── deploy.md          # → /project:deploy
    │
    ├── rules/                 # Modular instruction files
    │   ├── code-style.md
    │   ├── testing.md
    │   └── api-conventions.md
    │
    ├── skills/                # Auto-invoked workflows
    │   ├── security-review/
    │   │   └── SKILL.md
    │   └── deploy/
    │       └── SKILL.md
    │
    ├── agents/                # Specialized subagent personas
    │   ├── code-reviewer.md
    │   └── security-auditor.md
    │
    └── agent-memory/          # Shared agent memory (committed)
        └── code-reviewer/

~/.claude/
├── CLAUDE.md                  # Global instructions
├── settings.json              # Global settings
├── commands/                  # Personal commands (all projects)
├── skills/                    # Personal skills (all projects)
├── agents/                    # Personal agents (all projects)
└── projects/                  # Session history + auto-memory

```

***

## Edge Cases and Gotchas

Before wrapping up, here are the things most likely to trip you up:

* **CLAUDE.md gets ignored when too long.** Very long instruction files eat into the context window and Claude starts losing track of rules buried deep in the file. If you find instructions being ignored, check the file length first.
* **Deny rules are absolute.** A deny in any scope cannot be overridden by an allow in any other scope, even a higher-priority one. If you deny `Bash(rm *)` in project settings, no user or local setting can re-allow it.
* **Pattern matching is exact.**`Bash(npm test)` only matches the exact string `npm test`, not `npm test -- --watch`. Use `Bash(npm test *)` or `Bash(npm test*)` to match variations. Similarly, `Bash(git *)` as a deny rule blocks all Git commands including safe ones like `git status`. Only deny the dangerous operations.
* **MCP tool names require the full prefix.** MCP tools must use the `mcp__<server>__<tool>` format in permission rules. Writing just the tool name will not match.
* **Environment variables do not persist between Bash calls.** Each Bash command runs in a fresh shell environment. An `export MY_VAR=value` in one command is not available in the next. Use `CLAUDE_ENV_FILE` or the `env` field in settings.json instead.
* **Secrets in settings.json get committed.** If you put API keys or tokens in `.claude/settings.json`, they go into version control. Secrets belong in `.claude/settings.local.json` which is auto-gitignored.
* **Skill descriptions must be specific.** If a skill's `description` field is too vague, Claude may not recognize when to invoke it. Include concrete keywords that match the kinds of requests you expect.

***

## Getting Started

If you are starting from scratch, here is a progression that works well:

1. Run `/init` inside Claude Code. It generates a starter CLAUDE.md by reading your project. Edit it down to the essentials.
2. Add `.claude/settings.json` with allow/deny rules appropriate for your stack. At minimum, allow your run commands and deny `.env` reads.
3. Create one or two commands for the workflows you do most. Code review and issue fixing are good starting points.
4. As your project grows and your CLAUDE.md gets crowded, start splitting instructions into `.claude/rules/` files. Scope them by path where it makes sense.
5. Add a `~/.claude/CLAUDE.md` with your personal preferences, such as "always write types before implementations" or "prefer functional patterns over class-based."

That is all you need for the vast majority of projects. Skills, agents, and hooks come in when you have recurring complex workflows worth packaging up.

***

## The Key Insight

The `.claude` folder is really a protocol for telling Claude who you are, what your project does, and what rules it should follow. The more clearly you define that, the less time you spend correcting Claude and the more time it spends doing useful work.

CLAUDE.md is your highest-leverage file. Get that right first. Everything else is optimization.

Start small, refine as you go, and treat it like any other piece of infrastructure in your project — something that pays dividends every day once it is set up properly.

