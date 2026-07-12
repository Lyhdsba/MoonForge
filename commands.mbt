///|
pub fn list_tasks(project : Project) -> Array[String] {
  let names = project.tasks.keys().to_array()
  names.sort()
  names
}

///|
pub fn render_graph(
  project : Project,
  target : String?,
) -> Array[String] raise MoonforgeError {
  let order = task_order(project, target)
  let lines = []
  for name in order {
    let task = get_task(project, name)
    let deps = if task.deps.is_empty() {
      "(root)"
    } else {
      join_strings(task.deps, ", ")
    }
    lines.push("\{name} <- \{deps}")
  }
  lines
}

///|
pub fn explain_task(
  project : Project,
  target : String?,
) -> Array[String] raise MoonforgeError {
  let cache = load_cache(project)
  let (_order, _levels, plans) = make_plan(project, cache, target)
  let lines = []
  for plan in plans {
    lines.push(task_summary_line(plan))
  }
  lines
}

///|
pub fn project_stats(project : Project) -> ProjectStats raise MoonforgeError {
  validate_project(project)
  let names = list_tasks(project)
  let reverse_deps = reverse_dependency_map(project)
  let default_target = default_task_name(project)
  let default_order = task_order(project, Some(default_target))
  let missing_inputs = missing_input_findings(project)
  let duplicate_outputs = duplicate_outputs(project)
  let overlapping_outputs = overlapping_output_findings(project)
  let mut phony_tasks = 0
  let mut concrete_tasks = 0
  let mut tasks_with_inputs = 0
  let mut tasks_with_outputs = 0
  let mut total_declared_inputs = 0
  let mut total_declared_outputs = 0
  let mut root_tasks = 0
  let mut leaf_tasks = 0
  let mut max_depth = 0
  for name in names {
    let task = get_task(project, name)
    total_declared_inputs += task.inputs.length()
    total_declared_outputs += task.outputs.length()
    if task.is_effectively_phony() {
      phony_tasks += 1
    } else {
      concrete_tasks += 1
    }
    if !task.inputs.is_empty() {
      tasks_with_inputs += 1
    }
    if !task.outputs.is_empty() {
      tasks_with_outputs += 1
    }
    if task.deps.is_empty() {
      root_tasks += 1
    }
    if reverse_deps.get(name).unwrap_or([]).is_empty() {
      leaf_tasks += 1
    }
    let depth = dependency_depth(project, name)
    if depth > max_depth {
      max_depth = depth
    }
  }
  {
    default_target,
    total_tasks: names.length(),
    root_tasks,
    leaf_tasks,
    phony_tasks,
    concrete_tasks,
    tasks_with_inputs,
    tasks_with_outputs,
    total_declared_inputs,
    total_declared_outputs,
    max_depth,
    duplicate_outputs: duplicate_outputs.length(),
    overlapping_outputs: overlapping_outputs.length(),
    missing_inputs: missing_inputs.length(),
    unreachable_tasks: names.length() - default_order.length(),
  }
}

///|
pub fn render_project_stats(
  project : Project,
) -> Array[String] raise MoonforgeError {
  let stats = project_stats(project)
  [
    "default target: \{stats.default_target}",
    "task count: \{stats.total_tasks}",
    "root tasks: \{stats.root_tasks}",
    "leaf tasks: \{stats.leaf_tasks}",
    "phony tasks: \{stats.phony_tasks}",
    "concrete tasks: \{stats.concrete_tasks}",
    "tasks with inputs: \{stats.tasks_with_inputs}",
    "tasks with outputs: \{stats.tasks_with_outputs}",
    "declared inputs: \{stats.total_declared_inputs}",
    "declared outputs: \{stats.total_declared_outputs}",
    "max dependency depth: \{stats.max_depth}",
    "duplicate outputs: \{stats.duplicate_outputs}",
    "overlapping outputs: \{stats.overlapping_outputs}",
    "missing inputs: \{stats.missing_inputs}",
    "unreachable tasks from default target: \{stats.unreachable_tasks}",
  ]
}

