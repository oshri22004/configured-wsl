#!/bin/bash

# WSL Configuration Script
# This script configures a complete DevOps/SRE/Developer environment in WSL2

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running in WSL
if ! grep -q Microsoft /proc/version 2>/dev/null; then
    log_error "This script must be run in WSL (Windows Subsystem for Linux)"
    exit 1
fi

log_info "Starting WSL configuration..."

# Configure Windows Terminal settings
log_info "Configuring Windows Terminal settings..."
WINDOWS_USERNAME=$(cmd.exe /C "echo %USERNAME%" 2>/dev/null | tr -d '\r')
SETTINGS_PATH="/mnt/c/Users/$WINDOWS_USERNAME/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"

if [ -f "settings.json" ]; then
    if cp settings.json "$SETTINGS_PATH" 2>/dev/null; then
        log_success "Windows Terminal settings applied"
    else
        log_warning "Could not apply Windows Terminal settings (file may be in use)"
    fi
else
    log_warning "settings.json not found"
fi

# Configure Oh My Zsh plugins and themes
log_info "Setting up Oh My Zsh themes and plugins..."

# Define the custom theme and plugin paths
POWERLEVEL10K_PATH="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
ZSH_AUTOSUGGESTIONS_PATH="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
ZSH_SYNTAX_HIGHLIGHTING_PATH="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
OHMYZSH_FULL_AUTOUPDATE_PATH="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/ohmyzsh-full-autoupdate"

# Clone powerlevel10k theme if it doesn't already exist
if [ ! -d "$POWERLEVEL10K_PATH" ]; then
    log_info "Installing PowerLevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$POWERLEVEL10K_PATH"
    log_success "PowerLevel10k theme installed"
else
    log_info "PowerLevel10k theme already exists, skipping"
fi

# Clone zsh-autosuggestions plugin if it doesn't already exist
if [ ! -d "$ZSH_AUTOSUGGESTIONS_PATH" ]; then
    log_info "Installing zsh-autosuggestions plugin..."
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_AUTOSUGGESTIONS_PATH"
    log_success "zsh-autosuggestions plugin installed"
else
    log_info "zsh-autosuggestions plugin already exists, skipping"
fi

# Clone zsh-syntax-highlighting plugin if it doesn't already exist
if [ ! -d "$ZSH_SYNTAX_HIGHLIGHTING_PATH" ]; then
    log_info "Installing zsh-syntax-highlighting plugin..."
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_HIGHLIGHTING_PATH"
    log_success "zsh-syntax-highlighting plugin installed"
else
    log_info "zsh-syntax-highlighting plugin already exists, skipping"
fi

# Clone OhMyZsh-full-autoupdate plugin if it doesn't already exist
if [ ! -d "$OHMYZSH_FULL_AUTOUPDATE_PATH" ]; then
    log_info "Installing OhMyZsh-full-autoupdate plugin..."
    git clone --depth=1 https://github.com/Pilaton/OhMyZsh-full-autoupdate.git "$OHMYZSH_FULL_AUTOUPDATE_PATH"
    log_success "OhMyZsh-full-autoupdate plugin installed"
else
    log_info "OhMyZsh-full-autoupdate plugin already exists, skipping"
fi

# Install Docker
log_info "Checking Docker installation..."
if ! command -v docker &> /dev/null; then
    log_info "Docker not found, installing..."

    # Update package index
    sudo apt-get update

    # Install required packages
    sudo apt-get install -y ca-certificates curl gnupg lsb-release

    # Add Docker's official GPG key
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    # Add the repository to Apt sources
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Update package index again
    sudo apt-get update

    # Install Docker Engine
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Start Docker service
    sudo systemctl start docker
    sudo systemctl enable docker

    # Add user to docker group
    sudo usermod -aG docker $USER

    # Set permissions on Docker socket
    sudo chmod 666 /var/run/docker.sock

    log_success "Docker installed successfully"
else
    log_info "Docker already installed, skipping"
fi

# Install system packages
log_info "Installing system packages..."
if [ ! -f package_list.txt ]; then
    log_error "package_list.txt not found"
    exit 1
fi

if sudo apt install -y $(cat package_list.txt | tr '\n' ' '); then
    log_success "System packages installed successfully"
