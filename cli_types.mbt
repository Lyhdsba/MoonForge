///|
pub(all) enum CliCommand {
  Help
  List(config_path~ : String)
  Graph(config_path~ : String, target~ : String?)
  Explain(config_path~ : String, target~ : String?)
  Clean(config_path~ : String)
  Doctor(config_path~ : String)
  Run(config_path~ : String, target~ : String?, jobs~ : Int)
} derive(@debug.Debug)

///|
pub fn help_text() -> String {
  (
    #|MoonForge
    #|
    #|Usage:
    #|  moonforge list [--file PATH]
    #|  moonforge graph [TASK] [--file PATH]
    #|  moonforge explain [TASK] [--file PATH]
    #|  moonforge clean [--file PATH]
    #|  moonforge doctor [--file PATH]
    #|  moonforge run [TASK] [--file PATH] [-j N]
    #|
    #|Defaults:
    #|  config path: Moonforge.toml
    #|  run target : build, default, or the first task alphabetically
    #|
  )
}

///|
pub fn parse_cli(args : Array[String]) -> CliCommand raise MoonforgeError {
  if args.is_empty() {
    Help
  } else {
    let command = args[0]
    let rest = args[1:].to_owned()
    match command {
      "help" | "--help" | "-h" => Help
      "list" => {
        let (config_path, _jobs, target) = parse_common_args(rest)
        if target is Some(_) {
          config_error("list does not accept a target argument")
        }
        List(config_path~)
      }
      "graph" => {
        let (config_path, _jobs, target) = parse_common_args(rest)
        Graph(config_path~, target~)
      }
      "explain" => {
        let (config_path, _jobs, target) = parse_common_args(rest)
        Explain(config_path~, target~)
      }
      "clean" => {
        let (config_path, _jobs, target) = parse_common_args(rest)
        if target is Some(_) {
          config_error("clean does not accept a target argument")
        }
        Clean(config_path~)
      }
      "doctor" => {
        let (config_path, _jobs, target) = parse_common_args(rest)
        if target is Some(_) {
          config_error("doctor does not accept a target argument")
        }
        Doctor(config_path~)
      }
      "run" => {
        let (config_path, jobs, target) = parse_common_args(rest)
        Run(config_path~, target~, jobs~)
      }
      _ => config_error("unknown command '\{command}'")
    }
  }
}

///|
fn parse_common_args(
  args : Array[String],
) -> (String, Int, String?) raise MoonforgeError {
  let config_path = Ref("Moonforge.toml")
  let jobs = Ref(1)
  let target = Ref(None)
  let i = Ref(0)
  while i.val < args.length() {
    let arg = args[i.val]
    match arg {
      "--file" | "-f" => {
        guard i.val + 1 < args.length() else {
          config_error("\{arg} requires a value")
        }
        config_path.val = args[i.val + 1]
        i.val += 2
      }
      "--jobs" | "-j" => {
        guard i.val + 1 < args.length() else {
          config_error("\{arg} requires a value")
        }
        jobs.val = parse_jobs(args[i.val + 1])
        i.val += 2
      }
      value if value.has_prefix("-") =>
        config_error("unknown option '\{value}'")
      value => {
        guard target.val is None else {
          config_error("multiple target arguments are not supported")
        }
        target.val = Some(value)
        i.val += 1
      }
    }
  }
  (config_path.val, jobs.val, target.val)
}

///|
fn parse_jobs(raw : String) -> Int raise MoonforgeError {
  @string.parse_int(raw) catch {
    _ => config_error("invalid jobs value '\{raw}'")
  }
}
