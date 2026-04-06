#!/bin/bash
# Behavioral: Does the router skill suggest the right skill for each situation?
# One prompt, 30s timeout — tests using-ideaprobe routing table loaded correctly.

setup_test "Skill Routing"

TIMEOUT="${BEHAVIORAL_TIMEOUT:-30}"

verbose_log "Prompt: 'What IdeaProbe skill for someone without an idea?' (timeout: ${TIMEOUT}s)"
output=$(run_with_timeout "$TIMEOUT" claude -p "Using IdeaProbe, what skill should someone use if they don't have a business idea yet? Answer with just the skill name." < /dev/null 2>&1 || true)
verbose_log "Output length: ${#output} chars"

assert_contains "$output" "idea.generation\|idea-generation" "Routes to idea-generation for users without an idea"
