# Work Mac

This page is for a Mac with a software allow-list: Oh My Zsh is allowed but
sheldon is not, `git clone` is blocked, and editor extensions and Nerd Fonts
cannot be installed. Nothing here defines that Mac as an environment; it opts
in to the switches that fit what it can use, like any other machine.

## What to opt in to

| Switch           | What it does                                                                                     |
| ---------------- | ------------------------------------------------------------------------------------------------ |
| `omz`            | zsh loads its plugins with Oh My Zsh, installed by hand in `~/.oh-my-zsh`, instead of sheldon: `git`, plus three plugins kept in this repository and written to `~/.zsh/omz-custom`. Up/Down then search history for what is typed so far. |
| `cursor`         | Cursor settings, as on any machine                                                               |
| `editor-builtin` | The Cursor (and VS Code) settings colour the built-in Default Dark Modern theme with the Poimandres colours and use SF Mono, Menlo or Monaco, instead of the Poimandres and catppuccin extensions and Hack Nerd Font (`editor-extensions`) |

`editor-builtin` and `editor-extensions` have no default: with `cursor` or
`vscode` selected, exactly one of them must be selected too.

The aliases, commands and prompt are the same `~/.zsh/*` files on every
machine. Without Oh My Zsh installed yet, the shell still starts: it sources
`~/.zsh/*` without plugins, as on a machine without sheldon. `just doctor`
prints which loader is in use.

The plugins that Oh My Zsh does not ship are kept in `dot_zsh/omz-custom`,
pinned to a release, so that applying needs no clone:

| Plugin                         | Version |
| ------------------------------ | ------- |
| zsh-autosuggestions            | v0.7.1  |
| zsh-syntax-highlighting        | 0.8.0   |
| zsh-history-substring-search   | v1.1.0  |

To move to a newer release, change its pin in `scripts/vendor-omz-plugins.sh`,
run the script on a machine that can clone, and commit the result.

## What the allow-list means here

| Tool                         | On the work Mac        | What the dotfiles do                                                     |
| ---------------------------- | ---------------------- | ------------------------------------------------------------------------ |
| chezmoi                      | to be requested        | Nothing on this page applies until it is installed                       |
| Oh My Zsh                    | allowed                | Loads the zsh plugins (`omz`)                                            |
| sheldon                      | not allowed            | Not used when `omz` is selected                                          |
| `git clone`                  | blocked                | Applying clones nothing (do not select the `tmux` switch: it clones tpm) |
| fzf, peco, atuin, eza, bat, zoxide, direnv, mise, navi, delta | not allowed for now | Each alias or key that needs one is set only when it is installed, so the stock command or key keeps working (`Ctrl+R` is zsh's own history search) |
| Ghostty, Hack Nerd Font      | not allowed            | Not needed: iTerm2 and system fonts are used                             |
| Editor extensions            | cannot be installed    | Colours come from settings, not from an extension (`editor-builtin`)     |

Ask IT for a tool when you miss it; nothing needs to change in the repository
when one is installed, apart from running `chezmoi apply` again for git's pager
(delta) and editor choice.

## Install Oh My Zsh once, from its zip

```bash
curl -fsSL -o ~/Downloads/ohmyzsh.zip https://github.com/ohmyzsh/ohmyzsh/archive/refs/heads/master.zip
unzip -q ~/Downloads/ohmyzsh.zip -d ~/Downloads
mv ~/Downloads/ohmyzsh-master ~/.oh-my-zsh
```

Do not run Oh My Zsh's `install.sh`: it replaces `~/.zshrc`, which comes from
chezmoi and already loads Oh My Zsh when `omz` is selected. chezmoi writes nothing into
`~/.oh-my-zsh`, so updating Oh My Zsh means replacing that directory with a
newer zip. Its own update check is turned off, because it runs git.

## Get the repository

If `chezmoi init` can clone on this Mac, use it:

```bash
chezmoi init new-marty/chezmoi
```

If the clone is blocked, put the repository's zip where chezmoi looks for its
source instead. To update later, replace that directory with a newer zip;
`chezmoi update` needs git and will not work.

```bash
curl -fsSL -o ~/Downloads/chezmoi-src.zip https://github.com/new-marty/chezmoi/archive/refs/heads/main.zip
unzip -q ~/Downloads/chezmoi-src.zip -d ~/Downloads
mkdir -p ~/.local/share
mv ~/Downloads/chezmoi-main ~/.local/share/chezmoi
```

## Select the switches

Open the chezmoi config with `chezmoi edit-config` and write:

```toml
[data]
    optin = ["omz", "cursor", "editor-builtin"]
```

## Move from the old `~/.dotfiles/` setup

The work Mac was set up by hand from a zip in `~/.dotfiles/`, with symlinks
from the home directory into it. To move it to chezmoi:

1. Copy what belongs to this Mac into the local files, which chezmoi never
   writes (see [Setup in detail](setup.md#machine-local-files)):
   - git: the old `~/.gitconfig` held every setting. Keep only `user.name`,
     `user.email` and any signing settings in `~/.gitconfig`; the rest now comes
     from `~/.config/git/config`. git reads `~/.gitconfig` last, so anything
     left there overrides the shared config.
   - secrets and extra `PATH` entries: `~/.zshenv.local`.
   - your own aliases and functions: `~/.zshrc.local`.
2. Remove the symlinks into `~/.dotfiles/` (only the links; the directory stays
   as a backup). This lists them:

   ```bash
   find ~ ~/.config ~/Library/Application\ Support/Cursor/User -maxdepth 1 -type l -lname "$HOME/.dotfiles/*"
   ```

3. Get the repository and select the switches, as above.
4. Review what applying would write. Compare the Cursor settings with the old
   `~/.dotfiles/cursor/settings.json`, and move anything you still want into
   the repository first:

   ```bash
   chezmoi diff
   ```

5. Apply. For each file that already exists, chezmoi asks first:

   ```bash
   chezmoi apply --less-interactive
   ```

6. Open a new terminal and check the prompt (steeef, with the clock), an alias
   such as `gst`, and `just --justfile "$(chezmoi source-path)/justfile" doctor`
   if just is installed.
7. Once everything works, delete `~/.dotfiles/`.

## iTerm2 colours

The iTerm2 profile is not managed by chezmoi; set it up by hand. The prompt
does not depend on it: in a truecolor terminal (iTerm2, the VS Code and Cursor
terminals) the steeef theme writes the Poimandres colours as hex values. For
the colours of everything else, import a Poimandres colour preset in iTerm2
(Settings → Profiles → Colors → Color Presets → Import). The colour values are
in `private_dot_config/ghostty/themes/poimandres.ghostty`.

The prompt shows the clock on the right in iTerm2 and other terminals. The VS
Code and Cursor terminals do not show a right-hand prompt, so there the clock
goes at the end of the first prompt line.

## When sheldon or the extensions are allowed

Each switch changes on its own. For sheldon, install it, remove `omz` from the
list and apply; chezmoi stops managing `~/.zsh/omz-custom` and leaves it on
disk, so delete it, and `~/.oh-my-zsh` if nothing else uses it. For the editor
look, install the Poimandres and catppuccin extensions and Hack Nerd Font,
replace `editor-builtin` with `editor-extensions` and apply.
