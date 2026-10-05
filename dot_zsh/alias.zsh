# git
alias gs='git status'
alias gl="git log --graph --pretty=format:'%C(yellow)%h%Creset %s %Cgreen(%an)%Creset %Cred%d%Creset'"
alias gls='git log --stat --summary'
alias ga='git add'
alias br="git branch --sort=-committerdate --format='%(authordate:short) %(color:red)%(objectname:short) %(color:yellow)%(refname:short)%(color:reset) (%(color:green)%(committerdate:relative)%(color:reset))'"
alias gd='git diff'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gp='git push origin head'
alias sw='git switch'

# ls - use eza when installed, plain ls otherwise.
# `--icons=auto`, not `--icons`: the bare flag takes the next word as its value,
# so `ls some/path` failed with "invalid value for --icons".
if command -v eza &>/dev/null; then
    alias ls="eza --icons=auto"
    alias lll="eza -abghHliS --git --icons=auto"
fi
alias ll="ls -la"
alias la="ls -l"
alias l1="ls -1"

# cat - use bat for syntax highlighting when installed, plain cat otherwise
if command -v bat &>/dev/null; then
    alias cat="bat --style=plain --paging=never"
    alias catp="bat"  # bat with full features (paging, line numbers)
fi

# diff
command -v colordiff >/dev/null 2>&1 && alias diff='colordiff -u' || alias diff='diff -u'

# alias
alias rs='exec zsh -l'
alias sz='source ~/.zshrc'

# c - open the GUI editor chezmoi chose in .zshenv (Cursor or VS Code); no
# alias when neither is installed. To choose another editor, set the variable
# in ~/.zshenv.local (read before this file) or redefine `c` in ~/.zshrc.local.
[[ -n "$DOTFILES_GUI_EDITOR" ]] && alias c='"$DOTFILES_GUI_EDITOR"'

# pnpm
alias pp="pnpm"
alias pi="pnpm install"
alias pr="pnpm run"
alias pd="pnpm dev"
alias pu="pnpm update"
alias pb="pnpm build"

# docker
alias dcud='docker compose up -d'
alias dcu='docker compose up'
alias dcd='docker compose down'

# Modern CLI replacements, each only when installed. Without them the
# original command runs, so a missing tool never breaks a familiar name.
command -v dust &>/dev/null && alias du='dust'
command -v duf &>/dev/null && alias df='duf'
command -v procs &>/dev/null && alias ps='procs'
command -v btm &>/dev/null && alias top='btm'
command -v lazygit &>/dev/null && alias lg='lazygit'

# python
alias p='python3'

# terraform
alias tf='terraform'

# chezmoi
alias cm='chezmoi'
alias cma='chezmoi apply'
alias cmd='chezmoi diff'
alias cme='chezmoi edit'
alias cmu='chezmoi update'
alias cmcd='chezmoi cd'

# claude code
alias yolo='claude --dangerously-skip-permissions'

# tmux
alias t='tmux'
alias ta='tmux attach -t'
alias tl='tmux list-sessions'
alias tn='tmux new-session -s'

# help - Show custom commands and keybindings
alias help='show_dotfiles_help'
alias keys='show_keybindings'
alias docs='open_dotfiles_docs'

# Show keybindings quick reference
function show_keybindings() {
    echo "⌨️  Keybindings Quick Reference"
    echo "═══════════════════════════════"
    echo ""
    echo "  Ctrl+G    Command templates"
    echo "  Ctrl+S    Smart suggestions (context-aware)"
    echo "  Ctrl+F    Frequently used commands"
    echo "  Ctrl+N    Navi cheat sheets"
    echo "  Ctrl+R    Peco history search"
    echo "  Ctrl+H    Atuin enhanced history"
    echo "  Ctrl+U    Recent directories"
    echo "  Tab       fzf-tab completion"
    echo ""
    echo "💡 Type 'help' for full command reference"
}

# Open documentation in editor
function open_dotfiles_docs() {
    local docs_dir="$(chezmoi source-path)/docs"
    if [[ -d "$docs_dir" && -n "$DOTFILES_GUI_EDITOR" ]]; then
        "$DOTFILES_GUI_EDITOR" "$docs_dir"
    elif [[ -d "$docs_dir" ]]; then
        open "$docs_dir"
    else
        echo "Documentation not found at: $docs_dir"
    fi
}

