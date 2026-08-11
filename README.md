# MoonForge

MoonForge is a MoonBit-native incremental task runner for small builds, code
generation pipelines, document workflows, asset preparation, and reproducible
local CI commands. It makes task dependencies, inputs, outputs, caching, and
failure reasons explicit.

## Project status

MoonForge is an OSC2026 engineering-infrastructure project. The current
release focuses on a dependable native CLI, deterministic dependency planning,
incremental execution, diagnostics, and a small configuration format that is
easy to review and extend.

## Install MoonBit

Use the MoonBit 0.10.3 toolchain for the competition acceptance environment.
The official installers are:

```bash
# Linux or macOS
curl -fsSL https://cli.moonbitlang.com/install/unix.sh | bash
```

```powershell
# Windows PowerShell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm https://cli.moonbitlang.com/install/powershell.ps1 | iex
```

Restart the terminal if `moon` is not on `PATH`, then verify the toolchain:

```bash
moon version --all
moon update
```

The GitHub Actions workflow pins the complete 0.10.3 toolchain revision so
that CI and the acceptance environment use the same compiler and formatter.

## Quick start

From the repository root:

```bash
moon update
moon check --fmt --deny-warn --target native
moon fmt --check
moon info
moon build --deny-warn --target native
moon test --deny-warn --target native
moon run --target native cmd/main -- stats
moon run --target native cmd/main -- audit
moon run --target native cmd/main -- run build
```

`moon fmt` and `moon info` do not accept `--deny-warn` in the MoonBit 0.10.x
CLI. `moon fmt --check` is the strict formatting gate; `moon check --fmt
--deny-warn` combines formatting and warning-free compilation; `moon info`
regenerates the public interfaces and CI verifies that they are stable.

For a complete OSC2026-style local check, run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\verify_acceptance.ps1
```

## Configuration

MoonForge reads `Moonforge.toml`. Each task is declared under `[tasks.NAME]`:

| Field | Meaning |
| --- | --- |
| `cmd` | Command to execute |
| `deps` | Tasks that must finish first |
| `inputs` | Files or directories used by the task |
| `outputs` | Files or directories produced by the task |
| `phony` | Whether the task is always considered runnable |
| `desc` | Human-readable task description |

Example:

```toml
[tasks.bundle]
cmd = 'python -c "print(\"bundle\")"'
deps = ["generate"]
inputs = ["src/schema.json"]
outputs = ["dist/bundle.txt"]
phony = false
desc = "Build the bundle"
```

Tasks without declared outputs are treated as effectively phony. The sample
configuration in this repository demonstrates documentation, asset, and
aggregate build tasks.

## CLI

```text
moonforge list [--file PATH]
moonforge graph [TASK] [--file PATH]
moonforge explain [TASK] [--file PATH]
moonforge stats [--file PATH]
moonforge audit [--file PATH]
moonforge clean [--file PATH]
moonforge doctor [--file PATH]
moonforge run [TASK] [--file PATH] [-j N]
```

`run` plans tasks in dependency order, skips up-to-date tasks using input and
output fingerprints, and blocks dependent work after a failure. `-j N` enables
bounded parallel execution within a dependency level. `doctor` reports cycles,
duplicate or overlapping outputs, missing inputs, empty commands, and tasks
that cannot be reached from the default target. `stats` summarizes graph depth,
task classes, declared inputs/outputs, and reachability. `audit` presents the
same review surface as structured severity, code, task, path, and message
findings. Every executed run prints cache-hit and duration metrics.

## Benchmarks

The repository includes reproducible small-chain, medium-mixed, wide-fanout,
and deep-chain workloads. Run them with
`powershell -ExecutionPolicy Bypass -File scripts\run_benchmarks.ps1 -Jobs 4`;
see [benchmarks/README.md](benchmarks/README.md) for the data contract.

## Repository layout

- `*.mbt`: MoonForge library and test implementation.
- `cmd/main`: native CLI entry point.
- `Moonforge.toml`: runnable sample project configuration.
- `docs/`: design, acceptance, release, and competition notes.
- `scripts/verify_acceptance.ps1`: reproducible local acceptance gate.
- `.github/workflows/ci.yml`: pinned cross-platform checks.

## Development

Please read [CONTRIBUTING.md](CONTRIBUTING.md). Pull requests should include
tests for behavior changes and should leave these commands clean:

```bash
moon fmt --check
moon check --fmt --deny-warn --target native
moon info
git diff --exit-code -- pkg.generated.mbti cmd/main/pkg.generated.mbti
moon test --deny-warn --target native
```

## Links and license

- GitHub: <https://github.com/Lyhdsba/MoonForge>
- GitLink: <https://gitlink.org.cn/Lyhdsba/MoonForge>
- Mooncakes: <https://mooncakes.io/docs/Lyhdsba/moonforge>
- Proposal: [proposal/one-page-proposal.md](proposal/one-page-proposal.md)
- Acceptance checklist: [docs/acceptance-checklist.md](docs/acceptance-checklist.md)

MoonForge is released under the [Apache License 2.0](LICENSE).
