# Additional configurations for steeef theme
# These are optional enhancements that can be enabled as needed

# 1. Async Git status for large repositories (optional)
# Uncomment if you work with very large repositories
# autoload -Uz add-zsh-hook
#
# _steeef_async_git() {
#     cd "$1" 2>/dev/null || return
#     git status --porcelain 2>/dev/null
# }
#
# _steeef_async_callback() {
#     local job=$1 code=$2 output=$3 exec_time=$4
#     if [[ $code -eq 0 ]]; then
#         # Update git status based on output
#         # This would replace the synchronous git calls in precmd
#     fi
# }

# 2. Custom right prompt options
# Uncomment and modify as needed

# Show load average
# RPROMPT='%D{%H:%M:%S} [%L]'

# Show current directory depth
# RPROMPT='%D{%H:%M:%S} %~'

# Show battery level (macOS)
# function battery_level() {
#     pmset -g batt | grep -Eo "\d+%" | cut -d% -f1
# }
# RPROMPT='%D{%H:%M:%S} 🔋$(battery_level)%%'

# Show current kubectl context
# function kubectl_context() {
#     kubectl config current-context 2>/dev/null
# }
# RPROMPT='%D{%H:%M:%S} ⎈$(kubectl_context)'

# 3. Enhanced Git information
# Show more detailed Git information

# Show commit hash in prompt
# function git_commit_hash() {
#     git rev-parse --short HEAD 2>/dev/null
# }

# Show remote tracking branch
# function git_remote_status() {
#     git status --porcelain=v1 --branch 2>/dev/null | head -1 | grep -o '\[.*\]'
# }

# 4. Performance tuning for large repositories
# These settings can improve performance in large repos

# Disable untracked files check for performance
# zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
# +vi-git-untracked(){
#     if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
#        git status --porcelain | grep '??' &> /dev/null ; then
#         hook_com[staged]+='T'
#     fi
# }

# 5. Directory-specific configurations
# Different prompt styles for different directories

# function set_prompt_by_directory() {
#     case "$PWD" in
#         */projects/*)
#             # Work projects - show more info
#             RPROMPT='%D{%H:%M:%S} 💼'
#             ;;
#         */dotfiles*)
#             # Dotfiles - show minimal info
#             RPROMPT='%D{%H:%M:%S} ⚙️'
#             ;;
#         *)
#             # Default
#             RPROMPT='%D{%H:%M:%S}'
#             ;;
#     esac
# }
# add-zsh-hook chpwd set_prompt_by_directory

# 6. Git aliases for better workflow
# These complement the prompt improvements

# Show git graph with better formatting
alias glog='git log --oneline --graph --decorate --all'
alias gtree='git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'

# Show git status with better formatting
alias gst='git status --short --branch'

# Show git diff with better formatting
alias gdiff='git diff --color-words'

# 7. Terminal title integration
# Update terminal title with current directory and git branch

# function update_terminal_title() {
#     if [[ -n "$vcs_info_msg_0_" ]]; then
#         # In git repo
#         local branch=$(git branch --show-current 2>/dev/null)
#         print -Pn "\e]0;%n@%m:%~${branch:+ ($branch)}\a"
#     else
#         # Not in git repo
#         print -Pn "\e]0;%n@%m:%~\a"
#     fi
# }
# add-zsh-hook precmd update_terminal_title

# 8. Notification for long-running commands
# Show notification when commands take longer than threshold

# STEEEF_COMMAND_TIME_THRESHOLD=30
#
# function steeef_preexec_time() {
#     STEEEF_COMMAND_START_TIME=$SECONDS
# }
#
# function steeef_precmd_time() {
#     if [[ -n "$STEEEF_COMMAND_START_TIME" ]]; then
#         local elapsed=$((SECONDS - STEEEF_COMMAND_START_TIME))
#         if [[ $elapsed -gt $STEEEF_COMMAND_TIME_THRESHOLD ]]; then
#             # Show notification (macOS)
#             osascript -e "display notification \"Command completed in ${elapsed}s\" with title \"Terminal\""
#         fi
#         unset STEEEF_COMMAND_START_TIME
#     fi
# }
#
# add-zsh-hook preexec steeef_preexec_time
# add-zsh-hook precmd steeef_precmd_time

# 9. Environment-specific customizations
# Different settings for different environments

# if [[ -n "$SSH_CONNECTION" ]]; then
#     # SSH connection - show hostname more prominently
#     PROMPT=$'
# %F{red}[SSH]%f %(!.${red}.${purple})%n${PR_RST} at ${orange}%m${PR_RST} in ${limegreen}%~${PR_RST} ${vcs_info_msg_0_}$(python_info)
# $(exit_status)$ '
# fi

# 10. Integration with other tools
# Better integration with common development tools

# Docker context
# function docker_context() {
#     docker context show 2>/dev/null
# }

# AWS profile
# function aws_profile() {
#     echo ${AWS_PROFILE:-default}
# }

# Node.js version
# function node_version() {
#     node --version 2>/dev/null | cut -d'v' -f2
# }

# Add to RPROMPT if needed:
# RPROMPT='%D{%H:%M:%S} 🐳$(docker_context) ☁️$(aws_profile) ⬢$(node_version)'
