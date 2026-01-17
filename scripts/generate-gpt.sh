#!/bin/bash
# generate-gpt.sh - Generate images using OpenAI GPT Image API
#
# Usage: generate-gpt.sh <model> <prompt> <size> <quality> <format> <background> <output_path>
#
# Arguments:
#   model       - gpt-image-1.5, gpt-image-1, or gpt-image-1-mini
#   prompt      - Text prompt for image generation
#   size        - 1024x1024, 1024x1536, or 1536x1024
#   quality     - low, medium, high, or auto
#   format      - png, jpeg, or webp
#   background  - transparent or opaque
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

# Map quality to API values
case "$QUALITY" in
    low) API_QUALITY="low" ;;
    medium) API_QUALITY="medium" ;;
    high) API_QUALITY="high" ;;
    auto|*) API_QUALITY="auto" ;;
esac

# Build the request JSON
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

# Make the API request
RESPONSE=$(curl -s -X POST "https://api.openai.com/v1/images/generations" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d "$REQUEST_JSON")

# Check for errors in response
if echo "$RESPONSE" | grep -q '"error"'; then
    ERROR_MSG=$(echo "$RESPONSE" | grep -o '"message":"[^"]*"' | head -1 | cut -d'"' -f4)
    echo "Error from OpenAI API: $ERROR_MSG"
    exit 1
fi

# Extract base64 image data
IMAGE_DATA=$(echo "$RESPONSE" | grep -o '"b64_json":"[^"]*"' | head -1 | cut -d'"' -f4)

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
