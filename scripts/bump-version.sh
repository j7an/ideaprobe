#!/bin/bash
set -euo pipefail

# IdeaProbe version bump script
# Usage:
#   bump-version.sh <new-version>  — bumps all declared files to new version
#   bump-version.sh --check        — reports current versions, detects drift
#   bump-version.sh --audit        — scans repo for undeclared version references

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_FILE="$REPO_ROOT/.version-bump.json"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: .version-bump.json not found at $REPO_ROOT"
  exit 1
fi

# Parse the config file
FILES=$(python3 -c "
import json
config = json.load(open('$CONFIG_FILE'))
for f in config['files']:
    print(f['path'] + '|' + f['field'])
")

EXCLUDES=$(python3 -c "
import json
config = json.load(open('$CONFIG_FILE'))
for e in config.get('audit', {}).get('exclude', []):
    print(e)
")

get_version() {
    local file_path="$1"
    local field="$2"
    python3 -c "
import json
data = json.load(open('$REPO_ROOT/$file_path'))
print(data['$field'])
"
}

set_version() {
    local file_path="$1"
    local field="$2"
    local new_version="$3"
    python3 -c "
import json
path = '$REPO_ROOT/$file_path'
data = json.load(open(path))
data['$field'] = '$new_version'
json.dump(data, open(path, 'w'), indent=2)
print('  Updated: $file_path -> $new_version')
" 2>&1
    # Add trailing newline to JSON files
    echo "" >> "$REPO_ROOT/$file_path"
}

case "${1:-}" in
    --check)
        echo "Version check:"
        echo ""
        FIRST_VERSION=""
        DRIFT=false
        while IFS='|' read -r path field; do
            version=$(get_version "$path" "$field")
            echo "  $path ($field): $version"
            if [ -z "$FIRST_VERSION" ]; then
                FIRST_VERSION="$version"
            elif [ "$version" != "$FIRST_VERSION" ]; then
                DRIFT=true
            fi
        done <<< "$FILES"
        echo ""
        if [ "$DRIFT" = true ]; then
            echo "WARNING: Version drift detected!"
            exit 1
        else
            echo "All versions consistent: $FIRST_VERSION"
        fi
        ;;

    --audit)
        echo "Auditing for undeclared version references..."
        echo ""
        # Get current version from first declared file
        FIRST_PATH=$(echo "$FILES" | head -1 | cut -d'|' -f1)
        FIRST_FIELD=$(echo "$FILES" | head -1 | cut -d'|' -f2)
        CURRENT=$(get_version "$FIRST_PATH" "$FIRST_FIELD")

        # Build exclude args for grep
        # Apply each exclude as both --exclude (file) and --exclude-dir (directory)
        EXCLUDE_ARGS=""
        while IFS= read -r exclude; do
            [ -z "$exclude" ] && continue
            EXCLUDE_ARGS="$EXCLUDE_ARGS --exclude=$exclude --exclude-dir=$exclude"
        done <<< "$EXCLUDES"

        # Search for version string in repo
        # --include must come before --exclude for grep to respect both
        FOUND=$(cd "$REPO_ROOT" && grep -r --include="*.json" --include="*.md" --include="*.sh" $EXCLUDE_ARGS "$CURRENT" -l 2>/dev/null || true)

        # Filter out declared files (normalize paths by stripping leading ./)
        DECLARED_PATHS=$(echo "$FILES" | cut -d'|' -f1)
        UNDECLARED=""
        for f in $FOUND; do
            NORMALIZED=$(echo "$f" | sed 's|^\./||')
            if ! echo "$DECLARED_PATHS" | grep -q "^${NORMALIZED}$"; then
                UNDECLARED="$UNDECLARED $f"
            fi
        done

        if [ -z "$UNDECLARED" ]; then
            echo "No undeclared version references found."
        else
            echo "Undeclared version references found in:"
            for f in $UNDECLARED; do
                echo "  $f"
            done
            echo ""
            echo "Consider adding these to .version-bump.json or excluding them."
        fi
        ;;

    "")
        echo "Usage:"
        echo "  $0 <new-version>  — bump all files to new version"
        echo "  $0 --check        — check for version drift"
        echo "  $0 --audit        — find undeclared version references"
        exit 1
        ;;

    *)
        NEW_VERSION="$1"
        echo "Bumping to version $NEW_VERSION:"
        echo ""
        while IFS='|' read -r path field; do
            set_version "$path" "$field" "$NEW_VERSION"
        done <<< "$FILES"
        echo ""
        echo "Done. Run '$0 --check' to verify."
        ;;
esac
