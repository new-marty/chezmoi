# Dotfiles

zsh, git, SSH and editorconfig settings for macOS, managed with
[chezmoi](https://www.chezmoi.io/), plus optional settings for VS Code, Cursor,
Ghostty, tmux, navi, mise and a `justfile`. The core applies with no
configuration; each set of application settings applies only on a machine that
opts in to it. The setup uses the tools it finds and leaves the stock commands
in place for the ones it does not.

## Try it

```bash
brew install chezmoi
chezmoi init new-marty/chezmoi
chezmoi diff                          # see what would change in your home directory
chezmoi apply --less-interactive      # asks before overwriting a file you already have
```

`--less-interactive` needs chezmoi v2.66.0 or later (`chezmoi --version`). Do not
start with `chezmoi init --apply`, and do not run a plain `chezmoi apply` the
first time: both overwrite an existing `~/.zshrc`, `~/.ssh/config` and the like
without asking ([chezmoi issue #1551](https://github.com/twpayne/chezmoi/issues/1551)).

`chezmoi init` asks no questions and needs no `chezmoi.toml`. Nothing here holds
a name, an email address, a key or a host, so the files apply the same way on
every machine.

## Opt-in application settings

Without configuration you get only the core: zsh, git, SSH and editorconfig.
The settings below are applied only on a machine that lists their switch in
`~/.config/chezmoi/chezmoi.toml`:

```toml
[data]
    optin = ["vscode", "ghostty", "tmux"]
```

| Switch     | Files chezmoi writes (under `~`)                                   | What it configures                   |
| ---------- | ------------------------------------------------------------------ | ------------------------------------ |
| `vscode`   | `Library/Application Support/Code/User/` `settings.json`, `keybindings.json`, `extensions.json` | VS Code settings and keybindings |
| `cursor`   | `Library/Application Support/Cursor/User/settings.json`            | Cursor settings                      |
| `ghostty`  | `.config/ghostty/config`, `.config/ghostty/themes/poimandres.ghostty` | Ghostty terminal config and theme |
| `tmux`     | `.config/tmux/tmux.conf`, `.config/tmux/cheatsheet.md`, plus a one-time clone of the tmux plugin manager (tpm) into `~/.tmux/plugins/tpm` | tmux |
| `navi`     | `.config/navi/cheats/cheats.cheat`                                 | navi cheat sheets                    |
| `mise`     | `.config/mise/config.toml`                                         | mise global tool versions            |
| `justfile` | `justfile`                                                         | `~/justfile` with update and diagnostic recipes |

VS Code and Cursor read settings in the same format from different places, so
both `settings.json` files are generated from one shared template and you can
select either or both. The full table lives in `.chezmoidata/optin.toml`; a name
that is not in it stops `chezmoi apply` with an error that lists the valid ones.

Removing a switch does not delete anything. chezmoi stops managing that
switch's files without telling you and leaves them on disk as they were, where
they go stale. The same happens if you already used these dotfiles before
switches existed: write the `optin` list before your next `chezmoi apply`, or
the settings you meant to keep drop out of management.

`just optin` shows, for every switch, whether this machine selects it, whether
its files exist and whether chezmoi still manages them. For files that chezmoi
wrote, no longer manages and that nobody has changed since, it prints the `rm`
commands to remove them. Files changed since chezmoi wrote them are listed for
you to review instead, with no command. It suggests deleting files only. Directories such as
`~/Library/Application Support/Cursor` also hold the application's own data
(extensions, workspace state), so never delete those to opt out. Without
`~/justfile`, run it as `just --justfile "$(chezmoi source-path)/justfile" optin`.

## Machine-local files

Anything that differs between machines goes in a local file that the shared
file reads, so these files are where your identity, keys and private hosts
belong. The repository never holds their contents. chezmoi does not manage the
three `*.local` files, and each is read only if it exists. `~/.gitconfig` is
different: chezmoi creates it, with only a comment, when it is missing, so it
always exists after an apply, but chezmoi never changes it after that.

| File                   | Read by          | Typical contents                                     |
| ---------------------- | ---------------- | ---------------------------------------------------- |
| `~/.zshenv.local`      | end of `.zshenv` | extra `PATH` entries, environment switches           |
| `~/.zshrc.local`       | end of `.zshrc`  | personal aliases and functions                       |
| `~/.gitconfig`         | git, after `~/.config/git/config` | `user.name`, `user.email`, commit signing |
| `~/.ssh/config.local`  | top of `.ssh/config` | hosts, `IdentityFile`, `IdentityAgent`           |

The SSH file is included first rather than last because ssh keeps the first
value it finds for each option, so settings in `config.local` override the
shared defaults.

The shared git settings live in `~/.config/git/config`, and `~/.gitconfig`
belongs to the machine. An existing `~/.gitconfig` is kept as it is. git reads
`~/.gitconfig` after `~/.config/git/config`, so its values win, and
`git config --global` writes to it.

If this repository applied an earlier layout to your machine, your
`~/.gitconfig` is a full copy of the old shared settings that chezmoi used to
write there. chezmoi will not replace it, and because git reads it last, it
keeps overriding `~/.config/git/config`, including the editor choice described
under "Optional tools". Cut it down to your own settings (name, email, signing,
deliberate overrides) and remove its `[include]` of `~/.gitconfig.local`,
moving anything in that file into `~/.gitconfig`.

A minimal `~/.gitconfig`:

```ini
[user]
    name = Your Name
    email = you@example.com
```

Keep API keys out of shell startup files: anything exported there reaches
every process the shell starts. Store a key in the macOS Keychain with
`security add-generic-password -a "$USER" -s my-api-key -w`, and read it with
`security find-generic-password -a "$USER" -s my-api-key -w` only where it is
needed, such as a project's direnv `.envrc` or a function in `~/.zshrc.local`.

## Optional tools

Every tool below is optional. The shell checks for each one when it starts and
only then sets the alias or loads the integration, so a missing tool leaves the
original command working. For example, `ls` runs eza only when eza is
installed.

| Area            | Tools                                                    |
| --------------- | -------------------------------------------------------- |
| Shell plugins   | sheldon (without it, `~/.zsh/*.zsh` is sourced directly) |
| History, `cd`   | atuin, zoxide, peco, fzf, navi                           |
| Replacements    | eza (`ls`), bat (`cat`), dust (`du`), duf (`df`), procs (`ps`), btm (`top`), lazygit (`lg`), colordiff (`diff`) |
| Environment     | mise, direnv, thefuck                                    |
| Git             | delta (pager), Cursor or VS Code (`core.editor`)         |
| Editor alias    | Cursor or VS Code (`c`)                                  |

The git config and the editor choice are the exceptions to checking at startup:
chezmoi decides when it renders the files. git's `core.editor` and the shell
alias `c` open the same editor: Cursor (`cursor --wait`) when `cursor` is in the
`optin` list and the `cursor` command exists, otherwise VS Code (`code --wait`)
when `code` exists, otherwise none. After installing delta, Cursor or VS Code,
run `chezmoi apply` again. To use another editor on one machine, set
`core.editor` in `~/.gitconfig` and redefine `c` in `~/.zshrc.local`.

`just doctor` lists which of these are installed. To set up a new machine from
an existing one, run `brew bundle dump --file=-` on the old machine and install
what you want from that list.

## Custom commands and keybindings

| Command  | Description                          |
| -------- | ------------------------------------ |
| `help`   | Show custom commands and keybindings |
| `fcat`   | Recursively display file contents    |
| `ts2mp4` | Convert TS files to MP4              |
| `mkcd`   | Create a directory and cd into it    |
| `cdf`    | Fuzzy find and cd to a directory     |

| Key      | Function                          |
| -------- | --------------------------------- |
| `Ctrl+G` | Command templates                 |
| `Ctrl+S` | Smart suggestions (context-aware) |
| `Ctrl+F` | Frequently used commands          |
| `Ctrl+N` | Navi cheat sheets                 |
| `Ctrl+R` | Peco history search               |
| `Ctrl+H` | Atuin history search              |

`justfile` (applied to `~/justfile` with the `justfile` switch) has recipes for
updates and diagnostics; `just` lists them.

## Repository layout

```
.
├── dot_zshenv.tmpl, dot_zprofile.tmpl, dot_zshrc   # zsh startup files
├── dot_zsh/                      # aliases, commands, prompt theme, widgets
├── create_dot_gitconfig          # ~/.gitconfig, created once for local settings
├── dot_gitignore_global
├── dot_editorconfig
├── private_dot_ssh/              # ~/.ssh/config
├── private_dot_config/           # git (shared config), ghostty, mise, navi, sheldon, tmux
├── private_Library/              # VS Code and Cursor settings (macOS)
├── .chezmoidata/optin.toml       # opt-in switches and the paths each controls
├── .chezmoitemplates/            # settings template shared by VS Code and Cursor
├── run_once_before_install-tpm.sh.tmpl   # clones the tmux plugin manager (tmux switch)
├── justfile
└── docs/                         # per-topic notes (English and Japanese)
```

chezmoi maps the prefixes to target names: `dot_` becomes `.`, `private_`
restricts permissions, and `.tmpl` files are Go templates.

## Documentation

- [Core tools](docs/en/core-tools.md): chezmoi, sheldon, atuin, zoxide, navi, fzf
- [Modern CLI](docs/en/modern-cli.md): lazygit, dust, duf, procs, btm
- [Shell commands](docs/en/shell-commands.md): fcat, ts2mp4, mkcd, cdf
- [Git](docs/en/git.md): aliases, lazygit, delta
- [Keybindings](docs/en/keybindings.md)
- [Aliases](docs/en/aliases.md)
- [SSH](docs/en/ssh-setup.md)

Japanese versions are in [docs/ja](docs/ja/README.md).
