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
  let names = list_tasks(project)
  findings.push("task count: \{names.length()}")
  for name in names {
    let task = get_task(project, name)
    if task.cmd.trim(chars=" \n\r\t").is_empty() {
      findings.push("task '\{name}' has an empty command")
    }
    if task.is_effectively_phony() {
      findings.push("task '\{name}' is phony")
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
