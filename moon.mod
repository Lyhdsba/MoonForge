// Learn more about moon.mod configuration:
// https://docs.moonbitlang.com/en/latest/toolchain/moon/module.html
//
// To add a dependency, run this command in your terminal:
//   moon add moonbitlang/x
//
// Or manually declare it in `import`, for example:
// import {
//   "moonbitlang/x@0.4.6",
// }

name = "Lyhdsba/moonforge"

version = "0.1.1"

readme = "README.md"

repository = "https://github.com/Lyhdsba/MoonForge"

license = "Apache-2.0"

keywords = [ "moonbit", "build-tool", "task-runner", "incremental-build" ]

description = "A MoonBit-native incremental task runner for small builds, codegen workflows, and local CI orchestration."

preferred_target = "native"

import {
  "moonbitlang/async@0.16.8",
  "moonbitlang/x@0.4.46",
  "bobzhang/toml@0.4.1",
  "trkbt10/subprocess@0.2.0",
}
