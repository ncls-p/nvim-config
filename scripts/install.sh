#!/bin/bash

set -e

NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
OS=$(uname -s)
ARCH=$(uname -m)

log() {
    echo "📦 $1"
}

error() {
    echo "❌ Error: $1" >&2
    exit 1
}

check_command() {
    command -v "$1" >/dev/null 2>&1
}

detect_os() {
    case "$OS" in
        Darwin*) echo "macos" ;;
        Linux*) echo "linux" ;;
        MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
        *) error "Unsupported OS: $OS" ;;
    esac
}

detect_package_manager() {
    if check_command brew; then
        echo "brew"
    elif check_command apt; then
        echo "apt"
    elif check_command dnf; then
        echo "dnf"
    elif check_command pacman; then
        echo "pacman"
    elif check_command zypper; then
        echo "zypper"
    elif check_command choco; then
        echo "choco"
    else
        error "No supported package manager found"
    fi
}

install_package() {
    local pkg="$1"
    local pm="$2"
    
    case "$pm" in
        brew) brew install "$pkg" ;;
        apt) sudo apt-get install -y "$pkg" ;;
        dnf) sudo dnf install -y "$pkg" ;;
        pacman) sudo pacman -S --noconfirm "$pkg" ;;
        zypper) sudo zypper install -y "$pkg" ;;
        choco) choco install "$pkg" -y ;;
        *) error "Unknown package manager: $pm" ;;
    esac
}

install_nodejs() {
    local pm="$1"
    
    if check_command node; then
        log "Node.js already installed: $(node --version)"
        return
    fi
    
    log "Installing Node.js..."
    case "$pm" in
        brew) install_package "node" "$pm" ;;
        apt) 
            curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
            install_package "nodejs" "$pm"
            ;;
        dnf) install_package "nodejs npm" "$pm" ;;
        pacman) install_package "nodejs npm" "$pm" ;;
        zypper) install_package "nodejs npm" "$pm" ;;
        choco) install_package "nodejs" "$pm" ;;
    esac
}

install_python() {
    local pm="$1"
    
    if check_command python3; then
        log "Python3 already installed: $(python3 --version)"
        return
    fi
    
    log "Installing Python3..."
    case "$pm" in
        brew) install_package "python3" "$pm" ;;
        apt) install_package "python3 python3-pip" "$pm" ;;
        dnf) install_package "python3 python3-pip" "$pm" ;;
        pacman) install_package "python python-pip" "$pm" ;;
        zypper) install_package "python3 python3-pip" "$pm" ;;
        choco) install_package "python3" "$pm" ;;
    esac
}

install_tools() {
    local pm="$1"
    local tools=()
    
    case "$pm" in
        brew)
            tools=(
                "git" "curl" "wget" "unzip" "tar" "fzf" "ripgrep" "fd"
                "tree-sitter" "swiftformat" "xmllint" "shellcheck"
                "stylua" "prettier" "black" "isort" "flake8" "mypy"
            )
            ;;
        apt)
            tools=(
                "git" "curl" "wget" "unzip" "tar" "fzf" "ripgrep" "fd-find"
                "libxml2-utils" "shellcheck" "python3-black" "python3-isort"
                "python3-flake8" "python3-mypy"
            )
            ;;
        dnf)
            tools=(
                "git" "curl" "wget" "unzip" "tar" "fzf" "ripgrep" "fd-find"
                "libxml2" "ShellCheck" "python3-black" "python3-isort"
                "python3-flake8" "python3-mypy"
            )
            ;;
        pacman)
            tools=(
                "git" "curl" "wget" "unzip" "tar" "fzf" "ripgrep" "fd"
                "libxml2" "shellcheck" "python-black" "python-isort"
                "flake8" "mypy"
            )
            ;;
        zypper)
            tools=(
                "git" "curl" "wget" "unzip" "tar" "fzf" "ripgrep" "fd"
                "libxml2-tools" "ShellCheck" "python3-black" "python3-isort"
                "python3-flake8" "python3-mypy"
            )
            ;;
        choco)
            tools=(
                "git" "curl" "wget" "unzip" "tar" "fzf" "ripgrep" "fd"
                "shellcheck"
            )
            ;;
    esac
    
    log "Installing development tools..."
    for tool in "${tools[@]}"; do
        if ! check_command "${tool%% *}"; then
            log "Installing $tool"
            install_package "$tool" "$pm" 2>/dev/null || log "Warning: Failed to install $tool"
        fi
    done
}

install_npm_tools() {
    if ! check_command npm; then
        log "npm not available, skipping npm tools"
        return
    fi
    
    local npm_tools=(
        "neovim" "tree-sitter-cli" "@fsouza/prettierd" "eslint_d"
        "typescript-language-server" "vscode-langservers-extracted"
        "yaml-language-server" "dockerfile-language-server-nodejs"
    )
    
    log "Installing npm tools globally..."
    for tool in "${npm_tools[@]}"; do
        if ! npm list -g "$tool" >/dev/null 2>&1; then
            log "Installing $tool"
            npm install -g "$tool" 2>/dev/null || log "Warning: Failed to install $tool"
        fi
    done
}

install_python_tools() {
    if ! check_command pip3; then
        log "pip3 not available, skipping Python tools"
        return
    fi
    
    local pip_tools=(
        "pynvim" "python-lsp-server" "pyright" "ruff" "autopep8"
        "yapf" "debugpy"
    )
    
    log "Installing Python tools..."
    for tool in "${pip_tools[@]}"; do
        log "Installing $tool"
        pip3 install --user "$tool" 2>/dev/null || log "Warning: Failed to install $tool"
    done
}

setup_nvim_config() {
    log "Setting up Neovim configuration..."
    
    if [ ! -d "$NVIM_CONFIG_DIR" ]; then
        error "Neovim config directory not found: $NVIM_CONFIG_DIR"
    fi
    
    cd "$NVIM_CONFIG_DIR"
    
    if [ -f "lazy-lock.json" ]; then
        log "Backing up lazy-lock.json"
        cp "lazy-lock.json" "lazy-lock.json.backup"
    fi
    
    log "Configuration ready at: $NVIM_CONFIG_DIR"
}

create_desktop_entry() {
    local detected_os="$1"
    
    if [ "$detected_os" = "linux" ] && [ -d "$HOME/.local/share/applications" ]; then
        log "Creating desktop entry..."
        cat > "$HOME/.local/share/applications/nvim.desktop" << EOF
[Desktop Entry]
Name=Neovim
Comment=Edit text files
Exec=nvim %F
Terminal=true
Type=Application
Icon=nvim
Categories=Utility;TextEditor;Development;
MimeType=text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
EOF
        log "Desktop entry created"
    fi
}

main() {
    log "🚀 Neovim Configuration Installer"
    log "================================"
    
    local detected_os
    detected_os=$(detect_os)
    log "Detected OS: $detected_os"
    
    local pm
    pm=$(detect_package_manager)
    log "Package manager: $pm"
    
    log "Installing prerequisites..."
    install_nodejs "$pm"
    install_python "$pm"
    install_tools "$pm"
    
    log "Installing language servers and tools..."
    install_npm_tools
    install_python_tools
    
    setup_nvim_config
    create_desktop_entry "$detected_os"
    
    log "✅ Installation complete!"
    log ""
    log "Next steps:"
    log "1. Run 'nvim' to start Neovim"
    log "2. Plugins will auto-install on first run"
    log "3. Run ':checkhealth' to verify installation"
    log "4. Run ':Mason' to manage LSP servers"
    log ""
    log "Enjoy your optimized Neovim setup! 🎉"
}

if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi