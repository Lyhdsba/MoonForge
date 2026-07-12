///|
fn fixture_dir(name : String) -> String {
  "tmp/moonforge-tests/\{name}"
}

///|
fn reset_dir(path : String) -> Unit raise MoonforgeError {
  if @fs.path_exists(path) {
    remove_path_recursive(path)
  }
  ensure_dir_all(path)
}

///|
fn write_source_command() -> String {
  "python -c \"from pathlib import Path; Path(r\\\"build\\\").mkdir(parents=True, exist_ok=True); Path(r\\\"build/source.txt\\\").write_text(\\\"alpha\\\", encoding=\\\"utf-8\\\")\""
}

///|
fn copy_bundle_command() -> String {
  "python -c \"from pathlib import Path; Path(r\\\"build/bundle.txt\\\").write_text(Path(r\\\"build/source.txt\\\").read_text(encoding=\\\"utf-8\\\") + \\\"-bundle\\\", encoding=\\\"utf-8\\\")\""
}

///|
fn sample_config_text() -> String {
  [
    "[tasks.generate]",
    "cmd = '\{write_source_command()}'",
    "outputs = [\"build/source.txt\"]",
    "desc = \"generate a source file\"",
    "",
    "[tasks.bundle]",
    "cmd = '\{copy_bundle_command()}'",
    "deps = [\"generate\"]",
    "inputs = [\"build/source.txt\"]",
    "outputs = [\"build/bundle.txt\"]",
    "desc = \"copy the generated file\"",
    "",
    "[tasks.ci-local]",
    "cmd = 'python -c \"print(\\\"ci-local\\\")\"'",
    "deps = [\"bundle\"]",
    "phony = true",
    "",
  ].join("\n")
}

///|
fn write_config(path : String) -> Unit raise MoonforgeError {
  write_text_file(path, sample_config_text())
}

///|
test "load_project parses tasks" {
  let root = fixture_dir("parse")
  reset_dir(root)
  let config_path = join_path(root, "Moonforge.toml")
  write_config(config_path)
  let project = load_project(root~, config_path~)
  assert_true(project.tasks.contains("generate"))
  assert_true(project.tasks.contains("bundle"))
  let bundle = project.tasks.get("bundle").unwrap()
  inspect(bundle.deps.join(","), content="generate")
}

///|
test "doctor detects duplicate outputs" {
  let root = fixture_dir("doctor")
  reset_dir(root)
  let config_path = join_path(root, "Moonforge.toml")
  write_text_file(
    config_path,
    [
      "[tasks.a]", "cmd = 'python -c \"print(1)\"'", "outputs = [\"dist/out.txt\"]",
      "", "[tasks.b]", "cmd = 'python -c \"print(2)\"'", "outputs = [\"dist/out.txt\"]",
      "",
    ].join("\n"),
  )
  let project = load_project(root~, config_path~)
  let findings = doctor(project)
  assert_true(findings.join("\n").contains("duplicate output"))
}

///|
async test "run_target executes tasks and caches results" {
  let root = fixture_dir("run")
  reset_dir(root)
  let config_path = join_path(root, "Moonforge.toml")
  write_config(config_path)
  let project = load_project(root~, config_path~)
  let first = run_target(project, Some("bundle"))
  assert_eq(first.executed.length(), 2)
  let bundle_path = join_path(root, "build/bundle.txt")
  let text = read_text_file(bundle_path)
  inspect(text, content="alpha-bundle")

  let second = run_target(project, Some("bundle"))
  assert_eq(second.executed.length(), 0)
  assert_eq(second.skipped.length(), 2)
}

///|
async test "explain shows up to date after cached run" {
  let root = fixture_dir("explain")
  reset_dir(root)
  let config_path = join_path(root, "Moonforge.toml")
  write_config(config_path)
  let project = load_project(root~, config_path~)
  ignore(run_target(project, Some("bundle")))
  ignore(run_target(project, Some("bundle")))
  let lines = explain_task(project, Some("bundle"))
  let text = lines.join("\n")
  assert_true(text.contains("[skip] generate - up to date"))
  assert_true(text.contains("[skip] bundle - up to date"))
}

///|
test "doctor detects missing inputs without producing dependencies" {
  let root = fixture_dir("missing-inputs")
  reset_dir(root)
  let config_path = join_path(root, "Moonforge.toml")
  write_text_file(
    config_path,
    [
      "[tasks.build]", "cmd = 'python -c \"print(1)\"'", "inputs = [\"missing/data.txt\"]",
      "outputs = [\"dist/out.txt\"]", "",
    ].join("\n"),
  )
  let project = load_project(root~, config_path~)
  let findings = doctor(project)
  assert_true(findings.join("\n").contains("declares missing input"))
}

///|
test "doctor allows dependency-produced inputs before execution" {
  let root = fixture_dir("dependency-inputs")
  reset_dir(root)
  let config_path = join_path(root, "Moonforge.toml")
  write_text_file(
    config_path,
    [
      "[tasks.generate]", "cmd = 'python -c \"from pathlib import Path; Path(r\\\"dist\\\").mkdir(parents=True, exist_ok=True); Path(r\\\"dist/source.txt\\\").write_text(\\\"ok\\\", encoding=\\\"utf-8\\\")\"'",
      "outputs = [\"dist/source.txt\"]", "", "[tasks.bundle]", "cmd = 'python -c \"print(1)\"'",
      "deps = [\"generate\"]", "inputs = [\"dist/source.txt\"]", "outputs = [\"dist/bundle.txt\"]",
      "",
    ].join("\n"),
  )
  let project = load_project(root~, config_path~)
  let findings = doctor(project)
  assert_true(
    !findings.join("\n").contains("declares missing input 'dist/source.txt'"),
  )
}
