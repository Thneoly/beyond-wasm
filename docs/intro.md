---
sidebar_position: 1
---

# 项目简介与快速开始

> 立即开始阅读《Beyond the Browser: WebAssembly 全景解析》：
>
> - 书籍入口：侧边栏 “Docs” → “Book”，或访问稳定路径 `/docs/book`
> - 每章配套可运行示例位于 [examples/](https://github.com/Thneoly/beyond-wasm/tree/main/examples) 目录
> - 运行指南与依赖矩阵：见 [examples/README.md](https://github.com/Thneoly/beyond-wasm/blob/main/examples/README.md)

## 使用 Yarn（统一）

本仓库采用 Yarn。请使用 Node.js 20 或更高版本。

```bash
# 安装依赖
yarn

# 本地开发（http://localhost:3000）
yarn start

# 构建静态站点（产物在 build/）
yarn build

# 本地预览已构建站点
yarn serve
```

## 环境依赖（示例相关）

- wasm-tools（.wat↔.wasm、strip/component 等）
- Wasmtime（运行核心 WASM/WASI/组件）
- Rust toolchain + wasm32-wasi（构建 Rust 示例/组件）
- Binaryen（可选，`wasm-opt -Oz` 体积优化）

详细准备、常见问题与一键脚本见 [examples/README.md](https://github.com/Thneoly/beyond-wasm/blob/main/examples/README.md)。

## 推荐路径

- 先阅读 `/docs/book` 的“基础 → 运行时/工具链 → WASI → 组件模型”。
- 先跑 [examples/ch06](https://github.com/Thneoly/beyond-wasm/tree/main/examples/ch06)（浏览器/Node/插件式宿主）与 [examples/ch07](https://github.com/Thneoly/beyond-wasm/tree/main/examples/ch07)（体积优化与预编译对比）建立直观感受。
