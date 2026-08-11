///|
/// A table-driven boundary corpus for path, scheduler, parser, and audit behavior.

///|
test "normalize_path boundary 01" {
  assert_eq(normalize_path(""), ".")
}

///|
test "normalize_path boundary 02" {
  assert_eq(normalize_path(" "), ".")
}

///|
test "normalize_path boundary 03" {
  assert_eq(normalize_path("  alpha  "), "alpha")
}

///|
test "normalize_path boundary 04" {
  assert_eq(normalize_path("alpha\\beta"), "alpha/beta")
}

///|
test "normalize_path boundary 05" {
  assert_eq(normalize_path("alpha\\\\beta"), "alpha/beta")
}

///|
test "normalize_path boundary 06" {
  assert_eq(normalize_path("./alpha"), "./alpha")
}

///|
test "normalize_path boundary 07" {
  assert_eq(normalize_path("/alpha"), "/alpha")
}

///|
test "normalize_path boundary 08" {
  assert_eq(normalize_path("C:\\\\work\\\\file"), "C:/work/file")
}

///|
test "normalize_path boundary 09" {
  assert_eq(normalize_path("a//b"), "a//b")
}

///|
test "normalize_path boundary 10" {
  assert_eq(normalize_path("a/../b"), "a/../b")
}

///|
test "normalize_path boundary 11" {
  assert_eq(normalize_path("\talpha\n"), "alpha")
}

///|
test "normalize_path boundary 12" {
  assert_eq(normalize_path("\r\n"), ".")
}

///|
test "normalize_path boundary 13" {
  assert_eq(normalize_path("one\\two\\three"), "one/two/three")
}

///|
test "normalize_path boundary 14" {
  assert_eq(normalize_path("a/ b"), "a/ b")
}

///|
test "normalize_path boundary 15" {
  assert_eq(normalize_path("./"), "./")
}

///|
test "normalize_path boundary 16" {
  assert_eq(normalize_path("../x"), "../x")
}

///|
test "normalize_path boundary 17" {
  assert_eq(normalize_path("//server/share"), "//server/share")
}

///|
test "normalize_path boundary 18" {
  assert_eq(normalize_path("foo\\ bar"), "foo/ bar")
}

///|
test "normalize_path boundary 19" {
  assert_eq(normalize_path("a\tb"), "a\tb")
}

///|
test "normalize_path boundary 20" {
  assert_eq(normalize_path("a\rb"), "a\rb")
}

///|
test "join_path boundary 01" {
  assert_eq(join_path(".", "file"), "file")
}

///|
test "join_path boundary 02" {
  assert_eq(join_path(".", "dir/file"), "dir/file")
}

///|
test "join_path boundary 03" {
  assert_eq(join_path("root", "."), "root")
}

///|
test "join_path boundary 04" {
  assert_eq(join_path("root", "file"), "root/file")
}

///|
test "join_path boundary 05" {
  assert_eq(join_path("root/", "file"), "root/file")
}

///|
test "join_path boundary 06" {
  assert_eq(join_path("", "file"), "file")
}

///|
test "join_path boundary 07" {
  assert_eq(join_path("base", "child/grand"), "base/child/grand")
}

///|
test "join_path boundary 08" {
  assert_eq(join_path("a", "b\\c"), "a/b/c")
}

///|
test "join_path boundary 09" {
  assert_eq(join_path("a/", "b/"), "a/b/")
}

///|
test "join_path boundary 10" {
  assert_eq(join_path("a", ""), "a")
}

///|
test "join_path boundary 11" {
  assert_eq(join_path("", ""), ".")
}

///|
test "join_path boundary 12" {
  assert_eq(join_path("./", "x"), "./x")
}

///|
test "join_path boundary 13" {
  assert_eq(join_path("tmp/root", "Moonforge.toml"), "tmp/root/Moonforge.toml")
}

///|
test "join_path boundary 14" {
  assert_eq(join_path("C:/root", "x"), "C:/root/x")
}

///|
test "join_path boundary 15" {
  assert_eq(join_path("//server", "share"), "//server/share")
}

///|
test "join_path boundary 16" {
  assert_eq(join_path("a", "../b"), "a/../b")
}

///|
test "join_path boundary 17" {
  assert_eq(join_path("a", "./b"), "a/./b")
}

