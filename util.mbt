///|
fn normalize_path(path : String) -> String {
  let trimmed = path.trim(chars=" \n\r\t").to_owned()
  if trimmed.is_empty() {
    "."
  } else {
    trimmed.replace_all(old="\\", new="/")
  }
}

///|
fn dirname_string(path : String) -> String {
  let normalized = normalize_path(path)
  match normalized.rev_find("/") {
    Some(index) => if index == 0 { "/" } else { normalized[:index].to_owned() }
    None => "."
  }
}

///|
fn join_path(base : String, child : String) -> String {
  let left = normalize_path(base)
  let right = normalize_path(child)
  if left == "." || left.is_empty() {
    right
  } else if right == "." || right.is_empty() {
    left
  } else if left.has_suffix("/") {
    "\{left}\{right}"
  } else {
    "\{left}/\{right}"
  }
}

///|
fn join_strings(items : Array[String], sep : String) -> String {
  if items.is_empty() {
    ""
  } else {
    let buffer = StringBuilder::new()
    for index = 0; index < items.length(); index = index + 1 {
      if index > 0 {
        buffer.write_string(sep)
      }
      buffer.write_string(items[index])
    }
    buffer.to_string()
  }
}

///|
fn ensure_dir_all(path : String) -> Unit raise MoonforgeError {
  let normalized = normalize_path(path)
  if normalized == "." || normalized.is_empty() || @fs.path_exists(normalized) {
    ()
  } else {
    let parent = dirname_string(normalized)
    if parent != normalized {
      ensure_dir_all(parent)
    }
    @fs.create_dir(normalized) catch {
      @fs.IOError(message) =>
        config_error("failed to create directory '\{normalized}': \{message}")
    }
  }
}

///|
fn ensure_output_parents(outputs : Array[String]) -> Unit raise MoonforgeError {
  for output in outputs {
    ensure_dir_all(dirname_string(output))
  }
}

///|
fn hash_string(parts : Array[String]) -> String {
  let ctx = @crypto.SHA256::new()
  for part in parts {
    ctx.update(@utf8.encode(part))
    ctx.update(@utf8.encode("\n--moonforge--\n"))
  }
  @crypto.bytes_to_hex_string(ctx.finalize())
}

///|
fn hash_bytes(bytes : Bytes) -> String {
  @crypto.bytes_to_hex_string(@crypto.sha256(bytes))
}

///|
fn remove_path_recursive(path : String) -> Unit raise MoonforgeError {
  let normalized = normalize_path(path)
  if !@fs.path_exists(normalized) {
    ()
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
      for entry in entries {
        remove_path_recursive(join_path(normalized, entry))
      }
      @fs.remove_dir(normalized) catch {
        @fs.IOError(message) =>
          execution_error(
            "failed to remove directory '\{normalized}': \{message}",
          )
      }
    } else {
      @fs.remove_file(normalized) catch {
        @fs.IOError(message) =>
          execution_error("failed to remove file '\{normalized}': \{message}")
      }
    }
  }
}

///|
fn read_text_file(path : String) -> String raise MoonforgeError {
  @fs.read_file_to_string(path) catch {
    @fs.IOError(message) => config_error("failed to read '\{path}': \{message}")
  }
}

///|
fn write_text_file(
  path : String,
  content : String,
) -> Unit raise MoonforgeError {
  ensure_dir_all(dirname_string(path))
  @fs.write_string_to_file(path, content) catch {
    @fs.IOError(message) => cache_error("failed to write '\{path}': \{message}")
  }
}
