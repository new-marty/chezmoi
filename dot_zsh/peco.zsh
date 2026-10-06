# =============================================================================
# Peco Settings
# =============================================================================

# Select from command history. Bound to Ctrl+R
function peco-select-history() {
  BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
command -v peco &>/dev/null && bindkey '^r' peco-select-history

# cdr and its directory list are zsh functions that must be loaded before use;
# chpwd_recent_dirs records each directory change for `cdr -l` to list.
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# Get destination from cdr list
function peco-get-destination-from-cdr() {
  cdr -l |
    sed -e 's/^[[:digit:]]*[[:blank:]]*//' |
    peco --query "$LBUFFER"
}

# Select from previously visited directories. Bound to Ctrl+U
function peco-cdr() {
  local destination="$(peco-get-destination-from-cdr)"
  if [ -n "$destination" ]; then
    BUFFER="cd $destination"
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N peco-cdr
command -v peco &>/dev/null && bindkey '^u' peco-cdr
