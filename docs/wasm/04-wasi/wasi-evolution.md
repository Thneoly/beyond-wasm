---
id: wasi-evolution-merged
title: WASI 0.1 → 0.2 的演进（已合并）
sidebar_position: 4
draft: true
---

本页内容已合并至：`wasm/04-wasi/wasi.md` 的 4.2/4.3/4.4 节。

概述 preview1 到 preview2 的接口变化、能力建模与生态影响：

- 去除 POSIX 映射的强绑定，采用接口家族与 capability-based 设计
- I/O、时钟、文件系统、HTTP 等分解为可组合的包
- 组件模型下的稳态 ABI 与跨语言互操作
