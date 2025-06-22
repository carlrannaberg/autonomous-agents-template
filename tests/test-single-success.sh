#!/bin/bash

# Test a single successful run-agent execution
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

test_single_success() {
    # Create test files
    mkdir -p issues plans
    echo "# Test Issue" > issues/1-test.md
    echo "# Test Plan" > plans/plan_1-test.md
    cat > todo.md << 'EOF'
- [ ] **[Issue #1]** Test Issue - `issues/1-test.md`
EOF

    echo "Before:"
    cat todo.md
    
    # Create mock and run agent
    create_mock_claude
    bash "$RUN_AGENT_SCRIPT"
    
    echo "After:"
    cat todo.md
    
    # Check if issue was marked complete
    local todo_content=$(cat "todo.md")
    assert_contains "$todo_content" "- [x] **[Issue #1]** Test Issue - \`issues/1-test.md\`" "Issue should be marked complete"
}

echo "=== Testing Single Success Case ==="
run_test test_single_success "Single successful agent execution"