# Standalone Prezto steeef theme
# Based on: https://github.com/sorin-ionescu/prezto/blob/master/modules/prompt/functions/prompt_steeef_setup
#
# This theme mimics the original steeef prompt with its original colors.
# Enhanced for Ghostty terminal with always-updated Git status

# Disable virtualenv prompt modification by default
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Enable prompt substitution and other useful options
setopt prompt_subst
# Set prompt options for better behavior
prompt_opts=(cr percent sp subst)

# Function to display virtualenv info
function virtualenv_info {
    [ "$VIRTUAL_ENV" ] && echo "(%F{4}"$(basename "$VIRTUAL_ENV")"${PR_RST}) "
}

# Function to display Python environment info (like Prezto)
function python_info {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "(%F{4}"$(basename "$VIRTUAL_ENV")"${PR_RST}) "
    elif [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        echo "(%F{4}"$CONDA_DEFAULT_ENV"${PR_RST}) "
    fi
}

autoload -U add-zsh-hook
autoload -Uz vcs_info

# Enhanced color detection for Ghostty support
# Use extended color palette if available; otherwise, fall back to basic colors.
# Colors optimized for Ghostty's poimandres theme
case $TERM in
*256color* | *rxvt* | xterm-ghostty | xterm-kitty | alacritty)
    # Poimandres theme optimized colors (using palette numbers)
    turquoise="%F{4}" # palette 4: #89ddff (blue)
    orange="%F{11}"   # palette 11: #fffac2 (yellow/cream)
    purple="%F{13}"   # palette 13: #fcc5e9 (light pink)
    hotpink="%F{1}"   # palette 1: #d0679d (pink)
    limegreen="%F{2}" # palette 2: #5de4c7 (green)
    red="%F{9}"       # palette 9: #d0679d (bright pink/red)
    blue="%F{4}"      # palette 4: #89ddff (blue)
    ;;
*)
    # Basic 8-color fallback
    turquoise="%F{cyan}"
    orange="%F{yellow}"
    purple="%F{magenta}"
    hotpink="%F{red}"
    limegreen="%F{green}"
    red="%F{red}"
    blue="%F{blue}"
    ;;
esac

# SSH connection handling for Ghostty
if [[ -n $SSH_CONNECTION && $TERM == xterm-ghostty ]]; then
    export TERM=xterm-256color
fi

# Enable VCS systems (git and svn, optimized for performance)
zstyle ':vcs_info:*' enable git svn

# Enable check-for-changes
zstyle ':vcs_info:*:prompt:*' check-for-changes true

# Define VCS info formats
PR_RST="%f"
FMT_UNSTAGED="${orange}●"
FMT_STAGED="${limegreen}●"

zstyle ':vcs_info:*:prompt:*' unstagedstr "${FMT_UNSTAGED}"
zstyle ':vcs_info:*:prompt:*' stagedstr "${FMT_STAGED}"
zstyle ':vcs_info:*:prompt:*' actionformats "(${turquoise}%b${PR_RST}|${limegreen}%a${PR_RST}%u%c) "
zstyle ':vcs_info:*:prompt:*' formats "(${turquoise}%b${PR_RST}%u%c) "
zstyle ':vcs_info:*:prompt:*' nvcsformats ""

# Preexec hook: for potential future optimizations
function steeef_preexec {
    # Can be used for command-specific optimizations if needed
}
add-zsh-hook preexec steeef_preexec

# Chpwd hook: update VCS info when changing directories
function steeef_chpwd {
    # VCS info will be updated in precmd anyway
}
add-zsh-hook chpwd steeef_chpwd

# Precmd hook: ALWAYS update vcs_info for real-time Git status
function steeef_precmd {
    # Always update VCS info to ensure real-time Git status
    vcs_info 'prompt'

    # Always rebuild Git status format for real-time updates
    if [[ -n "$vcs_info_msg_0_" ]]; then
        local git_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
        local git_staged=""
        local git_unstaged=""
        local git_untracked=""

        # Check for staged changes
        if ! git diff --cached --quiet 2>/dev/null; then
            git_staged="%F{2}●%f" # palette 2: bright teal/green
        fi

        # Check for unstaged changes
        if ! git diff --quiet 2>/dev/null; then
            git_unstaged="%F{3}●%f" # palette 3: cream/yellow
        fi

        # Check for untracked files - use a visually distinct color
        if git ls-files --other --exclude-standard 2>/dev/null | grep -q "."; then
            git_untracked="%F{9}●%f" # palette 9: bright pink
        fi

        # Build complete format
        vcs_info_msg_0_="(${turquoise}${git_branch}${PR_RST}${git_unstaged}${git_staged}${git_untracked}) "
    fi
}
add-zsh-hook precmd steeef_precmd

# Function to show last command exit status
function exit_status {
    # Disabled: echo "%(?..${red}[%?]${PR_RST} )"
    echo ""
}

# Main prompt definition: displays username, hostname, current directory, vcs info, and virtualenv info.
# Enhanced to show root user in red, optimized for poimandres theme
PROMPT=$'
%(!.${red}.${blue})%n${PR_RST} at ${orange}%m${PR_RST} in ${limegreen}%~${PR_RST} ${vcs_info_msg_0_}$(python_info)
$(exit_status)$ '

# Right prompt to show additional info (optional)
# Using subtle colors from poimandres theme
RPROMPT='%F{8}%D{%H:%M:%S}%f'

# Additional useful settings for better terminal experience
# History settings (if not already set elsewhere)
export HISTSIZE=50000
export SAVEHIST=50000

# Better completion behavior
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Git-specific completions
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
zstyle ':completion:*:*:git:*' user-commands checkout:'checkout branch' switch:'switch branch'
