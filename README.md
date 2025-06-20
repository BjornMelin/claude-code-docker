# Claude Code Docker Container for WSL

🐳 Isolated Claude Code development environment for WSL with **multi-language support**, **configurable package managers**, **custom directory mappings**, and seamless access to your host development files while keeping Claude Code configuration isolated. Get Anthropic's AI assistant running in Docker while keeping your repos, configs, and SSH keys perfectly mapped. This setup creates an isolated Docker container for running Claude Code on WSL Windows 11, with proper volume mapping to access your host development files while keeping Claude Code configuration isolated. Perfect for Windows developers! ⚡

## ✨ Features

- 🚀 **High-Performance Package Managers**: Choose pnpm (10-100x faster) or uv (10-100x faster) for maximum speed
- 🌐 **Multi-Language Support**: Node.js 20 + Python 3.12 pre-configured
- 📦 **Package Manager Selection**: Choose your preferred Node.js (npm/pnpm/yarn) and Python (pip/uv) managers
- 🐚 **Configurable Shell Support**: Choose between zsh, bash, or fish
- 📁 **Easy Custom Directory Mapping**: Interactive setup for your specific needs  
- 🎯 **Preset Configurations**: Quick setup for common development scenarios
- 🔧 **Volume Mapping Helper**: GUI tool for managing custom directories
- 📝 **Comprehensive Configuration**: Template files for advanced customization
- ⚡ **Performance Optimization**: Smart caching and environment configuration

## Package Manager Performance Benefits

### 🚀 **Recommended High-Performance Setup**

- **pnpm** (Node.js): 10-100x faster than npm, efficient disk usage
- **uv** (Python): 10-100x faster than pip, written in Rust

This combination provides **maximum development speed** with significantly faster:

- Package installations
- Dependency resolution  
- Virtual environment creation
- Build operations

### 📊 **Performance Comparison**

| Operation | npm + pip | pnpm + uv | Improvement |
|-----------|-----------|-----------|-------------|
| Package install | 45s | 2-5s | **10-20x faster** |
| Dependency resolution | 30s | 1-3s | **10-15x faster** |
| Environment setup | 60s | 3-8s | **8-20x faster** |
| Build operations | Variable | Consistently faster | **Significantly improved** |

## Features

- ✅ **Isolated Claude Code Environment**: Container has its own Claude Code configuration and authentication
- ✅ **Multi-Language Ready**: Node.js 20 + Python 3.12 with optimized package managers
- ✅ **Package Manager Choice**: Select npm/pnpm/yarn for Node.js and pip/uv for Python
- ✅ **Shell Choice**: Pick zsh (with Oh My Zsh), bash, or fish as your preferred shell
- ✅ **Access to Host Repos**: Full read/write access to your configured repositories directory
- ✅ **Inherited Shell Configuration**: Container sources your host shell config
- ✅ **Custom Directory Mappings**: Map any host directories into the container
- ✅ **Git Integration**: Access to your SSH keys and git configuration
- ✅ **Persistent Configuration**: Claude Code settings persist between container restarts
- ✅ **WSL Optimized**: Uses WSL file system for optimal performance
- ✅ **Proper Permissions**: UID/GID mapping prevents permission issues
- ✅ **Smart Aliases**: Automatic aliases based on your package manager choices

## Setup Options

### 🚀 **Enhanced Setup (Recommended)**

The main files in this repository provide a full-featured, multi-language container with:

- **Multi-language support**: Node.js 20 + Python 3.12
- **Package manager selection**: Choose high-performance options (pnpm + uv)  
- **Interactive configuration**: Guided setup with explanations
- **Custom directory mappings**: Map any host directories you need

### 📦 **Simple Setup (Basic)**

For users who want minimal configuration, check the `simple-setup/` directory which provides:

- **Node.js only** with npm
- **zsh shell** with Oh My Zsh
- **Basic volume mapping** for repos and configs
- **No interactive setup** - just run and go

Most users should start with the **Enhanced Setup** as it provides much better performance and is still easy to use.

## Prerequisites

- Windows 11 with WSL2 enabled
- Docker Desktop installed and running
- Ubuntu (or similar) distribution in WSL
- Node.js knowledge (for understanding Claude Code)

