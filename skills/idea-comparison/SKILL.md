---
name: idea-comparison
description: "Compare 2-5 business ideas side-by-side with ranked scores. Use when the user has multiple ideas and wants to know which to pursue first."
---

# Idea Comparison

Compare 2-5 business ideas side-by-side using the full validation framework. Produces a ranked table so the user can decide which idea to pursue.

## Context Loading

Read these files before proceeding:
1. `refs/scoring-rubric.md` — scoring dimensions and verdict thresholds
2. `refs/output-templates.md` — the Comparison Table template

## Step 1: Collect Ideas

Ask the user to describe 2-5 ideas. For each idea, gather at minimum:
- A short name
- The problem it solves
- The target audience
- The proposed solution

If the user provides less than the full 5 inputs per idea (problem, audience, solution, model, advantage), that's acceptable for comparison — the validation will note gaps.

## Step 2: Validate Each Idea

Run the `idea-validation` skill workflow on each idea. Each validation is **independent** — different ideas, different searches, no shared state.

### Parallel Dispatch Strategy

For 2-3 ideas: dispatch all validations in parallel. Each validation launches its own 3 research agents, so you're running 6-9 agents concurrently.

For 4-5 ideas: dispatch in batches of 2-3 to avoid overwhelming the agent pool. Wait for the first batch to complete before starting the next.

### Model Selection

Follow the same model tiers as `idea-validation`:

- **Sentiment scanners**: Fast, cheap model (mechanical search work)
- **Market researchers, Competitor scouts**: Standard model (synthesis + judgment)
- **Validation reviewer**: Most capable model (critical analysis)

With 5 ideas, you're dispatching up to 15 research agents + 1 reviewer. Using
cheaper models for research agents significantly reduces cost and improves speed.
Announce the model tier for each agent so the user can gauge expected completion time.

### Per-Idea Validation

For each idea, run the full `idea-validation` workflow:
1. Gather any missing inputs for this specific idea
2. Launch 3 research agents in parallel (as described in idea-validation Step 2)
3. Score all 5 dimensions using agent findings
4. Launch the validation reviewer to challenge the report

This produces a full Validation Report per idea. All reports must be complete before proceeding to comparison.

## Step 3: Produce Ranked Comparison

Using the Comparison Table template from `refs/output-templates.md`:

1. Rank ideas by total score (highest first)
2. For each idea, show: score, verdict, strongest dimension, weakest dimension
3. Highlight across all ideas:
   - Which has the **strongest demand signal**?
   - Which has the **least competition**?
   - Which has the **best founder fit**?
   - Which is **fastest to MVP**?

## Step 4: Recommend

- **Recommendation:** Which idea to pursue and why (2-3 sentences). Base this on the scores, not on which idea sounds most exciting.
- **Runner-up:** What would make the #2 idea worth revisiting (e.g., "If you gained distribution in the X community, Idea B's Founder Fit would jump from 8 to 15").

## Step 5: Suggest Next Steps

- For the top-ranked idea: "Ready to scope the build? Use `mvp-scoping` to create a buildable MVP spec."
- For borderline ideas: "Want to dig deeper on [weak dimension]? Use `market-research` / `competitor-analysis` / `community-sentiment` for a focused analysis."
