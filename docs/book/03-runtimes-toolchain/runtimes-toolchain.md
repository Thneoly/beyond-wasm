---
id: runtimes-overview
title: 第 3 章 运行时与工具链
sidebar_label: 本章导读
sidebar_position: 1
---

目标：了解主流运行时差异、常用编译工具链与调试工具；完成“Rust 生成 WASM + Wasmtime 执行”。

> 快速跳转：完整的运行指南与依赖矩阵见 `examples/README.md`（总览导航 + 工具链准备 + FAQ）。

## 模块导览（本章深入）

- 运行时全览 → ./runtimes
- 工具链与开发流程 → ./tooling

## 3.1 运行时对比

- Wasmtime（Bytecode Alliance）：标准推进者，组件模型支持积极。
- Wasmer：多语言嵌入、商业化场景较多。
- WasmEdge：云原生/边缘计算场景优化。
- WAMR（Intel）：超低资源场景。

对比维度：启动时延、内存占用、WASI/组件模型支持、嵌入 API、生态工具。

## 3.2 工具链

- LLVM/Emscripten：C/C++ 到 WASM。
- Rust：`wasm32-unknown-unknown`、`wasm32-wasi` 等 target。
- wasm-tools：`parse` / `print` / `validate` / `component`。

## 3.3 调试工具实践

- `wasmtime inspect` / `wasm-tools objdump` / `wasm-objdump` 等。

## 3.4 示例：Rust 生成 WASM + Wasmtime 执行

参见 `examples/ch03/rust_wasm_wasmtime/`：

```bash
# 安装目标
rustup target add wasm32-wasi

# 构建 WASM
cd examples/ch03/rust_wasm_wasmtime
cargo build --release --target wasm32-wasi

# 通过 Wasmtime 调用导出函数
wasmtime target/wasm32-wasi/release/rust_wasm_wasmtime.wasm --invoke add 1 2
# 期望输出：3
```

---

小结：选择运行时与工具链时，需要结合部署环境与能力需求。下一章进入 WASI。

---

更多内容：
- 运行时全览 → ./runtimes
- 工具链与开发流程 → ./tooling