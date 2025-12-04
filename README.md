# Dotfiles

Personal development environment configuration managed with [chezmoi](https://www.chezmoi.io/).

## Quick Start

### New Machine Setup

```bash
# 1. Install chezmoi
brew install chezmoi

# 2. Initialize and apply dotfiles
chezmoi init --apply git@github.com:new-marty/chezmoi.git

# 3. Install 1Password CLI (for secrets)
brew install --cask 1password-cli

# 4. Sign in to 1Password
op signin

# 5. Install Homebrew packages
brew bundle install --file=$(chezmoi source-path)/Brewfile
```

### Update Existing Machine

```bash
chezmoi update
```

## Features

- **Multi-machine support**: Separate configurations for personal Mac, work Mac
- **Secret management**: Integration with 1Password CLI
- **Smart Brewfile**: Interactive package categorization (common/personal/work)
- **Custom commands**: `fcat`, `ts2mp4`, `mkcd`, `cdf`, and more
- **Enhanced shell**: zsh with sheldon plugins, atuin history, zoxide navigation

## Directory Structure

```
~/.local/share/chezmoi/
├── Brewfile.tmpl                 # Homebrew packages (templated)
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
├── dot_vscode/                   # VSCode custom CSS/JS
├── private_dot_config/
│   ├── ghostty/                  # Ghostty terminal
│   ├── navi/                     # Navi cheat sheets
│   ├── raycast/                  # Raycast scripts
│   └── sheldon/                  # Sheldon plugin manager
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
op signin
op vault list
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

## Documentation

- [English Documentation](docs/)
- [日本語ドキュメント](docs/ja/)

## References

- [chezmoi Documentation](https://www.chezmoi.io/)
- [1Password CLI](https://developer.1password.com/docs/cli/)
