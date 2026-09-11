# Dotfiles

Personal development environment configuration managed with [chezmoi](https://www.chezmoi.io/).

## Prerequisites

- macOS (Apple Silicon or Intel)
- [Homebrew](https://brew.sh/)
- Git
- 1Password account (for secrets management)

## Quick Start

### New Machine Setup (3 commands)

```bash
# 1. Install chezmoi and initialize
brew install chezmoi
chezmoi init --apply git@github.com:new-marty/chezmoi.git

# 2. Install all tools
brew bundle install --file=~/Brewfile

# 3. Install runtimes and restart
mise install && exec $SHELL -l
```

### Full Setup with Task Runner

```bash
# After chezmoi init, use just for automation:
just setup          # Full setup (brew + mise + sheldon)
just doctor         # Check all tools are installed
just benchmark      # Measure shell startup time
```

### Update Existing Machine

```bash
just update-all     # Update everything (brew, sheldon, mise, atuin)
# or individually:
chezmoi update      # Pull latest dotfiles
just brew-update    # Update Homebrew packages
just sheldon-update # Update shell plugins
```

## Features

- **Fast shell startup**: < 200ms with cached completions and shim-based mise
- **Multi-machine support**: Separate configs for personal/work Mac
- **Runtime management**: mise handles Node, Python, Go, etc.
- **Task automation**: justfile for setup, updates, and diagnostics
- **Per-machine Brewfile**: one package list per machine, no shared list to keep in sync
- **Modern CLI tools**: delta, lazygit, bat, eza, fzf, ripgrep, and more
- **Enhanced shell**: zsh with sheldon plugins, atuin history, zoxide, fzf-tab

## Directory Structure

```
~/.local/share/chezmoi/
├── Brewfile.tmpl                 # Homebrew packages (templated)
├── dot_editorconfig              # Global EditorConfig for consistent coding style
├── dot_gitconfig.tmpl            # Git configuration
├── dot_gitignore_global          # Global gitignore
├── .chezmoitemplates/
│   ├── Brewfile.personal_mac     # Personal Mac packages (one list per machine)
│   └── Brewfile.work_mac         # Work Mac packages (one list per machine)
├── dot_secrets.tmpl              # Secrets (1Password integration)
├── dot_zprofile                  # zsh profile
├── dot_zshenv.tmpl               # Environment variables
├── dot_zshrc                     # zsh configuration
├── dot_zsh/                      # Custom zsh scripts
│   ├── alias.zsh                 # Aliases
│   ├── commands.zsh              # Custom commands
│   ├── peco.zsh                  # Peco configuration
│   ├── steeef.zsh-theme          # Prompt theme
│   └── suggestions.zsh           # Command suggestions
├── private_dot_Library/          # macOS Library settings
│   └── Application Support/Code/ # VS Code settings
├── private_dot_config/
│   ├── ghostty/                  # Ghostty terminal
│   ├── mise/                     # mise runtime config
│   ├── navi/                     # Navi cheat sheets
│   ├── raycast/                  # Raycast scripts
│   └── sheldon/                  # Sheldon plugin manager
├── justfile                      # Task automation
└── docs/                         # Documentation
    └── ja/                       # Japanese translations
```

## Configuration

### Machine Type (`~/.config/chezmoi/chezmoi.toml`)

```toml
[data]
    is_personal_mac = true   # Personal Mac
    is_work_mac = false      # Work Mac

[onepassword]
    command = "op"
```

### Multi-Machine Settings

| Machine      | is_personal_mac | is_work_mac |
| ------------ | --------------- | ----------- |
| Personal Mac | true            | false       |
| Work Mac     | false           | true        |

Each machine has its own package list; there is no shared "common" list. A new
machine starts from the Essentials block at the top of another machine's list —
see `just brew-pick`.

## Brew Package Management

Each machine has its own package list under `.chezmoitemplates/`. There is no
shared "common" list, so installing a package records it for this machine only.
The `brew` command is wrapped to keep the list in step; it never prompts.

```bash
brew install ripgrep      # installs, then records brew "ripgrep" in this machine's list
brew uninstall ripgrep    # uninstalls, then removes the declaration wherever it is
```

The wrapper reads where Homebrew actually put the package, so `--cask` is
optional: `brew install google-chrome` records it as a cask.

Three recipes manage the lists themselves:

| Command                          | What it does                                                      |
| -------------------------------- | ----------------------------------------------------------------- |
| `just brew-pick <machine>`       | Browse another machine's list, install what you select, record it   |
| `just brew-move <package> <to>`  | Move one declaration between machine lists                          |
| `just brew-status`               | Show the size of each list and what is outdated here                |

Setting up a new machine means running `just brew-pick` against an existing
list and starting with its Essentials block: the packages the shell startup
files and gitconfig depend on.

## Custom Commands

| Command  | Description                          |
| -------- | ------------------------------------ |
| `help`   | Show custom commands and keybindings |
| `fcat`   | Recursively display file contents    |
| `ts2mp4` | Convert TS files to MP4              |
| `mkcd`   | Create directory and cd into it      |
| `cdf`    | Fuzzy find and cd to directory       |

## Keybindings

| Key      | Function                          |
| -------- | --------------------------------- |
| `Ctrl+G` | Command templates                 |
| `Ctrl+S` | Smart suggestions (context-aware) |
| `Ctrl+F` | Frequently used commands          |
| `Ctrl+N` | Navi cheat sheets                 |
| `Ctrl+R` | Peco history search               |
| `Ctrl+H` | Atuin enhanced history            |

## Secrets Management

Secrets are managed via [1Password CLI](https://developer.1password.com/docs/cli/):

```bash
# Create secrets (first time setup)
op item create \
  --category "Secure Note" \
  --title "Dotfiles Secrets" \
  --vault "Personal" \
  'OPENAI_API_KEY[password]=your-api-key-here'

# View secrets
op item get "Dotfiles Secrets" --vault Personal

# Update secrets
op item edit "Dotfiles Secrets" --vault Personal 'OPENAI_API_KEY=new-value'
```

## Common chezmoi Commands

```bash
# Show diff before applying
chezmoi diff

# Apply changes
chezmoi apply

# Open source directory
chezmoi cd

# List managed files
chezmoi managed

# Test template output
chezmoi execute-template '{{ .chezmoi.os }}'

# Edit and auto-add changes
chezmoi edit ~/.zshrc
```

## Troubleshooting

### 1Password not working

```bash
# Re-authenticate
op signin

# Check connection
op vault list

# Test template
chezmoi execute-template '{{ (onepasswordItemFields "Dotfiles Secrets" "Personal").OPENAI_API_KEY.value }}'
```

### Shell not loading properly

```bash
# Restart shell
exec $SHELL -l

# Rebuild sheldon cache
rm ~/.cache/sheldon.zsh
sheldon source
```

### chezmoi apply errors

```bash
chezmoi apply --dry-run --verbose
chezmoi diff
```

### Brewfile conflicts

```bash
# Regenerate Brewfile
chezmoi apply --force

# Or manually sync
brew bundle dump --force --file=$(chezmoi source-path)/Brewfile
```

## Documentation

### English
- [Overview](docs/en/README.md)
- [Core Tools](docs/en/core-tools.md) - chezmoi, sheldon, atuin, zoxide, navi, fzf...
- [Modern CLI](docs/en/modern-cli.md) - lazygit, dust, duf, procs, btm, httpie...
- [Shell Commands](docs/en/shell-commands.md) - fcat, ts2mp4, mkcd, cdf...
- [Git](docs/en/git.md) - Git aliases, lazygit, delta
- [Keybindings](docs/en/keybindings.md)
- [Aliases](docs/en/aliases.md)

### 日本語
- [概要](docs/ja/README.md)
- [コアツール](docs/ja/core-tools.md)
- [モダンCLI](docs/ja/modern-cli.md)
- [シェルコマンド](docs/ja/shell-commands.md)
- [Git](docs/ja/git.md)
- [キーバインド](docs/ja/keybindings.md)
- [エイリアス](docs/ja/aliases.md)

## References

- [chezmoi Documentation](https://www.chezmoi.io/)
- [1Password CLI](https://developer.1password.com/docs/cli/)
