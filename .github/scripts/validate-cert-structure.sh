#!/usr/bin/env bash
# Validate that every cert directory under exams/ has the required files,
# with tier-aware recommendations.
#
# Required (fail on missing): README.md
# Recommended for all certs: fact-sheet.md, practice-plan.md
# Recommended only for senior-tier certs (professional, expert, specialty): scenarios.md, strategy.md
#
# Senior-tier classification:
#   - path contains /professional/, /specialty/, or /expert/
#   - or matches a curated list of senior-tier cert basenames (architect, devops/SRE,
#     network engineer, security engineer, K8s CKS, ISC2 CISSP/CCSP, ISACA CISM/CISA,
#     advanced/expert codes, etc.)
#
# A "cert directory" is any directory under exams/<provider>/ that contains a notes/ subdir.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT" || exit 1

REQUIRED=("README.md")
RECOMMENDED_BASE=("fact-sheet.md" "practice-plan.md")
RECOMMENDED_SENIOR=("scenarios.md" "strategy.md")

# Returns "senior" or "junior".
classify_tier() {
    local dir="$1"
    # Path-based for providers that use tier subdirs (AWS, etc.)
    case "$dir" in
        */professional/*|*/specialty/*|*/expert/*) echo "senior"; return ;;
    esac

    local base="${dir##*/}"
    # Curated senior-tier cert basenames across providers.
    case "$base" in
        # GCP professional certs (live at exams/gcp/<name>)
        cloud-architect|data-engineer|machine-learning-engineer \
        |cloud-network-engineer|cloud-security-engineer|cloud-devops-engineer \
        |cloud-database-engineer|workspace-administrator) echo "senior"; return ;;
        # Azure expert / specialty
        az-305|az-400|az-500|az-700|az-800|sc-100|sc-200) echo "senior"; return ;;
        # Kubernetes pro / specialty
        cks|pca|ica) echo "senior"; return ;;
        # ISC2, ISACA, OSCP - all senior security certs
        cissp|ccsp|cism|cisa|oscp-pen-200|ccsk*|sscp) echo "senior"; return ;;
        # CompTIA mid-senior
        cysa-plus|pentest-plus|casp-plus) echo "senior"; return ;;
        # Cisco professional
        ccnp*|ccie*) echo "senior"; return ;;
        # HashiCorp / Databricks / Snowflake advanced
        terraform-professional|vault-professional|vault-pro \
        |snowpro-advanced-*|ml-professional|data-engineer-professional \
        |genai-llms-professional|agentic-ai-professional \
        |ai-infrastructure-professional|ai-operations-professional \
        |accelerated-data-science-professional \
        |claude-certified-architect-advanced) echo "senior"; return ;;
        # FinOps Professional
        certified-professional) echo "senior"; return ;;
        # VMware VCP-DCV is professional
        vcp-dcv-*) echo "senior"; return ;;
        # Anthropic architect-foundations + others foundational/associate
    esac
    echo "junior"
}

fail_count=0
warn_count=0
checked=0
senior_count=0

# A cert dir contains a notes/ subdirectory.
mapfile -t cert_dirs < <(find exams -type d -name notes | sed 's|/notes$||' | sort)

echo "Validating ${#cert_dirs[@]} cert directories (tier-aware)..."
echo ""

for dir in "${cert_dirs[@]}"; do
    checked=$((checked + 1))
    tier=$(classify_tier "$dir")
    [[ "$tier" == "senior" ]] && senior_count=$((senior_count + 1))

    missing_required=()
    missing_recommended=()

    for f in "${REQUIRED[@]}"; do
        [[ -f "$dir/$f" ]] || missing_required+=("$f")
    done

    for f in "${RECOMMENDED_BASE[@]}"; do
        [[ -f "$dir/$f" ]] || missing_recommended+=("$f")
    done

    if [[ "$tier" == "senior" ]]; then
        for f in "${RECOMMENDED_SENIOR[@]}"; do
            [[ -f "$dir/$f" ]] || missing_recommended+=("$f")
        done
    fi

    if [[ ${#missing_required[@]} -gt 0 ]]; then
        echo "FAIL  $dir [tier: $tier]"
        echo "      missing required: ${missing_required[*]}"
        fail_count=$((fail_count + 1))
    elif [[ ${#missing_recommended[@]} -gt 0 ]]; then
        echo "WARN  $dir [tier: $tier]"
        echo "      missing recommended: ${missing_recommended[*]}"
        warn_count=$((warn_count + 1))
    fi
done

echo ""
echo "Summary: $checked dirs checked ($senior_count senior, $((checked - senior_count)) junior)."
echo "         Failures: $fail_count. Warnings: $warn_count."

# Fail the workflow only on missing required files.
if [[ $fail_count -gt 0 ]]; then
    exit 1
fi
exit 0
