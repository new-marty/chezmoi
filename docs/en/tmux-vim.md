# Learning tmux and Vim

The goal is to use the stock keys, the ones that work in tmux and vi on a bare
server, and to have hints on your own Mac until they stick. Vim keeps every
stock key. tmux keeps them except where its plugins or the Mac clipboard need a
key, and those are marked "Mac": `v` and `y` in copy mode, `C-b Space`
(which-key; stock: next layout) and `C-b C-r` (reload).

## Hints while you type

| Where | What you see |
| ----- | ------------ |
| tmux (`tmux` switch) | The second status line lists the keys for the state you are in: the idle line, the keys after `C-b`, the Mac-only modes (`C-b P` `W` `S` `R`), copy mode. |
| Neovim (`nvim` switch) | After `d`, `y`, `c`, `g`, `z`, `"`, `Ctrl-w` and the like, which-key lists the keys that can follow. precognition marks where `w`, `b`, `e`, `^`, `$` would land (`:Precognition toggle`). hardtime suggests a better motion after `jjjj` (`:Hardtime toggle`). |
| Vim (`vim` switch) | A half-typed command shows in the bottom right (`showcmd`). |
| VS Code / Cursor | VSCodeVim shows the mode in the status bar; there is no key-by-key hint. Use the cheat sheet. |

## The cheat sheet

`cheatsheet/vim.html` and `cheatsheet/tmux.html` in the source directory scale
with the window. They are generated: edit `cheatsheet/build.py` or `style.css`,
then run `python3 cheatsheet/build.py`.

- Open one: hold `Space` and press `v` for Vim or `t` for tmux (Karabiner, in
  any input source). It opens in a window that floats above other apps;
  the same key again, or the window's close button, closes it. From a shell: `just cheatsheet vim`
  or `just cheatsheet tmux` (without the `justfile` switch:
  `sh "$(chezmoi source-path)/scripts/cheatsheet.sh" vim`). Inside tmux,
  `Opt+/` shows a short text version.
- It is drawn rather than listed: the Vim modes as a map (colour means mode
  everywhere on the page), motions on a real line and through a file, the
  verbs and ranges as a table, the tmux screen with the key for each part, and
  Dashed boxes are Mac-only.
- It also has recipes for everyday tasks, such as changing a setting or
  keeping a job alive after logout, with the screen before and after.

Learn one or two keys a day ("Learn Vim Progressively").

## Setting up

1. Opt in to `vim` and/or `nvim` (and `tmux`), then apply. Neovim installs its
   plugins from GitHub the first time it starts; without network access it
   starts without them.
2. VS Code / Cursor: install VSCodeVim (`vscodevim.vim`). `just vscode-extensions`
   installs it into VS Code with the rest of `vscode/extensions.txt`; for Cursor,
   run `cursor --install-extension vscodevim.vim` (it comes from Open VSX). Run
   `just vim-key-repeat` and reopen the editors, so holding `j` repeats
   instead of opening the accent menu. To pause Vim keys for a while, run
   "Vim: Toggle Vim Mode" from the command palette.
3. Karabiner (`karabiner` switch): `Esc` and `Ctrl+[` also switch the input to
   English in terminals, VS Code and Cursor, so normal mode never receives
   Japanese input. `Esc` while converting Japanese text cancels the conversion.
4. Ghostty sends the left Option key as Alt, which the tmux `Opt+…` keys need.
   The left Option key then no longer types characters such as `å`; on a
   keyboard where a character like `\` needs Option, use the right Option key.
5. To use Vim for `sudoedit`, `crontab -e` and the like, set
   `export EDITOR=vim VISUAL=vim` in `~/.zshenv.local`. The repository keeps
   `nano` for everyone else; `.zshrc` sets `bindkey -e`, so the prompt keeps its
   Emacs keys either way.

## Inside a server's tmux

Opened from inside your own tmux, a server's tmux has the same prefix.
`C-b C-b` sends the prefix to the inner one.
