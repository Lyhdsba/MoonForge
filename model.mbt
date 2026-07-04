///|
pub struct Task {
  name : String
  cmd : String
  deps : Array[String]
  inputs : Array[String]
  outputs : Array[String]
  phony : Bool
  desc : String?
} derive(Eq, @debug.Debug)

///|
pub fn Task::is_effectively_phony(self : Task) -> Bool {
  self.phony || self.outputs.is_empty()
}

///|
pub struct Project {
  root : String
  config_path : String
  tasks : Map[String, Task]
} derive(@debug.Debug)

///|
pub(all) enum PlanReason {
  FirstRun
  PhonyTask
  CommandChanged
  InputsChanged
  OutputMissing
  DependencyReran(Array[String])
  UpToDate
} derive(Eq, @debug.Debug)

///|
pub struct TaskPlan {
  task : Task
  reason : PlanReason
  should_run : Bool
  command_hash : String
  input_hash : String
} derive(@debug.Debug)

///|
pub struct CacheEntry {
  command_hash : String
  input_hash : String
  output_hash : String
  duration_ms : Int
} derive(ToJson, FromJson, Eq, @debug.Debug)

///|
pub struct CacheSnapshot {
  version : Int
  tasks : Map[String, CacheEntry]
} derive(ToJson, FromJson, Eq, @debug.Debug)

///|
pub struct RunSummary {
  plans : Array[TaskPlan]
  executed : Array[String]
  skipped : Array[String]
} derive(@debug.Debug)

///|
pub fn empty_cache() -> CacheSnapshot {
  { version: 1, tasks: {} }
}

///|
pub fn reason_message(reason : PlanReason) -> String {
  match reason {
    FirstRun => "first run"
    PhonyTask => "phony task"
    CommandChanged => "command changed"
    InputsChanged => "inputs changed"
    OutputMissing => "output missing"
    DependencyReran(names) => {
      let joined = join_strings(names, ", ")
      "dependency reran: \{joined}"
    }
    UpToDate => "up to date"
  }
}

///|
pub fn task_summary_line(plan : TaskPlan) -> String {
  let marker = if plan.should_run { "run " } else { "skip" }
  "[\{marker}] \{plan.task.name} - \{reason_message(plan.reason)}"
}
