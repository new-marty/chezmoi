#!/usr/bin/env bash
# =============================================================================
# vendor-omz-plugins.sh - Copy the Oh My Zsh plugins of the work profile into
# the repository
# =============================================================================
# Usage: ./scripts/vendor-omz-plugins.sh
#
# The work profile (profile = "work" in chezmoi.toml) loads its zsh plugins
# with Oh My Zsh from ~/.zsh/omz-custom (dot_zsh/omz-custom here). The work Mac
# cannot run git clone, so the plugins are kept in the repository and chezmoi
# writes them as ordinary files. Run this on a machine that can clone, after
# changing a pin below, and commit the result.
#
# Only the files a shell loads and the licence are kept (the licence of
# zsh-history-substring-search is in its .zsh file). chezmoi skips source
# files whose names start with a dot, so those are stored as dot_<name>.
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
DEST="$ROOT_DIR/dot_zsh/omz-custom/plugins"

# name tag files... (paths relative to the plugin repository; globs allowed)
PLUGINS=(
    "zsh-autosuggestions v0.7.1 zsh-autosuggestions.zsh zsh-autosuggestions.plugin.zsh LICENSE"
    "zsh-history-substring-search v1.1.0 zsh-history-substring-search.zsh zsh-history-substring-search.plugin.zsh"
    "zsh-syntax-highlighting 0.8.0 zsh-syntax-highlighting.zsh zsh-syntax-highlighting.plugin.zsh .version .revision-hash highlighters/*/*-highlighter.zsh COPYING.md"
)

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

for entry in "${PLUGINS[@]}"; do
    read -r name tag files <<<"$entry"
    git -c advice.detachedHead=false clone --quiet --depth 1 --branch "$tag" \
        "https://github.com/zsh-users/$name.git" "$work/$name"
    commit="$(git -C "$work/$name" rev-parse HEAD)"
    rm -rf "${DEST:?}/$name"
    mkdir -p "$DEST/$name"
    (
        cd "$work/$name"
        # zsh-syntax-highlighting reads its commit from .revision-hash, which
        # only a `git archive` fills in; write it here instead.
        [ -f .revision-hash ] && echo "$commit" >.revision-hash
        # shellcheck disable=SC2086  # $files holds globs to expand
        for f in $files; do
            target="$DEST/$name/$(dirname "$f")/$(basename "$f" | sed 's/^\./dot_/')"
            mkdir -p "$(dirname "$target")"
            cp "$f" "$target"
        done
    )
    echo "$name $tag $commit"
done
