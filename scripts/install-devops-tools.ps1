# DevOps Tools Installation Script for Windows (PowerShell)
# Supports Windows with Chocolatey, Scoop, or Winget
# Usage: .\install-devops-tools.ps1 [-Mode minimal|full|cloud] [-PackageManager choco|scoop|winget]

param(
    [ValidateSet("minimal", "full", "cloud")]
    [string]$Mode = "minimal",
    
    [ValidateSet("choco", "scoop", "winget", "auto")]
    [string]$PackageManager = "auto"
)

# Colors for output
$RED = "Red"
$GREEN = "Green" 
$YELLOW = "Yellow"
$BLUE = "Cyan"

function Write-Status {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor $BLUE
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor $GREEN
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor $YELLOW
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor $RED
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-Command {
    param([string]$Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

function Install-PackageManager {
    Write-Status "Setting up package manager..."
    
    if ($PackageManager -eq "auto") {
        if (Test-Command "winget") {
            $script:PackageManager = "winget"
            Write-Status "Using Windows Package Manager (winget)"
        }
        elseif (Test-Command "choco") {
            $script:PackageManager = "choco"
            Write-Status "Using Chocolatey"
        }
        elseif (Test-Command "scoop") {
            $script:PackageManager = "scoop"
            Write-Status "Using Scoop"
        }
        else {
            Write-Status "Installing Chocolatey..."
            Set-ExecutionPolicy Bypass -Scope Process -Force
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
            Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
            $script:PackageManager = "choco"
        }
    }
    else {
        $script:PackageManager = $PackageManager
    }
}

function Install-Package {
    param(
        [string]$PackageName,
        [string]$ChocoName = $PackageName,
        [string]$ScoopName = $PackageName,
        [string]$WingetName = $PackageName
    )
    
    switch ($script:PackageManager) {
        "choco" {
            if (Test-Command $PackageName) {
                Write-Success "$PackageName already installed"
                return
            }
            Write-Status "Installing $PackageName via Chocolatey..."
            choco install $ChocoName -y
        }
        "scoop" {
            if (Test-Command $PackageName) {
                Write-Success "$PackageName already installed"
                return
            }
            Write-Status "Installing $PackageName via Scoop..."
            scoop install $ScoopName
        }
        "winget" {
            if (Test-Command $PackageName) {
                Write-Success "$PackageName already installed"
                return
            }
            Write-Status "Installing $PackageName via Winget..."
            winget install $WingetName
        }
    }
}

function Install-Docker {
    Write-Status "Installing Docker..."
    
    switch ($script:PackageManager) {
        "choco" {
            choco install docker-desktop -y
        }
        "scoop" {
            scoop bucket add extras
            scoop install docker
        }
        "winget" {
            winget install Docker.DockerDesktop
        }
    }
    
    Write-Warning "Docker Desktop requires a restart to complete installation"
}

function Install-Kubernetes {
    Write-Status "Installing Kubernetes tools..."
    
    # kubectl
    Install-Package -PackageName "kubectl" -ChocoName "kubernetes-cli" -ScoopName "kubectl" -WingetName "Kubernetes.kubectl"
    
    # helm
    Install-Package -PackageName "helm" -ChocoName "kubernetes-helm" -ScoopName "helm" -WingetName "Helm.Helm"
    
    if ($Mode -ne "minimal") {
        # k9s
        Install-Package -PackageName "k9s" -ChocoName "k9s" -ScoopName "k9s" -WingetName "k9s"
        
        # kubectx (Windows version)
        if ($script:PackageManager -eq "choco") {
            choco install kubectx-ps -y
        }
    }
}

function Install-Terraform {
    Write-Status "Installing Terraform..."
    Install-Package -PackageName "terraform" -ChocoName "terraform" -ScoopName "terraform" -WingetName "Hashicorp.Terraform"
    
    # tflint
    Install-Package -PackageName "tflint" -ChocoName "tflint" -ScoopName "tflint" -WingetName "tflint"
}

function Install-Linters {
    Write-Status "Installing linters and formatters..."
    
    # hadolint
    Install-Package -PackageName "hadolint" -ChocoName "hadolint" -ScoopName "hadolint" -WingetName "hadolint"
    
    # jq
    Install-Package -PackageName "jq" -ChocoName "jq" -ScoopName "jq" -WingetName "jqlang.jq"
    
    # yamllint and ansible-lint via uv
    if (Test-Command "uv") {
        Write-Status "Installing Python linters via uv..."
        uv tool install yamllint
        uv tool install ansible-lint
    }
    elseif (Test-Command "python") {
        Write-Status "Installing uv for Python package management..."
        python -m pip install --user uv
        uv tool install yamllint
        uv tool install ansible-lint
    }
    else {
        Write-Warning "Python not found. Installing Python and uv..."
        Install-Package -PackageName "python" -ChocoName "python" -ScoopName "python" -WingetName "Python.Python.3.12"
        python -m pip install --user uv
        uv tool install yamllint
        uv tool install ansible-lint
    }
}

function Install-Ansible {
    Write-Status "Installing Ansible..."
    
    if (Test-Command "uv") {
        uv tool install ansible
    }
    elseif (Test-Command "python") {
        Write-Status "Installing uv for Ansible..."
        python -m pip install --user uv
        uv tool install ansible
    }
    else {
        Write-Warning "Python required for Ansible. Installing Python and uv first..."
        Install-Package -PackageName "python" -ChocoName "python" -ScoopName "python" -WingetName "Python.Python.3.12"
        python -m pip install --user uv
        uv tool install ansible
    }
}

function Install-HashiCorpTools {
    Write-Status "Installing HashiCorp tools..."
    
    # Vault
    Install-Package -PackageName "vault" -ChocoName "vault" -ScoopName "vault" -WingetName "Hashicorp.Vault"
    
    # Consul
    Install-Package -PackageName "consul" -ChocoName "consul" -ScoopName "consul" -WingetName "Hashicorp.Consul"
    
    # Nomad
    Install-Package -PackageName "nomad" -ChocoName "nomad" -ScoopName "nomad" -WingetName "Hashicorp.Nomad"
}

function Install-GitTools {
    Write-Status "Installing Git and CI/CD tools..."
    
    # Git (usually pre-installed)
    Install-Package -PackageName "git" -ChocoName "git" -ScoopName "git" -WingetName "Git.Git"
    
    # GitHub CLI
    Install-Package -PackageName "gh" -ChocoName "gh" -ScoopName "gh" -WingetName "GitHub.cli"
    
    # GitLab CLI
    if ($script:PackageManager -eq "scoop") {
        scoop install glab
    }
    elseif ($script:PackageManager -eq "choco") {
        choco install glab -y
    }
}

function Install-CloudTools {
    Write-Status "Installing cloud provider tools..."
    
    # AWS CLI
    Install-Package -PackageName "aws" -ChocoName "awscli" -ScoopName "aws" -WingetName "Amazon.AWSCLI"
    
    # Azure CLI
    Install-Package -PackageName "az" -ChocoName "azure-cli" -ScoopName "azure-cli" -WingetName "Microsoft.AzureCLI"
    
    # Google Cloud SDK
    switch ($script:PackageManager) {
        "choco" {
            choco install gcloudsdk -y
        }
        "scoop" {
            scoop bucket add extras
            scoop install gcloud
        }
        "winget" {
            winget install Google.CloudSDK
        }
    }
}

function Install-MonitoringTools {
    Write-Status "Installing monitoring tools..."
    
    # Note: Prometheus and Grafana on Windows are typically run via Docker
    Write-Status "For Prometheus and Grafana on Windows, consider using Docker containers"
    Write-Status "Example: docker run -p 9090:9090 prom/prometheus"
    Write-Status "Example: docker run -p 3000:3000 grafana/grafana"
}

function Show-PostInstallInstructions {
    Write-Success "Installation complete!"
    Write-Status ""
    Write-Status "Next steps:"
    Write-Status "1. Restart PowerShell/Terminal"
    Write-Status "2. If Docker was installed, restart your computer"
    Write-Status "3. Open Neovim and run ':Lazy sync'"
    Write-Status "4. Run ':Mason' to install language servers"
    Write-Status "5. Test with a Dockerfile, terraform file, or kubernetes manifest"
    Write-Status ""
    
    if ($Mode -eq "cloud") {
        Write-Status "Cloud CLI authentication:"
        Write-Status "- AWS: aws configure"
        Write-Status "- Azure: az login"
        Write-Status "- GCP: gcloud auth login"
    }
}

# Main execution
function Main {
    Write-Status "Starting DevOps tools installation in $Mode mode..."
    Write-Status "Package manager preference: $PackageManager"
    
    if (-not (Test-Administrator)) {
        Write-Warning "Running without administrator privileges. Some installations may fail."
        Write-Status "Consider running PowerShell as Administrator for best results."
    }
    
    Install-PackageManager
    
    # Essential tools (all modes)
    Install-Docker
    Install-Kubernetes  
    Install-Terraform
    Install-Linters
    Install-Ansible
    Install-GitTools
    
    # Additional tools for full and cloud modes
    if ($Mode -eq "full" -or $Mode -eq "cloud") {
        Install-HashiCorpTools
        Install-MonitoringTools
    }
    
    # Cloud tools only for cloud mode
    if ($Mode -eq "cloud") {
        Install-CloudTools
    }
    
    Show-PostInstallInstructions
}

# Help function
function Show-Help {
    Write-Host @"
DevOps Tools Installation Script for Windows

Usage: .\install-devops-tools.ps1 [OPTIONS]

OPTIONS:
    -Mode <minimal|full|cloud>     Installation mode (default: minimal)
    -PackageManager <choco|scoop|winget|auto>  Package manager to use (default: auto)

MODES:
    minimal: Docker, Kubernetes, Terraform, essential linters
    full:    Everything in minimal + monitoring, HashiCorp tools, utilities
    cloud:   Everything in full + AWS/Azure/GCP CLIs

PACKAGE MANAGERS:
    choco:   Chocolatey (requires admin)
    scoop:   Scoop (user-level installs)
    winget:  Windows Package Manager
    auto:    Auto-detect available package manager

EXAMPLES:
    .\install-devops-tools.ps1
    .\install-devops-tools.ps1 -Mode full
    .\install-devops-tools.ps1 -Mode cloud -PackageManager choco
"@
}

# Check for help parameter
if ($args -contains "-h" -or $args -contains "--help" -or $args -contains "/?" -or $args -contains "help") {
    Show-Help
    exit 0
}

# Run main function
try {
    Main
}
catch {
    Write-Error "An error occurred: $_"
    Write-Status "Try running the script as Administrator or check your internet connection"
    exit 1
}