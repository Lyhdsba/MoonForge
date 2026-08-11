///|
test "benchmark specs cover small, medium, wide, and deep workloads" {
  let specs = benchmark_specs()
  assert_eq(specs.length(), 4)
  assert_eq(specs[0].name, "small-chain")
  assert_eq(specs[1].name, "medium-mixed")
  assert_eq(specs[2].name, "wide-fanout")
  assert_eq(specs[3].name, "deep-chain")
  for spec in specs {
    let project = build_benchmark_project(spec)
    assert_eq(project.tasks.length(), spec.task_count)
    assert_true(project.tasks.contains("build"))
    ignore(validate_project(project))
  }
}

///|
test "small chain has deterministic order and depth" {
  let spec = benchmark_specs()[0]
  let project = build_benchmark_project(spec)
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_eq(order.length(), spec.task_count)
  assert_eq(levels.length(), spec.depth + 1)
  assert_eq(order[0], "step-000")
  assert_eq(order[order.length() - 1], "build")
}

///|
test "wide fanout keeps independent leaves in one dependency level" {
  let spec = benchmark_specs()[2]
  let project = build_benchmark_project(spec)
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_eq(levels.length(), 2)
  assert_eq(levels[0].length(), spec.task_count - 1)
  assert_eq(levels[1], ["build"])
}

///|
test "mixed workload exposes graph statistics" {
  let project = build_benchmark_project(benchmark_specs()[1])
  let stats = project_stats(project)
  assert_eq(stats.default_target, "build")
  assert_true(stats.total_tasks > 20)
  assert_true(stats.max_depth > 3)
  assert_true(stats.total_declared_outputs > 0)
}

///|
test "benchmark project names are stable across repeated generation" {
  for spec in benchmark_specs() {
    let left = list_tasks(build_benchmark_project(spec))
    let right = list_tasks(build_benchmark_project(spec))
    assert_eq(left, right)
  }
}
