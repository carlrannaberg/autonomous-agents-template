#!/bin/bash

# Quick test to verify Claude mock fix works
source "$(dirname "$0")/test-framework.sh"

SCRIPT_DIR="$(dirname "$0")/../scripts"
RUN_AGENT_SCRIPT="$SCRIPT_DIR/run-agent.sh"

# Setup cleanup
cleanup_test_artifacts() {
    rm -rf issues plans todo.md claude .claude_call_count
    export PATH="$ORIGINAL_PATH"
}
after_each cleanup_test_artifacts
ORIGINAL_PATH="$PATH"

# Create mock Claude with correct JSON format (no spaces)
create_mock_claude() {
    cat > claude << 'EOF'
#!/bin/bash
if [[ "$*" == *"stream-json"* ]]; then
    echo '{"type":"text","text":"Starting task execution..."}'
    echo '{"type":"text","text":"Task completed successfully."}'
    echo '{"type":"result","subtype":"success","is_error":false}'
    exit 0
fi
echo "Task completed"
exit 0
EOF
    chmod +x claude
    export PATH="$PWD:$PATH"
}

test_claude_success_detection() {
    # Create simple test files
    mkdir -p issues plans
    echo "# Test Issue" > issues/1-test.md
    echo "# Test Plan" > plans/plan_1-test.md
    cat > todo.md << 'EOF'
- [ ] **[Issue #1]** Test Issue - `issues/1-test.md`
EOF

    # Create mock and test just the success detection part
    create_mock_claude
    
    # Run agent but capture output to see if success is detected
    output=$(bash "$RUN_AGENT_SCRIPT" 2>&1)
    
    # Check if success was detected
    if echo "$output" | grep -q "✅ Agent completed the issue successfully"; then
        echo "✅ SUCCESS: Claude mock fix is working!"
        return 0
    else
        echo "❌ FAILURE: Success not detected"
        echo "Output snippet:"
        echo "$output" | tail -20
        return 1
    fi
}

echo "=== Testing Claude Mock Fix ==="
run_test test_claude_success_detection "Claude success detection"