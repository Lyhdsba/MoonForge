from __future__ import annotations

import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def tracked_moonbit_files() -> list[Path]:
    output = subprocess.check_output(
        ["git", "ls-files", "*.mbt", "*.mbti"],
        cwd=ROOT,
        text=True,
        encoding="utf-8",
    )
    return [ROOT / line for line in output.splitlines() if line.strip()]


def main() -> None:
    files = tracked_moonbit_files()
    total = 0
    for path in files:
        total += len(path.read_text(encoding="utf-8").splitlines())
    print(total)


if __name__ == "__main__":
    main()
