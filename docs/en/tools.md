# Optional tools

Every tool here is optional. The shell checks for each one when it starts and
sets up its alias or integration only if it is installed. This page lists what
the dotfiles do with each tool; for how to use the tool itself, follow its link.
`just doctor` shows which ones are installed.

## Shell

| Tool | What the dotfiles do with it |
| ---- | ---------------------------- |
| [sheldon](https://sheldon.cli.rs/) | Loads the zsh plugins in `~/.config/sheldon/plugins.toml` (syntax highlighting, autosuggestions, fzf-tab and others). Its output is cached in `~/.cache/sheldon.zsh` and rebuilt when `plugins.toml` changes. Without sheldon, only the files in `~/.zsh/` are loaded. With the `omz` switch, Oh My Zsh loads them instead ([Setup](setup.md#oh-my-zsh-instead-of-sheldon-omz)). |
| [fzf](https://junegunn.github.io/fzf/) | The list for `Ctrl+G`, `Ctrl+S`, `Ctrl+F`, `Tab` completion and `cdf`. |
| [peco](https://github.com/peco/peco) | History search on `Ctrl+R` and recent directories on `Ctrl+U`. |
| [atuin](https://docs.atuin.sh/) | History search on `Ctrl+H`. The up arrow is left to zsh. |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `z <part of a path>` jumps to a directory you use often; `zi` picks one interactively. |
| [navi](https://github.com/denisidoro/navi) | Cheat sheets on `Ctrl+N`. The `navi` switch adds this repository's sheets. |
| [Neovim](https://neovim.io/) | The `nvim` switch sets it up with hint plugins ([Learning tmux and Vim](tmux-vim.md)). |
| [Google Chrome](https://www.google.com/chrome/) | `just cheatsheet-pdf` prints the cheat sheet with it. |
| [thefuck](https://github.com/nvbn/thefuck) | `fuck` corrects the previous command. |
| [direnv](https://direnv.net/) | Loads a directory's `.envrc` when you enter it. |
| [mise](https://mise.jdx.dev/) | Activates tool versions per directory. The `mise` switch sets global defaults (Node LTS, Python 3.12, latest Go). |

## Replacements for standard commands

Each replaces a standard command through an alias; see
[Aliases](aliases.md#replacements-for-standard-commands).

| Tool | Replaces |
| ---- | -------- |
| [eza](https://eza.rocks/) | `ls` |
| [bat](https://github.com/sharkdp/bat) | `cat` |
| [dust](https://github.com/bootandy/dust) | `du` |
| [duf](https://github.com/muesli/duf) | `df` |
| [procs](https://github.com/dalance/procs) | `ps` |
| [bottom](https://github.com/ClementTsang/bottom) (`btm`) | `top` |
| [colordiff](https://www.colordiff.org/) | `diff` |
| [fd](https://github.com/sharkdp/fd) | used by `cdf` |

## Git and editors

| Tool | What the dotfiles do with it |
| ---- | ---------------------------- |
| [delta](https://dandavison.github.io/delta/) | git's pager; see [Git](git.md#delta). |
| [lazygit](https://github.com/jesseduffield/lazygit) | `lg`. |
| Cursor or VS Code | git's `core.editor` and the `c` alias; see [Setup in detail](setup.md#how-the-editor-is-chosen). |

delta, Cursor and VS Code are checked when chezmoi writes the files, not when
the shell starts, so run `chezmoi apply` after installing one of them.
