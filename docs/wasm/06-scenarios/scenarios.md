---
id: scenarios-overview
title: 第 6 章 应用场景与模式
sidebar_label: 本章导读
sidebar_position: 1
---

目标：了解 WASM 在真实系统中的用法与优势。

## 快速跳转
完整运行指南与依赖矩阵见：[examples/README.md](https://github.com/Thneoly/beyond-wasm/blob/main/examples/README.md)（总览导航 + 工具链准备 + FAQ）。

## 6.1 浏览器中的应用
Web Workers、游戏引擎、重计算任务、离线能力。

示例：[examples/ch06/browser/](https://github.com/Thneoly/beyond-wasm/tree/main/examples/ch06/browser)（最小纯前端加载 .wasm 并调用函数）
提示：使用静态服务打开 `index.html`，需先将 `add.wat` 转为 `add.wasm`（可用 `wasm-tools parse`）。

注意：
- 资源路径：构建产出后 .wasm 路径需与静态文件同源；
- 线程：部分浏览器特性（如 SharedArrayBuffer）需 COOP/COEP 头；
- 调试：DevTools 可查看 WebAssembly 调试信息（需保留 name 段）。

## 6.2 边缘计算 & Serverless
冷启动、隔离性、跨平台统一。

示例：[examples/ch06/http_server_node/](https://github.com/Thneoly/beyond-wasm/tree/main/examples/ch06/http_server_node)（Node 原生 HTTP 服务在路由中调用 Wasm）
提示：先将 `wasm/add.wat` 转为 `wasm/add.wasm`，再运行 `node server.mjs`，访问 `/add?a=1&b=2`。

扩展示例（WASI HTTP）：[examples/ch06/wasi_http_spin/](https://github.com/Thneoly/beyond-wasm/tree/main/examples/ch06/wasi_http_spin)（基于 Fermyon Spin）
提示：`spin build && spin up` 后访问 `http://127.0.0.1:3000/` 与 `/add?a=1&b=2`。

注意：
- 权限：Spin 的组件权限在 `spin.toml` 中声明，遵循能力最小化；
- 热更新：本地开发 `spin watch` 可快速迭代，但注意冷启动差异；
- 观测：利用日志与请求指标评估并发下的延迟分布。

## 6.3 区块链智能合约
Substrate/Polkadot、CosmWasm、NEAR 等。

## 6.4 插件系统案例
Envoy、Postgres、WasmCloud。

示例：[examples/ch06/plugin_host/](https://github.com/Thneoly/beyond-wasm/tree/main/examples/ch06/plugin_host)（Node 宿主加载 `plugins/*.wasm` 并调用导出）

扩展示例（组件模型 + HTTP 宿主）：[examples/ch06/component_http_host/](https://github.com/Thneoly/beyond-wasm/tree/main/examples/ch06/component_http_host)
说明：将业务逻辑封装为组件（WIT/世界：demo:add/add-world），由 Rust HTTP 宿主（Wasmtime 组件 API）在请求路由中进行调用。

注意：
- 实例池：为热点路由维持 warm 实例，降低冷启动；
- 超时/重试：对下游组件设定限时与熔断，避免级联拥塞；
- 观测：对每个组件导出/错误码建立指标标签，方便排错。

## 6.5 AI/ML 推理
WasmEdge 等运行时中的推理示例（后续补充 demo）。

提示：
- 算子支持：关注运行时对 SIMD/threads 的支持矩阵；
- 体积：尽量裁剪依赖，拆分模型与算子；
- I/O：用 streaming/分批处理避免内存峰值过高。

---

小结：场景选择决定运行时与接口选择。

---

更多内容：
- 浏览器与 Node 宿主 → ./browser-and-node
- HTTP 与组件化服务 → ./http-and-components
- 区块链智能合约 → ./blockchain-smart-contracts
- AI/ML 推理 → ./ai-ml-inference