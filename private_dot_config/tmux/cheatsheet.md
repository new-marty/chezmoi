# Tmux Cheatsheet — Prefix: Ctrl+\

## Instant (no prefix needed)
  Opt+h/j/k/l       Navigate panes
  Opt+1..9           Switch to window N
  Opt+n              New window
  Opt+z              Zoom toggle
  Opt+t              Floating scratch terminal
  Opt+/              This cheatsheet

## Modes (prefix enters mode, Esc exits)
  prefix + p         PANE:    h/j/k/l move, d/D split, x close, z zoom
  prefix + w         WINDOW:  n new, h/l prev/next, r rename, x close, 1-5 goto
  prefix + R         RESIZE:  h/j/k/l resize, H/J/K/L big resize (repeatable)
  prefix + s         SESSION: l list, n new, d detach, x kill, r rename

## Floating Popups
  Opt+t              Scratch terminal (persistent)
  prefix + g         Lazygit
  prefix + T         Session picker (sesh + fzf)

## Copy Mode (vi-style)
  prefix + [         Enter copy mode
  v                  Begin selection
  Ctrl+v             Rectangle selection
  y                  Yank (copy to clipboard)
  q                  Quit copy mode

## Misc
  prefix + r         Reload config
  prefix + I         Install plugins (tpm)
  prefix + U         Update plugins (tpm)
  prefix + Space     Which-key (all commands)
