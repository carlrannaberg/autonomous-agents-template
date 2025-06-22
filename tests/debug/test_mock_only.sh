#!/bin/bash

# Create exactly the mock from our test
cat > claude << 'EOF'
#!/bin/bash
# Mock Claude CLI for testing

if [[ "$*" == *"--help"* ]]; then
    echo "Mock Claude CLI"
    exit 0
fi

# Check if this is a streaming request (--output-format stream-json)
if [[ "$*" == *"stream-json"* ]]; then
    echo '{"type": "text", "text": "Starting task execution..."}'
    echo '{"type": "text", "text": "Task completed successfully."}'
    echo '{"type": "text", "text": "All tests passed."}'
    echo '{"type": "result", "is_error": false}'
    exit 0
else
    echo '{"type": "text", "text": "Starting task execution..."}'
    echo '{"type": "text", "text": "Task failed with error"}'
    echo '{"type": "result", "is_error": true}'
    exit 1
fi

# Regular non-streaming request
echo "Task completed successfully."
exit 0
EOF

chmod +x claude
export PATH="$PWD:$PATH"

# Test the exact command that run-agent.sh uses
echo "=== Testing exact command ==="
echo "some input" | ./claude -p "test prompt" --dangerously-skip-permissions --output-format stream-json --verbose

echo ""
echo "Exit code: $?"

echo ""
echo "=== Testing success detection pattern ==="
OUTPUT=$(echo "some input" | ./claude -p "test prompt" --dangerously-skip-permissions --output-format stream-json --verbose)
echo "Full output:"
echo "$OUTPUT"
echo ""

LAST_LINE=$(echo "$OUTPUT" | tail -n 1)
echo "Last line: '$LAST_LINE'"

if echo "$LAST_LINE" | grep -q '"type":"result"' && echo "$LAST_LINE" | grep -q '"is_error":false'; then
    echo "✅ SUCCESS pattern detected"
else
    echo "❌ FAILURE pattern not detected"
    echo "Checking parts:"
    if echo "$LAST_LINE" | grep -q '"type":"result"'; then
        echo "  ✅ Found type:result"
    else
        echo "  ❌ Missing type:result"
    fi
    if echo "$LAST_LINE" | grep -q '"is_error":false'; then
        echo "  ✅ Found is_error:false"
    else
        echo "  ❌ Missing is_error:false"
    fi
fi