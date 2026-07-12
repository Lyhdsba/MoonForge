# Source Attribution

## Project Type

MoonForge is an original MoonBit project for OSC2026. It is not a line-by-line
port of an existing repository.

## Design References

The project direction takes inspiration from widely known build and task tools
such as `make`, `ninja`, `just`, and small pipeline runners, but the current
repository implements its own:

- `Moonforge.toml` configuration shape
- incremental planning rules
- file-fingerprint cache layout
- CLI command set
- MoonBit-native data model and tests

## License Boundary

This repository is released under `Apache-2.0`. No private, closed-source, or
commercial code was copied into the implementation.

## AI Assistance Boundary

AI tools were used only as development assistance for implementation,
documentation polishing, and repository verification. Final repository content
was reviewed, edited, and validated inside this public project workspace.
