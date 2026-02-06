# claude-code-image

Generate and edit images using the latest models all within Claude Code.

## Install

```
/plugin marketplace add jshchnz/claude-code-image
/plugin install image@claude-code-image
```

> Requires Claude Code v1.0.33+

Then configure your API key:
> "Set up image generation" or `/image:configure`

## Quick Start

After installing, simply ask Claude to create images:

> "Create an image of a serene Japanese garden at sunset"

> "Generate a logo for a tech startup called 'NovaSpark'"

> "Make me a cute cartoon fox sticker"

Claude will handle the rest - selecting the right service, generating the image, and saving it for you.

## Examples

### Creating Images

**Landscapes & Scenes:**
> "Create an image of a cyberpunk city at night with neon lights and flying cars"

**Logos & Icons:**
> "Generate a minimalist logo for a coffee shop called 'Bean There'"

**Characters & Art:**
> "Draw a friendly robot mascot in a cartoon style"

**Stickers (auto-transparent):**
> "Make a kawaii cat sticker with sparkles"

### Editing Images

**Adding Elements:**
> "Here's my photo [attach image]. Add sunglasses to me"

**Style Transfer:**
> "Take this landscape photo and make it look like a Van Gogh painting"

**Modifications:**
> "Edit this image and change the background to a beach"

## Slash Commands (Advanced)

For explicit control, you can also use slash commands:

| Command | Description |
|---------|-------------|
| `/image:generate <prompt>` | Generate with specific prompt |
| `/image:edit` | Interactive image editing |
| `/image:configure` | Set up API keys and defaults |
| `/image:models` | View available AI models |
| `/image:history` | See recent generations |
| `/image:status` | Check configuration |

## Available Models

### GPT Image (OpenAI)

| Model | Speed | Quality | Cost |
|-------|-------|---------|------|
| `gpt-image-1.5` | Medium | Best | ~$0.02-0.08/image |
| `gpt-image-1` | Medium | High | ~$0.02-0.08/image |
| `gpt-image-1-mini` | Fast | Good | ~$0.005-0.02/image |

### Nanobanana (Google Gemini)

| Model | Speed | Quality | Notes |
|-------|-------|---------|-------|
| `gemini-2.5-flash-image` | Fast | Good | Free tier available |
| `gemini-3-pro-image-preview` | Slower | Best | Up to 4K resolution |

## Configuration

### API Keys

Set up your API keys as environment variables:

```bash
# OpenAI (for GPT Image)
export OPENAI_API_KEY='your-openai-api-key'

# Google (for Nanobanana)
export GEMINI_API_KEY='your-gemini-api-key'
```

Get your API keys:
- OpenAI: https://platform.openai.com/api-keys
- Gemini: https://aistudio.google.com/apikey

### User Preferences

Run `/image:configure` or say "configure image generation" to set up:
- Default service (GPT Image or Nanobanana)
- Default model for each service
- Output directory
- Default size, quality, and format

Configuration is saved to `~/.claude-code-image/config.json`.

## Output Options

### Size
- `square` - 1024x1024
- `portrait` - 1024x1536
- `landscape` - 1536x1024

### Quality
- `auto` - Let the AI decide
- `low` - Fastest
- `medium` - Balanced
- `high` - Best detail

### Format
- `png` - Best for transparency
- `jpeg` - Smaller file size
- `webp` - Modern format

## Auto-Transparency

The plugin automatically enables transparent backgrounds when your prompt contains keywords like:
- sticker, icon, sprite, logo
- cutout, transparent
- asset, emoji

## File Locations

| Path | Purpose |
|------|---------|
| `~/.claude-code-image/config.json` | User preferences |
| `~/.claude-code-image/history.json` | Generation history |
| `~/Pictures/claude-code-image/` | Default output directory |

## Requirements

- Claude Code CLI
- `curl` (for API requests)
- `base64` (for encoding/decoding)
- `python3` (for JSON parsing in Gemini scripts)
- API key for at least one service (OpenAI or Google)

## License

MIT License - see [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Support

- Report issues: https://github.com/jshchnz/claude-code-image/issues
- Discussions: https://github.com/jshchnz/claude-code-image/discussions

## Acknowledgments

- [OpenAI](https://openai.com) for the GPT Image API
- [Google](https://ai.google.dev) for the Gemini API
- [Anthropic](https://anthropic.com) for Claude Code
