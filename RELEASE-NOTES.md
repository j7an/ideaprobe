# IdeaProbe Release Notes

## v0.1.0 (2026-04-04)

Initial release. Claude Code / Claude Desktop only.

**Skills (9):**
- `getting-started` — bootstrap router with founder profile setup
- `founder-profile` — view, update, reset founder profile
- `idea-generation` — generate 3-5 idea candidates for a domain
- `idea-validation` — full validation orchestrator with parallel research agents
- `market-research` — standalone demand signal analysis
- `competitor-analysis` — standalone competitor mapping and gap analysis
- `community-sentiment` — standalone community pain signal scanning
- `idea-comparison` — side-by-side ranking of 2-5 ideas
- `mvp-scoping` — convert validated idea into buildable MVP spec

**Agents (4):**
- `market-researcher` — demand data gathering via web search
- `competitor-scout` — competitor profiling and saturation assessment
- `sentiment-scanner` — Reddit/HN pain signal scanning
- `validation-reviewer` — critical review of validation reports

**Infrastructure:**
- Plugin manifest (`.claude-plugin/plugin.json`)
- Marketplace metadata (`.claude-plugin/marketplace.json`)
- Session-start hook for automatic bootstrap
- Version bump script (`scripts/bump-version.sh`)
- 5 shared reference files (`refs/`)
- Founder profile stored at `.ideaprobe/user-profile.md` (project-local)
