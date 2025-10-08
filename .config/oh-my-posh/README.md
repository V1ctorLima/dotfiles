# Oh My Posh Configuration

This directory contains Oh My Posh prompt configuration with a beautiful Catppuccin theme.

## Files

### `chippuccin.toml`
- **Catppuccin-themed config** with Nerd Font icons
- **Best for**: Desktop terminals with proper font support
- **Requires**: Nerd Font installed (e.g., FiraCode Nerd Font, JetBrains Mono Nerd Font)
- **Features**: Custom symbols for success/error states and git branches

## Custom Symbols & Icon Replacements

### Custom Prompt Symbols
- **Success Symbol**: `➜` (bold green) - shown when last command succeeded
- **Error Symbol**: `✗` (bold red) - shown when last command failed  
- **Git Branch**: `🌱` - prefix for git branch names

### Icon Replacements (Docker vs Desktop)

| Feature | Nerd Font Icon | ASCII Alternative |
|---------|---------------|-------------------|
| SSH Session | `󰒍` | `[SSH]` |
| Local Session | `󰟀` | `[LOCAL]` |
| Folder Separator | `󰿟` | `/` |
| Git Changes | Various | `*` |
| Git Behind | Various | `v` |
| Git Ahead | Various | `^` |
| Success Prompt | `➜` | `➜` |
| Error Prompt | `✗` | `✗` |
| Git Branch | `🌱` | `🌱` |

## Font Installation

### Automatic Installation
The `setup.sh` script automatically installs JetBrains Mono Nerd Font:
```bash
./setup.sh
```

### Manual Installation

**macOS (with Homebrew):**
```bash
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font
```

**Ubuntu/Debian:**
```bash
mkdir -p ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
unzip JetBrainsMono.zip -d ~/.local/share/fonts
fc-cache -fv ~/.local/share/fonts
```

**Arch Linux:**
```bash
sudo pacman -S ttf-jetbrains-mono-nerd
```

### Terminal Configuration
After installing the font:
1. **Restart your terminal application**
2. **Set terminal font to "JetBrains Mono Nerd Font"**
3. **Set font size to 12-14pt for best readability**

## Troubleshooting

### Seeing weird characters or boxes?
- **Install Nerd Font**: Run `./setup.sh` or manually install JetBrains Mono Nerd Font
- **Configure Terminal**: Set your terminal font to "JetBrains Mono Nerd Font"
- **Restart Terminal**: Font changes require terminal restart

### Oh My Posh not working at all?
- Check if it's installed: `which oh-my-posh`
- The ZSH config will fallback to a simple colored prompt if Oh My Posh is missing
- Run `./setup.sh` to install all dependencies

### VMware/Virtual Machine Issues?
- Ensure Nerd Font is installed in the VM (not just host)
- Configure the VM's terminal emulator font settings
- Some VM terminal emulators may need specific font configuration

## Color Scheme

Both configurations use the **Catppuccin Mocha** color palette:
- Beautiful, consistent colors across all prompt segments
- Easy on the eyes for long coding sessions
- Matches popular editor themes
