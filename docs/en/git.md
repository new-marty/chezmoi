# Git Tools

Git-related aliases, tools, and configurations.

## Shell Aliases

| Alias | Command |
| ----- | ------- |
| `gs`  | `git status` |
| `gl`  | `git log --graph --pretty=format:...` |
| `gls` | `git log --stat --summary` |
| `ga`  | `git add` |
| `br`  | `git branch --sort=-committerdate ...` |
| `gd`  | `git diff` |
| `gcm` | `git commit -m` |
| `gca` | `git commit --amend` |
| `gp`  | `git push origin head` |
| `sw`  | `git switch` |

---

## Git Config Aliases

These are defined in `~/.gitconfig`:

```bash
git st          # Short status
git lg          # Graph log with colors
git lga         # Graph log with all branches
git amend       # Amend without editing message
git undo        # Soft reset last commit
git wip         # Quick WIP commit
git please      # Force push with lease (safe force)
git cleanup     # Delete merged branches
git aliases     # Show all aliases
```

---

## lazygit (alias: `lg`)

Visual git TUI. Much easier than command line for complex operations.

```bash
lg              # Open lazygit
```

### Key Operations

| Key | Action |
|-----|--------|
| `Space` | Stage/unstage file |
| `a` | Stage all files |
| `c` | Commit |
| `p` | Push |
| `P` | Pull |
| `b` | Branch operations |
| `m` | Merge |
| `r` | Rebase |
| `s` | Stash |
| `?` | Show all keybindings |
| `q` | Quit |

### Workflow Example

1. Open: `lg`
2. Stage all: `a`
3. Commit: `c` → type message → Enter
4. Push: `p`

---

## delta

Enhanced git diff with syntax highlighting.

Automatically applied to:
- `git diff`
- `git log`
- `git show`

**Features:**
- Syntax highlighting
- Side-by-side view
- Line numbers
- Navigate with `n`/`N`

```bash
git diff              # Uses delta automatically
git diff --no-pager   # Disable delta temporarily
```

---

## Comparison: lazygit vs Git CLI

| Task | Git CLI | Lazygit |
|------|---------|---------|
| Stage file | `git add file` | Navigate + Space |
| Stage all | `git add .` | `a` |
| Commit | `git commit -m "msg"` | `c` + type |
| Push | `git push` | `p` |
| Pull | `git pull` | `P` |
| Switch branch | `git switch branch` | `b` + select |
| Interactive rebase | `git rebase -i HEAD~n` | `r` on commit |
| Resolve conflicts | Manual editing | Visual interface |
| View diff | `git diff` | Select file |
| Stash | `git stash` | `s` |

---

## GitHub CLI (gh)

```bash
gh repo clone owner/repo    # Clone
gh repo create my-project   # Create new repo
gh issue list               # List issues
gh issue create             # Create issue
gh pr list                  # List PRs
gh pr create                # Create PR
gh pr checkout 123          # Checkout PR
gh pr view --web            # Open in browser
gh pr checks                # Check CI status
gh gist create file.txt     # Create gist
```




