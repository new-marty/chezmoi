# Dotfiles

macOS dotfiles managed with [chezmoi](https://www.chezmoi.io/). The core
(zsh, git, SSH and editorconfig) applies to any machine with no configuration.
Settings for VS Code, Cursor, Ghostty, tmux, navi, mise, Karabiner-Elements and a `justfile` apply
only on machines that opt in to them. Nothing in the repository identifies a
person: names, email addresses, keys and hosts go in local files that chezmoi
never touches.

This page covers installing and day-to-day use. The aliases, keybindings and
commands are in [the documentation](docs/en/README.md)
([日本語](docs/ja/README.md)).

## Install

1. Install chezmoi and clone this repository into chezmoi's source directory.
   To keep your own changes in git, fork the repository first and use your
   fork's name here.

   ```bash
   brew install chezmoi
   chezmoi init new-marty/chezmoi
   ```

2. See what would change in your home directory:

   ```bash
   chezmoi diff
   ```

3. Move what you want to keep out of the files that will be replaced. These
   dotfiles replace `~/.zshrc`, `~/.zshenv`, `~/.zprofile`, `~/.ssh/config`,
   `~/.editorconfig` and `~/.gitignore_global`, and add `~/.zsh/` and
   `~/.config/git/config`. Copy your own aliases and functions into `~/.zshrc.local`, `PATH` entries
   and environment variables into `~/.zshenv.local`, and SSH hosts into
   `~/.ssh/config.local`. The shared files read these local files, as described
   [below](#put-your-own-settings-in-local-files). An existing `~/.gitconfig` is
   kept as it is.

4. Apply. For each file you already have, chezmoi asks first; choose diff to
   compare, then overwrite or skip:

   ```bash
   chezmoi apply --less-interactive
   ```

5. Open a new terminal.

Do not start with `chezmoi init --apply` or a plain `chezmoi apply`. Both
overwrite an existing `~/.zshrc`, `~/.ssh/config` and the like without asking
([chezmoi issue #1551](https://github.com/twpayne/chezmoi/issues/1551)).
`--less-interactive` needs chezmoi v2.66.0 or later (`chezmoi --version`).

`chezmoi init` asks no questions and needs no config file. The tools the shell
uses (eza, bat, fzf and so on) are all optional: an alias or integration is set
only when its tool is installed, so a missing tool leaves the original command
working. With [just](https://just.systems/) installed,
`just --justfile "$(chezmoi source-path)/justfile" doctor` lists which ones you
have.

## Change a setting

| To                                         | Run                                         |
| ------------------------------------------ | ------------------------------------------- |
| Edit a managed file                        | `chezmoi edit ~/.zshrc` (alias `cme`)        |
| See what applying would change             | `chezmoi diff` (alias `cmd`)                 |
| Write the changes to your home directory   | `chezmoi apply` (alias `cma`)                |
| Pull this repository's changes and apply   | `chezmoi update` (alias `cmu`)               |
| Go to the repository to commit and push    | `chezmoi cd` (alias `cmcd`)                  |
| Edit this machine's chezmoi config         | `chezmoi edit-config`                        |

Edit through chezmoi rather than the file in your home directory. If you do
edit the file in place, the next `chezmoi apply` asks whether to overwrite it;
`chezmoi re-add ~/.zshrc` copies the change back into the repository instead
(this does not work for files generated from a `.tmpl` template).

To add an alias or change one only on your machine, put it in
`~/.zshrc.local`. To change one for every machine, edit the shared file with
`chezmoi edit ~/.zsh/alias.zsh` and apply. Either way, `sz` or a new terminal
loads the change.

## Opt in to application settings

List the switches you want in `~/.config/chezmoi/chezmoi.toml` (open it with
`chezmoi edit-config`), then apply. Use `--less-interactive` again, because a
plain `chezmoi apply` overwrites an existing `~/.config/ghostty/config` and the
like without asking:

```bash
chezmoi apply --less-interactive
```

```toml
[data]
    optin = ["vscode", "editor-extensions", "ghostty", "tmux"]
```

| Switch     | Configures                                                  |
| ---------- | ----------------------------------------------------------- |
| `vscode`   | VS Code settings, keybindings and extension list            |
| `cursor`   | Cursor settings (same template as VS Code)                  |
| `ghostty`  | Ghostty terminal config and theme                           |
| `tmux`     | tmux config, plus a one-time install of its plugin manager  |
| `navi`     | navi cheat sheets                                           |
| `mise`     | mise global tool versions                                   |
| `justfile` | `~/justfile` with update and diagnostic recipes             |
| `karabiner`| Karabiner-Elements rules (`~/.config/karabiner` links into the repository) |
| `omz`      | zsh plugins loaded with Oh My Zsh instead of sheldon        |
| `editor-extensions` | VS Code and Cursor look: Poimandres and catppuccin extensions, Hack Nerd Font |
| `editor-builtin` | VS Code and Cursor look: built-in theme in the Poimandres colours, system fonts |

With `vscode` or `cursor`, pick exactly one of `editor-extensions` and
`editor-builtin`. There is no default; `chezmoi apply` stops until you pick one.

Removing a switch later deletes nothing: chezmoi stops managing those files
and leaves them where they are. [Setup in detail](docs/en/setup.md) lists the
files each switch writes and how to clean up after removing one.

## Work Mac

A Mac whose software allow-list has Oh My Zsh but not sheldon, editor
extensions or Nerd Fonts opts in to what it can use: `omz` loads the zsh
plugins with Oh My Zsh (installed by hand from its zip) from copies kept in this
repository, so applying clones nothing, and `editor-builtin` makes the Cursor
settings use the built-in theme and system fonts. [Work Mac](docs/en/work-mac.md)
has the allow-list, installing Oh My Zsh, and moving from a hand-made setup.

```toml
[data]
    optin = ["omz", "cursor", "editor-builtin"]
```

## Put your own settings in local files

These files belong to the machine. The repository never holds their contents.

| File                  | Read                          | Put here                                   |
| --------------------- | ----------------------------- | ------------------------------------------ |
| `~/.zshenv.local`     | at the end of `~/.zshenv`     | extra `PATH` entries, environment variables |
| `~/.zshrc.local`      | at the end of `~/.zshrc`      | your own aliases and functions             |
| `~/.gitconfig`        | by git, after the shared config | `user.name`, `user.email`, commit signing |
| `~/.ssh/config.local` | at the top of `~/.ssh/config` | hosts, keys, the SSH agent                 |

The `.local` files are read only if they exist. chezmoi creates `~/.gitconfig`
once, holding only a comment, and never changes it after that. A minimal one:

```ini
[user]
    name = Your Name
    email = you@example.com
```

[Setup in detail](docs/en/setup.md) explains the order these files are read
in, where to keep API keys, and what to do if this repository wrote an older
`~/.gitconfig` to your machine.

## Repository layout

```
.
├── dot_zshenv.tmpl, dot_zprofile.tmpl, dot_zshrc   # zsh startup files
├── dot_zsh/                      # aliases, commands, prompt theme, widgets
│   └── omz-custom/               # zsh plugins for Oh My Zsh (omz switch, vendored)
├── create_dot_gitconfig          # ~/.gitconfig, created once for local settings
├── dot_gitignore_global
├── dot_editorconfig
├── private_dot_ssh/              # ~/.ssh/config
├── private_dot_config/           # git (shared config), ghostty, mise, navi, sheldon, tmux
├── private_Library/              # VS Code and Cursor settings (macOS)
├── karabiner/                    # Karabiner-Elements config, linked from ~/.config/karabiner
├── .chezmoidata/optin.toml       # opt-in switches, the files each one writes, required choices
├── .chezmoitemplates/            # settings template shared by VS Code and Cursor
├── run_once_before_install-tpm.sh.tmpl   # installs the tmux plugin manager (tmux switch)
├── justfile
└── docs/                         # usage notes in English (en) and Japanese (ja)
```

chezmoi turns source names into target names: `dot_` becomes `.`, `private_`
restricts permissions, and `.tmpl` files are Go templates.
