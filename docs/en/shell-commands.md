# Shell Commands

Custom shell commands and functions.

## update-dev

One-command daily maintenance for all development tools.

```bash
update-dev           # Update everything (brew, chezmoi, sheldon, atuin, mise)
update-dev --dry-run # Preview changes without applying
```

**What it updates:**
- Homebrew (update, upgrade, cleanup)
- Chezmoi (pull & apply)
- Sheldon plugins (lock --update)
- Atuin history sync
- Mise runtime tools upgrade
- NPM global packages
- TLDR cache

---

## mkcd

Create a directory and cd into it.

```bash
mkcd my-new-project
# Creates my-new-project/ and changes to it
```

---

## cdf

Fuzzy find and cd to a directory using fzf.

```bash
cdf
# Opens fzf to search and select a directory
```

---

## fcat

Recursively display file contents with headers.

```bash
fcat src/              # Display all files in a directory
fcat -i src/           # Respect .gitignore
fcat -n '*.js' src/    # Filter by pattern
fcat -c src/main.js    # Copy to clipboard
fcat -o output.txt lib/  # Save to file
```

### Options

| Option | Description |
|--------|-------------|
| `-i, --ignore-gitignore` | Respect .gitignore patterns |
| `-o, --output FILE` | Write output to file |
| `-c, --clipboard` | Copy output to clipboard |
| `-n, --name PATTERN` | Filter files by name pattern |
| `-h, --help` | Display help |

---

## ts2mp4

Convert TS video files to MP4.

```bash
ts2mp4               # Convert all TS files in current directory
ts2mp4 -o converted/ # Specify output directory
ts2mp4 --force       # Force overwrite existing files
```

### Options

| Option | Description |
|--------|-------------|
| `-o, --output DIR` | Output directory (default: mp4) |
| `-f, --force` | Overwrite existing files |
| `-h, --help` | Display help |

---

## help

Display all custom commands and keybindings.

```bash
help
```

---

## keys

Show keybindings quick reference.

```bash
keys
```

---

## docs

Open this documentation in the GUI editor chezmoi chose for `c` (Cursor or VS
Code). Without either, the docs folder opens in Finder.

```bash
docs
```

---

## direnv

Per-directory environment variables. Automatically loads `.envrc` when entering a directory.

```bash
echo 'export API_KEY=secret123' > .envrc  # Create .envrc
direnv allow      # Allow direnv to load it
direnv edit       # Edit .envrc
direnv reload     # Reload manually
direnv deny       # Block direnv
```

### Common .envrc patterns

```bash
dotenv                    # Load .env file
use mise                  # Use mise for version management
PATH_add bin              # Add local bin to PATH
source_env .env.local     # Source another file
```

