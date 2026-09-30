#!/usr/bin/env python3
"""Read docs/_data/essays.yml and publish each essay into docs/.

For 'markdown' essays: copy source → docs/<slug>/index.md, join wrapped link
                       definitions for kramdown, append a GitHub footer.
For 'html' essays:     copy source → docs/<slug>.html verbatim.
"""

import os
import re
import shutil
import sys

import yaml

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MANIFEST = os.path.join(REPO_ROOT, "docs", "_data", "essays.yml")
DOCS_DIR = os.path.join(REPO_ROOT, "docs")

GITHUB_FOOTER = (
    "\n\n---\n\n"
    '<a href="https://github.com/Warwick-Allen/essays" '
    'class="github-link">View Source on GitHub</a>\n'
)

# The opening or closing line of a fenced code block.
FENCE = re.compile(r"^ {0,3}(`{3,}|~{3,})")
# A link reference definition's label with nothing after it on the line.
DANGLING_LINK_LABEL = re.compile(r"^ {0,3}\[[^\]]+\]:[ \t]*$")


def join_link_definitions(text):
    """Move each link destination onto the same line as its label.

    CommonMark, and so GitHub, accepts a link reference definition whose
    destination is on the line after the label, but kramdown recognises a
    definition only when both are on one line.  Fenced code is left alone.
    """
    lines = []
    fence = None
    for line in text.split("\n"):
        marker = FENCE.match(line)
        if fence:
            if (marker and marker.group(1).startswith(fence)
                    and not line[marker.end():].strip()):
                fence = None
        elif marker:
            fence = marker.group(1)
        elif lines and DANGLING_LINK_LABEL.match(lines[-1]) and line.strip():
            lines[-1] += " " + line.strip()
            continue
        lines.append(line)
    return "\n".join(lines)


def publish_markdown(essay):
    slug = essay["slug"]
    source = os.path.join(REPO_ROOT, essay["source"])
    dest_dir = os.path.join(DOCS_DIR, slug)
    dest = os.path.join(dest_dir, "index.md")

    if not os.path.isfile(source):
        print(f"  SKIP (source not found): {source}", file=sys.stderr)
        return False

    with open(source, encoding="utf-8") as f:
        text = f.read()

    os.makedirs(dest_dir, exist_ok=True)
    with open(dest, "w", encoding="utf-8") as f:
        f.write(join_link_definitions(text) + GITHUB_FOOTER)

    print(f"  markdown → {os.path.relpath(dest, REPO_ROOT)}")
    return True


def publish_html(essay):
    slug = essay["slug"]
    source = os.path.join(REPO_ROOT, essay["source"])
    dest = os.path.join(DOCS_DIR, f"{slug}.html")

    if not os.path.isfile(source):
        print(f"  SKIP (source not found): {source}", file=sys.stderr)
        return False

    shutil.copy2(source, dest)

    print(f"  html     → {os.path.relpath(dest, REPO_ROOT)}")
    return True


def main():
    with open(MANIFEST, encoding="utf-8") as f:
        essays = yaml.safe_load(f)

    changed = False
    for essay in essays:
        title = essay["title"]
        essay_type = essay["type"]
        print(f"Publishing: {title}")

        if essay_type == "markdown":
            changed |= publish_markdown(essay)
        elif essay_type == "html":
            changed |= publish_html(essay)
        else:
            print(f"  SKIP (unknown type '{essay_type}')", file=sys.stderr)

    return 0 if changed else 0


if __name__ == "__main__":
    raise SystemExit(main())
