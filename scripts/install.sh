#!/usr/bin/env bash
#
# Neovim configuration bootstrapper
# ---------------------------------
# Goals
#   • Works on Linux, macOS and Windows (Git-Bash / MSYS / Cygwin / WSL).
#   • Installs every dependency required by your current Neovim setup
#     (system packages, Node, Python, build tools, LSPs, etc.).
#   • Keeps everything in a single script – no extra platform files.
#
#   Usage:
#     bash scripts/install.sh
#
set -euo pipefail

NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
OS_UNAME="$(uname -s)"

###############################################################################
# Helpers
###############################################################################
log() { printf '📦 %s\n' "$1"; }
warn() { printf '⚠️  %s\n' "$1"; }
error() {
  printf '❌ Error: %s\n' "$1" >&2
  exit 1
}

check_command() { command -v "$1" >/dev/null 2>&1; }

###############################################################################
# Detect platform / package manager
###############################################################################
detect_os() {
  case "$OS_UNAME" in
  Darwin*) echo "macos" ;;
  Linux*) echo "linux" ;;
  MINGW* | MSYS* | CYGWIN*) echo "windows" ;;
  *) error "Unsupported OS: $OS_UNAME" ;;
  esac
}

detect_package_manager() {
  if check_command brew; then
    echo "brew"
  elif check_command apt-get; then
    echo "apt"
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
  elif check_command scoop; then
    echo "scoop"
  else error "No supported package manager found"; fi
}

###############################################################################
# Package installation
###############################################################################
install_packages() {
  local pm="$1"
  shift
  local pkgs=("$@")
  [ "${#pkgs[@]}" -eq 0 ] && return 0

  case "$pm" in
  brew) brew install "${pkgs[@]}" ;;
  apt) sudo apt-get update -y && sudo apt-get install -y "${pkgs[@]}" ;;
  dnf) sudo dnf install -y "${pkgs[@]}" ;;
  pacman) sudo pacman -Sy --noconfirm "${pkgs[@]}" ;;
  zypper) sudo zypper install -y "${pkgs[@]}" ;;
  choco) choco install -y "${pkgs[@]}" ;;
  scoop) scoop install "${pkgs[@]}" ;;
  *) error "Unknown package manager: $pm" ;;
  esac
}

###############################################################################
# Node.js
###############################################################################
install_nodejs() {
  local pm="$1"

  if check_command node; then
    log "Node.js already installed: $(node --version)"
    return
  fi
  log "Installing Node.js…"

  case "$pm" in
  brew) install_packages "$pm" node ;;
  apt)
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    install_packages "$pm" nodejs
    ;;
  dnf)
    curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
    install_packages "$pm" nodejs npm
    ;;
  pacman | zypper) install_packages "$pm" nodejs npm ;;
  choco | scoop) install_packages "$pm" nodejs-lts ;;
  *) error "Node.js: package manager $pm not supported" ;;
  esac
}

###############################################################################
# Python
###############################################################################
install_python() {
  local pm="$1"

  if check_command python3; then
    log "Python already installed: $(python3 --version)"
    return
  fi
  log "Installing Python 3…"

  case "$pm" in
  brew) install_packages "$pm" python@3 ;;
  apt) install_packages "$pm" python3 python3-pip ;;
  dnf) install_packages "$pm" python3 python3-pip ;;
  pacman) install_packages "$pm" python python-pip ;;
  zypper) install_packages "$pm" python3 python3-pip ;;
  choco | scoop) install_packages "$pm" python ;;
  *) error "Python: package manager $pm not supported" ;;
  esac
}

###############################################################################
# Development tools (compiler, build, linters…)
###############################################################################
install_tools() {
  local pm="$1"
  local tools=()

  case "$pm" in
  brew)
    tools=(git curl wget unzip tar fzf ripgrep fd cmake make gcc
      tree-sitter swiftformat xmllint shellcheck stylua
      prettier black isort flake8 mypy)
    ;;
  apt)
    tools=(git curl wget unzip tar fzf ripgrep fd-find cmake make gcc build-essential
      libxml2-utils shellcheck python3-black python3-isort
      python3-flake8 python3-mypy stylua)
    ;;
  dnf)
    tools=(git curl wget unzip tar fzf ripgrep fd-find cmake make gcc gcc-c++
      libxml2 ShellCheck python3-black python3-isort
      python3-flake8 python3-mypy stylua)
    ;;
  pacman)
    tools=(git curl wget unzip tar fzf ripgrep fd cmake make gcc
      libxml2 shellcheck python-black python-isort
      flake8 mypy stylua)
    ;;
  zypper)
    tools=(git curl wget unzip tar fzf ripgrep fd cmake make gcc
      libxml2-tools ShellCheck python3-black python3-isort
      python3-flake8 python3-mypy stylua)
    ;;
  choco | scoop)
    tools=(git curl wget unzip tar fzf ripgrep fd cmake make gcc shellcheck stylua)
    ;;
  esac

  log "Installing development tools…"
  install_packages "$pm" "${tools[@]}"

  # Ensure 'fd' binary exists on Debian/Ubuntu (fd-find provides 'fdfind')
  if [[ "$pm" == "apt" && ! -e /usr/local/bin/fd && -e /usr/bin/fdfind ]]; then
    sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd
    log "Created symlink /usr/local/bin/fd → /usr/bin/fdfind"
  fi
}

