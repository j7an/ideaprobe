---
name: using-ideaprobe
description: "Bootstrap skill for IdeaProbe business idea validation. Use when the user mentions a business idea, asks 'is this worth building', wants to compare ideas, or is starting a new build cycle."
---

# IdeaProbe — Getting Started

You have IdeaProbe. It gives you business idea validation superpowers.

## First-Time Setup

Check if `.ideaprobe/user-profile.md` exists in the user's project directory.

**If it does not exist** (or still contains `[e.g.,` placeholder text), offer to set it up:

> "I have IdeaProbe for business idea validation. I notice your founder profile isn't set up yet — it takes about a minute and helps me score ideas for your specific skills and constraints. Want to set it up now?"

If the user agrees, ask these questions **one at a time**:
1. What are your technical skills and domain expertise?
2. Do you have an existing audience or distribution channel?
3. How much time can you dedicate? What's your budget for tools/infrastructure?
4. What's your revenue target and timeline?
5. Any preferences on how you want to build (solo, team, outsource)?

Write the answers to `.ideaprobe/user-profile.md` using the template format from `refs/user-profile.md`.

If the user declines, skip and proceed to the skill router below. Skills will ask founder fit questions inline when needed.

**If it already exists and is populated**, skip straight to the skill router.

## Available Skills

Based on where the user is in their journey, suggest the right skill:

| Situation | Skill to use |
|-----------|-------------|
| Doesn't have an idea yet | `idea-generation` — generates 3-5 candidates for a domain |
| Has a specific idea to evaluate | `idea-validation` — full validation with GO/EXPLORE/PIVOT/STOP verdict |
| Has multiple ideas, needs to choose | `idea-comparison` — side-by-side ranked scoring |
| Wants deeper research on demand | `market-research` — demand signal deep dive |
| Wants deeper research on competition | `competitor-analysis` — competitor mapping and gap analysis |
| Wants to find community pain signals | `community-sentiment` — Reddit/HN pain scanning |
| Has a validated idea (GO or EXPLORE ≥60) | `mvp-scoping` — converts validated idea into buildable MVP spec |
| Wants to view/update/reset profile | `founder-profile` — manage founder profile |

## Behavioral Guidelines

When using any IdeaProbe skill:
- **Always present structured scores and verdicts** — use the output templates, not freeform prose
- **Cite specific data points, not vibes** — every score needs evidence
- **Be honest about weak signals** — don't oversell moderate results as strong
- **When the verdict is STOP, say so clearly** — a clear STOP saves months of wasted effort
- **Absence of signal IS a signal** — if nobody's complaining, there may be no market

## Important

- Do NOT skip validation and jump straight to building
- Do NOT present validation results without structured scores
- These skills work best with a populated founder profile but function without one
