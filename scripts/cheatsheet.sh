#!/bin/sh
# Show or hide a cheat sheet in a Quick Look panel: cheatsheet.sh vim|tmux
#
# Karabiner runs this on Space+v and Space+t; `just cheatsheet` runs it too.
# The same key again closes the panel; the other key swaps the sheet.
# Quick Look is built into macOS, so this needs no extra app. A panel started
# from a shell opens behind the current app, so it is brought to the front.
set -eu

sheet="${1:-vim}"
case "$sheet" in
  vim | tmux) ;;
  *) echo "usage: $0 vim|tmux" >&2; exit 2 ;;
esac
file="$(cd "$(dirname "$0")/../cheatsheet" && pwd -P)/$sheet.html"

if pgrep -f "qlmanage -p .*/$sheet.html" >/dev/null 2>&1; then
  pkill -x qlmanage
  exit 0
fi
pkill -x qlmanage 2>/dev/null || true

qlmanage -p "$file" >/dev/null 2>&1 &

# Wait for the panel's process, then make it the frontmost app.
i=0
while [ "$i" -lt 30 ]; do
  if osascript -e 'tell application "System Events" to set frontmost of (first process whose name is "qlmanage") to true' >/dev/null 2>&1; then
    exit 0
  fi
  i=$((i + 1))
  sleep 0.1
done
