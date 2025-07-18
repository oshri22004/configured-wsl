#!/bin/bash

# Backup script for WSL configuration
# This script backs up important configuration files before making changes

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

# Create backup directory
BACKUP_DIR="$HOME/.wsl_config_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

log_info "Creating backup in $BACKUP_DIR"

# Files to backup
declare -A files_to_backup=(
    ["$HOME/.zshrc"]="zshrc"
    ["$HOME/.bashrc"]="bashrc"
    ["$HOME/.profile"]="profile"
    ["$HOME/.gitconfig"]="gitconfig"
    ["$HOME/.granted/config"]="granted_config"
    ["$HOME/.aws/config"]="aws_config"
    ["$HOME/.kube/config"]="kube_config"
    ["$HOME/.docker/config.json"]="docker_config"
)

# Backup individual files
for file in "${!files_to_backup[@]}"; do
    if [ -f "$file" ]; then
        cp "$file" "$BACKUP_DIR/${files_to_backup[$file]}.backup"
        log_success "Backed up $file"
    else
        log_warning "File $file not found, skipping"
    fi
done

# Backup Oh My Zsh custom directory
if [ -d "$HOME/.oh-my-zsh/custom" ]; then
    cp -r "$HOME/.oh-my-zsh/custom" "$BACKUP_DIR/oh-my-zsh-custom-backup"
    log_success "Backed up Oh My Zsh custom directory"
fi

# Create backup info file
cat > "$BACKUP_DIR/backup_info.txt" << EOF
WSL Configuration Backup
Created: $(date)
System: $(uname -a)
User: $(whoami)

Files backed up:
$(ls -la "$BACKUP_DIR")
EOF

log_success "Backup completed successfully in $BACKUP_DIR"
log_info "To restore, manually copy files from the backup directory to their original locations"
