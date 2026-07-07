# Acceptance Checklist

This checklist targets the repository-quality expectations that typically matter
for OSC2026 project completion review.

## Repository

- `README.md` exists and is a normal file, not a symbolic link
- `LICENSE`, `CHANGELOG.md`, `CONTRIBUTING.md`, and `SECURITY.md` exist
- GitHub Actions CI exists and matches the documented verification flow
- Commit history is public and contains 10-20 effective commits
- GitHub and GitLink repositories are synchronized

## Project Quality

- Scope is clear and consistent with the proposal
- MoonBit is the primary implementation language
- Example configuration is included
- CLI commands, constraints, and roadmap are documented

## Proposal Materials

- One-page PDF exists under `output/pdf/`
- PDF content is readable and layout is stable
- Proposal source text is readable UTF-8 Chinese
- Repository links in the PDF match the actual public repos

## Verification

- `moon info` passes
- `moon fmt --check` passes
- `moon check` passes
- `powershell -ExecutionPolicy Bypass -File scripts\verify_acceptance.ps1` passes
- If a native C compiler is available, `moon test` and CLI smoke checks pass
- After publication, the package can be resolved from Mooncakes
