#!/bin/bash
# Behavioral: Does idea-validation know its 5 scoring dimensions?
# One prompt, 30s timeout — tests skill content loaded correctly.

setup_test "Scoring Dimensions"

TIMEOUT="${BEHAVIORAL_TIMEOUT:-30}"

verbose_log "Prompt: 'What are the 5 scoring dimensions in ideaprobe:idea-validation?' (timeout: ${TIMEOUT}s)"
output=$(run_with_timeout "$TIMEOUT" claude -p "When using the ideaprobe:idea-validation skill, what are the 5 scoring dimensions? List only their names, one per line." 2>&1 || true)
verbose_log "Output length: ${#output} chars"

assert_contains "$output" "[Dd]emand" "Mentions demand signals dimension"
assert_contains "$output" "[Cc]ompetit" "Mentions competitor/competitive landscape dimension"
assert_contains "$output" "[Ff]ounder\|[Ff]it" "Mentions founder fit dimension"
assert_contains "$output" "[Ff]easibil\|[Bb]uild" "Mentions build feasibility dimension"
assert_contains "$output" "[Ww]illing\|[Pp]ay" "Mentions willingness to pay dimension"