## Quick Start

### Option 1: Enhanced Interactive Setup (Recommended)

The enhanced setup script will guide you through configuring your preferred package managers, shell, and directory mappings:

```bash
chmod +x setup.sh
./setup.sh
```

This interactive setup will ask about:

- **Package managers**: Node.js (npm/pnpm/yarn) and Python (pip/uv) with performance explanations
- Your preferred shell (zsh, bash, or fish)
- Container name and username
- Directory mappings (repos, documents, etc.)
- Configuration file paths
- Custom directory mappings

### Option 2: Quick Performance Setup

For maximum performance without interaction:

```bash
# Copy the configuration template
cp .env.example .env

# Edit for high-performance setup (pnpm + uv)
nano .env  # Set NODE_PACKAGE_MANAGER=pnpm, PYTHON_PACKAGE_MANAGER=uv

# Build and start
docker-compose build
docker-compose run --rm claude-code
```

### Option 3: Use Presets

For common development scenarios, use the volume helper:

```bash
chmod +x volume-helper.sh
./volume-helper.sh
# Choose from Windows dev, Node.js dev, Python dev, or Docker dev presets
```

### 4. Authenticate Claude Code

Inside the container, run:

```bash
claude
```

Follow the authentication prompts to connect your Anthropic account.

## Package Manager Configuration

### Node.js Package Manager Options

#### 🚀 **pnpm (Recommended)**

```bash
NODE_PACKAGE_MANAGER=pnpm
```

- **Performance**: 10-100x faster than npm
- **Efficiency**: Uses hard links to save disk space  
- **Security**: Strict dependency resolution prevents phantom dependencies
- **Best for**: All development, especially large projects and monorepos

#### 📦 **npm (Standard)**

```bash
NODE_PACKAGE_MANAGER=npm
```

- **Compatibility**: Works with all existing projects
- **Familiarity**: Standard commands everyone knows
- **Best for**: Beginners, maximum compatibility needs

#### 🧶 **yarn**

```bash
NODE_PACKAGE_MANAGER=yarn
```

- **Reliability**: Excellent lockfile handling
- **Teams**: Great workspace management
- **Best for**: Team development, existing Yarn projects

### Python Package Manager Options

#### ⚡ **uv (Highly Recommended)**

```bash
PYTHON_PACKAGE_MANAGER=uv
```

- **Performance**: 10-100x faster than pip
- **Modern**: Written in Rust with advanced dependency resolution
- **Automatic**: Handles virtual environments seamlessly
- **Best for**: All Python development

#### 🐍 **pip (Standard)**

```bash
PYTHON_PACKAGE_MANAGER=pip
```

- **Compatibility**: Works with all existing Python projects
- **Simplicity**: Familiar commands and behavior
- **Best for**: Simple projects, learning Python

## Configuration Options

### Shell Selection

Choose your preferred shell during setup:

- **zsh** (default): Includes Oh My Zsh with plugins and themes
- **bash**: Classic bash with your existing .bashrc
- **fish**: Modern shell with smart suggestions

### Directory Mappings

The container supports flexible directory mappings:

#### Core Mappings (Always Included)

- `~/repos` → `/workspace/repos` (your main development directory)
- Shell config → `/host-config/` (inherits your aliases and functions)
- `~/.ssh` → `/home/developer/.ssh` (git authentication)
- `~/.gitconfig` → `/home/developer/.gitconfig` (git identity)

#### Custom Mappings

Add unlimited custom directory mappings using:

1. **Interactive setup**: Guided configuration during initial setup
2. **Volume helper**: `./volume-helper.sh` for post-setup changes
3. **Manual editing**: Edit `docker-compose.override.yml` directly

#### Preset Configurations

Quick setup for common scenarios:

- **Windows Development**: Desktop, Documents, Git tools access
- **Node.js Development**: NVM config, global modules
- **Python Development**: Virtual environments, pyenv
- **Docker Development**: Docker-in-Docker support

## Usage

### Starting the Container

Use the main docker-compose file:

```bash
docker-compose run --rm claude-code
```

Or with the convenience script:

```bash
./start.sh
```

### Working with Claude Code

