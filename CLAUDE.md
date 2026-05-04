# Cloud + AI Learning Resource - Project Instructions

## Overview
A learning resource for cloud and AI - concepts, hands-on builds, deep references, and certification prep. Covers 122+ certifications across 22 providers (AWS, Azure, GCP, Kubernetes/CNCF, NVIDIA, HashiCorp, Databricks, Snowflake, GitHub, Red Hat, Cisco, Salesforce, Confluent/Kafka, MongoDB, FinOps, CompTIA, ISC2, Cloud Security Alliance, Linux Foundation, Oracle, IBM) plus 4 self-directed vendor study tracks for Anthropic Claude. Certifications are one pillar; the repo also serves non-cert learners.

## Structure
```
cloud-data-ai-security-zero-to-hero/
├── exams/              # Cert-specific study guides (the certify pillar)
├── learn/              # Plain-English learning content (the learn pillar)
│   ├── concepts/       # Bite-size topic pages (5-10 min): cloud + AI primitives
│   ├── day-one/        # Strict beginner on-ramp: terminal, git, HTTP, servers
│   ├── ai-from-scratch.md
│   ├── cloud-from-scratch.md
│   ├── glossary.md
│   └── youtube.md
├── resources/          # Cross-cert reference (build + reference pillars)
├── assets/diagrams/    # PNG diagrams (draw.io exports), organized by topic
├── docs/               # Repo-level docs (ARCHITECTURE.md)
├── README.md           # Top-level overview
├── STUDY-HUB.md        # Navigation hub
└── CONTRIBUTING.md     # How to contribute
```

## Purpose
- Personal study notes and exam prep materials (cert pillar)
- Plain-English learning content for non-cert students (learn pillar)
- Reference documentation for architecture, comparison, troubleshooting (build + reference pillars)
- Not a deployable application

## Notes
- Markdown-based knowledge base
- Organized by purpose (learn / certify / reference) and within each, by provider
- Each cert has: README.md, fact-sheet.md, notes/, practice-plan.md, scenarios.md, strategy.md
- Resources include: architecture patterns, service comparisons, CLI cheat sheets, roadmaps, compliance guides, migration guides, interview prep, troubleshooting guides, hands-on projects

## Visual Content Standards
- **Diagrams are created via the draw.io MCP server and saved as PNG files** in `assets/diagrams/<topic>/<slug>.png`. Topic subdirs (cloud/, ai/, networking/, architecture/, security/) are created lazily as content grows.
- Embed PNGs in markdown with descriptive alt text. Example: `![3-tier architecture with load balancer, app servers, and database](../../assets/diagrams/architecture/web-app-3-tier.png)`
- **Mermaid fenced code blocks are an acceptable fallback** when (a) the draw.io MCP isn't available, (b) the diagram is small enough to be readable inline, or (c) you want it editable directly in the markdown. GitHub renders Mermaid natively.
- See [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md#visual-content-standards) for the full convention.

## Frontmatter convention (new and refreshed pages)
```yaml
---
last-updated: YYYY-MM-DD
applies-to: AWS console as of 2026-Q2          # optional
difficulty: beginner | intermediate | advanced  # optional
reading-time: 10 min                            # optional
---
```
Backfill is opportunistic. Don't add frontmatter to thousands of files in one PR.

## House style
- No em dashes (-). Use regular dashes (-) only.
- Plain English, short sentences. Avoid emoji in body text (section markers OK).
- Cite vendor docs, don't paraphrase. Use the `**[📖 Title](URL)** - description` link format.
- No verbatim vendor exam questions.

## Automation
- `.github/workflows/` - link-check (lychee, weekly + on PR), markdown-lint (markdownlint-cli2), structure-validate (custom script).
- `.github/scripts/validate-cert-structure.sh` - confirm every cert dir has a README; warn on missing fact-sheet, practice-plan, scenarios, strategy.
- `.github/scripts/build-freshness-ledger.sh` - regenerate `docs/freshness.md` from `last-updated` frontmatter. Run after meaningful content updates.
- See [docs/freshness.md](./docs/freshness.md) for the per-cert verification ledger.
