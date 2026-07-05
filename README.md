# MoonForge

MoonForge is a MoonBit-native incremental task runner for small builds, code
generation pipelines, document workflows, asset preparation, and reproducible
local CI commands.

## 项目定位

MoonForge 面向 MoonBit 项目和通用本地工程，提供一个简单、可解释、可扩展的声明式任务编排工具。
它重点解决以下问题：

- 把散落在脚本里的构建步骤收敛到统一配置文件
- 为每个任务明确声明依赖、输入、输出和执行命令
- 根据输入变化、输出缺失和依赖状态决定是否重跑
- 在失败时及时阻断下游，便于本地复现和排查

这个方向与 MoonBit OSC2026 官方推荐的“工程基础设施与工具链”“构建工具，类似 n2 / ninja”一致。

## 当前能力

- 声明式配置文件 `Moonforge.toml`
- 任务 DAG 建图、环检测和缺失依赖检查
- 基于命令、输入、输出与依赖状态的增量判断
- 本地缓存 `.moonforge/cache.json`
- `run`、`list`、`graph`、`explain`、`clean`、`doctor` CLI
- 按依赖层级进行并行批量调度，支持 `-j N`

## 快速上手

```bash
moon check
moon run --target native cmd/main -- list
moon run --target native cmd/main -- graph build
moon run --target native cmd/main -- explain build
moon run --target native cmd/main -- run build
```

仓库内置了一个示例 `Moonforge.toml`，覆盖了文档转换、资源复制和伪任务聚合三个常见场景。

## 配置格式

顶层配置为单个 `[tasks]` 表，每个任务支持：

- `cmd`: 执行命令
- `deps`: 依赖任务名列表
- `inputs`: 输入文件或目录列表
- `outputs`: 输出文件或目录列表
- `phony`: 是否为伪任务
- `desc`: 任务说明

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

如果任务没有声明输出，则会被视为“等效伪任务”。

## 命令行

```text
moonforge list [--file PATH]
moonforge graph [TASK] [--file PATH]
moonforge explain [TASK] [--file PATH]
moonforge clean [--file PATH]
moonforge doctor [--file PATH]
moonforge run [TASK] [--file PATH] [-j N]
```

如果没有显式指定目标任务，MoonForge 会按 `build`、`default`、字母序第一个任务的优先级选择默认入口。

## 示例场景

- 文档流水线：Markdown 转 HTML 或预览产物
- 代码生成：schema 输入、生成代码、再触发测试
- 资源处理：复制、整理、分发静态资源
- 本地 CI：统一执行 `fmt`、`check`、`test`、构建步骤

## 当前边界

- 当前执行后端以 `native` 为主，因为命令执行依赖 `trkbt10/subprocess`
- v1 并行模型采用“按依赖层级分批调度”，强调行为稳定和可解释性
- 尚未实现远程缓存、分布式执行、沙箱隔离和自定义 DSL

## 仓库说明

- GitHub: <https://github.com/Lyhdsba/MoonForge>
- GitLink: <https://gitlink.org.cn/Lyhdsba/MoonForge>
- 一页申报书 PDF: `output/pdf/MoonForge-OSC2026-Proposal.pdf`

## 复审自检

仓库内提供了一个自检脚本：

```powershell
powershell -ExecutionPolicy Bypass -File scripts\verify_acceptance.ps1
```

该脚本会检查 README 文件形态、提交数、一页 PDF 是否存在且页数正确，以及材料中是否存在明显乱码。
