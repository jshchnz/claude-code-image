---
description: View recently generated images and their details
---

# History

View recently generated images and their details.

## Usage

```
/claude-code-image:history
```

## Instructions

When the user invokes this command, display the generation history:

### 1. Load History File

Read the history from `~/.claude-code-image/history.json`.

If the file doesn't exist or is empty, display:
"No generation history found. Generate your first image with `/claude-code-image:generate`!"

### 2. Display History

Show the most recent 10 generations in a formatted table:

"# Image Generation History

| # | Date | Service | Model | Type | Prompt | Output |
|---|------|---------|-------|------|--------|--------|
| 1 | 2026-01-17 14:30 | Nanobanana | flash | generate | a cyberpunk city... | ~/Pictures/... |
| 2 | 2026-01-17 14:25 | GPT | 1.5 | edit | Add wizard hat... | ~/Pictures/... |
| ... | ... | ... | ... | ... | ... | ... |

*Showing last 10 of [total] generations*"

### 3. Format Guidelines

- **Date**: Format as `YYYY-MM-DD HH:MM`
- **Service**: Shorten to "GPT" or "Nanobanana"
- **Model**: Use short names (flash, pro, 1.5, 1, mini)
- **Type**: "generate" or "edit"
- **Prompt**: Truncate to ~20 characters with "..."
- **Output**: Show truncated file path

### 4. Interactive Options

After displaying the history, offer options:

"**Options:**
1. **View details** - Enter a number (1-10) to see full details of a generation
2. **Open file** - Type 'open [number]' to open the image file
3. **Clear history** - Type 'clear' to clear all history
4. **Exit** - Press Enter to exit"

### 5. View Details

If the user selects a number, show full details:

"**Generation #[n] Details**

- **Timestamp**: 2026-01-17T14:30:52Z
- **Service**: Nanobanana (Google Gemini)
- **Model**: gemini-2.5-flash-image
- **Type**: generate
- **Prompt**: a cyberpunk city at night with neon lights and flying cars
- **Size**: square (1024x1024)
- **Quality**: auto
- **Format**: png
- **Transparent**: No
- **Output**: ~/Pictures/claude-code-image/nanobanana_flash_2026-01-17_143052.png"

Also display the image if it still exists at the output path.

### 6. Open File

If the user types 'open [number]', open the image:
```bash
open "[output_path]"
```

### 7. Clear History

If the user types 'clear':
1. Ask for confirmation: "Are you sure you want to clear all history? This cannot be undone. (yes/no)"
2. If confirmed, reset `~/.claude-code-image/history.json` to `[]`
3. Display: "History cleared."

Note: This only clears the history log, not the actual image files.

## History File Format

The history file (`~/.claude-code-image/history.json`) is an array of generation records:

```json
[
  {
    "timestamp": "2026-01-17T14:30:52Z",
    "service": "nanobanana",
    "model": "gemini-2.5-flash-image",
    "type": "generate",
    "prompt": "a cyberpunk city at night with neon lights",
    "output_path": "~/Pictures/claude-code-image/nanobanana_flash_2026-01-17_143052.png",
    "size": "square",
    "quality": "auto",
    "format": "png",
    "transparent": false
  },
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
]
```

## Storage Notes

- History is stored locally in `~/.claude-code-image/history.json`
- Maximum recommended history entries: 1000 (older entries can be pruned)
- History records metadata only, not the actual images
- Images are stored in the configured output directory
