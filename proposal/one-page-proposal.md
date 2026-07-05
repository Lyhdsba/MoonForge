# MoonForge 项目申报书

项目名称：MoonForge

项目简介：  
MoonForge 是一个面向 MoonBit 项目和通用本地工程的声明式增量任务编排与小型构建工具，支持任务依赖、输入输出声明、增量跳过、失败阻断、执行原因解释和并行调度。

项目方向与适用场景：  
项目属于工程基础设施与工具链方向，重点服务 MoonBit 项目开发、文档流水线、代码生成、静态资源处理和本地 CI 复现，具有明确的真实使用场景和持续扩展空间。

拟实现的核心功能：  
1. `Moonforge.toml` 配置解析与任务模型  
2. 任务 DAG 建图、缺失依赖检查与环检测  
3. 基于命令、输入、输出与依赖状态的增量判断  
4. 本地缓存 `.moonforge/cache.json`  
5. `run / list / graph / explain / clean / doctor` CLI  
6. 按依赖层级进行并行批量调度，并支持 `-j N`

项目性质：  
原创项目。项目实现参考了成熟构建工具的设计思想，但配置格式、能力边界和 MoonBit 生态适配均为独立设计，并非现有项目的直接移植。

当前交付与评审价值：  
已完成项目骨架、核心模块、CLI、示例配置、设计文档、测试样例和公开仓库初始化；项目方向与 MoonBit OSC2026 官方推荐的“构建工具，类似 n2 / ninja”一致，具备明确生态贡献价值。

仓库链接：  
- GitHub: https://github.com/Lyhdsba/MoonForge  
- GitLink: https://gitlink.org.cn/Lyhdsba/MoonForge

后续计划：  
围绕公开仓库继续补充真实 demo、更多校验规则、文档、示例与阶段性提交记录，完善成可直接服务 MoonBit 工程自动化的一版实用工具。