Once inside the container:

1. **Start Claude Code**: Run `claude` in any directory
2. **Access Your Repos**: Your configured repos directory is at `/workspace/repos`
3. **Use Git**: Your SSH keys and git config are available
4. **Multi-Language Development**: Both Node.js and Python are ready to use
5. **Package Management**: Use smart aliases based on your selections
6. **Custom Directories**: Access any mapped directories under `/workspace/`

### Smart Package Management Aliases

The container automatically creates aliases based on your package manager choices:

#### Node.js Development

```bash
# Universal aliases (work with any selected package manager)
ni <package>        # Install package
na <package>        # Add package to project
nr <script>         # Run npm script
ndev               # Install dev dependencies
nbuild             # Build project

# Examples:
ni typescript      # Installs typescript with your selected manager
na express         # Adds express to your project
nr start           # Runs npm start script
```

#### Python Development  

```bash
# Universal aliases (work with any selected package manager)
pi <package>        # Install package
pir                # Install from requirements.txt
pidev              # Install dev dependencies

# UV-specific aliases (when uv is selected)
pirun <command>     # Run command in uv environment
pisync             # Sync dependencies with uv
piadd <package>     # Add package with uv

# Examples:
pi flask           # Installs flask with your selected manager
pir                # Installs from requirements.txt
pirun python app.py # Runs python with uv (if selected)
```

#### Container Information

```bash
./container-info.sh    # Show container configuration
claude-info            # Show Claude Code status (if alias exists)
```

### Performance Monitoring

Check your package manager performance:

```bash
# Time package installations to see the speed difference
time ni lodash           # With pnpm: ~1-3 seconds
time pi requests         # With uv: ~1-3 seconds

# Compare with traditional managers:
# npm install lodash     # Would take ~10-30 seconds
# pip install requests   # Would take ~5-15 seconds
```

### Multi-Language Project Workflow

**Starting a new Node.js project:**

```bash
cd /workspace/repos
mkdir my-node-project && cd my-node-project
npm init -y  # Creates package.json
ni express typescript  # Fast installation with your package manager
claude  # Start Claude Code for development
```

**Starting a new Python project:**

```bash
cd /workspace/repos
mkdir my-python-project && cd my-python-project

# With uv (auto-creates virtual environment)
pirun python -m venv .  # Creates venv if using pip
pi flask fastapi       # Fast installation

claude  # Start Claude Code for development
```

**Working on existing projects:**

```bash
cd /workspace/repos/<project-name>

# Node.js project
ni                     # Install dependencies fast
nr test               # Run tests

# Python project  
pir                   # Install from requirements.txt fast
pirun pytest          # Run tests (with uv)

claude                # Start Claude Code
```

### Managing Virtual Environments

#### With uv (Automatic)

```bash
# uv handles virtual environments automatically
pi <package>          # Installs in project-specific environment
pirun <command>       # Runs in the correct environment
```

#### With pip (Manual)

```bash
# Create and activate virtual environment
python -m venv venv
source venv/bin/activate  # Linux/WSL
pi <package>             # Install in virtual environment
```

## Directory Structure

```text
Host (WSL)                    Container
├── ~/repos/             →    /workspace/repos/ (read/write)
├── ~/.zshrc             →    /host-config/.zshrc (read-only)
├── ~/.ssh/              →    /home/developer/.ssh (read-only)  
├── ~/.gitconfig         →    /home/developer/.gitconfig (read-only)
├── ~/.npmrc             →    /home/developer/.npmrc (read-only)
└── [custom directories] →    /workspace/[custom]/ (configurable)

Container-Specific:
├── /home/developer/.claude/     (Claude Code config - isolated)
├── /home/developer/.cache/      (Package manager caches - persistent)
├── /home/developer/.local/      (Package manager data - persistent)
└── /workspace/                  (Main working area)
    ├── repos/                   (Your development repositories)
    ├── documents/               (Optional: mapped ~/Documents)  
    ├── desktop/                 (Optional: mapped Windows Desktop)
    └── custom1-3/               (Optional: your custom mappings)

Multi-Language Environment:
├── Node.js 20                   (Built-in with selected package manager)
├── Python 3.12                 (Built-in with selected package manager)  
├── Package Manager Binaries:
│   ├── pnpm (if selected)       → ~/.local/share/pnpm/
│   ├── yarn (if selected)       → ~/.yarn/bin/
│   ├── uv (if selected)         → ~/.local/bin/
│   └── npm (always available)   → /usr/local/bin/
└── Development Tools:
    ├── git, gh (GitHub CLI)
    ├── fzf, delta (enhanced diffs)
    └── Shell framework (zsh/bash/fish)
```

