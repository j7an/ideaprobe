# Output Templates

Standardized formats for all IdeaProbe skill outputs. Skills must use these templates — do not output freeform prose.

## Validation Report

Used by: `idea-validation` skill

```
### [Idea Name] — Validation Report
**Verdict: [GO/EXPLORE/PIVOT/STOP]** (Score: XX/100)

| Dimension            | Score | Key Finding                    |
|----------------------|-------|--------------------------------|
| Demand Signals       | XX/20 | [one-line summary with source] |
| Competitor Landscape | XX/20 | [one-line summary with source] |
| Willingness to Pay   | XX/20 | [one-line summary with source] |
| Build Feasibility    | XX/20 | [one-line summary with source] |
| Founder Fit          | XX/20 | [one-line summary with source] |

**Top Risks:**
- [risk 1 — specific, not generic]
- [risk 2]
- [risk 3]

**Recommended Next Steps:**
- [action 1 — concrete, time-bound if possible]
- [action 2]
- [action 3]

**Data Sources Used:**
- [source 1 with URL]
- [source 2 with URL]
- [source 3 with URL]
```

## Comparison Table

Used by: `idea-comparison` skill

```
### Idea Comparison — Ranked Results

| Rank | Idea | Score | Verdict | Strongest Dimension | Weakest Dimension |
|------|------|-------|---------|---------------------|-------------------|
| 1    | [name] | XX/100 | [verdict] | [dimension] | [dimension] |
| 2    | [name] | XX/100 | [verdict] | [dimension] | [dimension] |

**Recommendation:** [Which to pursue and why, 2-3 sentences]
**Runner-up:** [What would make the #2 worth revisiting]
```

## MVP Specification

Used by: `mvp-scoping` skill

```
### [Idea Name] — MVP Specification

**Core Value Proposition:** [one sentence — what it does and for whom]

**Week-1 Feature Set:**
- [feature 1 — tests willingness to pay because...]
- [feature 2 — required because...]
- [feature 3 — required because...]
- Everything else is cut. Ship this first.

**Tech Stack:** [recommendation based on founder skills + speed to ship]

**Landing Page:**
- Headline: [value-focused, not feature-focused]
- Subhead: [who it's for and what pain it solves]
- CTA: [specific action — "Start free trial", "Join waitlist", etc.]
- Benefits: [3 key benefits, not features]

**Success Criteria (first 2 weeks):**
- [metric 1 — e.g., X signups from landing page]
- [metric 2 — e.g., Y waitlist conversions]
- [metric 3 — e.g., Z pre-orders or trial starts]

**CLAUDE.md Draft:**
[Project context file content ready for the build phase — includes problem statement, tech stack, MVP scope, success criteria, and constraints]
```

## Research Report

Used by: `market-research`, `competitor-analysis`, `community-sentiment` skills

```
### [Topic] — Research Report

**Summary:** [2-3 sentence overview of findings]

**Findings:**
[structured data — tables, lists, or sections as appropriate]
[every finding includes a source URL]

**Signal Strength:** [strong / moderate / weak / none — with justification]

**Recommended Next Step:** [which IdeaProbe skill to invoke next]
```

## Idea Generation Summary

Used by: `idea-generation` skill

```
### Ideas for [Domain] — Generation Report

| # | Idea | Problem | Audience | Demand Signal | Feasibility |
|---|------|---------|----------|---------------|-------------|
| 1 | [name] | [problem] | [who] | [signal] | [estimate] |
| 2 | [name] | [problem] | [who] | [signal] | [estimate] |

**Top Pick:** [which and why]
**Recommended Next Step:** Run `idea-comparison` for rigorous scoring, or `idea-validation` if one stands out.
```
