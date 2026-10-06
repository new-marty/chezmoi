# Work Mac (`profile = "work"`)

The work profile is for a Mac with a software allow-list: Oh My Zsh is allowed
but sheldon is not, `git clone` is blocked, and editor extensions and Nerd Fonts
cannot be installed. The shell, git and editor settings are the same files as
on any other machine; the profile changes only how zsh loads its plugins and
how the VS Code and Cursor settings get their colours and fonts.

## What the profile changes

| Area                        | `full` (the default)                       | `work`                                                       |
| --------------------------- | ------------------------------------------ | ------------------------------------------------------------ |
| zsh plugin loader           | sheldon (`~/.config/sheldon/plugins.toml`) | Oh My Zsh, installed by hand in `~/.oh-my-zsh`               |
| zsh plugins                 | cloned by sheldon                          | `git`, plus three plugins kept in this repository and written to `~/.zsh/omz-custom` |
| Aliases, commands, prompt   | `~/.zsh/*`                                 | the same `~/.zsh/*`                                          |
| Up/Down arrows              | zsh's own history keys                     | history search for what is typed so far (zsh-history-substring-search) |
| Editor colour theme         | Poimandres extension                       | built-in Default Dark Modern, recoloured with the Poimandres colours |
| Editor and terminal font    | Hack Nerd Font                             | SF Mono, Menlo, Monaco                                       |
| Editor icon theme           | catppuccin-mocha extension                 | the built-in default                                         |
| Editor integrated terminal  | the editor's default                       | a login shell (`zsh -l`), so `~/.zprofile` sets up Homebrew  |

With Oh My Zsh not installed yet, the shell still starts: it sources `~/.zsh/*`
without plugins, as on a machine without sheldon. `just doctor` prints the
profile and which loader is in use.

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
| Oh My Zsh                    | allowed                | Loads the zsh plugins                                                    |
| sheldon                      | not allowed            | Not used by the work profile                                             |
| `git clone`                  | blocked                | Applying clones nothing (do not select the `tmux` switch: it clones tpm) |
| fzf, peco, atuin, eza, bat, zoxide, direnv, mise, navi, delta | not allowed for now | Each alias or key that needs one is set only when it is installed, so the stock command or key keeps working (`Ctrl+R` is zsh's own history search) |
| Ghostty, Hack Nerd Font      | not allowed            | Not needed: iTerm2 and system fonts are used                             |
| Editor extensions            | cannot be installed    | Colours come from settings, not from an extension                        |

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
chezmoi and already holds the Oh My Zsh settings. chezmoi writes nothing into
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

## Select the profile

Open the chezmoi config with `chezmoi edit-config` and write:

```toml
[data]
    profile = "work"
    optin = ["cursor"]
```

A value other than `full` or `work` stops `chezmoi apply` with an error listing
the valid ones. Leaving `profile` out means `full`.

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

3. Get the repository and select the profile, as above.
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

## When sheldon is allowed

Change `profile` to `"full"` (or remove the line), install sheldon, and apply.
The editor settings then switch to the Poimandres extension, the catppuccin
icon theme and Hack Nerd Font, so install those first. chezmoi stops managing
`~/.zsh/omz-custom` and leaves it on disk; delete it, and `~/.oh-my-zsh` if
nothing else uses it.