### Example Custom Mappings

```text
Host Path                     Container Path              Purpose
~/Documents              →    /workspace/documents       Document access
~/Desktop                →    /workspace/desktop         Quick file access  
/mnt/c/SharedProjects    →    /workspace/shared         Team projects
~/.config                →    /workspace/host-config    Config backup (read-only)
~/.aws                   →    /workspace/aws-config     AWS credentials (read-only)
~/project-templates      →    /workspace/templates      Project scaffolds
```

## Volume Mapping Details

### Core Mappings (Always Present)

| Host Path | Container Path | Access | Purpose |
|-----------|---------------|---------|---------|
| `${REPOS_PATH}` | `/workspace/repos` | Read/Write | Development repositories |
| `${SHELL_CONFIG_PATH}` | `/host-config/.${SHELL}rc` | Read-Only | Shell configuration |
| `${SSH_PATH}` | `/home/developer/.ssh` | Read-Only | SSH keys for git |
| `${GIT_CONFIG_PATH}` | `/home/developer/.gitconfig` | Read-Only | Git user configuration |
| `${NPM_CONFIG_PATH}` | `/home/developer/.npmrc` | Read-Only | NPM configuration |

### Performance Volumes (Persistent Caches)

| Volume Name | Container Path | Purpose |
|-------------|---------------|---------|
| `claude-code-config` | `/home/developer/.claude` | Claude Code settings (isolated) |
| `claude-code-history` | `/home/developer/.shell_history_persistent` | Command history |
| `python-cache` | `/home/developer/.cache` | Python package caches (uv, pip) |
| `node-cache` | `/home/developer/.local/share` | Node.js package caches (pnpm, yarn) |

### Package Manager Paths

| Package Manager | Cache Location | Config Location |
|----------------|----------------|-----------------|
| **pnpm** | `~/.local/share/pnpm/store` | `~/.pnpmrc` |
| **uv** | `~/.cache/uv` | `~/.config/uv/` |
| **yarn** | `~/.yarn/cache` | `~/.yarnrc.yml` |
| **npm** | `~/.npm` | `~/.npmrc` |
| **pip** | `~/.cache/pip` | `~/.pip/pip.conf` |

### Custom Mappings (User Configurable)

Custom mappings are defined in:

- `.env` file (for simple mappings)
- `docker-compose.override.yml` (for complex configurations)
- Volume helper script (interactive management)

Common custom mapping examples:

- Windows directories (`/mnt/c/Users/...`)
- Development tools (`~/.nvm`, `~/.pyenv`, `~/.aws`)
- Project-specific directories
- Backup and archive locations
- Team shared resources

## Project Files

### Core Files

- **`Dockerfile`**: Multi-language container with configurable package managers
- **`docker-compose.yml`**: Enhanced container configuration with package manager support
- **`setup.sh`**: Interactive setup script with package manager selection
- **`start.sh`**: Convenient container launcher
- **`cleanup.sh`**: Maintenance and cleanup utilities

### Configuration Files  

- **`.env`**: Your custom configuration (created by setup)
- **`.env.example`**: Template with all package manager options and examples
- **`docker-compose.override.yml`**: Custom volume mappings (optional)

### Helper Scripts

- **`volume-helper.sh`**: Interactive volume mapping management
- **`container-info.sh`**: Shows container configuration and package manager status
- **`README.md`**: This comprehensive guide

### Simple Setup Files (for basic usage)

- **`simple-setup/`**: Directory containing simplified versions
  - **`Dockerfile.simple`**: Basic zsh-only container
  - **`docker-compose.simple.yml`**: Simple container configuration
  - **`setup.simple.sh`**: Basic setup script
  - **`README.simple.md`**: Simple setup documentation

