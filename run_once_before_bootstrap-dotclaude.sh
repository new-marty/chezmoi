#!/bin/bash
# Turn ~/.claude into a working copy of github.com:new-marty/dotclaude.
#
# ~/.claude holds Claude Code's user-level configuration (global instructions,
# skills, output styles, settings) mixed with runtime state (session logs,
# caches, OAuth tokens). The configuration lives in its own git repository
# rather than under chezmoi, because it is edited on every machine that uses it
# and therefore needs git's merge and conflict handling. chezmoi's only job is
# to connect ~/.claude to that repository; the .gitignore inside the repository
# decides what is tracked.
#
# Cloning is not an option: the Claude Code installer and any earlier session
# leave files in ~/.claude, and git clone refuses a non-empty directory. This
# initialises the repository in place instead.
set -euo pipefail

DIR="$HOME/.claude"
REMOTE="git@github.com:new-marty/dotclaude.git"

# Treat the setup as done only once the remote branch is actually present.
# Checking for .git alone would leave a directory whose fetch failed — after a
# network error, say — permanently half-configured.
if git -C "$DIR" rev-parse --verify -q refs/remotes/origin/main >/dev/null 2>&1; then
    exit 0
fi

echo "Connecting ~/.claude to ${REMOTE}"
mkdir -p "$DIR"
[ -d "$DIR/.git" ] || git -C "$DIR" init -q -b main

if git -C "$DIR" remote get-url origin >/dev/null 2>&1; then
    git -C "$DIR" remote set-url origin "$REMOTE"
else
    git -C "$DIR" remote add origin "$REMOTE"
fi

git -C "$DIR" fetch -q origin main
git -C "$DIR" branch -q -f main origin/main
git -C "$DIR" symbolic-ref HEAD refs/heads/main
git -C "$DIR" branch -q -u origin/main main
git -C "$DIR" reset -q origin/main

# Write out the tracked files that this machine does not have yet.
# checkout-index without -f skips paths that already exist and exits non-zero
# when it does, which is the wanted behaviour: a file this machine already has
# is kept and shows up as a local modification instead of being replaced by the
# remote copy without a trace. "reset --hard" would overwrite it silently.
if ! co_out=$(git -C "$DIR" checkout-index -a 2>&1); then
    echo "$co_out" | grep -v 'already exists, no checkout' >&2 || true
fi

if [ -n "$(git -C "$DIR" status --porcelain)" ]; then
    echo "~/.claude already had content that differs from the remote."
    echo "Review and reconcile it with:"
    echo "    git -C ~/.claude status"
    echo "    git -C ~/.claude diff"
fi
