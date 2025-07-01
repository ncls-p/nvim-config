#!/usr/bin/env bash
# DevOps Tools Installation Script for Neovim Configuration
# Supports macOS, Ubuntu/Debian, and other Linux distributions
# Usage: ./install-devops-tools.sh [--minimal|--full|--cloud]

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Installation mode
MODE="minimal"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --minimal)
            MODE="minimal"
            shift
            ;;
        --full)
            MODE="full"
            shift
            ;;
        --cloud)
            MODE="cloud"
            shift
            ;;
        --help|-h)
            cat << EOF
DevOps Tools Installation Script

Usage: $0 [OPTIONS]

OPTIONS:
    --minimal    Install essential tools only (default)
    --full       Install all DevOps tools
    --cloud      Install cloud provider tools
    --help       Show this help message

MODES:
    minimal: Docker, Kubernetes, Terraform, essential linters
    full:    Everything in minimal + monitoring, HashiCorp tools, utilities
    cloud:   Everything in full + AWS/Azure/GCP CLIs
EOF
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

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

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ -f /etc/debian_version ]]; then
        OS="debian"
    elif [[ -f /etc/redhat-release ]]; then
        OS="redhat"
    elif [[ -f /etc/arch-release ]]; then
        OS="arch"
    else
        OS="unknown"
    fi
    print_status "Detected OS: $OS"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install package managers
install_package_managers() {
    case $OS in
        macos)
            if ! command_exists brew; then
                print_status "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            ;;
        debian)
            print_status "Updating package lists..."
            sudo apt-get update
            ;;
        redhat)
            print_status "Updating package lists..."
            if command_exists dnf; then
                sudo dnf update -y
            else
                sudo yum update -y
            fi
            ;;
        arch)
            print_status "Updating package lists..."
            sudo pacman -Sy
            ;;
    esac

    # Install pip if not present
    if ! command_exists pip && ! command_exists pip3; then
        print_status "Installing pip..."
        case $OS in
            macos)
                brew install python
                ;;
            debian)
                sudo apt-get install -y python3-pip
                ;;
            redhat)
                if command_exists dnf; then
                    sudo dnf install -y python3-pip
                else
                    sudo yum install -y python3-pip
                fi
                ;;
            arch)
                sudo pacman -S python-pip
                ;;
        esac
    fi
}

# Install Docker
install_docker() {
    if command_exists docker; then
        print_success "Docker already installed"
        return
    fi

    print_status "Installing Docker..."
    case $OS in
        macos)
            if command_exists brew; then
                brew install --cask docker
            else
                print_warning "Please install Docker Desktop manually from docker.com"
            fi
            ;;
        debian)
            # Install Docker using official repository
            sudo apt-get install -y ca-certificates curl gnupg lsb-release
            sudo mkdir -p /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            sudo usermod -aG docker $USER
            ;;
        redhat)
            if command_exists dnf; then
                sudo dnf install -y docker docker-compose
            else
                sudo yum install -y docker docker-compose
            fi
            sudo systemctl enable --now docker
            sudo usermod -aG docker $USER
            ;;
        arch)
            sudo pacman -S docker docker-compose
            sudo systemctl enable --now docker
            sudo usermod -aG docker $USER
            ;;
    esac
}

# Install Kubernetes tools
install_kubernetes() {
    print_status "Installing Kubernetes tools..."
    
    case $OS in
        macos)
            brew install kubectl helm
            if [[ "$MODE" != "minimal" ]]; then
                brew install k9s kubectx
            fi
            ;;
        debian)
            # kubectl
            curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
            sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
            rm kubectl
            
            # helm
            curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
            sudo apt-get update
            sudo apt-get install -y helm
            ;;
        redhat)
            # kubectl
            cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
            if command_exists dnf; then
                sudo dnf install -y kubectl
            else
                sudo yum install -y kubectl
            fi
            
            # helm
            curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
            ;;
        arch)
            sudo pacman -S kubectl helm
            ;;
    esac
}

# Install Terraform
install_terraform() {
    if command_exists terraform; then
        print_success "Terraform already installed"
        return
    fi

    print_status "Installing Terraform..."
    case $OS in
        macos)
            brew tap hashicorp/tap
            brew install hashicorp/tap/terraform
            ;;
        debian)
            wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
            echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
            sudo apt-get update
            sudo apt-get install -y terraform
            ;;
        redhat)
            sudo yum install -y yum-utils
            sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
            if command_exists dnf; then
                sudo dnf install -y terraform
            else
                sudo yum install -y terraform
            fi
            ;;
        arch)
            sudo pacman -S terraform
            ;;
    esac
}

