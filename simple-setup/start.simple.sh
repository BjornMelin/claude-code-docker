#!/bin/bash

# Simple Claude Code Docker Start Script
# Convenience script to start the Claude Code container

set -e

PROJECT_DIR="$HOME/claude-code-docker"

# Check if project directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ Project directory not found at $PROJECT_DIR"
    echo "Please run the setup script first."
    exit 1
fi

cd "$PROJECT_DIR"

# Check if docker-compose.yml exists
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ docker-compose.yml not found. Please ensure all files are in place."
    exit 1
fi

echo "🚀 Starting Claude Code container..."

# Determine docker compose command
COMPOSE_CMD="docker-compose"
if docker compose version &>/dev/null; then
    COMPOSE_CMD="docker compose"
fi

# Build if needed
if [ "$1" = "--build" ] || [ "$1" = "-b" ]; then
    echo "🔨 Building container..."
    $COMPOSE_CMD build --no-cache
fi

# Start the container
echo "▶️  Launching Claude Code..."
echo "💡 Once inside the container, run 'claude' to start Claude Code"
echo "🔑 You'll need to authenticate Claude Code on first run"
echo "📁 Working directory: /workspace (clone your repos here)"
echo "🐚 Type 'exit' to leave the container"
echo ""

$COMPOSE_CMD run --rm claude-code

echo "✅ Container stopped."