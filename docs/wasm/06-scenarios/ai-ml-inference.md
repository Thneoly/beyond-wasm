---
id: scenarios-ai-ml
title: AI/ML 推理
sidebar_label: AI/ML 推理
sidebar_position: 5
---

# AI/ML 推理

在边缘与浏览器侧，WASM 提供良好隔离与可移植性。结合 SIMD/threads/异步 I/O，可覆盖轻量推理与前后处理。

## 运行时选择
- WasmEdge：面向 AI/ML 的优化，支持部分 NN 接口；
- Wasmtime：通用运行时，SIMD/threads 逐步完善；
- 浏览器：WebAssembly SIMD/Threads，需 COOP/COEP 与 SharedArrayBuffer。

## 模型与算子
- 体积：模型与算子按需裁剪，采用分块/流式加载；
- 精度：量化（int8/FP16）与蒸馏权衡；
- 格式：ONNX/WASM 原生算子/第三方库绑定。

## 性能实践
- 预热：首次加载后进行一次空跑，填充 JIT/缓存；
- 并发：采用实例池与任务队列，避免过多实例抢占；
- 亲和：将算力任务与 I/O 分离，降低抖动；
- 观测：记录 P50/P90/P99、内存峰值与队列时延。

> 示例待补充：计划提供最小图片预处理 + 简单模型推理的组件化示例。
