///|
pub(all) enum BenchmarkShape {
  Chain
  Mixed
  Fanout
} derive(Eq, @debug.Debug)

///|
pub struct BenchmarkSpec {
  name : String
  task_count : Int
  depth : Int
  fanout : Int
  shape : BenchmarkShape
} derive(Eq, @debug.Debug)

///|
pub fn benchmark_specs() -> Array[BenchmarkSpec] {
  [
    { name: "small-chain", task_count: 12, depth: 11, fanout: 1, shape: Chain },
    { name: "medium-mixed", task_count: 48, depth: 43, fanout: 6, shape: Mixed },
    { name: "wide-fanout", task_count: 33, depth: 1, fanout: 32, shape: Fanout },
    { name: "deep-chain", task_count: 40, depth: 39, fanout: 1, shape: Chain },
  ]
}

///|
pub fn build_benchmark_project(spec : BenchmarkSpec) -> Project {
  let tasks : Map[String, Task] = Map([])
  let non_build_count = spec.task_count - 1
  match spec.shape {
    Chain => add_chain_tasks(tasks, non_build_count)
    Fanout => add_fanout_tasks(tasks, non_build_count)
    Mixed => add_mixed_tasks(tasks, non_build_count, spec.fanout)
  }
  let build_deps = match spec.shape {
    Chain => [benchmark_task_name(non_build_count - 1)]
    Fanout => all_leaf_names(non_build_count)
    Mixed => {
      let deps = all_leaf_names(spec.fanout)
      deps.push(benchmark_task_name(non_build_count - 1))
      deps
    }
  }
  tasks["build"] = benchmark_task(
    name="build",
    deps=build_deps,
    output="benchmarks/out/build.txt",
  )
  {
    root: ".",
    config_path: "benchmarks/generated/\{spec.name}/Moonforge.toml",
    tasks,
  }
}

///|
pub fn benchmark_description(spec : BenchmarkSpec) -> String {
  let shape = match spec.shape {
    Chain => "chain"
    Mixed => "mixed fanout and chain"
    Fanout => "wide fanout"
  }
  "\{spec.name}: \{spec.task_count} tasks, depth \{spec.depth}, \{shape}"
}

///|
fn add_chain_tasks(tasks : Map[String, Task], count : Int) -> Unit {
  for i in 0..<count {
    let deps = if i == 0 { [] } else { [benchmark_task_name(i - 1)] }
    tasks[benchmark_task_name(i)] = benchmark_task(
      name=benchmark_task_name(i),
      deps~,
      output="benchmarks/out/\{benchmark_task_name(i)}.txt",
    )
  }
}

///|
fn add_fanout_tasks(tasks : Map[String, Task], count : Int) -> Unit {
  for i in 0..<count {
    let name = leaf_task_name(i)
    tasks[name] = benchmark_task(
      name~,
      deps=[],
      output="benchmarks/out/\{name}.txt",
    )
  }
}

///|
fn add_mixed_tasks(
  tasks : Map[String, Task],
  count : Int,
  fanout : Int,
) -> Unit {
  for i in 0..<count {
    if i < fanout {
      let name = leaf_task_name(i)
      tasks[name] = benchmark_task(
        name~,
        deps=[],
        output="benchmarks/out/\{name}.txt",
      )
    } else {
      let name = benchmark_task_name(i)
      let deps = if i == fanout {
        [leaf_task_name(0)]
      } else {
        [benchmark_task_name(i - 1)]
      }
      tasks[name] = benchmark_task(
        name~,
        deps~,
        output="benchmarks/out/\{name}.txt",
      )
    }
  }
}

///|
fn benchmark_task(
  name~ : String,
  deps~ : Array[String],
  output~ : String,
) -> Task {
  {
    name,
    cmd: "python -c \"print('moonforge benchmark: \{name}')\"",
    deps,
    inputs: [],
    outputs: [output],
    phony: false,
    desc: Some("generated benchmark workload task"),
  }
}

///|
fn benchmark_task_name(index : Int) -> String {
  "step-\{three_digit(index)}"
}

///|
fn leaf_task_name(index : Int) -> String {
  "leaf-\{three_digit(index)}"
}

///|
fn three_digit(value : Int) -> String {
  if value < 10 {
    "00\{value}"
  } else if value < 100 {
    "0\{value}"
  } else {
    value.to_string()
  }
}

///|
fn all_leaf_names(count : Int) -> Array[String] {
  let names = []
  for i in 0..<count {
    names.push(leaf_task_name(i))
  }
  names
}