## Troubleshooting

### Package Manager Issues

**pnpm not found or not working:**

```bash
# Verify pnpm installation
which pnpm
pnpm --version

# Rebuild container with pnpm
NODE_PACKAGE_MANAGER=pnpm docker-compose build --no-cache
```

**uv not found or not working:**

```bash
# Verify uv installation  
which uv
uv --version

# Rebuild container with uv
PYTHON_PACKAGE_MANAGER=uv docker-compose build --no-cache
```

**Slow package installations:**

```bash
# Check if you're using high-performance package managers
echo "Node: $NODE_PACKAGE_MANAGER, Python: $PYTHON_PACKAGE_MANAGER"

# Switch to high-performance setup
nano .env  # Set NODE_PACKAGE_MANAGER=pnpm, PYTHON_PACKAGE_MANAGER=uv
docker-compose build --no-cache
```

### Permission Issues

If you encounter permission errors:

```bash
# Rebuild with correct UID/GID
docker-compose build --no-cache

# Or run setup again to regenerate .env
./setup.sh
```

### Container Won't Start

1. Check Docker is running: `docker info`
2. Verify WSL: `grep microsoft /proc/version`
3. Check file permissions: `ls -la .`
4. Validate configuration: `docker-compose config`
5. Check package manager selection: `cat .env | grep PACKAGE_MANAGER`

### Shell Configuration Issues

**Wrong shell selected:**

```bash
# Edit .env file
nano .env
# Change PREFERRED_SHELL=bash (or zsh/fish)
docker-compose build --no-cache
```

**Shell config not loading:**

```bash
# Verify shell config path in .env
echo $SHELL_CONFIG_PATH
# Check if file exists and is readable
ls -la $SHELL_CONFIG_PATH
```

**Package manager aliases not working:**

```bash
# Check if aliases are loaded
alias | grep -E "(ni|pi|cc)"

# Restart shell or source config
exec $SHELL
```

### Performance Issues

**Package operations still slow:**

```bash
# Verify you're using high-performance managers
container-info

# Check for correct package manager selection
echo "Using: $NODE_PACKAGE_MANAGER for Node.js, $PYTHON_PACKAGE_MANAGER for Python"

# Clear caches and rebuild
docker-compose down -v
docker-compose build --no-cache
```

**Container startup slow:**

```bash
# Check if package manager caches are being used
docker volume ls | grep claude-code

# Rebuild without cache if needed
docker-compose build --no-cache --pull
```

### Multi-Language Issues

**Python packages not found:**

```bash
# Check Python environment
python --version
which python
which pip # or which uv

# Verify package manager selection
echo $PYTHON_PACKAGE_MANAGER
```

**Node.js packages not found:**

```bash
# Check Node.js environment
node --version
which node
which npm # or which pnpm/yarn

# Verify package manager selection  
echo $NODE_PACKAGE_MANAGER
```

### Volume Mapping Issues

**Custom directories not accessible:**

```bash
# Use volume helper to check mappings
./volume-helper.sh

# Verify paths in override file
cat docker-compose.override.yml

# Check if host directories exist
ls -la /path/to/host/directory
```

**Package manager configs not loading:**

```bash
# Check if package manager config files are mapped
ls -la ~/.npmrc ~/.pnpmrc ~/.yarnrc.yml

# Verify config file paths in .env
grep CONFIG_PATH .env
```

### Claude Code Authentication Issues

1. Ensure internet connectivity in container
2. Check Anthropic API status
3. Try clearing Claude Code config: `rm -rf ~/.claude` (inside container)
4. Verify API key if using environment variables

### File Access Issues

1. Verify host directories exist: `ls -la ~/repos`
2. Check mount paths: `docker-compose config`
3. Restart Docker Desktop if needed
4. Use volume helper to verify mappings: `./volume-helper.sh`

## Advanced Configuration

### Multi-Shell Support

The container supports multiple shells with their respective frameworks:

**Zsh (default):**

- Includes Oh My Zsh
- Supports .zshrc inheritance
- Default themes and plugins

**Bash:**

- Uses existing .bashrc
- Compatible with most existing configurations
- Reliable and widely supported

