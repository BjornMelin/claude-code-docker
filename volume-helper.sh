#!/bin/bash

# Volume Mapping Helper Script
# Helps users easily add custom directory mappings to their Claude Code container

set -e

OVERRIDE_FILE="docker-compose.override.yml"
BACKUP_FILE="docker-compose.override.yml.backup"

echo "📁 Claude Code Docker - Custom Volume Mapping Helper"
echo "===================================================="
echo ""

# Check if we're in the right directory
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Error: docker-compose.yml not found"
    echo "Please run this script from your claude-code-docker directory"
    exit 1
fi

# Function to backup existing override file
backup_override() {
    if [ -f "$OVERRIDE_FILE" ]; then
        cp "$OVERRIDE_FILE" "$BACKUP_FILE"
        echo "📋 Backed up existing override file to $BACKUP_FILE"
    fi
}

# Function to add volume mapping
add_volume_mapping() {
    local host_path="$1"
    local container_path="$2"
    local readonly="$3"
    local comment="$4"

    # Create override file if it doesn't exist
    if [ ! -f "$OVERRIDE_FILE" ]; then
        cat >"$OVERRIDE_FILE" <<'EOF'
version: '3.8'

services:
  claude-code:
    volumes:
      # Custom volume mappings added by volume helper
EOF
    fi

    # Add the volume mapping
    if [ "$readonly" = "true" ]; then
        readonly_flag="read_only: true"
    else
        readonly_flag=""
    fi

    cat >>"$OVERRIDE_FILE" <<EOF
      
      # $comment
      - type: bind
        source: $host_path
        target: $container_path${readonly_flag:+
        $readonly_flag}
EOF

    echo "✅ Added mapping: $host_path → $container_path${readonly_flag:+ (read-only)}"
}

# Function to show current mappings
show_current_mappings() {
    echo "📋 Current Volume Mappings:"
    echo "=========================="
    echo ""
    echo "📂 Base mappings (from docker-compose.yml):"

    # Extract volume mappings from docker-compose.yml
    if command -v yq &>/dev/null; then
        yq '.services.claude-code.volumes[]' docker-compose.yml 2>/dev/null || echo "  (unable to parse - yq not installed)"
    else
        echo "  No host repos mounted - container uses fresh clones"
        echo "  ~/.zshrc → /host-config/.zshrc (read-only)"
        echo "  ~/.ssh → /home/developer/.ssh (read-only)"
        echo "  ~/.gitconfig → /home/developer/.gitconfig (read-only)"
        echo "  ~/.npmrc → /home/developer/.npmrc (read-only)"
    fi

    echo ""
    if [ -f "$OVERRIDE_FILE" ]; then
        echo "📂 Custom mappings (from $OVERRIDE_FILE):"
        # Show custom mappings
        grep -A 2 -B 1 "source:" "$OVERRIDE_FILE" | grep -E "(#|source:|target:)" || echo "  (no custom mappings yet)"
    else
        echo "📂 Custom mappings: none yet"
    fi
    echo ""
}

# Function to remove all custom mappings
remove_all_custom() {
    if [ -f "$OVERRIDE_FILE" ]; then
        backup_override
        rm "$OVERRIDE_FILE"
        echo "🗑️  Removed all custom mappings"
        echo "📋 Backup saved as $BACKUP_FILE"
    else
        echo "ℹ️  No custom mappings to remove"
    fi
}

# Function to add common presets
add_preset() {
    local preset="$1"

    backup_override

    case $preset in
    "windows-dev")
        echo "Adding Windows development preset..."
        add_volume_mapping "/mnt/c/Users/\$(whoami)/Desktop" "/workspace/desktop" "false" "Windows Desktop access"
        add_volume_mapping "/mnt/c/Users/\$(whoami)/Documents" "/workspace/documents" "false" "Windows Documents"
        add_volume_mapping "/mnt/c/Program Files/Git" "/workspace/git-tools" "true" "Git tools (read-only)"
        ;;
    "node-dev")
        echo "Adding Node.js development preset..."
        add_volume_mapping "\${HOME}/.nvm" "/workspace/nvm-config" "true" "Node Version Manager config"
        add_volume_mapping "\${HOME}/node_modules" "/workspace/global-node-modules" "false" "Global node modules"
        ;;
    "python-dev")
        echo "Adding Python development preset..."
        add_volume_mapping "\${HOME}/.virtualenvs" "/workspace/python-envs" "false" "Python virtual environments"
        add_volume_mapping "\${HOME}/.pyenv" "/workspace/pyenv-config" "true" "Python version manager"
        ;;
    "docker-dev")
        echo "Adding Docker development preset..."
        add_volume_mapping "/var/run/docker.sock" "/var/run/docker.sock" "false" "Docker socket (Docker-in-Docker)"
        ;;
    *)
        echo "❌ Unknown preset: $preset"
        return 1
        ;;
    esac
}

