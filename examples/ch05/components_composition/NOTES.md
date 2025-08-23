# 组件组合说明与后续路线

当前 `componentize-ch03.sh` 与 `compose-add-inc.sh` 展示了：
- 如何将“Core WASM（无 I/O）”组件化；
- 如何用 `wasm-tools component compose` 将两个组件合并（仅做导入/导出连线）。

要实现“统一接口 + 真正可组合的世界（world）”，需让两个组件遵循一套 WIT 接口/世界定义。这通常通过以下路径完成：

1. 先定义 WIT（见 `wit/add.wit`、`wit/inc.wit` 与 `wit/glue.wit`）。
2. 用支持 WIT 绑定的工具链生成组件（例如 `cargo-component` 或相关绑定工具）。
3. 确保两个组件都导出/导入同一 world 下的接口（接口名与签名一致）。
4. 使用 `wasm-tools component compose` 进行组合，或编写一个“胶水组件”将 `add` 与 `inc` 组合为 `add_then_inc` 并导出。

注意：本仓库内的 `add`/`inc` 组件由裸 `cdylib` 转换而来，导出与 WIT 未严格对齐，因而组合后仅用于结构演示与 WIT 检视；如需通过运行器直接调用组件导出，请改为按统一 WIT 生成组件。
