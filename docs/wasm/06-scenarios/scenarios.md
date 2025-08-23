---
id: scenarios-overview
title: 第 6 章 应用场景与模式
sidebar_label: 本章导读
sidebar_position: 1
---

目标：了解 WASM 在真实系统中的用法与优势。

## 快速跳转
完整运行指南与依赖矩阵见：`examples/README.md`（总览导航 + 工具链准备 + FAQ）。

## 6.1 浏览器中的应用
Web Workers、游戏引擎、重计算任务、离线能力。

示例：`examples/ch06/browser/`（最小纯前端加载 .wasm 并调用函数）
提示：使用静态服务打开 `index.html`，需先将 `add.wat` 转为 `add.wasm`（可用 `wasm-tools parse`）。

## 6.2 边缘计算 & Serverless
冷启动、隔离性、跨平台统一。

示例：`examples/ch06/http_server_node/`（Node 原生 HTTP 服务在路由中调用 Wasm）
提示：先将 `wasm/add.wat` 转为 `wasm/add.wasm`，再运行 `node server.mjs`，访问 `/add?a=1&b=2`。

扩展示例（WASI HTTP）：`examples/ch06/wasi_http_spin/`（基于 Fermyon Spin）
提示：`spin build && spin up` 后访问 `http://127.0.0.1:3000/` 与 `/add?a=1&b=2`。

## 6.3 区块链智能合约
Substrate/Polkadot、CosmWasm、NEAR 等。

## 6.4 插件系统案例
Envoy、Postgres、WasmCloud。

示例：`examples/ch06/plugin_host/`（Node 宿主加载 `plugins/*.wasm` 并调用导出）

扩展示例（组件模型 + HTTP 宿主）：`examples/ch06/component_http_host/`
说明：将业务逻辑封装为组件（WIT/世界：demo:add/add-world），由 Rust HTTP 宿主（Wasmtime 组件 API）在请求路由中进行调用。

## 6.5 AI/ML 推理
WasmEdge 等运行时中的推理示例（后续补充 demo）。

---

小结：场景选择决定运行时与接口选择。

---

更多内容：
- 浏览器与 Node 宿主 → ./browser-and-node
- HTTP 与组件化服务 → ./http-and-components