#!/bin/sh
# Show or hide a cheat sheet in a floating window: cheatsheet.sh vim|tmux
#
# Karabiner runs this on Space+v and Space+t; `just cheatsheet` runs it too.
# The same key again closes the window; the other key swaps the sheet.
# The window (scripts/cheatsheet-window.js) uses JavaScript for Automation,
# which ships with macOS, so this needs no extra app. It floats above other
# apps' windows until it is closed.
set -eu

sheet="${1:-vim}"
case "$sheet" in
  vim | tmux) ;;
  *) echo "usage: $0 vim|tmux" >&2; exit 2 ;;
esac
# -P resolves symlinks first: Karabiner calls this through ~/.config/karabiner/..
root="$(cd -P "$(dirname "$0")" && cd -P .. && pwd -P)"
file="$root/cheatsheet/$sheet.html"

if pgrep -f "^osascript -l JavaScript .*/cheatsheet-window.js $file" >/dev/null 2>&1; then
  pkill -f "^osascript -l JavaScript .*/cheatsheet-window.js $file"
  exit 0
fi
pkill -f "^osascript -l JavaScript .*/cheatsheet-window.js" 2>/dev/null || true
nohup osascript -l JavaScript "$root/scripts/cheatsheet-window.js" "$file" >/dev/null 2>&1 &
