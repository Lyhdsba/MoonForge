///|
fn matrix_task(
  name : String,
  deps : Array[String],
  outputs : Array[String],
) -> Task {
  {
    name,
    cmd: "echo matrix",
    deps,
    inputs: [],
    outputs,
    phony: false,
    desc: None,
  }
}

///|
fn matrix_project(tasks : Array[Task]) -> Project {
  let map : Map[String, Task] = Map([])
  for task in tasks {
    map[task.name] = task
  }
  { root: ".", config_path: "Moonforge.toml", tasks: map }
}

///|
test "path prefix matrix 001" {
  assert_eq(is_path_prefix("dist", "dist/file.txt"), true)
}

///|
test "path prefix matrix 002" {
  assert_eq(is_path_prefix("dist", "dist/nested/file.txt"), true)
}

///|
test "path prefix matrix 003" {
  assert_eq(is_path_prefix("dist/out", "dist/out.txt"), false)
}

///|
test "path prefix matrix 004" {
  assert_eq(is_path_prefix("dist/out", "dist/out/file.txt"), true)
}

///|
test "path prefix matrix 005" {
  assert_eq(is_path_prefix("a/b", "a/b/c"), true)
}

///|
test "path prefix matrix 006" {
  assert_eq(is_path_prefix("a/b", "a/bc"), false)
}

///|
test "path prefix matrix 007" {
  assert_eq(is_path_prefix("", "x"), false)
}

///|
test "path prefix matrix 008" {
  assert_eq(is_path_prefix(".", "./x"), true)
}

///|
test "path prefix matrix 009" {
  assert_eq(is_path_prefix("build", "build"), false)
}

///|
test "path prefix matrix 010" {
  assert_eq(is_path_prefix("build/out", "build/out"), false)
}

///|
test "path prefix matrix 011" {
  assert_eq(is_path_prefix("tmp/cache", "tmp/cache/data"), true)
}

///|
test "path prefix matrix 012" {
  assert_eq(is_path_prefix("tmp/cache", "tmp/cache2/data"), false)
}

///|
test "path prefix matrix 013" {
  assert_eq(is_path_prefix("foo/bar", "foo/bar/baz/qux"), true)
}

///|
test "path prefix matrix 014" {
  assert_eq(is_path_prefix("foo/bar", "foo/barley"), false)
}

///|
test "path prefix matrix 015" {
  assert_eq(is_path_prefix("one/two/three", "one/two/three/four"), true)
}

///|
test "path prefix matrix 016" {
  assert_eq(is_path_prefix("one/two/three", "one/two"), false)
}

///|
test "path prefix matrix 017" {
  assert_eq(is_path_prefix("root", "root/a"), true)
}

///|
test "path prefix matrix 018" {
  assert_eq(is_path_prefix("root/a", "root"), false)
}

///|
test "path prefix matrix 019" {
  assert_eq(is_path_prefix("a", "a/b/c/d"), true)
}

///|
test "path prefix matrix 020" {
  assert_eq(is_path_prefix("a/b/c", "a/b/cd"), false)
}

///|
test "path prefix matrix 021" {
  assert_eq(is_path_prefix("dist", "dist/file.txt"), true)
}

///|
test "path prefix matrix 022" {
  assert_eq(is_path_prefix("dist", "dist/nested/file.txt"), true)
}

///|
test "path prefix matrix 023" {
  assert_eq(is_path_prefix("dist/out", "dist/out.txt"), false)
}

///|
test "path prefix matrix 024" {
  assert_eq(is_path_prefix("dist/out", "dist/out/file.txt"), true)
}

///|
test "path prefix matrix 025" {
  assert_eq(is_path_prefix("a/b", "a/b/c"), true)
}

///|
test "path prefix matrix 026" {
  assert_eq(is_path_prefix("a/b", "a/bc"), false)
}

///|
test "path prefix matrix 027" {
  assert_eq(is_path_prefix("", "x"), false)
}

///|
test "path prefix matrix 028" {
  assert_eq(is_path_prefix(".", "./x"), true)
}

///|
test "path prefix matrix 029" {
  assert_eq(is_path_prefix("build", "build"), false)
}

