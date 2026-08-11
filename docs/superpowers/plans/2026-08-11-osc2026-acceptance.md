# OSC2026 Acceptance Hardening Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make MoonForge reproducibly installable, testable, and publishable under the OSC2026 acceptance feedback, with identical verified state on GitHub and GitLink.

**Architecture:** Keep MoonForge's existing native CLI and package API stable while strengthening the repository contract around README installation, pinned MoonBit CI, generated public interfaces, acceptance checks, and release metadata. Use GitHub as the working copy, add GitLink as a second push remote, and verify both remotes expose the same `main` commit before publishing the package.

**Tech Stack:** MoonBit 0.10.3 toolchain, `moon check/test/fmt/info`, GitHub Actions, PowerShell, Python 3.11, Mooncakes, GitHub CLI.

---

### Task 1: Establish the acceptance baseline

**Files:**
- Inspect: `moon.mod`, `moon.pkg`, `cmd/main/moon.pkg`, `README.md`, `.github/workflows/ci.yml`, `.github/workflows/publish.yml`, `scripts/verify_acceptance.ps1`
- Create: `docs/superpowers/plans/2026-08-11-osc2026-acceptance.md`

- [ ] **Step 1: Record repository facts**

Run `git rev-parse --abbrev-ref HEAD`, `git rev-list --count HEAD`, `git ls-remote --symref origin HEAD`, `git shortlog -sne --all`, and `python scripts/count_moonbit_lines.py`.

- [ ] **Step 2: Record toolchain behavior**

Run `moon version --all`, `moon fmt --help`, `moon info --help`, `moon check --deny-warn --target native`, and `moon test --deny-warn --target native`. Treat unsupported flags or dependency errors as findings to resolve rather than as passing evidence; `moon fmt` and `moon info` do not expose `--deny-warn` in the current 0.10.x CLI, so strictness is provided by `fmt --check` and `check --deny-warn`.

### Task 2: Repair public documentation and reproducibility

**Files:**
- Modify: `README.md`
- Modify: `README.mbt.md`
- Modify: `CHANGELOG.md`
- Modify: `docs/acceptance-checklist.md`
- Modify: `docs/official-requirements.md`
- Modify: `docs/source-attribution.md`

- [ ] **Step 1: Add an explicit installation section**

Document MoonBit 0.10.3 installation, the exact supported strict commands `moon fmt --check`, `moon info`, `moon check --fmt --deny-warn`, `moon build --deny-warn`, `moon test --deny-warn --target native`, the CLI smoke command, and the acceptance script. Explicitly note that `fmt` and `info` have no `--deny-warn` option in MoonBit 0.10.x.

- [ ] **Step 2: Make the README UTF-8 and runnable**

Replace mojibake text with readable Chinese or concise English, ensure every command matches the current CLI, and include the project purpose, task configuration fields, examples, license, contribution path, and release links.

- [ ] **Step 3: Update release and acceptance traceability**

Record the committee feedback, the pinned toolchain, CI coverage, and the expected generated-interface check in the changelog and acceptance documents.

### Task 3: Strengthen the MoonBit CI and local acceptance gate

**Files:**
- Modify: `.github/workflows/ci.yml`
- Modify: `.github/workflows/publish.yml`
- Modify: `scripts/verify_acceptance.ps1`
- Modify: `.gitignore`

- [ ] **Step 1: Pin the requested MoonBit toolchain**

Use `hustcer/setup-moonbit@v1` with the verified 0.10.3 version identifier, run `moon version --all`, and run `moon update` before project checks.

- [ ] **Step 2: Add strict format/interface/build/test checks**

Run `moon fmt --check`, `moon info`, `moon check --fmt --deny-warn --target native`, `moon build --deny-warn --target native`, and `moon test --deny-warn --target native`; compare tracked `pkg.generated.mbti` files with `git diff --exit-code`.

- [ ] **Step 3: Cover the CLI and acceptance workflow**

Keep the cross-platform matrix, add CLI smoke commands and the PowerShell acceptance script, and ensure generated build/cache output is ignored and cannot pollute the repository diff.

### Task 4: Expand and test the project behavior

**Files:**
- Inspect/modify: `cache.mbt`, `commands.mbt`, `config_parse.mbt`, `fingerprint.mbt`, `graph.mbt`, `planning.mbt`, `runner.mbt`, `cmd/main/main.mbt`
- Test first, then modify: `integration_wbtest.mbt`, `moonforge_wbtest.mbt`
- Regenerate: `pkg.generated.mbti`, `cmd/main/pkg.generated.mbti`

- [ ] **Step 1: Add a failing regression test**

Add one focused test for the acceptance-relevant behavior that is missing after baseline review, such as deterministic `doctor` diagnostics, input-change invalidation, dependency-level scheduling, or explicit failure blocking. Run the focused MoonBit test and confirm it fails for the intended reason.

- [ ] **Step 2: Implement the minimum behavior**

Change only the package-local implementation needed by the failing test, preserving the public API unless the feature requires a documented addition.

- [ ] **Step 3: Run the green test and full checks**

Run the focused test, then `moon test --deny-warn --target native`, `moon build --deny-warn --target native`, `moon fmt --check`, and `moon info`. Review any generated interface changes before keeping them.

### Task 5: Mirror, publish, and audit both remotes

**Files:**
- Modify: Git history and remote refs only after verification
- Inspect: GitHub `Lyhdsba/MoonForge`, GitLink `Lyhdsba/MoonForge`, Mooncakes `Lyhdsba/moonforge`

- [ ] **Step 1: Commit the verified changes with the owner identity**

Set repository-local author identity to `Lyhdsba` and `2749233024@qq.com`, create a descriptive commit, and confirm `git shortlog` contains only the intended owner identity for new work.

- [ ] **Step 2: Push the same `main` commit to GitHub and GitLink**

Use the existing authenticated GitHub CLI credential for GitHub and the GitLink credential only for the GitLink remote. Never place a password in a remote URL or repository file. Verify both remote default branches are `main` and both heads equal the local commit.

- [ ] **Step 3: Publish to Mooncakes**

Run the prepublish checks, confirm `moon.mod` package identity/version and generated interfaces, then run `moon publish` using the existing Moon login. Verify the public package page and record the published version.

- [ ] **Step 4: Run the final OSC2026 self-check**

Run `powershell -ExecutionPolicy Bypass -File scripts/verify_acceptance.ps1`, inspect `git status --short --branch`, and re-check README, license, history, default branches, source line count, CI files, and remote parity before reporting completion.