///|
pub fn doctor(project : Project) -> Array[String] raise MoonforgeError {
  let findings = []
  validate_project(project)
  findings.push("config parses successfully")
  let duplicates = duplicate_outputs(project)
  if duplicates.is_empty() {
    findings.push("no duplicate outputs detected")
  } else {
    for item in duplicates {
      let (output, left, right) = item
      findings.push(
        "duplicate output '\{output}' declared by \{left} and \{right}",
      )
    }
  }
  let overlapping_outputs = overlapping_output_findings(project)
  if overlapping_outputs.is_empty() {
    findings.push("no overlapping output directories detected")
  } else {
    for item in overlapping_outputs {
      let (left, right) = item
      findings.push("overlapping outputs declared by \{left} and \{right}")
    }
  }
  let missing_inputs = missing_input_findings(project)
  if missing_inputs.is_empty() {
    findings.push("all declared inputs exist or are produced by dependencies")
  } else {
    for item in missing_inputs {
      let (task_name, input) = item
      findings.push(
        "task '\{task_name}' declares missing input '\{input}' without a producing dependency",
      )
    }
  }
  let names = list_tasks(project)
  let reachable = task_order(project, Some(default_task_name(project)))
  findings.push("task count: \{names.length()}")
  findings.push(
    "reachable from default target '\{default_task_name(project)}': \{reachable.length()}",
  )
  for name in names {
    let task = get_task(project, name)
    if task.cmd.trim(chars=" \n\r\t").is_empty() {
      findings.push("task '\{name}' has an empty command")
    }
    if task.is_effectively_phony() {
      findings.push("task '\{name}' is phony")
    }
    if !reachable.contains(name) {
      findings.push("task '\{name}' is unreachable from the default target")
    }
  }
  findings
}

///|
pub fn clean_project(project : Project) -> Array[String] raise MoonforgeError {
  let removed = []
  for name, task in project.tasks {
    ignore(name)
    for output in task.outputs {
      if @fs.path_exists(output) {
        remove_path_recursive(output)
        removed.push(output)
      }
    }
  }
  let cache_file = cache_path(project)
  if @fs.path_exists(cache_file) {
    remove_path_recursive(cache_file)
    removed.push(cache_file)
  }
  let cache_folder = cache_dir(project)
  if @fs.path_exists(cache_folder) {
    let entries = @fs.read_dir(cache_folder) catch {
      @fs.IOError(message) =>
        execution_error("failed to read cache directory: \{message}")
    }
    if entries.is_empty() {
      remove_path_recursive(cache_folder)
      removed.push(cache_folder)
    }
  }
  removed
}

///|
fn reverse_dependency_map(project : Project) -> Map[String, Array[String]] {
  let reverse : Map[String, Array[String]] = {}
  for name in project.tasks.keys() {
    reverse[name] = []
  }
  for task_name, task in project.tasks {
    for dep in task.deps {
      let users = reverse.get(dep).unwrap_or([])
      users.push(task_name)
      reverse[dep] = users
    }
  }
  reverse
}

///|
fn dependency_depth(
  project : Project,
  name : String,
) -> Int raise MoonforgeError {
  let task = get_task(project, name)
  if task.deps.is_empty() {
    0
  } else {
    let mut max_dep = 0
    for dep in task.deps {
      let depth = dependency_depth(project, dep) + 1
      if depth > max_dep {
        max_dep = depth
      }
    }
    max_dep
  }
}

///|
fn overlapping_output_findings(project : Project) -> Array[(String, String)] {
  let declared = []
  for task_name, task in project.tasks {
    for output in task.outputs {
      declared.push((task_name, normalize_path(output)))
    }
  }
  let findings = []
  for i = 0; i < declared.length(); i = i + 1 {
    let (left_task, left_path) = declared[i]
    for j = i + 1; j < declared.length(); j = j + 1 {
      let (right_task, right_path) = declared[j]
      if left_path == right_path {
        ()
      } else if is_path_prefix(left_path, right_path) ||
        is_path_prefix(right_path, left_path) {
        findings.push((left_task, right_task))
      }
    }
  }
  findings
}

///|
fn missing_input_findings(
  project : Project,
) -> Array[(String, String)] raise MoonforgeError {
  let findings = []
  for task_name, task in project.tasks {
    let available = declared_outputs_from_dependencies(project, task_name)
    for input in task.inputs {
      let resolved = resolve_project_path(project.root, input)
      if @fs.path_exists(resolved) || available.contains(normalize_path(input)) {
        ()
      } else {
        findings.push((task_name, normalize_path(input)))
      }
    }
  }
  findings
}

///|
fn declared_outputs_from_dependencies(
  project : Project,
  task_name : String,
) -> Array[String] raise MoonforgeError {
  let outputs = []
  let seen : Map[String, Bool] = {}
  collect_dependency_outputs(project, task_name, seen, outputs)
  outputs
}

///|
fn collect_dependency_outputs(
  project : Project,
  task_name : String,
  seen : Map[String, Bool],
  outputs : Array[String],
) -> Unit raise MoonforgeError {
  let task = get_task(project, task_name)
  for dep in task.deps {
    if !seen.contains(dep) {
      seen[dep] = true
      let dep_task = get_task(project, dep)
      for output in dep_task.outputs {
        let normalized = normalize_path(output)
        if !outputs.contains(normalized) {
          outputs.push(normalized)
        }
      }
      collect_dependency_outputs(project, dep, seen, outputs)
    }
  }
}

///|
fn is_path_prefix(left : String, right : String) -> Bool {
  let normalized_left = normalize_path(left)
  let normalized_right = normalize_path(right)
  normalized_right.has_prefix("\{normalized_left}/")
}
