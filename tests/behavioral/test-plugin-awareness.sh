#!/bin/bash
# E2E: Does the plugin load and Claude know about it?
# One API call, multiple assertions.
# Replaces: test-skill-triggering (tests 1+3) + test-session-bootstrap (tests 1+2+3)

setup_test "Plugin Awareness"

TIMEOUT="${BEHAVIORAL_TIMEOUT:-300}"

verbose_log "Running: claude -p 'What do you know about IdeaProbe? ...' (timeout: ${TIMEOUT}s)"
output=$(run_with_timeout "$TIMEOUT" claude -p "What do you know about IdeaProbe? List its skills and describe its key features." 2>&1 || true)
verbose_log "Output length: ${#output} chars"

# Assert: Claude mentions IdeaProbe by name
assert_contains "$output" "IdeaProbe\|ideaprobe" "Claude mentions IdeaProbe by name"

# Assert: Lists at least 5 of 9 skills
skill_names=("idea-validation" "market-research" "competitor-analysis" "community-sentiment" "idea-generation" "idea-comparison" "mvp-scoping" "founder-profile" "using-ideaprobe")
found_count=0
for skill in "${skill_names[@]}"; do
    pattern=$(echo "$skill" | sed 's/-/[- ]/g')
    if echo "$output" | grep -qi "$pattern"; then
        found_count=$((found_count + 1))
    fi
done

if [ "$found_count" -ge 5 ]; then
    pass_test "Lists $found_count/9 skills (>= 5 required)"
else
    fail_test "Lists $found_count/9 skills (>= 5 required)" "Only found $found_count"
fi

# Assert: Mentions scoring or verdicts
assert_contains "$output" "scor\|verdict\|GO\|STOP\|EXPLORE\|PIVOT" "Mentions scoring or verdicts"

# Assert: Mentions founder profile
assert_contains "$output" "founder\|profile\|Founder\|Profile" "Mentions founder profile"