# Install linters and formatters
install_linters() {
    print_status "Installing linters and formatters..."
    
    case $OS in
        macos)
            brew install hadolint tflint yamllint shellcheck shfmt jq
            ;;
        debian)
            sudo apt-get install -y shellcheck jq
            # hadolint
            wget -O /tmp/hadolint https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64
            sudo install /tmp/hadolint /usr/local/bin/hadolint
            # tflint
            curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
            ;;
        redhat)
            if command_exists dnf; then
                sudo dnf install -y ShellCheck jq
            else
                sudo yum install -y ShellCheck jq
            fi
            # Install hadolint and tflint similar to debian
            wget -O /tmp/hadolint https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64
            sudo install /tmp/hadolint /usr/local/bin/hadolint
            curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
            ;;
        arch)
            sudo pacman -S shellcheck jq
            # hadolint from AUR
            if command_exists yay; then
                yay -S hadolint-bin tflint-bin
            fi
            ;;
    esac

    # Python linters - use uv for modern Python package management
    if command_exists uv; then
        print_status "Installing Python tools via uv..."
        uv tool install yamllint
        uv tool install ansible-lint
    else
        print_status "Installing uv for Python package management..."
        case $OS in
            macos)
                brew install uv
                uv tool install yamllint
                uv tool install ansible-lint
                ;;
            debian)
                curl -LsSf https://astral.sh/uv/install.sh | sh
                export PATH="$HOME/.cargo/bin:$PATH"
                uv tool install yamllint
                uv tool install ansible-lint
                ;;
            redhat)
                curl -LsSf https://astral.sh/uv/install.sh | sh
                export PATH="$HOME/.cargo/bin:$PATH"
                uv tool install yamllint
                uv tool install ansible-lint
                ;;
            arch)
                curl -LsSf https://astral.sh/uv/install.sh | sh
                export PATH="$HOME/.cargo/bin:$PATH"
                uv tool install yamllint
                uv tool install ansible-lint
                ;;
            *)
                # Fallback to pip with proper flags
                local pip_cmd="pip3"
                if ! command_exists pip3 && command_exists pip; then
                    pip_cmd="pip"
                fi
                
                if ! $pip_cmd install --user yamllint ansible-lint 2>/dev/null; then
                    print_warning "Using --break-system-packages flag for pip install"
                    $pip_cmd install --break-system-packages --user yamllint ansible-lint
                fi
                ;;
        esac
    fi
}

# Install Ansible
install_ansible() {
    if command_exists ansible; then
        print_success "Ansible already installed"
        return
    fi

    print_status "Installing Ansible..."
    case $OS in
        macos)
            if command_exists uv; then
                uv tool install ansible
            else
                brew install ansible
            fi
            ;;
        debian)
            # Try uv first, fallback to apt
            if command_exists uv; then
                uv tool install ansible
            else
                sudo apt-get install -y ansible
            fi
            ;;
        redhat)
            if command_exists uv; then
                uv tool install ansible
            elif command_exists dnf; then
                sudo dnf install -y ansible
            else
                sudo yum install -y ansible
            fi
            ;;
        arch)
            if command_exists uv; then
                uv tool install ansible
            else
                sudo pacman -S ansible
            fi
            ;;
    esac
}

# Install HashiCorp tools (full mode)
install_hashicorp_tools() {
    print_status "Installing HashiCorp tools..."
    case $OS in
        macos)
            brew install vault consul nomad
            ;;
        debian)
            sudo apt-get install -y vault consul nomad
            ;;
        redhat)
            if command_exists dnf; then
                sudo dnf install -y vault consul nomad
            else
                sudo yum install -y vault consul nomad
            fi
            ;;
        arch)
            if command_exists yay; then
                yay -S vault consul nomad
            fi
            ;;
    esac
}

# Install monitoring tools (full mode)
install_monitoring() {
    print_status "Installing monitoring tools..."
    case $OS in
        macos)
            brew install prometheus grafana
            ;;
        debian)
            sudo apt-get install -y prometheus grafana
            ;;
        redhat)
            if command_exists dnf; then
                sudo dnf install -y prometheus grafana
            else
                sudo yum install -y prometheus grafana
            fi
            ;;
        arch)
            sudo pacman -S prometheus grafana
            ;;
    esac
}

# Install cloud tools (cloud mode)
install_cloud_tools() {
    print_status "Installing cloud provider tools..."
    case $OS in
        macos)
            brew install awscli azure-cli google-cloud-sdk
            ;;
        debian)
            # AWS CLI
            curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
            unzip awscliv2.zip
            sudo ./aws/install
            rm -rf aws awscliv2.zip
            
            # Azure CLI
            curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
            
            # Google Cloud SDK
            curl https://sdk.cloud.google.com | bash
            ;;
        redhat)
            # Similar to debian but using yum/dnf for what's available
            curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
            unzip awscliv2.zip
            sudo ./aws/install
            rm -rf aws awscliv2.zip
            ;;
        arch)
            if command_exists yay; then
                yay -S aws-cli-v2 azure-cli google-cloud-sdk
            fi
            ;;
    esac
}

# Install Git tools
install_git_tools() {
    print_status "Installing Git and CI/CD tools..."
    case $OS in
        macos)
            brew install gh glab
            ;;
        debian)
            # GitHub CLI
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            sudo apt-get update
            sudo apt-get install -y gh
            ;;
        redhat)
            if command_exists dnf; then
                sudo dnf install -y gh
            else
                sudo yum install -y gh
            fi
            ;;
        arch)
            sudo pacman -S github-cli
            ;;
    esac
}

# Main installation function
main() {
    print_status "Starting DevOps tools installation in $MODE mode..."
    
    detect_os
    install_package_managers
    
    # Essential tools (all modes)
    install_docker
    install_kubernetes
    install_terraform
    install_linters
    install_ansible
    install_git_tools
    
    # Additional tools for full and cloud modes
    if [[ "$MODE" == "full" || "$MODE" == "cloud" ]]; then
        install_hashicorp_tools
        install_monitoring
    fi
    
    # Cloud tools only for cloud mode
    if [[ "$MODE" == "cloud" ]]; then
        install_cloud_tools
    fi
    
    print_success "Installation complete!"
    print_status "Please restart your terminal or run 'source ~/.bashrc' (or ~/.zshrc)"
    
    if [[ "$OS" == "debian" || "$OS" == "redhat" || "$OS" == "arch" ]]; then
        print_warning "You may need to log out and log back in for Docker group permissions to take effect"
    fi
    
    print_status "Next steps:"
    echo "1. Open Neovim and run ':Lazy sync'"
    echo "2. Run ':Mason' to install language servers"
    echo "3. Test with a Dockerfile, terraform file, or kubernetes manifest"
}

# Run main function
main "$@"