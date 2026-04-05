---
name: founder-profile
description: "View, update, or reset your founder profile. Use when the user wants to change their skills, constraints, goals, or reset their profile."
---

# Founder Profile Management

Manage the founder profile used by IdeaProbe skills to score Founder Fit and personalize recommendations.

## Profile Location

- **Plugin template (read-only):** `refs/user-profile.md` — shows the expected format
- **User's profile (read/write):** `.ideaprobe/user-profile.md` in the project directory

## Actions

### View

1. Read `.ideaprobe/user-profile.md` from the project directory
2. If it doesn't exist, tell the user: "No founder profile found. Want me to set one up?"
3. If it exists, display the current profile contents

### Update

1. Read the current profile from `.ideaprobe/user-profile.md`
2. Ask the user which section they want to update:
   - Skills & Expertise
   - Distribution & Network
   - Constraints
   - Goals
3. Ask follow-up questions for just that section
4. Update the section in place, preserving other sections unchanged
5. Write back to `.ideaprobe/user-profile.md`
6. Confirm the update by showing the changed section

### Reset

1. Confirm with the user: "This will delete your current profile and start fresh. Continue?"
2. If confirmed, delete `.ideaprobe/user-profile.md`
3. Run the full profile questionnaire (same as using-ideaprobe first-time setup):
   - Technical skills and domain expertise
   - Existing audience or distribution channel
   - Time availability and budget
   - Revenue target and timeline
   - Build preferences
4. Write the new profile to `.ideaprobe/user-profile.md`

## Profile Format

The profile must follow the template structure from `refs/user-profile.md`:

```
# Founder Profile

## Skills & Expertise
- Technical skills: [filled in]
- Domain knowledge: [filled in]
- Years of experience: [filled in]

## Distribution & Network
- Existing audience: [filled in]
- Professional network: [filled in]
- Communities active in: [filled in]

## Constraints
- Time available: [filled in]
- Budget: [filled in]
- Risk tolerance: [filled in]

## Goals
- Revenue target: [filled in]
- Exit strategy: [filled in]
- Build preference: [filled in]
```

## Detecting Unpopulated Profiles

A profile is considered unpopulated if it contains `[e.g.,` — this indicates template placeholder text that hasn't been replaced.
