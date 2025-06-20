#!/bin/bash

# Enhanced Claude Code Docker Setup Script with Package Manager Selection
# Supports Node.js and Python with configurable package managers

set -e

echo "🚀 Enhanced Claude Code Docker Setup - Multi-Language Edition"
echo "=============================================================="
echo ""
echo "This setup creates a high-performance, multi-language development"
echo "environment with Claude Code, optimized package managers, and"
echo "seamless integration with your host development files."
echo ""

# Check if we're running in WSL
if ! grep -q microsoft /proc/version 2>/dev/null; then
    echo "❌ This script should be run in WSL (Windows Subsystem for Linux)"
    echo "   Claude Code requires WSL on Windows systems"
    exit 1
fi

# Check if Docker is installed and running
if ! command -v docker &>/dev/null; then
    echo "❌ Docker is not installed. Please install Docker Desktop first."
    echo "   Download from: https://www.docker.com/products/docker-desktop"
    exit 1
fi

if ! docker info &>/dev/null; then
    echo "❌ Docker is not running. Please start Docker Desktop."
    exit 1
fi

# Check if docker-compose is available
COMPOSE_CMD="docker-compose"
if docker compose version &>/dev/null 2>&1; then
    COMPOSE_CMD="docker compose"
elif ! command -v docker-compose &>/dev/null; then
    echo "❌ Docker Compose is not available. Please install Docker Compose."
    exit 1
fi

echo "✅ All prerequisites met!"
echo ""

# Interactive configuration
echo "📋 Let's configure your enhanced Claude Code environment..."
echo ""

# Node.js Package Manager Selection
echo "📦 Node.js Package Manager Selection:"
echo "======================================"
echo ""
echo "Choose your Node.js package manager:"
echo ""
echo "1. 🚀 pnpm (RECOMMENDED)"
echo "   • 10-100x faster than npm"
echo "   • Uses hard links to save disk space"
echo "   • Strict dependency resolution prevents phantom dependencies"
echo "   • Best for: Performance-focused developers, monorepos"
echo ""
echo "2. 📦 npm (Standard)"
echo "   • Default Node.js package manager"
echo "   • Widest compatibility with existing projects"
echo "   • Familiar commands and behavior"
echo "   • Best for: Beginners, maximum compatibility"
echo ""
echo "3. 🧶 yarn (Reliable)"
echo "   • Fast and reliable package manager"
echo "   • Excellent lockfile handling"
echo "   • Good workspace management"
echo "   • Best for: Teams, existing Yarn projects"
echo ""

read -p "Choose your Node.js package manager (1-3) [1]: " node_choice
node_choice=${node_choice:-1}

case $node_choice in
1) NODE_PACKAGE_MANAGER="pnpm" ;;
2) NODE_PACKAGE_MANAGER="npm" ;;
3) NODE_PACKAGE_MANAGER="yarn" ;;
*)
    echo "Invalid choice, defaulting to pnpm"
    NODE_PACKAGE_MANAGER="pnpm"
    ;;
esac

echo "Selected: $NODE_PACKAGE_MANAGER"
echo ""

# Python Package Manager Selection
echo "🐍 Python Package Manager Selection:"
echo "====================================="
echo ""
echo "Choose your Python package manager:"
echo ""
echo "1. ⚡ uv (HIGHLY RECOMMENDED)"
echo "   • 10-100x faster than pip"
echo "   • Written in Rust for maximum performance"
echo "   • Handles virtual environments automatically"
echo "   • Modern dependency resolution"
echo "   • Best for: All Python development, especially large projects"
echo ""
echo "2. 🐍 pip (Standard)"
echo "   • Default Python package manager"
echo "   • Maximum compatibility with existing projects"
echo "   • Simple and familiar"
echo "   • Best for: Simple projects, learning Python"
echo ""

read -p "Choose your Python package manager (1-2) [1]: " python_choice
python_choice=${python_choice:-1}

