# MoonForge

MoonForge is a MoonBit-native incremental task runner for small builds, code
generation pipelines, document workflows, asset preparation, and reproducible
local CI commands.

## 项目定位

MoonForge 面向 MoonBit 项目和通用本地工程，提供一个轻量、可解释、可扩展
的声明式任务编排工具。它重点解决四类常见问题：

- 把零散脚本收拢到统一配置文件中
- 显式声明任务依赖、输入、输出和执行命令
- 根据输入变化、输出缺失和依赖状态做增量判断
- 在失败时及时阻断下游，方便本地复现和排查

这个方向对应 MoonBit OSC2026 官方推荐的工程基础设施与工具链赛道，
也适合继续扩展到代码生成、文档流水线、资源构建和本地 CI 复现。

## 当前能力

- 声明式配置文件 `Moonforge.toml`
- 任务 DAG 建图、环检测、缺失依赖检查
- 基于命令、输入、输出和依赖状态的增量执行
- 本地缓存目录 `.moonforge/cache.json`
- `run`、`list`、`graph`、`explain`、`clean`、`doctor` CLI
- 按依赖层级分批并行调度，支持 `-j N`

## 快速开始

```bash
moon check
moon run --target native cmd/main -- list
moon run --target native cmd/main -- graph build
moon run --target native cmd/main -- explain build
moon run --target native cmd/main -- run build
```

仓库内置了一个 `Moonforge.toml` 示例，覆盖文档转换、资源复制和聚合伪任务等
典型场景。

## 配置格式

顶层使用 `tasks` 表。每个任务支持以下字段：

- `cmd`: 要执行的命令
- `deps`: 依赖任务名列表
- `inputs`: 输入文件或目录列表
- `outputs`: 输出文件列表
- `phony`: 是否为伪任务
- `desc`: 任务描述

示例：

```toml
[tasks.bundle]
cmd = 'python -c "print(\"bundle\")"'
deps = ["generate"]
inputs = ["src/schema.json"]
outputs = ["dist/bundle.txt"]
phony = false
desc = "Build the bundle"
```

如果任务没有声明输出，MoonForge 会把它当作“等效伪任务”处理。

## CLI

```text
moonforge list [--file PATH]
moonforge graph [TASK] [--file PATH]
moonforge explain [TASK] [--file PATH]
moonforge clean [--file PATH]
moonforge doctor [--file PATH]
moonforge run [TASK] [--file PATH] [-j N]
```

如果没有显式指定目标任务，MoonForge 会按 `build`、`default`、字母序第一个任务
的优先级选择默认入口。

## 示例场景

- 文档流水线：Markdown 转 HTML 或预览产物
- 代码生成：schema 输入、生成代码、再触发测试
- 资源处理：复制、整理、分发静态资源
- 本地 CI：统一执行 `fmt`、`check`、`test`、构建步骤

## 设计边界

- 当前执行后端以 `native` 为主，因为命令执行依赖 `trkbt10/subprocess`
- v1 并行模型采用按依赖层级分批调度，优先保证稳定和可解释
- 当前不包含远程缓存、分布式执行、沙箱隔离和自定义 DSL

## 仓库与文档

- GitHub: <https://github.com/Lyhdsba/MoonForge>
- GitLink: <https://gitlink.org.cn/Lyhdsba/MoonForge>
- Mooncakes: <https://mooncakes.io/docs/Lyhdsba/moonforge>
- 申报 PDF: `output/pdf/MoonForge-OSC2026-Proposal.pdf`
- 设计说明: `docs/design.md`
- 结项自检: `docs/acceptance-checklist.md`

## 结项自检

仓库提供了结项检查脚本：

```powershell
powershell -ExecutionPolicy Bypass -File scripts\verify_acceptance.ps1
```

脚本会检查 README 文件形态、仓库材料完整性、提交数、一页 PDF、模块身份一致
性，以及在具备本地 C 编译器时补跑 `moon test` 和 CLI 烟雾验证。
