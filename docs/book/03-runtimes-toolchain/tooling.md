---
sidebar_position: 2
---

# 工具链与开发流程

- rustup 目标、cargo-component、wasm-tools、wit-bindgen
- 典型流程：源码 → wasm → 组件化 → 组合/运行
- 示例：见 `examples/ch03` 与 `examples/ch05`

## 开发流水线（示意）

```mermaid
flowchart LR
	Source[源代码] --> Build[编译为 .wasm]
	Build --> Component[组件化 (component new)]
	Component --> Compose[组合 (component compose)]
	Compose --> Host[宿主运行 (Wasmtime/Node/Spin)]
```

常用命令片段：

```bash
rustup target add wasm32-wasi
cargo build --release --target wasm32-wasi
wasm-tools component new a.wasm -o a.component.wasm
wasm-tools component wit a.component.wasm
```
