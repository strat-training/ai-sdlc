#!/bin/bash
# install.sh — One-liner installer for Ultimate AI Agents
#
# Interactive:  ./install.sh           (prompts for options)
# Non-interactive: TOOLS=claude DEPT=engineering ./install.sh
# Pipe-friendly:   curl -fsSL .../install.sh | bash
#
# Options (via env vars — skip interactive prompts):
#   SCOPE=global|project     Where to install (default: project)
#   DEPT=all|engineering|...  Which department agents to install (default: all)
#   TOOLS=all|claude|cursor   Which tools to target (default: auto-detect)
#   BRANCH=main               Git branch to pull from (default: main)

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

# ─── Cleanup & Ctrl-C ──────────────────────────────────────────────────────────
TMPDIR=""
cleanup() { [ -n "$TMPDIR" ] && rm -rf "$TMPDIR" 2>/dev/null || true; }
trap 'cleanup; echo -e "\n\n  \033[2mCancelled.\033[0m\n"; exit 130' INT
trap 'cleanup' EXIT

# ─── Colors & Symbols ──────────────────────────────────────────────────────────
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
ARROW="${CYAN}→${RESET}"
DOT="${DIM}·${RESET}"

# ─── Config ─────────────────────────────────────────────────────────────────────
REPO_URL="${REPO_URL:-}"
BRANCH="${BRANCH:-}"
SCOPE="${SCOPE:-}"
DEPT="${DEPT:-}"
TOOLS="${TOOLS:-}"
INSTALL_COUNT=0
TOOL_COUNT=0
INTERACTIVE=false

# Defaults (applied after interactive prompts or when env vars are empty)
DEFAULT_REPO_URL="https://github.com/stratpoint-engineering/ultimate-ai-agents.git"
DEFAULT_BRANCH="main"

# All valid departments
VALID_DEPTS="engineering product-design project-management sales marketing hr l-and-d finance operations admin leadership"

# ─── Interactive prompts ────────────────────────────────────────────────────────
prompt_options() {
  # Go interactive if /dev/tty is available (works even when script is piped via curl)
  # Skip if env vars are set (non-interactive mode)
  if [ -n "$SCOPE" ] || [ -n "$TOOLS" ] || [ -n "$DEPT" ]; then return; fi
  if [ "$FORCE_INTERACTIVE" = false ] && ! [ -e /dev/tty ]; then return; fi

  INTERACTIVE=true

  # ── Scope ──
  echo -e "  ${BOLD}Where to install?${RESET}"
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
  echo -e "  ${BOLD}Which tools?${RESET}"
  echo -e "    ${CYAN}1${RESET}) Auto-detect installed tools"
  echo -e "    ${CYAN}2${RESET}) All tools"
  echo -e "    ${CYAN}3${RESET}) Let me pick..."
  echo ""
  printf "  Choice [1]: "
  read -r tools_choice </dev/tty
  echo ""

  case "${tools_choice:-1}" in
    2) TOOLS="all" ;;
    3)
      TOOLS=""
      echo -e "  ${DIM}Select tools (y/n for each):${RESET}"
      for tool in claude cursor codex amp gemini windsurf; do
        printf "    %-12s [y/N]: " "$tool"
        read -r yn </dev/tty
        if [[ "${yn:-n}" =~ ^[Yy] ]]; then
          if [ -n "$TOOLS" ]; then TOOLS="$TOOLS,$tool"; else TOOLS="$tool"; fi
        fi
      done
      if [ -z "$TOOLS" ]; then
        TOOLS="auto"
        warn "No tools selected — falling back to auto-detect"
      fi
      echo ""
      ;;
    *) TOOLS="auto" ;;
  esac

  # ── Department ──
  echo -e "  ${BOLD}Which departments?${RESET}"
  echo -e "    ${CYAN}1${RESET}) Engineering ${DIM}(default)${RESET}"
  echo -e "    ${CYAN}2${RESET}) All departments"
  echo -e "    ${CYAN}3${RESET}) Let me pick..."
  echo ""
  printf "  Choice [1]: "
  read -r dept_choice </dev/tty
  echo ""

  case "${dept_choice:-1}" in
    2) DEPT="all" ;;
    3)
      echo -e "  ${DIM}Available departments:${RESET}"
      local i=1
      local dept_arr=()
      for d in $VALID_DEPTS; do
        dept_arr+=("$d")
        local label
        case "$d" in
          engineering)         label="Engineering" ;;
          product-design)      label="Product & Design" ;;
          project-management)  label="Project Management" ;;
          sales)               label="Sales" ;;
          marketing)           label="Marketing" ;;
          hr)                  label="HR" ;;
          l-and-d)             label="L&D" ;;
          finance)             label="Finance" ;;
          operations)          label="Operations" ;;
          admin)               label="Admin" ;;
          leadership)          label="Leadership" ;;
          *)                   label="$d" ;;
        esac
        printf "    ${CYAN}%2d${RESET}) %s\n" "$i" "$label"
        i=$((i + 1))
      done
      echo ""
      printf "  Enter number: "
      read -r dept_num </dev/tty
      if [ -n "$dept_num" ] && [ "$dept_num" -ge 1 ] 2>/dev/null && [ "$dept_num" -le "${#dept_arr[@]}" ] 2>/dev/null; then
        DEPT="${dept_arr[$((dept_num - 1))]}"
      else
        DEPT="all"
        warn "Invalid selection — installing all departments"
      fi
      echo ""
      ;;
    *) DEPT="engineering" ;;
  esac

  # Confirm
  echo -e "  ${BOLD}─── Summary ───${RESET}"
  echo -e "  Scope: ${BOLD}$SCOPE${RESET}"
  echo -e "  Tools: ${BOLD}$TOOLS${RESET}"
  echo -e "  Dept:  ${BOLD}$DEPT${RESET}"
  echo ""
  printf "  Proceed? [Y/n]: "
  read -r confirm </dev/tty
  if [[ "${confirm:-y}" =~ ^[Nn] ]]; then
    echo -e "\n  ${DIM}Cancelled.${RESET}\n"
    exit 0
  fi
}

