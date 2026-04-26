# Developer Agents

> **Role focus:** Implementation. Debugging. Refactoring. Unit + integration
> testing. Documentation. Code review (self-review and peer-review).

## What lives here

| File | Purpose |
|---|---|
| `code-reviewer.md` | Seed agent — reviews TaskFlow code for quality, security, and CLAUDE.md compliance. |

## Suggested agents to contribute

As participants work through the training, additional agents to contribute:

- `unit-test-author.md` — agent that generates unit tests from a function plus
  acceptance criteria.
- `bug-investigator.md` — agent that walks a stack trace + failing test back
  to a likely root cause and proposes a fix.
- `refactor-with-tests.md` — agent that writes characterization tests first,
  then proposes a refactor that keeps them passing.
- `api-doc-generator.md` — agent that generates OpenAPI / API.md docs from
  route handlers.

## How to add an agent

1. Create a markdown file: `{agent-name}.md` (kebab-case).
2. Add YAML frontmatter (`name`, `description`, optional `tools`).
3. Write the system prompt body below the frontmatter.
4. Use the existing `code-reviewer.md` in this folder as the reference pattern.

## Related

- Reusable prompt templates: `knowledge/prompts/dev/`
- Cross-tool wiring guidance: `knowledge/agents/README.md`
- Quality gate skill: `knowledge/skills/taskflow-quality-gate-check/`
