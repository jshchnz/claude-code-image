#!/bin/bash
# edit-gpt.sh - Edit images using OpenAI GPT Image API
#
# Usage: edit-gpt.sh <model> <prompt> <image_base64> <mask_base64> <size> <quality> <format> <output_path>
#
# Arguments:
#   model        - gpt-image-1.5, gpt-image-1, or gpt-image-1-mini
#   prompt       - Text prompt describing the edit
#   image_base64 - Base64-encoded source image
#   mask_base64  - Base64-encoded mask image (or "none" for no mask)
#   size         - 1024x1024, 1024x1536, or 1536x1024
#   quality      - low, medium, high, or auto
#   format       - png, jpeg, or webp
#   output_path  - Full path where to save the edited image

set -e

MODEL="$1"
PROMPT="$2"
IMAGE_BASE64="$3"
MASK_BASE64="$4"
SIZE="$5"
QUALITY="$6"
FORMAT="$7"
OUTPUT_PATH="$8"

# Validate required arguments
if [ -z "$MODEL" ] || [ -z "$PROMPT" ] || [ -z "$IMAGE_BASE64" ] || [ -z "$OUTPUT_PATH" ]; then
    echo "Error: Missing required arguments"
    echo "Usage: edit-gpt.sh <model> <prompt> <image_base64> <mask_base64> <size> <quality> <format> <output_path>"
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
MASK_BASE64="${MASK_BASE64:-none}"

# Map quality to API values
case "$QUALITY" in
    low) API_QUALITY="low" ;;
    medium) API_QUALITY="medium" ;;
    high) API_QUALITY="high" ;;
    auto|*) API_QUALITY="auto" ;;
esac

# Create temporary files for the image data
TEMP_DIR=$(mktemp -d)
IMAGE_FILE="$TEMP_DIR/image.png"

# Decode the base64 image to a file
echo "$IMAGE_BASE64" | base64 -d > "$IMAGE_FILE"

# Build the curl command with multipart form data
if [ "$MASK_BASE64" != "none" ] && [ -n "$MASK_BASE64" ]; then
    # With mask
    MASK_FILE="$TEMP_DIR/mask.png"
    echo "$MASK_BASE64" | base64 -d > "$MASK_FILE"

    RESPONSE=$(curl -s -X POST "https://api.openai.com/v1/images/edits" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -F "model=$MODEL" \
        -F "image=@$IMAGE_FILE" \
        -F "mask=@$MASK_FILE" \
        -F "prompt=$PROMPT" \
        -F "n=1" \
        -F "size=$SIZE" \
        -F "response_format=b64_json")
else
    # Without mask
    RESPONSE=$(curl -s -X POST "https://api.openai.com/v1/images/edits" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -F "model=$MODEL" \
        -F "image=@$IMAGE_FILE" \
        -F "prompt=$PROMPT" \
        -F "n=1" \
        -F "size=$SIZE" \
        -F "response_format=b64_json")
fi

# Clean up temp files
rm -rf "$TEMP_DIR"

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
