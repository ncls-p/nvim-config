#!/usr/bin/env bash

# Modern Neovim Configuration Installer
# Cross-platform setup script for 2025

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
BACKUP_DIR="${NVIM_CONFIG_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
REPO_URL="https://github.com/ncls-p/nvim-config"

# Utility functions
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "macos" ;;
        Linux*) 
            if command_exists apt-get; then
                echo "ubuntu"
            elif command_exists pacman; then
                echo "arch"
            elif command_exists dnf; then
                echo "fedora"
            else
                echo "linux"
            fi
            ;;
        CYGWIN*|MINGW*|MSYS*) echo "windows" ;;
        *) echo "unknown" ;;
    esac
}

check_requirements() {
    local missing_deps=()
    
    print_info "Checking requirements..."
    
    # Check Neovim version
    if command_exists nvim; then
        local nvim_version
        nvim_version=$(nvim --version | head -n1 | grep -oE 'v[0-9]+\.[0-9]+' | sed 's/v//')
        local major minor
        major=$(echo "$nvim_version" | cut -d. -f1)
        minor=$(echo "$nvim_version" | cut -d. -f2)
        
        if [ "$major" -lt 0 ] || ([ "$major" -eq 0 ] && [ "$minor" -lt 10 ]); then
            print_warning "Neovim version $nvim_version found, but ≥0.10 required"
            missing_deps+=("neovim")
        else
            print_success "Neovim $nvim_version ✓"
        fi
    else
        missing_deps+=("neovim")
    fi
    
    # Check other dependencies
    local deps=("git" "rg" "node" "python3")
    for dep in "${deps[@]}"; do
        if command_exists "$dep"; then
            case "$dep" in
                "rg") print_success "ripgrep ✓" ;;
                "node") 
                    local node_version
                    node_version=$(node --version | sed 's/v//')
                    print_success "Node.js $node_version ✓"
                    ;;
                *) print_success "$dep ✓" ;;
            esac
        else
            missing_deps+=("$dep")
        fi
    done
    
    # Optional dependencies
    if command_exists fd; then
        print_success "fd ✓"
    else
        print_warning "fd not found (optional but recommended)"
    fi
    
    return "${#missing_deps[@]}"
}

install_dependencies() {
    local os
    os=$(detect_os)
    
    print_info "Installing dependencies for $os..."
    
    case "$os" in
        macos)
            if ! command_exists brew; then
                print_error "Homebrew not found. Please install it first:"
                echo "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
                exit 1
            fi
            
            print_info "Installing with Homebrew..."
            brew update
            brew install neovim ripgrep fd node python@3.12 git
            
            # Install Nerd Font
            brew tap homebrew/cask-fonts
            brew install --cask font-jetbrains-mono-nerd-font
            ;;
            
        ubuntu)
            print_info "Installing with apt..."
            sudo apt update
            
            # Add Neovim PPA for latest version
            sudo add-apt-repository ppa:neovim-ppa/unstable -y
            sudo apt update
            
            sudo apt install -y neovim ripgrep fd-find nodejs npm python3 python3-pip git curl
            
            # Create fd symlink if needed
            if [ ! -f /usr/bin/fd ] && [ -f /usr/bin/fdfind ]; then
                sudo ln -sf /usr/bin/fdfind /usr/bin/fd
            fi
            ;;
            
        arch)
            print_info "Installing with pacman..."
            sudo pacman -Syu --noconfirm
            sudo pacman -S --noconfirm neovim ripgrep fd nodejs npm python python-pip git
            
            # Install Nerd Font with yay if available
            if command_exists yay; then
                yay -S --noconfirm ttf-jetbrains-mono-nerd
            else
                print_warning "yay not found. Please install a Nerd Font manually."
            fi
            ;;
            
        fedora)
            print_info "Installing with dnf..."
            sudo dnf update -y
            sudo dnf install -y neovim ripgrep fd-find nodejs npm python3 python3-pip git
            ;;
            
        linux)
            print_warning "Generic Linux detected. Please install dependencies manually:"
            echo "- Neovim ≥0.10"
            echo "- ripgrep, fd, nodejs, python3, git"
            read -p "Continue with installation? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                exit 1
            fi
            ;;
            
        windows)
            print_info "Windows detected. Using Scoop or manual installation..."
            if command_exists scoop; then
                scoop install neovim ripgrep fd nodejs python git
            elif command_exists winget; then
                winget install Neovim.Neovim BurntSushi.ripgrep sharkdp.fd OpenJS.NodeJS Python.Python.3 Git.Git
            else
                print_error "Please install Scoop or use winget to install dependencies:"
                echo "Dependencies: neovim, ripgrep, fd, nodejs, python, git"
                exit 1
            fi
            ;;
            
        *)
            print_error "Unsupported operating system: $(uname -s)"
            print_info "Please install dependencies manually and re-run this script"
            exit 1
            ;;
    esac
    
    print_success "Dependencies installed!"
}

backup_existing_config() {
    if [ -d "$NVIM_CONFIG_DIR" ]; then
        print_warning "Existing Neovim configuration found"
        print_info "Creating backup at: $BACKUP_DIR"
        mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
        print_success "Backup created successfully"
    fi
}

clone_configuration() {
    print_info "Cloning Neovim configuration..."
    git clone "$REPO_URL" "$NVIM_CONFIG_DIR"
    print_success "Configuration cloned successfully"
}

setup_global_tools() {
    print_info "Installing global tools..."
    
    # Install global npm packages for LSP/formatters
    if command_exists npm; then
        npm install -g @vtsls/language-server prettier eslint
    fi
    
    # Install Python packages
    if command_exists pip3; then
        pip3 install --user ruff basedpyright
    elif command_exists pip; then
        pip install --user ruff basedpyright
    fi
    
    print_success "Global tools installed"
}

post_install_info() {
    print_success "🎉 Installation completed successfully!"
    echo
    print_info "Next steps:"
    echo "1. Start Neovim: nvim"
    echo "2. Wait for plugins to install automatically"
    echo "3. Press <Space> to see available keybindings"
    echo "4. Run :checkhealth to verify everything works"
    echo
    print_info "Key shortcuts:"
    echo "• <Space>ff - Find files"
    echo "• <Space>fg - Live grep"
    echo "• <Space>e - File explorer"
    echo "• <Space>ai - AI chat"
    echo "• <Space>uc - Random theme"
    echo
    print_info "Documentation: README.md in $NVIM_CONFIG_DIR"
    
    if [ -d "$BACKUP_DIR" ]; then
        echo
        print_warning "Your old configuration was backed up to:"
        echo "$BACKUP_DIR"
    fi
}

main() {
    echo "🚀 Modern Neovim Configuration Installer (2025)"
    echo "================================================"
    echo
    
    # Detect OS
    local os
    os=$(detect_os)
    print_info "Detected OS: $os"
    echo
    
    # Check if we should install dependencies
    if ! check_requirements; then
        print_warning "Missing dependencies detected"
        read -p "Install missing dependencies? (Y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            install_dependencies
        else
            print_error "Dependencies required for proper functionality"
            exit 1
        fi
    fi
    
    # Backup existing configuration
    backup_existing_config
    
    # Clone new configuration
    clone_configuration
    
    # Install global tools
    setup_global_tools
    
    # Show post-install information
    post_install_info
}

# Run main function
main "$@"
