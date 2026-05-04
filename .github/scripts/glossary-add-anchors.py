#!/usr/bin/env python3
"""
glossary-add-anchors.py - prepend per-term HTML anchors to learn/glossary.md.

Without per-term anchors, the autolinker can only target section anchors
(e.g., #cloud-fundamentals). With per-term anchors, links can target the
exact term (e.g., #term-availability-zone).

Idempotent: skips terms that already have an anchor.

Run: python3 .github/scripts/glossary-add-anchors.py
"""

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
GLOSSARY = ROOT / "learn" / "glossary.md"

# Match a glossary term line: starts with **TermName** -
# Captures the term in group(1).
TERM_LINE_RE = re.compile(r"^(\*\*[^*]+?\*\*) -")
# Existing anchor before a term: <a id="term-..."></a> followed by **Term**
EXISTING_ANCHOR_RE = re.compile(r'^<a id="term-[^"]+"></a>\s*\*\*')


def slugify_term(term: str) -> str:
    """GitHub-style slug for a glossary term. 'Availability Zone (AZ)' → 'availability-zone-az'."""
    s = term.lower()
    s = re.sub(r"[^\w\s-]", "", s)
    s = re.sub(r"\s+", "-", s.strip())
    s = re.sub(r"-+", "-", s)  # collapse multiple hyphens
    return s


def main():
    text = GLOSSARY.read_text()
    lines = text.splitlines(keepends=True)
    out = []
    added = 0
    skipped_existing = 0

    for line in lines:
        # Already has an anchor? leave it.
        if EXISTING_ANCHOR_RE.match(line):
            out.append(line)
            skipped_existing += 1
            continue

        m = TERM_LINE_RE.match(line)
        if not m:
            out.append(line)
            continue

        bolded = m.group(1)  # **Term** including the asterisks
        term = bolded[2:-2]  # strip surrounding **
        # For terms with parenthetical alias (e.g., "Availability Zone (AZ)"),
        # use the full string for the anchor so both forms resolve.
        slug = slugify_term(term)
        anchor = f'<a id="term-{slug}"></a>'
        new_line = f"{anchor}{line}"
        out.append(new_line)
        added += 1

    GLOSSARY.write_text("".join(out))
    print(f"Added {added} anchors; skipped {skipped_existing} that already had one.")


if __name__ == "__main__":
    main()
