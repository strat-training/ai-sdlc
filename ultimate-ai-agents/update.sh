#!/bin/bash
# update.sh — Pull latest agents and re-install
#
# Usage:
#   ./update.sh              # Interactive (prompts for options)
#   TOOLS=claude ./update.sh # Non-interactive (same env vars as install.sh)
#
# If running from a cloned repo, pulls latest changes first.
# If running standalone, re-fetches from remote.

set -euo pipefail

# ─── Version ────────────────────────────────────────────────────────────────────
VERSION="1.0.0"
if [[ "${1:-}" == "--version" || "${1:-}" == "-v" ]]; then
  echo "ultimate-ai-agents $VERSION"
  exit 0
fi

# ─── Colors ─────────────────────────────────────────────────────────────────────
CYAN='\033[0;36m'
DIM='\033[2m'
BOLD='\033[1m'
RESET='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

echo ""
echo -e "${BOLD}${CYAN}  Updating Ultimate AI Agents${RESET}"
echo ""

# ─── If inside a git repo, pull latest ──────────────────────────────────────────
if [ -d "$SCRIPT_DIR/.git" ] || git -C "$SCRIPT_DIR" rev-parse --git-dir &>/dev/null 2>&1; then
  echo -e "  ${DIM}Pulling latest changes...${RESET}"

  BEFORE=$(git -C "$SCRIPT_DIR" rev-parse HEAD 2>/dev/null || echo "unknown")

  if git -C "$SCRIPT_DIR" pull --ff-only 2>/dev/null; then
    AFTER=$(git -C "$SCRIPT_DIR" rev-parse HEAD 2>/dev/null || echo "unknown")
    if [ "$BEFORE" = "$AFTER" ]; then
      echo -e "  ${GREEN}✓${RESET} Already up to date"
    else
      SHORT_BEFORE="${BEFORE:0:7}"
      SHORT_AFTER="${AFTER:0:7}"
      echo -e "  ${GREEN}✓${RESET} Updated ${DIM}${SHORT_BEFORE}${RESET} → ${BOLD}${SHORT_AFTER}${RESET}"

      # Show what changed
      echo ""
      echo -e "  ${DIM}Changes:${RESET}"
      git -C "$SCRIPT_DIR" log --oneline "${BEFORE}..${AFTER}" 2>/dev/null | while read -r line; do
        echo -e "    ${DIM}•${RESET} $line"
      done
    fi
  else
    echo -e "  ${YELLOW}!${RESET} Pull failed — you may have local changes"
    echo -e "  ${DIM}  Run: git -C $SCRIPT_DIR stash && git -C $SCRIPT_DIR pull${RESET}"
  fi
  echo ""
fi

# ─── Re-run installer ──────────────────────────────────────────────────────────
echo -e "  ${DIM}Re-running installer...${RESET}"
echo ""

# Pass through all env vars to install.sh
exec "$SCRIPT_DIR/install.sh" "$@"
