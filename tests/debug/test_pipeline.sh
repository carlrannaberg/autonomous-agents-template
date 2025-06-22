#!/bin/bash

# Copy the scripts we need
cp ../../scripts/run-agent.sh .

# Create mock Claude that matches the expected command line
cat > claude << 'EOF'
#!/bin/bash
# Debug: Show all arguments
echo "DEBUG: Claude called with: $*" >&2

# Check if this is the expected streaming format
if [[ "$*" == *"stream-json"* ]]; then
    echo '{"type": "text", "text": "Starting task execution..."}'
    echo '{"type": "text", "text": "Task completed successfully."}'
    echo '{"type": "result", "is_error": false}'
    exit 0
else
    echo "DEBUG: Not a streaming request" >&2
    echo "Task completed"
    exit 0
fi
EOF
chmod +x claude

# Create test files
mkdir -p issues plans
echo "# Test Issue" > issues/1-test.md
echo "# Test Plan" > plans/plan_1-test.md
cat > todo.md << 'EOF'
- [ ] **[Issue #1]** Test Issue - `issues/1-test.md`
EOF

# Test the pipeline
export PATH="$PWD:$PATH"
echo "=== Testing full pipeline ==="

# Extract the format_claude_output function and test it
source ./run-agent.sh

# Create a temp file
temp_file=$(mktemp)

# Test the format function directly
echo "Testing format_claude_output with mock data:"
{
    echo '{"type": "text", "text": "Starting task execution..."}'
    echo '{"type": "text", "text": "Task completed successfully."}'
    echo '{"type": "result", "is_error": false}'
} | format_claude_output "$temp_file"

echo ""
echo "Contents of temp file:"
cat "$temp_file"
echo ""
echo "Last line:"
LAST_LINE=$(tail -n 1 "$temp_file")
echo "'$LAST_LINE'"

if echo "$LAST_LINE" | grep -q '"type":"result"' && echo "$LAST_LINE" | grep -q '"is_error":false'; then
    echo "✅ SUCCESS: Pattern detected correctly"
else
    echo "❌ FAILURE: Pattern not detected"
fi

rm -f "$temp_file"