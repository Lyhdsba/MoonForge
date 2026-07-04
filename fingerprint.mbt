///|
fn file_signature(path : String) -> String raise MoonforgeError {
  let normalized = normalize_path(path)
  if !@fs.path_exists(normalized) {
    "missing"
  } else {
    let is_dir = @fs.is_dir(normalized) catch {
      @fs.IOError(message) =>
        execution_error("failed to inspect '\{normalized}': \{message}")
    }
    if is_dir {
      let entries = @fs.read_dir(normalized) catch {
        @fs.IOError(message) =>
          execution_error(
            "failed to read directory '\{normalized}': \{message}",
          )
      }
      entries.sort()
      let ctx = @crypto.SHA256::new()
      ctx.update(@utf8.encode("dir:\{normalized}\n"))
      for entry in entries {
        let child = join_path(normalized, entry)
        ctx.update(@utf8.encode(entry))
        ctx.update(@utf8.encode(":"))
        ctx.update(@utf8.encode(file_signature(child)))
        ctx.update(@utf8.encode("\n"))
      }
      @crypto.bytes_to_hex_string(ctx.finalize())
    } else {
      let content = @fs.read_file_to_bytes(normalized) catch {
        @fs.IOError(message) =>
          execution_error("failed to read file '\{normalized}': \{message}")
      }
      hash_bytes(content)
    }
  }
}

///|
fn fingerprint_paths(paths : Array[String]) -> String raise MoonforgeError {
  let normalized = paths.map(normalize_path)
  let parts = []
  for path in normalized {
    parts.push(path)
    parts.push(file_signature(path))
  }
  hash_string(parts)
}

///|
fn outputs_exist(task : Task) -> Bool {
  if task.outputs.is_empty() {
    true
  } else {
    for output in task.outputs {
      if !@fs.path_exists(output) {
        return false
      }
    }
    true
  }
}
