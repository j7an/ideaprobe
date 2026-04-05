---
name: competitor-analysis
description: "Map the competitive landscape and identify exploitable gaps. Use when the user asks about competitors, market saturation, or says 'find competitors' for an idea."
---

# Competitor Analysis

Map the competitive landscape and identify exploitable gaps. This is a standalone skill — use it when you need detailed competitor intelligence without running the full validation workflow.

## Context Loading

Read these files before proceeding:
1. `refs/data-sources.md` — where to search and how to cite
2. `refs/output-templates.md` — the Research Report template

## Step 1: Clarify the Problem Space

If the user hasn't provided enough context, ask:
- What problem or solution space should I analyze?
- Any known competitors I should include?

## Step 2: Launch Research Agent

Launch the **`ideaprobe:competitor-scout`** agent with:
- The problem/solution space description
- Any known competitors to include
- Instruction to cover all sources from data-sources.md

Use a **standard model** for this agent.

If the agent returns shallow or incomplete results, re-dispatch with a more capable model.

## Step 3: Present Findings

Use the Research Report template from `refs/output-templates.md`. Present:

- **Competitor table:** Name, URL, pricing, audience, differentiator, weaknesses — for every competitor found.
- **Gap analysis:** What are users complaining about? What segments are underserved? What pricing tier is missing? What integrations are lacking?
- **Saturation assessment:** Low (<5, none dominant) / Moderate (5-15, gaps remain) / High (15+, strong leaders) / Saturated (mature, consolidation happening).
- **Pricing landscape:** Range from lowest to highest, most common pricing model, any missing tiers.

Every finding must include a source URL.

## Step 4: Suggest Next Steps

After presenting findings:
- If gaps are clear: "There are exploitable gaps. Want to run a full validation? Use `idea-validation` for a complete assessment."
- If market is saturated: "This market is crowded. Differentiation will require a strong angle. Consider `community-sentiment` to find specific underserved pain points."
- If no competitors: "Zero competitors is usually a warning sign — it may mean there's no market. Verify demand with `market-research` before proceeding."
