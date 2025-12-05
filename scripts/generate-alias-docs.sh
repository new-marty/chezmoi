#!/usr/bin/env bash
# =============================================================================
# generate-alias-docs.sh - Auto-generate alias documentation from alias.zsh
# =============================================================================
# Usage: ./scripts/generate-alias-docs.sh
#
# This script parses dot_zsh/alias.zsh and generates Markdown tables for
# docs/en/aliases.md and docs/ja/aliases.md
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

ALIAS_FILE="$ROOT_DIR/dot_zsh/alias.zsh"
EN_DOC="$ROOT_DIR/docs/en/aliases.md"
JA_DOC="$ROOT_DIR/docs/ja/aliases.md"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Parse aliases from alias.zsh
parse_aliases() {
    local section=""
    local aliases=()
    
    while IFS= read -r line; do
        # Detect section headers (# comments)
        if [[ "$line" =~ ^#\ (.+)$ ]]; then
            section="${BASH_REMATCH[1]}"
            continue
        fi
        
        # Parse alias definitions
        if [[ "$line" =~ ^alias\ ([^=]+)=[\'\"]?([^\'\"]*)[\'\"]?$ ]] || \
           [[ "$line" =~ ^alias\ ([^=]+)=\"([^\"]*)\"$ ]] || \
           [[ "$line" =~ ^alias\ ([^=]+)=\'([^\']*)\'$ ]]; then
            local alias_name="${BASH_REMATCH[1]}"
            local alias_cmd="${BASH_REMATCH[2]}"
            echo "${section}|${alias_name}|${alias_cmd}"
        fi
    done < "$ALIAS_FILE"
}

# Generate English documentation
generate_en_doc() {
    local current_section=""
    
    cat << 'EOF'
# Aliases

Complete alias reference for this dotfiles setup.

> ⚠️ **Auto-generated file** - Do not edit directly.
> Run `./scripts/generate-alias-docs.sh` to regenerate.

EOF

    parse_aliases | while IFS='|' read -r section alias_name alias_cmd; do
        if [[ "$section" != "$current_section" && -n "$section" ]]; then
            current_section="$section"
            echo ""
            echo "## ${section^} Aliases"
            echo ""
            echo "| Alias | Command |"
            echo "| ----- | ------- |"
        fi
        
        if [[ -n "$alias_name" ]]; then
            # Escape special characters for markdown
            alias_cmd="${alias_cmd//|/\\|}"
            echo "| \`$alias_name\` | \`$alias_cmd\` |"
        fi
    done
}

# Generate Japanese documentation
generate_ja_doc() {
    local current_section=""
    
    # Section name translations
    declare -A section_translations=(
        ["git"]="Git"
        ["ls"]="ファイル＆ナビゲーション"
        ["cat"]="Cat"
        ["diff"]="Diff"
        ["alias"]="シェル"
        ["code"]="エディタ"
        ["pnpm"]="パッケージマネージャー"
        ["docker"]="Docker"
        ["Modern CLI replacements"]="モダン CLI"
        ["python"]="Python"
        ["terraform"]="Terraform"
        ["chezmoi"]="Chezmoi"
        ["help - Show custom commands and keybindings"]="ヘルプ"
    )
    
    cat << 'EOF'
# エイリアス

この dotfiles 設定の完全なエイリアスリファレンス。

> ⚠️ **自動生成ファイル** - 直接編集しないでください。
> `./scripts/generate-alias-docs.sh` を実行して再生成してください。

EOF

    parse_aliases | while IFS='|' read -r section alias_name alias_cmd; do
        if [[ "$section" != "$current_section" && -n "$section" ]]; then
            current_section="$section"
            local ja_section="${section_translations[$section]:-$section}"
            echo ""
            echo "## ${ja_section} エイリアス"
            echo ""
            echo "| エイリアス | コマンド |"
            echo "| ---------- | -------- |"
        fi
        
        if [[ -n "$alias_name" ]]; then
            # Escape special characters for markdown
            alias_cmd="${alias_cmd//|/\\|}"
            echo "| \`$alias_name\` | \`$alias_cmd\` |"
        fi
    done
}

# Main execution
main() {
    if [[ ! -f "$ALIAS_FILE" ]]; then
        log_error "alias.zsh not found at: $ALIAS_FILE"
        exit 1
    fi
    
    log_info "Generating English documentation..."
    generate_en_doc > "$EN_DOC"
    log_info "Written to: $EN_DOC"
    
    log_info "Generating Japanese documentation..."
    generate_ja_doc > "$JA_DOC"
    log_info "Written to: $JA_DOC"
    
    log_info "✅ Documentation generation complete!"
    
    # Show diff if available
    if command -v git &> /dev/null; then
        echo ""
        log_info "Changes:"
        git diff --stat "$EN_DOC" "$JA_DOC" 2>/dev/null || true
    fi
}

main "$@"

