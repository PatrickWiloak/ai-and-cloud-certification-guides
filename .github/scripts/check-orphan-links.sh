#!/usr/bin/env bash
# List markdown files that no other markdown file references.
#
# An "orphan" is a .md file under content roots (learn/, resources/, exams/, topics/, docs/)
# whose basename + relative path doesn't appear inside any other .md file's body.
#
# Files in cert `notes/` subdirs are treated as expected-orphans when their parent cert
# directory IS referenced. Cert notes are conceptually part of a directory hierarchy that's
# linked via STUDY-HUB and topic indexes; they're discoverable via GitHub directory listing
# even if no markdown file links to them by basename.
#
# This is a hint, not a rule. Review the output manually before deleting anything.
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

# Returns 0 if the file is inside a cert tree whose root dir is referenced anywhere.
# Heuristic: file is at exams/<provider>/.../<cert-dir>/notes/*.md, and the cert dir path
# appears somewhere in the haystack.
is_cert_notes_under_linked_cert() {
    local f="$1"
    local haystack="$2"
    [[ "$f" == exams/* ]] || return 1
    [[ "$f" == */notes/* ]] || return 1
    # Walk up to the directory containing the notes/ subdir.
    local cert_dir="${f%/notes/*}"
    # Search haystack for any reference to that cert directory path.
    grep -qF "$cert_dir" "$haystack" && return 0
    return 1
}

# Returns 0 if the file is in a `services/` or `shared/` subdir that's referenced via parent.
is_under_referenced_subtree() {
    local f="$1"
    local haystack="$2"
    # Some content lives in shared/services trees (e.g., exams/aws/shared/services/compute/...)
    # which are typically referenced by parent dir.
    local dir
    dir="${f%/*}"
    while [[ "$dir" == */* ]]; do
        if grep -qF "$dir/" "$haystack"; then
            return 0
        fi
        dir="${dir%/*}"
    done
    return 1
}

# Build the haystack: concatenate all .md content into a temp file (for one grep instead of N).
# Include root-level .md files (README.md, STUDY-HUB.md, CHANGELOG.md, etc.) since they
# contain the bulk of cross-references into the content tree.
haystack=$(mktemp)
trap 'rm -f "$haystack"' EXIT
{
    find learn resources exams topics docs assets -name "*.md" -type f -print0 2>/dev/null
    find . -maxdepth 1 -name "*.md" -type f -print0 2>/dev/null
} | xargs -0 cat > "$haystack" 2>/dev/null

orphan_count=0
checked=0
covered_by_subtree=0

# Look for .md files that no other file references by basename.
while IFS= read -r f; do
    checked=$((checked + 1))
    is_expected_root "$f" && continue

    base="${f##*/}"

    # README.md basenames are too generic to match meaningfully - skip and treat dir as
    # the link target for orphan-detection purposes.
    if [[ "$base" == "README.md" ]]; then
        parent="${f%/README.md}"
        if grep -qF "$parent" "$haystack"; then
            continue
        fi
        # Top-level README at content root (e.g., learn/concepts/README.md) is also expected.
        depth=$(awk -F'/' '{print NF-1}' <<< "$f")
        if [[ "$depth" -le 2 ]]; then continue; fi
        echo "  $f"
        orphan_count=$((orphan_count + 1))
        continue
    fi

    # Direct basename match in haystack means it's linked somewhere.
    if grep -qF "$base" "$haystack"; then
        continue
    fi

    # Cert notes inside a referenced cert directory are not orphans.
    if is_cert_notes_under_linked_cert "$f" "$haystack"; then
        covered_by_subtree=$((covered_by_subtree + 1))
        continue
    fi

    # Files inside a referenced parent subtree (e.g., shared service catalogs).
    if is_under_referenced_subtree "$f" "$haystack"; then
        covered_by_subtree=$((covered_by_subtree + 1))
        continue
    fi

    echo "  $f"
    orphan_count=$((orphan_count + 1))
done < <(find learn resources exams topics docs -name "*.md" -type f 2>/dev/null | sort)

echo ""
echo "Summary: $checked .md files checked. Orphans (no inbound links found): $orphan_count."
echo "         (additionally, $covered_by_subtree files covered by a referenced parent dir)"
echo ""
echo "Note: orphans are a hint, not a rule. Review each manually - some are intentional"
echo "(e.g., new content not yet linked, or content discoverable only via directory listing)."