else
    log_warning "Some system packages may have failed to install"
fi

# Install Homebrew
log_info "Checking Homebrew installation..."
if ! command -v brew &> /dev/null; then
    log_info "Homebrew not found, installing..."
    
    # Install Homebrew
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    
    log_success "Homebrew installed successfully"
else
    log_info "Homebrew already installed, skipping"
fi

# Install Homebrew dependencies
log_info "Installing Homebrew dependencies..."
sudo apt-get install -y build-essential

# Install GCC using Homebrew
log_info "Installing GCC via Homebrew..."
brew install gcc

# Install common-fate/granted
log_info "Installing Granted..."
brew tap common-fate/granted
brew install granted

# Install Homebrew packages
log_info "Installing Homebrew packages..."
if command -v brew &>/dev/null; then
    if [ -f my_brews.txt ]; then
        log_info "Installing packages from my_brews.txt..."
        while IFS= read -r package; do
            if [ -n "$package" ] && [[ ! "$package" =~ ^# ]]; then
                log_info "Installing $package..."
                if brew install "$package"; then
                    log_success "$package installed"
                else
                    log_warning "Failed to install $package"
                fi
            fi
        done < my_brews.txt
        log_success "Homebrew packages installation completed"
    else
        log_warning "my_brews.txt not found"
    fi
else
    log_error "Homebrew not found, skipping brew installations"
fi

# Configure Chrome browser integration
log_info "Configuring Chrome browser integration..."
chrome_path="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
if [ -f "$chrome_path" ]; then
    if [ ! -L "/usr/bin/google" ]; then
        sudo ln -sf "$chrome_path" /usr/bin/google
        log_success "Chrome browser integration configured"
    else
        log_info "Chrome browser integration already configured"
    fi
else
    log_warning "Chrome not found at $chrome_path, skipping browser integration"
fi

# Configure GPG and password store
log_info "Configuring GPG and password store..."
if ! gpg --list-keys | grep -q "devops"; then
    log_info "Generating GPG key for devops..."
    gpg --batch --passphrase '' --quick-gen-key devops default default
    GPG_KEY_ID=$(gpg --list-keys --with-colons | grep '^fpr' | awk -F: '{print $10}' | head -n 1)
    if [ -n "$GPG_KEY_ID" ]; then
        pass init "$GPG_KEY_ID"
        log_success "GPG key and password store configured"
    else
        log_error "Failed to get GPG key ID"
    fi
else
    log_info "GPG key for 'devops' already exists, skipping"
fi

# Install colorls
log_info "Installing colorls..."
if sudo apt install -y ruby-rubygems ruby-dev; then
    if gem install --user-install colorls; then
        log_success "colorls installed successfully"
    else
        log_warning "Failed to install colorls"
    fi
else
    log_warning "Failed to install Ruby dependencies for colorls"
fi 

# Final configuration setup
log_info "Applying final configuration..."

# Create granted directory and copy configuration
mkdir -p ~/.granted
if [ -f "config" ]; then
    cp config ~/.granted/config
    log_success "Granted configuration applied"
else
    log_warning "Granted config file not found"
fi

# Copy zsh configuration
if [ -f ".zshrc" ]; then
    cp .zshrc ~/.zshrc
    log_success "Zsh configuration applied"
else
    log_warning ".zshrc file not found"
fi

# Setup assume command
if [ -f "assume" ]; then
    sudo cp assume /usr/local/bin/assume
    sudo chmod +x /usr/local/bin/assume
    log_success "Assume command configured"
else
    log_warning "Assume script not found"
fi

# Make AWS/Kube configuration script executable
if [ -f "config-aws-kube.sh" ]; then
    chmod +x config-aws-kube.sh
    log_success "AWS/Kube configuration script is ready"
else
    log_warning "config-aws-kube.sh not found"
fi

log_success "WSL configuration completed successfully!"
log_info "Next steps:"
log_info "1. Start a new shell session"
log_info "2. Run 'p10k configure' to set up your theme"
log_info "3. Optionally run './config-aws-kube.sh' for AWS/Kubernetes setup"
log_info "4. Restart your terminal to apply all changes"
