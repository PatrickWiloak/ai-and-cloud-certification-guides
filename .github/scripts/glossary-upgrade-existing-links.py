#!/usr/bin/env python3
"""
glossary-upgrade-existing-links.py - one-off pass to upgrade existing
section-anchor glossary links to per-term anchors.

Looks for patterns like [**X**](../glossary.md#section-anchor) or
[**X**](../../learn/glossary.md#section-anchor) and rewrites the anchor
to the per-term version (`#term-x`) when X is a known glossary term.

Idempotent: links already pointing at term-* anchors are unchanged.

Run: python3 .github/scripts/glossary-upgrade-existing-links.py
"""

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
GLOSSARY = ROOT / "learn" / "glossary.md"
TARGET_DIRS = [ROOT / "learn" / "concepts", ROOT / "resources" / "hands-on-projects"]


def slugify_term(term: str) -> str:
    s = term.lower()
    s = re.sub(r"[^\w\s-]", "", s)
    s = re.sub(r"\s+", "-", s.strip())
    s = re.sub(r"-+", "-", s)
    return s


# Match lines like: <a id="term-foo"></a>**Term Name** -
TERM_LINE_RE = re.compile(r'^<a id="(term-[^"]+)"></a>\*\*([^*]+?)\*\* -')


def parse_term_anchors():
    """Build term-display-text -> term-anchor map from the glossary."""
    out = {}
    for line in GLOSSARY.read_text().splitlines():
        m = TERM_LINE_RE.match(line)
        if not m:
            continue
        anchor, term = m.group(1), m.group(2).strip()
        # Both primary and parenthetical-alias forms.
        primary = term.split(" (")[0].strip()
        out.setdefault(primary, anchor)
        if " (" in term and ")" in term:
            alias = term.split(" (", 1)[1].rstrip(")")
            out.setdefault(alias, anchor)
        # Also map the full bracketed form ("Foo (FB)") as an exact key.
        out.setdefault(term, anchor)
    return out


# Existing link form: [**Term**](relpath/glossary.md#section-or-term-anchor)
LINK_RE = re.compile(
    r'\[\*\*([^*\]]+?)\*\*\]\(([^)]*?glossary\.md)#([^)]+)\)'
)


def upgrade_file(file_path: Path, term_map: dict) -> int:
    text = file_path.read_text()
    upgrades = 0

    def replace(m):
        nonlocal upgrades
        display, relpath, anchor = m.group(1), m.group(2), m.group(3)
        # Already a term anchor? leave it.
        if anchor.startswith("term-"):
            return m.group(0)
        new_anchor = term_map.get(display) or term_map.get(display.split(" (")[0].strip())
        if not new_anchor:
            return m.group(0)
        upgrades += 1
        return f"[**{display}**]({relpath}#{new_anchor})"

    new_text = LINK_RE.sub(replace, text)
    if upgrades > 0:
        file_path.write_text(new_text)
    return upgrades


def main():
    term_map = parse_term_anchors()
    print(f"Loaded {len(term_map)} term -> anchor mappings.")
    total = 0
    files_changed = 0
    for d in TARGET_DIRS:
        for f in sorted(d.glob("*.md")):
            n = upgrade_file(f, term_map)
            if n > 0:
                files_changed += 1
                total += n
                print(f"  {f.relative_to(ROOT)}: {n} link{'s' if n != 1 else ''} upgraded")
    print(f"\n{files_changed} files changed, {total} links upgraded.")


if __name__ == "__main__":
    main()
