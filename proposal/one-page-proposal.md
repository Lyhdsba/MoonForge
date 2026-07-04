# MoonForge 项目申报书

项目名称：MoonForge

项目简介：
一个面向 MoonBit 项目和通用本地工程的声明式增量任务编排与小型构建工具，支持任务依赖、输入输出声明、增量跳过、失败阻断、执行原因解释和并行调度。

项目方向与适用场景：
面向工程基础设施与工具链方向，重点服务 MoonBit 项目开发、文档流水线、代码生成、资源处理和本地 CI 复现，属于可复用、可持续扩展的成熟工具类选题。

拟实现的核心功能：
1. `Moonforge.toml` 配置解析与任务模型
2. DAG 建图、缺失依赖检查与环检测
3. 基于命令、输入、输出与依赖状态的增量判断
4. 本地缓存 `.moonforge/cache.json`
5. `run/list/graph/explain/clean/doctor` CLI
6. 按依赖层级进行并行批量调度，并支持 `-j N`

项目性质：
原创项目。项目设计参考 ninja / just 一类工具思想，但配置格式、实现边界与 MoonBit 生态适配均为独立设计，不是已有项目的直接移植。

当前交付与评审价值：
已完成项目骨架、核心模块、CLI、示例配置、设计文档与测试样例，仓库可公开持续迭代；项目方向与 MoonBit OSC2026 官方建议中的“构建工具，类似 n2 / ninja”一致。

仓库链接：
- GitHub: https://github.com/Lyhdsba/MoonForge
- GitLink: https://gitlink.org.cn/Lyhdsba/MoonForge

后续计划：
7 月上旬继续补足真实 demo、更多校验规则、使用文档与提交记录，完善到可直接用于 MoonBit 工程自动化的首版工具。
