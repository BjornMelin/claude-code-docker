# Claude Code Docker Container for WSL

🐳 Isolated Claude Code development environment for WSL with configurable shells, custom directory mappings, and seamless access to your host development files. Get Anthropic's AI assistant running in Docker while keeping your repos, configs, and SSH keys perfectly mapped. This setup creates an isolated Docker container for running Claude Code on WSL Windows 11, with proper volume mapping to access your host development files while keeping Claude Code configuration isolated. Perfect for Windows developers! ⚡

## ✨ New Features

- 🐚 **Configurable Shell Support**: Choose between zsh, bash, or fish
- 📁 **Easy Custom Directory Mapping**: Interactive setup for your specific needs
- 🎯 **Preset Configurations**: Quick setup for common development scenarios
- 🔧 **Volume Mapping Helper**: GUI tool for managing custom directories
- 📝 **Comprehensive Configuration**: Template files for advanced customization

## Features

- ✅ **Isolated Claude Code Environment**: Container has its own Claude Code configuration and authentication
- ✅ **Shell Choice**: Pick zsh (with Oh My Zsh), bash, or fish as your preferred shell
- ✅ **Access to Host Repos**: Full read/write access to your configured repositories directory
- ✅ **Inherited Shell Configuration**: Container sources your host shell config
- ✅ **Custom Directory Mappings**: Map any host directories into the container
- ✅ **Git Integration**: Access to your SSH keys and git configuration
- ✅ **Persistent Configuration**: Claude Code settings persist between container restarts
- ✅ **WSL Optimized**: Uses WSL file system for optimal performance
- ✅ **Proper Permissions**: UID/GID mapping prevents permission issues

## Prerequisites

- Windows 11 with WSL2 enabled
- Docker Desktop installed and running
- Ubuntu (or similar) distribution in WSL
- Node.js knowledge (for understanding Claude Code)

## Quick Start

### Option 1: Interactive Setup (Recommended)

The enhanced setup script will guide you through configuring your preferred shell and directory mappings:

```bash
chmod +x setup.sh
./setup.sh
```

This interactive setup will ask about:

- Your preferred shell (zsh, bash, or fish)
- Container name and username
- Directory mappings (repos, documents, etc.)
- Configuration file paths
- Custom directory mappings

### Option 2: Manual Setup

1. **Copy the configuration template:**

   ```bash
   cp .env.example .env
   nano .env  # Edit with your preferences
   ```

2. **Create the container:**

   ```bash
   docker-compose build
   ```

3. **Start Claude Code:**

   ```bash
   chmod +x start.sh
   ./start.sh
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

Use the start script for convenience:

```bash
./start.sh
```

Or use docker-compose directly:

```bash
docker-compose run --rm claude-code
```

### Working with Claude Code

Once inside the container:

1. **Start Claude Code**: Run `claude` in any directory
2. **Access Your Repos**: Your configured repos directory is at `/workspace/repos`
3. **Use Git**: Your SSH keys and git config are available
4. **Shell Environment**: Your host shell config is inherited
5. **Custom Directories**: Access any mapped directories under `/workspace/`

### Managing Volume Mappings

Use the volume helper script for easy management:

```bash
./volume-helper.sh
```

Options include:

- View current mappings
- Add new custom mappings
- Apply preset configurations
- Remove mappings
- Rebuild container

### Common Workflows

**Starting a new project:**

```bash
cd /workspace/repos
git clone <repository-url>
cd <repository-name>
claude
```

**Working on existing project:**

```bash
cd /workspace/repos/<project-name>
claude
```

**Accessing custom directories:**

```bash
cd /workspace/documents    # If you mapped ~/Documents
cd /workspace/desktop      # If you mapped Windows Desktop
cd /workspace/custom1      # Your custom mappings
```

**Quick Claude Code commands:**

```bash
claude /help          # Show help
claude /config         # Configure Claude Code
claude /cost           # Show session cost
claude /clear          # Clear conversation
cc                     # Alias for claude
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

Container Only:
├── /home/developer/.claude/     (Claude Code config - isolated)
├── /home/developer/.shell_history (Command history - persistent)
└── /workspace/                  (Main working area)
```

### Example Custom Mappings

```text
Host Path                     Container Path              Purpose
~/Documents              →    /workspace/documents       Document access
~/Desktop                →    /workspace/desktop         Quick file access
/mnt/c/SharedProjects    →    /workspace/shared         Team projects
~/.config                →    /workspace/host-config    Config backup (read-only)
~/.nvm                   →    /workspace/nvm-config     Node version manager
```

## Volume Mapping Details

### Core Mappings (Always Present)

| Host Path              | Container Path               | Access     | Purpose                  |
| ---------------------- | ---------------------------- | ---------- | ------------------------ |
| `${REPOS_PATH}`        | `/workspace/repos`           | Read/Write | Development repositories |
| `${SHELL_CONFIG_PATH}` | `/host-config/.${SHELL}rc`   | Read-Only  | Shell configuration      |
| `${SSH_PATH}`          | `/home/developer/.ssh`       | Read-Only  | SSH keys for git         |
| `${GIT_CONFIG_PATH}`   | `/home/developer/.gitconfig` | Read-Only  | Git user configuration   |
| `${NPM_CONFIG_PATH}`   | `/home/developer/.npmrc`     | Read-Only  | NPM configuration        |

### Persistent Volumes

| Volume Name           | Container Path                              | Purpose                         |
| --------------------- | ------------------------------------------- | ------------------------------- |
| `claude-code-config`  | `/home/developer/.claude`                   | Claude Code settings (isolated) |
| `claude-code-history` | `/home/developer/.shell_history_persistent` | Command history                 |

### Custom Mappings (User Configurable)

Custom mappings are defined in:

- `.env` file (for simple mappings)
- `docker-compose.override.yml` (for complex configurations)
- Volume helper script (interactive management)

Common custom mapping examples:

- Windows directories (`/mnt/c/Users/...`)
- Development tools (`~/.nvm`, `~/.pyenv`)
- Project-specific directories
- Backup and archive locations

## Project Files

### Core Files

- **`Dockerfile`**: Configurable container image with multi-shell support
- **`docker-compose.yml`**: Base container configuration
- **`setup.sh`**: Interactive setup script with shell and directory configuration
- **`start.sh`**: Convenient container launcher
- **`cleanup.sh`**: Maintenance and cleanup utilities

### Configuration Files

- **`.env`**: Your custom configuration (created by setup)
- **`.env.example`**: Template with all available options and examples
- **`docker-compose.override.yml`**: Custom volume mappings (optional)

### Helper Scripts

- **`volume-helper.sh`**: Interactive volume mapping management
- **`README.md`**: This comprehensive guide

## Troubleshooting

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

**Path doesn't exist errors:**

```bash
# Create missing directories
mkdir -p /path/to/missing/directory

# Or use setup script to recreate structure
./setup.sh
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
version: "3.8"
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
