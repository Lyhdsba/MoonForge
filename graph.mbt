///|
enum VisitState {
  Visiting
  Done
} derive(Eq, @debug.Debug)

///|
pub fn validate_project(project : Project) -> Unit raise MoonforgeError {
  ignore(task_order(project, None))
  ignore(duplicate_outputs(project))
}

///|
pub fn task_order(
  project : Project,
  target : String?,
) -> Array[String] raise MoonforgeError {
  let target_name = match target {
    Some(name) => name
    None => default_task_name(project)
  }
  guard project.tasks.contains(target_name) else {
    raise MissingTask("unknown task '\{target_name}'")
  }
  let order = []
  let states : Map[String, VisitState] = {}
  let stack = []
  dfs_task(project, target_name, states, order, stack)
  order
}

///|
fn dfs_task(
  project : Project,
  name : String,
  states : Map[String, VisitState],
  order : Array[String],
  stack : Array[String],
) -> Unit raise MoonforgeError {
  match states.get(name) {
    Some(Done) => ()
    Some(Visiting) => {
      let cycle = stack + [name]
      raise CycleDetected(join_strings(cycle, " -> "))
    }
    None => {
      states[name] = Visiting
      stack.push(name)
      let task = get_task(project, name)
      for dep in task.deps {
        guard project.tasks.contains(dep) else {
          config_error("task '\{name}' depends on missing task '\{dep}'")
        }
        dfs_task(project, dep, states, order, stack)
      }
      ignore(stack.pop())
      states[name] = Done
      order.push(name)
    }
  }
}

///|
pub fn task_levels(
  project : Project,
  order : Array[String],
) -> Array[Array[String]] raise MoonforgeError {
  let levels : Map[String, Int] = {}
  let max_level = Ref(0)
  for name in order {
    let task = get_task(project, name)
    let mut level = 0
    for dep in task.deps {
      let dep_level = levels.get(dep).unwrap()
      if dep_level + 1 > level {
        level = dep_level + 1
      }
    }
    levels[name] = level
    if level > max_level.val {
      max_level.val = level
    }
  }
  let grouped = Array::make(max_level.val + 1, [])
  for name in order {
    let level = levels.get(name).unwrap()
    grouped[level].push(name)
  }
  grouped
}

///|
pub fn duplicate_outputs(project : Project) -> Array[(String, String, String)] {
  let seen : Map[String, String] = {}
  let duplicates = []
  for task_name, task in project.tasks {
    for output in task.outputs {
      match seen.get(output) {
        Some(other_task) => duplicates.push((output, other_task, task_name))
        None => seen[output] = task_name
      }
    }
  }
  duplicates
}

///|
fn default_task_name(project : Project) -> String {
  if project.tasks.contains("build") {
    "build"
  } else if project.tasks.contains("default") {
    "default"
  } else {
    let names = project.tasks.keys().to_array()
    names.sort()
    names[0]
  }
}

///|
fn get_task(project : Project, name : String) -> Task raise MoonforgeError {
  match project.tasks.get(name) {
    Some(task) => task
    None => raise MissingTask("unknown task '\{name}'")
  }
}
