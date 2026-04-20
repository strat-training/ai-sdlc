# Contributing to Ultimate AI Agents

Thank you for contributing! This guide covers how to add agents, update workflows, and submit changes.

## Getting Started

```bash
git clone https://github.com/stratpoint-engineering/ultimate-ai-agents.git
cd ultimate-ai-agents
```

## Adding a New Agent

1. **Create the agent** in `agents/claude/<department>/agent-name.md`:

   ```yaml
   ---
   name: agent-name
   description: When to use this agent (include trigger keywords)
   tools: Read, Write, Edit, Bash, Grep, Glob
   model: sonnet
   ---

   # Agent Title

   You are an expert in...

   ## Guidelines
   ...
   ```

2. **Generate platform variants**:

   ```bash
   ./generate-platforms.sh    # Creates chatgpt/, claude-projects/, codex/ versions
   ./generate-browser.sh      # Regenerates index.html agent browser
   ```

3. **Test the install**:

   ```bash
   TOOLS=claude ./install.sh
   ```

4. **If adding Cursor rules**, create the `.mdc` file in `agents/cursor/engineering/` or `agents/cursor/business/`.

5. **If adding Gemini gems**, create the gem file in `agents/gemini/<department>/`.

## Editing an Existing Agent

1. Edit the source file in `agents/claude/<department>/`
2. Run `./generate-platforms.sh` and `./generate-browser.sh`
3. Run `./sync.sh` to verify local sync

## Adding a Workflow

Create a workflow command in `commands/workflow-<name>.md`. These become slash commands in Claude Code (`/project:workflow-<name>`).

## Code Style

- **No hardcoded counts** — never write "49 agents" or "11 workflows" in any file. These numbers change.
- **Agent frontmatter** — every Claude agent must have `name`, `description`, `tools`, and `model` fields.
- **Department structure** — agents belong in their department directory, not at the root.

## Submitting Changes

1. Create a branch from `main`:

   ```bash
   git checkout -b add/agent-name
   ```

2. Make your changes and commit:

   ```bash
   git add -A
   git commit -m "Add <agent-name> agent to <department>"
   ```

3. Push and open a PR:

   ```bash
   git push -u origin add/agent-name
   gh pr create
   ```

4. Fill out the PR template checklist.

5. Wait for review — `main` requires 1 approval before merging.

## Branch Naming

| Type | Pattern | Example |
|------|---------|---------|
| New agent | `add/<agent-name>` | `add/devops-engineer` |
| Update agent | `update/<agent-name>` | `update/code-reviewer` |
| New workflow | `add/workflow-<name>` | `add/workflow-migrate-db` |
| Fix | `fix/<description>` | `fix/install-script-macos` |
| Docs | `docs/<description>` | `docs/add-cursor-guide` |

## Project Structure

- `agents/claude/` — Source of truth for all agents
- `agents/cursor/` — Cursor-specific rules
- `agents/gemini/` — Gemini-specific gems
- `agents/chatgpt/` — Generated (do not edit directly)
- `agents/claude-projects/` — Generated (do not edit directly)
- `agents/codex/` — Generated (do not edit directly)
- `commands/` — Workflow slash commands
- `rules/` — Shared rules applied to all agents
- `docs/` — Nextra documentation site

## Questions?

Open an issue at [github.com/stratpoint-engineering/ultimate-ai-agents/issues](https://github.com/stratpoint-engineering/ultimate-ai-agents/issues).
