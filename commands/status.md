---
description: Check API key status and current configuration
---

# Status

Check the current configuration status and API key availability.

## Usage

```
/claude-code-image:status
```

## Instructions

When the user invokes this command, display a comprehensive status report:

### 1. Check API Keys

Check environment variables for API keys:

```bash
# Check OpenAI
if [ -n "$OPENAI_API_KEY" ]; then
  echo "OpenAI: Configured"
else
  echo "OpenAI: Not configured"
fi

# Check Gemini
if [ -n "$GEMINI_API_KEY" ]; then
  echo "Gemini: Configured"
else
  echo "Gemini: Not configured"
fi
```

### 2. Load Configuration

Read `~/.claude-code-image/config.json` if it exists.

### 3. Check History

Count entries in `~/.claude-code-image/history.json`.

### 4. Check Output Directory

Verify the output directory exists and count files in it.

### 5. Display Status Report

"# claude-code-image Status

## API Keys

| Service | Status | Get Key |
|---------|--------|---------|
| OpenAI (GPT Image) | [Configured] or [Not configured] | https://platform.openai.com/api-keys |
| Google (Nanobanana) | [Configured] or [Not configured] | https://aistudio.google.com/apikey |

## Current Configuration

| Setting | Value |
|---------|-------|
| Default Service | [service or 'Not set'] |
| Default GPT Model | [model or 'Not set'] |
| Default Nanobanana Model | [model or 'Not set'] |
| Output Directory | [path or 'Not set'] |
| Default Size | [size or 'Not set'] |
| Default Quality | [quality or 'Not set'] |
| Default Format | [format or 'Not set'] |

## Statistics

| Metric | Value |
|--------|-------|
| Total Images Generated | [count from history] |
| Images in Output Folder | [count from directory] |
| Config File | [Exists/Missing] |
| History File | [Exists/Missing] |

## File Locations

- **Config**: `~/.claude-code-image/config.json`
- **History**: `~/.claude-code-image/history.json`
- **Output**: `[configured output directory]`

---

**Quick Actions:**
- Run `/claude-code-image:configure` to update settings
- Run `/claude-code-image:generate <prompt>` to create an image
- Run `/claude-code-image:history` to view past generations"

### Status Icons

Use these indicators for status:
- Configured/Exists
- Not configured/Missing

### Handle Missing Configuration

If config file doesn't exist:
"Configuration not found. Run `/claude-code-image:configure` to set up the plugin."

If only some settings are missing, show "Not set" for those fields.

## Example Output

"# claude-code-image Status

## API Keys

| Service | Status | Get Key |
|---------|--------|---------|
| OpenAI (GPT Image) | Configured | https://platform.openai.com/api-keys |
| Google (Nanobanana) | Not configured | https://aistudio.google.com/apikey |

## Current Configuration

| Setting | Value |
|---------|-------|
| Default Service | nanobanana |
| Default GPT Model | gpt-image-1.5 |
| Default Nanobanana Model | gemini-2.5-flash-image |
| Output Directory | ~/Pictures/claude-code-image |
| Default Size | square |
| Default Quality | auto |
| Default Format | png |

## Statistics

| Metric | Value |
|--------|-------|
| Total Images Generated | 42 |
| Images in Output Folder | 38 |
| Config File | Exists |
| History File | Exists |

## File Locations

- **Config**: `~/.claude-code-image/config.json`
- **History**: `~/.claude-code-image/history.json`
- **Output**: `~/Pictures/claude-code-image`

---

**Quick Actions:**
- Run `/claude-code-image:configure` to update settings
- Run `/claude-code-image:generate <prompt>` to create an image
- Run `/claude-code-image:history` to view past generations"
