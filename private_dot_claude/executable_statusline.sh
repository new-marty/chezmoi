#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# Colors
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
MAGENTA='\033[35m'
RESET='\033[0m'
DIM='\033[2m'
BOLD='\033[1m'

# Permission mode (written by PreToolUse hook)
MODE=$(cat /tmp/claude-mode 2>/dev/null)
case "$MODE" in
  plan)               MODE_DISPLAY="${BOLD}${MAGENTA}⏸ PLAN${RESET}" ;;
  bypassPermissions)  MODE_DISPLAY="${BOLD}${RED}⚡ YOLO${RESET}" ;;
  acceptEdits)        MODE_DISPLAY="${BOLD}${YELLOW}✎ AUTO-EDIT${RESET}" ;;
  default)            MODE_DISPLAY="${DIM}● NORMAL${RESET}" ;;
  *)                  MODE_DISPLAY="${DIM}● NORMAL${RESET}" ;;
esac

# Context bar color based on usage
if [ "$PCT" -ge 90 ]; then BAR_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then BAR_COLOR="$YELLOW"
else BAR_COLOR="$GREEN"; fi

# Build progress bar (20 chars wide)
BAR_WIDTH=20
FILLED=$((PCT * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))
BAR=$(printf "%${FILLED}s" | tr ' ' '█')$(printf "%${EMPTY}s" | tr ' ' '░')

# Git branch with status
GIT_INFO=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    STAGED=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    MODIFIED=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')

    GIT_STATUS=""
    [ "$STAGED" -gt 0 ] && GIT_STATUS="${GREEN}+${STAGED}${RESET}"
    [ "$MODIFIED" -gt 0 ] && GIT_STATUS="${GIT_STATUS}${YELLOW}~${MODIFIED}${RESET}"

    GIT_INFO=" ${DIM}│${RESET} 🌿 ${CYAN}${BRANCH}${RESET} ${GIT_STATUS}"
fi

# Line 1: Mode + Model, Directory, Git
printf '%b' "${MODE_DISPLAY}  ${CYAN}[${MODEL}]${RESET} 📁 ${DIR}${GIT_INFO}\n"

# Line 2: Context bar
printf '%b' "${BAR_COLOR}${BAR}${RESET} ${PCT}%\n"
