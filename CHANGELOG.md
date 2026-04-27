# Changelog

All notable changes to the cloud certification study guides repository.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and this project uses calendar-based dating.

---

## [2026-04-27] - Gap fix and provider expansion

### Added

- **AWS Certified Data Engineer - Associate (DEA-C01)** - full Associate-tier scaffold (README, fact-sheet, 6 notes, practice-plan, scenarios, strategy). The current AWS data-engineering credential, replacing the retired DAS-C01 and DBS-C01.
- **Red Hat certifications** - new provider section with two starter certs:
  - **RHCSA (EX200)** - Red Hat Certified System Administrator
  - **OpenShift Administrator (EX280)** - Red Hat Certified Specialist in OpenShift Administration
- **Cisco CCNA (200-301)** - new provider section with foundational networking cert
- **Azure Microsoft Fabric Data Engineer (DP-700)** - newer Azure cert
- **Azure Network Engineer Associate (AZ-700)** - missing Azure networking cert
- **Microsoft 365 Fundamentals (MS-900)** - foundational M365 cert
- **Salesforce Administrator (ADX-201)** - new provider section, foundational admin cert
- **Salesforce Platform Developer I (DEX-450)** - developer cert
- **Practice question banks** for 10 previously-uncovered popular certs: CKA, Terraform Associate, CISSP, Databricks DE Associate, FinOps Practitioner, AWS AI Practitioner, AWS MLA-C01, Azure AI-102, Snowflake SnowPro Core, RHCSA + CCNA
- **Cloud Practitioner fact-sheet** (was missing despite existing notes and practice-plan)
- **`.templates/resources-{aws,azure,gcp}.md`** - centralized study-resources hub pages referenced from many cert dirs
- **CONTRIBUTING.md** - contribution scope, cert template, link format, retirement workflow, PR checklist
- **CHANGELOG.md** - this file
- **docs/ARCHITECTURE.md** - repo-structure and conventions doc for contributors

### Changed

- **Anthropic certs relabeled as study tracks**. Anthropic does not currently run an official certification program; the four guides under `exams/anthropic/` are now framed as self-directed Claude proficiency tracks.
- **AWS Quantum Practitioner relabeled as anticipated study track**. AWS has not formally announced QPC-C01.
- **Azure GenAI dir relabeled as cross-cert GenAI study track** (was confusingly framed as a specific AI-102/AI-900 variant)
- **GCP GenAI dir relabeled as cross-cert GenAI study track** (was framed as Professional ML Engineer; that cert lives in `exams/gcp/machine-learning-engineer/`)
- **GCP Professional Cloud Architect dirs deduplicated** - merged `exams/gcp/pca/` into `exams/gcp/cloud-architect/`. Cert count dropped from 13 to 12 GCP certs.
- **Counts in README, STUDY-HUB, and CLAUDE.md updated** to reflect actual contents (now 117+ certs across 21 providers, plus 4 vendor study tracks)
- **Roadmap files updated** to reference current AWS certs:
  - `certification-roadmap-cloud-engineer.md` - SOA-C02 → SOA-C03; MLS-C01 → MLA-C01; added DEA-C01
  - `certification-roadmap-ai-ml-engineer.md` - MLS-C01 → MLA-C01
  - `certification-roadmap-solutions-architect.md` - MLS-C01 retired note
  - `certification-roadmap-database-specialist.md` - DBS-C01 retired note + DEA-C01 as replacement
- **Heavy-offender README files rewritten** to match files actually on disk (Oracle x5, IBM x5, Azure AZ-305, AWS SAP-C02, AWS/Azure/GCP GenAI dirs)
- **All 317 broken internal links repaired** through a combination of new files (templates, missing fact-sheets) and corrected references
- **Provider integration into roadmaps**: Red Hat added to platform engineer roadmap; Cisco CCNA added as networking foundation in cloud engineer roadmap
- **STUDY-HUB decision tree, study tracks, and provider table** updated to include Red Hat / Cisco / DEA-C01 / Anthropic study-track separation

### Marked as retired

The following AWS specialty exams were retired by AWS but the study material is preserved for credential holders. Each now has a consistent `RETIRED [DATE]` banner on README and fact-sheet pointing to the modern replacement:

- **AWS Data Analytics Specialty (DAS-C01)** - retired April 8, 2024 → DEA-C01
- **AWS Database Specialty (DBS-C01)** - retired April 29, 2024 → DEA-C01
- **AWS Machine Learning Specialty (MLS-C01)** - retired April 15, 2025 → MLA-C01
- **AWS SysOps Administrator (SOA-C02)** - retired Sept 29, 2025 → SOA-C03 CloudOps Engineer

### Removed

- `exams/gcp/pca/` directory (merged into `exams/gcp/cloud-architect/`); 4 internal roadmap link references updated

### Documentation

- All retired-cert references in active roadmap files now have RETIRED banners
- Anthropic is now consistently presented as study tracks (not certifications) across README, STUDY-HUB, all 4 cert dirs
- Provider count corrected in README, STUDY-HUB, and CLAUDE.md from 19 to 21
- Cert count corrected from 118+ to accurate 117+ + 4 study tracks
- README structure section updated to reflect the new dir layout
- Internal link audit: 0 broken links remain (verified with code-block-aware scanner across all 700+ markdown files)

---

## [2026-04 prior] - Project state before this changelog

The repository existed prior to this entry. Before 2026-04-27, the catalog claimed:

- 118+ certifications across 19 providers
- 12 cross-cloud service comparisons
- 9 CLI cheat sheets
- 17 architecture patterns
- 11 certification roadmaps
- 10 hands-on projects
- 6 interview prep guides
- 5 compliance and 5 migration guides

That state had documentation drift: a duplicate GCP PCA dir, Anthropic certs framed as official, several AWS specialties listed as active despite being retired, broken internal links in dozens of cert READMEs, and a missing CONTRIBUTING.md referenced from the main README. The 2026-04-27 work above resolved those issues.

---

## How to update this changelog

When making user-visible or operationally-significant changes:

1. Add a dated section at the top using `## [YYYY-MM-DD] - Brief description`.
2. Group entries under: **Added**, **Changed**, **Deprecated**, **Removed**, **Fixed**, **Security**.
3. Link to the cert dir or resource file affected.
4. Keep entries concise (one line per item); link out for detail.
5. New cert additions, retirements, schema changes, and provider sections are always logged here.
6. Typo fixes and minor link repairs do not need a changelog entry.
