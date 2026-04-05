---
name: mvp-scoping
description: "Convert a validated idea into a buildable MVP specification. Use when the user has a validated idea (GO or EXPLORE with score >= 60) and wants to start building."
---

# MVP Scoping

Convert a validated business idea into a buildable MVP specification. This is the bridge from validation to building — the output can be handed directly to a coding agent.

## Context Loading

Read these files before proceeding:
1. `refs/output-templates.md` — the MVP Specification template

Also load `.ideaprobe/user-profile.md` from the project directory if it exists (used for tech stack recommendation).

## Prerequisites

This skill requires a validated idea. Check:

1. Has the idea been validated with `idea-validation`?
   - If yes, use the validation results.
   - If no, tell the user: "This idea hasn't been validated yet. Want to run `idea-validation` first? MVP scoping works best with validated data."

2. Is the verdict GO or EXPLORE with score >= 60?
   - If yes, proceed.
   - If EXPLORE with score 60-69, proceed but note: "This idea is in EXPLORE territory — the MVP should specifically test the weak dimensions."
   - If PIVOT or STOP (score < 60), warn: "This idea scored [XX]/100 with a [PIVOT/STOP] verdict. Building an MVP for a PIVOT/STOP idea is high risk. The validation identified these weaknesses: [list]. Do you want to proceed anyway, or reconsider the approach?"

## Step 1: Core Value Proposition

Distill the idea to one sentence: what it does and for whom.

This sentence should pass the "mom test" — someone unfamiliar with the space should understand what it does.

## Step 2: Week-1 Feature Set

List only features that directly test willingness to pay. For each feature:
- What it does
- Why it's in week 1 (which hypothesis does it test?)

**Ruthlessly cut everything else.** No admin dashboards, no settings pages, no premium tiers. The MVP tests one question: "Will someone pay for this?"

Guidelines:
- 3-5 features maximum
- Each feature must connect to a hypothesis from the validation
- If a feature doesn't test willingness to pay or core value, cut it

## Step 3: Tech Stack Recommendation

Based on the founder's skills (from profile or ask directly):
- What language/framework gets to launch fastest?
- What hosting/infrastructure is simplest?
- What third-party services are needed?

Prioritize speed to ship over "best" technology. The right stack is the one the founder can ship in 2 weeks.

## Step 4: Landing Page Spec

Define:
- **Headline:** Value-focused, not feature-focused. What outcome does the user get?
- **Subhead:** Who it's for and what pain it solves.
- **CTA:** Specific action — "Start free trial", "Join waitlist", "Get early access"
- **3 Key Benefits:** Benefits, not features. What changes for the user?

## Step 5: Success Criteria

Define measurable signals for the first 2 weeks after launch:
- What number of signups indicates traction?
- What waitlist size justifies continued building?
- What conversion rate from landing page is acceptable?
- What qualitative feedback would confirm the value proposition?

Be specific: "50 signups in 2 weeks" not "good traction."

## Step 6: CLAUDE.md Draft

Generate a CLAUDE.md file that provides project context for the build phase:

```
# [Project Name]

## What This Is
[One-line description]

## Problem
[Problem statement from validation]

## Target User
[Target audience from validation]

## MVP Scope
[Week-1 feature list]

## Tech Stack
[Recommended stack]

## Success Criteria
[2-week metrics]

## Out of Scope (for now)
[Features explicitly cut from MVP]
```

## Output

Present the complete MVP spec using the template from `refs/output-templates.md`. The spec should be copy-paste ready — a coding agent should be able to read it and start building immediately.
