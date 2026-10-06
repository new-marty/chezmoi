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

# Apply chezmoi changes
apply:
    chezmoi apply
    @echo "✅ Dotfiles applied"

# =============================================================================
# Package Management
# =============================================================================

# Update Homebrew and upgrade packages
brew-update:
    brew update && brew upgrade
    @echo "✅ Homebrew packages updated"

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

    # The "omz" opt-in picks Oh My Zsh over sheldon (.chezmoidata/optin.toml).
    omz="$(chezmoi execute-template '{{{{ has "omz" (dig "optin" list .) }}' 2>/dev/null || echo "unknown")"
    echo "🧩 zsh plugins:"
    if [[ "$omz" == true ]]; then
        if [[ -r "${ZSH:-$HOME/.oh-my-zsh}/oh-my-zsh.sh" ]]; then
            echo "  ✅ Oh My Zsh ${ZSH:-$HOME/.oh-my-zsh}, plugins from ~/.zsh/omz-custom"
        else
            echo "  ❌ Oh My Zsh not installed, ~/.zsh is sourced without plugins (docs/en/work-mac.md)"
        fi
    elif command -v sheldon &>/dev/null; then
        echo "  ✅ sheldon (~/.config/sheldon/plugins.toml)"
    else
        echo "  ❌ sheldon not installed, ~/.zsh is sourced without plugins"
    fi
    echo ""
    
    echo "📦 Tools the dotfiles use (all optional except chezmoi and git):"
    # The shell and gitconfig check for each of these and fall back to the
    # stock command when one is missing, so ❌ means a feature is off, not broken.
    for cmd in chezmoi git delta mise sheldon just tmux fzf peco navi atuin zoxide direnv thefuck bat eza dust duf procs btm lazygit colordiff code cursor fd rg jq gh; do
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
    for f in ~/.zshrc ~/.zshenv ~/.config/git/config ~/.gitconfig ~/.config/chezmoi/chezmoi.toml; do
        if [[ -f "$f" ]]; then
            echo "  ✅ $f"
        else
            echo "  ❌ $f (missing)"
        fi
    done
    echo ""
    
    echo "✅ Health check complete!"

# Show each opt-in switch: selected here, its files present, managed by chezmoi
optin:
    #!/usr/bin/env bash
    set -euo pipefail
    # chezmoi stops managing the files of a switch that is not selected without
    # saying so, and never deletes them, so an old file can stay on disk unmanaged.
    # The switch table is .chezmoidata/optin.toml; the selection is `optin` under
    # [data] in ~/.config/chezmoi/chezmoi.toml. Only the files chezmoi writes are
    # listed, never their directories, which can hold the application's own data.
    rows="$(chezmoi execute-template '{{{{- $sel := dig "optin" list . -}}
    {{{{- range $name, $sw := .optin_paths -}}
    {{{{- $on := ternary "yes" "no" (has $name $sel) -}}
    {{{{- range dig "files" list $sw -}}
    {{{{ $name }}{{{{ "\t" }}{{{{ $on }}{{{{ "\tfile\t" }}{{{{ . }}{{{{ "\n" }}
    {{{{- end -}}
    {{{{- range dig "scripts" list $sw -}}
    {{{{ $name }}{{{{ "\t" }}{{{{ $on }}{{{{ "\tscript\t" }}{{{{ . }}{{{{ "\n" }}
    {{{{- end -}}
    {{{{- if not (or (dig "files" list $sw) (dig "scripts" list $sw)) -}}
    {{{{ $name }}{{{{ "\t" }}{{{{ $on }}{{{{ "\tnone\t-\n" }}
    {{{{- end -}}
    {{{{- end -}}')"
    managed="$(chezmoi managed --include=all 2>&1)" || {
        echo "chezmoi managed failed (an unknown name in the optin list?):"
        echo "$managed"
        exit 1
    }
    # chezmoi records the SHA-256 of every file it writes (bucket entryState).
    # A file is offered for deletion only when that record exists and still
    # matches, i.e. chezmoi wrote it and nothing changed it since.
    written_by_chezmoi() {
        local want got
        want="$(chezmoi state get --bucket=entryState --key="$dest/$1" 2>/dev/null \
            | sed -n 's/.*"contentsSHA256": *"\([0-9a-f]*\)".*/\1/p')"
        [[ -n "$want" ]] || { echo no; return; }
        got="$(shasum -a 256 "$dest/$1" | cut -d' ' -f1)"
        if [[ "$want" == "$got" ]]; then echo yes; else echo changed; fi
    }
    # chezmoi keys its records by the destination path it normalised; $HOME
    # can differ in form (a trailing or doubled slash), so ask chezmoi for it.
    dest="$(chezmoi execute-template '{{{{ .chezmoi.destDir }}')"
    stale=()
    changed=()
    printf "%-18s %-9s %-8s %-8s %s\n" SWITCH SELECTED EXISTS MANAGED PATH
    while IFS=$'\t' read -r name selected kind path; do
        # A switch that writes no files of its own (editor-builtin) shows its
        # selection only.
        if [[ "$kind" == none ]]; then
            printf "%-18s %-9s %-8s %-8s %s\n" "$name" "$selected" - - -
            continue
        fi
        if [[ "$kind" == script ]]; then exists="script"
        elif [[ -e "$dest/$path" ]]; then exists="yes"
        else exists="no"; fi
        if grep -qxF "$path" <<<"$managed"; then is_managed="yes"; else is_managed="no"; fi
        printf "%-18s %-9s %-8s %-8s %s\n" "$name" "$selected" "$exists" "$is_managed" "$path"
        if [[ "$exists" == yes && "$is_managed" == no ]]; then
            case "$(written_by_chezmoi "$path")" in
                yes) stale+=("$path") ;;
                changed) changed+=("$path") ;;
            esac
        fi
    done <<<"$rows"
    if (( ${#stale[@]} )); then
        echo ""
        echo "chezmoi wrote these files, no longer manages them, and they are unchanged"
        echo "since. Delete them if you do not want them (the files only, never their"
        echo "directories, which can hold the application's own data):"
        for p in "${stale[@]}"; do printf '  rm %q\n' "$dest/$p"; done
    fi
    if (( ${#changed[@]} )); then
        echo ""
        echo "chezmoi wrote these files earlier, but they have changed since (the"
        echo "application or you edited them). Review them before deleting anything:"
        for p in "${changed[@]}"; do printf '  %s\n' "$dest/$p"; done
    fi
    # Files that exist without a chezmoi record were created by the application
    # or by hand; they are listed in the table but never offered for deletion.

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

# Lint shell scripts the same way CI does: zsh syntax, then ShellCheck on bash/sh
lint:
    #!/usr/bin/env bash
    set -euo pipefail
    # Run from ~/justfile (the opt-in copy), this file sits outside the source tree.
    [ -f dot_zshrc ] || cd "$(chezmoi source-path)"
    for f in dot_zshrc dot_zsh/*.zsh dot_zsh/*.zsh-theme dot_zsh/tests/*.zsh; do zsh -n "$f"; done
    shellcheck scripts/*.sh run_once_before_install-tpm.sh.tmpl

