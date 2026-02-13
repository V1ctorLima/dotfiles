#!/bin/bash
# Claude Code configuration installer
# This script sets up symlinks from ~/.claude to ~/dotfiles/.claude

set -e

DOTFILES_CLAUDE="$HOME/dotfiles/.claude"
CLAUDE_DIR="$HOME/.claude"

echo "🎨 Setting up Claude Code visual configuration..."
echo ""

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

# 1. Symlink Claude settings.json
echo "1️⃣  Claude Settings:"
create_symlink "$DOTFILES_CLAUDE/settings.json" "$CLAUDE_DIR/settings.json"

# 2. Symlink keybindings.json if it exists in dotfiles
if [ -f "$DOTFILES_CLAUDE/keybindings.json" ]; then
    create_symlink "$DOTFILES_CLAUDE/keybindings.json" "$CLAUDE_DIR/keybindings.json"
fi

# 3. Create settings.local.json if it doesn't exist
if [ ! -f "$CLAUDE_DIR/settings.local.json" ]; then
    echo '{}' > "$CLAUDE_DIR/settings.local.json"
    echo "  ✓ settings.local.json created (for machine-specific overrides)"
else
    echo "  ✓ settings.local.json already exists"
fi

echo ""

# 4. Setup ccstatusline visual configuration
echo "2️⃣  Status Line Visual Config:"
if [ -f "$HOME/dotfiles/.config/ccstatusline/settings.json" ]; then
    mkdir -p "$HOME/.config/ccstatusline"
    create_symlink "$HOME/dotfiles/.config/ccstatusline/settings.json" "$HOME/.config/ccstatusline/settings.json"
else
    echo "  ⊘ No ccstatusline config in dotfiles"
fi

echo ""
echo "✅ Claude Code configuration installed!"
echo ""
echo "📝 What's synced:"
echo "  ✓ Claude settings.json       → Permissions, plugins, status line command"
echo "  ✓ ccstatusline settings.json → Visual appearance (colors, layout, theme)"
echo ""
echo "💡 Machine-specific:"
echo "  • settings.local.json → Local overrides (not synced)"
echo ""
echo "🔄 To sync changes from other machines:"
echo "  cd ~/dotfiles && git pull"
echo ""
