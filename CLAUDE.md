# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A chezmoi-managed dotfiles repository for macOS. Files here are source templates that chezmoi applies to the home directory. This is NOT a traditional software project — there is no build step, package.json, or compilation.

## Key Commands

```bash
chezmoi apply              # Apply dotfiles to home directory
chezmoi apply --dry-run -v # Preview changes without applying
chezmoi diff               # Show diff between source and target
chezmoi execute-template '{{ .chezmoi.os }}'  # Test template rendering

just lint                  # Lint shell scripts with shellcheck
just doctor                # Check all tools are installed
```

Tests run in CI (GitHub Actions) and locally:
```bash
zsh -c 'source ./dot_zsh/commands.zsh && source ./dot_zsh/tests/fcat_test.zsh && main'
```

## Chezmoi File Naming Conventions

Files use chezmoi naming prefixes that map to target paths:
- `dot_` → `.` (e.g., `dot_zshrc` → `~/.zshrc`)
- `private_dot_` → `.` with restricted permissions (e.g., `private_dot_ssh/` → `~/.ssh/`)
- `private_` → restricted permissions (e.g., `private_Library/` → `~/Library/`)
- `.tmpl` suffix → Go template, rendered with chezmoi data
- `run_once_before_` → script that runs once before applying
- `run_once_` → script that runs once
- `executable_` → file gets executable permission
- `.chezmoitemplates/` → reusable template partials (included via `{{ template "name" . }}`)

## Template Data

Templates use variables from `~/.config/chezmoi/chezmoi.toml`:
- `.is_personal_mac`, `.is_work_mac` — machine type flags
- `.git_name`, `.git_email`, `.ssh_signing_key` — user identity
- `.chezmoi.os`, `.chezmoi.hostname`, `.chezmoi.homeDir` — built-in chezmoi variables
- Secrets come from 1Password CLI via `onepasswordItemFields "Dotfiles Secrets" "Personal"`

## Contexts and Machines

The owner works in four contexts, and accounts, credentials, and settings must stay
separate between them:

- Main job: the employer. "Work" in this repository (`.is_work_mac`, `Brewfile.work_mac`)
  means this context only.
- Side job: Starup. Its repositories live under `~/starup`, and Orca (a desktop app that
  runs coding agents in parallel worktrees) puts its worktrees under
  `~/orca/workspaces/archaive-pj`.
- Sole proprietorship: new-marty.
- Personal.

There are only two kinds of Mac, personal and work, so machine type does not identify the
context. The side job, the sole proprietorship, and personal use all share the personal
Mac, so anything that must differ between them is switched by working directory. The one
such switch today is in `dot_zshenv.tmpl`, which selects the Starup Claude
Code account inside Starup directories and leaves the personal account as the default
everywhere else.

Before changing an account, credential, or identity setting, establish which of the four
contexts it belongs to. Do not reduce the choice to personal versus work.

## Password Manager Policy

Currently on 1Password, but only adopt features that are portable across password
managers (i.e. also available in open-source alternatives like Vaultwarden/Bitwarden):

- **OK to use**: passwords, passkeys, TOTP, secure notes, SSH agent (keys stored in
  the vault), SSH-based commit signing via the agent
- **Avoid (1Password-specific lock-in)**: `op inject` / `op run` / `op plugin`,
  service accounts, 1Password Connect, embedding `onepassword*` template functions
  in dotfiles. If dotfiles ever need secrets, go through chezmoi's generic
  `[secret] command` abstraction so the backend stays swappable.

Provider-specific paths (agent socket, signing program) should be isolated behind
chezmoi template variables/branches so migrating means flipping one variable.

## Task Management & Tracking Work

All task planning and tracking live in `backlog.md` at the repository root, not in GitHub Issues.
GitHub Issues are disabled for this repository.

**Rule: Always create an entry in `backlog.md` before starting any work.**
- When starting work: create or update the entry in `backlog.md` describing the goals, context, and plan.
- When work is finished: delete the entry from `backlog.md` — git history keeps the record.
- Write each entry so it stands on its own: what is planned or left, and why it was designed/stopped where it was.
- `.chezmoiignore` excludes `backlog.md` so chezmoi does not apply it to the home directory.

## Architecture

**Brewfile system**: each machine has its own list — `Brewfile.tmpl` includes exactly one of `.chezmoitemplates/Brewfile.personal_mac` or `Brewfile.work_mac`, chosen by the machine type flag. There is no shared "common" list: a package installed on one machine is declared only there, and `just brew-pick <machine>` copies entries from another machine's list when setting up a new one. Each list opens with an Essentials block — the packages the dotfiles themselves need at shell startup.

**Shell loading order**: `dot_zprofile` (login) → `dot_zshenv.tmpl` (all shells, sets PATH/env) → `dot_zshrc` (interactive, loads tools/plugins/keybindings).

**Sheldon caching**: Shell plugins via sheldon are cached to `~/.cache/sheldon.zsh` for fast startup. The cache auto-regenerates when `plugins.toml` changes.

**Editor settings**: `.chezmoitemplates/editor-settings.tmpl` is a shared template for VS Code settings under `private_dot_Library/`.

## CI

GitHub Actions (`.github/workflows/lint.yml`) runs on pushes/PRs to main:
- ShellCheck on `dot_zsh/*.zsh` and Raycast scripts
- fcat tests on macOS runner
- chezmoi doctor + template validation
