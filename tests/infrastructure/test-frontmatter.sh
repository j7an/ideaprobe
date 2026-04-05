#!/bin/bash
# Test: YAML frontmatter in all skills and agents

setup_test "YAML Frontmatter"

# ─── Helper: extract frontmatter ─────────────
# Extracts text between first two --- lines
extract_frontmatter() {
    local file="$1"
    sed -n '1,/^---$/p' "$file" | tail -n +2 | sed '$d'
    # If file starts with ---, sed grabs line 1 through next ---.
    # tail -n +2 strips the first ---, sed '$d' strips the last ---.
}

# ─── Skills ───────────────────────────────────

skill_count=0
skill_pass=true

for skill_dir in "$REPO_ROOT"/skills/*/; do
    skill_file="$skill_dir/SKILL.md"
    [ -f "$skill_file" ] || continue
    skill_count=$((skill_count + 1))
    skill_name=$(basename "$skill_dir")

    # Check starts with ---
    first_line=$(head -1 "$skill_file")
    if [ "$first_line" != "---" ]; then
        fail_test "skills/$skill_name/SKILL.md starts with ---"
        skill_pass=false
        continue
    fi

    # Extract and check frontmatter fields
    fm=$(extract_frontmatter "$skill_file")

    if ! echo "$fm" | grep -q "^name:"; then
        fail_test "skills/$skill_name/SKILL.md has name: field"
        skill_pass=false
        continue
    fi

    if ! echo "$fm" | grep -q "^description:"; then
        fail_test "skills/$skill_name/SKILL.md has description: field"
        skill_pass=false
        continue
    fi

    # Check name is not empty
    name_value=$(echo "$fm" | grep "^name:" | sed 's/^name: *//' | tr -d '"')
    if [ -z "$name_value" ]; then
        fail_test "skills/$skill_name/SKILL.md has non-empty name"
        skill_pass=false
        continue
    fi

    # Check description is not empty
    desc_value=$(echo "$fm" | grep "^description:" | sed 's/^description: *//' | tr -d '"')
    if [ -z "$desc_value" ]; then
        fail_test "skills/$skill_name/SKILL.md has non-empty description"
        skill_pass=false
        continue
    fi
done

if [ "$skill_pass" = true ] && [ "$skill_count" -gt 0 ]; then
    pass_test "All $skill_count skills have valid frontmatter (---, name, description)"
fi

# ─── Agents ───────────────────────────────────

agent_count=0
agent_pass=true

for agent_file in "$REPO_ROOT"/agents/*.md; do
    [ -f "$agent_file" ] || continue
    agent_count=$((agent_count + 1))
    agent_name=$(basename "$agent_file" .md)

    # Check starts with ---
    first_line=$(head -1 "$agent_file")
    if [ "$first_line" != "---" ]; then
        fail_test "agents/$agent_name.md starts with ---"
        agent_pass=false
        continue
    fi

    # Extract and check frontmatter fields
    fm=$(extract_frontmatter "$agent_file")

    if ! echo "$fm" | grep -q "^name:"; then
        fail_test "agents/$agent_name.md has name: field"
        agent_pass=false
        continue
    fi

    if ! echo "$fm" | grep -q "^description:"; then
        fail_test "agents/$agent_name.md has description: field"
        agent_pass=false
        continue
    fi

    # Check name is not empty
    name_value=$(echo "$fm" | grep "^name:" | sed 's/^name: *//' | tr -d '"')
    if [ -z "$name_value" ]; then
        fail_test "agents/$agent_name.md has non-empty name"
        agent_pass=false
        continue
    fi

    # Check description is not empty
    desc_value=$(echo "$fm" | grep "^description:" | sed 's/^description: *//' | tr -d '"')
    if [ -z "$desc_value" ]; then
        fail_test "agents/$agent_name.md has non-empty description"
        agent_pass=false
        continue
    fi
done

if [ "$agent_pass" = true ] && [ "$agent_count" -gt 0 ]; then
    pass_test "All $agent_count agents have valid frontmatter (---, name, description)"
fi

# Sanity: we found some skills and agents
if [ "$skill_count" -eq 0 ]; then
    fail_test "At least one skill found" "No skills/*/SKILL.md files found"
fi
if [ "$agent_count" -eq 0 ]; then
    fail_test "At least one agent found" "No agents/*.md files found"
fi
