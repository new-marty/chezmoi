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
| `lg`  | `lazygit` |

---

## Modern CLI Aliases

| Alias | Command | Original | Description |
| ----- | ------- | -------- | ----------- |
| `ls`  | `eza --icons` | `ls` | List with icons |
| `du`  | `dust` | `du` | Visual disk usage |
| `df`  | `duf` | `df` | Beautiful disk free |
| `ps`  | `procs` | `ps` | Modern process viewer |
| `top` | `btm` | `top` | Graphical system monitor |
| `cat` | `ccat` | `cat` | Colored cat |
| `diff`| `colordiff -u` | `diff` | Colored diff |

---

## File & Navigation Aliases

| Alias | Command | Description |
| ----- | ------- | ----------- |
| `ls`  | `eza --icons` | List with icons |
| `ll`  | `ls -la` | Long format, all files |
| `la`  | `ls -l` | Long format |
| `l1`  | `ls -1` | One file per line |
| `lll` | `ls -abghHliS --git` | Detailed with git status |

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
| `rs`  | `exec $SHELL -l` | Restart shell |
| `sz`  | `source ~/.zshrc` | Reload zshrc |
| `c`   | `cursor` | Open Cursor editor |
| `p`   | `python3` | Python 3 |
| `tf`  | `terraform` | Terraform |
| `dcu` | `docker-compose up -d` | Docker compose up |

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

