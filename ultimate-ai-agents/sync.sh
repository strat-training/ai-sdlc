#!/bin/bash
# sync.sh — Sync canonical source agents/ to tool-specific config folders
# Run this after editing any file in agents/, commands/, or rules/

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "=== Syncing to .claude/ ==="

# Agents: flatten agents/claude/ (all subdirs) into .claude/agents/
rm -f .claude/agents/*.md
while IFS= read -r f; do
  cp "$f" ".claude/agents/$(basename "$f")"
  echo "  agents/$(basename "$f")"
done < <(find agents/claude -name "*.md" -type f | sort)

# Commands
rm -f .claude/commands/*.md
cp commands/*.md .claude/commands/
echo "  commands/ → .claude/commands/"

# Rules
rm -f .claude/rules/*.md
cp rules/*.md .claude/rules/
echo "  rules/ → .claude/rules/"

echo ""
echo "=== Syncing to .cursor/rules/ ==="

# Cursor: flatten agents/cursor/ into .cursor/rules/
mkdir -p .cursor/rules
rm -f .cursor/rules/*.mdc
while IFS= read -r f; do
  cp "$f" ".cursor/rules/$(basename "$f")"
  echo "  $(basename "$f")"
done < <(find agents/cursor -name "*.mdc" -type f | sort)

echo ""
echo "Done. Claude Code and Cursor configs are up to date."
echo "Gemini gems live at agents/gemini/ — no sync needed."
