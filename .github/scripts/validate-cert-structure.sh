#!/usr/bin/env bash
# Validate that every cert directory under exams/ has the required files.
#
# Required (fail on missing): README.md
# Recommended (warn on missing): fact-sheet.md, practice-plan.md, scenarios.md, strategy.md
#
# A "cert directory" is any directory under exams/<provider>/ that contains a notes/ subdir.
# This excludes provider tier dirs like exams/aws/associate/ and shared dirs like exams/aws/shared/.
#
# The bar is intentionally low: any cert dir missing README.md is malformed.
# Everything else is recommended - CI surfaces gaps without blocking commits.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT" || exit 1

REQUIRED=("README.md")
RECOMMENDED=("fact-sheet.md" "practice-plan.md" "scenarios.md" "strategy.md")

fail_count=0
warn_count=0
checked=0

# A cert dir contains a notes/ subdirectory.
mapfile -t cert_dirs < <(find exams -type d -name notes | sed 's|/notes$||' | sort)

echo "Validating ${#cert_dirs[@]} cert directories..."
echo ""

for dir in "${cert_dirs[@]}"; do
    checked=$((checked + 1))
    missing_required=()
    missing_recommended=()

    for f in "${REQUIRED[@]}"; do
        [[ -f "$dir/$f" ]] || missing_required+=("$f")
    done

    for f in "${RECOMMENDED[@]}"; do
        [[ -f "$dir/$f" ]] || missing_recommended+=("$f")
    done

    if [[ ${#missing_required[@]} -gt 0 ]]; then
        echo "FAIL  $dir"
        echo "      missing required: ${missing_required[*]}"
        fail_count=$((fail_count + 1))
    elif [[ ${#missing_recommended[@]} -gt 0 ]]; then
        echo "WARN  $dir"
        echo "      missing recommended: ${missing_recommended[*]}"
        warn_count=$((warn_count + 1))
    fi
done

echo ""
echo "Summary: $checked dirs checked. Failures: $fail_count. Warnings: $warn_count."

# Fail the workflow only on missing required files.
if [[ $fail_count -gt 0 ]]; then
    exit 1
fi
exit 0
