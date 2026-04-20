#!/bin/bash
# generate-platforms.sh — Generate platform-specific agent files from Claude source
# Claude agents (agents/claude/) are the source of truth.
# This generates:
#   agents/chatgpt/          — Clean prompts for ChatGPT Custom GPTs
#   agents/claude-projects/  — Clean prompts for Claude.ai Projects
#   agents/codex/            — AGENTS.md files for OpenAI Codex CLI

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

CLAUDE_DIR="agents/claude"
CHATGPT_DIR="agents/chatgpt"
CLAUDE_PROJ_DIR="agents/claude-projects"
CODEX_DIR="agents/codex"

# Load shared rules for Codex AGENTS.md
RULES_BLOCK=""
if [ -d "rules" ]; then
  for rf in rules/*.md; do
    [ -f "$rf" ] || continue
    rule_body=$(sed -n '/^---$/,/^---$/d; p' "$rf")
    RULES_BLOCK+="$rule_body"$'\n\n'
  done
fi

count=0

while IFS= read -r f; do
  # Get relative path from agents/claude/
  rel="${f#$CLAUDE_DIR/}"

  # Extract frontmatter fields
  name=$(sed -n 's/^name: *//p' "$f" | head -1)
  desc=$(sed -n 's/^description: *//p' "$f" | head -1)

  # Extract prompt body (everything after the closing ---)
  body=$(sed -n '/^---$/,/^---$/d; p' "$f")

  # ── ChatGPT format ──
  chatgpt_dir="$CHATGPT_DIR/$(dirname "$rel")"
  mkdir -p "$chatgpt_dir"
  cat > "$CHATGPT_DIR/$rel" <<EOF
# $name

> $desc

$body
EOF

  # ── Claude.ai Projects format ──
  proj_dir="$CLAUDE_PROJ_DIR/$(dirname "$rel")"
  mkdir -p "$proj_dir"
  cat > "$CLAUDE_PROJ_DIR/$rel" <<EOF
$body
EOF

  # ── Codex CLI format ──
  # Each agent becomes a standalone AGENTS.md (rules + persona)
  codex_dir="$CODEX_DIR/$(dirname "$rel")"
  mkdir -p "$codex_dir"
  cat > "$CODEX_DIR/$rel" <<EOF
# Project Rules

$RULES_BLOCK
# Agent: $name

$body
EOF

  count=$((count + 1))
done < <(find "$CLAUDE_DIR" -name "*.md" -type f | sort)

echo "Generated $count agents for ChatGPT, Claude Projects, and Codex CLI"
