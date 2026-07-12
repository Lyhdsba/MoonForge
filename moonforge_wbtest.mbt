///|
test "task_order keeps dependencies before target" {
  let project : Project = {
    root: ".",
    config_path: "Moonforge.toml",
    tasks: {
      "generate": {
        name: "generate",
        cmd: "echo generate",
        deps: [],
        inputs: [],
        outputs: ["dist/a.txt"],
        phony: false,
        desc: None,
      },
      "bundle": {
        name: "bundle",
        cmd: "echo bundle",
        deps: ["generate"],
        inputs: ["dist/a.txt"],
        outputs: ["dist/b.txt"],
        phony: false,
        desc: None,
      },
    },
  }
  inspect(
    task_order(project, Some("bundle")).join(","),
    content="generate,bundle",
  )
}

///|
test "chunk_names respects job size" {
  let chunks = chunk_names(["a", "b", "c"], 2)
  debug_inspect(
    chunks,
    content=(
      #|[["a", "b"], ["c"]]
    ),
  )
}

///|
test "task_levels keeps each layer isolated" {
  let project : Project = {
    root: ".",
    config_path: "Moonforge.toml",
    tasks: {
      "generate": {
        name: "generate",
        cmd: "echo generate",
        deps: [],
        inputs: [],
        outputs: ["dist/a.txt"],
        phony: false,
        desc: None,
      },
      "bundle": {
        name: "bundle",
        cmd: "echo bundle",
        deps: ["generate"],
        inputs: ["dist/a.txt"],
        outputs: ["dist/b.txt"],
        phony: false,
        desc: None,
      },
    },
  }
  let levels = task_levels(project, ["generate", "bundle"])
  debug_inspect(
    levels,
    content=(
      #|[["generate"], ["bundle"]]
    ),
  )
}

///|
test "project_stats summarizes the dependency graph" {
  let project : Project = {
    root: ".",
    config_path: "Moonforge.toml",
    tasks: {
      "generate": {
        name: "generate",
        cmd: "echo generate",
        deps: [],
        inputs: ["src/input.txt"],
        outputs: ["dist/a.txt"],
        phony: false,
        desc: None,
      },
      "bundle": {
        name: "bundle",
        cmd: "echo bundle",
        deps: ["generate"],
        inputs: ["dist/a.txt"],
        outputs: ["dist/b.txt"],
        phony: false,
        desc: None,
      },
      "report": {
        name: "report",
        cmd: "echo report",
        deps: ["bundle"],
        inputs: ["dist/b.txt"],
        outputs: [],
        phony: true,
        desc: None,
      },
    },
  }
  let stats = project_stats(project)
  assert_eq(stats.default_target, "bundle")
  assert_eq(stats.total_tasks, 3)
  assert_eq(stats.root_tasks, 1)
  assert_eq(stats.leaf_tasks, 1)
  assert_eq(stats.max_depth, 2)
  assert_eq(stats.phony_tasks, 1)
}
