# Acceptance Checklist

This checklist tracks the current OSC2026 completion expectations and the extra
pre-acceptance hardening items applied to MoonForge.

## Repository

- `README.md` exists and is a normal file, not a symbolic link
- `LICENSE`, `CHANGELOG.md`, `CONTRIBUTING.md`, and `SECURITY.md` exist
- `docs/official-requirements.md` and `docs/source-attribution.md` exist
- GitHub Actions CI exists, uses MoonBit `0.10.3`, and matches the documented verification flow
- Commit history is public and shows sustained post-registration development
- GitHub and GitLink repositories are synchronized on the same `main` branch

## Project Quality

- Scope is clear and consistent with the proposal
- MoonBit is the primary implementation language
- Example configuration is included
- CLI commands, constraints, roadmap, and source-attribution boundaries are documented
- `moonforge stats` and `moonforge doctor` both expose reviewer-friendly repository diagnostics

## Proposal Materials

- One-page PDF exists under `output/pdf/`
- PDF content is readable and layout is stable
- Proposal source text is readable UTF-8 Chinese
- Repository links in the PDF match the actual public repos

## Verification

- `moon check --fmt --deny-warn --target native` passes
- `moon info` regenerates no unexpected public-interface changes
- `moon check --deny-warn --target native` passes
- `powershell -ExecutionPolicy Bypass -File scripts\verify_acceptance.ps1` passes
- If a native C compiler is available, `moon test --deny-warn --target native` and CLI smoke checks pass
- After publication, the package can be resolved from Mooncakes
