#!/bin/bash
# test-scripts.sh - Tests for shell script validation

SCRIPTS_DIR="$PLUGIN_DIR/scripts"

# ============================================
# Script Existence Tests
# ============================================

if [ -x "$SCRIPTS_DIR/generate-gpt.sh" ]; then
    pass "generate-gpt.sh exists and is executable"
else
    fail "generate-gpt.sh exists and is executable"
fi

if [ -x "$SCRIPTS_DIR/generate-nanobanana.sh" ]; then
    pass "generate-nanobanana.sh exists and is executable"
else
    fail "generate-nanobanana.sh exists and is executable"
fi

if [ -x "$SCRIPTS_DIR/edit-gpt.sh" ]; then
    pass "edit-gpt.sh exists and is executable"
else
    fail "edit-gpt.sh exists and is executable"
fi

if [ -x "$SCRIPTS_DIR/edit-nanobanana.sh" ]; then
    pass "edit-nanobanana.sh exists and is executable"
else
    fail "edit-nanobanana.sh exists and is executable"
fi

# ============================================
# Argument Validation Tests
# ============================================

# Test: generate-gpt.sh fails without arguments
if "$SCRIPTS_DIR/generate-gpt.sh" >/dev/null 2>&1; then
    fail "generate-gpt.sh fails without arguments"
else
    pass "generate-gpt.sh fails without arguments"
fi

# Test: generate-nanobanana.sh fails without arguments
if "$SCRIPTS_DIR/generate-nanobanana.sh" >/dev/null 2>&1; then
    fail "generate-nanobanana.sh fails without arguments"
else
    pass "generate-nanobanana.sh fails without arguments"
fi

# Test: edit-gpt.sh fails without arguments
if "$SCRIPTS_DIR/edit-gpt.sh" >/dev/null 2>&1; then
    fail "edit-gpt.sh fails without arguments"
else
    pass "edit-gpt.sh fails without arguments"
fi

# Test: edit-nanobanana.sh fails without arguments
if "$SCRIPTS_DIR/edit-nanobanana.sh" >/dev/null 2>&1; then
    fail "edit-nanobanana.sh fails without arguments"
else
    pass "edit-nanobanana.sh fails without arguments"
fi

# ============================================
# API Key Validation Tests
# ============================================

# Test: generate-gpt.sh fails without OPENAI_API_KEY
# Provide args but unset API key
if OPENAI_API_KEY="" "$SCRIPTS_DIR/generate-gpt.sh" "model" "prompt" "1024x1024" "auto" "png" "opaque" "/tmp/test.png" >/dev/null 2>&1; then
    fail "generate-gpt.sh fails without OPENAI_API_KEY"
else
    pass "generate-gpt.sh fails without OPENAI_API_KEY"
fi

# Test: generate-nanobanana.sh fails without GEMINI_API_KEY
if GEMINI_API_KEY="" "$SCRIPTS_DIR/generate-nanobanana.sh" "model" "prompt" "1:1" "/tmp/test.png" >/dev/null 2>&1; then
    fail "generate-nanobanana.sh fails without GEMINI_API_KEY"
else
    pass "generate-nanobanana.sh fails without GEMINI_API_KEY"
fi

# Test: edit-gpt.sh fails without OPENAI_API_KEY
if OPENAI_API_KEY="" "$SCRIPTS_DIR/edit-gpt.sh" "model" "prompt" "base64data" "none" "1024x1024" "auto" "png" "/tmp/test.png" >/dev/null 2>&1; then
    fail "edit-gpt.sh fails without OPENAI_API_KEY"
else
    pass "edit-gpt.sh fails without OPENAI_API_KEY"
fi

# Test: edit-nanobanana.sh fails without GEMINI_API_KEY
if GEMINI_API_KEY="" "$SCRIPTS_DIR/edit-nanobanana.sh" "model" "prompt" "base64data" "1:1" "/tmp/test.png" >/dev/null 2>&1; then
    fail "edit-nanobanana.sh fails without GEMINI_API_KEY"
else
    pass "edit-nanobanana.sh fails without GEMINI_API_KEY"
fi
