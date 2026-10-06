# Learning tmux and Vim

The goal is to use the stock keys, the ones that work in tmux and vi on a bare
server, and to have hints on your own Mac until they stick. Nothing in this
setup remaps a stock key; the Mac-only extras are marked "Mac" wherever they are
listed.

## Hints while you type

| Where | What you see |
| ----- | ------------ |
| tmux (`tmux` switch) | The second status line lists the keys for the state you are in: the idle line, the keys after `C-b`, the Mac-only modes (`C-b P` `W` `S` `R`), copy mode. |
| Neovim (`nvim` switch) | After `d`, `y`, `c`, `g`, `z`, `"`, `Ctrl-w` and the like, which-key lists the keys that can follow. precognition marks where `w`, `b`, `e`, `^`, `$` would land (`:Precognition toggle`). hardtime suggests a better motion after `jjjj` (`:Hardtime toggle`). |
| Vim (`vim` switch) | A half-typed command shows in the bottom right (`showcmd`). |
| VS Code / Cursor | VSCodeVim shows the mode in the status bar; there is no key-by-key hint. Use the cheat sheet. |

## The cheat sheet

`cheatsheet/index.html` in the source directory is one page for the screen and
for paper.

- Open it: `Space`+`/` (Karabiner, while typing in English), `just cheatsheet`,
  or `Opt+/` inside tmux for the short text version.
- On screen, show stage ① only, ①②, or everything; hide the Mac-only keys;
  search for a key or a word.
- Print it: `just cheatsheet-pdf` writes two A4 landscape pages (Vim on the
  front, tmux on the back) to `~/Downloads/tmux-vim-cheatsheet.pdf` with
  Chrome. Pass a path to write elsewhere: `just cheatsheet-pdf ~/Desktop/sheet.pdf`.

Stages follow "Learn Vim Progressively": learn one or two keys a day, and tick
the box once you have used a key for a week without looking it up.

## Setting up

1. Opt in to `vim` and/or `nvim` (and `tmux`), then apply. Neovim installs its
   plugins from GitHub the first time it starts; without network access it
   starts without them.
2. VS Code / Cursor: install VSCodeVim (`vscodevim.vim`, in
   `vscode/extensions.txt`; Cursor gets it from Open VSX). Run
   `just vim-key-repeat` and reopen the editors, so holding `j` repeats
   instead of opening the accent menu. To pause Vim keys for a while, run
   "Vim: Toggle Vim Mode" from the command palette.
3. Karabiner (`karabiner` switch): `Esc` and `Ctrl+[` also switch the input to
   English in terminals, VS Code and Cursor, so normal mode never receives
   Japanese input. `Esc` while converting Japanese text cancels the conversion.
4. Ghostty sends the left Option key as Alt, which the tmux `Opt+…` keys need.
5. To use Vim for `sudoedit`, `crontab -e` and the like, set
   `export EDITOR=vim VISUAL=vim` in `~/.zshenv.local`. The repository keeps
   `nano` for everyone else; `.zshrc` sets `bindkey -e`, so the prompt keeps its
   Emacs keys either way.

## Inside a server's tmux

Opened from inside your own tmux, a server's tmux has the same prefix.
`C-b C-b` sends the prefix to the inner one.
