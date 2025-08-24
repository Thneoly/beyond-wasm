---
id: component-bindings-and-tools
title: 绑定与工具链
sidebar_label: 绑定与工具链
sidebar_position: 4
---

# 绑定与工具链

目标：了解跨语言绑定的生成方式与常用工具。

## 常用工具
- wit-bindgen：多语言绑定生成器（Rust/TS/…）。
- cargo component：Rust 组件项目脚手架与构建。
- wasm-tools：查看/封装/组合组件（`component new/compose/wit`）。

## 典型流程
1) 用 WIT 定义接口与 world；
2) 通过语言工具生成绑定（或手写实现）；
3) 构建 core wasm → `wasm-tools component new` 封装为 component；
4) `wasm-tools component wit` 验证导入导出；
5) 在宿主（如 Wasmtime 组件 API）加载并调用。

示例：
- 组件化与组合：[examples/ch05/components_composition](https://github.com/Thneoly/beyond-wasm/tree/main/examples/ch05/components_composition)
- HTTP 宿主调用组件：[examples/ch06/component_http_host](https://github.com/Thneoly/beyond-wasm/tree/main/examples/ch06/component_http_host)

## 注意事项
- 字符串/字节的所有权与拷贝次数；
- 大对象优先使用 record/扁平结构；
- 错误统一用 `result<T,E>` 或具名 `variant`；
- 在 CI 固定工具版本，避免升级引入不兼容。

## 命令与示例输出

构建与封装：

```bash
cargo build -Zunstable-options --target wasm32-wasi --release
wasm-tools component new \
	target/wasm32-wasi/release/my-demo.wasm \
	-o target/my-demo.component.wasm
```

查看组件 WIT：

```bash
wasm-tools component wit target/my-demo.component.wasm
# 可能输出（节选）：
# package demo:math
# world app {
#   export demo:math/algebra@0.1.0;
# }
```

组合两个组件：

```bash
wasm-tools component compose \
	--adapt some-adapter.wasm \
	add.component.wasm inc.component.wasm \
	-o glue.component.wasm
```
