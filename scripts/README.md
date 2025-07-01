# DevOps Tools Installation Scripts

Automated installation scripts for all DevOps tools required by the Neovim configuration.

## 🚀 Quick Start

### macOS/Linux
```bash
# Make script executable
chmod +x scripts/install-devops-tools.sh

# Install minimal tools (recommended)
./scripts/install-devops-tools.sh

# Install all tools
./scripts/install-devops-tools.sh --full

# Install with cloud provider tools
./scripts/install-devops-tools.sh --cloud
```

### Windows (PowerShell as Administrator)
```powershell
# Install minimal tools
.\scripts\install-devops-tools.ps1

# Install all tools
.\scripts\install-devops-tools.ps1 -Mode full

# Install with cloud provider tools  
.\scripts\install-devops-tools.ps1 -Mode cloud

# Use specific package manager
.\scripts\install-devops-tools.ps1 -Mode full -PackageManager choco
```

## 📦 Installation Modes

### Minimal (Default)
Essential DevOps tools for basic functionality:
- **Container**: Docker, Docker Compose
- **Orchestration**: kubectl, Helm
- **IaC**: Terraform, TFLint
- **Config Management**: Ansible
- **Linting**: hadolint, yamllint, ansible-lint
- **Utilities**: jq, shellcheck, shfmt
- **Git**: GitHub CLI

### Full
Everything in minimal plus:
- **HashiCorp**: Vault, Consul, Nomad
- **Monitoring**: Prometheus, Grafana (local dev)
- **Kubernetes**: k9s, kubectx/kubens
- **Additional utilities**

### Cloud
Everything in full plus:
- **AWS**: AWS CLI
- **Azure**: Azure CLI  
- **GCP**: Google Cloud SDK

## 🛠️ Tools Installed by Category

### Container & Orchestration
| Tool | Minimal | Full | Cloud | Description |
|------|---------|------|-------|-------------|
| Docker | ✅ | ✅ | ✅ | Container runtime |
| Docker Compose | ✅ | ✅ | ✅ | Multi-container apps |
| kubectl | ✅ | ✅ | ✅ | Kubernetes CLI |
| Helm | ✅ | ✅ | ✅ | Kubernetes package manager |
| k9s | ❌ | ✅ | ✅ | Kubernetes cluster management |
| kubectx/kubens | ❌ | ✅ | ✅ | Context/namespace switching |

### Infrastructure as Code
| Tool | Minimal | Full | Cloud | Description |
|------|---------|------|-------|-------------|
| Terraform | ✅ | ✅ | ✅ | Infrastructure provisioning |
| TFLint | ✅ | ✅ | ✅ | Terraform linter |
| Vault | ❌ | ✅ | ✅ | Secrets management |
| Consul | ❌ | ✅ | ✅ | Service discovery |
| Nomad | ❌ | ✅ | ✅ | Workload orchestration |

### Configuration Management
| Tool | Minimal | Full | Cloud | Description |
|------|---------|------|-------|-------------|
| Ansible | ✅ | ✅ | ✅ | Configuration management |
| ansible-lint | ✅ | ✅ | ✅ | Ansible linter |
| uv | ✅ | ✅ | ✅ | Modern Python package manager |

### Linting & Formatting
| Tool | Minimal | Full | Cloud | Description |
|------|---------|------|-------|-------------|
| hadolint | ✅ | ✅ | ✅ | Dockerfile linter |
| yamllint | ✅ | ✅ | ✅ | YAML linter |
| shellcheck | ✅ | ✅ | ✅ | Shell script linter |
| shfmt | ✅ | ✅ | ✅ | Shell formatter |

### Monitoring & Observability
| Tool | Minimal | Full | Cloud | Description |
|------|---------|------|-------|-------------|
| Prometheus | ❌ | ✅ | ✅ | Metrics collection |
| Grafana | ❌ | ✅ | ✅ | Metrics visualization |

