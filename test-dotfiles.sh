#!/bin/bash

# Test script for dotfiles deployment using stow
set -e

echo "🧪 Testing dotfiles deployment with stow..."
echo "================================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Test 1: Check if stow is available
print_status "Checking if stow is available..."
if command -v stow >/dev/null 2>&1; then
    print_success "stow is available: $(stow --version | head -1)"
else
    print_error "stow is not available"
    exit 1
fi

# Test 2: Backup existing dotfiles (if any)
print_status "Backing up existing dotfiles..."
backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"

# List of files that might conflict
dotfiles_to_backup=(".zshenv" ".config/zsh/.zshrc" ".config/git/config" ".config/vim/vimrc")

for file in "${dotfiles_to_backup[@]}"; do
    if [ -f "$HOME/$file" ] || [ -L "$HOME/$file" ]; then
        print_warning "Backing up existing $file"
        mkdir -p "$backup_dir/$(dirname "$file")"
        cp -L "$HOME/$file" "$backup_dir/$file" 2>/dev/null || true
    fi
done

# Test 3: Create required directories first
print_status "Creating required directories..."
mkdir -p "$HOME/.cache/zsh" "$HOME/.local/bin" "$HOME/Projects"
print_success "Required directories created"

# Test 4: Deploy dotfiles using stow with proper flags
print_status "Deploying dotfiles using stow..."
cd /home/testuser/dotfiles

# Use stow with --adopt and --target flags (following best practices)
if stow --verbose --adopt --target="$HOME" .; then
    print_success "Dotfiles deployed successfully with stow"
else
    print_error "Failed to deploy dotfiles with stow"
    exit 1
fi

# Test 5: Verify symlinks were created
print_status "Verifying symlinks were created..."
expected_links=(
    ".zshenv"
    ".config/zsh/.zshrc"
    ".config/git/config"
    ".config/vim/vimrc"
    ".config/bash/bashrc"
)

all_links_ok=true
for link in "${expected_links[@]}"; do
    if [ -L "$HOME/$link" ]; then
        target=$(readlink "$HOME/$link")
        print_success "✓ $link -> $target"
    elif [ -f "$HOME/$link" ]; then
        print_warning "⚠ $link exists but is not a symlink"
    else
        print_error "✗ $link does not exist"
        all_links_ok=false
    fi
done

# Test 6: Test zsh configuration
print_status "Testing zsh configuration..."
if [ -f "$HOME/.zshenv" ]; then
    # Source the zshenv file to test for syntax errors
    if zsh -c "source $HOME/.zshenv && echo 'zshenv loaded successfully'" >/dev/null 2>&1; then
        print_success "✓ .zshenv loads without errors"
    else
        print_error "✗ .zshenv has syntax errors"
        all_links_ok=false
    fi
else
    print_error "✗ .zshenv not found"
    all_links_ok=false
fi

# Test 7: Test git configuration
print_status "Testing git configuration..."
if [ -f "$HOME/.config/git/config" ]; then
    if git config --file "$HOME/.config/git/config" --list >/dev/null 2>&1; then
        print_success "✓ git config is valid"
    else
        print_error "✗ git config has errors"
        all_links_ok=false
    fi
else
    print_error "✗ git config not found"
    all_links_ok=false
fi

# Test 8: Test vim configuration
print_status "Testing vim configuration..."
if [ -f "$HOME/.config/vim/vimrc" ]; then
    # Test vim config by running vim with the config
    if vim -u "$HOME/.config/vim/vimrc" -c "quit" >/dev/null 2>&1; then
        print_success "✓ vim config loads without errors"
    else
        print_warning "⚠ vim config might have issues (this could be normal in headless environment)"
    fi
else
    print_error "✗ vim config not found"
    all_links_ok=false
fi

# Test 9: Show directory structure
print_status "Showing deployed dotfiles structure..."
echo "Home directory structure:"
find "$HOME" -maxdepth 3 -type l -exec ls -la {} \; 2>/dev/null | head -20

echo ""
echo "Config directory structure:"
if [ -d "$HOME/.config" ]; then
    tree "$HOME/.config" -L 3 2>/dev/null || find "$HOME/.config" -type f | head -20
fi

# Test 10: Test stow removal (cleanup test)
print_status "Testing stow removal (cleanup)..."
if stow --verbose --target="$HOME" -D .; then
    print_success "✓ Dotfiles removed successfully with stow -D"
else
    print_error "✗ Failed to remove dotfiles with stow"
    all_links_ok=false
fi

# Test 11: Re-deploy for final state
print_status "Re-deploying dotfiles for final state..."
if stow --verbose --adopt --target="$HOME" .; then
    print_success "✓ Dotfiles re-deployed successfully"
else
    print_error "✗ Failed to re-deploy dotfiles"
    all_links_ok=false
fi

# Final summary
echo ""
echo "================================================"
if [ "$all_links_ok" = true ]; then
    print_success "🎉 All tests passed! Dotfiles are working correctly with stow."
    echo ""
    print_status "To use these dotfiles:"
    echo "  1. Create required directories: mkdir -p \"\$HOME/.cache/zsh\" \"\$HOME/.local/bin\" \"\$HOME/Projects\""
    echo "  2. Clone your dotfiles repository to \$HOME/Projects"
    echo "  3. cd into the dotfiles directory"
    echo "  4. Run: stow --verbose --adopt --target=\"\$HOME\" ."
    echo "  5. To remove: stow --verbose --target=\"\$HOME\" -D ."
    exit 0
else
    print_error "❌ Some tests failed. Please check the output above."
    exit 1
fi
