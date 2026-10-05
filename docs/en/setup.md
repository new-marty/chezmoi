# Setup in detail

The [top-level README](../../README.md) has the install steps. This page covers
what they leave out: the files each opt-in switch writes, how the
machine-local files are read, how the editor is chosen, and how to move a
machine off an earlier layout of this repository.

## Opt-in switches

The core (zsh, git, SSH, editorconfig) always applies. Everything below applies
only when its switch is in the `optin` list of
`~/.config/chezmoi/chezmoi.toml`:

```toml
[data]
    optin = ["vscode", "ghostty", "tmux"]
```

| Switch     | Files chezmoi writes (under `~`)                                    |
| ---------- | ------------------------------------------------------------------- |
| `vscode`   | `Library/Application Support/Code/User/settings.json`, `keybindings.json`, `extensions.json` |
| `cursor`   | `Library/Application Support/Cursor/User/settings.json`             |
| `ghostty`  | `.config/ghostty/config`, `.config/ghostty/themes/poimandres.ghostty` |
| `tmux`     | `.config/tmux/tmux.conf`, `.config/tmux/cheatsheet.md`; also clones the tmux plugin manager (tpm) into `~/.tmux/plugins/tpm` once |
| `navi`     | `.config/navi/cheats/cheats.cheat`                                  |
| `mise`     | `.config/mise/config.toml`                                          |
| `justfile` | `justfile`                                                          |

VS Code and Cursor read settings in the same format from different places, so
both `settings.json` files come from one template and you can select either or
both. The switches and their files are defined in `.chezmoidata/optin.toml`,
and this table copies it. A name that is not in it stops `chezmoi apply` with an
error listing the valid names.

After changing the list, apply with `chezmoi apply --less-interactive`. A plain
`chezmoi apply` overwrites a file that already exists, such as your own
`~/.config/ghostty/config`, without asking.

### Removing a switch

Removing a switch deletes nothing. chezmoi stops managing that switch's files
without saying so and leaves them on disk, where they go stale. The same
happens on a machine that used these dotfiles before switches existed: write
the `optin` list before the next `chezmoi apply`, or the settings you meant to
keep fall out of management.

`just optin` shows, for each switch, whether this machine selects it, whether
its files exist and whether chezmoi still manages them. For a file that chezmoi
wrote, no longer manages and nobody has changed since, it prints an `rm`
command. A file that was changed after chezmoi wrote it is listed for you to
review, with no command. It needs [just](https://just.systems/). Without
`~/justfile`, run it as
`just --justfile "$(chezmoi source-path)/justfile" optin`.

**Delete files only, never their directories.** A directory such as
`~/Library/Application Support/Cursor` also holds the application's own data
(extensions, workspace state).

## Machine-local files

Anything that differs between machines goes in a local file that a shared file
reads. Your name, keys and private hosts belong there, and the repository never
holds them.

| File                  | Read                                     | Put here                                   |
| --------------------- | ---------------------------------------- | ------------------------------------------ |
| `~/.zshenv.local`     | at the end of `~/.zshenv`                | extra `PATH` entries, environment variables |
| `~/.zshrc.local`      | at the end of `~/.zshrc`                 | your own aliases and functions             |
| `~/.gitconfig`        | by git, after `~/.config/git/config`     | `user.name`, `user.email`, commit signing  |
| `~/.ssh/config.local` | at the top of `~/.ssh/config`            | hosts, `IdentityFile`, `IdentityAgent`     |

chezmoi does not manage the three `.local` files, and each is read only if it
exists. Their settings override the shared ones. The two zsh files get there by
being read last. `~/.ssh/config.local` is read first instead, because ssh keeps
the first value it finds for each option. See [SSH](ssh-setup.md).

### git: `~/.gitconfig` is yours

The shared git settings live in `~/.config/git/config`. git reads
`~/.gitconfig` after it, so values there win, and `git config --global` writes
there. chezmoi creates `~/.gitconfig` with only a comment when it is missing,
and never changes it after that. If you already had one, it stays, and every
setting in it keeps overriding the shared config; remove the ones you want the
shared config to decide. A minimal one:

```ini
[user]
    name = Your Name
    email = you@example.com
```

### Machines set up from an earlier layout

This applies only if you applied this repository before 5 October 2026. An
earlier version of this repository wrote all of its git settings into
`~/.gitconfig`. chezmoi will not replace that file, and because git reads it
last, it keeps overriding `~/.config/git/config`, including the editor choice
below. Cut it down to your own settings (name, email, signing and any override
you mean to keep). If it has an `[include]` of `~/.gitconfig.local`, move that
file's contents into `~/.gitconfig` and remove the include.

### API keys

Keep API keys out of shell startup files: anything exported there reaches every
process the shell starts. Store a key in the macOS Keychain:

```bash
security add-generic-password -a "$USER" -s my-api-key -w
```

and read it only where it is needed, such as a project's direnv `.envrc` or a
function in `~/.zshrc.local`:

```bash
security find-generic-password -a "$USER" -s my-api-key -w
```

## How the editor is chosen

git's `core.editor` and the shell alias `c` open the same editor, and chezmoi
picks it when it writes the files, not when the shell starts:

1. Cursor (`cursor --wait`), if `cursor` is in the `optin` list and the `cursor`
   command exists.
2. Otherwise VS Code (`code --wait`), if the `code` command exists.
3. Otherwise none: `core.editor` is left unset and `c` is not defined.

The same applies to delta, git's pager: it is set only if delta is installed
when chezmoi writes the git config. After installing Cursor, VS Code or delta,
run `chezmoi apply` again.

To use another editor on one machine, set `core.editor` in `~/.gitconfig` and
set `DOTFILES_GUI_EDITOR` in `~/.zshenv.local` (or redefine `c` in
`~/.zshrc.local`).

## Setting up a new machine

There is no package list in this repository. On the old machine, run
`brew bundle dump --file=-` and install what you want from its output on the
new one. Then follow the install steps in the README.
