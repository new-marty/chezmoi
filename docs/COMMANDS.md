# Custom Commands

## Shell Commands

### `mkcd`

Create a directory and cd into it.

```bash
mkcd my-new-project
# Creates my-new-project/ and changes to it
```

### `cdf`

Fuzzy find and cd to a directory using fzf.

```bash
cdf
# Opens fzf to search and select a directory
```

### `fcat`

Recursively display file contents with headers.

```bash
# Display all files in a directory
fcat src/

# Respect .gitignore
fcat -i src/

# Filter by pattern
fcat -n '*.js' src/

# Copy to clipboard
fcat -c src/main.js

# Save to file
fcat -o output.txt lib/
```

Options:
- `-i, --ignore-gitignore` - Respect .gitignore patterns
- `-o, --output FILE` - Write output to file
- `-c, --clipboard` - Copy output to clipboard
- `-n, --name PATTERN` - Filter files by name pattern
- `-h, --help` - Display help

### `ts2mp4`

Convert TS video files to MP4.

```bash
# Convert all TS files in current directory
ts2mp4

# Specify output directory
ts2mp4 -o converted/

# Force overwrite existing files
ts2mp4 --force
```

Options:
- `-o, --output DIR` - Output directory (default: mp4)
- `-f, --force` - Overwrite existing files
- `-h, --help` - Display help

### `brew` (wrapped)

Enhanced brew command with interactive Brewfile management.

```bash
# Install a package
brew install ripgrep
# Prompts: Add to which Brewfile?
#   > All machines (common)
#     Personal Mac only
#     Work Mac only
#     Skip

# Uninstall a package
brew uninstall ripgrep
# Prompts: Remove from which Brewfile?
```

### `help`

Display all custom commands and keybindings.

```bash
help
```

## Keybindings

| Key      | Function                          | Description                              |
| -------- | --------------------------------- | ---------------------------------------- |
| `Ctrl+G` | `show_command_templates`          | Show predefined command templates        |
| `Ctrl+S` | `smart_command_suggest`           | Context-aware suggestions                |
| `Ctrl+F` | `show_frequent_commands`          | Show frequently used commands            |
| `Ctrl+N` | `navi_widget`                     | Open navi cheat sheets                   |
| `Ctrl+R` | `peco-select-history`             | Search history with peco                 |
| `Ctrl+H` | `_atuin_search_widget`            | Search history with atuin                |
| `Ctrl+U` | `peco-cdr`                        | Jump to recent directories               |

## Git Aliases

| Alias | Command                                      |
| ----- | -------------------------------------------- |
| `gs`  | `git status`                                 |
| `gl`  | `git log --graph --pretty=format:...`        |
| `gls` | `git log --stat --summary`                   |
| `ga`  | `git add`                                    |
| `br`  | `git branch --sort=-committerdate ...`       |
| `gd`  | `git diff`                                   |
| `gcm` | `git commit -m`                              |
| `gca` | `git commit --amend`                         |
| `gp`  | `git push origin head`                       |
| `sw`  | `git switch`                                 |

## Other Aliases

| Alias | Command                    |
| ----- | -------------------------- |
| `ls`  | `eza --icons`              |
| `ll`  | `ls -la`                   |
| `la`  | `ls -l`                    |
| `l1`  | `ls -1`                    |
| `lll` | `ls -abghHliS --git`       |
| `cat` | `ccat`                     |
| `diff`| `colordiff -u`             |
| `rs`  | `exec $SHELL -l`           |
| `sz`  | `source ~/.zshrc`          |
| `c`   | `cursor`                   |
| `pp`  | `pnpm`                     |
| `pi`  | `pnpm install`             |
| `pr`  | `pnpm run`                 |
| `pd`  | `pnpm dev`                 |
| `pu`  | `pnpm update`              |
| `pb`  | `pnpm build`               |
| `dcu` | `docker-compose up -d`     |
| `p`   | `python3`                  |
| `tf`  | `terraform`                |