///|
test "chunk_names scheduler size 01" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 1)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 1 }))
}

///|
test "chunk_names scheduler size 02" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 2)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 2 }))
}

///|
test "chunk_names scheduler size 03" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 3)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 3 }))
}

///|
test "chunk_names scheduler size 04" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 4)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 4 }))
}

///|
test "chunk_names scheduler size 05" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 5)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 5 }))
}

///|
test "chunk_names scheduler size 06" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 6)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 6 }))
}

///|
test "chunk_names scheduler size 07" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 7)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 7 }))
}

///|
test "chunk_names scheduler size 08" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 8)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 8 }))
}

///|
test "chunk_names scheduler size 09" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 9)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 9 }))
}

///|
test "chunk_names scheduler size 10" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 10)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 10 }))
}

///|
test "chunk_names scheduler size 11" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 11)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 11 }))
}

///|
test "chunk_names scheduler size 12" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 12)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 12 }))
}

///|
test "chunk_names scheduler size 13" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 13)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 13 }))
}

///|
test "chunk_names scheduler size 14" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 14)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 14 }))
}

///|
test "chunk_names scheduler size 15" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 15)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 15 }))
}

///|
test "chunk_names scheduler size 16" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 16)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 16 }))
}

///|
test "chunk_names scheduler size 17" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 17)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 17 }))
}

///|
test "chunk_names scheduler size 18" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 18)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 18 }))
}

///|
test "chunk_names scheduler size 19" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 19)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 19 }))
}

///|
test "chunk_names scheduler size 20" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 20)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 20 }))
}

///|
test "chunk_names scheduler size 21" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 21)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 21 }))
}

///|
test "chunk_names scheduler size 22" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 22)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 22 }))
}

///|
test "chunk_names scheduler size 23" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 23)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 23 }))
}

///|
test "chunk_names scheduler size 24" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 24)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 24 }))
}

///|
test "chunk_names scheduler size 25" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 25)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 25 }))
}

///|
test "chunk_names scheduler size 26" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 26)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 26 }))
}

///|
test "chunk_names scheduler size 27" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 27)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 27 }))
}

///|
test "chunk_names scheduler size 28" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 28)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 28 }))
}

///|
test "chunk_names scheduler size 29" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 29)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 29 }))
}

///|
test "chunk_names scheduler size 30" {
  let chunks = chunk_names(["a", "b", "c", "d", "e"], 30)
  assert_true(chunks.length() >= 1)
  assert_eq(chunks.fold(init=0, (total, chunk) => total + chunk.length()), 5)
  assert_true(chunks.all(fn(chunk) { chunk.length() <= 30 }))
}

