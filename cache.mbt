///|
fn cache_dir(project : Project) -> String {
  join_path(project.root, ".moonforge")
}

///|
fn cache_path(project : Project) -> String {
  join_path(cache_dir(project), "cache.json")
}

///|
pub fn load_cache(project : Project) -> CacheSnapshot raise MoonforgeError {
  let path = cache_path(project)
  if !@fs.path_exists(path) {
    empty_cache()
  } else {
    let text = @fs.read_file_to_string(path) catch {
      @fs.IOError(message) =>
        cache_error("failed to read cache '\{path}': \{message}")
    }
    let value = @json.parse(text) catch {
      err =>
        cache_error("failed to parse cache '\{path}': \{@debug.to_string(err)}")
    }
    @json.from_json(value) catch {
      err =>
        cache_error(
          "failed to decode cache '\{path}': \{@debug.to_string(err)}",
        )
    }
  }
}

///|
pub fn save_cache(
  project : Project,
  snapshot : CacheSnapshot,
) -> Unit raise MoonforgeError {
  let path = cache_path(project)
  let text = snapshot.to_json().stringify(indent=2)
  write_text_file(path, text)
}
