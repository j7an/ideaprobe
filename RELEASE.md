# Release Guide

Quick reference for releasing a new version of IdeaProbe.

## Prerequisites

- [ ] All changes merged to `main`
- [ ] `scripts/bump-version.sh --check` shows no version drift
- [ ] `scripts/bump-version.sh --audit` shows no undeclared version references
- [ ] Hook produces valid JSON: `bash hooks/session-start | python3 -m json.tool > /dev/null`

---

## Releasing a New Version

### Phase 1: Version bump on a branch

    # 1. Start on main with latest changes
    git checkout main && git pull origin main

    # 2. Create release branch
    VERSION=0.2.0   # replace with target version
    git checkout -b "chore/release-v${VERSION}"

    # 3. Bump version across all declared files
    bash scripts/bump-version.sh "$VERSION"

    # 4. Verify versions are consistent
    bash scripts/bump-version.sh --check

    # 5. Audit for any undeclared version references
    bash scripts/bump-version.sh --audit

    # 6. Update RELEASE-NOTES.md
    # Add a new section at the top: ## vX.Y.Z (YYYY-MM-DD)
    # Only include changes for THIS version, not prior versions

    # 7. Commit and push
    git add package.json .claude-plugin/plugin.json RELEASE-NOTES.md
    git commit -m "chore(release): v${VERSION}"
    git push -u origin "chore/release-v${VERSION}"

    # 8. Create PR and merge
    gh pr create --title "chore(release): v${VERSION}" --body "Version bump to v${VERSION}"
    # Merge via GitHub, then continue to Phase 2

### Phase 2: Tag and release from main

    # 9. Switch to main with the merged release commit
    git checkout main && git pull origin main

    # 10. Tag the release
    VERSION=$(python3 -c "import json; print(json.load(open('package.json'))['version'])")
    git tag -a "v${VERSION}" -m "v${VERSION}"
    git push origin "v${VERSION}"

    # 11. Create GitHub Release (only this version's notes, not the full file)
    # Extract the current version's section from RELEASE-NOTES.md:
    NOTES="$(sed -n '/^## v'"${VERSION}"'/,/^---$/p' RELEASE-NOTES.md | sed '$d')"
    if [ -z "$NOTES" ]; then
      echo "ERROR: No release notes found for v${VERSION} in RELEASE-NOTES.md"
      echo "Did you forget to update RELEASE-NOTES.md in step 6?"
      exit 1
    fi
    gh release create "v${VERSION}" \
      --title "v${VERSION}" \
      --notes "$NOTES"

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
