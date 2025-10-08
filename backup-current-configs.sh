#!/bin/bash

# Backup script for current dotfiles before stow deployment
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔒 Backing up current configuration files...${NC}"

# Create timestamped backup directory
BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
echo -e "${GREEN}Created backup directory: $BACKUP_DIR${NC}"

# Files that might conflict (based on .gitignore allowlist)
POTENTIAL_CONFLICTS=(
    ".zshenv"
    ".config/aliases.bsd.sh"
    ".config/aliases.linux.sh"
    ".config/aliases.unix.sh"
    ".config/aliases.windows.sh"
    ".config/bash/bashrc"
    ".config/git/config"
    ".config/inputrc"
    ".config/oh-my-posh/chippuccin.toml"
    ".config/oh-my-posh/README.md"
    ".config/vim/vimrc"
    ".config/vim/colors/catppuccin_mocha.vim"
    ".config/zsh/.zshrc"
    ".config/zsh/functions.sh"
    ".gnupg/gpg-agent.conf"
)

# Backup existing files
BACKED_UP=0
for file in "${POTENTIAL_CONFLICTS[@]}"; do
    if [ -f "$HOME/$file" ] || [ -L "$HOME/$file" ]; then
        echo -e "${YELLOW}Backing up: $file${NC}"
        
        # Create directory structure in backup
        mkdir -p "$BACKUP_DIR/$(dirname "$file")"
        
        # Copy the file (preserving symlinks)
        cp -L "$HOME/$file" "$BACKUP_DIR/$file" 2>/dev/null || cp "$HOME/$file" "$BACKUP_DIR/$file"
        BACKED_UP=$((BACKED_UP + 1))
    fi
done

echo ""
if [ $BACKED_UP -gt 0 ]; then
    echo -e "${GREEN}✅ Backed up $BACKED_UP configuration files to:${NC}"
    echo -e "${BLUE}   $BACKUP_DIR${NC}"
    echo ""
    echo -e "${YELLOW}📝 To restore your original configs later:${NC}"
    echo -e "   cp -r $BACKUP_DIR/* $HOME/"
    echo ""
    echo -e "${GREEN}🚀 You can now safely run:${NC}"
    echo -e "   ${BLUE}stow --verbose --adopt . --target=\"\$HOME\"${NC}"
else
    echo -e "${GREEN}✅ No conflicting files found. Safe to deploy dotfiles!${NC}"
    echo -e "${GREEN}🚀 You can run:${NC}"
    echo -e "   ${BLUE}stow --verbose --adopt . --target=\"\$HOME\"${NC}"
fi

echo ""
echo -e "${YELLOW}💡 Pro tip: Use 'stow --simulate' first to preview changes${NC}"
