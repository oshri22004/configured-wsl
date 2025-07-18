# Troubleshooting Guide

This guide helps resolve common issues encountered when setting up the WSL configuration.

## Common Issues and Solutions

### 1. Permission Denied Errors

**Problem**: Getting permission denied when running scripts
```bash
bash: ./configure_my_wsl.sh: Permission denied
```

**Solution**:
```bash
chmod +x configure_my_wsl.sh
chmod +x config-aws-kube.sh
chmod +x validate_setup.sh
chmod +x backup_config.sh
```

### 2. Docker Installation Issues

**Problem**: Docker installation fails or docker daemon is not running

**Solutions**:
- Ensure WSL 2 is being used: `wsl --version`
- Restart WSL: `wsl --shutdown` then restart WSL
- Check Docker service: `sudo systemctl status docker`
- Start Docker service: `sudo systemctl start docker`
- Add user to docker group: `sudo usermod -aG docker $USER`

### 3. Homebrew Installation Problems

**Problem**: Homebrew installation fails or brew command not found

**Solutions**:
- Ensure build tools are installed: `sudo apt install build-essential`
- Add Homebrew to PATH:
  ```bash
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
  source ~/.profile
  ```
- Reinstall Homebrew if needed

### 4. Oh My Zsh Theme Issues

**Problem**: PowerLevel10k theme not loading or looks incorrect

**Solutions**:
- Install a Nerd Font in Windows Terminal
- Run theme configuration: `p10k configure`
- Check if theme is properly installed:
  ```bash
  ls -la ~/.oh-my-zsh/custom/themes/powerlevel10k/
  ```

### 5. Package Installation Failures

**Problem**: Some packages fail to install

**Solutions**:
- Update package lists: `sudo apt update`
- Fix broken packages: `sudo apt --fix-broken install`
- Install packages individually to identify the problematic ones
- Check disk space: `df -h`

### 6. AWS/Kubernetes Configuration Issues

**Problem**: AWS or Kubernetes tools not working properly

**Solutions**:
- Ensure AWS CLI is properly configured: `aws configure`
- Check kubectl configuration: `kubectl config current-context`
- Verify kubeconfig file exists: `ls -la ~/.kube/config`
- Update kubeconfig: `aws eks update-kubeconfig --region <region> --name <cluster-name>`

### 7. Windows Terminal Settings Not Applied

**Problem**: Windows Terminal settings don't seem to apply

**Solutions**:
- Ensure Windows Terminal is closed when running the script
- Check if the settings file path is correct
- Manually copy settings.json to the Windows Terminal LocalState folder
- Restart Windows Terminal

### 8. GPG Key Issues

**Problem**: GPG key generation fails or password store issues

**Solutions**:
- Check GPG version: `gpg --version`
- List existing keys: `gpg --list-keys`
- Remove and regenerate keys if needed:
  ```bash
  gpg --delete-secret-keys devops
  gpg --delete-keys devops
  ```
- Reinstall pass: `sudo apt install pass`

### 9. Chrome Integration Problems

**Problem**: Chrome browser integration doesn't work

**Solutions**:
- Verify Chrome is installed in the standard location
- Check symlink: `ls -la /usr/bin/google`
- Manually create symlink:
  ```bash
  sudo ln -sf "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe" /usr/bin/google
  ```

### 10. Zsh Plugins Not Working

**Problem**: Zsh plugins don't seem to be active

**Solutions**:
- Check if plugins are in the correct directory:
  ```bash
  ls -la ~/.oh-my-zsh/custom/plugins/
  ```
- Verify .zshrc configuration
- Restart zsh: `exec zsh`
- Source .zshrc: `source ~/.zshrc`

## Validation and Testing

### Run the Validation Script
```bash
./validate_setup.sh
```

### Manual Checks
1. **Check Zsh theme**: Theme should be PowerLevel10k
2. **Test Docker**: `docker --version` and `docker ps`
3. **Test Homebrew**: `brew --version` and `brew list`
4. **Test AWS CLI**: `aws --version`
5. **Test Kubernetes tools**: `kubectl version --client` and `k9s version`

### Creating a Backup
Before making changes, create a backup:
```bash
./backup_config.sh
```

## Getting Help

If you're still experiencing issues:

1. **Check the logs**: Most commands provide verbose output
2. **Run validation**: Use `./validate_setup.sh` to identify missing components
3. **Search existing issues**: Check the GitHub repository for similar problems
4. **Create a new issue**: Use the bug report template with detailed information

## Environment Information

To help with troubleshooting, gather this information:
- WSL version: `wsl --version`
- Linux distribution: `cat /etc/os-release`
- Available disk space: `df -h`
- Memory usage: `free -h`
- Current user: `whoami`
- Current shell: `echo $SHELL`

## Reset Installation

If all else fails, you can reset the installation:

1. **Backup important data**
2. **Remove installed components**:
   ```bash
   rm -rf ~/.oh-my-zsh
   rm -rf ~/.granted
   # Remove other components as needed
   ```
3. **Run the configuration script again**

Remember: Always backup your configuration before making significant changes!
