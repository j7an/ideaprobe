#!/bin/bash
# Behavioral: Does idea-validation know the verdict score thresholds?
# One prompt, 30s timeout — tests scoring rubric content loaded correctly.

setup_test "Verdict Thresholds"

TIMEOUT="${BEHAVIORAL_TIMEOUT:-30}"

verbose_log "Prompt: 'What verdict for a score of 45?' (timeout: ${TIMEOUT}s)"
output=$(run_with_timeout "$TIMEOUT" claude -p "In ideaprobe:idea-validation, what verdict (GO, EXPLORE, PIVOT, or STOP) would a total score of 45 out of 100 receive? Answer in one word." < /dev/null 2>&1 || true)
verbose_log "Output length: ${#output} chars"

assert_contains "$output" "PIVOT" "Score of 45 maps to PIVOT verdict (40-59 range)"