# Check if TOOLS contains a specific tool (supports comma-separated list)
tools_contains() {
  local tool="$1"
  if [ "$TOOLS" = "all" ] || [ "$TOOLS" = "$tool" ]; then return 0; fi
  if echo "$TOOLS" | grep -q "$tool"; then return 0; fi
  return 1
}

# ─── Helpers ────────────────────────────────────────────────────────────────────
info()    { echo -e "  ${DOT} $1"; }
success() { echo -e "  ${CHECK} $1"; }
warn()    { echo -e "  ${YELLOW}!${RESET} $1"; }
fail()    { echo -e "  ${CROSS} $1"; }
header()  { echo -e "\n${BOLD}${BLUE}$1${RESET}"; }
step()    { echo -e "  ${ARROW} $1"; }

banner() {
  local v="v${VERSION}"
  local v_pad=$(( (36 - ${#v}) / 2 ))
  local v_right=$(( 36 - v_pad - ${#v} ))
  echo ""
  echo -e "${BOLD}${CYAN}"
  echo "  +------------------------------------+"
  echo "  |                                    |"
  echo "  |    Ultimate AI Agents Installer    |"
  printf "  |%*s%s%*s|\n" "$v_pad" "" "$v" "$v_right" ""
  echo "  |                                    |"
  echo "  +------------------------------------+"
  echo -e "${RESET}"
  echo -e "  ${DIM}Claude Code · Cursor · Codex · Gemini · Amp · Windsurf${RESET}"
  echo -e "  ${DIM}Press Ctrl-C at any time to quit${RESET}"
  echo ""
}

# ─── Preflight ──────────────────────────────────────────────────────────────────
preflight() {
  header "Preflight checks"

  if ! command -v git &>/dev/null; then
    fail "git is required but not installed"
    exit 1
  fi
  success "git found"

  # Validate department
  if [ "$DEPT" != "all" ]; then
    local valid=false
    for d in $VALID_DEPTS; do
      if [ "$d" = "$DEPT" ]; then valid=true; break; fi
    done
    if [ "$valid" = false ]; then
      fail "Invalid department: $DEPT"
      echo -e "  ${DIM}Valid: all $VALID_DEPTS${RESET}"
      exit 1
    fi
    info "Department filter: ${BOLD}$DEPT${RESET}"
  else
    info "Installing all departments"
  fi

  info "Scope: ${BOLD}$SCOPE${RESET}"
  info "Branch: ${BOLD}$BRANCH${RESET}"
}

# ─── Clone / Download ──────────────────────────────────────────────────────────
fetch_repo() {
  header "Fetching agents"
  TMPDIR=$(mktemp -d)

  step "Cloning ${DIM}$REPO_URL${RESET} ${DIM}($BRANCH)${RESET}"
  if git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$TMPDIR/repo" 2>/dev/null; then
    success "Repository cloned to temp directory"
    SRC="$TMPDIR/repo"
  else
    # Fallback: check if we're running from inside the repo
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
    if [ -d "$SCRIPT_DIR/agents" ] && [ -d "$SCRIPT_DIR/commands" ]; then
      warn "Clone failed — using local repo at ${DIM}$SCRIPT_DIR${RESET}"
      SRC="$SCRIPT_DIR"
      # No temp dir needed — clear it so cleanup skips
      rm -rf "$TMPDIR"
      TMPDIR=""
    else
      fail "Could not fetch repository. Run from inside the repo or set REPO_URL."
      exit 1
    fi
  fi
}

# ─── Collect files by tool and department filter ───────────────────────────────
# Structure: agents/<tool>/<dept>/...
# Claude agents: agents/claude/<dept>/**/*.md
# Cursor rules:  agents/cursor/<category>/*.mdc
# Gemini gems:   agents/gemini/<dept>/**/*.md

collect_agents() {
  CLAUDE_AGENTS=()
  GEMINI_GEMS=()
  CURSOR_RULES=()

  # Claude agents: agents/claude/<dept>/**/*.md
  local claude_dir="$SRC/agents/claude"
  if [ -d "$claude_dir" ]; then
    if [ "$DEPT" = "all" ]; then
      while IFS= read -r f; do CLAUDE_AGENTS+=("$f"); done < <(find "$claude_dir" -name "*.md" -type f 2>/dev/null | sort)
    else
      local dept_dir="$claude_dir/$DEPT"
      [ -d "$dept_dir" ] && while IFS= read -r f; do CLAUDE_AGENTS+=("$f"); done < <(find "$dept_dir" -name "*.md" -type f 2>/dev/null | sort)
    fi
  fi

  # Gemini gems: agents/gemini/<dept>/**/*.md
  local gemini_dir="$SRC/agents/gemini"
  if [ -d "$gemini_dir" ]; then
    if [ "$DEPT" = "all" ]; then
      while IFS= read -r f; do GEMINI_GEMS+=("$f"); done < <(find "$gemini_dir" -name "*.md" -type f 2>/dev/null | sort)
    else
      local dept_dir="$gemini_dir/$DEPT"
      [ -d "$dept_dir" ] && while IFS= read -r f; do GEMINI_GEMS+=("$f"); done < <(find "$dept_dir" -name "*.md" -type f 2>/dev/null | sort)
    fi
  fi

  # Cursor rules: agents/cursor/<category>/*.mdc — always collect all (not dept-filtered)
  local cursor_dir="$SRC/agents/cursor"
  if [ -d "$cursor_dir" ]; then
    while IFS= read -r f; do CURSOR_RULES+=("$f"); done < <(find "$cursor_dir" -name "*.mdc" -type f 2>/dev/null | sort)
  fi

  info "Found ${BOLD}${#CLAUDE_AGENTS[@]}${RESET} Claude agents, ${BOLD}${#CURSOR_RULES[@]}${RESET} Cursor rules, ${BOLD}${#GEMINI_GEMS[@]}${RESET} Gemini gems"
}

# ─── Resolve target directories ────────────────────────────────────────────────
resolve_targets() {
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

# ─── Tool detection ────────────────────────────────────────────────────────────
should_install() {
  local tool="$1"
  if [ "$TOOLS" = "all" ]; then return 0; fi
  if [ "$TOOLS" = "$tool" ]; then return 0; fi
  # Support comma-separated list from interactive mode (e.g., "claude,cursor,codex")
  if echo ",$TOOLS," | grep -q ",$tool,"; then return 0; fi
  if [ "$TOOLS" = "auto" ]; then
    case "$tool" in
      claude)   command -v claude &>/dev/null || [ -d "$HOME/.claude" ] && return 0 ;;
      cursor)   [ -d "$HOME/.cursor" ] || command -v cursor &>/dev/null && return 0 ;;
      amp)      command -v amp &>/dev/null || [ -d "$HOME/.amp" ] && return 0 ;;
      windsurf) [ -d "$HOME/.codeium" ] && return 0 ;;
      gemini)   command -v gemini &>/dev/null || [ -d "$HOME/.gemini" ] && return 0 ;;
      codex)    command -v codex &>/dev/null || [ -d "$HOME/.codex" ] && return 0 ;;
    esac
    return 1
  fi
  return 1
}

# ─── Install: Claude Code ──────────────────────────────────────────────────────
install_claude() {
  if ! should_install claude; then return 0; fi

  header "Claude Code"
  TOOL_COUNT=$((TOOL_COUNT + 1))
  local count=0

  # Agents (from agents/claude/)
  mkdir -p "$CLAUDE_DIR/agents"
  for f in "${CLAUDE_AGENTS[@]}"; do
    local name
    name=$(basename "$f")
    cp "$f" "$CLAUDE_DIR/agents/$name"
    count=$((count + 1))
  done
  success "${count} agents ${ARROW} ${DIM}$CLAUDE_DIR/agents/${RESET}"

  # Commands/Workflows
  if [ -d "$SRC/commands" ]; then
    mkdir -p "$CLAUDE_DIR/commands"
    local cmd_count=0
    for f in "$SRC"/commands/*.md; do
      [ -f "$f" ] || continue
      cp "$f" "$CLAUDE_DIR/commands/$(basename "$f")"
      cmd_count=$((cmd_count + 1))
    done
    success "${cmd_count} workflows ${ARROW} ${DIM}$CLAUDE_DIR/commands/${RESET}"
    count=$((count + cmd_count))
  fi

  # Rules
  if [ -d "$SRC/rules" ]; then
    mkdir -p "$CLAUDE_DIR/rules"
    local rule_count=0
    for f in "$SRC"/rules/*.md; do
      [ -f "$f" ] || continue
      cp "$f" "$CLAUDE_DIR/rules/$(basename "$f")"
      rule_count=$((rule_count + 1))
    done
    success "${rule_count} rules ${ARROW} ${DIM}$CLAUDE_DIR/rules/${RESET}"
    count=$((count + rule_count))
  fi

  # Skills
  if [ -d "$SRC/.claude/skills" ]; then
    local skill_count=0
    for skill_dir in "$SRC"/.claude/skills/*/; do
      [ -d "$skill_dir" ] || continue
      local skill_name
      skill_name=$(basename "$skill_dir")
      mkdir -p "$CLAUDE_DIR/skills/$skill_name"
      cp "$skill_dir"* "$CLAUDE_DIR/skills/$skill_name/" 2>/dev/null || true
      skill_count=$((skill_count + 1))
    done
    if [ $skill_count -gt 0 ]; then
      success "${skill_count} skills ${ARROW} ${DIM}$CLAUDE_DIR/skills/${RESET}"
      count=$((count + skill_count))
    fi
  fi

  # Settings (only if no settings.json exists yet)
  if [ ! -f "$CLAUDE_DIR/settings.json" ] && [ -f "$SRC/.claude/settings.json" ]; then
    cp "$SRC/.claude/settings.json" "$CLAUDE_DIR/settings.json"
    success "settings.json ${ARROW} ${DIM}$CLAUDE_DIR/${RESET}"
  elif [ -f "$CLAUDE_DIR/settings.json" ]; then
    info "settings.json already exists — skipped ${DIM}(won't overwrite)${RESET}"
  fi

  INSTALL_COUNT=$((INSTALL_COUNT + count))
}

# ─── Install: Cursor ───────────────────────────────────────────────────────────
install_cursor() {
  if ! should_install cursor; then return 0; fi

  header "Cursor"
  TOOL_COUNT=$((TOOL_COUNT + 1))
  local count=0

  if [ ${#CURSOR_RULES[@]} -gt 0 ]; then
    mkdir -p "$CURSOR_DIR/rules"
    for f in "${CURSOR_RULES[@]}"; do
      local name
      name=$(basename "$f")
      if [ -f "$CURSOR_DIR/rules/$name" ]; then
        info "${name} already exists — skipped"
      else
        cp "$f" "$CURSOR_DIR/rules/$name"
        count=$((count + 1))
      fi
    done
    success "${count} rules ${ARROW} ${DIM}$CURSOR_DIR/rules/${RESET}"
  else
    warn "No Cursor rules found in repo"
  fi

  INSTALL_COUNT=$((INSTALL_COUNT + count))
}

# ─── Install: Amp Code ─────────────────────────────────────────────────────────
install_amp() {
  if ! should_install amp; then return 0; fi

  header "Amp Code"
  TOOL_COUNT=$((TOOL_COUNT + 1))
  local count=0

  # Amp uses the same commands/ format as Claude Code
  mkdir -p "$AMP_DIR/commands"
  for f in "$SRC"/commands/*.md; do
    [ -f "$f" ] || continue
    cp "$f" "$AMP_DIR/commands/$(basename "$f")"
    count=$((count + 1))
  done
  success "${count} workflows ${ARROW} ${DIM}$AMP_DIR/commands/${RESET}"

  INSTALL_COUNT=$((INSTALL_COUNT + count))
}

# ─── Install: Windsurf ─────────────────────────────────────────────────────────
install_windsurf() {
  if ! should_install windsurf; then return 0; fi

  header "Windsurf"
  TOOL_COUNT=$((TOOL_COUNT + 1))

  local rules_file="$WINDSURF_DIR/memories/global_rules.md"
  local marker="## Ultimate AI Agents"

  mkdir -p "$WINDSURF_DIR/memories"

  if [ -f "$rules_file" ] && grep -q "$marker" "$rules_file" 2>/dev/null; then
    info "Already installed — skipped ${DIM}(remove '$marker' section to reinstall)${RESET}"
    return 0
  fi

  # Append rules to global_rules.md
  {
    echo ""
    echo "$marker"
    echo ""
    for f in "$SRC"/rules/*.md; do
      [ -f "$f" ] || continue
      echo "### $(basename "$f" .md)"
      echo ""
      # Strip frontmatter
      sed -n '/^---$/,/^---$/!p' "$f"
      echo ""
    done
  } >> "$rules_file"

  success "Rules appended ${ARROW} ${DIM}$rules_file${RESET}"
  INSTALL_COUNT=$((INSTALL_COUNT + 1))
}

# ─── Install: Gemini CLI ───────────────────────────────────────────────────────
install_gemini() {
  if ! should_install gemini; then return 0; fi

  header "Gemini CLI"
  TOOL_COUNT=$((TOOL_COUNT + 1))
  local count=0

  if [ ${#GEMINI_GEMS[@]} -gt 0 ]; then
    mkdir -p "$GEMINI_DIR/commands"
    for f in "${GEMINI_GEMS[@]}"; do
      local name
      name=$(basename "$f" .md)
      local desc
      desc=$(grep -m1 "^description:" "$f" 2>/dev/null | sed 's/^description: *//' || echo "$name agent")
      local content
      content=$(sed -n '/^---$/,/^---$/!p' "$f")

      # Write as TOML for Gemini CLI
      cat > "$GEMINI_DIR/commands/$name.toml" <<TOML
description = "$desc"

[prompt]
content = """
$content
"""
TOML
      count=$((count + 1))
    done
    success "${count} gems ${ARROW} ${DIM}$GEMINI_DIR/commands/${RESET}"
  else
    warn "No Gemini gems found in agents/gemini/"
  fi

  INSTALL_COUNT=$((INSTALL_COUNT + count))
}

# ─── Install: Codex CLI ─────────────────────────────────────────────────────────
install_codex() {
  if ! should_install codex; then return 0; fi

  header "Codex CLI"
  TOOL_COUNT=$((TOOL_COUNT + 1))
  local count=0

  # Codex uses a single AGENTS.md — install rules as global guidance
  if [ "$SCOPE" = "global" ]; then
    mkdir -p "$CODEX_DIR"
    local agents_file="$CODEX_DIR/AGENTS.md"
  else
    local agents_file="$CODEX_DIR/AGENTS.md"
  fi

  # Build AGENTS.md with rules
  if [ -d "$SRC/rules" ]; then
    {
      echo "# Project Rules"
      echo ""
      echo "> Auto-generated by Ultimate AI Agents installer"
      echo ""
      for f in "$SRC"/rules/*.md; do
        [ -f "$f" ] || continue
        sed -n '/^---$/,/^---$/d; p' "$f"
        echo ""
      done
    } > "$agents_file"
    success "Rules ${ARROW} ${DIM}$agents_file${RESET}"
    count=$((count + 1))
  fi

  # Copy per-agent AGENTS.md files for easy swapping
  local codex_agents_dir="$SRC/agents/codex"
  if [ -d "$codex_agents_dir" ]; then
    local agent_count
    agent_count=$(find "$codex_agents_dir" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
    info "${agent_count} agent files available in agents/codex/"
    info "To use an agent: ${DIM}cp agents/codex/<dept>/<agent>.md AGENTS.md${RESET}"
  fi

  INSTALL_COUNT=$((INSTALL_COUNT + count))
}

# ─── Summary ────────────────────────────────────────────────────────────────────
summary() {
  echo ""
  echo -e "${BOLD}─────────────────────────────────────────────${RESET}"

  if [ $TOOL_COUNT -eq 0 ]; then
    echo ""
    fail "No supported tools detected!"
    echo ""
    echo -e "  Supported tools:"
    echo -e "    ${DIM}•${RESET} Claude Code  ${DIM}(claude)${RESET}"
    echo -e "    ${DIM}•${RESET} Cursor       ${DIM}(cursor)${RESET}"
    echo -e "    ${DIM}•${RESET} Amp Code     ${DIM}(amp)${RESET}"
    echo -e "    ${DIM}•${RESET} Windsurf     ${DIM}(windsurf)${RESET}"
    echo -e "    ${DIM}•${RESET} Gemini CLI   ${DIM}(gemini)${RESET}"
    echo -e "    ${DIM}•${RESET} Codex CLI    ${DIM}(codex)${RESET}"
    echo ""
    echo -e "  Force install for a specific tool:"
    echo -e "    ${DIM}TOOLS=claude ./install.sh${RESET}"
    echo ""
    exit 1
  fi

  echo ""
  success "${BOLD}Installed ${INSTALL_COUNT} files across ${TOOL_COUNT} tool(s)${RESET}"
  echo ""

  # Usage hints
  echo -e "  ${BOLD}Quick start:${RESET}"
  echo ""
  if should_install claude 2>/dev/null; then
    echo -e "    ${DIM}# Use any agent${RESET}"
    echo -e "    claude ${CYAN}@code-reviewer${RESET} review this PR"
    echo -e "    claude ${CYAN}@sales-strategist${RESET} draft a proposal"
    echo ""
    echo -e "    ${DIM}# Run a workflow${RESET}"
    echo -e "    ${CYAN}/project:workflow-review-code${RESET}"
    echo ""
  fi
  if should_install cursor 2>/dev/null; then
    echo -e "    ${DIM}# Cursor rules auto-activate by file path${RESET}"
    echo ""
  fi

  if [ -n "$TMPDIR" ]; then
    info "Temp files cleaned up"
  fi

  echo -e "  ${DIM}Docs: https://github.com/stratpoint/ultimate-ai-agents${RESET}"
  echo -e "  ${DIM}Update: re-run this installer to pull latest changes${RESET}"
  echo ""
}

# ─── Main ───────────────────────────────────────────────────────────────────────
main() {
  banner
  prompt_options

  # Apply defaults for anything not set (non-interactive or after prompts)
  REPO_URL="${REPO_URL:-$DEFAULT_REPO_URL}"
  BRANCH="${BRANCH:-$DEFAULT_BRANCH}"
  SCOPE="${SCOPE:-project}"
  DEPT="${DEPT:-engineering}"
  TOOLS="${TOOLS:-auto}"

  preflight
  fetch_repo
  collect_agents
  resolve_targets

  install_claude
  install_cursor
  install_amp
  install_windsurf
  install_gemini
  install_codex

  summary
}

main "$@"