### Cloud Provider Tools
| Tool | Minimal | Full | Cloud | Description |
|------|---------|------|-------|-------------|
| AWS CLI | ❌ | ❌ | ✅ | Amazon Web Services |
| Azure CLI | ❌ | ❌ | ✅ | Microsoft Azure |
| Google Cloud SDK | ❌ | ❌ | ✅ | Google Cloud Platform |

### Development Tools
| Tool | Minimal | Full | Cloud | Description |
|------|---------|------|-------|-------------|
| jq | ✅ | ✅ | ✅ | JSON processor |
| GitHub CLI | ✅ | ✅ | ✅ | GitHub integration |
| GitLab CLI | ❌ | ✅ | ✅ | GitLab integration |

## 🖥️ Platform Support

### Linux Distributions
- **Ubuntu/Debian**: Full support via apt
- **RHEL/CentOS/Fedora**: Full support via yum/dnf
- **Arch Linux**: Full support via pacman
- **Other distributions**: Manual installation fallbacks

### macOS
- **Homebrew**: Preferred package manager
- **Direct downloads**: Fallback for unavailable packages

### Windows
- **Chocolatey**: Full-featured package manager (requires admin)
- **Scoop**: User-level package manager
- **Winget**: Windows Package Manager (modern Windows)
- **Auto-detection**: Script chooses best available option

## 🔧 Post-Installation Setup

After running the installation script:

1. **Restart your terminal/shell**
2. **For Docker on Linux**: Log out and back in for group permissions
3. **Open Neovim**:
   ```vim
   :Lazy sync
   :Mason
   ```
4. **Install LSP servers** (auto-configured in Mason):
   - dockerfile-language-server
   - docker-compose-language-service
   - terraform-ls
   - ansible-language-server
   - helm-ls
   - yaml-language-server

5. **Test your setup**:
   ```bash
   # Create test files to verify LSP functionality
   touch Dockerfile
   touch docker-compose.yml  
   touch main.tf
   touch playbook.yml
   ```

## 🔍 Verification Commands

Test your installation:

```bash
# Core tools
docker --version
kubectl version --client
helm version
terraform --version
ansible --version

# Linters
hadolint --version
yamllint --version
tflint --version

# Utilities
jq --version
gh --version
```

## 🐛 Troubleshooting

### Common Issues

1. **Permission denied errors**:
   - Linux: Run with sudo or check user groups
   - Windows: Run PowerShell as Administrator

2. **Docker group permissions** (Linux):
   ```bash
   sudo usermod -aG docker $USER
   # Log out and back in
   ```

3. **PATH not updated**:
   ```bash
   # Reload shell configuration
   source ~/.bashrc  # or ~/.zshrc
   ```

4. **Package manager not found**:
   - Linux: Install curl, wget first
   - Windows: Install Chocolatey manually
   - macOS: Install Homebrew manually

5. **Python package issues**:
   ```bash
   # Install uv for better Python package management
   brew install uv  # macOS
   curl -LsSf https://astral.sh/uv/install.sh | sh  # Linux
   
   # Install Python tools via uv
   uv tool install yamllint
   uv tool install ansible-lint
   uv tool install ansible
   ```

### Manual Installation

If automatic installation fails, refer to official documentation:
- [Docker](https://docs.docker.com/get-docker/)
- [Kubernetes tools](https://kubernetes.io/docs/tasks/tools/)
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/)

## 🔄 Updates

To update tools:

```bash
# macOS
brew update && brew upgrade

# Ubuntu/Debian  
sudo apt update && sudo apt upgrade

# Windows (Chocolatey)
choco upgrade all
```

## 📝 Customization

You can modify the scripts to:
- Add/remove specific tools
- Change installation sources
- Customize configuration paths
- Add company-specific tools

The scripts are designed to be modular and easy to extend.

## 🤝 Contributing

To add support for new tools or platforms:
1. Update the appropriate script section
2. Test on target platform
3. Update this documentation
4. Submit a pull request

## 📚 Additional Resources

- [Neovim DevOps Configuration Guide](../CLAUDE.md)
- [Mason LSP Server List](https://github.com/williamboman/mason.nvim/blob/main/PACKAGES.md)
- [DevOps Tool Comparison](https://landscape.cncf.io/)