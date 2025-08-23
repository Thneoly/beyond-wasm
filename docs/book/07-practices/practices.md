---
id: practices-overview
title: 第 7 章 实践与示例
sidebar_label: 本章导读
sidebar_position: 1
---

目标：通过一组递进式示例完成从入门到实战。

建议实践路径（与 examples/ 对应）：

- 接口与版本：用 WIT/world 设计与演进（第 5 章/第 6 章示例回顾）
- 安全与权限：WASI 能力最小化（以 Spin/Wasmtime 为例）
- 性能与体积：优化与对比（见 7.3、7.4）
- 观测与调试：日志/指标/追踪（Host 侧埋点）
- 测试与 CI：可重复构建与基线回归

本章新增两个“上手即用”的优化示例：

- size-opt：体积优化对比（-O/-Oz/strip/wasm-opt），并生成对比报告
- precompile-wasmtime：对比“直接运行 vs wasmtime compile 预编译后运行”的启动耗时

> 快速跳转：完整的运行指南与依赖矩阵见 `examples/README.md`（总览导航 + 工具链准备 + FAQ）。

---

小结：通过实操形成“运行时 + 能力 + 组件”的系统性理解。

更多内容：
- 性能与体积 → ./perf-and-size