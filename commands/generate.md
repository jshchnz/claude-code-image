---
description: Generate images from text prompts using AI (OpenAI or Gemini)
argument-hint: <prompt>
---

# Image Generation

## When to Use This Command

**Use this when the user wants to create a new image.** This includes natural language requests like:

- "Create an image of a sunset over mountains"
- "Generate a cyberpunk cityscape"
- "Make me a logo for my bakery"
- "Draw a cartoon cat"
- "I need an illustration of a rocket ship"
- "Design an icon for my app"
- "Can you make a picture of..."
- "Visualize what a futuristic car might look like"

**Also triggered by:** `/claude-code-image:generate <prompt>`

---

## Usage

```
/claude-code-image:generate <prompt>
```

## Instructions

When the user invokes this command with a prompt, follow these steps:

### 0. First-Time Setup Check

Check if configuration exists at `~/.claude-code-image/config.json`.

**If config file does NOT exist**, run first-time setup:

Display:
"**Welcome to claude-code-image!** Let's set up your preferences (one-time only).

**Step 1/3: Choose your preferred service**

Which AI service would you like to use for image generation?

1. **OpenAI (DALL-E 3)** - Best quality, ~$0.04-0.12/image
2. **Google Gemini** - Fast, free tier (1500/day), then ~$0.0025/image"

After user selects, ask for model preference:

**If OpenAI selected:**
"**Step 2/3: Choose default model**

1. `dall-e-3` - Best quality (recommended)
2. `dall-e-2` - Budget-friendly"

**If Gemini selected:**
"**Step 2/3: Choose default model**

1. `gemini-2.0-flash-exp-image-generation` - Fast, free tier (recommended)"

Then check for API key:

"**Step 3/3: API Key Setup**"

**For OpenAI:**
Check if `OPENAI_API_KEY` environment variable is set.
- If set: "API key detected! You're all set."
- If not set: Guide user to set it up:
  "No OpenAI API key found. Please set it up:
  1. Get your key: https://platform.openai.com/api-keys
  2. Add to your shell config (~/.zshrc or ~/.bashrc):
     `export OPENAI_API_KEY='your-key-here'`
  3. Run `source ~/.zshrc` and restart Claude Code"

**For Gemini:**
Check if `GEMINI_API_KEY` environment variable is set.
- If set: "API key detected! You're all set."
- If not set: Guide user to set it up:
  "No Gemini API key found. Please set it up:
  1. Get your key: https://aistudio.google.com/apikey
  2. Add to your shell config (~/.zshrc or ~/.bashrc):
     `export GEMINI_API_KEY='your-key-here'`
  3. Run `source ~/.zshrc` and restart Claude Code"

**Save Configuration:**

Create config directory and save preferences:
```bash
mkdir -p ~/.claude-code-image
mkdir -p ~/Pictures/claude-code-image
```

Write to `~/.claude-code-image/config.json`:
```json
{
  "default_service": "[selected: openai or gemini]",
  "default_model": {
    "openai": "[selected openai model]",
    "gemini": "[selected gemini model]"
  },
  "output_directory": "~/Pictures/claude-code-image",
  "default_size": "square",
  "default_quality": "auto",
  "default_format": "png"
}
```

Display: "**Setup complete!** Your preferences have been saved. Now let's generate your image..."

Then continue to Step 1.

**If config file EXISTS**, skip this step and proceed directly to Step 1.

---

### 1. Load User Preferences

Check if a config file exists at `~/.claude-code-image/config.json`. If it exists, read the user's default preferences:
- `default_service`: "gpt" or "nanobanana"
- `default_model`: model preferences per service
- `output_directory`: where to save images
- `default_size`: "square", "portrait", or "landscape"
- `default_quality`: "low", "medium", "high", or "auto"
- `default_format`: "png", "jpeg", or "webp"

### 2. Auto-Detect Transparency

Check if the prompt contains any of these keywords (case-insensitive):
- sticker, stickers
- icon, icons
- sprite, sprites
- logo, logos
- cutout
- transparent
- asset, assets
- emoji

If detected, inform the user: "Detected '[keyword]' - enabling transparent background (PNG format will be used)"

Set format to "png" and enable transparent background for this generation.

### 3. Select Service (if no default)

If no default service is configured, ask the user:

"Which image generation service would you like to use?
1. **GPT Image** (OpenAI) - State of the art quality
2. **Nanobanana** (Google Gemini) - Fast, free tier available"

### 4. Select Model (if no default for chosen service)

