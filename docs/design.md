# MoonForge Design

MoonForge chooses a narrow v1 boundary on purpose:

- Config is plain TOML instead of a custom DSL.
- Incrementality is based on command hash plus recursive file fingerprints.
- Execution uses shell commands with project-root `cwd`.
- Parallelism is level-based, not a fully dynamic scheduler.

That tradeoff keeps the implementation easy to inspect in competition review
while still covering realistic workflows such as docs generation, asset copying,
and local CI orchestration.

## Why TOML

- Easy to review in PRs
- Familiar to users of Rust, Python, and tooling ecosystems
- Good fit for static task declarations
- Avoids inventing a second language before the execution engine is stable

## Cache Model

MoonForge stores cache metadata in `.moonforge/cache.json`.

Each task snapshot keeps:

- `command_hash`
- `input_hash`
- `output_hash`
- `duration_ms`

The planner reruns a task when:

- no cache entry exists
- the task is phony
- a declared output is missing
- the command changed
- any input fingerprint changed
- a dependency reran

## Execution Model

- Validate config and dependency graph first.
- Compute a topological order.
- Group tasks by dependency level.
- Run each level in batches of at most `-j N`.
- Stop the pipeline on the first command failure.

This is intentionally smaller than a full Ninja-style scheduler, but it keeps
the behavior predictable and easier to debug.
