#!/bin/bash
# generate-gpt.sh - Generate images using OpenAI GPT Image API
#
# Usage: generate-gpt.sh <model> <prompt> <size> <quality> <format> <background> <output_path>
#
# Arguments:
#   model       - dall-e-3, dall-e-2, gpt-image-1, or gpt-image-1-mini
#   prompt      - Text prompt for image generation
#   size        - 1024x1024, 1024x1792, or 1792x1024 (dall-e-3)
#   quality     - standard, hd (dall-e-3) or low, medium, high, auto (gpt-image)
#   format      - png, jpeg, or webp (gpt-image only, ignored for dall-e)
#   background  - transparent or opaque (gpt-image only, ignored for dall-e)
#   output_path - Full path where to save the generated image

set -e

MODEL="$1"
PROMPT="$2"
SIZE="$3"
QUALITY="$4"
FORMAT="$5"
BACKGROUND="$6"
OUTPUT_PATH="$7"

# Validate required arguments
if [ -z "$MODEL" ] || [ -z "$PROMPT" ] || [ -z "$OUTPUT_PATH" ]; then
    echo "Error: Missing required arguments"
    echo "Usage: generate-gpt.sh <model> <prompt> <size> <quality> <format> <background> <output_path>"
    exit 1
fi

# Check for API key
if [ -z "$OPENAI_API_KEY" ]; then
    echo "Error: OPENAI_API_KEY environment variable is not set"
    exit 1
fi

# Set defaults
SIZE="${SIZE:-1024x1024}"
QUALITY="${QUALITY:-auto}"
FORMAT="${FORMAT:-png}"
BACKGROUND="${BACKGROUND:-opaque}"

# Build the request JSON based on model type
if [[ "$MODEL" == dall-e-* ]]; then
    # DALL-E models use different parameters
    # Map quality for DALL-E (only dall-e-3 supports quality)
    if [ "$MODEL" = "dall-e-3" ]; then
        case "$QUALITY" in
            hd|high) API_QUALITY="hd" ;;
            *) API_QUALITY="standard" ;;
        esac
        REQUEST_JSON=$(cat <<EOF
{
  "model": "$MODEL",
  "prompt": "$PROMPT",
  "n": 1,
  "size": "$SIZE",
  "quality": "$API_QUALITY",
  "response_format": "b64_json"
}
EOF
)
    else
        # dall-e-2 doesn't support quality
        REQUEST_JSON=$(cat <<EOF
{
  "model": "$MODEL",
  "prompt": "$PROMPT",
  "n": 1,
  "size": "$SIZE",
  "response_format": "b64_json"
}
EOF
)
    fi
else
    # GPT-Image models (gpt-image-1, etc.) use extended parameters
    case "$QUALITY" in
        low) API_QUALITY="low" ;;
        medium) API_QUALITY="medium" ;;
        high) API_QUALITY="high" ;;
        auto|*) API_QUALITY="auto" ;;
    esac

    if [ "$BACKGROUND" = "transparent" ]; then
        REQUEST_JSON=$(cat <<EOF
{
  "model": "$MODEL",
  "prompt": "$PROMPT",
  "n": 1,
  "size": "$SIZE",
  "quality": "$API_QUALITY",
  "output_format": "$FORMAT",
  "background": "transparent",
  "response_format": "b64_json"
}
EOF
)
    else
        REQUEST_JSON=$(cat <<EOF
{
  "model": "$MODEL",
  "prompt": "$PROMPT",
  "n": 1,
  "size": "$SIZE",
  "quality": "$API_QUALITY",
  "output_format": "$FORMAT",
  "response_format": "b64_json"
}
EOF
)
    fi
fi

# Make the API request
RESPONSE=$(curl -s -X POST "https://api.openai.com/v1/images/generations" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d "$REQUEST_JSON")

# Check for errors in response
if echo "$RESPONSE" | grep -q '"error"'; then
    ERROR_MSG=$(echo "$RESPONSE" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('error', {}).get('message', 'Unknown error'))
except:
    print('Failed to parse error')
" 2>/dev/null)
    echo "Error from OpenAI API: $ERROR_MSG"
    exit 1
fi

# Extract base64 image data using Python for reliable JSON parsing
IMAGE_DATA=$(echo "$RESPONSE" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    images = data.get('data', [])
    if images and 'b64_json' in images[0]:
        print(images[0]['b64_json'])
except Exception as e:
    pass
" 2>/dev/null)

if [ -z "$IMAGE_DATA" ]; then
    echo "Error: No image data in response"
    echo "Response: $RESPONSE"
    exit 1
fi

# Create output directory if it doesn't exist
OUTPUT_DIR=$(dirname "$OUTPUT_PATH")
mkdir -p "$OUTPUT_DIR"

# Decode and save the image
echo "$IMAGE_DATA" | base64 -d > "$OUTPUT_PATH"

# Verify the file was created
if [ -f "$OUTPUT_PATH" ]; then
    echo "Image saved to: $OUTPUT_PATH"
else
    echo "Error: Failed to save image"
    exit 1
fi
