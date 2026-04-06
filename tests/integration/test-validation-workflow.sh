#!/bin/bash
# E2E: Does the full validation pipeline produce structured output?
# One API call — tests the critical path through idea-validation skill.

setup_test "Validation Workflow"

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

verbose_log "Running: claude -p '...' --allowed-tools=all --dangerously-skip-permissions (timeout: ${TIMEOUT}s)"
output=$(run_with_timeout "$TIMEOUT" claude -p "$PROMPT" \
    --allowed-tools=all \
    --dangerously-skip-permissions \
    < /dev/null 2>&1 || true)
verbose_log "Output length: ${#output} chars"

# Assert: Output is substantial (agents were dispatched and returned data)
output_length=${#output}
if [ "$output_length" -gt 500 ]; then
    pass_test "Output is substantial (${output_length} chars, >500 required)"
else
    fail_test "Output is substantial (${output_length} chars, >500 required)" "Output too short — agents may not have run"
fi

# Assert: Output contains scoring dimensions
dimensions=("demand\|Demand" "competitor\|Competitor\|competitive\|Competitive" "founder\|Founder\|fit\|Fit")
dims_found=0
for dim_pattern in "${dimensions[@]}"; do
    if echo "$output" | grep -qi "$dim_pattern"; then
        dims_found=$((dims_found + 1))
    fi
done

if [ "$dims_found" -ge 2 ]; then
    pass_test "Output contains scoring dimensions ($dims_found/3 found, >= 2 required)"
else
    fail_test "Output contains scoring dimensions ($dims_found/3 found, >= 2 required)" "Too few dimensions mentioned"
fi

# Assert: Output contains a verdict
if echo "$output" | grep -qE "GO|EXPLORE|PIVOT|STOP"; then
    pass_test "Output contains a verdict (GO/EXPLORE/PIVOT/STOP)"
else
    fail_test "Output contains a verdict (GO/EXPLORE/PIVOT/STOP)" "No verdict keyword found"
fi

# Cleanup
cleanup_test_project
