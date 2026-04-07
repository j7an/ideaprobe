# IdeaProbe Release Notes

## v0.1.1 (2026-04-06)

Test suite and bug fixes. No skill or agent changes.

**Test Suite:**
- Three-tier test pyramid: infrastructure (25 tests, ~4s), behavioral (4 tests, ~40s), integration (1 test, 10-30 min)
- Infrastructure tests: hook output, version consistency, JSON manifests, YAML frontmatter, cross-references
- Behavioral tests: focused skill-content prompts with 30s timeout (scoring dimensions, agent dispatch rules, verdict thresholds, skill routing)
- Integration tests: scoring pipeline with pre-baked data (fast mode, ~50s) and full validation workflow with agent dispatch
- Shared assertion library (`tests/test-helpers.sh`) modeled on Superpowers plugin
- Test runner with `--behavioral`, `--all`, `--all --fast`, `--test`, `--verbose`, `--timeout` flags
- Portable timeout: `timeout` → `gtimeout` → perl fallback for macOS compatibility

**Bug Fixes:**
- Fix `marketplace.json` schema — use marketplace directory format, not plugin manifest (#3)
- Remove `skills`/`agents` fields from `plugin.json` — Claude Code discovers these by convention (#4)
- Rename `getting-started` skill to `using-ideaprobe` for clarity (#5)
- Fix `bump-version.sh --audit` grep ordering and path normalization (#2)

**npm scripts:**
- `npm test` — infrastructure only
- `npm run test:behavioral` — + skill-content tests
- `npm run test:all:fast` — + scoring pipeline (Sonnet, medium effort)
- `npm run test:all` — + full validation workflow

---

## v0.1.0 (2026-04-04)

Initial release. Claude Code / Claude Desktop only.

**Skills (9):**
- `using-ideaprobe` — bootstrap router with founder profile setup
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
