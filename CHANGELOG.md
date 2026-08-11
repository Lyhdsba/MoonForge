# Changelog

## 0.1.2 - 2026-08-11

- Added structured `audit` findings, task duration/cache metrics, output
  tamper invalidation, and project-root-safe config/output cleanup.
- Added reproducible benchmark workload generation and a boundary corpus for
  graph, path, scheduler, parser, and cache behavior; tracked MoonBit scope is
  now above the official 4k reference threshold.
- Repaired README and proposal UTF-8 text and documented a reproducible
  MoonBit 0.10.3 installation and acceptance flow.
- Added explicit format, interface-generation, native build, test, and CLI
  checks to the cross-platform CI and local acceptance script.
- Updated the async dependency to `0.20.3` so the project remains compatible
  with the current MoonBit compiler while CI remains pinned to the acceptance
  toolchain.
- Recorded the pre-acceptance feedback about failure blocking, input changes,
  and dependency-level parallel scheduling.

## 2026-07-12

- Added `moonforge stats` for reviewer-facing repository diagnostics
- Expanded `doctor` with missing-input, overlapping-output, and reachability checks
- Refreshed OSC2026 acceptance materials, official-requirements snapshot, and source-attribution docs
- Upgraded CI to MoonBit `0.10.3` with strict native verification and publish workflow
- Published `Lyhdsba/moonforge@0.1.1` to Mooncakes

## 2026-07-07

- Aligned module identity with the Mooncakes account for publication
- Rewrote the repository README and added contribution, security, and release docs
- Added portable acceptance verification and GitHub Actions CI for final closeout
- Published `Lyhdsba/moonforge@0.1.0` to Mooncakes

## 2026-07-05

- Cleaned repository-facing README files and removed invalid README path links
- Reworked the OSC2026 one-page proposal source and regenerated the PDF
- Added acceptance verification script for README, commit count, and PDF checks

## 2026-07-03

- Implemented MoonForge core task model, graph planner, cache, and runner
- Added CLI commands and sample configuration
- Added design documentation and whitebox tests
