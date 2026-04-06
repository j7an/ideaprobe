#!/bin/bash
set -euo pipefail

# IdeaProbe Test Runner
#
# Prerequisites:
#   - Infrastructure tests: python3 (for JSON parsing)
#   - Behavioral/integration tests: Claude CLI (authenticated), IdeaProbe plugin installed
#   - macOS: brew install coreutils (provides gtimeout for behavioral/integration tests)
#
# Usage:
#   ./tests/run-tests.sh                  # Infrastructure tests only (default)
#   ./tests/run-tests.sh --all            # Infrastructure + behavioral (~2 min)
#   ./tests/run-tests.sh --integration    # Infrastructure + behavioral + integration (10-30 min)
#   ./tests/run-tests.sh --test NAME      # Run a specific test (partial match)
#   ./tests/run-tests.sh --verbose        # Show command output
#   ./tests/run-tests.sh --timeout N      # Custom timeout for behavioral tests (default: 30)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ─── Parse Arguments ──────────────────────────
RUN_ALL=false
RUN_INTEGRATION=false
TEST_FILTER=""
VERBOSE=false
BEHAVIORAL_TIMEOUT=30

while [[ $# -gt 0 ]]; do
    case "$1" in
        --all)
            RUN_ALL=true
            shift
            ;;
        --integration)
            RUN_ALL=true
            RUN_INTEGRATION=true
            shift
            ;;
        --test)
            TEST_FILTER="$2"
            shift 2
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --timeout)
            BEHAVIORAL_TIMEOUT="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--all] [--integration] [--test NAME] [--verbose] [--timeout SECONDS]"
            exit 1
            ;;
    esac
done

# --all and --integration imply --verbose (slow tests need progress feedback)
if [ "$RUN_ALL" = true ]; then
    VERBOSE=true
fi

export VERBOSE
export BEHAVIORAL_TIMEOUT

# ─── Source Helpers ───────────────────────────
source "$SCRIPT_DIR/test-helpers.sh"

echo -e "${BOLD}IdeaProbe Test Suite${NC}"
echo ""

# ─── Discover Tests ──────────────────────────
INFRA_TESTS=()
BEHAVIORAL_TESTS=()
INTEGRATION_TESTS=()

for test_file in "$SCRIPT_DIR"/infrastructure/test-*.sh; do
    [ -f "$test_file" ] || continue
    INFRA_TESTS+=("$test_file")
done

for test_file in "$SCRIPT_DIR"/behavioral/test-*.sh; do
    [ -f "$test_file" ] || continue
    BEHAVIORAL_TESTS+=("$test_file")
done

for test_file in "$SCRIPT_DIR"/integration/test-*.sh; do
    [ -f "$test_file" ] || continue
    INTEGRATION_TESTS+=("$test_file")
done

# ─── Filter Tests ────────────────────────────
# Inline filtering (no namerefs — compatible with bash 3.2 on macOS)
# Guard empty array access for set -u compatibility
if [ -n "$TEST_FILTER" ]; then
    FILTERED=()
    if [ ${#INFRA_TESTS[@]} -gt 0 ]; then
        for test_file in "${INFRA_TESTS[@]}"; do
            basename=$(basename "$test_file" .sh)
            if [[ "$basename" == *"$TEST_FILTER"* ]]; then
                FILTERED+=("$test_file")
            fi
        done
    fi
    INFRA_TESTS=("${FILTERED[@]+"${FILTERED[@]}"}")

    FILTERED=()
    if [ ${#BEHAVIORAL_TESTS[@]} -gt 0 ]; then
        for test_file in "${BEHAVIORAL_TESTS[@]}"; do
            basename=$(basename "$test_file" .sh)
            if [[ "$basename" == *"$TEST_FILTER"* ]]; then
                FILTERED+=("$test_file")
            fi
        done
    fi
    BEHAVIORAL_TESTS=("${FILTERED[@]+"${FILTERED[@]}"}")

    FILTERED=()
    if [ ${#INTEGRATION_TESTS[@]} -gt 0 ]; then
        for test_file in "${INTEGRATION_TESTS[@]}"; do
            basename=$(basename "$test_file" .sh)
            if [[ "$basename" == *"$TEST_FILTER"* ]]; then
                FILTERED+=("$test_file")
            fi
        done
    fi
    INTEGRATION_TESTS=("${FILTERED[@]+"${FILTERED[@]}"}")
fi

# ─── Run Infrastructure Tests ────────────────
if [ ${#INFRA_TESTS[@]} -gt 0 ]; then
    echo -e "${BOLD}Infrastructure Tests${NC}"
    for test_file in "${INFRA_TESTS[@]}"; do
        source "$test_file"
    done
fi

# ─── Check Claude Prerequisites ─────────────
check_claude_prereqs() {
    if ! require_command "claude" "Claude CLI required"; then
        return 1
    fi
    if ! require_plugin "ideaprobe" "IdeaProbe plugin must be installed"; then
        return 1
    fi
    return 0
}

# ─── Run Behavioral Tests ────────────────────
if [ "$RUN_ALL" = true ] || [ -n "$TEST_FILTER" ]; then
    if [ ${#BEHAVIORAL_TESTS[@]} -gt 0 ]; then
        echo ""
        echo -e "${BOLD}Behavioral Tests${NC} (${BEHAVIORAL_TIMEOUT}s timeout per prompt)"

        if check_claude_prereqs; then
            for test_file in "${BEHAVIORAL_TESTS[@]}"; do
                source "$test_file"
            done
        else
            for test_file in "${BEHAVIORAL_TESTS[@]}"; do
                skip_test "$(basename "$test_file" .sh)" "Prerequisites not met"
            done
        fi
    fi
else
    if [ ${#BEHAVIORAL_TESTS[@]} -gt 0 ] && [ -z "$TEST_FILTER" ]; then
        echo ""
        echo -e "${YELLOW}Skipped ${#BEHAVIORAL_TESTS[@]} behavioral test(s). Use --all to include them.${NC}"
    fi
fi

# ─── Run Integration Tests ───────────────────
if [ "$RUN_INTEGRATION" = true ] || [ -n "$TEST_FILTER" ]; then
    if [ ${#INTEGRATION_TESTS[@]} -gt 0 ]; then
        echo ""
        echo -e "${BOLD}Integration Tests${NC}"
        echo -e "${YELLOW}Warning: Integration tests are slow (10-30 min) and use significant tokens.${NC}"

        if check_claude_prereqs; then
            echo "Proceeding in 5s... (Ctrl+C to cancel)"
            sleep 5
            for test_file in "${INTEGRATION_TESTS[@]}"; do
                source "$test_file"
            done
        else
            for test_file in "${INTEGRATION_TESTS[@]}"; do
                skip_test "$(basename "$test_file" .sh)" "Prerequisites not met"
            done
        fi
    fi
else
    if [ ${#INTEGRATION_TESTS[@]} -gt 0 ] && [ -z "$TEST_FILTER" ]; then
        echo ""
        echo -e "${YELLOW}Skipped ${#INTEGRATION_TESTS[@]} integration test(s). Use --integration to include them.${NC}"
    fi
fi

# ─── Summary ─────────────────────────────────
print_summary
exit $?
