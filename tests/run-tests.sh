#!/bin/bash
set -euo pipefail

# IdeaProbe Test Runner
#
# Prerequisites:
#   - Infrastructure tests: python3 (for JSON parsing)
#   - Behavioral tests: Claude CLI (authenticated), IdeaProbe plugin installed
#   - macOS: brew install coreutils (provides gtimeout for behavioral tests)
#
# Usage:
#   ./tests/run-tests.sh              # Infrastructure tests only (default)
#   ./tests/run-tests.sh --all        # Infrastructure + behavioral
#   ./tests/run-tests.sh --test NAME  # Run a specific test (partial match)
#   ./tests/run-tests.sh --verbose    # Show command output
#   ./tests/run-tests.sh --timeout N  # Custom timeout for behavioral tests (default: 300)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ─── Parse Arguments ──────────────────────────
RUN_ALL=false
TEST_FILTER=""
VERBOSE=false
BEHAVIORAL_TIMEOUT=300

while [[ $# -gt 0 ]]; do
    case "$1" in
        --all)
            RUN_ALL=true
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
            echo "Usage: $0 [--all] [--test NAME] [--verbose] [--timeout SECONDS]"
            exit 1
            ;;
    esac
done

# --all implies --verbose (behavioral tests are slow; progress feedback is essential)
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

for test_file in "$SCRIPT_DIR"/infrastructure/test-*.sh; do
    [ -f "$test_file" ] || continue
    INFRA_TESTS+=("$test_file")
done

for test_file in "$SCRIPT_DIR"/behavioral/test-*.sh; do
    [ -f "$test_file" ] || continue
    BEHAVIORAL_TESTS+=("$test_file")
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
fi

# ─── Run Infrastructure Tests ────────────────
if [ ${#INFRA_TESTS[@]} -gt 0 ]; then
    echo -e "${BOLD}Infrastructure Tests${NC}"
    for test_file in "${INFRA_TESTS[@]}"; do
        source "$test_file"
    done
fi

# ─── Run Behavioral Tests ────────────────────
if [ "$RUN_ALL" = true ] || [ -n "$TEST_FILTER" ]; then
    if [ ${#BEHAVIORAL_TESTS[@]} -gt 0 ]; then
        echo ""
        echo -e "${BOLD}Behavioral Tests${NC}"
        echo -e "${YELLOW}Warning: Behavioral tests use Claude API and cost tokens.${NC}"

        # Check prerequisites
        if ! require_command "claude" "Claude CLI required for behavioral tests"; then
            for test_file in "${BEHAVIORAL_TESTS[@]}"; do
                local_name=$(basename "$test_file" .sh)
                skip_test "$local_name" "Claude CLI not found"
            done
        elif ! require_plugin "ideaprobe" "IdeaProbe plugin must be installed"; then
            for test_file in "${BEHAVIORAL_TESTS[@]}"; do
                local_name=$(basename "$test_file" .sh)
                skip_test "$local_name" "Plugin not installed"
            done
        else
            echo "Proceeding in 5s... (Ctrl+C to cancel)"
            sleep 5
            for test_file in "${BEHAVIORAL_TESTS[@]}"; do
                source "$test_file"
            done
        fi
    fi
else
    if [ ${#BEHAVIORAL_TESTS[@]} -gt 0 ] && [ -z "$TEST_FILTER" ]; then
        echo ""
        echo -e "${YELLOW}Skipped ${#BEHAVIORAL_TESTS[@]} behavioral test(s). Use --all to include them.${NC}"
    fi
fi

# ─── Summary ─────────────────────────────────
print_summary
exit $?
