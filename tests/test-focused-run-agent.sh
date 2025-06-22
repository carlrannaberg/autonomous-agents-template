#!/bin/bash

# Test just the successful cases from run-agent tests
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

# Create mock Claude with accurate format
create_mock_claude() {
    local success=${1:-true}
    
    cat > claude << EOF
#!/bin/bash
if [[ "\$*" == *"stream-json"* ]]; then
    if [[ "$success" == "true" ]]; then
        echo '{"type":"text","text":"Starting task execution..."}'
        echo '{"type":"text","text":"Task completed successfully."}'
        echo '{"type":"text","text":"All tests passed."}'
        echo '{"type":"result","subtype":"success","is_error":false}'
        exit 0
    else
        echo '{"type":"text","text":"Starting task execution..."}'
        echo '{"type":"text","text":"Task failed with error"}'
        echo '{"type":"result","subtype":"error","is_error":true}'
        exit 1
    fi
fi
echo "Task completed"
exit 0
EOF
    chmod +x claude
    export PATH="$PWD:$PATH"
}

test_claude_execution_success() {
    # Setup files
    cat > todo.md << 'EOF'
# Todo List

- [ ] **[Issue #1]** Test Issue - `issues/1-test.md`
EOF

    mkdir -p issues plans
    echo "# Test Issue" > "issues/1-test.md"
    echo "# Test Plan" > "plans/plan_1-test.md"
    
    # Mock successful Claude
    create_mock_claude true
    
    # Run agent
    bash "$RUN_AGENT_SCRIPT"
    
    # Check issue is marked complete
    local todo_content=$(cat "todo.md")
    assert_contains "$todo_content" "- [x] **[Issue #1]** Test Issue - \`issues/1-test.md\`" "Issue should be marked complete after successful execution"
}

test_claude_execution_failure() {
    # Setup files
    cat > todo.md << 'EOF'
# Todo List

- [ ] **[Issue #1]** Test Issue - `issues/1-test.md`
EOF

    mkdir -p issues plans
    echo "# Test Issue" > "issues/1-test.md"
    echo "# Test Plan" > "plans/plan_1-test.md"
    
    # Mock failed Claude
    create_mock_claude false
    
    # Run agent - should fail
    assert_exit_code 1 "bash '$RUN_AGENT_SCRIPT'" "Should exit with error when Claude execution fails"
    
    # Check issue remains unchecked
    local todo_content=$(cat "todo.md")
    assert_contains "$todo_content" "- [ ] **[Issue #1]** Test Issue - \`issues/1-test.md\`" "Issue should remain unchecked after failed execution"
}

echo "=== Testing Focused Run Agent Cases ==="
run_test test_claude_execution_success "Successful Claude execution"
run_test test_claude_execution_failure "Failed Claude execution"