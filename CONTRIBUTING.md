# Contributing to Configured WSL

Thank you for considering contributing to Configured WSL! This document outlines how to contribute to this project.

## Code of Conduct

By participating in this project, you are expected to uphold our code of conduct:
- Be respectful and inclusive
- Focus on constructive feedback
- Help create a welcoming environment for all contributors

## How to Contribute

### Reporting Issues

If you encounter any problems:

1. **Search existing issues** to avoid duplicates
2. **Use the issue template** when creating new issues
3. **Provide detailed information**:
   - Your WSL version and Linux distribution
   - Steps to reproduce the issue
   - Expected vs actual behavior
   - Any error messages
   - Your environment details

### Suggesting Enhancements

We welcome suggestions for improvements:

1. **Check existing issues** for similar suggestions
2. **Create a detailed enhancement request** with:
   - Clear description of the proposed feature
   - Use cases and benefits
   - Possible implementation approach
   - Any potential drawbacks

### Code Contributions

#### Setting Up Development Environment

1. **Fork the repository** on GitHub
2. **Clone your fork locally**:
   ```bash
   git clone https://github.com/your-username/configured-wsl.git
   cd configured-wsl
   ```

3. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

#### Making Changes

1. **Follow the existing code style**:
   - Use 2 spaces for indentation in shell scripts
   - Add comments for complex logic
   - Use meaningful variable names
   - Follow bash best practices

2. **Test your changes**:
   - Test the script on a clean WSL installation
   - Verify that existing functionality still works
   - Test edge cases and error conditions

3. **Update documentation**:
   - Update README.md if needed
   - Update CHANGELOG.md with your changes
   - Add or update comments in code

#### Submitting Changes

1. **Commit your changes**:
   ```bash
   git add .
   git commit -m "Add: Brief description of your changes"
   ```

2. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

3. **Create a Pull Request**:
   - Use a clear title and description
   - Reference any related issues
   - Explain what your changes do and why

## Pull Request Guidelines

### Before Submitting

- [ ] Code follows the project's style guidelines
- [ ] Changes have been tested on WSL
- [ ] Documentation has been updated
- [ ] CHANGELOG.md has been updated
- [ ] No merge conflicts with main branch

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update
- [ ] Performance improvement

## Testing
- [ ] Tested on clean WSL installation
- [ ] Existing functionality verified
- [ ] Edge cases tested

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
```

## Adding New Packages

### System Packages (APT)
To add new system packages:
1. Add the package name to `package_list.txt`
2. Test the installation
3. Document the package purpose in your PR

### Homebrew Packages
To add new Homebrew packages:
1. Add the package name to `my_brews.txt`
2. Test the installation
3. Ensure the package is relevant for DevOps/development

## Project Structure

```
configured-wsl/
├── README.md                 # Main documentation
├── configure_my_wsl.sh      # Main configuration script
├── config-aws-kube.sh       # AWS/Kubernetes setup script
├── package_list.txt         # System packages list
├── my_brews.txt            # Homebrew packages list
├── settings.json           # Windows Terminal settings
├── .zshrc                  # Zsh configuration
├── config                  # Granted configuration
├── assume                  # Assume script
├── imgs/                   # Documentation images
├── CHANGELOG.md            # Version history
├── CONTRIBUTING.md         # This file
├── LICENSE                 # MIT License
└── .gitignore             # Git ignore rules
```

## Style Guidelines

### Shell Scripts
- Use `#!/bin/bash` shebang
- Enable strict mode: `set -euo pipefail`
- Use color-coded logging functions
- Add proper error handling
- Include helpful comments
- Use meaningful variable names

### Documentation
- Use clear, concise language
- Include code examples where helpful
- Use proper Markdown formatting
- Add emojis for visual appeal (sparingly)

## Questions?

If you have questions about contributing, please:
1. Check existing issues and discussions
2. Create a new issue with the "question" label
3. Reach out to maintainers

Thank you for contributing to Configured WSL! 🚀
