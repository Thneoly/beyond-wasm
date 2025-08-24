---
id: outlook-standards
title: 标准与提案追踪
sidebar_label: 标准与提案
sidebar_position: 3
---

# 标准与提案追踪

面向未来 12–24 个月的标准化关注点与落地影响梳理。

## Core Wasm 提案（部分）
- Threads / Atomics：多线程并行能力逐步成熟，浏览器与原生运行时采纳推进；
- SIMD：在主流运行时已较为稳定，适合数值与多媒体处理；
- Memory64：为大内存应用铺路，注意与宿主 ABI 的兼容性；
- GC / Typed Functions：利于高层语言（如 GC 语言）高效落地；
- Tail Calls / Exception Handling：优化高阶函数/语言特性与异常模型。

## 组件模型（Component Model）
- 里程碑：WIT/World 工具链成熟、语言绑定增强、Host API 稳定化；
- 影响：跨语言互操作门槛下降，函数/库级复用成为主流交付单元；
- 建议：新项目优先以 WIT 设计契约，面向组件交付与组合。

## WASI 能力族
- Preview 2 路线：能力最小化、按接口族拆分（cli/fs/clocks/http 等）；
- 网络与 HTTP：wasi:http/相关能力加速推进，服务型工作负载更易落地；
- 密钥/加密/AI：wasi:crypto、wasi:nn 等领域接口持续演进。

## 工具链与运行时
- 运行时：Wasmtime、WasmEdge、Wasmer 等持续跟进新提案；
- 工具：`wasm-tools`、`wit-bindgen`、`cargo-component` 等功能完善；
- 建议：在 CI 固定工具版本，逐步验证新提案以降低升级风险。