# Main menu
while true; do
    echo "Choose an option:"
    echo "1. Show current volume mappings"
    echo "2. Add custom volume mapping"
    echo "3. Add preset configurations"
    echo "4. Remove all custom mappings"
    echo "5. Edit override file manually"
    echo "6. Rebuild container (applies changes)"
    echo "7. Exit"
    echo ""
    read -p "Enter your choice (1-7): " choice

    case $choice in
    1)
        show_current_mappings
        ;;
    2)
        echo ""
        echo "📁 Add Custom Volume Mapping"
        echo "============================"
        read -p "Host path (absolute path): " host_path

        if [ ! -e "$host_path" ]; then
            echo "⚠️  Warning: $host_path does not exist"
            read -p "Create it now? (y/N): " create_choice
            if [[ $create_choice =~ ^[Yy]$ ]]; then
                mkdir -p "$host_path"
                echo "✅ Created $host_path"
            fi
        fi

        read -p "Container path [/workspace/$(basename "$host_path")]: " container_path
        container_path=${container_path:-/workspace/$(basename "$host_path")}

        read -p "Read-only? (y/N): " readonly_choice
        readonly_choice=${readonly_choice,,}
        if [[ $readonly_choice =~ ^(y|yes)$ ]]; then
            readonly="true"
        else
            readonly="false"
        fi

        read -p "Description/comment: " comment
        comment=${comment:-"Custom mapping"}

        backup_override
        add_volume_mapping "$host_path" "$container_path" "$readonly" "$comment"
        ;;
    3)
        echo ""
        echo "📦 Available Presets:"
        echo "==================="
        echo "1. windows-dev  - Windows Desktop, Documents, Git tools"
        echo "2. node-dev     - Node.js/npm configuration"
        echo "3. python-dev   - Python virtual environments"
        echo "4. docker-dev   - Docker-in-Docker support"
        echo ""
        read -p "Choose preset (1-4): " preset_choice

        case $preset_choice in
        1) add_preset "windows-dev" ;;
        2) add_preset "node-dev" ;;
        3) add_preset "python-dev" ;;
        4) add_preset "docker-dev" ;;
        *) echo "❌ Invalid preset choice" ;;
        esac
        ;;
    4)
        echo ""
        read -p "⚠️  Remove ALL custom mappings? (y/N): " confirm
        if [[ $confirm =~ ^[Yy]$ ]]; then
            remove_all_custom
        fi
        ;;
    5)
        if command -v nano &>/dev/null; then
            nano "$OVERRIDE_FILE"
        elif command -v vim &>/dev/null; then
            vim "$OVERRIDE_FILE"
        else
            echo "Please edit $OVERRIDE_FILE manually"
        fi
        ;;
    6)
        echo ""
        echo "🔨 Rebuilding container to apply changes..."

        # Determine docker compose command
        COMPOSE_CMD="docker-compose"
        if docker compose version &>/dev/null; then
            COMPOSE_CMD="docker compose"
        fi

        $COMPOSE_CMD down
        $COMPOSE_CMD build --no-cache
        echo "✅ Container rebuilt! Start it with: $COMPOSE_CMD run --rm claude-code"
        ;;
    7)
        echo "👋 Goodbye!"
        exit 0
        ;;
    *)
        echo "❌ Invalid choice"
        ;;
    esac

    echo ""
    echo "Press Enter to continue..."
    read
    echo ""
done
