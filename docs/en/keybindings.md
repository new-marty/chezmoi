# Keybindings

These are the zsh keybindings the dotfiles add. Each one needs the tool named in
its row; without it the key is not bound and keeps zsh's own meaning (`Ctrl+R`
is then zsh's incremental history search). Type `keys` in a terminal for a
short version of this table.

| Key      | What it does                                                   | Needs          |
| -------- | -------------------------------------------------------------- | -------------- |
| `Ctrl+G` | Pick a command from a fixed list of templates                  | fzf            |
| `Ctrl+S` | Pick a command suggested for the project in this directory     | fzf            |
| `Ctrl+F` | Pick one of your 20 most used commands                         | fzf            |
| `Ctrl+N` | Pick a command from the navi cheat sheets                      | navi           |
| `Ctrl+R` | Search history                                                 | peco           |
| `Ctrl+H` | Search history with more filters (directory, session)          | atuin          |
| `Ctrl+U` | Jump to a recently visited directory                           | peco           |
| `Tab`    | Completion in an fzf list, with a preview of files and folders | sheldon, fzf   |
| `Up`/`Down` | Search history for what is typed so far                     | the work profile ([Work Mac](work-mac.md)) |

The picked command is placed on the command line, not run, so you can edit it
before pressing Enter.

## Ctrl+G: command templates

A list of about a hundred common commands (git, docker, pnpm, chezmoi and
system commands), defined in `show_command_templates` in
`~/.zsh/suggestions.zsh`. To add your own, edit that list with
`chezmoi edit ~/.zsh/suggestions.zsh`.

## Ctrl+S: project suggestions

Looks at the files in the current directory and offers matching commands:

| File found           | Suggested commands                          |
| -------------------- | ------------------------------------------- |
| `package.json`       | `pnpm install`, `pnpm run dev`, build, test |
| `Dockerfile`         | `docker build -t`, `docker run -p`          |
| `docker-compose.yml` | `docker-compose up -d`, down, logs          |
| `.git`               | `git status`, add, commit, push             |
| `Makefile`           | `make`, install, clean, test                |
| `requirements.txt`   | `pip3 install -r requirements.txt`, venv    |
| `go.mod`             | `go run .`, build, test, `go mod tidy`      |
| `Cargo.toml`         | `cargo run`, build, test, check             |

With none of these, it offers a few general commands such as `ls -la`.

## Ctrl+N: navi cheat sheets

Opens the cheat sheets in `~/.config/navi/cheats/cheats.cheat` (git, pnpm,
docker, brew, terraform, kubernetes and more). The file is applied with the
`navi` switch; see [Setup in detail](setup.md#opt-in-switches).

## Ctrl+R and Ctrl+H: two history searches

`Ctrl+R` is a plain fuzzy filter over this shell's history. `Ctrl+H` opens
atuin, which can narrow the search to the current directory or session and
sync history between machines. The up arrow keeps zsh's normal behaviour;
atuin does not take it over.

## Other keybindings

tmux (with the `tmux` switch) uses `Ctrl+\` as its prefix and has its own
shortcuts; press `Opt+/` inside tmux to see them. For keys inside lazygit and
btm, press `?` in the program.
