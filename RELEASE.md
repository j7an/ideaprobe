# Release Guide

Quick reference for releasing a new version of IdeaProbe.

## Prerequisites

- [ ] All changes merged to `main`
- [ ] `scripts/bump-version.sh --check` shows no version drift
- [ ] `scripts/bump-version.sh --audit` shows no undeclared version references
- [ ] Hook produces valid JSON: `bash hooks/session-start | python3 -m json.tool > /dev/null`

---

## Releasing a New Version

Run these commands in order:

    # 1. Start on main with latest changes
    git checkout main && git pull origin main

    # 2. Bump version across all declared files
    bash scripts/bump-version.sh 0.2.0   # replace with target version

    # 3. Verify versions are consistent
    bash scripts/bump-version.sh --check

    # 4. Audit for any undeclared version references
    bash scripts/bump-version.sh --audit

    # 5. Update RELEASE-NOTES.md with new version entry
    # Add a new section at the top: ## vX.Y.Z (YYYY-MM-DD)

    # 6. Commit version bump
    VERSION=$(python3 -c "import json; print(json.load(open('package.json'))['version'])")
    git add -A
    git commit -m "chore(release): v${VERSION}"

    # 7. Tag the release
    git tag -a "v${VERSION}" -m "v${VERSION}"

    # 8. Push commit and tag
    git push origin main
    git push origin "v${VERSION}"

    # 9. Create GitHub Release
    gh release create "v${VERSION}" \
      --title "v${VERSION}" \
      --notes-file RELEASE-NOTES.md

---

## After the Release

- [ ] Verify the tag exists: `git ls-remote --tags origin | grep "${VERSION}"`
- [ ] Verify the GitHub Release is published
- [ ] Test install from GitHub:

      claude plugin marketplace add https://github.com/j7an/ideaprobe.git
      claude plugin install ideaprobe@ideaprobe

- [ ] Verify skills load: start a new Claude Code session, confirm using-ideaprobe is injected
- [ ] If listed on official marketplace: verify `claude plugin update ideaprobe` picks up the new version

---

## Version Scheme

IdeaProbe follows [Semantic Versioning](https://semver.org/):

- **Patch** (0.1.1): Bug fixes, typo corrections, minor wording improvements in skills/refs
- **Minor** (0.2.0): New skills, new agents, new platform support, new refs
- **Major** (1.0.0): Breaking changes to skill behavior, scoring rubric changes, output format changes

---

## Files That Contain the Version

Managed by `.version-bump.json` and `scripts/bump-version.sh`:

| File | Field |
|------|-------|
| `package.json` | `version` |
| `.claude-plugin/plugin.json` | `version` |

Never edit versions manually — always use `bump-version.sh` to keep them in sync.

---

## Recovering from a Failed Release

### Tag pushed but release not created

Create the release manually:

    gh release create "v${VERSION}" \
      --title "v${VERSION}" \
      --notes-file RELEASE-NOTES.md

### Version bump committed but tag is wrong

Delete the tag and re-create:

    git tag -d "v${VERSION}"
    git push origin ":refs/tags/v${VERSION}"
    git tag -a "v${VERSION}" -m "v${VERSION}"
    git push origin "v${VERSION}"

### Need to yank a release

Delete the GitHub Release and tag, then publish a patch:

    gh release delete "v${VERSION}" --yes
    git tag -d "v${VERSION}"
    git push origin ":refs/tags/v${VERSION}"
    # Fix the issue, then release vX.Y.Z+1
