---
title: 第 1 章 引言：为什么是 WebAssembly
slug: /book/01-intro
---

本章目标：回答「为什么要学习 WASM」，给出清晰的背景、能力边界与应用全景。

> 快速跳转：完整的运行指南与依赖矩阵见 `examples/README.md`（总览导航 + 工具链准备 + FAQ）。

## 1.1 什么是 WebAssembly（WASM）

WebAssembly 是一种可移植、紧凑的字节码格式和安全的执行模型，最初为浏览器而生，现已扩展到服务器、边缘、桌面与区块链等多种环境。

- 关键特性：
	- 近原生的执行性能（Ahead-of-Time/Just-in-Time 编译）
	- 可移植性与确定性（跨 CPU/OS 的稳定语义）
	- 安全沙箱（受限能力、内存隔离）
	- 语言多样性（Rust、C/C++、Go、AssemblyScript 等均可编译为 WASM）

> 参考：W3C WebAssembly 规范、Bytecode Alliance 文档。

## 1.2 简史与标准化进程

- 2015-2017：最初在浏览器中落地，成为四大浏览器共同支持的标准。
- 2019-2022：WASI（WebAssembly System Interface）提出，探索脱离浏览器的系统接口。
- 2022-至今：组件模型（Component Model）与 preview2 能力模型推进，生态加速。

更多时间线与标准化细节，见第 8 章展望与生态。

## 1.3 与传统虚拟机（JVM、CLR）的对比

- 定位不同：WASM 追求可验证的小而简的安全执行核心；JVM/CLR 是更重的运行时平台与标准库集合。
- 语言绑定：WASM 偏向多语言编译目标；JVM/CLR 以字节码生态为中心（Java/C#）。
- 沙箱与能力：WASM 默认沙箱 + 显式能力授予；JVM/CLR 依赖安全管理器/权限模型（现代用法减少）。
- 启动与资源占用：WASM 冷启动更快、内存足迹更小，适合边缘与 Serverless。

## 1.4 应用场景全览

- 浏览器：游戏、图像/视频处理、CAD、数据可视化、离线/本地推理。
- Serverless/边缘：冷启动快，天然隔离，跨平台部署一致。
- 区块链：作为智能合约执行引擎（Polkadot、Cosmos、NEAR 等）。
- 插件系统：Envoy、Postgres、WasmCloud 等以 WASM 作为安全插件沙箱。
- AI/ML：在 WasmEdge、WAMR 等运行时中进行本地/边缘推理。

配图建议：WASM 在不同生态中的定位图（TODO）。

## 1.5 生态全景与本书结构

本书结构参见本目录左侧导航或下列章节：

1) 基础概念（第 2 章）  2) 运行时与工具链（第 3 章）  3) WASI（第 4 章）
4) 组件模型（第 5 章）  5) 应用场景（第 6 章）  6) 实践示例（第 7 章）  7) 展望（第 8 章）

与 examples/ 目录联动，所有示例可运行。建议从最小 .wat 示例开始：`examples/ch02/min.wat`（见第 2 章）。

---

小结：WASM 正从“浏览器加速器”走向“通用、安全、可移植的执行层”。接下来在第 2 章我们从字节码与执行模型出发，夯实基础。
