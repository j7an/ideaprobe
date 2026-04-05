---
name: idea-generation
description: "Generate business idea candidates for a specific domain or problem space. Use when the user wants ideas, asks 'what should I build', or specifies a domain to explore."
---

# Idea Generation

Generate 3-5 structured business idea candidates for a specific domain or problem space. This skill helps users who don't yet have an idea find promising candidates to validate.

## Context Loading

Read these files before proceeding:
1. `refs/methodology.md` — validation philosophy and principles
2. `refs/scoring-rubric.md` — understand what makes an idea score well
3. `refs/data-sources.md` — where to research the domain

Also load `.ideaprobe/user-profile.md` from the project directory if it exists (used to align ideas with founder's skills and constraints).

## Step 1: Gather Constraints

Ask the user (skip questions already answered by the founder profile):

1. **Target domain:** What area or industry are you interested in? (e.g., developer tools, healthcare, education, e-commerce)
2. **Skills to leverage:** What technical skills or domain expertise do you bring? (skip if in profile)
3. **Time budget:** How much time can you invest in building? (skip if in profile)
4. **Revenue goals:** What revenue target makes this worthwhile? (skip if in profile)
5. **Preferences:** Any specific constraints? (e.g., "no consumer apps", "B2B only", "must be API-based")

## Step 2: Research the Domain

Using web search and the data sources from `refs/data-sources.md`:

1. Search for common pain points in the target domain
2. Look for "I wish there was..." and "Why doesn't anyone build..." posts
3. Check what tools exist and what people complain about
4. Identify underserved segments or emerging trends
5. Note any regulatory or market timing factors

## Step 3: Generate 3-5 Ideas

For each idea, provide:

- **Idea name:** Short, memorable name
- **Problem statement:** What specific problem does this solve? (one sentence)
- **Target audience:** Who has this problem?
- **Proposed solution:** What would you build? (one sentence)
- **Why now:** What's changed that makes this timely?
- **Preliminary demand signal:** What evidence suggests people want this? (cite sources)
- **Rough feasibility:** Can this be built in 2-4 weeks as an MVP?

Prioritize ideas that:
- Align with the founder's skills (from profile or inline answers)
- Have observable demand signals (not speculative)
- Can be built and launched quickly
- Have a clear path to revenue

## Step 4: Present Summary

Use the Idea Generation Summary template from `refs/output-templates.md`.

Present ideas in a ranked table, highlight the top pick and why, then suggest next steps:
- "Want to compare these rigorously? Use `idea-comparison` for scored side-by-side ranking."
- "One idea stand out? Use `idea-validation` for a full GO/STOP verdict."
