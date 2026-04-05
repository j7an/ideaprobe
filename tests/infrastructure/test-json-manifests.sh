#!/bin/bash
# Test: plugin.json and marketplace.json — validates structure and fields

setup_test "JSON Manifests"

PLUGIN_JSON="$REPO_ROOT/.claude-plugin/plugin.json"
MARKETPLACE_JSON="$REPO_ROOT/.claude-plugin/marketplace.json"

# ─── plugin.json ──────────────────────────────

# Test 1: plugin.json is valid JSON
assert_json_valid "$PLUGIN_JSON" "plugin.json is valid JSON"

# Test 2: Required fields present
plugin_fields=$(python3 -c "
import json
data = json.load(open('$PLUGIN_JSON'))
required = ['name', 'version', 'description', 'author']
missing = [f for f in required if f not in data]
print('ok' if not missing else 'missing: ' + ', '.join(missing))
")
if [ "$plugin_fields" = "ok" ]; then
    pass_test "plugin.json has required fields (name, version, description, author)"
else
    fail_test "plugin.json has required fields" "$plugin_fields"
fi

# Test 3: No forbidden fields
forbidden_fields=$(python3 -c "
import json
data = json.load(open('$PLUGIN_JSON'))
forbidden = ['skills', 'agents']
found = [f for f in forbidden if f in data]
print('ok' if not found else 'found: ' + ', '.join(found))
")
if [ "$forbidden_fields" = "ok" ]; then
    pass_test "plugin.json has no forbidden fields (skills, agents)"
else
    fail_test "plugin.json has no forbidden fields" "$forbidden_fields"
fi

# ─── marketplace.json ─────────────────────────

# Test 4: marketplace.json is valid JSON
assert_json_valid "$MARKETPLACE_JSON" "marketplace.json is valid JSON"

# Test 5: Has required fields ($schema, owner, plugins)
marketplace_fields=$(python3 -c "
import json
data = json.load(open('$MARKETPLACE_JSON'))
checks = []
if '\$schema' not in data: checks.append('\$schema')
if 'owner' not in data: checks.append('owner')
if 'plugins' not in data: checks.append('plugins')
print('ok' if not checks else 'missing: ' + ', '.join(checks))
")
if [ "$marketplace_fields" = "ok" ]; then
    pass_test "marketplace.json has required fields (\$schema, owner, plugins)"
else
    fail_test "marketplace.json has required fields" "$marketplace_fields"
fi

# Test 6: plugins array is non-empty
plugins_count=$(python3 -c "
import json
data = json.load(open('$MARKETPLACE_JSON'))
print(len(data.get('plugins', [])))
")
if [ "$plugins_count" -gt 0 ]; then
    pass_test "marketplace.json plugins array is non-empty ($plugins_count plugin(s))"
else
    fail_test "marketplace.json plugins array is non-empty" "Array is empty"
fi
