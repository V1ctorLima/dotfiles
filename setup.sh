#!/bin/bash

# Dotfiles setup script - ensures all dependencies are installed before stow deployment
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
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

print_header() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                           ${BOLD}🚀 Dotfiles Setup Script${NC}${CYAN}                           ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get >/dev/null 2>&1; then
            OS="ubuntu"
        elif command -v pacman >/dev/null 2>&1; then
            OS="arch"
        elif command -v dnf >/dev/null 2>&1; then
            OS="fedora"
        else
            OS="linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
    else
        OS="unknown"
    fi
    print_status "Detected OS: $OS"
}

# Install package manager if needed
install_package_manager() {
    case $OS in
        "macos")
            if ! command -v brew >/dev/null 2>&1; then
                print_status "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                print_success "Homebrew installed"
            else
                print_success "Homebrew already installed"
            fi
            ;;
        "ubuntu")
            print_success "APT package manager available"
            ;;
        "arch")
            print_success "Pacman package manager available"
            ;;
        "fedora")
            print_success "DNF package manager available"
            ;;
        *)
            print_warning "Unknown package manager for OS: $OS"
            ;;
    esac
}

# Install essential packages
install_essential_packages() {
    print_status "Installing essential packages..."
    
    case $OS in
        "macos")
            brew install stow git vim zsh curl wget tree
            ;;
        "ubuntu")
            sudo apt-get update
            sudo apt-get install -y stow git vim zsh curl wget tree build-essential
            ;;
        "arch")
            sudo pacman -S --noconfirm stow git vim zsh curl wget tree base-devel
            ;;
        "fedora")
            sudo dnf install -y stow git vim zsh curl wget tree
            ;;
        *)
            print_warning "Please install stow, git, vim, zsh, curl, wget, tree manually"
            return 1
            ;;
    esac
    
    print_success "Essential packages installed"
}

# Configure ZSH as default shell
configure_zsh() {
    print_status "Configuring ZSH as default shell..."
    
    # Check if ZSH is installed
    if ! command -v zsh >/dev/null 2>&1; then
        print_error "ZSH is not installed. Please run the setup again."
        return 1
    fi
    
    # Get ZSH path
    ZSH_PATH=$(which zsh)
    print_status "ZSH found at: $ZSH_PATH"
    
    # Check if ZSH is in /etc/shells
    if ! grep -q "$ZSH_PATH" /etc/shells 2>/dev/null; then
        print_status "Adding ZSH to /etc/shells..."
        echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
        print_success "ZSH added to /etc/shells"
    else
        print_success "ZSH already in /etc/shells"
    fi
    
    # Check current shell
    CURRENT_SHELL=$(echo $SHELL)
    if [ "$CURRENT_SHELL" != "$ZSH_PATH" ]; then
        print_status "Current shell: $CURRENT_SHELL"
        print_status "Changing default shell to ZSH..."
        
        # Change shell
        if chsh -s "$ZSH_PATH"; then
            print_success "Default shell changed to ZSH"
            print_warning "Please log out and log back in for the shell change to take effect"
        else
            print_warning "Failed to change default shell. You can manually run: chsh -s $ZSH_PATH"
        fi
    else
        print_success "ZSH is already the default shell"
    fi
}

