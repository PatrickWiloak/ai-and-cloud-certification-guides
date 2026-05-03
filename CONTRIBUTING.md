# Contributing

Thanks for your interest in improving this repo. It's a markdown knowledge base for cloud and AI - concepts, hands-on builds, references, and certification prep. The goal is accurate, well-linked, exam-aligned material that respects readers' time. Plain-English, no fluff.

## What kinds of contributions are welcome

- **Typo / grammar fixes** in any markdown file.
- **Broken-link repairs** when AWS, Azure, GCP, or other vendors reorganize their docs.
- **Doc-link additions**: high-quality vendor documentation links that strengthen an existing section.
- **Domain-weight or exam-detail updates** when a vendor publishes a refreshed exam blueprint.
- **New cert scaffolds** for missing in-demand certifications (open an issue first to confirm scope and naming).
- **Resource updates**: better practice questions, scenarios, or hands-on lab walkthroughs.
- **Roadmap additions** for under-served career paths.
- **`learn/` content**: new concept pages (`learn/concepts/<topic>.md`), day-one onramp expansions, glossary additions. Keep concept pages 5-10 minute reads, plain English, no exam framing.
- **Diagrams**: PNG diagrams (draw.io export) under `assets/diagrams/<topic>/`, or inline Mermaid in existing pages. See [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md#visual-content-standards).

## What is out of scope

- **Marketing / SEO content** or affiliate links.
- **Paid course advertising** beyond what is already in `resources/recommended-courses.md`.
- **Verbatim copies** of vendor exam questions (legal and ethical violation - do not submit, do not request).
- **Generated/AI-written notes** that don't match the structured pattern below.

## Repository layout

```
exams/<provider>/<cert-dir>/
    README.md           # cert overview, who it's for, prereqs, study time
    fact-sheet.md       # exam details, domains, key services, doc links
    notes/              # numbered topic files: 01-foo.md, 02-bar.md, ...
    practice-plan.md    # weekly study schedule with checkboxes
    scenarios.md        # exam-style scenarios with explanations (optional but recommended)
    strategy.md         # exam day approach, time allocation (optional)
learn/
    concepts/           # bite-size topic pages (5-10 min reads), cloud + AI
    day-one/            # strict beginner on-ramp (terminal, git, HTTP, servers)
    ai-from-scratch.md  # 8-phase non-cert AI path
    cloud-from-scratch.md  # 8-phase non-cert cloud path
    glossary.md         # 200+ term reference
    youtube.md          # curated video resources
resources/
    architecture-patterns/      # multi-cloud architecture write-ups
    certification-roadmap-*.md  # career-focused learning paths
    cli-cheat-sheet-*.md        # tool quick references
    compliance-guides/          # SOC 2, HIPAA, PCI DSS, GDPR, FedRAMP
    cost-optimization/          # per-cloud cost playbooks
    hands-on-projects/          # guided builds
    interview-prep/             # role-based interview prep
    migration-guides/           # cloud migration playbooks
    networking-deep-dives/      # hybrid, multi-cloud, DNS, load balancing
    practice-questions/         # per-cert question banks
    service-comparison-*.md     # cross-cloud service comparisons
    troubleshooting/            # per-platform troubleshooting
    well-architected/           # AWS, Azure, GCP frameworks
assets/diagrams/        # PNG diagrams (draw.io exports), organized by topic
README.md           # top-level overview and provider table
STUDY-HUB.md        # navigation hub with decision tree and roadmaps
CLAUDE.md           # project-level guidance for AI-assisted edits
```

## Cert directory template

When scaffolding a new cert, use this structure:

- `README.md` - 1-page overview. Include exam code, level (Associate / Professional / Specialty / etc.), brief audience description, prerequisites, recommended study time, and a "Study Materials in This Guide" table linking to the other files in the dir.
- `fact-sheet.md` - dense reference. Lead with a Quick Reference table (exam code, duration, questions, passing score, cost, validity, prerequisites, delivery format), then domain breakdown with weights, then deep service / topic coverage with embedded vendor doc links.
- `notes/` - one numbered file per major exam domain or topic cluster. Aim for 4-7 files. File names are kebab-case with a `NN-` prefix (e.g. `01-data-ingestion.md`).
- `practice-plan.md` - week-by-week schedule (typically 4-12 weeks depending on tier) with checkbox milestones.
- `scenarios.md` - 10-25 exam-style scenarios with full explanations. Map each to a domain.
- `strategy.md` (optional, recommended for Professional/Specialty) - exam-day timing, common traps, how to pace.

Keep early files (`README.md`, `fact-sheet.md`) compact and accurate. Depth lives in `notes/`.

## Documentation link format

Always prefer **official vendor documentation** over third-party tutorials. The standard format used throughout the repo is:

```
**[📖 Link Text](URL)** - Optional short description
```

For example:

```markdown
**[📖 RDS Documentation](https://docs.aws.amazon.com/rds/)** - Complete RDS guide
```

Other conventions:

- Use markdown links, not bare URLs.
- For internal repo links, use relative paths: `[fact-sheet](./fact-sheet.md)` or `[Solutions Architect Roadmap](../../resources/certification-roadmap-solutions-architect.md)`.
- Don't link to URL-shorteners. Link to the canonical URL so readers can see where they're going.
- When a vendor doc URL changes, fix all references in one PR (use `grep -rn "old-path"` to find them).

## Style and tone

- **No em dashes (-)**. Use regular dashes (-) instead. This is a global house style.
- **Avoid emojis** in body text. The repo uses a small set of section-marker emojis (☁️, 🔒, 📖, etc.) but body content stays plain.
- **Plain English, short sentences.** Aim for the reader who is mid-study at midnight on a Sunday.
- **Don't write fluffy intros.** Lead with the substance.
- **No trailing summaries** that repeat what was just said.
- **Cite, don't paraphrase**, when a vendor doc says it best. Link the doc.

## Diagrams

- Canonical: PNG files generated from draw.io, stored under `assets/diagrams/<topic>/<slug>.png`. Always include descriptive alt text when embedding.
- Acceptable fallback: Mermaid in fenced ` ```mermaid ` code blocks (renders inline on GitHub). Use when small/simple or when draw.io tooling isn't available.
- See [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md#visual-content-standards) for the full convention.

## Frontmatter (new and refreshed pages)

Add YAML frontmatter to new pages. `last-updated` is the only required field; others are optional but useful.

```yaml
---
last-updated: YYYY-MM-DD
applies-to: AWS console as of 2026-Q2          # optional
difficulty: beginner | intermediate | advanced  # optional
reading-time: 10 min                            # optional
---
```

Backfilling existing files is opportunistic - do it when you touch a file, don't open a frontmatter-only PR for thousands of files.

## YouTube tie-in (optional)

When a topic has a companion video on [@patrickwiloak](https://youtube.com/@patrickwiloak), add a single-line callout near the top:

```markdown
> 📺 **Watch:** [Video title](https://youtube.com/...)
```

Keep these to one per page. Topic stays the source of truth; the video is a companion, not a replacement.

## What to do with retired exams

When a vendor retires a cert:

1. Add a clear "RETIRED [DATE]" banner to the top of `README.md` and `fact-sheet.md` for that cert. See [exams/aws/specialty/data-analytics-das-c01/](exams/aws/specialty/data-analytics-das-c01/) for the canonical pattern.
2. Link to the replacement cert (if any).
3. Keep the original content intact for credential holders.
4. Remove the cert from active counts in `README.md` and `STUDY-HUB.md`.
5. Update any roadmap docs that reference the retired cert.

## Submitting a change

1. Fork the repo and make your changes on a branch.
2. **Run a spot-check before opening a PR**:
   - `find exams -name "*.md" | xargs -I {} grep -l "broken-pattern" {}` for any cleanup you're doing.
   - Open the affected cert dir and visually confirm that links resolve to existing files.
   - Verify any updated counts (e.g. provider totals) match what's actually on disk.
3. Open a PR with:
   - A short title (under 70 chars) describing the change.
   - A description that explains the **why** as well as the **what**.
   - A test-plan checklist: which files changed, which links you verified, which counts you reconciled.

## PR checklist (copy into your description)

```
- [ ] Style: no em dashes (-); regular dashes (-) only
- [ ] All new vendor doc links use the **[📖 Title](URL)** format
- [ ] Internal links resolve (relative paths checked)
- [ ] If counts changed: README.md and STUDY-HUB.md totals reconciled
- [ ] If a cert was retired: banner added, replacement linked, counts updated
- [ ] If a new cert was added: README.md and STUDY-HUB.md provider tables updated
- [ ] No verbatim vendor exam questions
```

## Questions

Open an issue with the `question` label and one of the maintainers will respond. For broader proposals (new provider sections, new resource categories), open a discussion or issue first so we can scope it together.
