#!/bin/bash
# generate-nanobanana.sh - Generate images using Google Gemini (Nanobanana) API
#
# Usage: generate-nanobanana.sh <model> <prompt> <aspect_ratio> <output_path>
#
# Arguments:
#   model        - gemini-2.5-flash-image or gemini-3-pro-image-preview
#   prompt       - Text prompt for image generation
#   aspect_ratio - 1:1, 9:16, or 16:9
#   output_path  - Full path where to save the generated image

set -e

MODEL="$1"
PROMPT="$2"
ASPECT_RATIO="$3"
OUTPUT_PATH="$4"

# Validate required arguments
if [ -z "$MODEL" ] || [ -z "$PROMPT" ] || [ -z "$OUTPUT_PATH" ]; then
    echo "Error: Missing required arguments"
    echo "Usage: generate-nanobanana.sh <model> <prompt> <aspect_ratio> <output_path>"
    exit 1
fi

# Check for API key
if [ -z "$GEMINI_API_KEY" ]; then
    echo "Error: GEMINI_API_KEY environment variable is not set"
    exit 1
fi

# Set defaults
ASPECT_RATIO="${ASPECT_RATIO:-1:1}"

# Build the request JSON
# Gemini uses generateContent endpoint with image generation config
REQUEST_JSON=$(cat <<EOF
{
  "contents": [
    {
      "parts": [
        {
          "text": "$PROMPT"
        }
      ]
    }
  ],
  "generationConfig": {
    "responseModalities": ["TEXT", "IMAGE"],
    "responseMimeType": "text/plain"
  }
}
EOF
)

# Make the API request
API_URL="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"

RESPONSE=$(curl -s -X POST "$API_URL" \
    -H "Content-Type: application/json" \
    -H "x-goog-api-key: $GEMINI_API_KEY" \
    -d "$REQUEST_JSON")

# Check for errors in response
if echo "$RESPONSE" | grep -q '"error"'; then
    ERROR_MSG=$(echo "$RESPONSE" | grep -o '"message":"[^"]*"' | head -1 | cut -d'"' -f4)
    echo "Error from Gemini API: $ERROR_MSG"
    echo "Full response: $RESPONSE"
    exit 1
fi

# Extract base64 image data from the response
# Gemini returns image in candidates[0].content.parts[].inlineData.data
IMAGE_DATA=$(echo "$RESPONSE" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    candidates = data.get('candidates', [])
    if candidates:
        parts = candidates[0].get('content', {}).get('parts', [])
        for part in parts:
            if 'inlineData' in part:
                print(part['inlineData']['data'])
                break
except Exception as e:
    print('', file=sys.stderr)
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