# Install modern CLI tools
install_modern_tools() {
    print_status "Installing modern CLI tools..."
        
    # Mise
    if ! command -v mise >/dev/null 2>&1; then
        print_status "Installing Mise..."
        curl https://mise.run | sh
        export PATH="$HOME/.local/bin:$PATH"
        print_success "Mise installed"
    else
        print_success "Mise already installed"
    fi
    
    # Atuin
    if ! command -v atuin >/dev/null 2>&1; then
        print_status "Installing Atuin..."
        curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
        export PATH="$HOME/.atuin/bin:$PATH"
        print_success "Atuin installed"
    else
        print_success "Atuin already installed"
    fi
    
    # Oh My Posh
    if ! command -v oh-my-posh >/dev/null 2>&1; then
        print_status "Installing Oh My Posh..."
        case $OS in
            "macos")
                brew install jandedobbeleer/oh-my-posh/oh-my-posh
                ;;
            "ubuntu"|"linux")
                curl -s https://ohmyposh.dev/install.sh | bash -s
                ;;
            "arch")
                sudo pacman -S --noconfirm oh-my-posh
                ;;
            *)
                curl -s https://ohmyposh.dev/install.sh | bash -s
                ;;
        esac
        print_success "Oh My Posh installed"
    else
        print_success "Oh My Posh already installed"
    fi
    
    # FZF
    if ! command -v fzf >/dev/null 2>&1; then
        print_status "Installing FZF..."
        case $OS in
            "macos")
                brew install fzf
                ;;
            "ubuntu")
                sudo apt-get install -y fzf
                ;;
            "arch")
                sudo pacman -S --noconfirm fzf
                ;;
            "fedora")
                sudo dnf install -y fzf
                ;;
            *)
                git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
                ~/.fzf/install --all
                ;;
        esac
        print_success "FZF installed"
    else
        print_success "FZF already installed"
    fi
    
    # Granted (AWS role assumption)
    if ! command -v granted >/dev/null 2>&1; then
        print_status "Installing Granted..."
        case $OS in
            "macos")
                brew tap common-fate/granted
                brew install granted
                ;;
            "ubuntu"|"linux")
                curl -OL https://releases.commonfate.io/granted/v0.20.3/granted_0.20.3_linux_x86_64.tar.gz
                sudo tar -zxvf ./granted_0.20.3_linux_x86_64.tar.gz -C /usr/local/bin/
                rm granted_0.20.3_linux_x86_64.tar.gz
                ;;
            "arch")
                yay -S granted
                ;;
            *)
                print_status "Please install Granted manually: https://docs.commonfate.io/granted/getting-started"
                ;;
        esac
        print_success "Granted installed"
    else
        print_success "Granted already installed"
    fi
    
    # ZSH plugins
    case $OS in
        "ubuntu")
            sudo apt-get install -y zsh-autosuggestions zsh-syntax-highlighting
            ;;
        "arch")
            sudo pacman -S --noconfirm zsh-autosuggestions zsh-syntax-highlighting
            ;;
        "fedora")
            sudo dnf install -y zsh-autosuggestions zsh-syntax-highlighting
            ;;
        "macos")
            brew install zsh-autosuggestions zsh-syntax-highlighting
            ;;
    esac
}