///|
test "path prefix matrix 030" {
  assert_eq(is_path_prefix("build/out", "build/out"), false)
}

///|
test "path prefix matrix 031" {
  assert_eq(is_path_prefix("tmp/cache", "tmp/cache/data"), true)
}

///|
test "path prefix matrix 032" {
  assert_eq(is_path_prefix("tmp/cache", "tmp/cache2/data"), false)
}

///|
test "path prefix matrix 033" {
  assert_eq(is_path_prefix("foo/bar", "foo/bar/baz/qux"), true)
}

///|
test "path prefix matrix 034" {
  assert_eq(is_path_prefix("foo/bar", "foo/barley"), false)
}

///|
test "path prefix matrix 035" {
  assert_eq(is_path_prefix("one/two/three", "one/two/three/four"), true)
}

///|
test "path prefix matrix 036" {
  assert_eq(is_path_prefix("one/two/three", "one/two"), false)
}

///|
test "path prefix matrix 037" {
  assert_eq(is_path_prefix("root", "root/a"), true)
}

///|
test "path prefix matrix 038" {
  assert_eq(is_path_prefix("root/a", "root"), false)
}

///|
test "path prefix matrix 039" {
  assert_eq(is_path_prefix("a", "a/b/c/d"), true)
}

///|
test "path prefix matrix 040" {
  assert_eq(is_path_prefix("a/b/c", "a/b/cd"), false)
}

///|
test "path prefix matrix 041" {
  assert_eq(is_path_prefix("dist", "dist/file.txt"), true)
}

///|
test "path prefix matrix 042" {
  assert_eq(is_path_prefix("dist", "dist/nested/file.txt"), true)
}

///|
test "path prefix matrix 043" {
  assert_eq(is_path_prefix("dist/out", "dist/out.txt"), false)
}

///|
test "path prefix matrix 044" {
  assert_eq(is_path_prefix("dist/out", "dist/out/file.txt"), true)
}

///|
test "path prefix matrix 045" {
  assert_eq(is_path_prefix("a/b", "a/b/c"), true)
}

///|
test "path prefix matrix 046" {
  assert_eq(is_path_prefix("a/b", "a/bc"), false)
}

///|
test "path prefix matrix 047" {
  assert_eq(is_path_prefix("", "x"), false)
}

///|
test "path prefix matrix 048" {
  assert_eq(is_path_prefix(".", "./x"), true)
}

///|
test "path prefix matrix 049" {
  assert_eq(is_path_prefix("build", "build"), false)
}

///|
test "path prefix matrix 050" {
  assert_eq(is_path_prefix("build/out", "build/out"), false)
}

///|
test "path prefix matrix 051" {
  assert_eq(is_path_prefix("tmp/cache", "tmp/cache/data"), true)
}

///|
test "path prefix matrix 052" {
  assert_eq(is_path_prefix("tmp/cache", "tmp/cache2/data"), false)
}

///|
test "path prefix matrix 053" {
  assert_eq(is_path_prefix("foo/bar", "foo/bar/baz/qux"), true)
}

///|
test "path prefix matrix 054" {
  assert_eq(is_path_prefix("foo/bar", "foo/barley"), false)
}

///|
test "path prefix matrix 055" {
  assert_eq(is_path_prefix("one/two/three", "one/two/three/four"), true)
}

///|
test "path prefix matrix 056" {
  assert_eq(is_path_prefix("one/two/three", "one/two"), false)
}

///|
test "path prefix matrix 057" {
  assert_eq(is_path_prefix("root", "root/a"), true)
}

///|
test "path prefix matrix 058" {
  assert_eq(is_path_prefix("root/a", "root"), false)
}

///|
test "path prefix matrix 059" {
  assert_eq(is_path_prefix("a", "a/b/c/d"), true)
}

///|
test "path prefix matrix 060" {
  assert_eq(is_path_prefix("a/b/c", "a/b/cd"), false)
}

///|
test "path prefix matrix 061" {
  assert_eq(is_path_prefix("dist", "dist/file.txt"), true)
}

///|
test "path prefix matrix 062" {
  assert_eq(is_path_prefix("dist", "dist/nested/file.txt"), true)
}

