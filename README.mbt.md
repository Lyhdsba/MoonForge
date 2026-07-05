# MoonForge

MoonForge is a MoonBit-native incremental task runner for small builds, code
generation pipelines, document workflows, and reproducible local CI commands.

## Highlights

- Declarative `Moonforge.toml`
- DAG validation and cycle detection
- Input/output fingerprinting with `.moonforge/cache.json`
- `run`, `list`, `graph`, `explain`, `clean`, and `doctor` commands
- Batch parallel execution by dependency level with `-j N`

## Quick Start

```mbt nocheck
moon check
moon run --target native cmd/main -- list
moon run --target native cmd/main -- graph build
moon run --target native cmd/main -- explain build
moon run --target native cmd/main -- run build
```

## Config Example

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

- `cmd`
- `deps`
- `inputs`
- `outputs`
- `phony`
- `desc`

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
