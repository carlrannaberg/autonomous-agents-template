#!/bin/bash

# Create mock Claude
cat > claude << 'EOF'
#!/bin/bash
echo '{"type": "text", "text": "Starting task execution..."}'
echo '{"type": "text", "text": "Task completed successfully."}'
echo '{"type": "result", "is_error": false}'
exit 0
EOF
chmod +x claude

# Create test files
mkdir -p issues plans
echo "# Test Issue" > issues/1-test.md
echo "# Test Plan" > plans/plan_1-test.md
cat > todo.md << 'EOF'
- [ ] **[Issue #1]** Test Issue - `issues/1-test.md`
EOF

# Test Claude directly
echo "=== Testing Claude directly ==="
export PATH="$PWD:$PATH"
echo '{"test": "input"}' | ./claude -p "test" --output-format stream-json

echo
echo "=== Testing format_claude_output function ==="

# Extract and test the format_claude_output function
temp_file=$(mktemp)
echo '{"type": "text", "text": "Starting task execution..."}'
echo '{"type": "text", "text": "Task completed successfully."}'  
echo '{"type": "result", "is_error": false}'

echo "Output logged to: $temp_file"
echo "Last line check:"
LAST_LINE=$(tail -n 1 "$temp_file")
echo "Last line: '$LAST_LINE'"
if echo "$LAST_LINE" | grep -q '"type":"result"' && echo "$LAST_LINE" | grep -q '"is_error":false'; then
    echo "SUCCESS: Success pattern detected"
else
    echo "FAILURE: Success pattern NOT detected"
fi

rm -f "$temp_file"