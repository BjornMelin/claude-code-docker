#!/bin/bash

# Container Info Script
# Shows detailed information about the Claude Code container configuration

set -e

echo "📋 Claude Code Container Information"
echo "==================================="
echo ""

# Check if we're running inside the container
if [ -f /.dockerenv ] || grep -q docker /proc/1/cgroup 2>/dev/null; then
    INSIDE_CONTAINER=true
    echo "🐳 Running inside container"
else
    INSIDE_CONTAINER=false
    echo "🖥️  Running on host system"
fi

echo ""

# Container Configuration
echo "📦 Container Configuration:"
echo "=========================="

if [ "$INSIDE_CONTAINER" = true ]; then
    # Inside container - show actual configuration
    echo "🏷️  Container Name: $(hostname)"
    echo "👤 Container User: $(whoami)"
    echo "🆔 User ID: $(id -u):$(id -g)"
    echo "🏠 Home Directory: $HOME"
    echo "📁 Working Directory: $(pwd)"
    echo "🐚 Current Shell: $SHELL"

    # Package Manager Information
    echo ""
    echo "📦 Package Managers:"
    echo "==================="

    # Node.js and package manager
    if command -v node &>/dev/null; then
        NODE_VERSION=$(node --version)
        echo "📗 Node.js: $NODE_VERSION"

        # Detect active Node package manager
        if [ -n "$NODE_PACKAGE_MANAGER" ]; then
            echo "📦 Node Package Manager: $NODE_PACKAGE_MANAGER"
        else
            # Try to detect from available commands
            if command -v pnpm &>/dev/null; then
                PNPM_VERSION=$(pnpm --version 2>/dev/null || echo "unknown")
                echo "📦 pnpm: v$PNPM_VERSION (available)"
            fi
            if command -v yarn &>/dev/null; then
                YARN_VERSION=$(yarn --version 2>/dev/null || echo "unknown")
                echo "📦 yarn: v$YARN_VERSION (available)"
            fi
            if command -v npm &>/dev/null; then
                NPM_VERSION=$(npm --version 2>/dev/null || echo "unknown")
                echo "📦 npm: v$NPM_VERSION (available)"
            fi
        fi
    else
        echo "❌ Node.js not found"
    fi

    # Python and package manager
    if command -v python &>/dev/null; then
        PYTHON_VERSION=$(python --version 2>&1 | cut -d' ' -f2)
        echo "🐍 Python: v$PYTHON_VERSION"

        # Detect active Python package manager
        if [ -n "$PYTHON_PACKAGE_MANAGER" ]; then
            echo "📦 Python Package Manager: $PYTHON_PACKAGE_MANAGER"
        else
            # Try to detect from available commands
            if command -v uv &>/dev/null; then
                UV_VERSION=$(uv --version 2>/dev/null | cut -d' ' -f2 || echo "unknown")
                echo "⚡ uv: v$UV_VERSION (available)"
            fi
            if command -v pip &>/dev/null; then
                PIP_VERSION=$(pip --version 2>/dev/null | cut -d' ' -f2 || echo "unknown")
                echo "📦 pip: v$PIP_VERSION (available)"
            fi
        fi
    else
        echo "❌ Python not found"
    fi

    # Claude Code
    echo ""
    echo "🤖 Claude Code:"
    echo "==============="
    if command -v claude &>/dev/null; then
        CLAUDE_VERSION=$(claude --version 2>/dev/null || echo "not authenticated")
        echo "🤖 Claude Code: $CLAUDE_VERSION"
        echo "📁 Config Directory: ${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

        # Check if authenticated
        if claude --version &>/dev/null; then
            echo "✅ Authentication: Ready"
        else
            echo "⚠️  Authentication: Not authenticated (run 'claude' to authenticate)"
        fi
    else
        echo "❌ Claude Code not found"
    fi

    # Development Tools
    echo ""
    echo "🔧 Development Tools:"
    echo "===================="

    # Git
    if command -v git &>/dev/null; then
        GIT_VERSION=$(git --version | cut -d' ' -f3)
        echo "📝 Git: v$GIT_VERSION"

        # Git configuration
        GIT_USER=$(git config user.name 2>/dev/null || echo "not configured")
        GIT_EMAIL=$(git config user.email 2>/dev/null || echo "not configured")
        echo "   User: $GIT_USER <$GIT_EMAIL>"
    fi

    # GitHub CLI
    if command -v gh &>/dev/null; then
        GH_VERSION=$(gh --version | head -n1 | cut -d' ' -f3)
        echo "🐙 GitHub CLI: v$GH_VERSION"
    fi

    # Other tools
    if command -v fzf &>/dev/null; then
        FZF_VERSION=$(fzf --version | cut -d' ' -f1)
        echo "🔍 fzf: v$FZF_VERSION"
    fi

    if command -v delta &>/dev/null; then
        DELTA_VERSION=$(delta --version | cut -d' ' -f2)
        echo "📊 delta: v$DELTA_VERSION"
    fi

    # Volume Mounts
    echo ""
    echo "📂 Volume Mounts:"
    echo "================="
    echo "🏠 Host repos → /workspace/repos"
    if [ -d "/workspace/repos" ]; then
        REPO_COUNT=$(find /workspace/repos -maxdepth 1 -type d | wc -l)
        REPO_COUNT=$((REPO_COUNT - 1)) # Subtract the parent directory
        echo "   📊 Repositories found: $REPO_COUNT"
    else
        echo "   ❌ Repos directory not mounted"
    fi

    if [ -f "/host-config/.zshrc" ]; then
        echo "🐚 Host shell config → /host-config/"
    fi

    if [ -d "/home/$(whoami)/.ssh" ]; then
        SSH_KEY_COUNT=$(find /home/$(whoami)/.ssh -name "*.pub" 2>/dev/null | wc -l)
        echo "🔑 SSH keys mounted: $SSH_KEY_COUNT public keys found"
    fi

    # Custom mounts
    if [ -d "/workspace" ]; then
        CUSTOM_DIRS=$(find /workspace -maxdepth 1 -type d ! -name "repos" ! -name "workspace" | wc -l)
        if [ "$CUSTOM_DIRS" -gt 0 ]; then
            echo "📁 Custom mounts:"
            find /workspace -maxdepth 1 -type d ! -name "repos" ! -name "workspace" | while read dir; do
                DIRNAME=$(basename "$dir")
                echo "   📂 $DIRNAME → $dir"
            done
        fi
    fi

    # Performance Information
    echo ""
    echo "⚡ Performance Information:"
    echo "=========================="

    # Package manager performance notes
    if [ "$NODE_PACKAGE_MANAGER" = "pnpm" ] || command -v pnpm &>/dev/null; then
        echo "🚀 pnpm detected - High performance Node.js package management"
    fi

    if [ "$PYTHON_PACKAGE_MANAGER" = "uv" ] || command -v uv &>/dev/null; then
        echo "⚡ uv detected - Ultra-fast Python package management"
    fi

    if [ "$NODE_PACKAGE_MANAGER" = "pnpm" ] && [ "$PYTHON_PACKAGE_MANAGER" = "uv" ]; then
        echo "🎉 MAXIMUM PERFORMANCE SETUP - You're using the fastest package managers!"
    fi

    # Aliases
    echo ""
    echo "🔗 Available Aliases:"
    echo "===================="
    echo "📦 Package Management:"
    if [ -n "$NODE_PACKAGE_MANAGER" ]; then
        echo "   ni <package>  → Install Node.js package with $NODE_PACKAGE_MANAGER"
        echo "   na <package>  → Add Node.js package"
        echo "   nr <script>   → Run npm script"
    fi
    if [ -n "$PYTHON_PACKAGE_MANAGER" ]; then
        echo "   pi <package>  → Install Python package with $PYTHON_PACKAGE_MANAGER"
        echo "   pir           → Install from requirements.txt"
        if [ "$PYTHON_PACKAGE_MANAGER" = "uv" ]; then
            echo "   pirun <cmd>   → Run command with uv"
        fi
    fi
    echo ""
    echo "🤖 Claude Code:"
    echo "   claude        → Start Claude Code"
    echo "   cc            → Claude Code alias"
    echo "   claude-config → Configure Claude Code"

