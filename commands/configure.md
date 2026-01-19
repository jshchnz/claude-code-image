---
description: Set up API keys and default preferences for image generation
---

# Configure

Set up API keys and default preferences for the claude-code-image plugin.

## Usage

```
/claude-code-image:configure
```

## Instructions

When the user invokes this command, guide them through the configuration process:

### 1. Welcome Message

Display:
"Welcome to claude-code-image configuration!

This will help you set up:
1. API keys for image generation services
2. Default preferences for faster generation"

### 2. Configure API Keys

#### OpenAI API Key (for GPT Image)

Ask: "Do you want to configure the OpenAI API key for GPT Image?"

If yes:
1. Check if `OPENAI_API_KEY` is already set in the environment
2. If set, ask: "OpenAI API key is already configured. Do you want to update it?"
3. Provide instructions:

"To set up your OpenAI API key:

1. Go to https://platform.openai.com/api-keys
2. Create a new API key
3. Add it to your shell configuration:

**For zsh (~/.zshrc):**
```bash
export OPENAI_API_KEY='your-api-key-here'
```

**For bash (~/.bashrc):**
```bash
export OPENAI_API_KEY='your-api-key-here'
```

Then run `source ~/.zshrc` (or `~/.bashrc`) to apply."

#### Gemini API Key (for Nanobanana)

Ask: "Do you want to configure the Gemini API key for Nanobanana?"

If yes:
1. Check if `GEMINI_API_KEY` is already set in the environment
2. If set, ask: "Gemini API key is already configured. Do you want to update it?"
3. Provide instructions:

"To set up your Gemini API key:

1. Go to https://aistudio.google.com/apikey
2. Create a new API key
3. Add it to your shell configuration:

**For zsh (~/.zshrc):**
```bash
export GEMINI_API_KEY='your-api-key-here'
```

**For bash (~/.bashrc):**
```bash
export GEMINI_API_KEY='your-api-key-here'
```

Then run `source ~/.zshrc` (or `~/.bashrc`) to apply."

### 3. Configure Default Preferences

Ask the user to set default preferences. Create the config directory if it doesn't exist:
```bash
mkdir -p ~/.claude-code-image
```

#### Default Service

Ask: "Which service do you want as your default?
1. **GPT Image** (OpenAI)
2. **Nanobanana** (Google Gemini)
3. **Ask each time** (no default)"

#### Default Models

**For GPT Image:**
Ask: "Which GPT Image model should be your default?
1. `gpt-image-1.5` - Best quality (recommended)
2. `gpt-image-1` - High quality
3. `gpt-image-1-mini` - Fast and budget-friendly"

**For Nanobanana:**
Ask: "Which Nanobanana model should be your default?
1. `gemini-2.5-flash-image` - Fast (recommended)
2. `gemini-3-pro-image-preview` - Pro features, up to 4K"

#### Output Directory

Ask: "Where should generated images be saved?
Default: `~/Pictures/claude-code-image`

Enter a custom path or press Enter for default:"

If a custom path is provided, validate it exists or offer to create it.

#### Default Size

Ask: "What should be your default image size?
1. `square` - 1024x1024 (recommended)
2. `portrait` - 1024x1536
3. `landscape` - 1536x1024"

#### Default Quality

Ask: "What should be your default quality?
1. `auto` - Let the AI decide (recommended)
2. `low` - Fastest
3. `medium` - Balanced
4. `high` - Best detail"

#### Default Format

Ask: "What should be your default image format?
1. `png` - Best for transparency (recommended)
2. `jpeg` - Smaller file size
3. `webp` - Modern format"

### 4. Save Configuration

Write the configuration to `~/.claude-code-image/config.json`:

```json
{
  "default_service": "nanobanana",
  "default_model": {
    "gpt": "gpt-image-1.5",
    "nanobanana": "gemini-2.5-flash-image"
  },
  "output_directory": "~/Pictures/claude-code-image",
  "default_size": "square",
  "default_quality": "auto",
  "default_format": "png"
}
```

### 5. Create Output Directory

Create the output directory if it doesn't exist:
```bash
mkdir -p ~/Pictures/claude-code-image
```

### 6. Initialize History File

Create an empty history file if it doesn't exist:
```bash
echo '[]' > ~/.claude-code-image/history.json
```
(Only if the file doesn't already exist)

### 7. Confirmation

Display a summary:
"Configuration saved!

**API Keys:**
- OpenAI: [Configured/Not configured]
- Gemini: [Configured/Not configured]

**Defaults:**
- Service: [service]
- GPT Model: [model]
- Nanobanana Model: [model]
- Output Directory: [path]
- Size: [size]
- Quality: [quality]
- Format: [format]

Run `/claude-code-image:status` to check your configuration at any time."

## Reconfiguration

Users can run `/claude-code-image:configure` again to update any settings. The command will show current values and allow selective updates.

## Config File Location

All configuration is stored in:
- `~/.claude-code-image/config.json` - User preferences
- `~/.claude-code-image/history.json` - Generation history

## Environment Variables

API keys should be stored as environment variables (not in the config file for security):
- `OPENAI_API_KEY` - For GPT Image
- `GEMINI_API_KEY` - For Nanobanana