case $python_choice in
1) PYTHON_PACKAGE_MANAGER="uv" ;;
2) PYTHON_PACKAGE_MANAGER="pip" ;;
*)
    echo "Invalid choice, defaulting to uv"
    PYTHON_PACKAGE_MANAGER="uv"
    ;;
esac

echo "Selected: $PYTHON_PACKAGE_MANAGER"
echo ""

# Performance Benefits Summary
echo "⚡ Performance Benefits of Your Selection:"
echo "=========================================="
if [ "$NODE_PACKAGE_MANAGER" = "pnpm" ] && [ "$PYTHON_PACKAGE_MANAGER" = "uv" ]; then
    echo "🎉 MAXIMUM PERFORMANCE SETUP!"
    echo "   Your combination provides the fastest possible package operations"
    echo "   Expected performance improvement: 10-100x faster than npm+pip"
elif [ "$NODE_PACKAGE_MANAGER" = "pnpm" ] || [ "$PYTHON_PACKAGE_MANAGER" = "uv" ]; then
    echo "🚀 HIGH PERFORMANCE SETUP!"
    echo "   You've chosen at least one ultra-fast package manager"
    echo "   Expected performance improvement: Significantly faster operations"
else
    echo "📦 STANDARD SETUP"
    echo "   Using familiar, reliable package managers"
    echo "   Maximum compatibility with existing projects"
fi
echo ""

# Shell preference (existing logic)
echo "🐚 Shell Configuration:"
echo "======================="
echo "1. zsh (recommended - with Oh My Zsh)"
echo "2. bash (classic and reliable)"
echo "3. fish (modern and user-friendly)"
echo ""
read -p "Choose your preferred shell (1-3) [1]: " shell_choice
shell_choice=${shell_choice:-1}

case $shell_choice in
1) PREFERRED_SHELL="zsh" ;;
2) PREFERRED_SHELL="bash" ;;
3) PREFERRED_SHELL="fish" ;;
*)
    echo "Invalid choice, defaulting to zsh"
    PREFERRED_SHELL="zsh"
    ;;
esac

echo "Selected: $PREFERRED_SHELL"
echo ""

# Container configuration (existing logic)
echo "📦 Container Configuration:"
echo "=========================="
read -p "Container name [claude-code-dev]: " container_name
container_name=${container_name:-claude-code-dev}

read -p "Container username [developer]: " container_username
container_username=${container_username:-developer}
echo ""

# Directory mappings (existing logic)
echo "📁 Directory Mappings:"
echo "====================="
echo ""
echo "Repository directory (where your code projects are stored):"
read -p "Repos path [\$HOME/repos]: " repos_path
repos_path=${repos_path:-$HOME/repos}

echo ""
echo "Default working directory inside container:"
read -p "Working directory [/workspace/repos]: " working_dir
working_dir=${working_dir:-/workspace/repos}

echo ""
echo "🔧 Configuration File Paths:"
echo "============================"

# Shell config
shell_config_default=""
case $PREFERRED_SHELL in
"zsh") shell_config_default="$HOME/.zshrc" ;;
"bash") shell_config_default="$HOME/.bashrc" ;;
"fish") shell_config_default="$HOME/.config/fish/config.fish" ;;
esac

read -p "Shell config file [$shell_config_default]: " shell_config_path
shell_config_path=${shell_config_path:-$shell_config_default}

# Other config paths (existing logic)
read -p "Git config file [\$HOME/.gitconfig]: " git_config_path
git_config_path=${git_config_path:-$HOME/.gitconfig}

read -p "SSH directory [\$HOME/.ssh]: " ssh_path
ssh_path=${ssh_path:-$HOME/.ssh}

read -p "NPM config file [\$HOME/.npmrc]: " npm_config_path
npm_config_path=${npm_config_path:-$HOME/.npmrc}

echo ""
echo "📂 Additional Custom Directories (optional):"
echo "============================================"
echo "You can map up to 3 additional directories into the container."
echo "Leave blank to skip."
echo ""

declare -a custom_paths=()
declare -a custom_targets=()
declare -a custom_readonly=()

