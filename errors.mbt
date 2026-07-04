///|
suberror MoonforgeError {
  ConfigError(String)
  CacheError(String)
  MissingTask(String)
  CycleDetected(String)
  ExecutionError(String)
} derive(@debug.Debug)

///|
fn[T] config_error(message : String) -> T raise MoonforgeError {
  raise ConfigError(message)
}

///|
fn[T] cache_error(message : String) -> T raise MoonforgeError {
  raise CacheError(message)
}

///|
fn[T] execution_error(message : String) -> T raise MoonforgeError {
  raise ExecutionError(message)
}