###############################################################################
# Global npm tools
###############################################################################
install_npm_tools() {
  if ! check_command npm; then
    warn "npm not available – skipping global npm tools"
    return
  fi

  local npm_tools=(
    neovim tree-sitter-cli @fsouza/prettierd eslint_d prettier
    typescript-language-server vscode-langservers-extracted
    yaml-language-server dockerfile-language-server-nodejs
  )

  log "Installing global npm tools…"
  for tool in "${npm_tools[@]}"; do
    if npm list -g --depth=0 "$tool" >/dev/null 2>&1; then
      continue
    fi
    log "  ↳ $tool"
    npm install -g --silent "$tool" || warn "Could not install $tool"
  done
}

###############################################################################
# Global pip tools
###############################################################################
install_python_tools() {
  if ! check_command pip3; then
    warn "pip3 not available – skipping Python tools"
    return
  fi

  local pip_tools=(
    pynvim python-lsp-server pyright ruff autopep8 yapf debugpy
  )

  log "Installing user-level Python tools…"
  pip3 install --user --upgrade "${pip_tools[@]}" ||
    warn "Some Python packages failed to install"
}

###############################################################################
# Sync Neovim configuration
###############################################################################
sync_nvim_config() {
  log "Syncing Neovim configuration…"

  local repo_root
  repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

  if [[ "$repo_root" != "$NVIM_CONFIG_DIR" ]]; then
    log "Copying config from $repo_root to $NVIM_CONFIG_DIR"
    mkdir -p "$NVIM_CONFIG_DIR"
    rsync -a --delete \
      --exclude '.git' \
      --exclude 'lazy-lock.json.backup' \
      "$repo_root/" "$NVIM_CONFIG_DIR/"
  fi

  cd "$NVIM_CONFIG_DIR"
  if [[ -f lazy-lock.json ]]; then
    cp lazy-lock.json lazy-lock.json.backup
    log "Backed up lazy-lock.json"
  fi
}

###############################################################################
# Clean obsolete scripts
###############################################################################
cleanup_scripts_dir() {
  local scripts_dir
  scripts_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  find "$scripts_dir" -maxdepth 1 -type f \
    ! -name 'install.sh' \
    \( -name '*.sh' -o -name '*.ps1' -o -name '*.bat' \) \
    -print -delete | while read -r deleted; do
    log "Removed obsolete script: $(basename "$deleted")"
  done
}

###############################################################################
# Desktop entry (Linux)
###############################################################################
create_desktop_entry() {
  local os="$1"
  if [[ "$os" == "linux" && -d "$HOME/.local/share/applications" ]]; then
    log "Creating desktop entry…"
    cat >"$HOME/.local/share/applications/nvim.desktop" <<EOF
[Desktop Entry]
Name=Neovim
Comment=Edit text files
Exec=nvim %F
Terminal=true
Type=Application
Icon=nvim
Categories=Utility;TextEditor;Development;
MimeType=text/plain;
EOF
  fi
}

###############################################################################
# Main
###############################################################################
main() {
  log "🚀 Neovim bootstrap script"
  log "=========================="

  local os pm
  os="$(detect_os)"
  pm="$(detect_package_manager)"
  log "Detected OS: $os"
  log "Package manager: $pm"

  install_nodejs "$pm"
  install_python "$pm"
  install_tools "$pm"
  install_npm_tools
  install_python_tools

  sync_nvim_config
  cleanup_scripts_dir
  create_desktop_entry "$os"

  log "✅ All done!"
  printf '\nNext steps:\n'
  printf ' • Run “nvim” to launch Neovim (plugins will be installed automatically).\n'
  printf ' • Inside Neovim, run :checkhealth to verify everything is OK.\n'
  printf ' • Use :Mason to manage additional LSP servers and tools.\n\n'
  printf 'Happy coding! ✨\n'
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
