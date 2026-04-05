#!/bin/bash
# Test: Claude discovers and lists IdeaProbe skills
# Requires: Claude CLI, IdeaProbe plugin installed

setup_test "Skill Triggering"

TIMEOUT="${BEHAVIORAL_TIMEOUT:-300}"

# Test 1: Claude lists IdeaProbe skills when asked directly
verbose_log "Running: claude -p 'What skills does IdeaProbe provide?' (timeout: ${TIMEOUT}s)"
output=$(run_with_timeout "$TIMEOUT" claude -p "What skills does IdeaProbe provide? List them briefly." 2>&1 || true)
verbose_log "Output length: ${#output} chars"

assert_contains "$output" "idea-validation\|idea validation\|validation" "Claude mentions idea-validation skill"
assert_contains "$output" "market-research\|market research" "Claude mentions market-research skill"
assert_contains "$output" "competitor\|competitor-analysis" "Claude mentions competitor-analysis skill"

# Test 2: Implicit triggering from business context
verbose_log "Running: claude -p 'I have a business idea for a SaaS tool' (timeout: ${TIMEOUT}s)"
implicit_output=$(run_with_timeout "$TIMEOUT" claude -p "I have a business idea for a SaaS tool that helps freelancers track invoices. What should I do first?" 2>&1 || true)
verbose_log "Output length: ${#implicit_output} chars"

# Should reference IdeaProbe or validation — not just give generic advice
if echo "$implicit_output" | grep -qi "ideaprobe\|validat\|idea-validation\|score\|founder"; then
    pass_test "Implicit trigger: Claude references IdeaProbe for business idea"
else
    fail_test "Implicit trigger: Claude references IdeaProbe for business idea" "Response did not mention IdeaProbe or validation"
fi

# Test 3: Explicit skill enumeration
verbose_log "Running: claude -p 'List all available ideaprobe skills' (timeout: ${TIMEOUT}s)"
enum_output=$(run_with_timeout "$TIMEOUT" claude -p "List all available ideaprobe skills with their names." 2>&1 || true)
verbose_log "Output length: ${#enum_output} chars"

# Count how many known skill names appear
skill_names=("idea-validation" "market-research" "competitor-analysis" "community-sentiment" "idea-generation" "idea-comparison" "mvp-scoping" "founder-profile" "using-ideaprobe")
found_count=0
for skill in "${skill_names[@]}"; do
    # Match with or without hyphens
    pattern=$(echo "$skill" | sed 's/-/[- ]/g')
    if echo "$enum_output" | grep -qi "$pattern"; then
        found_count=$((found_count + 1))
    fi
done

if [ "$found_count" -ge 5 ]; then
    pass_test "Explicit enumeration: Claude lists $found_count/9 skills (≥5 required)"
else
    fail_test "Explicit enumeration: Claude lists $found_count/9 skills (≥5 required)" "Only found $found_count skill names"
fi
