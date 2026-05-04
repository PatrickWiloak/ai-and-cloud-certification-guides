#!/usr/bin/env bash
# List markdown files that no other markdown file references.
#
# An "orphan" is a .md file under content roots (learn/, resources/, exams/, topics/, docs/)
# whose basename + relative path doesn't appear inside any other .md file's body.
#
# This is a hint, not a rule. Some orphans are intentional (top-level READMEs, CHANGELOG,
# CONTRIBUTING, navigation hubs). Review the output manually before deleting anything.
#
# Run locally: bash .github/scripts/check-orphan-links.sh

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT" || exit 1

# Files we never expect to be linked from elsewhere (entry points, indexes).
EXPECTED_ROOTS=(
    "README.md"
    "STUDY-HUB.md"
    "CHANGELOG.md"
    "CONTRIBUTING.md"
    "CLAUDE.md"
)

is_expected_root() {
    local f="$1"
    for r in "${EXPECTED_ROOTS[@]}"; do
        [[ "$f" == "$r" ]] && return 0
    done
    return 1
}

# Build the haystack: concatenate all .md content into a temp file (for one grep instead of N).
haystack=$(mktemp)
trap 'rm -f "$haystack"' EXIT
find learn resources exams topics docs assets -name "*.md" -type f -print0 2>/dev/null | xargs -0 cat > "$haystack" 2>/dev/null

orphan_count=0
checked=0

# Look for .md files that no other file references by basename.
while IFS= read -r f; do
    checked=$((checked + 1))
    is_expected_root "$f" && continue

    base="${f##*/}"

    # README.md basenames are too generic to match meaningfully - skip and treat dir as
    # the link target for orphan-detection purposes.
    if [[ "$base" == "README.md" ]]; then
        # Look for the parent dir path being linked instead (e.g., "(./learn/concepts/)").
        parent="${f%/README.md}"
        if grep -q "$parent" "$haystack"; then
            continue
        fi
        # Top-level README at content root (e.g., learn/concepts/README.md) is also expected.
        depth=$(awk -F'/' '{print NF-1}' <<< "$f")
        if [[ "$depth" -le 2 ]]; then continue; fi
        echo "  $f"
        orphan_count=$((orphan_count + 1))
        continue
    fi

    # Search for the basename in the concatenated haystack.
    if ! grep -qF "$base" "$haystack"; then
        echo "  $f"
        orphan_count=$((orphan_count + 1))
    fi
done < <(find learn resources exams topics docs -name "*.md" -type f 2>/dev/null | sort)

echo ""
echo "Summary: $checked .md files checked. Orphans (no inbound links found): $orphan_count."
echo ""
echo "Note: orphans are a hint, not a rule. Review each manually - some are intentional"
echo "(e.g., new content not yet linked, or content discoverable only via directory listing)."
