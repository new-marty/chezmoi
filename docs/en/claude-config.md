# Claude Code configuration

Claude Code's user-level configuration (`~/.claude`) is **not** managed by this
dotfiles repository. It lives in its own private git repository,
[`new-marty/dotclaude`](https://github.com/new-marty/dotclaude).

## Why not chezmoi

chezmoi distributes in one direction: the source (under
`~/.local/share/chezmoi/`) is authoritative and `chezmoi apply` writes the
target (your home directory). Carrying a change the other way requires an
explicit `chezmoi re-add`.

`~/.claude` does not fit that model, because Claude Code writes to its own
configuration:

- `settings.json` — theme, model and `effortLevel` changes, and entries appended
  to `permissions.allow` whenever a permission prompt is answered with "always
  allow"
- `skills/` — skills created or edited during a conversation
- `output-styles/` — likewise

Every missed `re-add` leaves the source stale, and the next `chezmoi apply`
rolls the newer content back to the older copy. While `~/.claude` was managed
this way, `statusline.sh` drifted to 173 lines on disk while the source stayed
at the 57-line version it had been added as.

What this configuration actually needs is two-way sync with conflict handling,
which git provides directly: `git pull --rebase --autostash` shelves local
edits, replays them on top, and stops on a conflict when it cannot.

## Division of responsibility

| Owner | Scope |
| --- | --- |
| chezmoi | Connect `~/.claude` to the dotclaude repository on a new machine (once) |
| git | Day-to-day sync, driven by Claude Code hooks that pull and push |

This repository contributes exactly one file:
`run_once_before_bootstrap-dotclaude.sh`. It never touches the contents of
`~/.claude`.

## The bootstrap script

`run_once_before_bootstrap-dotclaude.sh` initialises `~/.claude` as a git
repository in place. Cloning is not possible: the Claude Code installer
(`claude.ai/install.sh`, run by `run_once_install-claude-code.sh.tmpl`) creates
`~/.claude/downloads/` and friends first, and `git clone` refuses a non-empty
directory.

Instead it runs `git init` → `fetch` → `reset` (without `--hard`) →
`checkout-index -a`. That combination writes out the files this machine is
missing and leaves the ones it already has untouched. Where the local and
remote copies differ, the difference shows up in `git status` for a human to
resolve.

A failed `run_once_` script is not recorded as complete, so a fetch that fails
— on a machine that is offline, say — is retried on the next `chezmoi apply`.

## Changing what is tracked

Edit `~/.claude/.gitignore`, not anything in this repository. It ignores
everything by default and re-includes configuration explicitly; adding a
directory takes two lines (`!name/` and `!name/**`). See
`~/.claude/README.md` for details.
