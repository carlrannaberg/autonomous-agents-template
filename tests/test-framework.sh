#!/bin/bash

# Simple test framework for shell scripts
# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test setup and teardown
TEST_DIR=""
ORIGINAL_DIR=""
AFTER_EACH_CALLBACKS=()
AFTER_ALL_CALLBACKS=()

# Register cleanup callbacks
after_each() {
    AFTER_EACH_CALLBACKS+=("$1")
}

after_all() {
    AFTER_ALL_CALLBACKS+=("$1")
}

# Initialize test environment
init_test() {
    ORIGINAL_DIR=$(pwd)
    TEST_DIR=$(mktemp -d)
    cp -R "$ORIGINAL_DIR/." "$TEST_DIR"
    cd "$TEST_DIR"
    echo "Test environment: $TEST_DIR"
}

# Run after each callbacks
run_after_each() {
    for callback in "${AFTER_EACH_CALLBACKS[@]}"; do
        eval "$callback" || echo "Warning: after_each callback failed: $callback"
    done
}

# Run after all callbacks
run_after_all() {
    for callback in "${AFTER_ALL_CALLBACKS[@]}"; do
        eval "$callback" || echo "Warning: after_all callback failed: $callback"
    done
}

# Cleanup test environment
cleanup_test() {
    run_after_all
    cd "$ORIGINAL_DIR"
    if [[ -n "$TEST_DIR" && -d "$TEST_DIR" ]]; then
        rm -rf "$TEST_DIR"
    fi
}

# Assert functions
run_test_suite() {
    local test_file="$1"
    local suite_name="$2"
    
    echo -e "${YELLOW}Running: $suite_name${NC}"
    echo "----------------------------------------"
    
    TOTAL_SUITES=$((TOTAL_SUITES + 1))
    
    # Capture test output and results
    if ( init_test && source "$test_file" && cleanup_test ); then
        PASSED_SUITES=$((PASSED_SUITES + 1))
        echo -e "${GREEN}✓ $suite_name PASSED${NC}"
    else
        FAILED_SUITES=$((FAILED_SUITES + 1))
        echo -e "${RED}✗ $suite_name FAILED${NC}"
    fi
    
    echo
    echo
}

