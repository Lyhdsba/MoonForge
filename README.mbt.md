# MoonForge

MoonForge is a MoonBit-native incremental task runner for small builds, codegen
pipelines, docs workflows, and reproducible local CI commands.

It focuses on a compact, inspectable workflow:

- Declarative `Moonforge.toml`
- DAG validation and cycle detection
- Input/output fingerprinting with cache stored in `.moonforge/cache.json`
- `run`, `list`, `graph`, `explain`, `clean`, and `doctor` commands
- Batch parallel execution by dependency level with `-j N`

## Quick Start

Install dependencies and run the CLI:

```mbt nocheck
moon check
moon run --target native cmd/main -- list
moon run --target native cmd/main -- run build
moon run --target native cmd/main -- explain build
```

The repository ships with a sample [Moonforge.toml](/C:/Users/px830/Documents/罗永华/Moonforge.toml)
that demonstrates:

- a docs-style transform
- an asset copy step
- a phony aggregate task

## Config Shape

Top-level configuration is a single `[tasks]` table.

```toml
[tasks.bundle]
cmd = 'python -c "print(\"bundle\")"'
deps = ["generate"]
inputs = ["src/schema.json"]
outputs = ["dist/bundle.txt"]
phony = false
desc = "Build the bundle"
```

Supported task fields:

- `cmd`: shell command to execute
- `deps`: dependent task names
- `inputs`: files or directories to fingerprint
- `outputs`: files or directories expected after the task runs
- `phony`: always rerun this task
- `desc`: short description

Tasks without outputs are treated as effectively phony.

## CLI

```text
moonforge list [--file PATH]
moonforge graph [TASK] [--file PATH]
moonforge explain [TASK] [--file PATH]
moonforge clean [--file PATH]
moonforge doctor [--file PATH]
moonforge run [TASK] [--file PATH] [-j N]
```

If no run target is supplied, MoonForge prefers `build`, then `default`, then
the first task alphabetically.

## Notes

- Current execution support is native-target focused because command execution
  depends on `trkbt10/subprocess`.
- Parallelism is intentionally simple in v1: tasks run concurrently only when
  they are in the same dependency level and `-j` allows it.
