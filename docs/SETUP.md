# Setup Guide

## Prerequisites

- macOS (Apple Silicon or Intel)
- [Homebrew](https://brew.sh/)
- Git
- 1Password account (for secrets management)

## Initial Setup

### 1. Install chezmoi

```bash
brew install chezmoi
```

### 2. Initialize dotfiles

```bash
chezmoi init --apply git@github.com:new-marty/chezmoi.git
```

### 3. Configure Machine Type

Create or edit `~/.config/chezmoi/chezmoi.toml`:

```toml
[data]
    is_personal_mac = true   # Set to true for personal Mac
    is_work_mac = false      # Set to true for work Mac
    is_windows = false
    is_linux = false

[onepassword]
    command = "op"
```

### 4. Setup 1Password CLI

```bash
# Install 1Password CLI
brew install --cask 1password-cli

# Sign in
op signin

# Verify connection
op vault list
```

### 5. Create Secrets in 1Password

Create a "Dotfiles Secrets" item in your Personal vault:

```bash
op item create \
  --category "Secure Note" \
  --title "Dotfiles Secrets" \
  --vault "Personal" \
  'OPENAI_API_KEY[password]=your-api-key-here'
```

### 6. Apply Configuration

```bash
chezmoi apply
```

### 7. Install Homebrew Packages

```bash
brew bundle install --file=~/Brewfile
```

### 8. Restart Shell

```bash
exec $SHELL -l
```

## Machine-Specific Setup

### Personal Mac

The default configuration. All packages in `Brewfile.common` and `Brewfile.personal_mac` will be installed.

### Work Mac

Edit `~/.config/chezmoi/chezmoi.toml`:

```toml
[data]
    is_personal_mac = false
    is_work_mac = true
```

Then regenerate Brewfile:

```bash
chezmoi apply
brew bundle install --file=~/Brewfile
```

## Updating

### Pull Latest Changes

```bash
chezmoi update
```

### Apply Changes

```bash
chezmoi apply
```

### Update Homebrew Packages

```bash
brew bundle install --file=~/Brewfile
```

## Troubleshooting

### chezmoi apply fails

```bash
# Check for errors
chezmoi apply --dry-run --verbose

# View diff
chezmoi diff
```

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

### Brewfile conflicts

```bash
# Regenerate Brewfile
chezmoi apply --force

# Or manually sync
brew bundle dump --force --file=$(chezmoi source-path)/Brewfile
```

