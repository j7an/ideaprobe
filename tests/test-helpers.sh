#!/bin/bash
# IdeaProbe Test Helpers
# Sourced by all test scripts. Provides assertions, lifecycle, and utilities.

# ─── Colors ───────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
NC='\033[0m' # No color

# ─── Global State ─────────────────────────────
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_SKIPPED=0
TESTS_TOTAL=0
TEST_START_TIME=$(date +%s)
VERBOSE=${VERBOSE:-false}
TEST_TMP_DIR=""

# Resolve repo root (tests/ is one level below root)
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# ─── Lifecycle ────────────────────────────────

setup_test() {
    local name="$1"
    echo ""
    echo -e "${BOLD}── $name ──${NC}"
}

pass_test() {
    local description="$1"
    TESTS_PASSED=$((TESTS_PASSED + 1))
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    echo -e "  ${GREEN}✓${NC} $description"
}

fail_test() {
    local description="$1"
    local detail="${2:-}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    echo -e "  ${RED}✗${NC} $description"
    if [ -n "$detail" ]; then
        echo -e "    ${RED}$detail${NC}"
    fi
}

skip_test() {
    local description="$1"
    local reason="${2:-}"
    TESTS_SKIPPED=$((TESTS_SKIPPED + 1))
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    if [ -n "$reason" ]; then
        echo -e "  ${YELLOW}○${NC} $description (skipped: $reason)"
    else
        echo -e "  ${YELLOW}○${NC} $description (skipped)"
    fi
}

print_summary() {
    local end_time=$(date +%s)
    local elapsed=$((end_time - TEST_START_TIME))
    echo ""
    echo -e "${BOLD}═══════════════════════════════════════════${NC}"
    echo -e "  ${GREEN}$TESTS_PASSED passed${NC}, ${RED}$TESTS_FAILED failed${NC}, ${YELLOW}$TESTS_SKIPPED skipped${NC} (${elapsed}s elapsed)"
    echo -e "${BOLD}═══════════════════════════════════════════${NC}"
    echo ""
    if [ "$TESTS_FAILED" -gt 0 ]; then
        return 1
    fi
    return 0
}

# ─── Assertions ───────────────────────────────

assert_contains() {
    local output="$1"
    local expected="$2"
    local description="$3"
    if echo "$output" | grep -q "$expected"; then
        pass_test "$description"
    else
        fail_test "$description" "Expected to contain: $expected"
    fi
}

assert_not_contains() {
    local output="$1"
    local unexpected="$2"
    local description="$3"
    if echo "$output" | grep -q "$unexpected"; then
        fail_test "$description" "Should not contain: $unexpected"
    else
        pass_test "$description"
    fi
}

assert_count() {
    local output="$1"
    local pattern="$2"
    local expected_count="$3"
    local description="$4"
    local actual_count
    actual_count=$(echo "$output" | grep -c "$pattern" || true)
    if [ "$actual_count" -eq "$expected_count" ]; then
        pass_test "$description"
    else
        fail_test "$description" "Expected $expected_count matches, got $actual_count"
    fi
}

assert_json_valid() {
    local file_path="$1"
    local description="$2"
    if python3 -m json.tool "$file_path" > /dev/null 2>&1; then
        pass_test "$description"
    else
        fail_test "$description" "Invalid JSON: $file_path"
    fi
}

assert_file_exists() {
    local file_path="$1"
    local description="$2"
    if [ -f "$file_path" ]; then
        pass_test "$description"
    else
        fail_test "$description" "File not found: $file_path"
    fi
}

assert_exit_code() {
    local expected="$1"
    local actual="$2"
    local description="$3"
    if [ "$actual" -eq "$expected" ]; then
        pass_test "$description"
    else
        fail_test "$description" "Expected exit code $expected, got $actual"
    fi
}

# ─── Utilities ────────────────────────────────

require_command() {
    local cmd="$1"
    local msg="$2"
    if ! command -v "$cmd" > /dev/null 2>&1; then
        echo -e "${RED}Prerequisite missing:${NC} $msg"
        return 1
    fi
}

require_plugin() {
    local plugin_name="$1"
    local msg="$2"
    # Check if plugin is in the Claude plugins cache
    local cache_dir="$HOME/.claude/plugins/cache/$plugin_name"
    if [ ! -d "$cache_dir" ]; then
        echo -e "${RED}Prerequisite missing:${NC} $msg"
        echo "  Install with: claude plugin install $plugin_name"
        return 1
    fi
}

create_test_project() {
    TEST_TMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/ideaprobe-test-XXXXXX")
    mkdir -p "$TEST_TMP_DIR/.ideaprobe"
    if [ "$VERBOSE" = true ]; then
        echo "  [tmp] Created $TEST_TMP_DIR"
    fi
}

cleanup_test_project() {
    if [ -n "$TEST_TMP_DIR" ] && [ -d "$TEST_TMP_DIR" ]; then
        rm -rf "$TEST_TMP_DIR"
        if [ "$VERBOSE" = true ]; then
            echo "  [tmp] Cleaned up $TEST_TMP_DIR"
        fi
        TEST_TMP_DIR=""
    fi
}

get_plugin_root() {
    echo "$REPO_ROOT"
}

verbose_log() {
    if [ "$VERBOSE" = true ]; then
        echo "  [verbose] $*"
    fi
}
