#!/bin/bash
# Claude Code configuration installer
# This script sets up symlinks from ~/.claude to ~/dotfiles/.claude

set -e

DOTFILES_CLAUDE="$HOME/dotfiles/.claude"
CLAUDE_DIR="$HOME/.claude"

echo "🎨 Setting up Claude Code visual configuration..."

# Create ~/.claude directory if it doesn't exist
mkdir -p "$CLAUDE_DIR"

# Function to safely create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    local filename=$(basename "$source")

    if [ -L "$target" ]; then
        echo "  ✓ $filename already symlinked"
    elif [ -f "$target" ] || [ -d "$target" ]; then
        echo "  ⚠️  $filename exists, backing up to ${target}.backup"
        mv "$target" "${target}.backup"
        ln -s "$source" "$target"
        echo "  ✓ $filename symlinked (backup created)"
    else
        ln -s "$source" "$target"
        echo "  ✓ $filename symlinked"
    fi
}

# Symlink settings.json
create_symlink "$DOTFILES_CLAUDE/settings.json" "$CLAUDE_DIR/settings.json"

# Symlink keybindings.json if it exists in dotfiles
if [ -f "$DOTFILES_CLAUDE/keybindings.json" ]; then
    create_symlink "$DOTFILES_CLAUDE/keybindings.json" "$CLAUDE_DIR/keybindings.json"
fi

# Create settings.local.json if it doesn't exist
if [ ! -f "$CLAUDE_DIR/settings.local.json" ]; then
    echo '{}' > "$CLAUDE_DIR/settings.local.json"
    echo "  ✓ settings.local.json created (for machine-specific overrides)"
else
    echo "  ✓ settings.local.json already exists"
fi

echo ""
echo "✅ Claude Code configuration installed!"
echo ""
echo "📝 Notes:"
echo "  - Use settings.json for synced configuration"
echo "  - Use settings.local.json for machine-specific settings"
echo "  - Status line: $DOTFILES_CLAUDE/settings.json"
echo ""
echo "🔄 To sync changes across machines:"
echo "  cd ~/dotfiles && git pull"
echo ""
