///|
pub fn make_plan(
  project : Project,
  cache : CacheSnapshot,
  target : String?,
) -> (Array[String], Array[Array[String]], Array[TaskPlan]) raise MoonforgeError {
  let order = task_order(project, target)
  let levels = task_levels(project, order)
  let plan_map : Map[String, TaskPlan] = {}
  let plans = []
  for name in order {
    let task = get_task(project, name)
    let command_hash = hash_string([task.cmd])
    let input_hash = fingerprint_paths(project.root, task.inputs)
    let dependency_runs = []
    for dep in task.deps {
      match plan_map.get(dep) {
        Some(dep_plan) => if dep_plan.should_run { dependency_runs.push(dep) }
        None => ()
      }
    }
    let reason = if task.is_effectively_phony() {
      PhonyTask
    } else {
      match cache.tasks.get(task.name) {
        None => FirstRun
        Some(_) if !outputs_exist(project.root, task) => OutputMissing
        Some(entry) if entry.command_hash != command_hash => CommandChanged
        Some(entry) if entry.input_hash != input_hash => InputsChanged
        Some(_) if !dependency_runs.is_empty() =>
          DependencyReran(dependency_runs)
        Some(_) => UpToDate
      }
    }
    let plan = {
      task,
      reason,
      should_run: reason != UpToDate,
      command_hash,
      input_hash,
    }
    plan_map[name] = plan
    plans.push(plan)
  }
  (order, levels, plans)
}

///|
pub fn plan_for_task(plans : Array[TaskPlan], task_name : String) -> TaskPlan? {
  for plan in plans {
    if plan.task.name == task_name {
      return Some(plan)
    }
  }
  None
}
