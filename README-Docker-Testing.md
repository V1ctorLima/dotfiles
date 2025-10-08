# Docker Testing for Dotfiles

This directory contains a complete Docker-based testing environment for your dotfiles using GNU Stow. This allows you to test your dotfiles configuration in a clean, isolated environment without affecting your host system.

## 🚀 Quick Start

### Prerequisites
- Docker
- Docker Compose
- Make (optional, for convenience commands)

### Basic Usage

1. **Run automated tests:**
   ```bash
   make test-auto
   ```

2. **Interactive testing:**
   ```bash
   make test
   # Inside the container, run:
   ./test-dotfiles.sh
   ```

3. **Start an interactive shell:**
   ```bash
   make shell    # bash shell
   make zsh      # zsh shell
   ```

## 📁 Files Overview

- **`Dockerfile`** - Defines the testing environment with Ubuntu 22.04, stow, and essential tools
- **`docker-compose.yml`** - Container orchestration with two services (interactive and automated)
- **`test-dotfiles.sh`** - Comprehensive test script that validates dotfiles deployment
- **`Makefile`** - Convenient commands for common operations
- **`README-Docker-Testing.md`** - This documentation file

## 🧪 Test Script Features

The `test-dotfiles.sh` script performs comprehensive testing:

1. **Environment Check** - Verifies stow is available
2. **Backup Management** - Backs up existing dotfiles before testing
3. **Stow Deployment** - Uses stow to deploy your dotfiles
4. **Symlink Verification** - Confirms all expected symlinks are created
5. **Configuration Testing** - Tests zsh, git, and vim configurations for syntax errors
6. **Structure Display** - Shows the deployed dotfiles structure
7. **Cleanup Testing** - Tests stow removal functionality
8. **Re-deployment** - Ensures dotfiles can be re-deployed successfully

## 🛠️ Available Make Commands

Run `make help` to see all available commands:

### Basic Commands
- `make test-auto` - Run automated tests
- `make test` - Start interactive test environment
- `make shell` - Start bash shell in container
- `make zsh` - Start zsh shell in container

### Development Commands
- `make build` - Build the Docker image
- `make dev-build` - Build without cache
- `make dev-test` - Fresh build and test

### Stow-Specific Commands
- `make stow-deploy` - Test stow deployment
- `make stow-remove` - Test stow removal

### Maintenance Commands
- `make clean` - Remove containers and images
- `make stop` - Stop running containers
- `make logs` - Show container logs

### Debugging Commands
- `make debug` - Start debug session
- `make inspect` - Inspect the built image

## 🔧 Manual Docker Commands

If you prefer not to use Make:

```bash
# Build the image
docker-compose build

# Run automated tests
docker-compose run --rm dotfiles-test-auto

# Start interactive session
docker-compose run --rm dotfiles-test

# Clean up
docker-compose down --rmi all --volumes --remove-orphans
```

## 📋 What Gets Tested

The testing environment validates:

### Dotfiles Structure
- `.zshenv` - ZSH environment configuration
- `.config/zsh/.zshrc` - ZSH shell configuration
- `.config/git/config` - Git configuration
- `.config/vim/vimrc` - Vim configuration
- `.config/bash/bashrc` - Bash configuration
- Various alias files and other configurations

### Stow Functionality
- Proper symlink creation
- Conflict detection and handling
- Clean removal of symlinks
- Re-deployment capability

### Configuration Validity
- ZSH configuration syntax
- Git configuration validity
- Vim configuration loading
- Environment variable setup

## 🐛 Troubleshooting

### Common Issues

1. **Permission Errors**
   ```bash
   # Make sure the test script is executable
   chmod +x test-dotfiles.sh
   ```

2. **Docker Build Fails**
   ```bash
   # Try building without cache
   make dev-build
   ```

3. **Stow Conflicts**
   - The test script automatically backs up existing files
   - Check the backup directory: `~/.dotfiles-backup-YYYYMMDD-HHMMSS`

4. **Configuration Errors**
   - Review the test output for specific error messages
   - Test individual configurations manually in the container

### Debugging Tips

1. **Inspect the container:**
   ```bash
   make inspect
   ```

2. **Start a debug session:**
   ```bash
   make debug
   ```

3. **Check container logs:**
   ```bash
   make logs
   ```

## 🔄 Development Workflow

1. **Make changes to your dotfiles**
2. **Run quick test:**
   ```bash
   make test-auto
   ```
3. **For detailed testing:**
   ```bash
   make test
   ./test-dotfiles.sh
   ```
4. **Debug issues:**
   ```bash
   make debug
   # Manual testing inside container
   ```

## 📝 Customization

### Adding New Dotfiles
1. Add the file to your dotfiles directory
2. Update `.gitignore` to include the new file (using the allowlist pattern)
3. Add the file to the `expected_links` array in `test-dotfiles.sh`
4. Run tests to verify

### Modifying Test Environment
- Edit `Dockerfile` to change the base image or installed packages
- Modify `docker-compose.yml` to adjust container configuration
- Update `test-dotfiles.sh` to add new test cases

## 🎯 Benefits of Docker Testing

- **Isolation** - Test without affecting your host system
- **Reproducibility** - Consistent testing environment
- **CI/CD Ready** - Can be integrated into automated pipelines
- **Multi-OS Testing** - Test on different Linux distributions
- **Clean State** - Each test starts with a fresh environment
- **Safe Experimentation** - Try changes without risk

## 📚 Additional Resources

- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/stow.html)
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

---

Happy dotfiles testing! 🎉

