# Oh My Posh Configuration

This directory contains Oh My Posh prompt configurations for different environments.

## Files

### `chippuccin.toml`
- **Full-featured config** with Nerd Font icons
- **Best for**: Desktop terminals with proper font support
- **Requires**: Nerd Font installed (e.g., FiraCode Nerd Font, JetBrains Mono Nerd Font)

### `chippuccin-docker.toml`
- **Docker/Terminal-friendly** version without Nerd Font icons
- **Best for**: Docker containers, basic terminals, SSH sessions
- **Uses**: ASCII-safe characters only (`/`, `*`, `^`, `v`, `>`, etc.)

## Automatic Detection

The ZSH configuration automatically detects your environment:

```bash
# Docker containers or basic terminals
if [ -f /.dockerenv ] || [ "$CONTAINER" = "docker" ] || [ "$TERM" = "linux" ]; then
    # Uses chippuccin-docker.toml (no Nerd Font icons)
else
    # Uses chippuccin.toml (full Nerd Font icons)
fi
```

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

## Troubleshooting

### Seeing weird characters like `󰟀󰿟`?
- You're probably using a terminal without Nerd Font support
- The Docker-friendly config should auto-detect and fix this
- If not, manually use: `oh-my-posh init zsh --config ~/.config/oh-my-posh/chippuccin-docker.toml`

### Oh My Posh not working at all?
- Check if it's installed: `which oh-my-posh`
- The ZSH config will fallback to a simple colored prompt if Oh My Posh is missing

### Want to force a specific config?
```bash
# Force Docker-friendly config
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/chippuccin-docker.toml)"

# Force full Nerd Font config
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/chippuccin.toml)"
```

## Color Scheme

Both configurations use the **Catppuccin Mocha** color palette:
- Beautiful, consistent colors across all prompt segments
- Easy on the eyes for long coding sessions
- Matches popular editor themes
