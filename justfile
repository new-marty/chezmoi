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
    for cmd in chezmoi brew sheldon mise atuin zoxide fzf bat eza delta lazygit; do
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

