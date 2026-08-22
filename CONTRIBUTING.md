# Contributing to Field Inspector

Thank you for your interest in contributing to Field Inspector! This document provides guidelines and instructions for contributing to the project.

## 🤝 How to Contribute

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When creating a bug report, include:

- **Title**: Clear and descriptive
- **Description**: Detailed explanation of the bug
- **Steps to Reproduce**: Step-by-step instructions to reproduce the issue
- **Expected Behavior**: What you expected to happen
- **Actual Behavior**: What actually happened
- **Screenshots**: If applicable, add screenshots
- **Environment**: 
  - App version
  - Device model
  - Android version
  - Flutter version

### Suggesting Enhancements

Enhancement suggestions are welcome! Please provide:

- **Title**: Clear and descriptive
- **Problem Description**: What problem does this solve?
- **Proposed Solution**: How should it be implemented?
- **Alternatives**: What alternatives have you considered?
- **Additional Context**: Any other relevant information

## 🛠️ Development Setup

1. **Fork the repository**
2. **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/Field_Inspector.git
   cd Field_Inspector/field_inspector
   ```

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

4. **Create a branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

5. **Make your changes** and follow the coding standards below

6. **Test your changes**:
   ```bash
   flutter analyze
   flutter test
   flutter run
   ```

7. **Commit your changes**:
   ```bash
   git commit -m "Add your commit message"
   ```

8. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

9. **Create a Pull Request** on GitHub

## 📋 Coding Standards

### Dart/Flutter Guidelines

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `flutter format .` to format code before committing
- Run `flutter analyze` and fix all issues
- Keep functions small and focused
- Use meaningful variable and function names
- Add comments for complex logic

### Code Style

- Use camelCase for variables and functions
- Use PascalCase for classes and types
- Use lowercase_with_underscores for files and directories
- Maximum line length: 80 characters
- Add doc comments for public APIs

### File Organization

- Keep related files together
- Use clear directory structure
- Separate UI from business logic
- Keep main.dart minimal

## 🧪 Testing

- Write unit tests for business logic
- Write widget tests for UI components
- Test on multiple screen sizes
- Test on different Android versions
- Ensure all tests pass before submitting PR

## 📝 Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting, etc.)
- `refactor:` Code refactoring
- `test:` Adding or updating tests
- `chore:` Maintenance tasks

Examples:
- `feat: add night mode support`
- `fix: resolve GPS permission issue`
- `docs: update README with new features`

## 🎯 Pull Request Guidelines

- Provide a clear description of changes
- Link related issues using `#issue-number`
- Update documentation if needed
- Add tests for new features
- Ensure all tests pass
- Request review from maintainers

## 📞 Getting Help

If you need help:

- Open an issue for questions
- Check existing documentation
- Join discussions in issues
- Reach out to maintainers

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to Field Inspector! 🎉