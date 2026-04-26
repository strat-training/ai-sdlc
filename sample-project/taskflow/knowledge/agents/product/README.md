# Product Manager / Designer Agents

> **Role focus:** PRD authoring. UI/UX design. User stories with acceptance
> criteria. PRD-against-BRD validation.

## What lives here

Agent definitions Product Managers / Designers build during training to
automate recurring PRD and UX work. Examples participants might contribute:

- `prd-author.md` — agent that drafts PRD sections from approved BRD content.
- `user-story-generator.md` — agent that takes a feature description and
  produces user stories with acceptance criteria.
- `accessibility-reviewer.md` — agent that reviews UI specs against WCAG 2.1 AA
  for the core flows.
- `wireframe-spec-writer.md` — agent that converts user stories into wireframe
  descriptions ready for Figma Make.

## How to add an agent

1. Create a markdown file: `{agent-name}.md` (kebab-case).
2. Add YAML frontmatter (`name`, `description`, optional `tools`).
3. Write the system prompt body below the frontmatter.
4. See `knowledge/agents/dev/code-reviewer.md` as a reference pattern.

## Related

- Reusable prompt templates: `knowledge/prompts/product/`
- Cross-tool wiring guidance: `knowledge/agents/README.md`
