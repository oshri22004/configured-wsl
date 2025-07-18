# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Comprehensive README.md with proper formatting and documentation
- MIT License file
- .gitignore file to exclude sensitive and unnecessary files
- CHANGELOG.md for tracking changes
- Color-coded logging system in main configuration script
- Better error handling and validation in scripts
- Improved Docker installation process
- Enhanced package installation with individual package handling
- GPG key configuration improvements
- Chrome browser integration setup

### Changed
- Complete rewrite of README.md with better structure and emojis
- Enhanced main configuration script with proper error handling
- Improved logging output with color-coded messages
- Better validation and checks throughout the installation process
- Optimized Git clones to use shallow clones (--depth=1) for faster downloads

### Fixed
- WSL detection to ensure script runs only in WSL environment
- Error handling for missing files and failed operations
- Proper exit codes and error messages
- Docker installation process with correct GPG key handling
- Package installation with better error recovery

## [1.0.0] - Initial Release

### Added
- Basic WSL configuration script
- Oh My Zsh with PowerLevel10k theme setup
- Essential development tools installation
- Docker installation and configuration
- Homebrew package management
- AWS and Kubernetes tooling setup
- Windows Terminal configuration
- Chrome browser integration
- GPG and password store setup
