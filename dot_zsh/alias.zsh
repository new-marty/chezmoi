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

# ls
alias ls="eza --icons"
alias ll="ls -la"
alias la="ls -l"
alias l1="ls -1"
alias lll="ls -abghHliS --git"

# cat
alias cat="ccat"

# diff
alias diff='colordiff -u'

# alias
alias rs='exec $SHELL -l'
alias sz='source ~/.zshrc'

# code
alias c='cursor'

# pnpm
alias pp="pnpm"
alias pi="pnpm install"
alias pr="pnpm run"
alias pd="pnpm dev"
alias pu="pnpm update"
alias pb="pnpm build"

# docker
alias dcu='docker-compose up -d'

# python
alias p='python3'

# terraform
alias tf='terraform'

# help - Show custom commands and keybindings
alias help='show_dotfiles_help'

# Help function for custom commands and features
function show_dotfiles_help() {
    echo "🚀 Custom Dotfiles Help"
    echo "======================="
    echo ""

    echo "📋 KEYBINDINGS (Command Suggestions)"
    echo "────────────────────────────────────"
    echo "  Ctrl+G    Show command templates (100+ pre-configured commands)"
    echo "  Ctrl+S    Smart suggestions based on current directory context"
    echo "  Ctrl+F    Show most frequently used commands from history"
    echo "  Ctrl+N    Interactive cheat sheets for git, docker, npm, etc."
    echo "  Ctrl+R    Enhanced history search with atuin"
    echo "  Ctrl+U    Jump to recently visited directories (peco)"
    echo ""

    echo "🏃 NAVIGATION"
    echo "─────────────"
    echo "  z <dir>    Jump to frequently used directories (zoxide)"
    echo "  cdf        Find and cd to directory using fuzzy search"
    echo "  mkcd       Create directory and cd into it"
    echo "  br         Show git branches with dates"
    echo ""

    echo "🛠️  CUSTOM COMMANDS"
    echo "──────────────────"
    echo "  fcat       Display files with headers (supports .gitignore, patterns)"
    echo "             Usage: fcat [options] <directory/file>"
    echo "             Options: -i (ignore gitignore), -o (output file),"
    echo "                     -c (clipboard), -n (name pattern)"
    echo "  ts2mp4     Convert TS files to MP4 format"
    echo "             Usage: ts2mp4 [-o output_dir] [-f force]"
    echo "  brew       Enhanced brew with auto Brewfile updates"
    echo ""

    echo "📁 GIT ALIASES"
    echo "──────────────"
    echo "  gs         git status"
    echo "  gl         git log with graph"
    echo "  gls        git log with stats"
    echo "  ga         git add"
    echo "  gd         git diff"
    echo "  gcm        git commit -m"
    echo "  gca        git commit --amend"
    echo "  gp         git push origin head"
    echo "  sw         git switch"
    echo ""

    echo "📦 PACKAGE MANAGEMENT"
    echo "────────────────────"
    echo "  pp         pnpm"
    echo "  pi         pnpm install"
    echo "  pr         pnpm run"
    echo "  pd         pnpm dev"
    echo "  pu         pnpm update"
    echo "  pb         pnpm build"
    echo ""

    echo "🗂️  FILE OPERATIONS"
    echo "──────────────────"
    echo "  ls         eza --icons"
    echo "  ll         ls -la"
    echo "  la         ls -l"
    echo "  l1         ls -1"
    echo "  lll        ls -abghHliS --git"
    echo "  cat        ccat (colored cat)"
    echo "  diff       colordiff -u"
    echo ""

    echo "🔧 UTILITIES"
    echo "────────────"
    echo "  rs         Restart shell (exec \$SHELL -l)"
    echo "  sz         Source ~/.zshrc"
    echo "  c          cursor (VS Code cursor)"
    echo "  p          python3"
    echo "  tf         terraform"
    echo "  dcu        docker-compose up -d"
    echo ""

    echo "📖 HELP RESOURCES"
    echo "─────────────────"
    echo "  help       Show this help message"
    echo "  navi       Interactive cheat sheets"
    echo "  atuin -h   Enhanced history search help"
    echo "  fcat -h    File display tool help"
    echo "  ts2mp4 -h  TS to MP4 converter help"
    echo ""

    echo "💡 TIPS"
    echo "───────"
    echo "  • Use Tab completion for most commands"
    echo "  • Commands learn from your usage patterns"
    echo "  • Smart suggestions adapt to your project type"
    echo "  • History is enhanced with atuin (Ctrl+R)"
    echo "  • Use 'navi' for interactive cheat sheets"
    echo "  • Directory jumping gets smarter with usage (z command)"
    echo ""

    echo "🔗 MORE INFO"
    echo "────────────"
    echo "  GitHub: https://github.com/yumabuchi/dotfiles"
    echo "  README: ~/dotfiles/README.md"
    echo ""
}
