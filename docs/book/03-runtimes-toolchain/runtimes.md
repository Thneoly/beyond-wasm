---
id: runtimes-runtime-overview
title: 运行时全览
sidebar_label: 运行时全览
sidebar_position: 2
---

# 运行时全览

- 浏览器、Wasmtime、WasmEdge、Node 的能力对比
- 组件模型支持状况与兼容性
- 嵌入式/Serverless 等场景选择建议

## 对比轴（示意）

```mermaid
flowchart LR
	Start([运行时选择]) --> A[组件模型支持]
	A --> B[WASI 能力]
	B --> C["启动/内存开销"]
	C --> D[嵌入 API 友好度]
	D --> E[生态与工具]
```
