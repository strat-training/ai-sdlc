#!/bin/bash
# uninstall.sh — Remove Ultimate AI Agents from all tools
#
# Interactive:      ./uninstall.sh
# Non-interactive:  TOOLS=claude SCOPE=project ./uninstall.sh
#
# Options (via env vars — skip interactive prompts):
#   SCOPE=global|project     Where to uninstall from (default: project)
#   TOOLS=all|claude|cursor   Which tools to clean (default: all)

set -euo pipefail

# ─── Version ────────────────────────────────────────────────────────────────────
VERSION="1.0.0"
FORCE_INTERACTIVE=false
for arg in "$@"; do
  case "$arg" in
    --version|-v) echo "ultimate-ai-agents $VERSION"; exit 0 ;;
    --interactive|-i) FORCE_INTERACTIVE=true ;;
  esac
done

# ─── Ctrl-C handler ────────────────────────────────────────────────────────────
trap 'echo -e "\n\n  \033[2mCancelled.\033[0m\n"; exit 130' INT

# ─── Colors ───────────��────────────────────────────────��──────────────────────���─
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
DIM='\033[2m'
BOLD='\033[1m'
RESET='\033[0m'
CHECK="${GREEN}✓${RESET}"
CROSS="${RED}✗${RESET}"
DOT="${DIM}·${RESET}"

info()    { echo -e "  ${DOT} $1"; }
success() { echo -e "  ${CHECK} $1"; }
warn()    { echo -e "  ${YELLOW}!${RESET} $1"; }
header()  { echo -e "\n${BOLD}${BLUE}$1${RESET}"; }

SCOPE="${SCOPE:-}"
TOOLS="${TOOLS:-}"
REMOVED=0

# ─── Interactive prompts ────────────────────────────────────────────────────────
prompt_options() {
  if [ -n "$SCOPE" ] || [ -n "$TOOLS" ]; then return; fi
  if [ "$FORCE_INTERACTIVE" = false ] && ! [ -e /dev/tty ]; then return; fi

  echo ""
  echo -e "${BOLD}${RED}  Uninstall Ultimate AI Agents${RESET}"
  echo -e "  ${DIM}Press Ctrl-C at any time to quit${RESET}"
  echo ""

  # ── Scope ─��
  echo -e "  ${BOLD}Where to uninstall from?${RESET}"
  echo -e "    ${CYAN}1${RESET}) Current project ${DIM}(./.claude/, ./.cursor/, etc.)${RESET}"
  echo -e "    ${CYAN}2${RESET}) Global ${DIM}(~/.claude/, ~/.cursor/, etc.)${RESET}"
  echo ""
  printf "  Choice [1]: "
  read -r scope_choice </dev/tty
  case "${scope_choice:-1}" in
    2) SCOPE="global" ;;
    *) SCOPE="project" ;;
  esac
  echo ""

  # ── Tools ──
  echo -e "  ${BOLD}Which tools to remove?${RESET}"
  echo -e "    ${CYAN}1${RESET}) All tools"
  echo -e "    ${CYAN}2${RESET}) Let me pick..."
  echo ""
  printf "  Choice [1]: "
  read -r tools_choice </dev/tty
  echo ""

  case "${tools_choice:-1}" in
    2)
      TOOLS=""
      echo -e "  ${DIM}Select tools to remove (y/n for each):${RESET}"
      for tool in claude cursor codex amp gemini windsurf; do
        printf "    %-12s [y/N]: " "$tool"
        read -r yn </dev/tty
        if [[ "${yn:-n}" =~ ^[Yy] ]]; then
          if [ -n "$TOOLS" ]; then TOOLS="$TOOLS,$tool"; else TOOLS="$tool"; fi
        fi
      done
      if [ -z "$TOOLS" ]; then
        TOOLS="all"
        warn "No tools selected — removing all"
      fi
      echo ""
      ;;
    *) TOOLS="all" ;;
  esac

  # Confirm
  echo -e "  ${BOLD}─── Summary ───${RESET}"
  echo -e "  Scope: ${BOLD}$SCOPE${RESET}"
  echo -e "  Tools: ${BOLD}$TOOLS${RESET}"
  echo ""
  printf "  Proceed? [Y/n]: "
  read -r confirm </dev/tty
  if [[ "${confirm:-y}" =~ ^[Nn] ]]; then
    echo -e "\n  ${DIM}Cancelled.${RESET}\n"
    exit 0
  fi
}

# ─── Tool matching (supports comma-separated) ──────────────────────────────────
should_clean() {
  local tool="$1"
  if [ "$TOOLS" = "all" ] || [ "$TOOLS" = "$tool" ]; then return 0; fi
  if echo ",$TOOLS," | grep -q ",$tool,"; then return 0; fi
  return 1
}

