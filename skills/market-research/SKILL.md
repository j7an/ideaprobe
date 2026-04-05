---
name: market-research
description: "Deep dive into demand signals for a problem or solution space. Use when the user asks about market demand, search trends, or says 'check demand' for an idea."
---

# Market Research

Deep dive into demand signals for a specific problem or solution space. This is a standalone skill — use it when you need detailed demand analysis without running the full validation workflow.

## Context Loading

Read these files before proceeding:
1. `refs/data-sources.md` — where to search and how to cite
2. `refs/output-templates.md` — the Research Report template

## Step 1: Clarify the Problem Space

If the user hasn't provided enough context, ask:
- What problem or solution space should I research?
- Any specific keywords or competitors I should include in the search?

## Step 2: Launch Research Agent

Launch the **`ideaprobe:market-researcher`** agent with:
- The problem/solution space description
- Any specific keywords the user provided
- Instruction to cover all sources from data-sources.md

Use a **standard model** for this agent.

If the agent returns shallow or incomplete results, re-dispatch with a more capable model.

## Step 3: Present Findings

Use the Research Report template from `refs/output-templates.md`. Present:

- **Search volume trends:** Rising, stable, or declining? Seasonal patterns? Include Google Trends data with trajectory direction.
- **Community signal volume:** How many relevant posts on Reddit and HN? Which subreddits are most active?
- **Lightweight market sizing:** Directional estimate from industry reports, competitor customer counts, job posting volume. Don't over-engineer TAM/SAM/SOM.
- **Trend trajectory:** Is this problem growing (expanding market) or being solved (shrinking)? What forces are driving the trend?
- **Related rising queries:** Adjacent search terms that reveal opportunities the user may not have considered.

Every finding must include a source URL.

## Step 4: Suggest Next Steps

After presenting findings:
- If demand looks strong: "Want to run a full validation? Use the `idea-validation` skill for a complete GO/STOP verdict."
- If demand is unclear: "Consider checking community sentiment directly with `community-sentiment` for more qualitative signals."
- If demand is weak: "Low demand signals suggest this market may be too small. Consider a different angle or problem space."
