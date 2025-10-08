#!/bin/bash

# Interactive welcome script for dotfiles testing
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                    ${BOLD}🧪 Interactive Dotfiles Testing Environment${NC}${CYAN}                    ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Welcome to your dotfiles testing container!${NC}"
echo ""
echo -e "${YELLOW}📁 Current status:${NC}"
echo -e "   • You're in: ${BOLD}$(pwd)${NC}"
echo -e "   • User: ${BOLD}$(whoami)${NC}"
echo -e "   • Home: ${BOLD}$HOME${NC}"
echo -e "   • Dotfiles are ${BOLD}NOT YET DEPLOYED${NC}"
echo ""
echo -e "${GREEN}🚀 Quick Start Commands:${NC}"
echo ""
echo -e "${BOLD}1. Quick setup (installs dependencies + deploys):${NC}"
echo -e "   ${CYAN}./setup.sh${NC}"
echo ""
echo -e "${BOLD}2. Manual deploy dotfiles:${NC}"
echo -e "   ${CYAN}stow --verbose --adopt --target=\"\$HOME\" .${NC}"
echo ""
echo -e "${BOLD}3. Run comprehensive tests:${NC}"
echo -e "   ${CYAN}./test-dotfiles.sh${NC}"
echo ""
echo -e "${BOLD}4. Check what's deployed:${NC}"
echo -e "   ${CYAN}ls -la \$HOME${NC}"
echo -e "   ${CYAN}ls -la \$HOME/.config${NC}"
echo ""
echo -e "${BOLD}5. Test ZSH with your config:${NC}"
echo -e "   ${CYAN}zsh${NC}  (after deploying dotfiles)"
echo ""
echo -e "${BOLD}6. Remove dotfiles:${NC}"
echo -e "   ${CYAN}stow --verbose --target=\"\$HOME\" -D .${NC}"
echo ""
echo -e "${GREEN}🛠️  Available Modern Tools:${NC}"
echo -e "   • ${BOLD}oh-my-posh${NC} $(oh-my-posh --version 2>/dev/null || echo 'not found')"
echo -e "   • ${BOLD}mise${NC} $(mise --version 2>/dev/null || echo 'not found')"
echo -e "   • ${BOLD}atuin${NC} $(atuin --version 2>/dev/null || echo 'not found')"
echo -e "   • ${BOLD}fzf${NC} $(fzf --version 2>/dev/null || echo 'not found')"
echo ""
echo -e "${YELLOW}💡 Pro Tips:${NC}"
echo -e "   • Use ${CYAN}tree \$HOME/.config${NC} to see the config structure"
echo -e "   • Use ${CYAN}find \$HOME -type l${NC} to see all symlinks"
echo -e "   • Use ${CYAN}exit${NC} to leave the container"
echo ""
echo -e "${BLUE}Ready to test your dotfiles! 🎉${NC}"
echo ""
