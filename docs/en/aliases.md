# Aliases

Complete alias reference for this dotfiles setup.

## Git Aliases

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
| `lg`  | `lazygit` (only when lazygit is installed) |

---

## Modern CLI Aliases

Each alias below is set only when its tool is installed; the shell checks when
it starts. Without the tool, the original command runs unchanged (`diff` still
becomes `diff -u`).

| Alias | Command | Original | Description |
| ----- | ------- | -------- | ----------- |
| `ls`  | `eza --icons=auto` | `ls` | List with icons |
| `du`  | `dust` | `du` | Visual disk usage |
| `df`  | `duf` | `df` | Beautiful disk free |
| `ps`  | `procs` | `ps` | Modern process viewer |
| `top` | `btm` | `top` | Graphical system monitor |
| `cat` | `bat --style=plain --paging=never` | `cat` | Syntax-highlighted cat |
| `catp`| `bat` | - | bat with paging and line numbers |
| `diff`| `colordiff -u` | `diff` | Colored diff |

---

## File & Navigation Aliases

| Alias | Command | Description |
| ----- | ------- | ----------- |
| `ls`  | `eza --icons=auto` | List with icons (when eza is installed) |
| `ll`  | `ls -la` | Long format, all files |
| `la`  | `ls -l` | Long format |
| `l1`  | `ls -1` | One file per line |
| `lll` | `eza -abghHliS --git --icons=auto` | Detailed with git status (when eza is installed) |

---

## Package Manager Aliases

| Alias | Command | Description |
| ----- | ------- | ----------- |
| `pp`  | `pnpm` | pnpm |
| `pi`  | `pnpm install` | Install dependencies |
| `pr`  | `pnpm run` | Run script |
| `pd`  | `pnpm dev` | Run dev server |
| `pu`  | `pnpm update` | Update dependencies |
| `pb`  | `pnpm build` | Build project |

---

## Utility Aliases

| Alias | Command | Description |
| ----- | ------- | ----------- |
| `rs`  | `exec zsh -l` | Restart shell |
| `sz`  | `source ~/.zshrc` | Reload zshrc |
| `c`   | Cursor or VS Code | Open the GUI editor (see below) |
| `p`   | `python3` | Python 3 |
| `tf`  | `terraform` | Terraform |
| `dcud`| `docker compose up -d` | Docker compose up, detached |
| `dcu` | `docker compose up` | Docker compose up |
| `dcd` | `docker compose down` | Docker compose down |

`c` opens the same editor as git's `core.editor`. chezmoi picks it when it
renders the files: Cursor when `cursor` is in the `optin` list in
`~/.config/chezmoi/chezmoi.toml` and the `cursor` command exists, otherwise VS
Code when `code` exists. With neither, `c` is not defined. After installing
Cursor or VS Code, run `chezmoi apply` again. The choice is stored in
`DOTFILES_GUI_EDITOR`; to use another editor on one machine, set that variable
in `~/.zshenv.local` or redefine `c` in `~/.zshrc.local`.

---

## Chezmoi Aliases

| Alias | Command | Description |
| ----- | ------- | ----------- |
| `cm`  | `chezmoi` | Chezmoi |
| `cma` | `chezmoi apply` | Apply changes |
| `cmd` | `chezmoi diff` | Show diff |
| `cme` | `chezmoi edit` | Edit file |
| `cmu` | `chezmoi update` | Update from remote |
| `cmcd`| `chezmoi cd` | Go to source |

---

## Help Aliases

| Alias | Command | Description |
| ----- | ------- | ----------- |
| `help`| `show_dotfiles_help` | Show all commands |
| `keys`| `show_keybindings` | Show keybindings |
| `docs`| `open_dotfiles_docs` | Open docs in editor |

---

## Maintenance Aliases

| Alias | Command | Description |
| ----- | ------- | ----------- |
| `update-dev` | (function) | Update all dev tools |

