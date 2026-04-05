#!/bin/bash
# E2E: Does Claude suggest IdeaProbe when a user mentions a business idea?
# One API call — tests the session-start hook's real-world effect.

setup_test "Implicit Trigger"

TIMEOUT="${BEHAVIORAL_TIMEOUT:-300}"

verbose_log "Running: claude -p 'I have a business idea...' (timeout: ${TIMEOUT}s)"
output=$(run_with_timeout "$TIMEOUT" claude -p "I have a business idea for a SaaS tool that helps freelancers track invoices. What should I do first?" 2>&1 || true)
verbose_log "Output length: ${#output} chars"

# Assert: Claude references IdeaProbe or validation — not just generic advice
if echo "$output" | grep -qi "ideaprobe\|validat\|idea-validation\|score\|founder"; then
    pass_test "Claude references IdeaProbe or validation for business idea"
else
    fail_test "Claude references IdeaProbe or validation for business idea" "Response did not mention IdeaProbe or validation"
fi
