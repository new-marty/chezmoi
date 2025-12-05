# Enhanced command suggestions and shortcuts
# This file provides intelligent command suggestions similar to Fig

# =============================================================================
# Autosuggestions Configuration
# =============================================================================
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# =============================================================================
# Command Templates
# =============================================================================
# Command templates for fuzzy search
# To add new templates, edit the templates array below
function show_command_templates() {
    local templates=(
        "git add ."
        "git commit -m \"\""
        "git push origin HEAD"
        "git pull origin main"
        "git checkout -b feature/"
        "git merge --no-ff"
        "git log --oneline -10"
        "git status"
        "brew install"
        "brew upgrade"
        "brew uninstall"
        "brew search"
        "brew info"
        "pnpm install"
        "pnpm run dev"
        "pnpm run build"
        "pnpm run test"
        "pnpm add"
        "pnpm remove"
        "docker-compose up -d"
        "docker-compose down"
        "docker ps"
        "docker images"
        "docker system prune"
        "chezmoi cd"
        "cd ~/Desktop"
        "cd ~/Documents"
        "ls -la"
        "ls -la | grep"
        "find . -name"
        "grep -r"
        "ps aux | grep"
        "kill -9"
        "chmod +x"
        "curl -s"
        "wget -O"
        "tar -xzf"
        "zip -r"
        "ssh"
        "scp"
        "rsync -av"
        "python3 -m"
        "pip3 install"
        "npm install"
        "npm run"
        "yarn install"
        "yarn add"
        "code ."
        "cursor ."
        "open ."
        "mkdir -p"
        "rm -rf"
        "cp -r"
        "mv"
        "ln -s"
        "which"
        "whereis"
        "man"
        "history | grep"
        "du -sh"
        "df -h"
        "top"
        "htop"
        "netstat -tulpn"
        "lsof -i"
        "ps -ef"
        "tail -f"
        "head -n"
        "cat"
        "less"
        "more"
        "wc -l"
        "sort"
        "uniq"
        "cut -d"
        "awk"
        "sed"
        "tr"
        "xargs"
        "systemctl start"
        "systemctl stop"
        "systemctl status"
        "systemctl restart"
        "journalctl -u"
        "make"
        "make install"
        "make clean"
        "terraform init"
        "terraform plan"
        "terraform apply"
        "terraform destroy"
        "kubectl get pods"
        "kubectl describe"
        "kubectl logs"
        "kubectl exec -it"
        "kubectl apply -f"
        "kubectl delete"
        "heroku logs --tail"
        "heroku run"
        "heroku ps"
        "heroku config"
        "aws s3 ls"
        "aws ec2 describe-instances"
        "gcloud compute instances list"
        "gcloud config set project"
        "help"
        "keys"
        "docs"
        "tldr"
        "navi"
        "chezmoi cd"
        "chezmoi apply"
        "chezmoi diff"
    )

    local selected=$(printf '%s\n' "${templates[@]}" | fzf --height 50% --layout=reverse --border --prompt="Command Template: ")

    if [[ -n "$selected" ]]; then
        LBUFFER="$selected"
        zle reset-prompt
    fi
}

# Smart suggestion based on current directory and project type
function smart_command_suggest() {
    local suggestions=()

    # Check for package.json (Node.js project)
    if [[ -f "package.json" ]]; then
        suggestions+=("pnpm install" "pnpm run dev" "pnpm run build" "pnpm run test")
    fi

    # Check for Dockerfile
    if [[ -f "Dockerfile" ]]; then
        suggestions+=("docker build -t" "docker run -p")
    fi

    # Check for docker-compose.yml
    if [[ -f "docker-compose.yml" ]]; then
        suggestions+=("docker-compose up -d" "docker-compose down" "docker-compose logs")
    fi

    # Check for git repository
    if [[ -d ".git" ]]; then
        suggestions+=("git status" "git add ." "git commit -m" "git push origin HEAD")
    fi

    # Check for Makefile
    if [[ -f "Makefile" ]]; then
        suggestions+=("make" "make install" "make clean" "make test")
    fi

    # Check for requirements.txt (Python project)
    if [[ -f "requirements.txt" ]]; then
        suggestions+=("pip3 install -r requirements.txt" "python3 -m venv venv" "source venv/bin/activate")
    fi

    # Check for go.mod (Go project)
    if [[ -f "go.mod" ]]; then
        suggestions+=("go run ." "go build" "go test" "go mod tidy")
    fi

    # Check for Cargo.toml (Rust project)
    if [[ -f "Cargo.toml" ]]; then
        suggestions+=("cargo run" "cargo build" "cargo test" "cargo check")
    fi

    if [[ ${#suggestions[@]} -eq 0 ]]; then
        suggestions=("ls -la" "cd .." "pwd" "find . -name" "grep -r")
    fi

    local selected=$(printf '%s\n' "${suggestions[@]}" | fzf --height 50% --layout=reverse --border --prompt="Smart Suggestion: ")

    if [[ -n "$selected" ]]; then
        LBUFFER="$selected"
        zle reset-prompt
    fi
}

# Frequently used commands widget
function show_frequent_commands() {
    local frequent_commands=$(history | awk '{print $2}' | sort | uniq -c | sort -rn | head -20 | awk '{print $2}')

    local selected=$(echo "$frequent_commands" | fzf --height 50% --layout=reverse --border --prompt="Frequent Commands: ")

    if [[ -n "$selected" ]]; then
        LBUFFER="$selected"
        zle reset-prompt
    fi
}

# Register widgets (keybindings are set in .zshrc after all plugins are loaded)
zle -N show_command_templates
zle -N smart_command_suggest
zle -N show_frequent_commands

# Navi integration (install with: brew install navi)
function navi_widget() {
    local selected=$(navi --print)
    if [[ -n "$selected" ]]; then
        LBUFFER="$selected"
        zle reset-prompt
    fi
}
zle -N navi_widget