else
    # Running on host - show project configuration
    echo "📁 Project Directory: /home/bjorn/repos/containers/claude-code-docker"

    # Check for configuration files
    if [ -f "/home/bjorn/repos/containers/claude-code-docker/.env" ]; then
        echo "✅ Configuration file found (.env)"
        echo ""
        echo "📋 Current Configuration:"
        echo "========================"

        # Read configuration safely
        if command -v grep &>/dev/null; then
            echo "📦 Package Managers:"
            NODE_PKG=$(grep "NODE_PACKAGE_MANAGER=" /home/bjorn/repos/containers/claude-code-docker/.env 2>/dev/null | cut -d'=' -f2 || echo "not set")
            PYTHON_PKG=$(grep "PYTHON_PACKAGE_MANAGER=" /home/bjorn/repos/containers/claude-code-docker/.env 2>/dev/null | cut -d'=' -f2 || echo "not set")
            SHELL_TYPE=$(grep "PREFERRED_SHELL=" /home/bjorn/repos/containers/claude-code-docker/.env 2>/dev/null | cut -d'=' -f2 || echo "not set")

            echo "   Node.js: $NODE_PKG"
            echo "   Python: $PYTHON_PKG"
            echo "   Shell: $SHELL_TYPE"
        fi
    else
        echo "⚠️  No configuration file found - run ./setup.sh to create one"
    fi

    echo ""
    echo "🚀 Quick Start Commands:"
    echo "======================="
    echo "   ./setup.sh              → Configure the container"
    echo "   docker-compose build    → Build the container"
    echo "   ./start.sh              → Start the container"
    echo "   ./volume-helper.sh      → Manage volume mappings"
    echo "   ./cleanup.sh            → Clean up containers"
fi

echo ""
echo "📚 Need Help?"
echo "============="
echo "   📖 Read the README.md for comprehensive documentation"
echo "   🔧 Run ./volume-helper.sh for volume mapping management"
if [ "$INSIDE_CONTAINER" = true ]; then
    echo "   🤖 Run 'claude' to start coding with Claude Code"
    echo "   🚪 Run 'exit' to leave the container"
else
    echo "   🚀 Run './start.sh' to enter the container"
fi
echo ""