///|
test "benchmark workload invariant 01" {
  let spec = benchmark_specs()[0]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "benchmark workload invariant 02" {
  let spec = benchmark_specs()[1]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "benchmark workload invariant 03" {
  let spec = benchmark_specs()[2]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "benchmark workload invariant 04" {
  let spec = benchmark_specs()[3]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "benchmark workload invariant 05" {
  let spec = benchmark_specs()[0]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "benchmark workload invariant 06" {
  let spec = benchmark_specs()[1]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "benchmark workload invariant 07" {
  let spec = benchmark_specs()[2]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "benchmark workload invariant 08" {
  let spec = benchmark_specs()[3]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "benchmark workload invariant 09" {
  let spec = benchmark_specs()[0]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "benchmark workload invariant 10" {
  let spec = benchmark_specs()[1]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "benchmark workload invariant 11" {
  let spec = benchmark_specs()[2]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "benchmark workload invariant 12" {
  let spec = benchmark_specs()[3]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "benchmark workload invariant 13" {
  let spec = benchmark_specs()[0]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "benchmark workload invariant 14" {
  let spec = benchmark_specs()[1]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "benchmark workload invariant 15" {
  let spec = benchmark_specs()[2]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "benchmark workload invariant 16" {
  let spec = benchmark_specs()[3]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "benchmark workload invariant 17" {
  let spec = benchmark_specs()[0]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "benchmark workload invariant 18" {
  let spec = benchmark_specs()[1]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "benchmark workload invariant 19" {
  let spec = benchmark_specs()[2]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "benchmark workload invariant 20" {
  let spec = benchmark_specs()[3]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "benchmark workload invariant 21" {
  let spec = benchmark_specs()[0]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "benchmark workload invariant 22" {
  let spec = benchmark_specs()[1]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "benchmark workload invariant 23" {
  let spec = benchmark_specs()[2]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "benchmark workload invariant 24" {
  let spec = benchmark_specs()[3]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "benchmark workload invariant 25" {
  let spec = benchmark_specs()[0]
  let project = build_benchmark_project(spec)
  assert_eq(project.tasks.length(), spec.task_count)
  assert_true(task_order(project, Some("build")).length() == spec.task_count)
}

///|
test "cli parser matrix 01" {
  let suffix = 0
  let args = if suffix % 2 == 0 {
    ["list", "--file", "custom.toml"]
  } else {
    ["audit"]
  }
  let text = @debug.to_string(parse_cli(args))
  assert_true(text.contains(if suffix % 2 == 0 { "List" } else { "Audit" }))
}

///|
test "cli parser matrix 02" {
  let suffix = 1
  let args = if suffix % 2 == 0 {
    ["list", "--file", "custom.toml"]
  } else {
    ["audit"]
  }
  let text = @debug.to_string(parse_cli(args))
  assert_true(text.contains(if suffix % 2 == 0 { "List" } else { "Audit" }))
}

///|
test "cli parser matrix 03" {
  let suffix = 2
  let args = if suffix % 2 == 0 {
    ["list", "--file", "custom.toml"]
  } else {
    ["audit"]
  }
  let text = @debug.to_string(parse_cli(args))
  assert_true(text.contains(if suffix % 2 == 0 { "List" } else { "Audit" }))
}

///|
test "cli parser matrix 04" {
  let suffix = 3
  let args = if suffix % 2 == 0 {
    ["list", "--file", "custom.toml"]
  } else {
    ["audit"]
  }
  let text = @debug.to_string(parse_cli(args))
  assert_true(text.contains(if suffix % 2 == 0 { "List" } else { "Audit" }))
}

///|
test "cli parser matrix 05" {
  let suffix = 4
  let args = if suffix % 2 == 0 {
    ["list", "--file", "custom.toml"]
  } else {
    ["audit"]
  }
  let text = @debug.to_string(parse_cli(args))
  assert_true(text.contains(if suffix % 2 == 0 { "List" } else { "Audit" }))
}

///|
test "cli parser matrix 06" {
  let suffix = 5
  let args = if suffix % 2 == 0 {
    ["list", "--file", "custom.toml"]
  } else {
    ["audit"]
  }
  let text = @debug.to_string(parse_cli(args))
  assert_true(text.contains(if suffix % 2 == 0 { "List" } else { "Audit" }))
}

///|
test "cli parser matrix 07" {
  let suffix = 6
  let args = if suffix % 2 == 0 {
    ["list", "--file", "custom.toml"]
  } else {
    ["audit"]
  }
  let text = @debug.to_string(parse_cli(args))
  assert_true(text.contains(if suffix % 2 == 0 { "List" } else { "Audit" }))
}

///|
test "cli parser matrix 08" {
  let suffix = 7
  let args = if suffix % 2 == 0 {
    ["list", "--file", "custom.toml"]
  } else {
    ["audit"]
  }
  let text = @debug.to_string(parse_cli(args))
  assert_true(text.contains(if suffix % 2 == 0 { "List" } else { "Audit" }))
}

///|
test "cli parser matrix 09" {
  let suffix = 8
  let args = if suffix % 2 == 0 {
    ["list", "--file", "custom.toml"]
  } else {
    ["audit"]
  }
  let text = @debug.to_string(parse_cli(args))
  assert_true(text.contains(if suffix % 2 == 0 { "List" } else { "Audit" }))
}

///|
test "cli parser matrix 10" {
  let suffix = 9
  let args = if suffix % 2 == 0 {
    ["list", "--file", "custom.toml"]
  } else {
    ["audit"]
  }
  let text = @debug.to_string(parse_cli(args))
  assert_true(text.contains(if suffix % 2 == 0 { "List" } else { "Audit" }))
}

///|
test "cli parser matrix 11" {
  let suffix = 10
  let args = if suffix % 2 == 0 {
    ["list", "--file", "custom.toml"]
  } else {
    ["audit"]
  }
  let text = @debug.to_string(parse_cli(args))
  assert_true(text.contains(if suffix % 2 == 0 { "List" } else { "Audit" }))
}

///|
test "cli parser matrix 12" {
  let suffix = 11
  let args = if suffix % 2 == 0 {
    ["list", "--file", "custom.toml"]
  } else {
    ["audit"]
  }
  let text = @debug.to_string(parse_cli(args))
  assert_true(text.contains(if suffix % 2 == 0 { "List" } else { "Audit" }))
}

///|
test "cli parser matrix 13" {
  let suffix = 12
  let args = if suffix % 2 == 0 {
    ["list", "--file", "custom.toml"]
  } else {
    ["audit"]
  }
  let text = @debug.to_string(parse_cli(args))
  assert_true(text.contains(if suffix % 2 == 0 { "List" } else { "Audit" }))
}

///|
test "cli parser matrix 14" {
  let suffix = 13
  let args = if suffix % 2 == 0 {
    ["list", "--file", "custom.toml"]
  } else {
    ["audit"]
  }
  let text = @debug.to_string(parse_cli(args))
  assert_true(text.contains(if suffix % 2 == 0 { "List" } else { "Audit" }))
}

///|
test "cli parser matrix 15" {
  let suffix = 14
  let args = if suffix % 2 == 0 {
    ["list", "--file", "custom.toml"]
  } else {
    ["audit"]
  }
  let text = @debug.to_string(parse_cli(args))
  assert_true(text.contains(if suffix % 2 == 0 { "List" } else { "Audit" }))
}

///|
test "cli parser matrix 16" {
  let suffix = 15
  let args = if suffix % 2 == 0 {
    ["list", "--file", "custom.toml"]
  } else {
    ["audit"]
  }
  let text = @debug.to_string(parse_cli(args))
  assert_true(text.contains(if suffix % 2 == 0 { "List" } else { "Audit" }))
}

///|
test "cli parser matrix 17" {
  let suffix = 16
  let args = if suffix % 2 == 0 {
    ["list", "--file", "custom.toml"]
  } else {
    ["audit"]
  }
  let text = @debug.to_string(parse_cli(args))
  assert_true(text.contains(if suffix % 2 == 0 { "List" } else { "Audit" }))
}

///|
test "cli parser matrix 18" {
  let suffix = 17
  let args = if suffix % 2 == 0 {
    ["list", "--file", "custom.toml"]
  } else {
    ["audit"]
  }
  let text = @debug.to_string(parse_cli(args))
  assert_true(text.contains(if suffix % 2 == 0 { "List" } else { "Audit" }))
}

///|
test "cli parser matrix 19" {
  let suffix = 18
  let args = if suffix % 2 == 0 {
    ["list", "--file", "custom.toml"]
  } else {
    ["audit"]
  }
  let text = @debug.to_string(parse_cli(args))
  assert_true(text.contains(if suffix % 2 == 0 { "List" } else { "Audit" }))
}

///|
test "cli parser matrix 20" {
  let suffix = 19
  let args = if suffix % 2 == 0 {
    ["list", "--file", "custom.toml"]
  } else {
    ["audit"]
  }
  let text = @debug.to_string(parse_cli(args))
  assert_true(text.contains(if suffix % 2 == 0 { "List" } else { "Audit" }))
}

///|
test "model reason matrix 01" {
  let text = reason_message(
    if 0 % 2 == 0 {
      PlanReason::FirstRun
    } else {
      PlanReason::OutputsChanged
    },
  )
  assert_true(text == "first run" || text == "outputs changed")
}

///|
test "model reason matrix 02" {
  let text = reason_message(
    if 1 % 2 == 0 {
      PlanReason::FirstRun
    } else {
      PlanReason::OutputsChanged
    },
  )
  assert_true(text == "first run" || text == "outputs changed")
}

///|
test "model reason matrix 03" {
  let text = reason_message(
    if 2 % 2 == 0 {
      PlanReason::FirstRun
    } else {
      PlanReason::OutputsChanged
    },
  )
  assert_true(text == "first run" || text == "outputs changed")
}

///|
test "model reason matrix 04" {
  let text = reason_message(
    if 3 % 2 == 0 {
      PlanReason::FirstRun
    } else {
      PlanReason::OutputsChanged
    },
  )
  assert_true(text == "first run" || text == "outputs changed")
}

///|
test "model reason matrix 05" {
  let text = reason_message(
    if 4 % 2 == 0 {
      PlanReason::FirstRun
    } else {
      PlanReason::OutputsChanged
    },
  )
  assert_true(text == "first run" || text == "outputs changed")
}

///|
test "model reason matrix 06" {
  let text = reason_message(
    if 5 % 2 == 0 {
      PlanReason::FirstRun
    } else {
      PlanReason::OutputsChanged
    },
  )
  assert_true(text == "first run" || text == "outputs changed")
}

///|
test "model reason matrix 07" {
  let text = reason_message(
    if 6 % 2 == 0 {
      PlanReason::FirstRun
    } else {
      PlanReason::OutputsChanged
    },
  )
  assert_true(text == "first run" || text == "outputs changed")
}

///|
test "model reason matrix 08" {
  let text = reason_message(
    if 7 % 2 == 0 {
      PlanReason::FirstRun
    } else {
      PlanReason::OutputsChanged
    },
  )
  assert_true(text == "first run" || text == "outputs changed")
}

///|
test "model reason matrix 09" {
  let text = reason_message(
    if 8 % 2 == 0 {
      PlanReason::FirstRun
    } else {
      PlanReason::OutputsChanged
    },
  )
  assert_true(text == "first run" || text == "outputs changed")
}

///|
test "model reason matrix 10" {
  let text = reason_message(
    if 9 % 2 == 0 {
      PlanReason::FirstRun
    } else {
      PlanReason::OutputsChanged
    },
  )
  assert_true(text == "first run" || text == "outputs changed")
}

///|
test "model reason matrix 11" {
  let text = reason_message(
    if 10 % 2 == 0 {
      PlanReason::FirstRun
    } else {
      PlanReason::OutputsChanged
    },
  )
  assert_true(text == "first run" || text == "outputs changed")
}

///|
test "model reason matrix 12" {
  let text = reason_message(
    if 11 % 2 == 0 {
      PlanReason::FirstRun
    } else {
      PlanReason::OutputsChanged
    },
  )
  assert_true(text == "first run" || text == "outputs changed")
}

///|
test "model reason matrix 13" {
  let text = reason_message(
    if 12 % 2 == 0 {
      PlanReason::FirstRun
    } else {
      PlanReason::OutputsChanged
    },
  )
  assert_true(text == "first run" || text == "outputs changed")
}

///|
test "model reason matrix 14" {
  let text = reason_message(
    if 13 % 2 == 0 {
      PlanReason::FirstRun
    } else {
      PlanReason::OutputsChanged
    },
  )
  assert_true(text == "first run" || text == "outputs changed")
}

///|
test "model reason matrix 15" {
  let text = reason_message(
    if 14 % 2 == 0 {
      PlanReason::FirstRun
    } else {
      PlanReason::OutputsChanged
    },
  )
  assert_true(text == "first run" || text == "outputs changed")
}

///|
test "model reason matrix 16" {
  let text = reason_message(
    if 15 % 2 == 0 {
      PlanReason::FirstRun
    } else {
      PlanReason::OutputsChanged
    },
  )
  assert_true(text == "first run" || text == "outputs changed")
}

///|
test "model reason matrix 17" {
  let text = reason_message(
    if 16 % 2 == 0 {
      PlanReason::FirstRun
    } else {
      PlanReason::OutputsChanged
    },
  )
  assert_true(text == "first run" || text == "outputs changed")
}

///|
test "model reason matrix 18" {
  let text = reason_message(
    if 17 % 2 == 0 {
      PlanReason::FirstRun
    } else {
      PlanReason::OutputsChanged
    },
  )
  assert_true(text == "first run" || text == "outputs changed")
}

///|
test "model reason matrix 19" {
  let text = reason_message(
    if 18 % 2 == 0 {
      PlanReason::FirstRun
    } else {
      PlanReason::OutputsChanged
    },
  )
  assert_true(text == "first run" || text == "outputs changed")
}

///|
test "model reason matrix 20" {
  let text = reason_message(
    if 19 % 2 == 0 {
      PlanReason::FirstRun
    } else {
      PlanReason::OutputsChanged
    },
  )
  assert_true(text == "first run" || text == "outputs changed")
}
