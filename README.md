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
- **Smart Brewfile**: Interactive package categorization (common/personal/work)
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
│   ├── Brewfile.common           # Packages for all machines
│   ├── Brewfile.personal_mac     # Personal Mac packages
│   └── Brewfile.work_mac         # Work Mac packages
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
    is_windows = false       # Windows
    is_linux = false         # Linux

[onepassword]
    command = "op"
```

### Multi-Machine Settings

| Machine      | is_personal_mac | is_work_mac | is_windows | is_linux |
| ------------ | --------------- | ----------- | ---------- | -------- |
| Personal Mac | true            | false       | false      | false    |
| Work Mac     | false           | true        | false      | false    |
| Windows      | false           | false       | true       | false    |
| Linux        | false           | false       | false      | true     |

## Brew Package Management

The `brew` command is wrapped to provide interactive Brewfile management:

```bash
# When you install a package
brew install ripgrep

# You'll be prompted:
# ? Add to which Brewfile?
#   > All machines (common)
#     Personal Mac only
#     Work Mac only
#     Skip (don't update Brewfile)
```

Same for `brew uninstall` - you can choose which Brewfile to update.

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
