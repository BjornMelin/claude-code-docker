#!/bin/bash

# Claude Code Docker Cleanup Script
# Removes containers, images, and optionally project files

set -e

PROJECT_DIR="$HOME/claude-code-docker"

echo "🧹 Claude Code Docker Cleanup"
echo "==============================="

# Check if project directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ Project directory not found at $PROJECT_DIR"
    echo "Nothing to clean up."
    exit 0
fi

cd "$PROJECT_DIR"

# Determine docker compose command
COMPOSE_CMD="docker-compose"
if docker compose version &>/dev/null; then
    COMPOSE_CMD="docker compose"
fi

echo "Available cleanup options:"
echo "1. Stop and remove containers only"
echo "2. Remove containers and images"
echo "3. Remove containers, images, and volumes (⚠️  loses Claude Code config)"
echo "4. Full cleanup - remove everything including project directory"
echo "5. Cancel"
echo ""

read -p "Choose an option (1-5): " choice

case $choice in
1)
    echo "🛑 Stopping and removing containers..."
    $COMPOSE_CMD down
    echo "✅ Containers stopped and removed"
    ;;

2)
    echo "🛑 Stopping containers..."
    $COMPOSE_CMD down

    echo "🗑️  Removing images..."
    docker rmi claude-code-docker_claude-code 2>/dev/null || echo "Image not found (already removed?)"

    echo "✅ Containers and images removed"
    ;;

3)
    echo "⚠️  This will remove your Claude Code configuration!"
    read -p "Are you sure? (y/N): " confirm

    if [[ $confirm =~ ^[Yy]$ ]]; then
        echo "🛑 Stopping containers..."
        $COMPOSE_CMD down -v

        echo "🗑️  Removing images..."
        docker rmi claude-code-docker_claude-code 2>/dev/null || echo "Image not found"

        echo "🗑️  Removing volumes..."
        docker volume rm claude-code-docker_claude-code-config 2>/dev/null || echo "Volume not found"
        docker volume rm claude-code-docker_claude-code-history 2>/dev/null || echo "Volume not found"

        echo "✅ Containers, images, and volumes removed"
    else
        echo "❌ Cancelled"
    fi
    ;;

4)
    echo "⚠️  This will remove EVERYTHING including your project directory!"
    echo "📁 Project directory: $PROJECT_DIR"
    read -p "Are you absolutely sure? (y/N): " confirm

    if [[ $confirm =~ ^[Yy]$ ]]; then
        echo "🛑 Stopping containers..."
        $COMPOSE_CMD down -v

        echo "🗑️  Removing images..."
        docker rmi claude-code-docker_claude-code 2>/dev/null || echo "Image not found"

        echo "🗑️  Removing volumes..."
        docker volume rm claude-code-docker_claude-code-config 2>/dev/null || echo "Volume not found"
        docker volume rm claude-code-docker_claude-code-history 2>/dev/null || echo "Volume not found"

        echo "🗑️  Removing project directory..."
        cd "$HOME"
        rm -rf "$PROJECT_DIR"

        echo "✅ Full cleanup complete - everything removed"
    else
        echo "❌ Cancelled"
    fi
    ;;

5)
    echo "❌ Cleanup cancelled"
    exit 0
    ;;

*)
    echo "❌ Invalid option"
    exit 1
    ;;
esac

echo ""
echo "🧽 Docker system cleanup (removes unused containers/images)..."
read -p "Run 'docker system prune'? (y/N): " prune_confirm

if [[ $prune_confirm =~ ^[Yy]$ ]]; then
    docker system prune -f
    echo "✅ Docker system cleanup complete"
fi

echo ""
echo "🎉 Cleanup finished!"
