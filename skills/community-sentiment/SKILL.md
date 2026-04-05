---
name: community-sentiment
description: "Find real people experiencing a problem and gauge pain intensity. Use when the user asks about community sentiment, pain signals, or says 'scan sentiment' for an idea."
---

# Community Sentiment Analysis

Find real people experiencing a problem and gauge the intensity and frequency of their pain. This is a standalone skill — use it when you need qualitative pain signals without running the full validation workflow.

## Context Loading

Read these files before proceeding:
1. `refs/data-sources.md` — where to search and how to cite
2. `refs/output-templates.md` — the Research Report template

## Step 1: Clarify the Problem Space

If the user hasn't provided enough context, ask:
- What problem should I scan communities for?
- Any specific communities or platforms I should prioritize?

## Step 2: Launch Research Agent

Launch the **`ideaprobe:sentiment-scanner`** agent with:
- The problem description
- Any specific communities to prioritize
- Instruction to cover Reddit and Hacker News at minimum

Use a **standard model** for this agent.

If the agent returns shallow or incomplete results, re-dispatch with a more capable model.

## Step 3: Present Findings

Use the Research Report template from `refs/output-templates.md`. Present:

- **Signal strength rating:** Strong (50+ posts, recurring pain) / Moderate (10-50 posts) / Weak (<10 posts) / None (can't find anyone discussing this).
- **Top 5 pain points:** In users' own words — direct quotes with source URLs.
- **Existing solutions mentioned:** What tools people currently use, and what they complain about with each.
- **Notable quotes:** The most compelling quotes that capture frustration — these are valuable for marketing copy and landing pages.
- **Platform breakdown:** How many posts found on Reddit vs HN vs elsewhere.

Every quote and finding must include a source URL.

## Step 4: Suggest Next Steps

After presenting findings:
- If signal is strong: "Strong pain signals. Want to run a full validation? Use `idea-validation` for a complete GO/STOP verdict."
- If signal is moderate: "Moderate signals — the problem exists but may not be urgent. Consider `competitor-analysis` to see if existing solutions are failing these users."
- If signal is weak or none: "Weak community signals suggest few people are actively experiencing this pain publicly. This could mean no market, or that the audience doesn't use Reddit/HN. Consider alternative research channels."
