# Aliases

Every alias the dotfiles define. An alias for an optional tool is set only when
the tool is installed (the shell checks when it starts), so without the tool the
original command runs unchanged. Add your own aliases in `~/.zshrc.local`; an
alias defined there replaces one of these.

## Git

| Alias   | Runs                                                   |
| ------- | ------------------------------------------------------ |
| `gs`    | `git status`                                           |
| `gst`   | `git status --short --branch`                          |
| `ga`    | `git add`                                              |
| `gd`    | `git diff`                                             |
| `gdiff` | `git diff --color-words`                               |
| `gcm`   | `git commit -m`                                        |
| `gca`   | `git commit --amend`                                   |
| `gp`    | `git push origin head`                                 |
| `sw`    | `git switch`                                           |
| `br`    | `git branch`, newest first, with dates                 |
| `gl`    | `git log --graph` with a one-line format               |
| `gls`   | `git log --stat --summary`                             |
| `glog`  | `git log --oneline --graph --decorate --all`           |
| `gtree` | `git log --graph --full-history --all`, colored        |
| `lg`    | `lazygit` (when installed)                             |

git itself has more aliases (`git st`, `git undo` and so on); see [Git](git.md).

## Replacements for standard commands

| Alias  | Runs                               | When                     |
| ------ | ---------------------------------- | ------------------------ |
| `ls`   | `eza --icons=auto`                 | eza is installed         |
| `lll`  | `eza -abghHliS --git --icons=auto` | eza is installed         |
| `cat`  | `bat --style=plain --paging=never` | bat is installed         |
| `catp` | `bat` (paging, line numbers)       | bat is installed         |
| `du`   | `dust`                             | dust is installed        |
| `df`   | `duf`                              | duf is installed         |
| `ps`   | `procs`                            | procs is installed       |
| `top`  | `btm`                              | btm is installed         |
| `diff` | `colordiff -u`, or `diff -u`       | always                   |
| `ll`   | `ls -la`                           | always                   |
| `la`   | `ls -l`                            | always                   |
| `l1`   | `ls -1`                            | always                   |

`ll`, `la` and `l1` call `ls`, so they use eza when it is installed.

## chezmoi

| Alias  | Runs             |
| ------ | ---------------- |
| `cm`   | `chezmoi`        |
| `cma`  | `chezmoi apply`  |
| `cmd`  | `chezmoi diff`   |
| `cme`  | `chezmoi edit`   |
| `cmu`  | `chezmoi update` |
| `cmcd` | `chezmoi cd`     |

## tmux

| Alias | Runs                   |
| ----- | ---------------------- |
| `t`   | `tmux`                 |
| `ta`  | `tmux attach -t`       |
| `tl`  | `tmux list-sessions`   |
| `tn`  | `tmux new-session -s`  |

## pnpm and Docker

| Alias  | Runs                   |
| ------ | ---------------------- |
| `pp`   | `pnpm`                 |
| `pi`   | `pnpm install`         |
| `pr`   | `pnpm run`             |
| `pd`   | `pnpm dev`             |
| `pu`   | `pnpm update`          |
| `pb`   | `pnpm build`           |
| `dcu`  | `docker compose up`    |
| `dcud` | `docker compose up -d` |
| `dcd`  | `docker compose down`  |

## Shell and other

| Alias  | Runs                                       |
| ------ | ------------------------------------------ |
| `rs`   | `exec zsh -l` (restart the shell)          |
| `sz`   | `source ~/.zshrc`                          |
| `c`    | Cursor or VS Code (see below)              |
| `p`    | `python3`                                  |
| `tf`   | `terraform`                                |
| `yolo` | `claude --dangerously-skip-permissions`    |
| `help` | list the custom commands, aliases and keybindings |
| `keys` | list the keybindings                       |
| `docs` | open this documentation in the editor      |

`c` opens the same editor as git's `core.editor`: Cursor or VS Code, chosen
when chezmoi writes the files. With neither installed, `c` is not defined.
[Setup in detail](setup.md#how-the-editor-is-chosen) explains the choice and
how to override it.
