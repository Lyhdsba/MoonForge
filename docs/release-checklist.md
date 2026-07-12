# Release Checklist

- Confirm `moon.mod` identity matches the target Mooncakes account
- Run `moon version --all`
- Run `moon check --fmt --deny-warn --target native`
- Run `moon info` and ensure no generated-interface diff remains
- Run `moon check --deny-warn --target native`
- Run `powershell -ExecutionPolicy Bypass -File scripts\verify_acceptance.ps1`
- If a native compiler is available, run `moon test --deny-warn --target native`
- Regenerate proposal PDF only if proposal source changed
- Push the same final commit to GitHub and GitLink
- Run `moon publish --dry-run`
- Publish to Mooncakes
- Verify the package API entry exists and the docs page is reachable
