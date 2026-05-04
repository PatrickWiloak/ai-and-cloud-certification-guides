#!/usr/bin/env bash
# Validate YAML frontmatter on key markdown surfaces.
#
# Scope:
#   - learn/concepts/*.md
#   - learn/*.md (top-level learn pages)
#   - resources/hands-on-projects/*.md
#   - exams/<provider>/<cert>/fact-sheet.md (every cert with a notes/ subdir)
#
# Behavior:
#   FAIL on malformed YAML (frontmatter started with `---` but no closing `---` in first 30 lines)
#   FAIL on bad date format (must be YYYY-MM-DD if present)
#   WARN on missing `last-updated` field
#   WARN on `last-updated` older than 180 days
#
# README.md files are skipped - they're navigation indexes, not content.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT" || exit 1

today_epoch=$(date -u +%s)
stale_threshold_seconds=$((180 * 24 * 60 * 60))

fail_count=0
warn_count=0
checked=0

check_file() {
    local f="$1"
    [[ -f "$f" ]] || return 0
    local base="${f##*/}"
    [[ "$base" == "README.md" ]] && return 0
    checked=$((checked + 1))

    # No frontmatter at all? warn (missing last-updated).
    if ! head -1 "$f" | grep -q "^---$"; then
        echo "WARN  $f"
        echo "      missing frontmatter (no last-updated)"
        warn_count=$((warn_count + 1))
        return 0
    fi

    # Find closing --- within first 30 lines (after the opener at line 1).
    local close_line
    close_line=$(awk 'NR==1{next} /^---$/{print NR; exit} NR>30{exit}' "$f")
    if [[ -z "$close_line" ]]; then
        echo "FAIL  $f"
        echo "      frontmatter opened with --- but no closing --- found in first 30 lines"
        fail_count=$((fail_count + 1))
        return 0
    fi

    # Extract last-updated value (may be missing).
    local raw_date
    raw_date=$(sed -n "2,${close_line}p" "$f" | grep -E '^last-updated:' | head -1 | awk '{print $2}')

    if [[ -z "$raw_date" ]]; then
        echo "WARN  $f"
        echo "      frontmatter present but no last-updated field"
        warn_count=$((warn_count + 1))
        return 0
    fi

    # Validate format YYYY-MM-DD.
    if ! [[ "$raw_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        echo "FAIL  $f"
        echo "      malformed last-updated value: '$raw_date' (expected YYYY-MM-DD)"
        fail_count=$((fail_count + 1))
        return 0
    fi

    # Check staleness.
    local file_epoch
    file_epoch=$(date -d "$raw_date" +%s 2>/dev/null || echo 0)
    if [[ "$file_epoch" -eq 0 ]]; then
        echo "FAIL  $f"
        echo "      could not parse last-updated date: $raw_date"
        fail_count=$((fail_count + 1))
        return 0
    fi
    local age=$((today_epoch - file_epoch))
    if [[ "$age" -gt "$stale_threshold_seconds" ]]; then
        local days=$((age / 86400))
        echo "WARN  $f"
        echo "      last-updated is $days days old ($raw_date) - aim for re-verification every 180 days"
        warn_count=$((warn_count + 1))
    fi
}

# Concept pages
for f in learn/concepts/*.md; do check_file "$f"; done

# Top-level learn pages
for f in learn/*.md; do check_file "$f"; done

# Hands-on projects
for f in resources/hands-on-projects/*.md; do check_file "$f"; done

# Cert fact-sheets
mapfile -t cert_dirs < <(find exams -type d -name notes | sed 's|/notes$||' | sort)
for dir in "${cert_dirs[@]}"; do
    check_file "$dir/fact-sheet.md"
done

echo ""
echo "Summary: $checked files checked. Failures: $fail_count. Warnings: $warn_count."

if [[ $fail_count -gt 0 ]]; then
    exit 1
fi
exit 0