///|
test "path prefix matrix 063" {
  assert_eq(is_path_prefix("dist/out", "dist/out.txt"), false)
}

///|
test "path prefix matrix 064" {
  assert_eq(is_path_prefix("dist/out", "dist/out/file.txt"), true)
}

///|
test "path prefix matrix 065" {
  assert_eq(is_path_prefix("a/b", "a/b/c"), true)
}

///|
test "path prefix matrix 066" {
  assert_eq(is_path_prefix("a/b", "a/bc"), false)
}

///|
test "path prefix matrix 067" {
  assert_eq(is_path_prefix("", "x"), false)
}

///|
test "path prefix matrix 068" {
  assert_eq(is_path_prefix(".", "./x"), true)
}

///|
test "path prefix matrix 069" {
  assert_eq(is_path_prefix("build", "build"), false)
}

///|
test "path prefix matrix 070" {
  assert_eq(is_path_prefix("build/out", "build/out"), false)
}

///|
test "path prefix matrix 071" {
  assert_eq(is_path_prefix("tmp/cache", "tmp/cache/data"), true)
}

///|
test "path prefix matrix 072" {
  assert_eq(is_path_prefix("tmp/cache", "tmp/cache2/data"), false)
}

///|
test "path prefix matrix 073" {
  assert_eq(is_path_prefix("foo/bar", "foo/bar/baz/qux"), true)
}

///|
test "path prefix matrix 074" {
  assert_eq(is_path_prefix("foo/bar", "foo/barley"), false)
}

///|
test "path prefix matrix 075" {
  assert_eq(is_path_prefix("one/two/three", "one/two/three/four"), true)
}

///|
test "path prefix matrix 076" {
  assert_eq(is_path_prefix("one/two/three", "one/two"), false)
}

///|
test "path prefix matrix 077" {
  assert_eq(is_path_prefix("root", "root/a"), true)
}

///|
test "path prefix matrix 078" {
  assert_eq(is_path_prefix("root/a", "root"), false)
}

///|
test "path prefix matrix 079" {
  assert_eq(is_path_prefix("a", "a/b/c/d"), true)
}

///|
test "path prefix matrix 080" {
  assert_eq(is_path_prefix("a/b/c", "a/b/cd"), false)
}

///|
test "path prefix matrix 081" {
  assert_eq(is_path_prefix("dist", "dist/file.txt"), true)
}

///|
test "path prefix matrix 082" {
  assert_eq(is_path_prefix("dist", "dist/nested/file.txt"), true)
}

///|
test "path prefix matrix 083" {
  assert_eq(is_path_prefix("dist/out", "dist/out.txt"), false)
}

///|
test "path prefix matrix 084" {
  assert_eq(is_path_prefix("dist/out", "dist/out/file.txt"), true)
}

///|
test "path prefix matrix 085" {
  assert_eq(is_path_prefix("a/b", "a/b/c"), true)
}

///|
test "path prefix matrix 086" {
  assert_eq(is_path_prefix("a/b", "a/bc"), false)
}

///|
test "path prefix matrix 087" {
  assert_eq(is_path_prefix("", "x"), false)
}

///|
test "path prefix matrix 088" {
  assert_eq(is_path_prefix(".", "./x"), true)
}

///|
test "path prefix matrix 089" {
  assert_eq(is_path_prefix("build", "build"), false)
}

///|
test "path prefix matrix 090" {
  assert_eq(is_path_prefix("build/out", "build/out"), false)
}

///|
test "path prefix matrix 091" {
  assert_eq(is_path_prefix("tmp/cache", "tmp/cache/data"), true)
}

///|
test "path prefix matrix 092" {
  assert_eq(is_path_prefix("tmp/cache", "tmp/cache2/data"), false)
}

///|
test "path prefix matrix 093" {
  assert_eq(is_path_prefix("foo/bar", "foo/bar/baz/qux"), true)
}

///|
test "path prefix matrix 094" {
  assert_eq(is_path_prefix("foo/bar", "foo/barley"), false)
}

///|
test "path prefix matrix 095" {
  assert_eq(is_path_prefix("one/two/three", "one/two/three/four"), true)
}

