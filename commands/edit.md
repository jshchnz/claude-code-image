# Edit Image

Edit existing images using AI image generation services. Supports reference images, inpainting with masks, and style transfer.

## Usage

```
/claude-code-image:edit
```

## Instructions

When the user invokes this command, follow these interactive steps:

### 1. Request Source Image

Ask the user:
"Please provide the image you want to edit. You can:
- Share a file path (e.g., `/Users/me/photo.jpg`)
- Describe which image from the conversation to use"

Read the image file that the user provides.

### 2. Request Edit Instructions

Ask the user:
"What changes would you like to make to this image?"

Examples of edit instructions:
- "Add a wizard hat to the person"
- "Change the background to a beach sunset"
- "Remove the car from the image"
- "Make it look like a watercolor painting"

### 3. Optional: Request Mask Image (for Inpainting)

Ask the user:
"Do you want to provide a mask to specify which area to edit?
- **Yes**: Provide a mask image (white = edit area, black = preserve)
- **No**: The AI will determine the edit area automatically"

If yes, ask for the mask image path and read it.

### 4. Load User Preferences

Check `~/.claude-code-image/config.json` for defaults:
- `default_service`
- `default_model`
- `output_directory`
- `default_size`
- `default_quality`
- `default_format`

### 5. Select Service (if no default)

Ask the user which service to use:

"Which service would you like to use for editing?
1. **GPT Image** (OpenAI) - Best for precise edits and inpainting
2. **Nanobanana** (Google Gemini) - Good for style transfer and general edits"

### 6. Select Model (if no default)

Present available models for the chosen service (same as generate command).

### 7. Select Output Options (if no defaults)

Same options as generate command:
- Size (square, portrait, landscape)
- Quality (low, medium, high, auto)
- Format (png, jpeg, webp)

### 8. Check API Key

Verify the required API key is set:
- GPT Image: `OPENAI_API_KEY`
- Nanobanana: `GEMINI_API_KEY`

### 9. Perform the Edit

**For GPT Image:**
```bash
bash /path/to/plugin/scripts/edit-gpt.sh \
  "<model>" \
  "<prompt>" \
  "<image_base64>" \
  "<mask_base64>" \
  "<size>" \
  "<quality>" \
  "<format>" \
  "<output_path>"
```

Where:
- `<image_base64>`: Base64-encoded source image
- `<mask_base64>`: Base64-encoded mask image (or "none" if no mask)
- Other params same as generate

**For Nanobanana:**
```bash
bash /path/to/plugin/scripts/edit-nanobanana.sh \
  "<model>" \
  "<prompt>" \
  "<image_base64>" \
  "<aspect_ratio>" \
  "<output_path>"
```

### 10. Generate Output Filename

Use this naming convention:
```
{service}_edit_{YYYY-MM-DD}_{HHMMSS}.{format}
```

Examples:
- `gpt_edit_2026-01-17_143210.png`
- `nanobanana_edit_2026-01-17_143215.png`

### 11. Save to History

Append to `~/.claude-code-image/history.json`:
```json
{
  "timestamp": "2026-01-17T14:32:10Z",
  "service": "gpt",
  "model": "gpt-image-1.5",
  "type": "edit",
  "prompt": "Add a wizard hat to the person",
  "source_image": "/Users/me/photo.jpg",
  "mask_used": false,
  "output_path": "~/Pictures/claude-code-image/gpt_edit_2026-01-17_143210.png",
  "size": "square",
  "quality": "high",
  "format": "png"
}
```

### 12. Return Result

Display:
- The edited image
- The file path where it was saved
- A comparison note (original vs edited)

## Edit Types

### Reference Image Editing
Use the source image as a reference for style, composition, or content while applying the edit instructions.

### Inpainting (with Mask)
Edit only specific regions of the image:
- White areas in mask = regions to edit
- Black areas in mask = regions to preserve
- Gray areas = partial editing

### Style Transfer
Apply artistic styles to the image:
- "Make it look like a Van Gogh painting"
- "Convert to anime style"
- "Apply cyberpunk aesthetic"

## Examples

**Simple edit:**
```
/claude-code-image:edit
> Image: /Users/me/portrait.jpg
> Edit: Add sunglasses to the person
```

**Inpainting with mask:**
```
/claude-code-image:edit
> Image: /Users/me/landscape.jpg
> Edit: Replace the sky with a dramatic sunset
> Mask: /Users/me/sky-mask.png
```

**Style transfer:**
```
/claude-code-image:edit
> Image: /Users/me/photo.jpg
> Edit: Transform this into a Studio Ghibli style illustration
```
