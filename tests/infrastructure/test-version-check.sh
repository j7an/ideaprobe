#!/bin/bash
# Test: bump-version.sh --check — validates version consistency

setup_test "Version Check"

BUMP_SCRIPT="$REPO_ROOT/scripts/bump-version.sh"
PKG_JSON="$REPO_ROOT/package.json"

# Test 1: --check exits 0 when versions are in sync
exit_code=0
output=$(bash "$BUMP_SCRIPT" --check 2>&1) || exit_code=$?
assert_exit_code 0 "$exit_code" "--check exits 0 when versions in sync"

# Test 2: Reports the current version string
current_version=$(python3 -c "import json; print(json.load(open('$PKG_JSON'))['version'])")
assert_contains "$output" "$current_version" "--check reports current version ($current_version)"

# Test 3: Detects drift when versions are mismatched
# Save original, inject drift, check, restore
original=$(cat "$PKG_JSON")
python3 -c "
import json
data = json.load(open('$PKG_JSON'))
data['version'] = '99.99.99'
json.dump(data, open('$PKG_JSON', 'w'), indent=2)
"
# Add trailing newline (matches bump-version.sh behavior)
echo "" >> "$PKG_JSON"

drift_exit=0
drift_output=$(bash "$BUMP_SCRIPT" --check 2>&1) || drift_exit=$?

# Restore original
printf '%s' "$original" > "$PKG_JSON"

if [ "$drift_exit" -ne 0 ]; then
    pass_test "--check detects version drift (exits non-zero)"
else
    fail_test "--check detects version drift (exits non-zero)" "Expected non-zero exit, got 0"
fi
assert_contains "$drift_output" "drift" "--check output mentions drift"
