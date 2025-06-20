FROM node:20-slim

# Build arguments for package manager selection
ARG NODE_PACKAGE_MANAGER=pnpm
ARG PYTHON_PACKAGE_MANAGER=uv
ARG DEFAULT_SHELL=zsh
ARG USER_UID=1000
ARG USER_GID=1000
ARG USERNAME=developer
ARG PYTHON_VERSION=3.11

# Set timezone
ARG TZ=UTC
ENV TZ="$TZ"

# Install system dependencies including Python
RUN apt-get update && apt-get install -y \
    # Core system tools
    git \
    curl \
    wget \
    unzip \
    sudo \
    procps \
    less \
    vim \
    nano \
    man-db \
    # Shells
    zsh \
    bash \
    fish \
    # Development tools
    fzf \
    jq \
    gh \
    # Python and build essentials
    python${PYTHON_VERSION} \
    python${PYTHON_VERSION}-dev \
    python${PYTHON_VERSION}-venv \
    python3-pip \
    # Build tools for native packages
    build-essential \
    gcc \
    g++ \
    make \
    # Networking and security
    ca-certificates \
    gnupg2 \
    # Clean up
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Create symlinks for python/pip to point to specific version
RUN ln -sf /usr/bin/python${PYTHON_VERSION} /usr/bin/python3 \
    && ln -sf /usr/bin/python3 /usr/bin/python

# Install Node.js package managers as root (before USER switch)
RUN if [ "$NODE_PACKAGE_MANAGER" = "pnpm" ]; then \
        # Install pnpm via corepack
        corepack enable pnpm && \
        corepack install --global pnpm@latest; \
    elif [ "$NODE_PACKAGE_MANAGER" = "yarn" ]; then \
        # Install yarn via corepack
        corepack enable yarn && \
        corepack install --global yarn@stable; \
    fi

# Install git-delta for better diffs (as root)
RUN ARCH=$(dpkg --print-architecture) && \
    wget "https://github.com/dandavison/delta/releases/download/0.18.2/git-delta_0.18.2_${ARCH}.deb" && \
    dpkg -i "git-delta_0.18.2_${ARCH}.deb" && \
    rm "git-delta_0.18.2_${ARCH}.deb"

# Create developer user, but gracefully handle cases where UID/GID 1000 already exist in the base image
RUN groupadd -f -o -g $USER_GID $USERNAME \
    && useradd -o -m -u $USER_UID -g $USER_GID $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set default shell for user (as root)
RUN if [ "$DEFAULT_SHELL" = "zsh" ]; then \
        chsh -s /bin/zsh $USERNAME; \
    elif [ "$DEFAULT_SHELL" = "bash" ]; then \
        chsh -s /bin/bash $USERNAME; \
    elif [ "$DEFAULT_SHELL" = "fish" ]; then \
        chsh -s /usr/bin/fish $USERNAME; \
    fi

# Create necessary directories
RUN mkdir -p /workspace/repos \
    && mkdir -p /home/$USERNAME/.claude \
    && mkdir -p /home/$USERNAME/.config \
    && mkdir -p /home/$USERNAME/.local/bin \
    && mkdir -p /home/$USERNAME/.cache \
    && chown -R $USERNAME:$USERNAME /workspace /home/$USERNAME

# Switch to developer user for package manager installations
USER $USERNAME
WORKDIR /home/$USERNAME

# Set up package manager environment variables
ENV NODE_PACKAGE_MANAGER="$NODE_PACKAGE_MANAGER"
ENV PYTHON_PACKAGE_MANAGER="$PYTHON_PACKAGE_MANAGER"
ENV PNPM_HOME="/home/$USERNAME/.local/share/pnpm"
ENV UV_CACHE_DIR="/home/$USERNAME/.cache/uv"
ENV UV_PYTHON_DOWNLOADS="never"
ENV UV_COMPILE_BYTECODE="1"
ENV UV_LINK_MODE="copy"

# Configure PATH for all package managers
ENV PATH="/home/$USERNAME/.local/bin:$PNPM_HOME:$PATH"

# Configure pnpm store directory if using pnpm
RUN if [ "$NODE_PACKAGE_MANAGER" = "pnpm" ]; then \
        pnpm config set store-dir /home/$USERNAME/.local/share/pnpm/store; \
    fi

