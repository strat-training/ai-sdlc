# TaskFlow — CLAUDE.md (Claude Code)

> **Source of truth: `AGENTS.md` at the repo root.**
> AGENTS.md contains the cross-tool project rules read by Claude Code, Cursor,
> and Antigravity. This file (CLAUDE.md) layers Claude-Code-specific behavior
> on top — it is loaded automatically by Claude Code in every session.

## Read first

Always read `AGENTS.md` at the start of any non-trivial task. It contains:
- Stack and forbidden technologies
- Backend, frontend, security, and git coding standards
- Role permissions
- Quality gate requirements
- Working-with-AI conventions for this project

If a rule below conflicts with `AGENTS.md`, `AGENTS.md` wins on shared concerns.
Use this file only for genuine Claude-Code-specific overrides.

## Claude-Code-specific behaviors

### Subagent invocation

The seed code-reviewer subagent for this project lives at:
`knowledge/agents/dev/code-reviewer.md`.

To make it available to Claude Code's auto-delegation, copy or symlink it to
`.claude/agents/code-reviewer.md` in your local checkout. Once installed,
Claude Code will auto-invoke it on review-shaped tasks based on the
`description` field.

When working on TaskFlow:
- Trust auto-delegation for code review on PRs and commits.
- Explicitly invoke `@code-reviewer` for self-review before pushing.
- Build your own subagents during Module 6 — keep the source of truth in
  `knowledge/agents/{role}/` and copy to `.claude/agents/` for activation.

### Skills

Skills for this project live in `knowledge/skills/{name}/SKILL.md`. To use them
in Claude Code, copy or symlink to `.claude/skills/{name}/SKILL.md`. The seed
skill is `taskflow-quality-gate-check` — useful before commits and during
review.

### Session hygiene

- For tasks involving multiple unrelated artifacts (e.g., refactor + new
  feature + test fix), prefer separate sessions or use subagents to isolate
  context.
- Compact context (`/compact`) when the conversation has accumulated noise
  from completed sub-tasks. See Module 5 for full context-engineering practice.

### MCP servers in scope

This project's `.mcp.json` configures: GitHub (repo operations), Filesystem
(repo file access). If you need additional MCP servers (e.g., Atlassian for
Jira), install them at the user level rather than committing project-level
changes — keep the project's MCP scope tight.
