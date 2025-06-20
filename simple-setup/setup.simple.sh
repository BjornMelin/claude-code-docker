#!/bin/bash

# Basic Claude Code Docker Setup Script for WSL
# This script sets up a Docker container for Claude Code with simple volume mapping

set -e

echo "🚀 Setting up Claude Code Docker container for WSL..."

# Check if we're running in WSL
if ! grep -q microsoft /proc/version 2>/dev/null; then
    echo "❌ This script should be run in WSL (Windows Subsystem for Linux)"
    exit 1
fi

# Check if Docker is installed and running
if ! command -v docker &>/dev/null; then
    echo "❌ Docker is not installed. Please install Docker Desktop first."
    exit 1
fi

if ! docker info &>/dev/null; then
    echo "❌ Docker is not running. Please start Docker Desktop."
    exit 1
fi

# Check if docker-compose is available
if ! command -v docker-compose &>/dev/null && ! docker compose version &>/dev/null; then
    echo "❌ Docker Compose is not available. Please install Docker Compose."
    exit 1
fi

# Create project directory
PROJECT_DIR="$HOME/claude-code-docker"
echo "📁 Creating project directory at $PROJECT_DIR"
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# Get host UID and GID
HOST_UID=$(id -u)
HOST_GID=$(id -g)

echo "👤 Host UID: $HOST_UID, GID: $HOST_GID"

# Create .env file
echo "📝 Creating environment configuration..."
cat >.env <<EOF
HOST_UID=${HOST_UID}
HOST_GID=${HOST_GID}
HOME=${HOME}
EOF

# Ensure required directories exist
echo "📂 Ensuring required directories exist..."
mkdir -p "$HOME/repos"

# Create missing config files if they don't exist
if [ ! -f "$HOME/.zshrc" ]; then
    echo "📄 Creating default .zshrc..."
    cat >"$HOME/.zshrc" <<'EOF'
# Default zsh configuration
export PATH=$PATH:/usr/local/bin
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
EOF
fi

if [ ! -f "$HOME/.gitconfig" ]; then
    echo "📄 Creating default .gitconfig..."
    cat >"$HOME/.gitconfig" <<'EOF'
[user]
    name = Your Name
    email = your.email@example.com
[core]
    editor = vim
EOF
    echo "⚠️  Please update ~/.gitconfig with your actual git user information"
fi

if [ ! -d "$HOME/.ssh" ]; then
    echo "📄 Creating .ssh directory..."
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
fi

if [ ! -f "$HOME/.npmrc" ]; then
    echo "📄 Creating default .npmrc..."
    touch "$HOME/.npmrc"
fi

echo "✅ Setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Copy the Dockerfile and docker-compose.yml to $PROJECT_DIR"
echo "2. Run: cd $PROJECT_DIR && docker-compose build"
echo "3. Run: cd $PROJECT_DIR && docker-compose run --rm claude-code"
echo "4. Authenticate Claude Code inside the container when prompted"
echo ""
echo "🔧 Useful commands:"
echo "  Start container: docker-compose run --rm claude-code"
echo "  Build/rebuild:   docker-compose build --no-cache"
echo "  View logs:       docker-compose logs"
echo "  Cleanup:         docker-compose down && docker system prune"
echo ""
echo "💡 The container will have access to:"
echo "  - Your repos in ~/repos (read/write)"
echo "  - Your shell config from ~/.zshrc (read-only)"  
echo "  - Your SSH keys from ~/.ssh (read-only)"
echo "  - Your git config from ~/.gitconfig (read-only)"
echo "  - Isolated Claude Code configuration"