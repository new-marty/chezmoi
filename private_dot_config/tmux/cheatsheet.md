# Tmux Cheatsheet — Prefix: Ctrl+a

## Panes
  prefix + |         Split horizontally
  prefix + -         Split vertically
  prefix + h/j/k/l   Navigate panes (left/down/up/right)
  prefix + H/J/K/L   Resize pane
  prefix + z          Toggle zoom (fullscreen pane)
  prefix + x          Close pane
  prefix + p          Toggle floating pane (floax)

## Windows
  Alt+1..9            Switch to window N (no prefix)
  prefix + c          New window
  prefix + ,          Rename window
  prefix + &          Close window
  prefix + n / p      Next / Previous window

## Sessions
  prefix + d          Detach
  prefix + s          List sessions
  prefix + T          Session picker (sesh + fzf)
  prefix + $          Rename session

## Floating Popups
  Alt+t               Floating scratch terminal (persistent)
  prefix + g          Floating lazygit
  prefix + p          Floating pane toggle (floax)
  Alt+?               This cheatsheet

## Copy Mode (vi-style)
  prefix + [          Enter copy mode
  v                   Begin selection
  Ctrl+v              Rectangle selection
  y                   Yank (copy to clipboard)
  q                   Quit copy mode

## Text Selection
  prefix + F          Thumbs (vimium-style hint selection)
  prefix + Shift+F    Fuzzy finder (tmux-fzf)

## Misc
  prefix + r          Reload config
  prefix + I          Install plugins (tpm)
  prefix + U          Update plugins (tpm)
  prefix + a          Send literal Ctrl+a (readline)
