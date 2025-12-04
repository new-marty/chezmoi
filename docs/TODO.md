# TODO

## Completed

### Basic Migration
- [x] Install and initialize chezmoi
- [x] Add dotfiles to chezmoi
- [x] Add config directories to chezmoi
- [x] Add Brewfile
- [x] Commit and push to Git repository

### Path References
- [x] Fix `dot_zsh/commands.zsh` - brew function with chezmoi source-path
- [x] Fix `dot_zshenv.tmpl` - remove unused BAT_CONFIG_PATH
- [x] Fix `dot_zsh/alias.zsh` - help function references
- [x] Fix `dot_zsh/suggestions.zsh` - dotfiles reference to chezmoi cd
- [x] Fix `private_dot_config/sheldon/plugins.toml` - path to ~/.zsh
- [x] Fix `private_dot_config/navi/cheats/cheats.cheat` - path references

### Secret Management
- [x] Setup 1Password CLI
- [x] Create "Dotfiles Secrets" item in 1Password
- [x] Update `dot_secrets.tmpl` for 1Password integration
- [x] Create `~/.config/chezmoi/chezmoi.toml`

### Brewfile
- [x] Template Brewfile with common/personal_mac/work_mac separation
- [x] Add interactive package selection to brew wrapper

### Documentation
- [x] Create English README.md
- [x] Create docs/ folder structure
- [x] Add Japanese translations

### Cleanup
- [x] Delete old `~/dotfiles` directory
- [x] Delete `~/Brewfile` (managed by chezmoi)
- [x] Delete `~/.claude.json.corrupted.*` files
- [x] Delete `~/.amazon-q.dotfiles.bak`
- [x] Remove `.gitattributes`

---

## Optional (Future)

### Multi-Machine Support
- [ ] Template Brewfile for Windows (winget)
- [ ] Template Brewfile for Linux (apt)
- [ ] OS-specific configuration templates
- [ ] Server Linux support
- [ ] Desktop Linux support

### Improvements
- [ ] Add chezmoi aliases (`cm`, `cma`, `cmcd`)
- [ ] Auto-commit configuration for chezmoi
- [ ] Migrate more secrets to 1Password

---

## New Machine Setup Checklist

```bash
# 1. Install chezmoi
brew install chezmoi

# 2. Initialize dotfiles
chezmoi init --apply git@github.com:new-marty/chezmoi.git

# 3. Install 1Password CLI and sign in
brew install --cask 1password-cli
op signin

# 4. Install Homebrew packages
brew bundle install --file=$(chezmoi source-path)/Brewfile

# 5. Restart shell
exec $SHELL -l
```

## Machine-Specific chezmoi.toml

### Personal Mac
```toml
[data]
    is_personal_mac = true
    is_work_mac = false
    is_windows = false
    is_linux = false
```

### Work Mac
```toml
[data]
    is_personal_mac = false
    is_work_mac = true
    is_windows = false
    is_linux = false
```

### Windows
```toml
[data]
    is_personal_mac = false
    is_work_mac = false
    is_windows = true
    is_linux = false
```

### Linux
```toml
[data]
    is_personal_mac = false
    is_work_mac = false
    is_windows = false
    is_linux = true
```

