# Contributing to claude-code-image

Thank you for your interest in contributing to claude-code-image! This document provides guidelines and instructions for contributing.

## Code of Conduct

Please be respectful and constructive in all interactions. We welcome contributors of all experience levels.

## How to Contribute

### Reporting Bugs

1. Check existing issues to avoid duplicates
2. Use the bug report template if available
3. Include:
   - Claude Code version
   - Operating system
   - Steps to reproduce
   - Expected vs actual behavior
   - Error messages or logs

### Suggesting Features

1. Check existing issues and discussions
2. Describe the feature and its use case
3. Explain why it would benefit users

### Submitting Changes

1. Fork the repository
2. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Make your changes
4. Test your changes thoroughly
5. Commit with clear messages:
   ```bash
   git commit -m "Add feature: description of change"
   ```
6. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```
7. Open a Pull Request

## Development Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/jshchnz/claude-code-image.git
   cd claude-code-image
   ```

2. Make scripts executable:
   ```bash
   chmod +x scripts/*.sh
   ```

3. Set up API keys for testing:
   ```bash
   export OPENAI_API_KEY='your-test-key'
   export GEMINI_API_KEY='your-test-key'
   ```

4. Test the plugin:
   ```bash
   claude --plugin-dir ./
   ```

## Project Structure

```
claude-code-image/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── commands/
│   ├── generate.md          # Generation command
│   ├── edit.md              # Editing command
│   ├── configure.md         # Configuration command
│   ├── models.md            # Models listing command
│   ├── history.md           # History command
│   └── status.md            # Status command
├── scripts/
│   ├── generate-gpt.sh      # OpenAI generation
│   ├── generate-nanobanana.sh # Gemini generation
│   ├── edit-gpt.sh          # OpenAI editing
│   └── edit-nanobanana.sh   # Gemini editing
├── LICENSE
├── README.md
└── CONTRIBUTING.md
```

## Guidelines

### Command Files (.md)

- Use clear, step-by-step instructions
- Include all necessary context for Claude
- Document parameters and expected inputs
- Provide example usage

### Shell Scripts

- Include usage comments at the top
- Validate required arguments
- Handle errors gracefully
- Use meaningful variable names
- Quote variables to handle spaces

### Documentation

- Keep README concise but complete
- Update docs when adding features
- Include examples where helpful

## Testing

Before submitting a PR:

1. Test all commands manually
2. Verify scripts work with both services
3. Check error handling for missing API keys
4. Test with various prompt types

## Pull Request Process

1. Update documentation if needed
2. Ensure all tests pass
3. Request review from maintainers
4. Address feedback promptly

## Questions?

- Open a discussion on GitHub
- Check existing issues and discussions

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
