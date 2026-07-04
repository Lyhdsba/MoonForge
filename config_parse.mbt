///|
pub fn load_project(
  root? : String = ".",
  config_path? : String = "Moonforge.toml",
) -> Project raise MoonforgeError {
  let root = normalize_path(root)
  let config_path = normalize_path(config_path)
  guard @fs.path_exists(config_path) else {
    config_error("config file not found: \{config_path}")
  }
  let source = read_text_file(config_path)
  let parsed = @toml.parse(source) catch {
    err =>
      config_error("failed to parse \{config_path}: \{@debug.to_string(err)}")
  }
  let tasks = parse_tasks(parsed)
  { root, config_path, tasks }
}

///|
fn parse_tasks(
  value : @toml.TomlValue,
) -> Map[String, Task] raise MoonforgeError {
  guard value is @toml.TomlTable(root) else {
    config_error("Moonforge config must be a TOML table")
  }
  let tasks_value = root.get("tasks")
  guard tasks_value is Some(@toml.TomlTable(tasks_table)) else {
    config_error("Moonforge config must define a [tasks] table")
  }
  let tasks : Map[String, Task] = {}
  for name, task_value in tasks_table {
    tasks[name] = parse_task(name, task_value)
  }
  guard !tasks.is_empty() else {
    config_error("Moonforge config must define at least one task")
  }
  tasks
}

///|
fn parse_task(
  name : String,
  value : @toml.TomlValue,
) -> Task raise MoonforgeError {
  guard value is @toml.TomlTable(table) else {
    config_error("task '\{name}' must be a TOML table")
  }
  let cmd = required_string_field(table, task_name=name, field="cmd")
  let deps = string_array_field(table, task_name=name, field="deps")
  let inputs = string_array_field(table, task_name=name, field="inputs")
  let outputs = string_array_field(table, task_name=name, field="outputs")
  let phony = bool_field(table, task_name=name, field="phony", default=false)
  let desc = optional_string_field(table, task_name=name, field="desc")
  {
    name,
    cmd,
    deps: deps.map(normalize_path),
    inputs: inputs.map(normalize_path),
    outputs: outputs.map(normalize_path),
    phony,
    desc,
  }
}

///|
fn required_string_field(
  table : Map[String, @toml.TomlValue],
  task_name~ : String,
  field~ : String,
) -> String raise MoonforgeError {
  match table.get(field) {
    Some(@toml.TomlString(value)) => value
    Some(_) =>
      config_error("task '\{task_name}' field '\{field}' must be a string")
    None => config_error("task '\{task_name}' is missing '\{field}'")
  }
}

///|
fn optional_string_field(
  table : Map[String, @toml.TomlValue],
  task_name~ : String,
  field~ : String,
) -> String? raise MoonforgeError {
  match table.get(field) {
    Some(@toml.TomlString(value)) => Some(value)
    Some(_) =>
      config_error("task '\{task_name}' field '\{field}' must be a string")
    None => None
  }
}

///|
fn bool_field(
  table : Map[String, @toml.TomlValue],
  task_name~ : String,
  field~ : String,
  default~ : Bool,
) -> Bool raise MoonforgeError {
  match table.get(field) {
    Some(@toml.TomlBoolean(value)) => value
    Some(_) =>
      config_error("task '\{task_name}' field '\{field}' must be a boolean")
    None => default
  }
}

///|
fn string_array_field(
  table : Map[String, @toml.TomlValue],
  task_name~ : String,
  field~ : String,
) -> Array[String] raise MoonforgeError {
  match table.get(field) {
    None => []
    Some(@toml.TomlArray(items)) => {
      let result = []
      for item in items {
        match item {
          @toml.TomlString(value) => result.push(value)
          _ =>
            config_error(
              "task '\{task_name}' field '\{field}' must contain strings only",
            )
        }
      }
      result
    }
    Some(_) =>
      config_error("task '\{task_name}' field '\{field}' must be an array")
  }
}
