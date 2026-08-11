///|
pub(all) enum AuditSeverity {
  Error
  Warning
  Info
} derive(Eq, @debug.Debug)

///|
pub(all) enum AuditCode {
  DuplicateOutput
  OverlappingOutput
  MissingInput
  EmptyCommand
  UnreachableTask
  PhonyTaskInfo
} derive(Eq, @debug.Debug)

///|
pub struct AuditFinding {
  severity : AuditSeverity
  code : AuditCode
  task : String
  related_task : String?
  path : String?
  message : String
} derive(Eq, @debug.Debug)

///|
pub struct AuditReport {
  stats : ProjectStats
  findings : Array[AuditFinding]
} derive(@debug.Debug)

///|
pub fn audit_project(project : Project) -> AuditReport raise MoonforgeError {
  let stats = project_stats(project)
  let findings = []
  let names = list_tasks(project)
  let reachable = task_order(project, Some(stats.default_target))

  for item in duplicate_outputs(project) {
    let (path, left, right) = item
    findings.push({
      severity: Error,
      code: DuplicateOutput,
      task: left,
      related_task: Some(right),
      path: Some(path),
      message: "two tasks declare the same output",
    })
  }
  for item in overlapping_output_findings(project) {
    let (left, right) = item
    findings.push({
      severity: Error,
      code: OverlappingOutput,
      task: left,
      related_task: Some(right),
      path: None,
      message: "task outputs overlap by path prefix",
    })
  }
  for item in missing_input_findings(project) {
    let (task_name, input) = item
    findings.push({
      severity: Error,
      code: MissingInput,
      task: task_name,
      related_task: None,
      path: Some(input),
      message: "declared input is absent and not produced by a dependency",
    })
  }
  for name in names {
    let task = get_task(project, name)
    if task.cmd.trim(chars=" \n\r\t").is_empty() {
      findings.push({
        severity: Error,
        code: EmptyCommand,
        task: name,
        related_task: None,
        path: None,
        message: "task has an empty command",
      })
    }
    if task.is_effectively_phony() {
      findings.push({
        severity: Info,
        code: PhonyTaskInfo,
        task: task.name,
        related_task: None,
        path: None,
        message: "task always runs because it is phony or has no outputs",
      })
    }
    if !reachable.contains(name) {
      findings.push({
        severity: Warning,
        code: UnreachableTask,
        task: name,
        related_task: None,
        path: None,
        message: "task is not reachable from the default target",
      })
    }
  }
  { stats, findings }
}

///|
pub fn audit_code_label(code : AuditCode) -> String {
  match code {
    DuplicateOutput => "duplicate-output"
    OverlappingOutput => "overlapping-output"
    MissingInput => "missing-input"
    EmptyCommand => "empty-command"
    UnreachableTask => "unreachable-task"
    PhonyTaskInfo => "phony-task"
  }
}

///|
pub fn audit_severity_label(severity : AuditSeverity) -> String {
  match severity {
    Error => "error"
    Warning => "warning"
    Info => "info"
  }
}

///|
pub fn audit_status(report : AuditReport) -> String {
  for finding in report.findings {
    if finding.severity is Error {
      return "error"
    }
  }
  for finding in report.findings {
    if finding.severity is Warning {
      return "warning"
    }
  }
  "clean"
}

///|
pub fn render_audit_report(
  project : Project,
) -> Array[String] raise MoonforgeError {
  let report = audit_project(project)
  let lines = [
    "MoonForge audit",
    "status: \{audit_status(report)}",
    "tasks: \{report.stats.total_tasks}",
    "default target: \{report.stats.default_target}",
    "max dependency depth: \{report.stats.max_depth}",
    "declared inputs: \{report.stats.total_declared_inputs}",
    "declared outputs: \{report.stats.total_declared_outputs}",
    "findings: \{report.findings.length()}",
  ]
  for finding in report.findings {
    let related = match finding.related_task {
      Some(name) => " with \{name}"
      None => ""
    }
    let path = match finding.path {
      Some(value) => " path=\{value}"
      None => ""
    }
    lines.push(
      "[\{audit_severity_label(finding.severity)}] \{audit_code_label(finding.code)} task=\{finding.task}\{related}\{path}: \{finding.message}",
    )
  }
  lines
}
