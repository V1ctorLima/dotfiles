# dotfiles

My personal, **modern** configuration files. These dotfiles are built on a core philosophy of simplicity, productivity, and efficiency to enhance the development experience with modern CLI tools and beautiful aesthetics.

## Philosophy

This project is guided by the following principles:

1. **Productivity**: Streamline workflows with modern CLI tools and intelligent shortcuts.
2. **Aesthetics**: Apply consistent, beautiful themes and prompts for visual clarity.
3. **Efficiency**: Optimize shell performance with smart history, completion, and navigation.
4. **Modularity**: Organize configurations by platform and purpose for easy maintenance.
5. **Modern Tooling**: Integrate cutting-edge tools like `mise`, `atuin`, `fzf`, and `oh-my-posh`.

## Features & Highlights

### 🎨 **Beautiful Shell Experience**
- **Oh My Posh**: Custom Catppuccin-themed prompt with git integration and Nerd Font icons
- **Custom Symbols**: `➜` for success, `✗` for errors, beautiful git branch icons
- **Tab Completion**: Full AWS profile autocompletion with Granted

### 🚀 **Modern CLI Tools Integration**
- **[Mise](https://mise.jdx.dev/)**: Runtime version manager (replaces nvm, rbenv, etc.)
- **[Atuin](https://atuin.sh/)**: Magical shell history with sync and search
- **[FZF](https://github.com/junegunn/fzf)**: Fuzzy finder for files, history, and commands
- **[Granted](https://docs.commonfate.io/granted/)**: AWS role assumption made easy

### ⚡ **Enhanced ZSH Configuration**
- **Smart History**: Extended history with deduplication and timestamps
- **Intelligent Completion**: Case-insensitive matching with menu selection
- **Auto-suggestions**: Fish-like autosuggestions with syntax highlighting
- **Directory Navigation**: Auto-cd and smart path completion

### 🛠️ **Development Tools**
- **Git**: Comprehensive configuration with GPG signing and Delta integration
- **Vim**: Modern configuration with Catppuccin theme and Docker-friendly key mappings
- **Aliases**: Platform-specific aliases for macOS, Linux, BSD, and Windows

### 🐳 **Docker Testing Environment**
- **Isolated Testing**: Test dotfiles in clean Ubuntu containers
- **Automated Deployment**: One-command setup with `make test-deploy`
- **Interactive Mode**: Full shell experience for manual testing

## Quick Start

### Prerequisites

Before installing, ensure the following directory structure exists:

```sh
mkdir -p "$HOME/.cache/zsh" "$HOME/.local/bin" "$HOME/Projects"
```

The configurations require [GNU Stow](https://www.gnu.org/software/stow/) to manage symlinks:

```sh
# macOS
brew install stow

# Linux (Ubuntu/Debian)
sudo apt install stow

# Linux (Arch)
sudo pacman -S stow

# Linux (Fedora)
sudo dnf install stow
```

### Installation

Clone the repository and deploy the dotfiles:

```sh
cd "$HOME/Projects"
git clone https://github.com/yourusername/dotfiles
cd dotfiles
stow --verbose --adopt . --target="$HOME"
```

### Quick Setup Script

For a complete setup including dependencies:

```sh
./setup.sh
```

This script will:
- Detect your OS and install required packages
- Install modern CLI tools (mise, atuin, fzf, oh-my-posh)
- Configure ZSH as your default shell
- Deploy dotfiles using Stow
- Run comprehensive tests

## Docker Testing

Test your dotfiles in an isolated environment:

```sh
# Build and test interactively
make test

# Auto-deploy and start shell
make test-deploy

# Run automated tests
make test-automated

# Clean up
make clean
```

See [README-Docker-Testing.md](README-Docker-Testing.md) for detailed Docker testing documentation.

## Important Notes

- This process uses `stow --adopt`, which will replace existing configuration files with symlinks
- Use `stow --simulate` first to preview changes and avoid data loss
- The `.gitignore` is configured to ignore all files unless explicitly added with `git add -f`
- ZSH is set as the default shell - ensure it's installed on your system

## Configuration Structure

```
dotfiles/
├── .config/
│   ├── zsh/           # ZSH configuration and functions
│   ├── vim/           # Vim configuration with Catppuccin theme
│   ├── git/           # Git configuration with GPG and Delta
│   ├── oh-my-posh/    # Custom prompt themes
│   └── aliases.*      # Platform-specific aliases
├── .zshenv            # ZSH environment variables
├── setup.sh           # Automated setup script
└── Dockerfile         # Docker testing environment
```

## Shortcuts & Keybindings

This is a quick reference for the most important shortcuts and keybindings organized by application.

### ZSH Shell

Enhanced shell experience with modern keybindings:

| Shortcut | Action |
| :------- | :----- |
| `ctrl-r` | Search history with Atuin (magical search) |
| `ctrl-t` | Fuzzy find files with FZF |
| `ctrl-alt-h` | Fuzzy find directories with FZF |
| `ctrl-l` | Clear screen |
| `ctrl-u` | Clear entire line |
| `ctrl-a` | Move to beginning of line |
| `ctrl-e` | Move to end of line |
| `alt-left` | Move to previous word |
| `alt-right` | Move to next word |
| `ctrl-c` | Kill foreground process |
| `ctrl-z` | Suspend process (use `fg` to resume) |

### Git Aliases

Streamlined git workflow with short aliases:

| Alias | Command | Action |
| :---- | :------ | :----- |
| `g` | `git` | Git shorthand |
| `gs` | `git status` | Show repository status |
| `ga` | `git add` | Stage changes |
| `gc` | `git commit` | Commit changes |
| `gp` | `git push` | Push to remote |
| `gl` | `git pull` | Pull from remote |
| `gd` | `git diff` | Show differences |
| `gb` | `git branch` | List/create branches |
| `gco` | `git checkout` | Switch branches |

### Directory Navigation

Quick navigation aliases:

| Alias | Action |
| :---- | :----- |
| `~` | Go to home directory |
| `..` | Go up one directory |
| `...` | Go up two directories |
| `.3` | Go up three directories |
| `.4` | Go up four directories |
| `p` | Print current directory |

### File Operations

Safe file operations with confirmations:

| Alias | Command | Action |
| :---- | :------ | :----- |
| `rm` | `rm -iv` | Remove with confirmation |
| `cp` | `cp -iv` | Copy with confirmation |
| `mv` | `mv -iv` | Move with confirmation |
| `mkdir` | `mkdir -pv` | Create directories recursively |

### System Information

Platform-specific system aliases:

| Alias | Action (Linux) | Action (macOS) |
| :---- | :------------- | :------------- |
| `ls` | `ls --color=auto -lhF` | `ls -GlhF` |
| `ll` | `ls -alF` | `ls -alF` |
| `la` | `ls -A` | `ls -A` |
| `free` | `free -h` | `vm_stat` |
| `ps` | `ps aux` | `ps aux` |

### Vim Editor

Modern Vim configuration with Docker-friendly mappings:

| Shortcut | Action |
| :------- | :----- |
| `:wq` | Save and exit |
| `:q!` | Exit without saving |
| `dd` | Cut entire line |
| `yy` | Copy entire line |
| `p` | Paste |
| `u` | Undo |
| `ctrl-r` | Redo |
| `gg` | Go to beginning of file |
| `G` | Go to end of file |
| `/text` | Search for text |
| `n` | Next search result |
| `N` | Previous search result |

### Custom Functions & Aliases

Useful shell functions and aliases included:

| Function | Usage | Action |
| :------- | :---- | :----- |
| `pingts` | `pingts google.com` | Timestamped ping |
| `cheat` | `cheat curl` | Quick cheat sheets from cheat.sh |
| `server` | `server 8080` | Start HTTP server (default port 8000) |
| `assume` | `assume <profile>` | Assume AWS role with Granted (auto-configured) |

## Customization

### Oh My Posh Themes

Two prompt configurations are available:

- **`chippuccin.toml`**: Full Nerd Font version with icons
- **`chippuccin-ascii.toml`**: ASCII-safe version for Docker/SSH/Cloud terminals

The configuration automatically detects your environment and switches accordingly. You can also manually force ASCII mode by setting the `OH_MY_POSH_ASCII` environment variable.

### Platform-Specific Aliases

Aliases are organized by platform:

- **`aliases.unix.sh`**: Universal Unix aliases
- **`aliases.linux.sh`**: Linux-specific aliases  
- **`aliases.mac.sh`**: macOS-specific aliases
- **`aliases.bsd.sh`**: BSD-specific aliases
- **`aliases.windows.sh`**: Windows/WSL aliases

### Adding Custom Configurations

1. Add your files to the appropriate `.config/` directory
2. Update `.stow-local-ignore` if needed
3. Test with `stow --simulate` before deploying
4. Use `git add -f` to track new files

## Troubleshooting

### Common Issues

**Prompt showing weird characters or boxes?**

The fonts are likely installed but your terminal isn't configured correctly. Here's how to fix it:

**For Cursor/VS Code integrated terminal:**
1. Open Settings (Cmd+,)
2. Search for "terminal font"
3. Set `Terminal › Integrated: Font Family` to: `JetBrainsMono Nerd Font`
4. Close and reopen the terminal

Or add to your `settings.json`:
```json
"terminal.integrated.fontFamily": "JetBrainsMono Nerd Font",
"terminal.integrated.fontSize": 13,
"terminal.integrated.env.osx": {
    "TERM": "xterm-256color"
}
```

**For other terminals:**
- **iTerm2**: Preferences → Profiles → Text → Font → "JetBrainsMono Nerd Font"
- **Terminal.app**: Preferences → Profiles → Font → "JetBrainsMono Nerd Font"  
- **WezTerm/Alacritty/Kitty**: Check their config files

**Font not installed yet?**
- **Run the setup script**: `./setup.sh` automatically installs JetBrains Mono Nerd Font
- **Manual install**: Download from [Nerd Fonts](https://www.nerdfonts.com/)

**Test your setup:**
```bash
./test-nerd-fonts.sh
```

**ZSH not found?**
- Install ZSH: `brew install zsh` (macOS) or `sudo apt install zsh` (Linux)
- Set as default: `chsh -s $(which zsh)`

**Stow conflicts?**
- Use `stow --adopt` to replace existing files
- Or backup existing configs before running stow

**Modern tools not working?**
- Run `./setup.sh` to install all dependencies
- Check if `~/.local/bin` is in your PATH

### Getting Help

1. Check the [Docker Testing Guide](README-Docker-Testing.md)
2. Run `./test-dotfiles.sh` for comprehensive testing
3. Use `stow --simulate` to preview changes
4. Check individual config files for inline documentation

## Contributing

Feel free to fork this repository and adapt it to your needs. The modular structure makes it easy to:

- Add new tools and configurations
- Customize themes and prompts  
- Extend platform support
- Improve the Docker testing environment

## License

This project is open source and available under the [MIT License](LICENSE).

---

*Inspired by the minimalist philosophy of [lopes/dotfiles](https://raw.githubusercontent.com/lopes/dotfiles/refs/heads/master/README.md) with modern tooling enhancements.*
