# Shell commands

Commands the dotfiles define as zsh functions, in `~/.zsh/commands.zsh` and
`~/.zsh/alias.zsh`.

## update-dev

Updates the development tools in one go. Each step runs only if its tool is
installed, and a failed step does not stop the rest.

```bash
update-dev            # run every step
update-dev --dry-run  # print the commands without running them (also -n)
```

| Step       | Command                                                    |
| ---------- | ---------------------------------------------------------- |
| Homebrew   | `brew update`, `brew upgrade`, `brew cleanup`              |
| chezmoi    | `chezmoi update --apply`                                   |
| sheldon    | `sheldon lock --update`, then clears the plugin cache      |
| atuin      | `atuin sync`                                               |
| mise       | `mise self-update --yes`, `mise upgrade`                   |
| npm        | `npm update -g`                                            |
| tldr       | `tldr --update`                                            |

Run `rs` afterwards to restart the shell with the new versions.

## mkcd

Creates a directory and changes into it.

```bash
mkcd my-project
```

## cdf

Lists the directories below the current one in fzf and changes into the one
you pick. It needs fd and fzf, and works only inside your home directory.

```bash
cdf
```

## fcat

Prints the contents of every file under the given paths, each with a header
naming the file. Useful for pasting a set of files into a chat or an issue.

```bash
fcat src/                 # every file under src/
fcat -i src/              # skip files that .gitignore ignores
fcat -n '*.js' src/       # only files matching the pattern
fcat -c src/main.js       # copy the output to the clipboard
fcat -o out.txt lib/      # write the output to a file
```

| Option                   | Effect                                         |
| ------------------------ | ---------------------------------------------- |
| `-i`, `--ignore-gitignore` | skip files ignored by `.gitignore` (default: show all) |
| `-n`, `--name PATTERN`   | only files whose name matches, as in `find -name` |
| `-o`, `--output FILE`    | write to `FILE` instead of the terminal        |
| `-c`, `--clipboard`      | copy to the clipboard (`pbcopy`)               |
| `-h`, `--help`           | show the help                                  |

## ts2mp4

Converts every `.ts` video in the current directory to `.mp4` with ffmpeg,
copying the streams without re-encoding. It needs ffmpeg. A file whose `.mp4`
already exists is skipped unless you pass `-f`.

```bash
ts2mp4                # write to ./mp4/
ts2mp4 -o converted   # write to ./converted/
ts2mp4 -f             # overwrite existing .mp4 files
```

## help, keys, docs

| Command | Does                                                               |
| ------- | ------------------------------------------------------------------ |
| `help`  | prints the custom commands, aliases and keybindings                |
| `keys`  | prints the keybindings only                                        |
| `docs`  | opens this documentation in the editor `c` uses, or Finder without one |
