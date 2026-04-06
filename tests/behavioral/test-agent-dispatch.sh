#!/bin/bash
# Test: idea-validation dispatches agents and produces structured output
# Requires: Claude CLI, IdeaProbe plugin installed, internet access
# WARNING: This test is slow (5-10 minutes) and uses significant API tokens

setup_test "Agent Dispatch"

TIMEOUT="${BEHAVIORAL_TIMEOUT:-600}"
# Override default — agent dispatch needs more time
if [ "$TIMEOUT" -lt 600 ]; then
    TIMEOUT=600
fi

echo -e "  ${YELLOW}This test takes 5-10 minutes and uses ~50K-100K tokens.${NC}"

# Create a test project directory
create_test_project

PROMPT="Use the ideaprobe:idea-validation skill to validate this idea:

Problem: Freelance developers waste 2-3 hours per week writing git commit messages.
Target audience: Solo developers and small dev teams (estimated 30M+ globally).
Solution: A CLI tool that reads git diffs and generates semantic commit messages using AI.
Business model: Freemium — free for 50 commits/month, \$5/month for unlimited.
Unfair advantage: First-mover in CLI-native commit tooling, built by a developer for developers.

Run the full validation. Do not ask me any questions — use the inputs above."

verbose_log "Running: claude -p '...' --allowed-tools=all (timeout: ${TIMEOUT}s)"
output=$(cd "$TEST_TMP_DIR" && run_with_timeout "$TIMEOUT" claude -p "$PROMPT" --allowed-tools=all 2>&1 || true)
verbose_log "Output length: ${#output} chars"

# Test 1: Output is substantial (agents were dispatched and returned data)
output_length=${#output}
if [ "$output_length" -gt 500 ]; then
    pass_test "Output is substantial (${output_length} chars, >500 required)"
else
    fail_test "Output is substantial (${output_length} chars, >500 required)" "Output too short — agents may not have run"
fi

# Test 2: Output contains scoring dimensions
dimensions=("demand\|Demand" "competitor\|Competitor\|competitive\|Competitive" "founder\|Founder\|fit\|Fit")
dims_found=0
for dim_pattern in "${dimensions[@]}"; do
    if echo "$output" | grep -qi "$dim_pattern"; then
        dims_found=$((dims_found + 1))
    fi
done

if [ "$dims_found" -ge 2 ]; then
    pass_test "Output contains scoring dimensions ($dims_found/3 found, ≥2 required)"
else
    fail_test "Output contains scoring dimensions ($dims_found/3 found, ≥2 required)" "Too few dimensions mentioned"
fi

# Test 3: Output contains a verdict
if echo "$output" | grep -qE "GO|EXPLORE|PIVOT|STOP"; then
    pass_test "Output contains a verdict (GO/EXPLORE/PIVOT/STOP)"
else
    fail_test "Output contains a verdict (GO/EXPLORE/PIVOT/STOP)" "No verdict keyword found"
fi

# Cleanup
cleanup_test_project
