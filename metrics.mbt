///|
pub struct RunMetrics {
  total_tasks : Int
  executed_tasks : Int
  skipped_tasks : Int
  total_duration_ms : Int
  average_duration_ms : Int
  cache_hit_percent : Int
  longest_task : String?
  longest_duration_ms : Int
} derive(@debug.Debug)

///|
pub fn run_metrics(summary : RunSummary) -> RunMetrics {
  let total_tasks = summary.plans.length()
  let executed_tasks = summary.executed.length()
  let skipped_tasks = summary.skipped.length()
  let mut total_duration_ms = 0
  let mut longest_task : String? = None
  let mut longest_duration_ms = 0
  for task_name, duration_ms in summary.durations_ms {
    total_duration_ms += duration_ms
    if duration_ms > longest_duration_ms {
      longest_duration_ms = duration_ms
      longest_task = Some(task_name)
    }
  }
  let average_duration_ms = if executed_tasks == 0 {
    0
  } else {
    total_duration_ms / executed_tasks
  }
  let cache_hit_percent = if total_tasks == 0 {
    100
  } else {
    skipped_tasks * 100 / total_tasks
  }
  {
    total_tasks,
    executed_tasks,
    skipped_tasks,
    total_duration_ms,
    average_duration_ms,
    cache_hit_percent,
    longest_task,
    longest_duration_ms,
  }
}

///|
pub fn render_run_metrics(summary : RunSummary) -> Array[String] {
  let metrics = run_metrics(summary)
  let longest = match metrics.longest_task {
    Some(task) => "\{task} (\{metrics.longest_duration_ms} ms)"
    None => "none"
  }
  [
    "metrics:",
    "  total tasks: \{metrics.total_tasks}",
    "  executed tasks: \{metrics.executed_tasks}",
    "  skipped tasks: \{metrics.skipped_tasks}",
    "  cache hit rate: \{metrics.cache_hit_percent}%",
    "  total execution time: \{metrics.total_duration_ms} ms",
    "  average execution time: \{metrics.average_duration_ms} ms",
    "  longest task: \{longest}",
  ]
}

///|
pub fn metrics_csv_header() -> String {
  "total_tasks,executed_tasks,skipped_tasks,cache_hit_percent,total_duration_ms,average_duration_ms,longest_task,longest_duration_ms"
}

///|
pub fn metrics_csv_row(summary : RunSummary) -> String {
  let metrics = run_metrics(summary)
  let longest = match metrics.longest_task {
    Some(task) => task.replace_all(old="\"", new="\"\"")
    None => ""
  }
  [
    metrics.total_tasks.to_string(),
    metrics.executed_tasks.to_string(),
    metrics.skipped_tasks.to_string(),
    metrics.cache_hit_percent.to_string(),
    metrics.total_duration_ms.to_string(),
    metrics.average_duration_ms.to_string(),
    longest,
    metrics.longest_duration_ms.to_string(),
  ].join(",")
}
