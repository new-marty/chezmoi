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

just lint                  # zsh -n on zsh files, ShellCheck on bash/sh scripts
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

## Public Repository and Machine-Local Files

The repository is public, and applying it must work for a stranger with an empty
`chezmoi.toml` and none of the optional tools. CI (`fresh-apply`) checks this. README
tells people to run `chezmoi init`, `chezmoi diff`, then `chezmoi apply
--less-interactive`, because a first plain apply overwrites their existing files.

- Templates use only built-in variables (`.chezmoi.os`, `.chezmoi.hostname`, ...),
  repo data from `.chezmoidata/`, functions such as `lookPath`, and one piece of machine
  data: the optional `optin` list, always read as `dig "optin" list .`. Do not add any
  other `chezmoi.toml` data: chezmoi's default `missingkey=error` makes a missing key
  fail the whole apply for a stranger.
- Never define machines or environments (no `profile = "work"`, no per-machine
  branches): a machine opts in to the things it uses, one switch each. Where a
  selected switch needs a choice between alternatives, there is no default either: list
  it under `[optin_choices.<name>]` (`required_by`, `options`) in `.chezmoidata/optin.toml`
  and `.chezmoiignore` `fail`s unless exactly one option is selected (and when an option
  is selected without any switch that needs it). A switch may write
  no files and only change a template (`editor-extensions`/`editor-builtin` in
  `.chezmoitemplates/editor-settings.tmpl`).
- App settings are opt-in. `.chezmoidata/optin.toml` (`[optin_paths.<switch>]`) lists
  each switch's `files` (exactly what chezmoi writes; CI fails when they drift from
  `chezmoi managed`), `dirs` (ignored so no empty dirs leak, never offered for
  deletion because they hold app data) and `scripts`; `.chezmoiignore` ignores all three
  for unselected switches and `fail`s on an unknown name. A new app config needs a
  switch there, because ignored files are never deleted and an unselected stranger must
  not get it. The core (zsh, git, ssh, editorconfig) is never behind a switch.
- Anything that belongs to the owner (names, emails, keys, hosts, accounts, employer or
  client names, personal tools) goes in a machine-local file whose contents the
  repository never holds: `~/.zshenv.local`, `~/.zshrc.local` and `~/.ssh/config.local`
  (unmanaged, read only if present; the ssh one is included first, because ssh keeps the
  first value), and `~/.gitconfig` (always present, see the git item below).
- git: the shared config is `private_dot_config/git/config.tmpl` (`~/.config/git/config`).
  `~/.gitconfig` is machine-local: `create_dot_gitconfig` writes it only when absent.
  git reads it after `~/.config/git/config`, so it wins, and `git config --global`
  writes there instead of into a chezmoi-managed file.
- git `core.editor` (in the git config template) and the `c` alias (`DOTFILES_GUI_EDITOR`
  in `dot_zshenv.tmpl`, used by `dot_zsh/alias.zsh`) use the same rule: Cursor when
  `cursor` is opted in and installed, else VS Code when installed. Change both together.
- Guard every alias or integration for an optional tool with `command -v`, so the stock
  command still works when the tool is missing.
- There is no package list. A new machine is set up by hand from
  `brew bundle dump --file=-` on the old one.

## Contexts and Machines

The owner works in four contexts, and accounts, credentials, and settings must stay
separate between them:

- Main job: the employer.
- Side job: Starup. Its repositories live under `~/starup`, and Orca (a desktop app that
  runs coding agents in parallel worktrees) puts its worktrees under
  `~/orca/workspaces/archaive-pj`.
- Sole proprietorship: new-marty.
- Personal.

The side job, the sole proprietorship, and personal use share one Mac, so anything that
must differ between them is switched by working directory. These switches are personal, so
they live in the untracked local files, not in this repository: `~/.zshenv.local` selects
the Starup Claude Code account inside Starup directories and leaves the personal account
as the default everywhere else.

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

Provider-specific paths (agent socket, signing program) live only in `~/.ssh/config.local`
and `~/.gitconfig`, so switching providers means editing those two local files.

## Task Management & Tracking Work

All task planning and tracking live in `backlog.md` at the repository root, not in GitHub Issues.
GitHub Issues are disabled for this repository.

**Rule: Always create an entry in `backlog.md` before starting any work.**
- When starting work: create or update the entry in `backlog.md` describing the goals, context, and plan.
- When work is finished: delete the entry from `backlog.md` — git history keeps the record.
- Write each entry so it stands on its own: what is planned or left, and why it was designed/stopped where it was.
- `.chezmoiignore` excludes `backlog.md` so chezmoi does not apply it to the home directory.

## Architecture

**Shell loading order**: `dot_zshenv.tmpl` (all shells, sets PATH/env and `DOTFILES_OMZ`, then `~/.zshenv.local`) → `dot_zprofile.tmpl` (login; puts back the PATH order that macOS's `path_helper` in `/etc/zprofile` changed) → `dot_zshrc` (interactive, loads tools/plugins/keybindings, then `~/.zshrc.local`).

**Plugin loader**: `dot_zshrc` stays a plain file (so `zsh -n` checks every branch) and picks the loader from `DOTFILES_OMZ` (1 when the `omz` opt-in is selected): Oh My Zsh when selected and `~/.oh-my-zsh` exists (plugins only; `ZSH_CUSTOM=~/.zsh/omz-custom`, vendored by `scripts/vendor-omz-plugins.sh` because the Mac that uses it cannot clone; no OMZ theme; it runs compinit; zsh-syntax-highlighting and zsh-history-substring-search are sourced at the end of `.zshrc`, after every widget), else sheldon when installed, else none. With Oh My Zsh or none, `dot_zshrc` sources `~/.zsh/*.zsh` and the theme directly.

**Sheldon caching**: Shell plugins via sheldon are cached to `~/.cache/sheldon.zsh` for fast startup. The cache auto-regenerates when `plugins.toml` changes.

**Editor settings**: `.chezmoitemplates/editor-settings.tmpl` is the shared template for the VS Code and Cursor `settings.json` under `private_Library/`; each editor's file appends its own keys.

## CI

GitHub Actions (`.github/workflows/lint.yml`) runs on pushes/PRs to main:
- `zsh -n` on `dot_zshrc` and `dot_zsh/` (not the vendored `omz-custom`), ShellCheck on `scripts/*.sh` and the `run_once_` script (ShellCheck does not support zsh)
- fcat tests on macOS runner
- chezmoi doctor + template validation
- `fresh-apply`: apply into an empty home, with paths taken from `.chezmoidata/optin.toml`: empty config (core files only, no `.zsh/omz-custom`, interactive zsh starts), every switch selected, with the first option of each choice (every listed file exists, and the `files` lists match `chezmoi managed` under each switch's `dirs`), `omz` (zsh starts without Oh My Zsh, then loads every plugin from a pinned Oh My Zsh zip), a choice missing, made twice or made without its switch (apply fails) and each option (applies, and both `settings.json` parse as JSONC), an unknown switch (apply fails)
