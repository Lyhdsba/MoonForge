# Contributing

## Development Flow

1. Keep task behavior changes small and reviewable.
2. Update examples or docs together with CLI behavior changes.
3. Run the local verification loop before pushing:
   - `moon info`
   - `moon fmt --check`
   - `moon check`
   - `powershell -ExecutionPolicy Bypass -File scripts\verify_acceptance.ps1`

If a native C compiler is available locally, also run:

- `moon test`
- `moon run --target native cmd/main -- list`

## Scope Guardrails

- Keep v1 focused on declarative tasks, DAG validation, incremental execution,
  explainability, and practical local workflows.
- Do not add a custom DSL or macro system to solve configuration problems.
- Prefer explicit metadata and predictable behavior over clever shortcuts.

## Pull Request Notes

- Mention user-visible CLI changes in `README.md`.
- Record meaningful milestones in `CHANGELOG.md`.
- Keep proposal-facing repository materials readable and stable.
