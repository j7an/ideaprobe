#!/bin/bash
# Behavioral: Does idea-validation know to dispatch agents in parallel?
# One prompt, 30s timeout — tests parallel dispatch instruction loaded correctly.

setup_test "Agent Dispatch Rules"

TIMEOUT="${BEHAVIORAL_TIMEOUT:-30}"

verbose_log "Prompt: 'How many research agents and should they run in parallel?' (timeout: ${TIMEOUT}s)"
output=$(run_with_timeout "$TIMEOUT" claude -p "In ideaprobe:idea-validation, how many research agents are dispatched and should they run sequentially or in parallel? Answer in one sentence." < /dev/null 2>&1 || true)
verbose_log "Output length: ${#output} chars"

assert_contains "$output" "3\|[Tt]hree" "Knows 3 research agents are dispatched"
assert_contains "$output" "[Pp]arallel" "Knows agents should run in parallel"