# Install Python package managers based on selection
RUN if [ "$PYTHON_PACKAGE_MANAGER" = "uv" ]; then \
        # Install uv (ultra-fast Python package manager)
        curl -LsSf https://astral.sh/uv/install.sh | sh && \
        echo 'export PATH="/home/'$USERNAME'/.local/bin:$PATH"' >> ~/.bashrc; \
    else \
        # Upgrade pip to latest version
        python3 -m pip install --user --upgrade pip setuptools wheel; \
    fi

# Install shell frameworks based on DEFAULT_SHELL
RUN if [ "$DEFAULT_SHELL" = "zsh" ]; then \
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; \
    elif [ "$DEFAULT_SHELL" = "fish" ]; then \
        curl -L https://get.oh-my.fish | fish || true; \
    fi

# Install Claude Code using the selected Node package manager
RUN if [ "$NODE_PACKAGE_MANAGER" = "pnpm" ]; then \
        pnpm install -g @anthropic-ai/claude-code; \
    elif [ "$NODE_PACKAGE_MANAGER" = "yarn" ]; then \
        yarn global add @anthropic-ai/claude-code; \
    else \
        npm install -g @anthropic-ai/claude-code; \
    fi

# Verify Claude Code installation
RUN claude --version && echo "✅ Claude Code successfully installed with $NODE_PACKAGE_MANAGER"

# Create comprehensive shell configuration
RUN if [ "$DEFAULT_SHELL" = "zsh" ]; then \
        # Configure zsh
        echo '# Source host .zshrc if available' > ~/.zshrc && \
        echo 'if [ -f /host-config/.zshrc ]; then' >> ~/.zshrc && \
        echo '  source /host-config/.zshrc' >> ~/.zshrc && \
        echo 'fi' >> ~/.zshrc && \
        echo '' >> ~/.zshrc && \
        echo '# Container Environment Info' >> ~/.zshrc && \
        echo 'echo "🚀 Claude Code Container Ready!"' >> ~/.zshrc && \
        echo 'echo "📦 Node.js $(node --version) with '$NODE_PACKAGE_MANAGER'"' >> ~/.zshrc && \
        echo 'echo "🐍 Python $(python --version | cut -d\" \" -f2) with '$PYTHON_PACKAGE_MANAGER'"' >> ~/.zshrc && \
        echo 'echo "🐚 '$DEFAULT_SHELL' shell configured"' >> ~/.zshrc && \
        echo 'echo ""' >> ~/.zshrc && \
        echo '# Package Manager Environment' >> ~/.zshrc && \
        echo 'export NODE_PACKAGE_MANAGER='$NODE_PACKAGE_MANAGER >> ~/.zshrc && \
        echo 'export PYTHON_PACKAGE_MANAGER='$PYTHON_PACKAGE_MANAGER >> ~/.zshrc && \
        echo 'export CLAUDE_CONFIG_DIR=/home/'$USERNAME'/.claude' >> ~/.zshrc && \
        echo '' >> ~/.zshrc && \
        echo '# Smart Package Manager Aliases' >> ~/.zshrc && \
        echo 'alias ni="'$NODE_PACKAGE_MANAGER' install"' >> ~/.zshrc && \
        echo 'alias na="'$NODE_PACKAGE_MANAGER' add"' >> ~/.zshrc && \
        echo 'alias nr="'$NODE_PACKAGE_MANAGER' run"' >> ~/.zshrc && \
        echo 'alias pi="'$PYTHON_PACKAGE_MANAGER' install"' >> ~/.zshrc && \
        echo 'if [ "'$PYTHON_PACKAGE_MANAGER'" = "uv" ]; then' >> ~/.zshrc && \
        echo '  alias pir="uv add -r requirements.txt"' >> ~/.zshrc && \
        echo '  alias pis="uv add --dev"  # install as dev dependency' >> ~/.zshrc && \
        echo '  alias pirun="uv run"      # run with uv' >> ~/.zshrc && \
        echo 'else' >> ~/.zshrc && \
        echo '  alias pir="pip install -r requirements.txt"' >> ~/.zshrc && \
        echo 'fi' >> ~/.zshrc && \
        echo '' >> ~/.zshrc && \
        echo '# Claude Code Aliases' >> ~/.zshrc && \
        echo 'alias cc="claude"' >> ~/.zshrc && \
        echo 'alias claude-config="claude /config"' >> ~/.zshrc && \
        echo '' >> ~/.zshrc && \
        echo '# Default to workspace/repos directory' >> ~/.zshrc && \
        echo 'cd /workspace/repos 2>/dev/null || cd /workspace' >> ~/.zshrc; \
    elif [ "$DEFAULT_SHELL" = "bash" ]; then \
        # Configure bash (similar structure)
        echo '# Source host .bashrc if available' > ~/.bashrc && \
        echo 'if [ -f /host-config/.bashrc ]; then' >> ~/.bashrc && \
        echo '  source /host-config/.bashrc' >> ~/.bashrc && \
        echo 'fi' >> ~/.bashrc && \
        echo '# Container Environment Info' >> ~/.bashrc && \
        echo 'echo "🚀 Claude Code Container Ready!"' >> ~/.bashrc && \
        echo 'echo "📦 Node.js $(node --version) with '$NODE_PACKAGE_MANAGER'"' >> ~/.bashrc && \
        echo 'echo "🐍 Python $(python --version | cut -d\" \" -f2) with '$PYTHON_PACKAGE_MANAGER'"' >> ~/.bashrc && \
        echo 'export NODE_PACKAGE_MANAGER='$NODE_PACKAGE_MANAGER >> ~/.bashrc && \
        echo 'export PYTHON_PACKAGE_MANAGER='$PYTHON_PACKAGE_MANAGER >> ~/.bashrc && \
        echo 'alias ni="'$NODE_PACKAGE_MANAGER' install"' >> ~/.bashrc && \
        echo 'alias pi="'$PYTHON_PACKAGE_MANAGER' install"' >> ~/.bashrc && \
        echo 'alias cc="claude"' >> ~/.bashrc && \
        echo 'cd /workspace/repos 2>/dev/null || cd /workspace' >> ~/.bashrc; \
    elif [ "$DEFAULT_SHELL" = "fish" ]; then \
        # Configure fish
        mkdir -p ~/.config/fish && \
        echo '# Fish configuration with package managers' > ~/.config/fish/config.fish && \
        echo 'set -x NODE_PACKAGE_MANAGER '$NODE_PACKAGE_MANAGER >> ~/.config/fish/config.fish && \
        echo 'set -x PYTHON_PACKAGE_MANAGER '$PYTHON_PACKAGE_MANAGER >> ~/.config/fish/config.fish && \
        echo 'alias ni="'$NODE_PACKAGE_MANAGER' install"' >> ~/.config/fish/config.fish && \
        echo 'alias pi="'$PYTHON_PACKAGE_MANAGER' install"' >> ~/.config/fish/config.fish && \
        echo 'alias cc="claude"' >> ~/.config/fish/config.fish && \
        echo 'cd /workspace/repos 2>/dev/null || cd /workspace' >> ~/.config/fish/config.fish; \
    fi

