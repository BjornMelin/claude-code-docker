# Simple Claude Code Docker Setup

This directory contains the **simplified version** of the Claude Code Docker setup for users who want a basic, straightforward configuration without the advanced multi-language features and package manager selection.

## 🎯 **When to Use Simple Setup**

Choose the simple setup if you:

- Want a quick, no-configuration setup
- Only need basic Node.js development with Claude Code
- Prefer npm over other package managers
- Don't need Python development support
- Want minimal complexity

## 📁 **Files in This Directory**

- **`Dockerfile.simple`** - Basic zsh-only container with Claude Code
- **`docker-compose.simple.yml`** - Simple container configuration  
- **`setup.simple.sh`** - Basic setup script (no interactive options)
- **`start.simple.sh`** - Simple container launcher
- **`cleanup.simple.sh`** - Basic cleanup script

## 🚀 **Quick Start**

1. **Run the simple setup:**

```bash
cd simple-setup
chmod +x setup.simple.sh
./setup.simple.sh
```

2. **Copy simple files to project directory:**

```bash
cp Dockerfile.simple ~/claude-code-docker/Dockerfile
cp docker-compose.simple.yml ~/claude-code-docker/docker-compose.yml
cp start.simple.sh ~/claude-code-docker/start.sh
cp cleanup.simple.sh ~/claude-code-docker/cleanup.sh
```

3. **Build and start:**

```bash
cd ~/claude-code-docker
docker-compose build
./start.sh
```

## 📦 **What You Get**

- **Node.js 20** with npm
- **zsh** with Oh My Zsh
- **Claude Code** pre-installed
- **Isolated workspace** at /workspace
- **Git integration** with SSH keys
- **Persistent Claude Code configuration**

## 🔄 **Migrating to Enhanced Setup**

If you later want the advanced multi-language features with package manager selection, simply:

1. Go back to the main directory
2. Run the enhanced setup: `./setup.sh`
3. Rebuild with enhanced configuration

## 🆚 **Simple vs Enhanced Comparison**

| Feature | Simple Setup | Enhanced Setup |
|---------|-------------|----------------|
| Languages | Node.js only | Node.js + Python |
| Package Managers | npm only | Configurable (pnpm/npm/yarn + uv/pip) |
| Shell Options | zsh only | Configurable (zsh/bash/fish) |
| Setup Process | Automated | Interactive with choices |
| Performance | Standard | Optimized (10-100x faster with right choices) |
| Complexity | Minimal | Advanced but guided |
| Custom Mappings | Basic | Advanced with helper tools |

## 💡 **Recommendation**

For most users, we recommend trying the **enhanced setup** in the main directory first, as it:

- Provides much better performance with optimized package managers
- Still supports simple choices (just select npm + pip)
- Includes helpful explanations during setup
- Can be configured to match the simple setup exactly

The simple setup is mainly provided for:

- Users who specifically want minimal configuration
- Automated deployments where interaction isn't possible
- Learning/educational purposes
- Backwards compatibility
