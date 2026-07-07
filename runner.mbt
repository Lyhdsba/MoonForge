///|
pub async fn run_target(
  project : Project,
  target : String?,
  jobs? : Int = 1,
) -> RunSummary raise MoonforgeError {
  validate_project(project)
  let cache = load_cache(project)
  let (_order, levels, plans) = make_plan(project, cache, target)
  let plan_map : Map[String, TaskPlan] = {}
  for plan in plans {
    plan_map[plan.task.name] = plan
  }
  let executed = []
  let skipped = []
  let new_cache = { version: cache.version, tasks: cache.tasks }
  let jobs = if jobs <= 0 { 1 } else { jobs }
  for level in levels {
    for batch in chunk_names(level, jobs) {
      @async.with_task_group(async fn(group) {
        let pending = []
        for task_name in batch {
          let plan = plan_map.get(task_name).unwrap()
          if plan.should_run {
            pending.push(
              group.spawn(async fn() {
                let entry = run_one(project, plan)
                (task_name, entry)
              }),
            )
          } else {
            skipped.push(task_name)
          }
        }
        for task_handle in pending {
          let (task_name, entry) = task_handle.wait() catch {
            err => execution_error(@debug.to_string(err))
          }
          executed.push(task_name)
          new_cache.tasks[task_name] = entry
        }
        group.return_immediately(())
      }) catch {
        err => execution_error(@debug.to_string(err))
      }
    }
  }
  save_cache(project, new_cache)
  { plans, executed, skipped }
}

///|
async fn run_one(
  project : Project,
  plan : TaskPlan,
) -> CacheEntry raise MoonforgeError {
  ensure_output_parents(plan.task.outputs)
  let started = @bench.monotonic_clock_start()
  let result = @subprocess.exec(plan.task.cmd, cwd=project.root, check=true) catch {
    @subprocess.CommandFailed(result) =>
      execution_error(
        "task '\{plan.task.name}' failed with exit code \{result.exit_code}\n\{result.stderr}",
      )
    @subprocess.SpawnFailed(message) =>
      execution_error("task '\{plan.task.name}' could not start: \{message}")
  }
  ignore(result)
  let duration_ms = (@bench.monotonic_clock_end(started) * 1000.0).to_int()
  let input_hash = fingerprint_paths(project.root, plan.task.inputs)
  let output_hash = fingerprint_paths(project.root, plan.task.outputs)
  { command_hash: plan.command_hash, input_hash, output_hash, duration_ms }
}

///|
fn chunk_names(items : Array[String], size : Int) -> Array[Array[String]] {
  if items.is_empty() {
    []
  } else {
    let chunks = []
    let current = []
    for item in items {
      current.push(item)
      if current.length() >= size {
        chunks.push(current.copy())
        current.clear()
      }
    }
    if !current.is_empty() {
      chunks.push(current)
    }
    chunks
  }
}
