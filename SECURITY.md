# Security Policy

MoonForge is an experimental developer tool and is not intended for hostile
multi-tenant execution.

## Current Security Posture

- Commands are executed on the local machine through the native backend.
- There is no sandbox, privilege separation, or remote cache isolation in v0.1.
- Configuration should be treated as trusted project input.

## Reporting

If you find a security issue that could affect command execution, file handling,
or cache integrity, report it privately to the maintainer before opening a
public issue.

## Hardening Roadmap

- Sandboxed execution adapters
- Safer command environment controls
- Optional stricter checks for overlapping outputs and undeclared writes
