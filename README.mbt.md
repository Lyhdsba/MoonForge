# MoonForge

MoonForge is a MoonBit-native incremental task runner for small builds, code
generation pipelines, document workflows, asset preparation, and local CI.

## Highlights

- Declarative `Moonforge.toml` task configuration.
- Dependency graph validation and cycle detection.
- Input/output fingerprinting with `.moonforge/cache.json`.
- `run`, `list`, `graph`, `explain`, `stats`, `clean`, and `doctor` commands.
- Bounded parallel execution by dependency level with `-j N`.

## Quick start

```mbt nocheck
moon update
moon check --fmt --deny-warn --target native
moon fmt --check
moon info
moon test --deny-warn --target native
moon run --target native cmd/main -- stats
```

## Configuration example

```toml
[tasks.bundle]
cmd = 'python -c "print(\"bundle\")"'
deps = ["generate"]
inputs = ["src/schema.json"]
outputs = ["dist/bundle.txt"]
phony = false
desc = "Build the bundle"
```

Supported fields are `cmd`, `deps`, `inputs`, `outputs`, `phony`, and `desc`.
Tasks without outputs are treated as effectively phony.

## CLI

```text
moonforge list [--file PATH]
moonforge graph [TASK] [--file PATH]
moonforge explain [TASK] [--file PATH]
moonforge stats [--file PATH]
moonforge clean [--file PATH]
moonforge doctor [--file PATH]
moonforge run [TASK] [--file PATH] [-j N]
```
