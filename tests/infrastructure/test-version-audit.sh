#!/bin/bash
# Test: bump-version.sh --audit — validates undeclared reference detection

setup_test "Version Audit"

BUMP_SCRIPT="$REPO_ROOT/scripts/bump-version.sh"
PKG_JSON="$REPO_ROOT/package.json"

# Test 1: --audit exits 0 with no undeclared references
exit_code=0
output=$(bash "$BUMP_SCRIPT" --audit 2>&1) || exit_code=$?
assert_exit_code 0 "$exit_code" "--audit exits 0 with no undeclared refs"
assert_contains "$output" "No undeclared" "--audit reports no undeclared references"

# Test 2: Detects an injected version reference
current_version=$(python3 -c "import json; print(json.load(open('$PKG_JSON'))['version'])")

# Create a temp file in repo root with the version string
INJECTED_FILE="$REPO_ROOT/test-injected-version.md"
echo "This file contains version $current_version for testing." > "$INJECTED_FILE"

inject_output=$(bash "$BUMP_SCRIPT" --audit 2>&1) || true

# Cleanup the injected file
rm -f "$INJECTED_FILE"

assert_contains "$inject_output" "test-injected-version.md" "--audit detects injected version reference"
