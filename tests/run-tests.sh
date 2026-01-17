#!/bin/bash
# run-tests.sh - Simple test runner for claude-code-image plugin
# Note: We don't use set -e because tests intentionally check for failures

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"

PASSED=0
FAILED=0

# Colors (if terminal supports them)
if [ -t 1 ]; then
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    NC='\033[0m'
else
    GREEN=''
    RED=''
    NC=''
fi

pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASSED++))
}

fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAILED++))
}

echo "Running tests..."
echo ""

# Export plugin directory for test scripts
export PLUGIN_DIR

# Run all test-*.sh files
for test_file in "$SCRIPT_DIR"/test-*.sh; do
    if [ -f "$test_file" ]; then
        source "$test_file"
    fi
done

echo ""
echo "----------------------------------------"
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}Tests: $PASSED passed, $FAILED failed${NC}"
    exit 0
else
    echo -e "${RED}Tests: $PASSED passed, $FAILED failed${NC}"
    exit 1
fi
