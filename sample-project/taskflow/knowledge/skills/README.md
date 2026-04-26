# TaskFlow — knowledge/skills/

> **Skills are packaged domain expertise the AI loads dynamically when relevant.**
> Each skill is a directory containing a SKILL.md file with YAML frontmatter
> (name, description) plus instructions and optional scripts.

## Why Skills

Rules apply to every prompt. Agents are scoped roles. **Skills are the third
customization layer:** packaged expertise that the AI pulls in only when the
task matches the skill's description. This keeps the main context window clean
while giving the AI access to specialized knowledge on demand.

Anthropic published Agent Skills as an open standard in December 2025. Claude
Code, Cursor, and Antigravity all support the SKILL.md format.

## Folder Structure

Each skill lives in its own directory:

```
knowledge/skills/
├── README.md                            (this file)
├── taskflow-quality-gate-check/
│   └── SKILL.md
└── {your-skill-name}/
    └── SKILL.md
```

Skills can also include scripts, examples, and additional reference files
inside the skill directory. Use progressive disclosure — keep the SKILL.md
short and reference larger files only when needed.

## How to Add a New Skill

1. Create a new directory under `knowledge/skills/{your-skill-name}/`.
2. Add a `SKILL.md` file with YAML frontmatter (name, description) followed by
   the body.
3. Make the `description` field crisp — that's how AI tools decide when to
   load your skill.
4. Test by running a relevant prompt and verifying the skill loads.
5. Commit. Skills are team property once merged.

## Tool-specific Wiring

The `SKILL.md` file is portable. Each tool loads it differently:

- **Claude Code** — `.claude/skills/{name}/SKILL.md` (project) or
  `~/.claude/skills/{name}/SKILL.md` (user). Auto-loaded when relevant.
- **Antigravity** — `.agents/skills/{name}/SKILL.md`. Same dynamic-load model.
- **Cursor** — Same SKILL.md format. Loaded by Cursor automatically.
- **Gemini (Workspace)** — No native SKILL.md support. Use Gem knowledge files
  for similar effect.

When you create a skill in `knowledge/skills/`, you can copy or symlink it to
the tool-specific location your workflow uses.

## Naming

- Use lowercase with hyphens: `taskflow-quality-gate-check`, not `TaskFlowQualityGateCheck`.
- Name should describe what the skill *does*, not what it is.
