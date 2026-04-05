---
name: idea-validation
description: "Run a full business idea validation. Use when the user has a specific idea to evaluate, says 'validate this', or wants a GO/STOP verdict on an idea."
---

# Idea Validation

Run a structured assessment of a business idea's viability before committing to a build cycle. This is the flagship IdeaProbe skill — it orchestrates parallel research agents, scores across 5 dimensions, and produces a data-backed verdict.

## Context Loading

Read these files before proceeding:
1. `refs/scoring-rubric.md` — scoring dimensions, bands, and verdict thresholds
2. `refs/output-templates.md` — the Validation Report template
3. `refs/data-sources.md` — where agents should search

Also load `.ideaprobe/user-profile.md` from the project directory if it exists (used for Founder Fit scoring).

## Step 1: Gather Required Inputs

If not already provided by the user, ask for each of these **one at a time**:

- [ ] **Problem statement:** What specific problem does this solve?
- [ ] **Target audience:** Who has this problem? How many of them?
- [ ] **Proposed solution:** What are you building?
- [ ] **Business model:** How does this make money?
- [ ] **Unfair advantage:** Why you? Why now?

Do not proceed until all 5 inputs are gathered.

## Step 2: Launch Research Agents in Parallel

The 3 research agents are **independent** — they search different sources for different data, with no shared state. Dispatch all 3 in a **single message** with multiple Agent tool calls so they run concurrently.

### Agent Prompts

Each agent needs self-contained context. Include the idea inputs gathered in Step 1.

**Agent 1 — `ideaprobe:market-researcher`:**
Provide the problem statement, target audience, and proposed solution. Ask for demand signal data covering search volume trends, community signal volume, market sizing, and trend trajectory.

**Agent 2 — `ideaprobe:competitor-scout`:**
Provide the proposed solution, problem space, and any known competitors. Ask for competitor profiles, gap analysis, and saturation assessment.

**Agent 3 — `ideaprobe:sentiment-scanner`:**
Provide the problem statement and target audience keywords. Ask for community pain signals, direct quotes, signal strength rating, and existing solution complaints.

### How to Dispatch

Send a single message with 3 Agent tool calls — one per research agent. All 3 will run concurrently:

```
Agent(description="Market research for [idea]", prompt="You are ideaprobe:market-researcher. [full context]...")
Agent(description="Competitor analysis for [idea]", prompt="You are ideaprobe:competitor-scout. [full context]...")
Agent(description="Sentiment scan for [idea]", prompt="You are ideaprobe:sentiment-scanner. [full context]...")
```

**Do NOT dispatch sequentially** — that wastes time. These agents have no dependencies on each other.

### Model Selection

Use the least powerful model that can handle each role:
- **Research agents** (market-researcher, competitor-scout, sentiment-scanner): Use a standard model. These agents perform structured web searches and extract data — moderate judgment required.
- If a research agent returns shallow or incomplete results, re-dispatch that agent with a more capable model.

### Handling Results

Wait for all 3 agents to complete before proceeding to scoring. When results arrive:
1. Read each agent's structured findings
2. Verify each agent returned data (not just "no results found" for everything)
3. If an agent returned shallow results, re-dispatch it with a more capable model
4. Once all 3 have substantive findings, proceed to Step 3

## Step 3: Score Each Dimension

Using the agent findings and the scoring rubric from `refs/scoring-rubric.md`, score each dimension 0-20:

1. **Demand Signals (0-20)** — Score using market-researcher findings. How strong is the evidence that people have this problem?

2. **Competitor Landscape (0-20)** — Score using competitor-scout findings. Are there exploitable gaps, or is the market saturated?

3. **Willingness to Pay (0-20)** — Score using competitor-scout pricing data combined with sentiment-scanner frustration signals. Will people pay for this?

4. **Build Feasibility (0-20)** — Assess directly based on the proposed solution. Can this be built as an MVP in 2-4 weeks? Are APIs available? Any regulatory hurdles?

5. **Founder Fit (0-20)** — Score using the founder profile from `.ideaprobe/user-profile.md`. If no profile exists, ask the user directly about their relevant skills, distribution, and domain knowledge.

**Every score must cite specific evidence.** A score without a data source reference is not valid.

## Step 4: Calculate Verdict

Total = sum of 5 dimensions (0-100).

| Score | Verdict |
|-------|---------|
| 80-100 | **GO** — Strong signals across the board. Start building. |
| 60-79 | **EXPLORE** — Promising but needs deeper validation on weak areas. |
| 40-59 | **PIVOT** — Core problem exists but approach needs rethinking. |
| 0-39 | **STOP** — Weak demand or fundamental blockers. Move to next idea. |

## Step 5: Launch Validation Reviewer

Launch the **`ideaprobe:validation-reviewer`** agent. Provide the complete draft report (scores, evidence, verdict). Ask it to challenge the analysis.

### Model Selection

Use the **most capable available model** for the validation reviewer. This agent must reason critically, detect bias, and challenge assumptions.

Review the feedback. If the reviewer identifies:
- **Unjustified scores** — adjust the scores with explanation
- **Missing data** — note the gap in the report and adjust conservatively
- **Changed verdict** — present both the original and revised verdict with reasoning

## Step 6: Present Final Report

Use the Validation Report template from `refs/output-templates.md`. The report must include:
- Idea name and verdict with total score
- Score table with key findings per dimension
- Top risks (specific, not generic)
- Recommended next steps (concrete actions)
- Data sources used (with URLs)

If the verdict is GO or EXPLORE (≥60), suggest: "Ready to scope the MVP? Use the `mvp-scoping` skill."
If the verdict is PIVOT, suggest: "Consider changing [specific weak dimension]. Re-validate after pivoting."
If the verdict is STOP, say so clearly: "This idea has weak signals. Move to your next idea."
