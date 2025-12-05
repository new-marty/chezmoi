# Core Tools

These are the foundational tools that power this dotfiles setup.

## chezmoi

Dotfile manager that handles multi-machine configurations and templates.

```bash
chezmoi apply              # Apply changes from source to home
chezmoi diff               # Show what would change
chezmoi edit ~/.zshrc      # Edit a managed file
chezmoi update             # Update from remote repository
chezmoi cd                 # Go to chezmoi source directory
chezmoi add ~/.config      # Add a new file to be managed
chezmoi managed            # List all managed files
chezmoi re-add ~/.zshrc    # Re-add after external changes
chezmoi execute-template '{{ .chezmoi.hostname }}'  # Test template
```

**Aliases:**

| Alias  | Command          |
| ------ | ---------------- |
| `cm`   | `chezmoi`        |
| `cma`  | `chezmoi apply`  |
| `cmd`  | `chezmoi diff`   |
| `cme`  | `chezmoi edit`   |
| `cmu`  | `chezmoi update` |
| `cmcd` | `chezmoi cd`     |

---

## sheldon

Fast, configurable zsh plugin manager.

```bash
sheldon source              # Reload plugins
sheldon list                # List installed plugins
sheldon add name --github user/repo  # Add a plugin
sheldon remove name         # Remove a plugin
sheldon lock --update       # Update all plugins
```

**Configuration:** `~/.config/sheldon/plugins.toml`

---

## atuin

Magical shell history with sync, search, and statistics.

```bash
atuin search                # Search history
atuin search -i             # Interactive search
atuin stats                 # Show statistics
atuin import zsh            # Import history from zsh
atuin sync                  # Sync history (if configured)
atuin search --cwd .        # History for current directory
```

**Key binding:** `Ctrl+H` for interactive search

---

## zoxide

Smarter cd command that learns your habits.

```bash
z projects        # Jump to most frecent match for "projects"
z local share     # Jump with multiple keywords
zi                # Interactive selection with fzf
zoxide add ~/path # Add a directory manually
zoxide remove ~/path  # Remove a directory
zoxide query -l   # List all entries with scores
```

**Tips:**
- Use shorter keywords: `z dow` instead of `z Downloads`
- The more you use a directory, the higher its score

---

## navi

Interactive cheat sheet tool for the command-line.

```bash
navi                  # Open interactive cheat sheets
navi --query git      # Search for specific topic
```

**Key binding:** `Ctrl+N` opens navi widget

**Custom cheats:** `~/.config/navi/cheats/cheats.cheat`

---

## fzf

Command-line fuzzy finder.

```bash
fzf                              # Basic fuzzy find
cursor $(fzf)                    # Find files and open in editor
fzf --preview 'bat --color=always {}'  # Preview files
fzf -m                           # Multi-select (Tab)
find ~/Documents -type f | fzf   # Find in specific directory
```

**Integrated with:** Tab completion, Ctrl+G templates, Ctrl+S suggestions

---

## peco

Interactive filtering tool (used for history).

```bash
cat file.txt | peco    # Filter any input
history | peco         # History search
```

**Key bindings:**
- `Ctrl+R` - Search command history
- `Ctrl+U` - Jump to recent directories

---

## thefuck

Corrects your previous console command.

```bash
$ gut status
git: 'gut' is not a git command.

$ fuck
git status [enter/↑/↓/ctrl+c]
```

---

## eza

Modern replacement for ls with icons and git integration.

```bash
ls              # Basic listing (aliased)
ll              # Long format with all files
lll             # With git status
eza --tree --level=2  # Tree view
eza -l --sort=modified  # Sort by modification time
```

---

## bat

Cat clone with syntax highlighting.

```bash
bat file.py                    # View with syntax highlighting
bat -n file.py                 # Show line numbers
bat --line-range 10:20 file.py # Show specific lines
bat -p file.py                 # Plain output
```

---

## ripgrep (rg)

Fast grep alternative that respects .gitignore.

```bash
rg "pattern"              # Search for pattern
rg "pattern" -t js        # Search specific file types
rg -i "pattern"           # Case insensitive
rg -l "pattern"           # Show only filenames
rg --hidden "pattern"     # Include hidden files
rg -C 3 "pattern"         # Show context lines
rg "old" --replace "new"  # Replace (preview)
```

---

## fd

Fast and user-friendly alternative to find.

```bash
fd readme           # Find files by name
fd -e js            # Find by extension
fd -t d             # Find directories only
fd -t f             # Find files only
fd -H pattern       # Include hidden files
fd -e jpg -x convert {} {.}.png  # Execute on results
```

---

## gh

GitHub CLI for working with GitHub from the terminal.

```bash
gh repo clone owner/repo    # Clone a repository
gh repo create my-project   # Create a new repo
gh issue list               # View issues
gh pr list                  # View PRs
gh pr create                # Create PR
gh pr checkout 123          # Checkout PR
gh pr view --web            # Open in browser
```

---

## 1Password CLI (op)

Access 1Password from the command line.

```bash
op signin                   # Sign in
op vault list               # List vaults
op item get "Item Name"     # Get item
op item get "Item" --fields password  # Get specific field
```

---

## mise

Unified runtime version manager (replaces nvm, pyenv, rbenv, etc.).

```bash
mise install node@20        # Install Node.js 20
mise install python@3.12    # Install Python 3.12
mise use node@20            # Use Node.js 20 in current directory
mise use --global node@20   # Set global default
mise ls                     # List installed versions
mise ls-remote node         # List available versions
mise current                # Show current versions
mise prune                  # Remove unused versions
```

**Configuration:** `~/.config/mise/config.toml` or `.mise.toml` per project

**Supported tools:** node, python, ruby, go, rust, java, and many more.

---

## update-dev

Update all development tools at once.

```bash
update-dev                  # Update everything
update-dev --dry-run        # Preview what would be updated
```

**Updates:**
- Homebrew (brew update && brew upgrade)
- Chezmoi (chezmoi update)
- Sheldon plugins (sheldon lock --update)
- Atuin (atuin sync)
- Mise runtimes (mise upgrade)

