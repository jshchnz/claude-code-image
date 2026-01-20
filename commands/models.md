---
description: List available AI image generation models and their specs
---

# Models

List all available image generation models with their specifications.

## Usage

```
/image:models
```

## Instructions

When the user invokes this command, display the following information:

### Display Model Information

"# Available Image Generation Models

## GPT Image (OpenAI)

| Model | Speed | Quality | Max Resolution | Estimated Cost | Notes |
|-------|-------|---------|----------------|----------------|-------|
| `gpt-image-1.5` | Medium | Best | 1536x1024 | ~$0.02-0.08/image | State of the art, recommended |
| `gpt-image-1` | Medium | High | 1536x1024 | ~$0.02-0.08/image | Reliable, good for most uses |
| `gpt-image-1-mini` | Fast | Good | 1536x1024 | ~$0.005-0.02/image | Budget-friendly option |

**Features:**
- Text-to-image generation
- Image editing with masks (inpainting)
- Transparent background support
- Multiple output formats (PNG, JPEG, WebP)
- Quality levels: low, medium, high, auto

**API Key:** `OPENAI_API_KEY`
**Get key:** https://platform.openai.com/api-keys

---

## Nanobanana (Google Gemini)

| Model | Speed | Quality | Max Resolution | Estimated Cost | Notes |
|-------|-------|---------|----------------|----------------|-------|
| `gemini-2.5-flash-image` | Fast | Good | 1024x1024 | ~$0.02/image | Free tier available, fast |
| `gemini-3-pro-image-preview` | Slower | Best | Up to 4K | ~$0.12/image | Pro features, highest resolution |

**Features:**
- Text-to-image generation
- Image editing with reference images
- Style transfer capabilities
- Multimodal understanding

**API Key:** `GEMINI_API_KEY`
**Get key:** https://aistudio.google.com/apikey

---

## Model Recommendations

| Use Case | Recommended Model |
|----------|-------------------|
| Quick prototyping | `gemini-2.5-flash-image` |
| Production quality | `gpt-image-1.5` |
| Budget-conscious | `gpt-image-1-mini` |
| High resolution (4K) | `gemini-3-pro-image-preview` |
| Transparent backgrounds | Any GPT Image model |
| Free tier / Testing | `gemini-2.5-flash-image` |

## Size Options

| Size | Dimensions | Aspect Ratio | Best For |
|------|------------|--------------|----------|
| `square` | 1024x1024 | 1:1 | Social media, icons |
| `portrait` | 1024x1536 | 2:3 | Mobile wallpapers, posters |
| `landscape` | 1536x1024 | 3:2 | Desktop wallpapers, banners |

## Quality Options

| Quality | Description | Speed | Detail |
|---------|-------------|-------|--------|
| `auto` | AI decides optimal | Varies | Adaptive |
| `low` | Fast generation | Fastest | Basic |
| `medium` | Balanced | Medium | Good |
| `high` | Maximum detail | Slowest | Best |

## Format Options

| Format | Best For | Transparency | File Size |
|--------|----------|--------------|-----------|
| `png` | Icons, stickers, logos | Yes | Larger |
| `jpeg` | Photos, artwork | No | Smaller |
| `webp` | Web use | Yes | Smallest |

---

**Tip:** Run `/image:configure` to set your default model preferences."

## Notes

- Costs are estimates and may vary based on usage and pricing changes
- Free tier availability for Gemini may have usage limits
- All models support the same size options, but actual output may vary
- Transparent background is only available with PNG format
