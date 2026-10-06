# tmux — prefix: C-b (Ctrl+b, release, then the key)

Keys outside "Mac only" work on any server's tmux (C-b / needs 3.1+,
the menus 3.0+). Windows there are numbered from 0.
The full sheet with Vim: Space+/ (Karabiner) or `just cheatsheet`.

## Start, leave, come back (type in the shell)
  tmux new -s work   Start a session named work
  C-b d              Detach: leave, the session keeps running
  tmux ls            List sessions
  tmux a -t work     Attach to work again

## Windows (tabs)
  C-b c              New window
  C-b n / C-b p      Next / previous window
  C-b 0..9           Go to window N
  C-b ,              Rename      C-b w   pick from a list
  C-b &              Close (asks first)

## Panes (splits)
  C-b %              Split left | right
  C-b "              Split top - bottom
  C-b o              Next pane   C-b arrow   pane in that direction
  C-b z              Zoom the pane in or out
  C-b Opt+arrow      Resize the pane
  C-b x              Close the pane (asks first)

## Scroll back and copy (copy mode)
  C-b [              Enter copy mode, scroll with hjkl / Ctrl-u / Ctrl-d
  / ?   n            Search down / up, next match
  Space   Enter      Start selecting, copy (C-b ] pastes)
  q                  Quit copy mode
  (vi keys here need EDITOR/VISUAL to contain vi when the server starts,
   or: C-b : setw -g mode-keys vi. Otherwise they are emacs keys.)

## Find out
  C-b ?              All keys (q to close)
  C-b /              What does the next key do? (tmux 3.1+)
  C-b <  C-b >       Window / pane menu (tmux 3.0+)
  C-b :              Type a tmux command
  C-b C-b            Send C-b to a tmux opened inside this one (a server's)

## Mac only
  Opt+h/j/k/l        Move between panes
  Opt+1..9           Go to window N
  Opt+n  Opt+z       New window, zoom
  Opt+t              Floating scratch terminal
  C-b P W S R        Pane / window / session / resize: the next key (hints below)
  v   y              In copy mode: select, copy to the Mac clipboard
  C-b g  C-b T       lazygit, session picker (sesh)
  C-b C-r            Reload the config      C-b M-r  restore saved sessions
  C-b Space          Which-key menu (stock: next layout)
