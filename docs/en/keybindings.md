# Keybindings

All keyboard shortcuts configured in this dotfiles setup.

## Command Line Keybindings

| Key | Function | Description |
| --- | -------- | ----------- |
| `Ctrl+G` | `show_command_templates` | Show 100+ predefined command templates |
| `Ctrl+S` | `smart_command_suggest` | Context-aware suggestions based on project type |
| `Ctrl+F` | `show_frequent_commands` | Show your most frequently used commands |
| `Ctrl+N` | `navi_widget` | Open navi interactive cheat sheets |
| `Ctrl+R` | `peco-select-history` | Search command history with peco |
| `Ctrl+H` | `_atuin_search_widget` | Search history with atuin (more features) |
| `Ctrl+U` | `peco-cdr` | Jump to recently visited directories |
| `Tab` | fzf-tab | Enhanced completion with file preview |

---

## Details

### Ctrl+G - Command Templates

Shows a fuzzy-searchable list of common commands:
- Git commands
- Docker commands
- Package manager commands
- System commands
- And more...

### Ctrl+S - Smart Suggestions

Detects your project type and suggests relevant commands:

| Detected File | Suggestions |
|---------------|-------------|
| `package.json` | pnpm install, pnpm run dev, etc. |
| `Dockerfile` | docker build, docker run |
| `docker-compose.yml` | docker-compose up/down/logs |
| `.git` | git status, add, commit, push |
| `Makefile` | make, make install, make clean |
| `requirements.txt` | pip install, venv |
| `go.mod` | go run, go build, go test |
| `Cargo.toml` | cargo run, cargo build, cargo test |

### Ctrl+F - Frequent Commands

Shows your 20 most frequently used commands from history.

### Ctrl+N - Navi Cheat Sheets

Interactive cheat sheets for:
- git
- docker
- npm/pnpm
- terraform
- kubernetes
- system commands
- And custom cheats

### Ctrl+R vs Ctrl+H

| Feature | Ctrl+R (peco) | Ctrl+H (atuin) |
|---------|---------------|----------------|
| Interface | Simple list | Rich UI |
| Search | Basic fuzzy | Full-text + filters |
| Context | None | Directory-aware |
| Sync | No | Optional cloud sync |

### Tab - fzf-tab

Enhanced tab completion:
- Shows file/directory preview
- Fuzzy matching
- Works with all commands

```bash
cd <Tab>              # Preview directories
cat <Tab>             # Preview files
git checkout <Tab>    # Show branches
kill <Tab>            # Show processes
```

---

## lazygit Keybindings

| Key | Action |
|-----|--------|
| `Space` | Stage/unstage |
| `a` | Stage all |
| `c` | Commit |
| `p` | Push |
| `P` | Pull |
| `b` | Branches |
| `m` | Merge |
| `r` | Rebase |
| `s` | Stash |
| `?` | Help |
| `q` | Quit |

---

## bottom (btm) Keybindings

| Key | Action |
|-----|--------|
| `e` | Expand widget |
| `h/l` | Move between widgets |
| `j/k` | Scroll |
| `/` | Search |
| `t` | Tree view |
| `dd` | Kill process |
| `?` | Help |
| `q` | Quit |

---

## Quick Reference Command

Type `keys` in terminal to see keybindings:

```bash
keys
```

