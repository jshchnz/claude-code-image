# Security Policy

## Reporting Vulnerabilities

If you discover a security vulnerability in claude-code-image, please report it responsibly:

1. **DO NOT** create a public GitHub issue for security vulnerabilities
2. Email security concerns to the maintainer (see repository contact info)
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

We will acknowledge receipt within 48 hours and provide a detailed response within 7 days.

## Supported Versions

| Version | Supported          |
|---------|--------------------|
| 1.x     | :white_check_mark: |

## Security Best Practices

### API Key Management

- **Never commit API keys** to version control
- Store keys as environment variables only:
  ```bash
  export OPENAI_API_KEY='your-key'
  export GEMINI_API_KEY='your-key'
  ```
- Add keys to your shell profile (`~/.zshrc` or `~/.bashrc`), not to files in the repository
- Consider using a secrets manager for production environments
- Rotate keys periodically (recommended: every 90 days)
- Use separate keys for development and production

### What NOT to Do

- Do not store API keys in config files that might be synced or shared
- Do not log API responses in production (may contain sensitive data)
- Do not share screenshots showing API keys
- Do not use the same API key across multiple untrusted environments

## Security Features

### Input Validation
- All scripts validate required arguments before execution
- API keys are verified before making requests
- User prompts are JSON-escaped to prevent injection attacks

### Network Security
- All API communications use HTTPS
- Connection timeouts prevent indefinite hangs
- The plugin only communicates with these endpoints:
  - `api.openai.com` (OpenAI)
  - `generativelanguage.googleapis.com` (Google Gemini)

### Data Handling
- Generated images are saved locally only
- No user data is collected or transmitted except to the selected API provider
- Generation history is stored locally in `~/.claude-code-image/`
- Temporary files are cleaned up automatically

### Secure Defaults
- Temporary files use `mktemp` with restricted permissions
- API keys are read from environment variables only (never from config files)
- Cleanup traps ensure temp files are removed even on script failure

## Known Limitations

- Prompts are sent to third-party APIs (OpenAI/Google) - review their privacy policies
- API responses may be logged by the providers per their data retention policies
- Local history file (`~/.claude-code-image/history.json`) is not encrypted
- Generated images inherit default filesystem permissions