# Create a helpful info script
RUN echo '#!/bin/bash' > /home/$USERNAME/container-info.sh && \
    echo 'echo "📋 Container Configuration:"' >> /home/$USERNAME/container-info.sh && \
    echo 'echo "  Node.js: $(node --version) with '$NODE_PACKAGE_MANAGER'"' >> /home/$USERNAME/container-info.sh && \
    echo 'echo "  Python: $(python --version) with '$PYTHON_PACKAGE_MANAGER'"' >> /home/$USERNAME/container-info.sh && \
    echo 'echo "  Shell: '$DEFAULT_SHELL'"' >> /home/$USERNAME/container-info.sh && \
    echo 'echo "  Claude Code: $(claude --version 2>/dev/null || echo \"not authenticated\")"' >> /home/$USERNAME/container-info.sh && \
    echo 'echo ""' >> /home/$USERNAME/container-info.sh && \
    echo 'echo "🔧 Quick Commands:"' >> /home/$USERNAME/container-info.sh && \
    echo 'echo "  claude          - Start Claude Code"' >> /home/$USERNAME/container-info.sh && \
    echo 'echo "  ni <package>    - Install Node package with '$NODE_PACKAGE_MANAGER'"' >> /home/$USERNAME/container-info.sh && \
    echo 'echo "  pi <package>    - Install Python package with '$PYTHON_PACKAGE_MANAGER'"' >> /home/$USERNAME/container-info.sh && \
    echo 'echo "  cc              - Claude Code alias"' >> /home/$USERNAME/container-info.sh && \
    chmod +x /home/$USERNAME/container-info.sh

# Set working directory
WORKDIR /workspace/repos

# Default command based on shell choice
CMD ["/bin/sh", "-c", "exec $SHELL"]