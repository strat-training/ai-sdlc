# TaskFlow — Shared AI Knowledge Repository

This repository stores reusable AI prompts, rules, agent specs, workflow patterns, and retrospective notes from the TaskFlow project.

## Structure

```
knowledge/
├── prompts/
│   ├── pm/         # Product Manager prompts
│   ├── sa/         # Solutions Architect prompts
│   └── dev/        # Developer prompts
├── rules/          # Project-specific AI rules with rationale
├── agents/         # Agent specifications and usage notes
├── patterns/       # Multi-step prompt chains and workflow templates
└── retros/         # Sprint retrospective notes and action items
```

## How to Contribute

1. **Prompts** — create `prompts/{role}/{task-type}/{prompt-name}.md` using the template below
2. **Rules** — add to `rules/` with rationale explaining why the rule exists
3. **Agents** — document in `agents/` with spec, tools, and usage examples
4. **Patterns** — document multi-step chains in `patterns/`
5. **Retros** — add sprint retro notes in `retros/YYYY-MM-DD.md`

Submit as a PR with a brief description. Get peer review before merging.

## Prompt Documentation Template

```markdown
# [Prompt Title]

**Purpose:** One sentence on what this prompt does.
**Role:** PM | SA | TL | Dev
**Tool:** Claude Code | Cursor | Gemini

## Template

\```
[Paste prompt template here — use [PLACEHOLDER] for variable parts]
\```

## Example Input

[Paste a real example input]

## Example Output

[Paste or summarize the output you got]

## Notes

- When to use this prompt
- Known limitations
- Refinements that improved it
```

## Quality Standards

- Every prompt must have at least one real example input/output
- Rules must include rationale — why does this rule exist?
- Agent specs must include tools allowed and disallowed
- Retro notes must include at least one concrete action item with an owner
