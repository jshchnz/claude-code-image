#!/bin/bash
# edit-nanobanana.sh - Edit images using Google Gemini (Nanobanana) API
#
# Usage: edit-nanobanana.sh <model> <prompt> <image_base64> <aspect_ratio> <output_path>
#
# Arguments:
#   model        - gemini-2.5-flash-image or gemini-3-pro-image-preview
#   prompt       - Text prompt describing the edit
#   image_base64 - Base64-encoded source image
#   aspect_ratio - 1:1, 9:16, or 16:9
#   output_path  - Full path where to save the edited image

set -e

# JSON escaping function to prevent injection
# Uses jq if available, falls back to Python
escape_json_string() {
    local input="$1"
    if command -v jq &>/dev/null; then
        printf '%s' "$input" | jq -Rs '.[:-1]'
    else
        printf '%s' "$input" | python3 -c "import sys,json; print(json.dumps(sys.stdin.read())[1:-1])"
    fi
}

MODEL="$1"
PROMPT="$2"
IMAGE_BASE64="$3"
ASPECT_RATIO="$4"
OUTPUT_PATH="$5"

# Validate required arguments
if [ -z "$MODEL" ] || [ -z "$PROMPT" ] || [ -z "$IMAGE_BASE64" ] || [ -z "$OUTPUT_PATH" ]; then
    echo "Error: Missing required arguments"
    echo "Usage: edit-nanobanana.sh <model> <prompt> <image_base64> <aspect_ratio> <output_path>"
    exit 1
fi

# Check for API key
if [ -z "$GEMINI_API_KEY" ]; then
    echo "Error: GEMINI_API_KEY environment variable is not set"
    exit 1
fi

# Set defaults
ASPECT_RATIO="${ASPECT_RATIO:-1:1}"

# Escape prompt for safe JSON embedding
ESCAPED_PROMPT=$(escape_json_string "$PROMPT")

# Detect image mime type from base64 header or default to png
# Most images will be PNG or JPEG
MIME_TYPE="image/png"
if echo "$IMAGE_BASE64" | head -c 20 | grep -q "/9j/"; then
    MIME_TYPE="image/jpeg"
fi

# Build the request JSON with inline image data
# Gemini accepts images as inlineData in the content parts
# Note: IMAGE_BASE64 is already base64-encoded, safe for JSON embedding
REQUEST_JSON=$(cat <<EOF
{
  "contents": [
    {
      "parts": [
        {
          "inlineData": {
            "mimeType": "$MIME_TYPE",
            "data": "$IMAGE_BASE64"
          }
        },
        {
          "text": "$ESCAPED_PROMPT"
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

# Make the API request (with timeouts to prevent hanging)
API_URL="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"

RESPONSE=$(curl -s --connect-timeout 10 --max-time 120 -X POST "$API_URL" \
    -H "Content-Type: application/json" \
    -H "x-goog-api-key: $GEMINI_API_KEY" \
    -d "$REQUEST_JSON")

# Check for curl errors
CURL_EXIT=$?
if [ $CURL_EXIT -ne 0 ]; then
    case $CURL_EXIT in
        28) echo "Error: Request timed out" ;;
        6)  echo "Error: Could not resolve host" ;;
        7)  echo "Error: Connection refused" ;;
        *)  echo "Error: Network error (curl exit code: $CURL_EXIT)" ;;
    esac
    exit 1
fi

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
