#!/bin/bash
# Test: hooks/session-start — validates JSON output and content

setup_test "Session-Start Hook"

HOOK="$REPO_ROOT/hooks/session-start"
SKILL_FILE="$REPO_ROOT/skills/using-ideaprobe/SKILL.md"

# Test 1: Script exits 0 and outputs valid JSON
exit_code=0
output=$(bash "$HOOK" 2>&1) || exit_code=$?
assert_exit_code 0 "$exit_code" "Hook exits with code 0"

# Write output to temp file for JSON validation
HOOK_TMP=$(mktemp)
echo "$output" > "$HOOK_TMP"
assert_json_valid "$HOOK_TMP" "Hook output is valid JSON"

# Test 2: JSON contains hookSpecificOutput.additionalContext
has_key=$(python3 -c "
import json, sys
data = json.load(open('$HOOK_TMP'))
ctx = data.get('hookSpecificOutput', {}).get('additionalContext', None)
print('yes' if ctx is not None else 'no')
" 2>/dev/null || echo "error")
if [ "$has_key" = "yes" ]; then
    pass_test "JSON contains hookSpecificOutput.additionalContext"
else
    fail_test "JSON contains hookSpecificOutput.additionalContext" "Key missing or parse error"
fi

# Test 3: Content includes IdeaProbe skill text
content=$(python3 -c "
import json
data = json.load(open('$HOOK_TMP'))
print(data['hookSpecificOutput']['additionalContext'])
" 2>/dev/null || echo "")
assert_contains "$content" "IdeaProbe" "Content includes IdeaProbe text"

# Test 4: YAML frontmatter is stripped
assert_not_contains "$content" "^---$" "YAML frontmatter is stripped from content"

# Test 5: Missing skill file — exits 0, no crash
mv "$SKILL_FILE" "${SKILL_FILE}.bak"
missing_exit=0
missing_output=$(bash "$HOOK" 2>&1) || missing_exit=$?
mv "${SKILL_FILE}.bak" "$SKILL_FILE"
assert_exit_code 0 "$missing_exit" "Missing skill file: exits 0 gracefully"

# Cleanup
rm -f "$HOOK_TMP"
