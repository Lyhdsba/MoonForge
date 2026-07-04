///|
fn[T] fatal(message : String, show_help? : Bool = false) -> T {
  println(message)
  if show_help {
    println(@moonforge.help_text())
  }
  @sys.exit(1)
  abort("unreachable")
}

///|
async fn main {
  let args = @sys.get_cli_args()
  let command = @moonforge.parse_cli(args) catch {
    err => fatal("error: \{@debug.to_string(err)}", show_help=true)
  }
  match command {
    Help => println(@moonforge.help_text())
    List(config_path~) => {
      let project = @moonforge.load_project(config_path~) catch {
        err => fatal("error: \{@debug.to_string(err)}")
      }
      for name in @moonforge.list_tasks(project) {
        println(name)
      }
    }
    Graph(config_path~, target~) => {
      let project = @moonforge.load_project(config_path~) catch {
        err => fatal("error: \{@debug.to_string(err)}")
      }
      let lines = @moonforge.render_graph(project, target) catch {
        err => fatal("error: \{@debug.to_string(err)}")
      }
      for line in lines {
        println(line)
      }
    }
    Explain(config_path~, target~) => {
      let project = @moonforge.load_project(config_path~) catch {
        err => fatal("error: \{@debug.to_string(err)}")
      }
      let lines = @moonforge.explain_task(project, target) catch {
        err => fatal("error: \{@debug.to_string(err)}")
      }
      for line in lines {
        println(line)
      }
    }
    Clean(config_path~) => {
      let project = @moonforge.load_project(config_path~) catch {
        err => fatal("error: \{@debug.to_string(err)}")
      }
      let removed = @moonforge.clean_project(project) catch {
        err => fatal("error: \{@debug.to_string(err)}")
      }
      if removed.is_empty() {
        println("nothing to clean")
      } else {
        for path in removed {
          println("removed \{path}")
        }
      }
    }
    Doctor(config_path~) => {
      let project = @moonforge.load_project(config_path~) catch {
        err => fatal("error: \{@debug.to_string(err)}")
      }
      let findings = @moonforge.doctor(project) catch {
        err => fatal("error: \{@debug.to_string(err)}")
      }
      for line in findings {
        println(line)
      }
    }
    Run(config_path~, target~, jobs~) => {
      let project = @moonforge.load_project(config_path~) catch {
        err => fatal("error: \{@debug.to_string(err)}")
      }
      let summary = @moonforge.run_target(project, target, jobs~) catch {
        err => fatal("error: \{@debug.to_string(err)}")
      }
      for plan in summary.plans {
        println(@moonforge.task_summary_line(plan))
      }
      println(
        "executed: \{summary.executed.length()}, skipped: \{summary.skipped.length()}",
      )
    }
  }
}