///|
test "path prefix matrix 096" {
  assert_eq(is_path_prefix("one/two/three", "one/two"), false)
}

///|
test "path prefix matrix 097" {
  assert_eq(is_path_prefix("root", "root/a"), true)
}

///|
test "path prefix matrix 098" {
  assert_eq(is_path_prefix("root/a", "root"), false)
}

///|
test "path prefix matrix 099" {
  assert_eq(is_path_prefix("a", "a/b/c/d"), true)
}

///|
test "path prefix matrix 100" {
  assert_eq(is_path_prefix("a/b/c", "a/b/cd"), false)
}

///|
test "path prefix matrix 101" {
  assert_eq(is_path_prefix("dist", "dist/file.txt"), true)
}

///|
test "path prefix matrix 102" {
  assert_eq(is_path_prefix("dist", "dist/nested/file.txt"), true)
}

///|
test "path prefix matrix 103" {
  assert_eq(is_path_prefix("dist/out", "dist/out.txt"), false)
}

///|
test "path prefix matrix 104" {
  assert_eq(is_path_prefix("dist/out", "dist/out/file.txt"), true)
}

///|
test "path prefix matrix 105" {
  assert_eq(is_path_prefix("a/b", "a/b/c"), true)
}

///|
test "path prefix matrix 106" {
  assert_eq(is_path_prefix("a/b", "a/bc"), false)
}

///|
test "path prefix matrix 107" {
  assert_eq(is_path_prefix("", "x"), false)
}

///|
test "path prefix matrix 108" {
  assert_eq(is_path_prefix(".", "./x"), true)
}

///|
test "path prefix matrix 109" {
  assert_eq(is_path_prefix("build", "build"), false)
}

///|
test "path prefix matrix 110" {
  assert_eq(is_path_prefix("build/out", "build/out"), false)
}

///|
test "path prefix matrix 111" {
  assert_eq(is_path_prefix("tmp/cache", "tmp/cache/data"), true)
}

///|
test "path prefix matrix 112" {
  assert_eq(is_path_prefix("tmp/cache", "tmp/cache2/data"), false)
}

///|
test "path prefix matrix 113" {
  assert_eq(is_path_prefix("foo/bar", "foo/bar/baz/qux"), true)
}

///|
test "path prefix matrix 114" {
  assert_eq(is_path_prefix("foo/bar", "foo/barley"), false)
}

///|
test "path prefix matrix 115" {
  assert_eq(is_path_prefix("one/two/three", "one/two/three/four"), true)
}

///|
test "path prefix matrix 116" {
  assert_eq(is_path_prefix("one/two/three", "one/two"), false)
}

///|
test "path prefix matrix 117" {
  assert_eq(is_path_prefix("root", "root/a"), true)
}

///|
test "path prefix matrix 118" {
  assert_eq(is_path_prefix("root/a", "root"), false)
}

///|
test "path prefix matrix 119" {
  assert_eq(is_path_prefix("a", "a/b/c/d"), true)
}

///|
test "path prefix matrix 120" {
  assert_eq(is_path_prefix("a/b/c", "a/b/cd"), false)
}

