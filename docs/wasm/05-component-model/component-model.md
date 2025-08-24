---
id: component-model-overview
title: 第 5 章 组件模型与未来标准
sidebar_label: 本章导读
sidebar_position: 1
---

目标：理解组件模型的动机、接口类型与绑定，并演示模块组合为组件。

> 快速跳转：完整的运行指南与依赖矩阵见 [examples/README.md](https://github.com/Thneoly/beyond-wasm/blob/main/examples/README.md)（总览导航 + 工具链准备 + FAQ）。

## 5.1 动机与目标

多语言互操作、模块组合、封装能力与版本化。

- 解耦语言与运行时：以 WIT 契约定义边界，任何语言可实现/消费；
- 稳定链接（Stable ABI）：避免各语言各自的 FFI 差异；
- 组合与替换：以 world 维度组织能力，便于 A/B 与灰度；
- 版本演进与兼容：新增字段/接口不破坏既有消费者。

## 5.2 接口类型与 bindings

接口类型（Interface Types）解决跨语言的类型传递；bindings 自动生成 glue code。

典型工作流：
- 用 WIT 描述接口/世界（records、variants、lists、result 等）；
- 通过 `wit-bindgen` 或语言工具链生成绑定代码；
- 在实现侧导出；在消费侧按世界导入；
- Host 运行时（如 Wasmtime）负责类型安全的参数编解码。

常见坑：
- 字符串/字节的所有权与生命周期要明确（避免双重释放）；
- 大对象按结构传递时优先扁平化（record）而非深层嵌套；
- 跨语言错误统一用 `result<T, E>` 或具名 `variant` 承载。

## 5.3 组件拼接演示

参见 [examples/ch05/components_composition](https://github.com/Thneoly/beyond-wasm/tree/main/examples/ch05/components_composition) 的脚本与 WIT 草案，逐步完成 componentize/compose/glue。

## 5.4 标准接口族示例

wasi:io, wasi:crypto, wasi:nn 等能力接口的使用与场景。

- wasi:cli、wasi:filesystem、wasi:clocks：通用系统能力；
- wasi:http：以组件接口暴露 HTTP 处理（如 Spin）；
- wasi:crypto、wasi:nn：特定领域能力；
- 能力最小化：仅声明/授予必须的 world 依赖，减少攻击面。

## 5.5 对比：WASM 组件 vs OCI 容器

目标、隔离边界、镜像/分发、组合方式不同，互补而非替代。

- 单体 vs 颗粒度：容器适合进程级交付；组件适合函数/库级复用；
- 隔离：容器=OS 级；组件=运行时沙箱 + 能力授权；
- 分发：容器镜像/仓库 vs 组件包（可嵌入 OCI Artifact）；
- 组合：容器常用 sidecar/服务编排；组件可静态 compose 或 Host 路由。

落地建议：
- 以 OCI 为外围交付形态，内含多组件，Host 根据路由/策略调度；
- 在 CI 里同时产出容器镜像与组件产物，生成 SBOM 与签名。

---

更多内容：
- WIT 与 World → ./wit-and-world
- 组合与宿主 → ./composition
- 类型与语法速览 → ./types-and-syntax
 - 绑定与工具链 → ./bindings-and-tools
 - 组件化工作流 → ./workflow
 - 版本与兼容 → ./versioning-and-compat
 - 分发与签名 → ./distribution-and-signing
 - 宿主与运行时 → ./host-and-runtime