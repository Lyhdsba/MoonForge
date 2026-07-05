# Acceptance Checklist

This checklist targets the MoonBit OSC2026 proposal and repository review expectations.

## Repository

- `README.md` exists and is a normal file, not a symbolic link
- `LICENSE` exists
- Commit history is public and contains 10-20 effective commits
- GitHub and GitLink repositories are synchronized

## Project Quality

- Core scope is clear and matches the proposal
- MoonBit is the primary implementation language
- Example configuration is included
- Commands and current limitations are documented

## Proposal Materials

- One-page PDF exists under `output/pdf/`
- PDF content is readable and layout is stable
- Proposal source text is readable UTF-8 Chinese
- Repository links in the PDF match the actual public repos

## Verification

- `moon check` passes
- `powershell -ExecutionPolicy Bypass -File scripts\verify_acceptance.ps1` passes
- PDF page count is exactly 1