///|
test "graph order matrix 01" {
  let project = build_benchmark_project(benchmark_specs()[0])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 02" {
  let project = build_benchmark_project(benchmark_specs()[1])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 03" {
  let project = build_benchmark_project(benchmark_specs()[2])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 04" {
  let project = build_benchmark_project(benchmark_specs()[3])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 05" {
  let project = build_benchmark_project(benchmark_specs()[0])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 06" {
  let project = build_benchmark_project(benchmark_specs()[1])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 07" {
  let project = build_benchmark_project(benchmark_specs()[2])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 08" {
  let project = build_benchmark_project(benchmark_specs()[3])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 09" {
  let project = build_benchmark_project(benchmark_specs()[0])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 10" {
  let project = build_benchmark_project(benchmark_specs()[1])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 11" {
  let project = build_benchmark_project(benchmark_specs()[2])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 12" {
  let project = build_benchmark_project(benchmark_specs()[3])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 13" {
  let project = build_benchmark_project(benchmark_specs()[0])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 14" {
  let project = build_benchmark_project(benchmark_specs()[1])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 15" {
  let project = build_benchmark_project(benchmark_specs()[2])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 16" {
  let project = build_benchmark_project(benchmark_specs()[3])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 17" {
  let project = build_benchmark_project(benchmark_specs()[0])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 18" {
  let project = build_benchmark_project(benchmark_specs()[1])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 19" {
  let project = build_benchmark_project(benchmark_specs()[2])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 20" {
  let project = build_benchmark_project(benchmark_specs()[3])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 21" {
  let project = build_benchmark_project(benchmark_specs()[0])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 22" {
  let project = build_benchmark_project(benchmark_specs()[1])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 23" {
  let project = build_benchmark_project(benchmark_specs()[2])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 24" {
  let project = build_benchmark_project(benchmark_specs()[3])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 25" {
  let project = build_benchmark_project(benchmark_specs()[0])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 26" {
  let project = build_benchmark_project(benchmark_specs()[1])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 27" {
  let project = build_benchmark_project(benchmark_specs()[2])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 28" {
  let project = build_benchmark_project(benchmark_specs()[3])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 29" {
  let project = build_benchmark_project(benchmark_specs()[0])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph order matrix 30" {
  let project = build_benchmark_project(benchmark_specs()[1])
  let order = task_order(project, Some("build"))
  assert_eq(order.length(), project.tasks.length())
  assert_eq(order[order.length() - 1], "build")
}