**Fish:**

- Modern shell with auto-suggestions
- Uses config.fish for configuration
- Built-in features and syntax highlighting

### Custom Environment Variables

Edit `.env` file to customize:

```bash
# Container settings
CONTAINER_NAME=my-claude-env
CONTAINER_USERNAME=myuser
PREFERRED_SHELL=bash

# Path configurations  
REPOS_PATH=/mnt/c/MyProjects
SHELL_CONFIG_PATH=/home/user/.bashrc

# Custom working directory
CONTAINER_WORKING_DIR=/workspace/myproject
```

### Docker Compose Overrides

For complex configurations, use `docker-compose.override.yml`:

```yaml
version: '3.8'
services:
  claude-code:
    volumes:
      - type: bind
        source: /mnt/c/SharedFolder
        target: /workspace/shared
    environment:
      - CUSTOM_VAR=value
    ports:
      - "8080:8080"
```

### Multiple Container Instances

Run multiple isolated environments:

```bash
# Copy project directory
cp -r claude-code-docker claude-code-project1

# Edit configuration
cd claude-code-project1
nano .env  # Change CONTAINER_NAME

# Run separate instance
docker-compose up -d
```

## Security Considerations

- SSH keys are mounted read-only for security
- Claude Code configuration is isolated in container volumes
- Container runs as non-root user with matching host UID/GID
- Host file system access is limited to explicitly mapped directories
- Custom mappings can be set to read-only for additional protection

## Cleanup

### Quick Cleanup

```bash
./cleanup.sh
```

### Manual Cleanup Options

**Remove Container and Images:**

```bash
docker-compose down
docker system prune -f
```

**Remove Project Directory:**

```bash
rm -rf ~/claude-code-docker
```

**Reset Claude Code Configuration:**

```bash
docker volume rm claude-code-docker_claude-code-config
```

**Remove All Custom Mappings:**

```bash
rm docker-compose.override.yml
```

## Tips and Best Practices

### Setup Tips

1. **Use the interactive setup** for first-time configuration
2. **Choose your preferred shell** during setup - easier than changing later
3. **Map commonly used directories** during initial setup
4. **Use presets** for quick configuration of common development scenarios

### Usage Tips  

1. **Authenticate once** - credentials persist between sessions
2. **Keep repos organized** in your mapped repos directory
3. **Use git inside container** - all your keys and config are available
4. **Leverage custom mappings** for project-specific directories
5. **Use the volume helper** for easy mapping management

### Performance Tips

1. **Use WSL file system paths** (not /mnt/c/) for better performance
2. **Limit custom mappings** to directories you actually need
3. **Use read-only mappings** for configuration files
4. **Clean up unused containers** regularly with cleanup script

### Development Workflows

1. **One container per major project** for isolation
2. **Use preset configurations** for consistent team setups  
3. **Map team-shared directories** for collaboration
4. **Version control your .env** file (without secrets) for team sharing

## Support

For issues related to:

- **Claude Code itself**: Check [Anthropic's documentation](https://docs.anthropic.com/en/docs/claude-code)
- **Docker setup**: Verify Docker Desktop and WSL2 configuration
- **This container**: Check logs with `docker-compose logs`
- **Volume mappings**: Use `./volume-helper.sh` for interactive troubleshooting
- **Shell issues**: Verify your shell config and PREFERRED_SHELL setting

## Contributing

Contributions are welcome! Please feel free to:

- Report bugs and issues
- Suggest new presets or features
- Improve documentation
- Submit pull requests

## Changelog

### Enhanced Version (v2.0)

- ✅ Multi-shell support (zsh, bash, fish)
- ✅ Interactive setup with custom directory mapping
- ✅ Volume mapping helper script
- ✅ Configuration presets for common scenarios
- ✅ Comprehensive .env configuration
- ✅ Docker Compose override support
- ✅ Enhanced documentation and troubleshooting

### Original Version (v1.0)  

- ✅ Basic zsh-only container
- ✅ Fixed directory mappings
- ✅ WSL optimization
- ✅ Claude Code integration

---

**Note**: This setup is optimized for WSL2 on Windows 11. Performance and features may vary on other platforms.
