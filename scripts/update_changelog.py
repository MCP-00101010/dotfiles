from __future__ import annotations

from pathlib import Path
import subprocess

CHANGELOG_HEADER = """# Changelog

Automatically updated on every commit by the tracked `post-commit` hook.

## Entries
<!-- changelog-entries-start -->
<!-- changelog-entries-end -->
"""


def git_output(root: Path, *args: str) -> str:
    result = subprocess.run(
        ["git", *args],
        cwd=root,
        check=True,
        capture_output=True,
        text=True,
    )
    return result.stdout.strip()


def ensure_changelog(path: Path) -> str:
    if path.exists():
        return path.read_text(encoding="utf-8")
    path.write_text(CHANGELOG_HEADER, encoding="utf-8", newline="\n")
    return CHANGELOG_HEADER


def insert_entry(content: str, entry: str) -> str:
    start_marker = "<!-- changelog-entries-start -->"
    end_marker = "<!-- changelog-entries-end -->"
    block = f"{start_marker}\n{entry}\n{end_marker}"
    if start_marker not in content or end_marker not in content:
        return f"{content.rstrip()}\n\n## Entries\n{block}\n"

    start_index = content.index(start_marker)
    end_index = content.index(end_marker)
    between = content[start_index:end_index]
    if entry in between:
        return content

    return content.replace(
        f"{start_marker}\n{end_marker}",
        block,
        1,
    )


def main() -> int:
    root = Path(__file__).resolve().parent.parent
    changelog_path = root / "CHANGELOG.md"
    content = ensure_changelog(changelog_path)

    commit_date = git_output(root, "log", "-1", "--date=short", "--pretty=format:%ad")
    commit_subject = git_output(root, "log", "-1", "--pretty=format:%s")
    entry = f"- {commit_date}: {commit_subject}"

    updated = insert_entry(content, entry)
    if updated != content:
        changelog_path.write_text(updated, encoding="utf-8", newline="\n")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