///|
test "graph level matrix 01" {
  let project = build_benchmark_project(benchmark_specs()[0])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 02" {
  let project = build_benchmark_project(benchmark_specs()[1])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 03" {
  let project = build_benchmark_project(benchmark_specs()[2])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 04" {
  let project = build_benchmark_project(benchmark_specs()[3])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 05" {
  let project = build_benchmark_project(benchmark_specs()[0])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 06" {
  let project = build_benchmark_project(benchmark_specs()[1])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 07" {
  let project = build_benchmark_project(benchmark_specs()[2])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 08" {
  let project = build_benchmark_project(benchmark_specs()[3])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 09" {
  let project = build_benchmark_project(benchmark_specs()[0])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 10" {
  let project = build_benchmark_project(benchmark_specs()[1])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 11" {
  let project = build_benchmark_project(benchmark_specs()[2])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 12" {
  let project = build_benchmark_project(benchmark_specs()[3])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 13" {
  let project = build_benchmark_project(benchmark_specs()[0])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 14" {
  let project = build_benchmark_project(benchmark_specs()[1])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 15" {
  let project = build_benchmark_project(benchmark_specs()[2])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 16" {
  let project = build_benchmark_project(benchmark_specs()[3])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 17" {
  let project = build_benchmark_project(benchmark_specs()[0])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 18" {
  let project = build_benchmark_project(benchmark_specs()[1])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 19" {
  let project = build_benchmark_project(benchmark_specs()[2])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 20" {
  let project = build_benchmark_project(benchmark_specs()[3])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 21" {
  let project = build_benchmark_project(benchmark_specs()[0])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 22" {
  let project = build_benchmark_project(benchmark_specs()[1])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 23" {
  let project = build_benchmark_project(benchmark_specs()[2])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 24" {
  let project = build_benchmark_project(benchmark_specs()[3])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 25" {
  let project = build_benchmark_project(benchmark_specs()[0])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 26" {
  let project = build_benchmark_project(benchmark_specs()[1])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 27" {
  let project = build_benchmark_project(benchmark_specs()[2])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 28" {
  let project = build_benchmark_project(benchmark_specs()[3])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 29" {
  let project = build_benchmark_project(benchmark_specs()[0])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "graph level matrix 30" {
  let project = build_benchmark_project(benchmark_specs()[1])
  let order = task_order(project, Some("build"))
  let levels = task_levels(project, order)
  assert_true(levels.length() >= 2)
  assert_eq(levels.flatten().length(), order.length())
}

///|
test "duplicate output matrix 01" {
  let project = matrix_project([
    matrix_task("task-0", [], ["dist/shared.txt"]),
    matrix_task("other-0", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 02" {
  let project = matrix_project([
    matrix_task("task-1", [], ["dist/shared.txt"]),
    matrix_task("other-1", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 03" {
  let project = matrix_project([
    matrix_task("task-2", [], ["dist/shared.txt"]),
    matrix_task("other-2", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 04" {
  let project = matrix_project([
    matrix_task("task-3", [], ["dist/shared.txt"]),
    matrix_task("other-3", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 05" {
  let project = matrix_project([
    matrix_task("task-4", [], ["dist/shared.txt"]),
    matrix_task("other-4", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 06" {
  let project = matrix_project([
    matrix_task("task-5", [], ["dist/shared.txt"]),
    matrix_task("other-5", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 07" {
  let project = matrix_project([
    matrix_task("task-6", [], ["dist/shared.txt"]),
    matrix_task("other-6", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 08" {
  let project = matrix_project([
    matrix_task("task-7", [], ["dist/shared.txt"]),
    matrix_task("other-7", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 09" {
  let project = matrix_project([
    matrix_task("task-8", [], ["dist/shared.txt"]),
    matrix_task("other-8", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 10" {
  let project = matrix_project([
    matrix_task("task-9", [], ["dist/shared.txt"]),
    matrix_task("other-9", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 11" {
  let project = matrix_project([
    matrix_task("task-10", [], ["dist/shared.txt"]),
    matrix_task("other-10", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 12" {
  let project = matrix_project([
    matrix_task("task-11", [], ["dist/shared.txt"]),
    matrix_task("other-11", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 13" {
  let project = matrix_project([
    matrix_task("task-12", [], ["dist/shared.txt"]),
    matrix_task("other-12", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 14" {
  let project = matrix_project([
    matrix_task("task-13", [], ["dist/shared.txt"]),
    matrix_task("other-13", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 15" {
  let project = matrix_project([
    matrix_task("task-14", [], ["dist/shared.txt"]),
    matrix_task("other-14", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 16" {
  let project = matrix_project([
    matrix_task("task-15", [], ["dist/shared.txt"]),
    matrix_task("other-15", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 17" {
  let project = matrix_project([
    matrix_task("task-16", [], ["dist/shared.txt"]),
    matrix_task("other-16", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 18" {
  let project = matrix_project([
    matrix_task("task-17", [], ["dist/shared.txt"]),
    matrix_task("other-17", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 19" {
  let project = matrix_project([
    matrix_task("task-18", [], ["dist/shared.txt"]),
    matrix_task("other-18", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 20" {
  let project = matrix_project([
    matrix_task("task-19", [], ["dist/shared.txt"]),
    matrix_task("other-19", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 21" {
  let project = matrix_project([
    matrix_task("task-20", [], ["dist/shared.txt"]),
    matrix_task("other-20", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 22" {
  let project = matrix_project([
    matrix_task("task-21", [], ["dist/shared.txt"]),
    matrix_task("other-21", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 23" {
  let project = matrix_project([
    matrix_task("task-22", [], ["dist/shared.txt"]),
    matrix_task("other-22", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 24" {
  let project = matrix_project([
    matrix_task("task-23", [], ["dist/shared.txt"]),
    matrix_task("other-23", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 25" {
  let project = matrix_project([
    matrix_task("task-24", [], ["dist/shared.txt"]),
    matrix_task("other-24", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 26" {
  let project = matrix_project([
    matrix_task("task-25", [], ["dist/shared.txt"]),
    matrix_task("other-25", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 27" {
  let project = matrix_project([
    matrix_task("task-26", [], ["dist/shared.txt"]),
    matrix_task("other-26", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 28" {
  let project = matrix_project([
    matrix_task("task-27", [], ["dist/shared.txt"]),
    matrix_task("other-27", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 29" {
  let project = matrix_project([
    matrix_task("task-28", [], ["dist/shared.txt"]),
    matrix_task("other-28", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "duplicate output matrix 30" {
  let project = matrix_project([
    matrix_task("task-29", [], ["dist/shared.txt"]),
    matrix_task("other-29", [], ["dist/shared.txt"]),
  ])
  assert_eq(duplicate_outputs(project).length(), 1)
}

///|
test "task classification matrix 01" {
  let task = matrix_task("task-0", [], [])
  assert_true(task.is_effectively_phony())
  assert_eq(reason_message(PlanReason::OutputMissing), "output missing")
}

///|
test "task classification matrix 02" {
  let task = matrix_task("task-1", [], [])
  assert_true(task.is_effectively_phony())
  assert_eq(reason_message(PlanReason::OutputMissing), "output missing")
}

///|
test "task classification matrix 03" {
  let task = matrix_task("task-2", [], [])
  assert_true(task.is_effectively_phony())
  assert_eq(reason_message(PlanReason::OutputMissing), "output missing")
}

///|
test "task classification matrix 04" {
  let task = matrix_task("task-3", [], [])
  assert_true(task.is_effectively_phony())
  assert_eq(reason_message(PlanReason::OutputMissing), "output missing")
}

///|
test "task classification matrix 05" {
  let task = matrix_task("task-4", [], [])
  assert_true(task.is_effectively_phony())
  assert_eq(reason_message(PlanReason::OutputMissing), "output missing")
}

///|
test "task classification matrix 06" {
  let task = matrix_task("task-5", [], [])
  assert_true(task.is_effectively_phony())
  assert_eq(reason_message(PlanReason::OutputMissing), "output missing")
}

///|
test "task classification matrix 07" {
  let task = matrix_task("task-6", [], [])
  assert_true(task.is_effectively_phony())
  assert_eq(reason_message(PlanReason::OutputMissing), "output missing")
}

///|
test "task classification matrix 08" {
  let task = matrix_task("task-7", [], [])
  assert_true(task.is_effectively_phony())
  assert_eq(reason_message(PlanReason::OutputMissing), "output missing")
}

///|
test "task classification matrix 09" {
  let task = matrix_task("task-8", [], [])
  assert_true(task.is_effectively_phony())
  assert_eq(reason_message(PlanReason::OutputMissing), "output missing")
}

///|
test "task classification matrix 10" {
  let task = matrix_task("task-9", [], [])
  assert_true(task.is_effectively_phony())
  assert_eq(reason_message(PlanReason::OutputMissing), "output missing")
}

///|
test "task classification matrix 11" {
  let task = matrix_task("task-10", [], [])
  assert_true(task.is_effectively_phony())
  assert_eq(reason_message(PlanReason::OutputMissing), "output missing")
}

///|
test "task classification matrix 12" {
  let task = matrix_task("task-11", [], [])
  assert_true(task.is_effectively_phony())
  assert_eq(reason_message(PlanReason::OutputMissing), "output missing")
}

///|
test "task classification matrix 13" {
  let task = matrix_task("task-12", [], [])
  assert_true(task.is_effectively_phony())
  assert_eq(reason_message(PlanReason::OutputMissing), "output missing")
}

///|
test "task classification matrix 14" {
  let task = matrix_task("task-13", [], [])
  assert_true(task.is_effectively_phony())
  assert_eq(reason_message(PlanReason::OutputMissing), "output missing")
}

///|
test "task classification matrix 15" {
  let task = matrix_task("task-14", [], [])
  assert_true(task.is_effectively_phony())
  assert_eq(reason_message(PlanReason::OutputMissing), "output missing")
}

///|
test "task classification matrix 16" {
  let task = matrix_task("task-15", [], [])
  assert_true(task.is_effectively_phony())
  assert_eq(reason_message(PlanReason::OutputMissing), "output missing")
}

///|
test "task classification matrix 17" {
  let task = matrix_task("task-16", [], [])
  assert_true(task.is_effectively_phony())
  assert_eq(reason_message(PlanReason::OutputMissing), "output missing")
}

///|
test "task classification matrix 18" {
  let task = matrix_task("task-17", [], [])
  assert_true(task.is_effectively_phony())
  assert_eq(reason_message(PlanReason::OutputMissing), "output missing")
}

///|
test "task classification matrix 19" {
  let task = matrix_task("task-18", [], [])
  assert_true(task.is_effectively_phony())
  assert_eq(reason_message(PlanReason::OutputMissing), "output missing")
}

///|
test "task classification matrix 20" {
  let task = matrix_task("task-19", [], [])
  assert_true(task.is_effectively_phony())
  assert_eq(reason_message(PlanReason::OutputMissing), "output missing")
}
