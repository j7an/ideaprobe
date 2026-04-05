#!/bin/bash
# Test: session-start hook injects IdeaProbe context into Claude session
# Requires: Claude CLI, IdeaProbe plugin installed

setup_test "Session Bootstrap"

TIMEOUT="${BEHAVIORAL_TIMEOUT:-300}"

# Test 1: Claude demonstrates IdeaProbe awareness
verbose_log "Running: claude -p 'What do you know about IdeaProbe?' (timeout: ${TIMEOUT}s)"
output=$(run_with_timeout "$TIMEOUT" claude -p "What do you know about IdeaProbe? Be specific about its capabilities." 2>&1 || true)
verbose_log "Output length: ${#output} chars"

# Should demonstrate real awareness, not a generic "I don't know"
if echo "$output" | grep -qi "business idea\|validation\|scoring\|market research\|founder"; then
    pass_test "Claude demonstrates IdeaProbe awareness (not generic)"
else
    fail_test "Claude demonstrates IdeaProbe awareness (not generic)" "Response appears generic or unaware"
fi

# Test 2: Claude knows about specific features
assert_contains "$output" "skill\|Skill\|scoring\|verdict\|GO\|STOP\|EXPLORE" "Claude knows about IdeaProbe features (skills, scoring, or verdicts)"

# Test 3: Claude knows about the founder profile
verbose_log "Running: claude -p 'Does IdeaProbe use a founder profile?' (timeout: ${TIMEOUT}s)"
profile_output=$(run_with_timeout "$TIMEOUT" claude -p "Does IdeaProbe use a founder profile? What is it for?" 2>&1 || true)
verbose_log "Output length: ${#profile_output} chars"

if echo "$profile_output" | grep -qi "profile\|founder\|skill\|fit\|user-profile"; then
    pass_test "Claude knows about founder profile feature"
else
    fail_test "Claude knows about founder profile feature" "Response did not mention profiles"
fi