for i in {1..3}; do
    echo "Custom mapping #$i:"
    read -p "  Host path (absolute): " custom_path
    if [ -n "$custom_path" ]; then
        read -p "  Container target [/workspace/custom$i]: " custom_target
        custom_target=${custom_target:-/workspace/custom$i}

        read -p "  Read-only? (y/N): " readonly_choice
        readonly_choice=${readonly_choice,,}
        if [[ $readonly_choice =~ ^(y|yes)$ ]]; then
            readonly_val="true"
        else
            readonly_val="false"
        fi

        custom_paths[$i]="$custom_path"
        custom_targets[$i]="$custom_target"
        custom_readonly[$i]="$readonly_val"

        echo "  ✅ Added: $custom_path → $custom_target (readonly: $readonly_val)"
    fi
    echo ""
done

# Create project directory
PROJECT_DIR="$HOME/claude-code-docker"
echo "📁 Creating project directory at $PROJECT_DIR"
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# Get host UID and GID
HOST_UID=$(id -u)
HOST_GID=$(id -g)

echo "👤 Host UID: $HOST_UID, GID: $HOST_GID"
echo ""

# Create comprehensive .env file
echo "📝 Creating environment configuration..."
cat >.env <<EOF
# Enhanced Claude Code Docker Configuration
# Generated on $(date)

# Host system configuration
HOST_UID=$HOST_UID
HOST_GID=$HOST_GID
HOME=$HOME
TZ=$(date +%Z)

# Container configuration
CONTAINER_NAME=$container_name
CONTAINER_HOSTNAME=$container_name
CONTAINER_USERNAME=$container_username
PREFERRED_SHELL=$PREFERRED_SHELL
CONTAINER_WORKING_DIR=$working_dir

# Package Manager Selection
NODE_PACKAGE_MANAGER=$NODE_PACKAGE_MANAGER
PYTHON_PACKAGE_MANAGER=$PYTHON_PACKAGE_MANAGER

# Language Versions
PYTHON_VERSION=3.12

# Core directory mappings
REPOS_PATH=$repos_path

# Configuration file paths
SHELL_CONFIG_PATH=$shell_config_path
GIT_CONFIG_PATH=$git_config_path
SSH_PATH=$ssh_path
NPM_CONFIG_PATH=$npm_config_path

# Custom directory mappings
$([ -n "${custom_paths[1]}" ] && echo "CUSTOM_PATH_1=${custom_paths[1]}")
$([ -n "${custom_targets[1]}" ] && echo "CUSTOM_TARGET_1=${custom_targets[1]}")
$([ -n "${custom_readonly[1]}" ] && echo "CUSTOM_1_READONLY=${custom_readonly[1]}")

$([ -n "${custom_paths[2]}" ] && echo "CUSTOM_PATH_2=${custom_paths[2]}")
$([ -n "${custom_targets[2]}" ] && echo "CUSTOM_TARGET_2=${custom_targets[2]}")
$([ -n "${custom_readonly[2]}" ] && echo "CUSTOM_2_READONLY=${custom_readonly[2]}")

$([ -n "${custom_paths[3]}" ] && echo "CUSTOM_PATH_3=${custom_paths[3]}")
$([ -n "${custom_targets[3]}" ] && echo "CUSTOM_TARGET_3=${custom_targets[3]}")
$([ -n "${custom_readonly[3]}" ] && echo "CUSTOM_3_READONLY=${custom_readonly[3]}")
EOF

# Ensure required directories exist (existing logic)
echo "📂 Ensuring required directories exist..."
mkdir -p "$repos_path"

# Create missing config files (existing logic but enhanced)
if [ ! -f "$shell_config_path" ]; then
    echo "📄 Creating default shell config at $shell_config_path..."
    mkdir -p "$(dirname "$shell_config_path")"

    case $PREFERRED_SHELL in
    "zsh")
        cat >"$shell_config_path" <<'EOF'
# Default zsh configuration
export PATH=$PATH:/usr/local/bin

# Enhanced aliases for development
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
EOF
        ;;
    "bash")
        cat >"$shell_config_path" <<'EOF'