**GPT Image models:**
| Model | Speed | Quality | Cost |
|-------|-------|---------|------|
| `gpt-image-1.5` | Medium | Best | ~$0.02-0.08 |
| `gpt-image-1` | Medium | High | ~$0.02-0.08 |
| `gpt-image-1-mini` | Fast | Good | ~$0.005-0.02 |

**Nanobanana models:**
| Model | Speed | Quality | Notes |
|-------|-------|---------|-------|
| `gemini-2.5-flash-image` | Fast | Good | Free tier available |
| `gemini-3-pro-image-preview` | Slower | Best | Pro features, up to 4K |

### 5. Select Output Options (if no defaults)

**Size:**
- `square`: 1024x1024
- `portrait`: 1024x1536
- `landscape`: 1536x1024

**Quality:**
- `low`: Fastest, lower detail
- `medium`: Balanced
- `high`: Best detail, slower
- `auto`: Let the API decide

**Format:**
- `png`: Best for transparency, lossless
- `jpeg`: Smaller file size
- `webp`: Modern format, good compression

### 6. Estimate Cost & Confirm

Before generating, calculate and display the estimated cost based on selected options:

**OpenAI DALL-E 3 Pricing:**
| Size | Standard | HD |
|------|----------|-----|
| 1024x1024 (square) | $0.04 | $0.08 |
| 1024x1792 (portrait) | $0.08 | $0.12 |
| 1792x1024 (landscape) | $0.08 | $0.12 |

**OpenAI DALL-E 2 Pricing:**
- All sizes: ~$0.02

**Google Gemini (Nanobanana) Pricing:**
- **Free tier**: Up to 1500 images/day at no cost
- After free tier: ~$0.0025/image

Display a confirmation to the user:

```
**Estimated Cost:** $X.XX

Summary:
- Service: [OpenAI/Gemini]
- Model: [model name]
- Size: [dimensions]
- Quality: [quality level]

Proceed with generation?
```

Wait for user confirmation before proceeding. If user declines, offer to change options or cancel.

### 7. Check API Key

**For GPT Image:** Check if `OPENAI_API_KEY` environment variable is set.
**For Nanobanana:** Check if `GEMINI_API_KEY` environment variable is set.

If the required API key is not set, inform the user:
"API key not configured. Run `/claude-code-image:configure` to set up your API keys."

### 8. Generate the Image

Run the appropriate script based on the selected service:

**For GPT Image:**
```bash
bash /path/to/plugin/scripts/generate-gpt.sh \
  "<model>" \
  "<prompt>" \
  "<size>" \
  "<quality>" \
  "<format>" \
  "<background>" \
  "<output_path>"
```

Where:
- `<model>`: gpt-image-1.5, gpt-image-1, or gpt-image-1-mini
- `<size>`: 1024x1024, 1024x1536, or 1536x1024
- `<quality>`: low, medium, high, or auto
- `<format>`: png, jpeg, or webp
- `<background>`: "transparent" or "opaque"
- `<output_path>`: Full path including filename

**For Nanobanana:**
```bash
bash /path/to/plugin/scripts/generate-nanobanana.sh \
  "<model>" \
  "<prompt>" \
  "<aspect_ratio>" \
  "<output_path>"
```

Where:
- `<model>`: gemini-2.5-flash-image or gemini-3-pro-image-preview
- `<aspect_ratio>`: 1:1, 9:16, or 16:9
- `<output_path>`: Full path including filename

### 9. Generate Output Filename

Use this naming convention:
```
{service}_{model_short}_{YYYY-MM-DD}_{HHMMSS}.{format}
```

Examples:
- `gpt_1.5_2026-01-17_143052.png`
- `nanobanana_flash_2026-01-17_143105.png`

### 10. Save to History

Append the generation details to `~/.claude-code-image/history.json`:
```json
{
  "timestamp": "2026-01-17T14:30:52Z",
  "service": "nanobanana",
  "model": "gemini-2.5-flash-image",
  "prompt": "a cyberpunk city at night",
  "output_path": "~/Pictures/claude-code-image/nanobanana_flash_2026-01-17_143052.png",
  "size": "square",
  "quality": "auto",
  "format": "png",
  "transparent": false
}
```

### 11. Return Result

Display to the user:
- The generated image (read and display it)
- The file path where it was saved
- A brief confirmation message

Example output:
```
Image generated successfully!
Saved to: ~/Pictures/claude-code-image/nanobanana_flash_2026-01-17_143052.png

[Display the image]
```

## Examples

**Basic generation:**
```
/claude-code-image:generate a serene mountain landscape at sunset
```

**Auto-transparency:**
```
/claude-code-image:generate a cute cat sticker with sparkles
```
(Automatically enables transparent background)

**With saved preferences:**
If user has configured defaults, generation proceeds immediately without prompts.
