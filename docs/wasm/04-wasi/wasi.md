---
id: wasi-overview
title: 第 4 章 WASI（System Interface）
sidebar_label: 本章导读
sidebar_position: 1
---

目标：理解 WASI 的目标、preview1 局限与 preview2 的能力模型，并通过示例访问文件与时间。

> 快速跳转：完整的运行指南与依赖矩阵见 [examples/README.md](https://github.com/Thneoly/beyond-wasm/blob/main/examples/README.md)（总览导航 + 工具链准备 + FAQ）。

## 4.1 目标与愿景

为浏览器外的 WASM 提供标准化系统接口，强调能力受限与可移植性。

## 4.2 preview1 的设计与局限

以 POSIX-ish 接口为主，命名空间割裂、能力粒度较粗、可组合性不足。

## 4.3 preview2 的能力模型

能力导向（capability-based）、接口类型统一、面向组件模型友好。
示例能力：
- 文件系统：以“预打开目录”授予相对路径访问权；
- 时钟：授予高精度/壁钟时间访问；
- HTTP/网络：通过专用接口族授予（如 WASI HTTP）。

## 4.4 0.1 → 0.2 的演进

接口整合、语义强化、跨运行时一致性提升。

## 4.5 示例：文件与时间
参见 [examples/ch04/wasi_fs_time/](https://github.com/Thneoly/beyond-wasm/tree/main/examples/ch04/wasi_fs_time)：

```bash
rustup target add wasm32-wasi
cd examples/ch04/wasi_fs_time
cargo build --release --target wasm32-wasi

# 预打开当前目录，读取 sample.txt 并打印当前时间
wasmtime --dir=. target/wasm32-wasi/release/wasi_fs_time.wasm sample.txt
```

扩展：
- HTTP：基于 WASI HTTP/组件模型实现请求处理，见第 6 章 HTTP 场景。
- 时钟：不同运行时对精度/权限策略可能不同，注意错误处理与降级策略。

---

小结：WASI 为 WASM 赋予受控 I/O 能力，是浏览器外运行的关键基础。

---

更多内容：
- 能力模型与权限授予 → ./capability-model
- I/O 与时钟 → ./io-and-clocks