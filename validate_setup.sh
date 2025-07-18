#!/bin/bash

# Validation script to check the health of the WSL configuration
# This script can be run after the main configuration to verify everything is set up correctly

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

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if directory exists
dir_exists() {
    [ -d "$1" ]
}

# Check if file exists
file_exists() {
    [ -f "$1" ]
}

log_info "Starting WSL configuration validation..."

# Check if running in WSL
if ! grep -q Microsoft /proc/version 2>/dev/null; then
    log_error "This script must be run in WSL (Windows Subsystem for Linux)"
    exit 1
fi

# Check Oh My Zsh installation
log_info "Checking Oh My Zsh installation..."
if dir_exists "$HOME/.oh-my-zsh"; then
    log_success "Oh My Zsh is installed"
else
    log_error "Oh My Zsh is not installed"
fi

# Check PowerLevel10k theme
log_info "Checking PowerLevel10k theme..."
if dir_exists "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"; then
    log_success "PowerLevel10k theme is installed"
else
    log_error "PowerLevel10k theme is not installed"
fi

# Check Zsh plugins
log_info "Checking Zsh plugins..."
plugins=(
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
    "ohmyzsh-full-autoupdate"
)

for plugin in "${plugins[@]}"; do
    if dir_exists "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin"; then
        log_success "$plugin plugin is installed"
    else
        log_error "$plugin plugin is not installed"
    fi
done

# Check essential commands
log_info "Checking essential commands..."
essential_commands=(
    "git"
    "curl"
    "wget"
    "docker"
    "brew"
    "node"
    "npm"
    "python3"
    "pip3"
    "aws"
    "kubectl"
    "k9s"
    "jq"
    "yq"
    "assume"
)

for cmd in "${essential_commands[@]}"; do
    if command_exists "$cmd"; then
        log_success "$cmd is available"
    else
        log_warning "$cmd is not available"
    fi
done

# Check configuration files
log_info "Checking configuration files..."
config_files=(
    "$HOME/.zshrc"
    "$HOME/.granted/config"
)

for file in "${config_files[@]}"; do
    if file_exists "$file"; then
        log_success "$(basename "$file") is configured"
    else
        log_warning "$(basename "$file") is not configured"
    fi
done

# Check Docker service
log_info "Checking Docker service..."
if systemctl is-active --quiet docker; then
    log_success "Docker service is running"
else
    log_warning "Docker service is not running"
fi

# Check Docker permissions
log_info "Checking Docker permissions..."
if docker ps >/dev/null 2>&1; then
    log_success "Docker permissions are correctly configured"
else
    log_warning "Docker permissions may need adjustment"
fi

# Check Chrome integration
log_info "Checking Chrome integration..."
if file_exists "/usr/bin/google"; then
    log_success "Chrome integration is configured"
else
    log_warning "Chrome integration is not configured"
fi

# Check GPG configuration
log_info "Checking GPG configuration..."
if gpg --list-keys | grep -q "devops"; then
    log_success "GPG key is configured"
else
    log_warning "GPG key is not configured"
fi

# Check Homebrew packages
log_info "Checking Homebrew packages..."
if command_exists "brew"; then
    brew_packages=(
        "awscli"
        "kubectl"
        "k9s"
        "jq"
        "yq"
        "node"
        "python@3.12"
        "gh"
        "granted"
    )
    
    for package in "${brew_packages[@]}"; do
        if brew list | grep -q "^$package$"; then
            log_success "$package is installed via Homebrew"
        else
            log_warning "$package is not installed via Homebrew"
        fi
    done
else
    log_error "Homebrew is not available"
fi

# Check colorls
log_info "Checking colorls..."
if gem list | grep -q colorls; then
    log_success "colorls is installed"
else
    log_warning "colorls is not installed"
fi

log_info "Validation completed!"
log_info "If you see any errors or warnings above, you may need to re-run the configuration script."
