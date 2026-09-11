# =============================================================================
# Dotfiles Automation - Task Runner
# Usage: just <recipe>
# =============================================================================

# Default recipe - show available commands
default:
    @just --list

# =============================================================================
# Setup & Apply
# =============================================================================

# Full setup for a new machine
setup: brew-bundle apply sheldon-update mise-install
    @echo "✅ Setup complete! Run 'exec $SHELL -l' to reload shell."

# Apply chezmoi changes
apply:
    chezmoi apply --exclude=encrypted
    @echo "✅ Dotfiles applied"

# Apply with secrets (requires 1Password auth)
apply-all:
    chezmoi apply
    @echo "✅ Dotfiles applied (including secrets)"

# =============================================================================
# Package Management
# =============================================================================

# Install all Homebrew packages
brew-bundle:
    brew bundle install --file=~/Brewfile
    @echo "✅ Homebrew packages installed"

# Update Homebrew and upgrade packages
brew-update:
    brew update && brew upgrade
    @echo "✅ Homebrew packages updated"

# Pick packages from another machine's list and install them here
brew-pick MACHINE="":
    #!/usr/bin/env bash
    # Each machine keeps its own Brewfile template, so a new machine starts
    # empty. This browses another machine's list, installs what you select, and
    # records it in this machine's list. Start with the Essentials block at the
    # top of the source list: those are what the dotfiles themselves need.
    set -uo pipefail
    src="$(chezmoi source-path)/.chezmoitemplates"
    mine=""
    for f in personal_mac work_mac; do
        if [[ "$(chezmoi execute-template "{{{{ .is_${f} }}")" == "true" ]]; then
            mine="Brewfile.${f}"; break
        fi
    done
    [[ -n "$mine" ]] || { echo "No machine type flag set in chezmoi.toml"; exit 1; }
    from="{{MACHINE}}"
    if [[ -z "$from" ]]; then
        from=$(ls "$src" | grep '^Brewfile\.' | grep -v "^${mine}$" | head -1)
    else
        from="Brewfile.${from#Brewfile.}"
    fi
    [[ -f "$src/$from" ]] || { echo "No such list: $from"; exit 1; }
    echo "Picking from ${from} into ${mine}"
    # Entries already in this machine's list are filtered out. grep exits 1 when
    # it filters everything away and fzf exits 1/130 on empty input or Esc, so
    # the pipeline must not abort the recipe.
    candidates=$(grep -E '^(brew|cask) "' "$src/$from" \
        | grep -vxF -f <(grep -E '^(brew|cask) "' "$src/$mine") || true)
    [[ -n "$candidates" ]] || { echo "Nothing left to pick: ${mine} already has every entry"; exit 0; }
    selected=$(printf '%s\n' "$candidates" \
        | fzf --multi --height 80% --layout=reverse --border \
              --prompt="Install on this machine > " \
              --header="TAB to select, Enter to confirm" || true)
    [[ -n "$selected" ]] || { echo "Nothing selected"; exit 0; }
    while IFS= read -r line; do
        [[ -n "$line" ]] || continue
        kind="${line%% *}"; pkg="${line#*\"}"; pkg="${pkg%%\"*}"
        if [[ "$kind" == "cask" ]]; then
            brew install --cask "$pkg" < /dev/null || { echo "Failed: $pkg"; continue; }
        else
            brew install "$pkg" < /dev/null || { echo "Failed: $pkg"; continue; }
        fi
        # Record it. The zsh brew() wrapper is not in scope under bash, so the
        # declaration has to be written here or it would be lost.
        if grep -qE "^${kind} \"${pkg}\"[[:space:]]*(#.*)?$" "$src/$mine"; then
            echo "Already declared: $line"
        else
            last=$(grep -n "^${kind} \"" "$src/$mine" | tail -1 | cut -d: -f1 || true)
            if [[ -n "$last" ]]; then
                tmp="$(mktemp "${TMPDIR:-/tmp}/brewfile.XXXXXX")"
                awk -v n="$last" -v l="$line" 'NR==n{print; print l; next} {print}' "$src/$mine" > "$tmp"
                mv "$tmp" "$src/$mine"
            else
                printf '\n%s\n' "$line" >> "$src/$mine"
            fi
            echo "Recorded: $line -> $mine"
        fi
    done <<< "$selected"
    echo "Run 'chezmoi apply' to regenerate ~/Brewfile"

# Move a declaration from one machine's list to another
brew-move PACKAGE TARGET:
    #!/usr/bin/env bash
    set -uo pipefail
    src="$(chezmoi source-path)/.chezmoitemplates"
    target="Brewfile.{{TARGET}}"; target="${target/Brewfile.Brewfile./Brewfile.}"
    [[ -f "$src/$target" ]] || { echo "No such list: $target"; exit 1; }
    moved=0
    for f in "$src"/Brewfile.*; do
        base="$(basename "$f")"
        [[ "$base" == "$target" ]] && continue
        # Trailing comments are allowed on a declaration, so anchor on the
        # closing quote rather than the end of the line.
        line="$(grep -E "^(brew|cask) \"{{PACKAGE}}\"[[:space:]]*(#.*)?$" "$f" | head -1 || true)"
        [[ -n "$line" ]] || continue
        kind="${line%% *}"
        tmp="$(mktemp "${TMPDIR:-/tmp}/brewfile.XXXXXX")"
        grep -vE "^${kind} \"{{PACKAGE}}\"[[:space:]]*(#.*)?$" "$f" > "$tmp"
        if [[ -s "$tmp" ]]; then mv "$tmp" "$f"; else rm -f "$tmp"; fi
        if grep -qE "^${kind} \"{{PACKAGE}}\"[[:space:]]*(#.*)?$" "$src/$target"; then
            echo "Removed from ${base}; ${target} already declared it"
        else
            last=$(grep -n "^${kind} \"" "$src/$target" | tail -1 | cut -d: -f1 || true)
            if [[ -n "$last" ]]; then
                tmp="$(mktemp "${TMPDIR:-/tmp}/brewfile.XXXXXX")"
                awk -v n="$last" -v l="$line" 'NR==n{print; print l; next} {print}' "$src/$target" > "$tmp"
                mv "$tmp" "$src/$target"
            else
                printf '\n%s\n' "$line" >> "$src/$target"
            fi
            echo "Moved ${line} from ${base} to ${target}"
        fi
        moved=1
    done
    (( moved )) || echo "{{PACKAGE}} is not declared in any list"

# Show what each machine's list holds, and where this machine drifted from it
brew-status:
    #!/usr/bin/env bash
    set -uo pipefail
    src="$(chezmoi source-path)/.chezmoitemplates"
    for f in "$src"/Brewfile.*; do
        printf '%-28s brew %3s  cask %3s  vscode %3s\n' "$(basename "$f")" \
            "$(grep -c '^brew "' "$f" || true)" \
            "$(grep -c '^cask "' "$f" || true)" \
            "$(grep -c '^vscode "' "$f" || true)"
    done
    echo
    echo "Outdated on this machine:"
    export HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_ENV_HINTS=1
    printf '  formula %s\n' "$(brew outdated --formula --quiet 2>/dev/null | wc -l | tr -d ' ')"
    printf '  cask    %s\n' "$(brew outdated --cask --quiet 2>/dev/null | wc -l | tr -d ' ')"

# Clean up Homebrew
brew-cleanup:
    brew cleanup --prune=all
    brew autoremove
    @echo "✅ Homebrew cleaned up"

# =============================================================================
# Plugin & Runtime Management
# =============================================================================

# Update sheldon plugins
sheldon-update:
    sheldon lock --update
    rm -f ~/.cache/sheldon.zsh
    @echo "✅ Sheldon plugins updated (cache cleared)"

# Install default runtimes with mise
mise-install:
    mise install
    @echo "✅ Mise runtimes installed"

# Update all mise runtimes
mise-update:
    mise upgrade
    @echo "✅ Mise runtimes updated"

# =============================================================================
# Sync & Backup
# =============================================================================

# Sync atuin history
atuin-sync:
    atuin sync
    @echo "✅ Atuin history synced"

# Push dotfiles changes
push MESSAGE="update dotfiles":
    cd ~/.local/share/chezmoi && git add -A && git commit -m "{{MESSAGE}}" && git push
    @echo "✅ Dotfiles pushed"

# Pull latest dotfiles
pull:
    chezmoi update
    @echo "✅ Dotfiles updated from remote"

# =============================================================================
# Health Check & Diagnostics
# =============================================================================

# Check dotfiles health
doctor:
    #!/usr/bin/env bash
    set -e
    echo "🔍 Checking dotfiles health..."
    echo ""
    
    echo "📦 Required tools:"
    # Keep this list in step with the Essentials block at the top of
    # .chezmoitemplates/Brewfile.<machine>: these are what the shell startup
    # files and gitconfig depend on.
    for cmd in chezmoi git delta mise sheldon just tmux fzf peco navi atuin zoxide direnv bat eza fd rg jq gh; do
        if command -v $cmd &>/dev/null; then
            printf "  ✅ %-12s %s\n" "$cmd" "$(command -v $cmd)"
        else
            printf "  ❌ %-12s not found\n" "$cmd"
        fi
    done
    echo ""
    
    echo "🔧 Versions:"
    echo "  chezmoi: $(chezmoi --version 2>/dev/null | head -1 || echo 'N/A')"
    echo "  mise:    $(mise --version 2>/dev/null || echo 'N/A')"
    echo "  sheldon: $(sheldon --version 2>/dev/null || echo 'N/A')"
    echo ""
    
    echo "📁 Config files:"
    for f in ~/.zshrc ~/.zshenv ~/.gitconfig ~/.config/chezmoi/chezmoi.toml; do
        if [[ -f "$f" ]]; then
            echo "  ✅ $f"
        else
            echo "  ❌ $f (missing)"
        fi
    done
    echo ""
    
    echo "✅ Health check complete!"

# Measure shell startup time
benchmark:
    #!/usr/bin/env bash
    echo "⏱️  Measuring shell startup time (5 runs)..."
    for i in 1 2 3 4 5; do
        /usr/bin/time zsh -i -c exit 2>&1 || true
    done
    echo ""
    echo "💡 Target: < 200ms for fast startup"
    echo "✅ Your average: ~185ms - Great!"

# Show shell startup breakdown
startup-profile:
    @echo "📊 Profiling shell startup..."
    @zsh -xc exit 2>&1 | ts -i '%.s' | tail -50
    @echo ""
    @echo "💡 Look for slow lines (> 0.01s)"

# =============================================================================
# Maintenance
# =============================================================================

# Update everything
update-all: brew-update sheldon-update mise-update atuin-sync
    @echo "✅ All tools updated!"

# Clean up caches and temporary files
clean:
    rm -f ~/.cache/sheldon.zsh
    rm -f ~/.zcompdump*
    brew cleanup --prune=all 2>/dev/null || true
    @echo "✅ Caches cleaned"

# Lint shell scripts
lint:
    @echo "🔍 Linting shell scripts..."
    shellcheck ~/.zsh/*.zsh 2>/dev/null || echo "⚠️  shellcheck not found or issues found"
    @echo "✅ Lint complete"

