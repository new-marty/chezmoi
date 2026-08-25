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
- `.is_personal_mac`, `.is_work_mac`, `.is_windows`, `.is_linux` — machine type flags
- `.git_name`, `.git_email`, `.ssh_signing_key` — user identity
- `.chezmoi.os`, `.chezmoi.hostname`, `.chezmoi.homeDir` — built-in chezmoi variables
- Secrets come from 1Password CLI via `onepasswordItemFields "Dotfiles Secrets" "Personal"`

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

## Architecture

**Brewfile system**: `Brewfile.tmpl` composes from `.chezmoitemplates/Brewfile.common`, `Brewfile.personal_mac`, and `Brewfile.work_mac` based on machine type flags.

**Shell loading order**: `dot_zprofile` (login) → `dot_zshenv.tmpl` (all shells, sets PATH/env) → `dot_zshrc` (interactive, loads tools/plugins/keybindings).

**Sheldon caching**: Shell plugins via sheldon are cached to `~/.cache/sheldon.zsh` for fast startup. The cache auto-regenerates when `plugins.toml` changes.

**Editor settings**: `.chezmoitemplates/editor-settings.tmpl` is a shared template for VS Code settings under `private_dot_Library/`.

## CI

GitHub Actions (`.github/workflows/lint.yml`) runs on pushes/PRs to main:
- ShellCheck on `dot_zsh/*.zsh` and Raycast scripts
- fcat tests on macOS runner
- chezmoi doctor + template validation
