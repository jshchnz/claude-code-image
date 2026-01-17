# claude-code-image

A Claude Code plugin for AI image generation and editing using GPT Image (OpenAI) or Nanobanana (Google Gemini).

## Features

- **Text-to-image generation** - Create images from text prompts
- **Image editing** - Edit existing images with AI (inpainting, style transfer, modifications)
- **Multiple services** - Choose between OpenAI GPT Image or Google Gemini (Nanobanana)
- **Auto-transparency** - Automatically enables transparent backgrounds for stickers, icons, and sprites
- **Configurable defaults** - Save your preferred settings for faster generation
- **Generation history** - Track all your generated images

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/jshchnz/claude-code-image.git
   ```

2. Add the plugin to Claude Code:
   ```bash
   claude --plugin-dir /path/to/claude-code-image
   ```

   Or add to your Claude Code settings to load automatically.

## Quick Start

1. Configure your API keys:
   ```
   /claude-code-image:configure
   ```

2. Generate your first image:
   ```
   /claude-code-image:generate a serene mountain landscape at sunset
   ```

## Commands

| Command | Description |
|---------|-------------|
| `/claude-code-image:generate <prompt>` | Generate an image from a text prompt |
| `/claude-code-image:edit` | Edit an existing image |
| `/claude-code-image:configure` | Set up API keys and preferences |
| `/claude-code-image:models` | List available models and their specs |
| `/claude-code-image:history` | View recently generated images |
| `/claude-code-image:status` | Check API key status and current config |

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

Run `/claude-code-image:configure` to set up:
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

## Examples

### Basic Generation
```
/claude-code-image:generate a cyberpunk city at night with neon lights
```

### Sticker (auto-transparent)
```
/claude-code-image:generate a kawaii cat sticker with sparkles
```

### Image Editing
```
/claude-code-image:edit
> Image: /path/to/photo.jpg
> Edit: Add sunglasses to the person
```

### Inpainting with Mask
```
/claude-code-image:edit
> Image: /path/to/landscape.jpg
> Edit: Replace the sky with a dramatic sunset
> Mask: /path/to/sky-mask.png
```

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