# Install Nerd Fonts for proper Oh My Posh rendering
install_nerd_fonts() {
    print_status "Installing Nerd Fonts for proper terminal rendering..."
    
    case $OS in
        "macos")
            # Use Homebrew to install Nerd Fonts
            if command -v brew >/dev/null 2>&1; then
                print_status "Installing JetBrains Mono Nerd Font via Homebrew..."
                brew tap homebrew/cask-fonts 2>/dev/null || true
                brew install --cask font-jetbrains-mono-nerd-font 2>/dev/null || true
                print_success "Nerd Font installed via Homebrew"
            else
                print_warning "Homebrew not found, skipping font installation"
            fi
            ;;
        "ubuntu"|"linux")
            # Download and install Nerd Fonts manually
            FONT_DIR="$HOME/.local/share/fonts"
            mkdir -p "$FONT_DIR"
            
            if [ ! -f "$FONT_DIR/JetBrainsMonoNerdFont-Regular.ttf" ]; then
                print_status "Downloading JetBrains Mono Nerd Font..."
                FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip"
                TEMP_DIR=$(mktemp -d)
                
                if command -v wget >/dev/null 2>&1; then
                    wget -q "$FONT_URL" -O "$TEMP_DIR/JetBrainsMono.zip"
                elif command -v curl >/dev/null 2>&1; then
                    curl -sL "$FONT_URL" -o "$TEMP_DIR/JetBrainsMono.zip"
                else
                    print_error "Neither wget nor curl found. Cannot download fonts."
                    return 1
                fi
                
                if command -v unzip >/dev/null 2>&1; then
                    unzip -q "$TEMP_DIR/JetBrainsMono.zip" -d "$TEMP_DIR"
                    cp "$TEMP_DIR"/*.ttf "$FONT_DIR/" 2>/dev/null || true
                    
                    # Update font cache
                    if command -v fc-cache >/dev/null 2>&1; then
                        fc-cache -fv "$FONT_DIR" >/dev/null 2>&1
                    fi
                    
                    rm -rf "$TEMP_DIR"
                    print_success "JetBrains Mono Nerd Font installed"
                else
                    print_error "unzip not found. Cannot extract fonts."
                    rm -rf "$TEMP_DIR"
                    return 1
                fi
            else
                print_success "JetBrains Mono Nerd Font already installed"
            fi
            ;;
        "arch")
            # Use pacman to install Nerd Fonts
            print_status "Installing Nerd Fonts via pacman..."
            sudo pacman -S --noconfirm ttf-jetbrains-mono-nerd 2>/dev/null || true
            print_success "Nerd Font installed via pacman"
            ;;
        "fedora")
            # Use dnf to install Nerd Fonts
            print_status "Installing Nerd Fonts via dnf..."
            sudo dnf install -y jetbrains-mono-fonts-all 2>/dev/null || true
            print_success "Nerd Font installed via dnf"
            ;;
        *)
            print_warning "Unknown OS. Please manually install a Nerd Font from https://www.nerdfonts.com/"
            print_status "Recommended: JetBrains Mono Nerd Font"
            ;;
    esac
    
    print_status "📝 Important: You may need to:"
    print_status "   1. Restart your terminal application"
    print_status "   2. Set your terminal font to 'JetBrains Mono Nerd Font'"
    print_status "   3. Ensure font size is readable (12-14pt recommended)"
}

# Create required directories
create_directories() {
    print_status "Creating required directories..."
    
    mkdir -p "$HOME/.cache/zsh"
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/.local/share"
    mkdir -p "$HOME/Projects"
    
    print_success "Required directories created"
}

# Deploy dotfiles with stow
deploy_dotfiles() {
    print_status "Deploying dotfiles with stow..."
    
    if ! command -v stow >/dev/null 2>&1; then
        print_error "Stow is not installed. Please run the setup again."
        exit 1
    fi
    
    # Backup existing files if they exist and are not symlinks
    backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
    dotfiles_to_backup=(".zshenv" ".config/zsh/.zshrc" ".config/git/config" ".config/vim/vimrc")
    
    for file in "${dotfiles_to_backup[@]}"; do
        if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
            print_warning "Backing up existing $file"
            mkdir -p "$backup_dir/$(dirname "$file")"
            cp "$HOME/$file" "$backup_dir/$file" 2>/dev/null || true
        fi
    done
    
    # Deploy with stow
    if stow --verbose --adopt --target="$HOME" .; then
        print_success "Dotfiles deployed successfully with stow"
    else
        print_error "Failed to deploy dotfiles with stow"
        exit 1
    fi
}

# Test deployment
test_deployment() {
    print_status "Testing deployment..."
    
    # Test symlinks
    expected_links=(".zshenv" ".config/zsh" ".config/git" ".config/vim")
    all_good=true
    
    for link in "${expected_links[@]}"; do
        if [ -L "$HOME/$link" ]; then
            print_success "✓ $link is properly linked"
        else
            print_error "✗ $link is not a symlink"
            all_good=false
        fi
    done
    
    # Test ZSH config
    if [ -f "$HOME/.zshenv" ]; then
        if zsh -c "source $HOME/.zshenv && echo 'ZSH config test passed'" >/dev/null 2>&1; then
            print_success "✓ ZSH configuration loads without errors"
        else
            print_warning "⚠ ZSH configuration has issues"
        fi
    fi
    
    # Test git config
    if [ -f "$HOME/.config/git/config" ]; then
        if git config --file "$HOME/.config/git/config" --list >/dev/null 2>&1; then
            print_success "✓ Git configuration is valid"
        else
            print_warning "⚠ Git configuration has issues"
        fi
    fi
    
    if [ "$all_good" = true ]; then
        print_success "🎉 All tests passed!"
    else
        print_warning "Some tests failed, but dotfiles are deployed"
    fi
}

# Main execution
main() {
    print_header
    
    print_status "Starting dotfiles setup..."
    echo ""
    
    detect_os
    echo ""
    
    install_package_manager
    echo ""
    
    install_essential_packages
    echo ""
    
    configure_zsh
    echo ""
    
    install_modern_tools
    echo ""
    
    install_nerd_fonts
    echo ""
    
    create_directories
    echo ""
    
    deploy_dotfiles
    echo ""
    
    test_deployment
    echo ""
    
    print_success "🎉 Setup complete!"
    echo ""
    print_status "Next steps:"
    echo "  1. Open a new terminal or restart your shell"
    echo "  2. If ZSH isn't your default shell yet, log out and log back in"
    echo "  3. Run 'zsh' to start using your new configuration immediately"
    echo "  4. Enjoy your modern shell setup with all the tools!"
    echo ""
    print_status "Installed tools:"
    echo "  • ZSH (configured as default shell)"
    echo "  • Oh My Posh (modern prompt engine)"
    echo "  • Mise (runtime version manager)"
    echo "  • Atuin (shell history)"
    echo "  • FZF (fuzzy finder)"
    echo "  • Granted (AWS role assumption)"
    echo "  • ZSH plugins (autosuggestions, syntax highlighting)"
    echo ""
    print_status "To remove dotfiles: stow --verbose --target=\"\$HOME\" -D ."
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Please don't run this script as root"
    exit 1
fi

# Run main function
main "$@"