# Help function for custom commands and features
function show_dotfiles_help() {
    echo "🚀 Custom Dotfiles Help"
    echo "======================="
    echo ""

    echo "📋 KEYBINDINGS"
    echo "──────────────"
    echo "  Ctrl+G    Command templates (100+ pre-configured)"
    echo "  Ctrl+S    Smart suggestions (context-aware)"
    echo "  Ctrl+F    Frequently used commands"
    echo "  Ctrl+N    Navi cheat sheets"
    echo "  Ctrl+R    Peco history search"
    echo "  Ctrl+H    Atuin enhanced history"
    echo "  Ctrl+U    Recent directories (peco)"
    echo "  Tab       fzf-tab completion with preview"
    echo ""

    echo "🏃 NAVIGATION"
    echo "─────────────"
    echo "  z <dir>    Jump to directory (zoxide, learns from usage)"
    echo "  zi         Interactive directory selection"
    echo "  cdf        Fuzzy find and cd to directory"
    echo "  mkcd       Create directory and cd into it"
    echo ""

    echo "🛠️  CUSTOM COMMANDS"
    echo "──────────────────"
    echo "  fcat       Display files with headers"
    echo "             -i (gitignore), -o (output), -c (clipboard), -n (pattern)"
    echo "  ts2mp4     Convert TS to MP4 (-o dir, -f force)"
    echo "  fuck       Correct previous command (thefuck)"
    echo ""

    echo "📁 GIT"
    echo "──────"
    echo "  lg         lazygit TUI (Space=stage, c=commit, p=push)"
    echo "  gs         git status"
    echo "  gl         git log with graph"
    echo "  ga         git add"
    echo "  gd         git diff (with delta syntax highlighting)"
    echo "  gcm        git commit -m"
    echo "  gca        git commit --amend"
    echo "  gp         git push origin head"
    echo "  sw         git switch"
    echo "  br         git branch with dates"
    echo ""

    echo "🖥️  TMUX"
    echo "───────"
    echo "  t          tmux"
    echo "  ta         tmux attach -t"
    echo "  tl         tmux list-sessions"
    echo "  tn         tmux new-session -s"
    echo ""

    echo "🆕 MODERN CLI REPLACEMENTS"
    echo "──────────────────────────"
    echo "  ls         eza (with icons)"
    echo "  ll/la/l1   eza variants"
    echo "  cat        bat (syntax highlighting, plain mode)"
    echo "  catp       bat with full features (paging, line numbers)"
    echo "  du         dust (visual disk usage)"
    echo "  df         duf (beautiful disk free)"
    echo "  ps         procs (modern process viewer)"
    echo "  top        btm/bottom (graphical monitor)"
    echo "  http       httpie (user-friendly curl)"
    echo ""

    echo "🔍 SEARCH & FIND"
    echo "────────────────"
    echo "  rg         ripgrep (fast grep, respects .gitignore)"
    echo "  fd         fast find alternative"
    echo "  fzf        fuzzy finder"
    echo "  tldr       simplified man pages"
    echo "  glow       Render markdown in terminal"
    echo ""

    echo "🌐 NETWORK"
    echo "──────────"
    echo "  doggo      Modern DNS lookup (dig replacement)"
    echo "  bandwhich  Realtime bandwidth by process"
    echo "  gping      Visual ping with graph"
    echo ""

    echo "📦 PACKAGE MANAGEMENT"
    echo "────────────────────"
    echo "  pp/pi/pr   pnpm / install / run"
    echo "  pd/pu/pb   pnpm dev / update / build"
    echo "  mise       Unified runtime manager (node/python/rust)"
    echo "             mise install, mise use, mise ls"
    echo ""

    echo "🔧 UTILITIES"
    echo "────────────"
    echo "  rs         Restart shell"
    echo "  sz         Source ~/.zshrc"
    echo "  c          Editor (Cursor or VS Code)"
    echo "  p          python3"
    echo "  tf         terraform"
    echo "  dcud       docker compose up -d"
    echo "  dcu        docker compose up"
    echo "  dcd        docker compose down"
    echo "  gh         GitHub CLI"
    echo "  yolo       Claude Code (skip permissions)"
    echo ""
    
    echo "🔄 MAINTENANCE"
    echo "──────────────"
    echo "  update-dev Update all dev tools (brew, chezmoi, sheldon, atuin, mise)"
    echo "             --dry-run: Preview changes without applying"
    echo ""

    echo "⚙️  CHEZMOI (Dotfile Management)"
    echo "────────────────────────────────"
    echo "  cm         chezmoi"
    echo "  cma        chezmoi apply"
    echo "  cmd        chezmoi diff"
    echo "  cme        chezmoi edit"
    echo "  cmu        chezmoi update"
    echo "  cmcd       chezmoi cd"
    echo ""

    echo "🌍 ENVIRONMENT"
    echo "──────────────"
    echo "  direnv     Per-directory env vars (auto-loads .envrc)"
    echo "             direnv allow / direnv edit"
    echo ""

    echo "📖 MORE HELP"
    echo "────────────"
    echo "  navi              Interactive cheat sheets"
    echo "  tldr <cmd>        Quick command examples"
    echo "  <cmd> --help      Command help"
    echo "  fcat -h           fcat help"
    echo "  ts2mp4 -h         ts2mp4 help"
    echo ""

    echo "📚 DOCUMENTATION"
    echo "────────────────"
    echo "  English:   \$(chezmoi source-path)/docs/en/"
    echo "  日本語:    \$(chezmoi source-path)/docs/ja/"
    echo "  Open docs: docs"
    echo ""

    echo "💡 QUICK TIPS"
    echo "─────────────"
    echo "  • Tab = fzf completion with preview"
    echo "  • z learns from your cd usage"
    echo "  • Ctrl+S adapts to project type (package.json, Dockerfile...)"
    echo "  • lg (lazygit) for visual git operations"
    echo "  • tldr <cmd> for quick examples"
    echo ""
}