# Default bash configuration
export PATH=$PATH:/usr/local/bin

# Enhanced aliases for development
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
EOF
        ;;
    "fish")
        cat >"$shell_config_path" <<'EOF'
# Default fish configuration
set -x PATH $PATH /usr/local/bin

# Enhanced aliases for development
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
EOF
        ;;
    esac
fi

# Create default configs if missing (existing logic)
if [ ! -f "$git_config_path" ]; then
    echo "📄 Creating default .gitconfig..."
    cat >"$git_config_path" <<'EOF'
[user]
    name = Your Name
    email = your.email@example.com
[core]
    editor = vim
[init]
    defaultBranch = main
[pull]
    rebase = false
EOF
    echo "⚠️  Please update $git_config_path with your actual git user information"
fi

if [ ! -d "$ssh_path" ]; then
    echo "📄 Creating SSH directory..."
    mkdir -p "$ssh_path"
    chmod 700 "$ssh_path"
fi

if [ ! -f "$npm_config_path" ]; then
    echo "📄 Creating default .npmrc..."
    touch "$npm_config_path"
fi

# Create custom directories if specified
for i in {1..3}; do
    if [ -n "${custom_paths[$i]}" ] && [ ! -d "${custom_paths[$i]}" ]; then
        echo "📄 Creating custom directory: ${custom_paths[$i]}"
        mkdir -p "${custom_paths[$i]}"
    fi
done

echo ""
echo "✅ Setup complete!"
echo ""
echo "📋 Configuration Summary:"
echo "========================"
echo "🐚 Shell: $PREFERRED_SHELL"
echo "📦 Node.js Package Manager: $NODE_PACKAGE_MANAGER"
echo "🐍 Python Package Manager: $PYTHON_PACKAGE_MANAGER"
echo "📦 Container: $container_name ($container_username)"
echo "📁 Repos: $repos_path → /workspace/repos"
echo "🔧 Shell config: $shell_config_path"
echo "📝 Git config: $git_config_path"
echo "🔑 SSH: $ssh_path"
echo "📦 NPM config: $npm_config_path"

for i in {1..3}; do
    if [ -n "${custom_paths[$i]}" ]; then
        echo "📂 Custom $i: ${custom_paths[$i]} → ${custom_targets[$i]} (readonly: ${custom_readonly[$i]})"
    fi
done

if [ "$NODE_PACKAGE_MANAGER" = "pnpm" ] && [ "$PYTHON_PACKAGE_MANAGER" = "uv" ]; then
    echo ""
    echo "🎉 You've selected the MAXIMUM PERFORMANCE configuration!"
    echo "   Your package operations will be lightning fast!"
fi

echo ""
echo "📋 Next steps:"
echo "=============="
echo "1. Copy the enhanced Dockerfile and docker-compose files to $PROJECT_DIR"
echo "2. Build: cd $PROJECT_DIR && $COMPOSE_CMD build"
echo "3. Start: cd $PROJECT_DIR && $COMPOSE_CMD run --rm claude-code"
echo "4. Authenticate Claude Code inside the container when prompted"
echo ""
echo "🔧 Useful commands:"
echo "=================="
echo "  Start container: $COMPOSE_CMD run --rm claude-code"
echo "  Build/rebuild:   $COMPOSE_CMD build --no-cache"
echo "  View config:     cat .env"
echo "  Edit config:     nano .env  # then rebuild"
echo "  Check status:    $COMPOSE_CMD ps"
echo ""
echo "⚡ Performance optimizations included:"
echo "====================================="
echo "  • Package manager caching for faster rebuilds"
echo "  • Optimized environment variables"
echo "  • Smart aliases for package operations:"
echo "    - ni <package>  → Install with $NODE_PACKAGE_MANAGER"
echo "    - pi <package>  → Install with $PYTHON_PACKAGE_MANAGER"
echo "    - cc            → Claude Code shortcut"
echo ""
echo "💡 Your configuration is saved in .env"
echo "   Edit this file anytime and rebuild to apply changes!"
