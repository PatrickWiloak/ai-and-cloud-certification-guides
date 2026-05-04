#!/usr/bin/env python3
"""
glossary-autolink.py - link first-occurrence glossary terms in concept and hands-on pages.

Parses learn/glossary.md to build a map of bolded terms (lines starting with `**Term**`
or `**Term (alias)**`) to the section they appear under. Then for each .md file in
learn/concepts/ and resources/hands-on-projects/, replaces the first **Term** occurrence
with a link to the glossary section.

Safety:
- Caps at 5 links per file to avoid over-linking.
- Skips fenced code blocks and the glossary itself.
- Idempotent: if a bold term is already a link, leaves it alone.
- Only links terms that appear as **Term** (bolded) in the target page - i.e., the
  author already flagged them as glossary-worthy.

Run: python3 .github/scripts/glossary-autolink.py [--dry-run]
"""

import os
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
GLOSSARY = ROOT / "learn" / "glossary.md"

TARGET_DIRS = [
    ROOT / "learn" / "concepts",
    ROOT / "topics",
    ROOT / "resources" / "hands-on-projects",
    ROOT / "resources" / "architecture-patterns",
    ROOT / "resources" / "networking-deep-dives",
]

# Single-file globs for new content shapes that live directly under resources/.
TARGET_FILE_GLOBS = [
    "resources/decision-matrix-*.md",
    "resources/postmortem-*.md",
    "resources/playlist-*.md",
]

MAX_LINKS_PER_FILE = 5

SECTION_RE = re.compile(r"^## (.+)$")
TERM_RE = re.compile(r"^\*\*([^*]+?)\*\* -")


def slugify(s: str) -> str:
    """GitHub-style slug from a heading."""
    s = s.lower()
    s = re.sub(r"[^\w\s-]", "", s)
    s = re.sub(r"\s+", "-", s.strip())
    return s


def slugify_term(term: str) -> str:
    """Match the slug logic used by glossary-add-anchors.py for per-term anchors."""
    s = term.lower()
    s = re.sub(r"[^\w\s-]", "", s)
    s = re.sub(r"\s+", "-", s.strip())
    s = re.sub(r"-+", "-", s)
    return s


# Match lines like:
#   <a id="term-foo"></a>**Term** -
# or just:
#   **Term** -
ANCHOR_PREFIX_RE = re.compile(r'^<a id="(term-[^"]+)"></a>')


def parse_glossary():
    """Returns dict: term -> anchor. Prefers per-term anchor (term-...) over section anchor."""
    terms = {}
    current_section = None
    for line in GLOSSARY.read_text().splitlines():
        m = SECTION_RE.match(line)
        if m:
            section = m.group(1)
            current_section = slugify(section)
            continue
        # Strip a leading per-term anchor if present, capturing the anchor id.
        anchor_id = None
        a = ANCHOR_PREFIX_RE.match(line)
        if a:
            anchor_id = a.group(1)
            line = line[a.end():]
        m = TERM_RE.match(line)
        if m and current_section:
            term = m.group(1).strip()
            # Pick the strongest available anchor: per-term anchor > section anchor.
            chosen = anchor_id if anchor_id else current_section
            primary = term.split(" (")[0].strip()
            if primary not in terms and len(primary) >= 3:
                terms[primary] = chosen
            if " (" in term and ")" in term:
                alias = term.split(" (", 1)[1].rstrip(")")
                if alias not in terms and len(alias) >= 3:
                    terms[alias] = chosen
    return terms


def relpath_to_glossary(file_path: Path) -> str:
    """Compute the relative path from file_path's directory to learn/glossary.md."""
    return os.path.relpath(GLOSSARY, file_path.parent)


def link_terms_in_file(file_path: Path, terms: dict, dry_run: bool) -> int:
    """Apply autolinking to a single file. Returns count of links added."""
    text = file_path.read_text()
    lines = text.splitlines(keepends=True)
    glossary_rel = relpath_to_glossary(file_path)

    in_code = False
    used = set()  # track which terms we've already linked in this file
    out = []
    links_added = 0

    for line in lines:
        # Toggle fenced code block state.
        if line.startswith("```"):
            in_code = not in_code
            out.append(line)
            continue
        if in_code:
            out.append(line)
            continue
        if line.startswith("#"):
            out.append(line)  # never link inside headings
            continue
        if links_added >= MAX_LINKS_PER_FILE:
            out.append(line)
            continue

        new_line = line
        # Find bolded **X** patterns; for each, check if X is a glossary term we haven't linked yet.
        for m in re.finditer(r"\*\*([^*\n]+?)\*\*", line):
            if links_added >= MAX_LINKS_PER_FILE:
                break
            text_inside = m.group(1).strip()
            # Skip if this **bold** is already inside a link (preceded by `[` and followed by `]`).
            start = m.start()
            if start > 0 and line[start - 1] == "[":
                continue
            # Try direct match, then strip parenthetical aliases.
            term = text_inside
            anchor = terms.get(term) or terms.get(term.split(" (")[0].strip())
            if anchor and term not in used:
                replacement = f"[**{text_inside}**]({glossary_rel}#{anchor})"
                new_line = new_line.replace(m.group(0), replacement, 1)
                used.add(term)
                links_added += 1

        out.append(new_line)

    if links_added > 0 and not dry_run:
        file_path.write_text("".join(out))
    return links_added


def main():
    dry_run = "--dry-run" in sys.argv
    terms = parse_glossary()
    print(f"Loaded {len(terms)} glossary terms.")
    total_links = 0
    files_changed = 0
    target_files = []
    for d in TARGET_DIRS:
        if not d.exists():
            continue
        for f in sorted(d.glob("*.md")):
            if f.name == "README.md":
                continue
            target_files.append(f)
    for pattern in TARGET_FILE_GLOBS:
        for f in sorted(ROOT.glob(pattern)):
            target_files.append(f)

    seen = set()
    for f in target_files:
        if f in seen:
            continue
        seen.add(f)
        n = link_terms_in_file(f, terms, dry_run)
        if n > 0:
            files_changed += 1
            total_links += n
            print(f"  {f.relative_to(ROOT)}: {n} link{'s' if n != 1 else ''}")
    mode = "(dry run)" if dry_run else "(applied)"
    print(f"\n{files_changed} files changed, {total_links} links added {mode}.")


if __name__ == "__main__":
    main()
