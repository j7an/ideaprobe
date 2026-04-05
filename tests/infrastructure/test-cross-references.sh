#!/bin/bash
# Test: cross-references between skills, agents, and refs

setup_test "Cross-References"

# ─── Test 1: refs/ files referenced in skills exist ───

refs_pass=true
refs_checked=0

for skill_file in "$REPO_ROOT"/skills/*/SKILL.md; do
    [ -f "$skill_file" ] || continue
    # Extract refs/ paths — match backtick-quoted or plain refs/... patterns
    refs_found=$(grep -oE 'refs/[a-zA-Z0-9_-]+\.md' "$skill_file" | sort -u)
    for ref_path in $refs_found; do
        refs_checked=$((refs_checked + 1))
        if [ ! -f "$REPO_ROOT/$ref_path" ]; then
            skill_name=$(basename "$(dirname "$skill_file")")
            fail_test "Reference exists: $ref_path (from skills/$skill_name)"
            refs_pass=false
        fi
    done
done

if [ "$refs_pass" = true ] && [ "$refs_checked" -gt 0 ]; then
    pass_test "All $refs_checked refs/ references in skills point to existing files"
fi

# ─── Test 2: agent names in skills have matching files ───

agents_pass=true
agents_checked=0

# Known agent names referenced in skills (ideaprobe:<name> pattern)
for skill_file in "$REPO_ROOT"/skills/*/SKILL.md; do
    [ -f "$skill_file" ] || continue
    agent_refs=$(grep -oE 'ideaprobe:[a-zA-Z0-9_-]+' "$skill_file" | sort -u)
    for agent_ref in $agent_refs; do
        agent_name="${agent_ref#ideaprobe:}"
        # Skip skill references — only check agent references
        # Agents are in agents/*.md, skills are in skills/*/SKILL.md
        if [ -f "$REPO_ROOT/agents/$agent_name.md" ]; then
            agents_checked=$((agents_checked + 1))
        elif [ -d "$REPO_ROOT/skills/$agent_name" ]; then
            # It's a skill reference, not an agent — skip
            continue
        else
            skill_name=$(basename "$(dirname "$skill_file")")
            fail_test "Agent exists: agents/$agent_name.md (referenced in skills/$skill_name)"
            agents_pass=false
            agents_checked=$((agents_checked + 1))
        fi
    done
done

if [ "$agents_pass" = true ] && [ "$agents_checked" -gt 0 ]; then
    pass_test "All $agents_checked agent references in skills have matching files"
fi

# ─── Test 3: skills listed in router have matching directories ───

router_file="$REPO_ROOT/skills/using-ideaprobe/SKILL.md"
router_pass=true
router_checked=0

if [ -f "$router_file" ]; then
    # Extract skill names from the router table (backtick-quoted names)
    router_skills=$(grep -oE '`[a-zA-Z0-9_-]+`' "$router_file" | tr -d '`' | sort -u)
    for skill_name in $router_skills; do
        # Only check if it looks like a skill name (has a matching directory)
        # Skip generic words that happen to be in backticks
        if [ -d "$REPO_ROOT/skills/$skill_name" ]; then
            router_checked=$((router_checked + 1))
        elif echo "$skill_name" | grep -qE '^(idea|market|competitor|community|mvp|founder|using)'; then
            # Looks like it should be a skill name but directory is missing
            fail_test "Router skill exists: skills/$skill_name/SKILL.md"
            router_pass=false
            router_checked=$((router_checked + 1))
        fi
        # Otherwise it's just a backtick-quoted word, not a skill name — skip
    done
fi

if [ "$router_pass" = true ] && [ "$router_checked" -gt 0 ]; then
    pass_test "All $router_checked skills in router have matching directories"
fi

# ─── Test 4: no orphaned agents ──────────────

orphan_pass=true
orphan_checked=0

for agent_file in "$REPO_ROOT"/agents/*.md; do
    [ -f "$agent_file" ] || continue
    agent_name=$(basename "$agent_file" .md)
    orphan_checked=$((orphan_checked + 1))

    # Check if any skill references this agent
    if ! grep -rq "ideaprobe:$agent_name" "$REPO_ROOT/skills/"; then
        fail_test "Agent is referenced: $agent_name (not found in any skill)"
        orphan_pass=false
    fi
done

if [ "$orphan_pass" = true ] && [ "$orphan_checked" -gt 0 ]; then
    pass_test "All $orphan_checked agents are referenced by at least one skill"
fi
