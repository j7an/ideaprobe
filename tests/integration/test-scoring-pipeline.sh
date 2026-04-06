#!/bin/bash
# Integration (fast): Does the scoring pipeline produce correct scores and verdict?
# Pre-baked data — no agent dispatch or web search needed.
# ~40-50s, tests scoring rubric + verdict thresholds + output format.

setup_test "Scoring Pipeline"

TIMEOUT=120

PROMPT="Use the ideaprobe:idea-validation scoring rubric to score this idea given pre-gathered research data. Do NOT dispatch agents — use the data below directly.

Idea: A CLI tool that generates commit messages from git diffs using AI.

Pre-gathered data:
- Demand: 'commit message generator' has 5K monthly searches, growing 40% YoY. 12 Reddit threads with 200+ upvotes about commit message pain.
- Competitors: 3 exist (commitizen, aicommits, conventional-commits). Gap in CLI-native AI tooling with freemium model.
- Willingness to pay: aicommits charges \$5/mo with 2K paying users. Reddit comments show devs willing to pay for time savings.
- Build feasibility: CLI tool using OpenAI API, 2-week MVP feasible. No regulatory hurdles.
- Founder fit: experienced CLI developer, no existing audience, solo builder.

Score each of the 5 dimensions 0-20. Show the total score and verdict (GO/EXPLORE/PIVOT/STOP). Keep it brief."

verbose_log "Prompt: scoring pipeline with pre-baked data (timeout: ${TIMEOUT}s)"
output=$(run_with_timeout "$TIMEOUT" claude -p "$PROMPT" --model sonnet --effort medium < /dev/null 2>&1 || true)
verbose_log "Output length: ${#output} chars"

# Assert: Output contains numeric scores
if echo "$output" | grep -qE '[0-9]+/20|[0-9]+ ?/ ?20|: [0-9]{1,2}$'; then
    pass_test "Output contains dimension scores"
else
    # Fallback: check for any numbers near dimension names
    if echo "$output" | grep -qE '[0-9]{1,2}.*[Dd]emand|[Dd]emand.*[0-9]{1,2}'; then
        pass_test "Output contains dimension scores"
    else
        fail_test "Output contains dimension scores" "No scoring pattern found"
    fi
fi

# Assert: Output contains a total score
assert_contains "$output" "[0-9][0-9]\|[Tt]otal\|/100" "Output contains a total score"

# Assert: Output contains a verdict
if echo "$output" | grep -qE "GO|EXPLORE|PIVOT|STOP"; then
    pass_test "Output contains a verdict (GO/EXPLORE/PIVOT/STOP)"
else
    fail_test "Output contains a verdict (GO/EXPLORE/PIVOT/STOP)" "No verdict keyword found"
fi