# ─── Resolve dirs ─────���──────────────────────────────��─────────────────────────
resolve_dirs() {
  if [ "$SCOPE" = "global" ]; then
    CLAUDE_DIR="$HOME/.claude"
    CURSOR_DIR="$HOME/.cursor"
    AMP_DIR="$HOME/.amp"
    WINDSURF_DIR="$HOME/.codeium/windsurf"
    GEMINI_DIR="$HOME/.gemini"
    CODEX_DIR="$HOME/.codex"
  else
    CLAUDE_DIR="./.claude"
    CURSOR_DIR="./.cursor"
    AMP_DIR="./.amp"
    WINDSURF_DIR="./.codeium/windsurf"
    GEMINI_DIR="./.gemini"
    CODEX_DIR="."
  fi
}

# ─── Clean functions ─────────���─────────────────────────────────────────────────
clean_claude() {
  should_clean claude || return 0
  header "Claude Code"

  for dir in agents commands rules skills; do
    if [ -d "$CLAUDE_DIR/$dir" ]; then
      rm -rf "$CLAUDE_DIR/$dir"
      success "Removed $CLAUDE_DIR/$dir/"
      REMOVED=$((REMOVED + 1))
    fi
  done

  if [ -f "$CLAUDE_DIR/settings.json" ]; then
    info "Kept settings.json ${DIM}(may contain custom config)${RESET}"
  fi
}

clean_cursor() {
  should_clean cursor || return 0
  header "Cursor"

  if [ -d "$CURSOR_DIR/rules" ]; then
    rm -rf "$CURSOR_DIR/rules"
    success "Removed $CURSOR_DIR/rules/"
    REMOVED=$((REMOVED + 1))
  else
    info "Nothing to remove"
  fi
}

clean_amp() {
  should_clean amp || return 0
  header "Amp Code"

  if [ -d "$AMP_DIR/commands" ]; then
    rm -rf "$AMP_DIR/commands"
    success "Removed $AMP_DIR/commands/"
    REMOVED=$((REMOVED + 1))
  else
    info "Nothing to remove"
  fi
}

clean_windsurf() {
  should_clean windsurf || return 0
  header "Windsurf"

  local rules_file="$WINDSURF_DIR/memories/global_rules.md"
  local marker="## Ultimate AI Agents"

  if [ -f "$rules_file" ] && grep -q "$marker" "$rules_file" 2>/dev/null; then
    sed -i.bak "/$marker/,\$d" "$rules_file"
    rm -f "$rules_file.bak"
    success "Removed agents section from global_rules.md"
    REMOVED=$((REMOVED + 1))
  else
    info "Nothing to remove"
  fi
}

clean_gemini() {
  should_clean gemini || return 0
  header "Gemini CLI"

  if [ -d "$GEMINI_DIR/commands" ]; then
    rm -rf "$GEMINI_DIR/commands"
    success "Removed $GEMINI_DIR/commands/"
    REMOVED=$((REMOVED + 1))
  else
    info "Nothing to remove"
  fi
}

clean_codex() {
  should_clean codex || return 0
  header "Codex CLI"

  local agents_file="$CODEX_DIR/AGENTS.md"
  if [ -f "$agents_file" ] && grep -q "Auto-generated by Ultimate AI Agents" "$agents_file" 2>/dev/null; then
    rm -f "$agents_file"
    success "Removed $agents_file"
    REMOVED=$((REMOVED + 1))
  else
    info "Nothing to remove (AGENTS.md not ours or doesn't exist)"
  fi
}

# ─── Main ──────────────────────────���─────────────────────────��─────────────────
main() {
  prompt_options

  # Apply defaults
  SCOPE="${SCOPE:-project}"
  TOOLS="${TOOLS:-all}"

  # Non-interactive banner
  if [ ! -t 0 ] || [ -n "${SKIP_BANNER:-}" ]; then
    echo ""
    echo -e "${BOLD}${RED}  Uninstall Ultimate AI Agents${RESET}"
    echo -e "  ${DIM}Scope: $SCOPE · Tools: $TOOLS${RESET}"
  fi

  resolve_dirs

  clean_claude
  clean_cursor
  clean_amp
  clean_windsurf
  clean_gemini
  clean_codex

  echo ""
  echo -e "${BOLD}─────────────────���───────────────────────────${RESET}"
  echo ""
  if [ $REMOVED -gt 0 ]; then
    success "${BOLD}Cleaned ${REMOVED} tool(s)${RESET}"
  else
    info "Nothing to uninstall"
  fi
  echo ""
}

main "$@"
