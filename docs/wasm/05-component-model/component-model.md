---
id: component-model-overview
title: 第 5 章 组件模型与未来标准
sidebar_label: 本章导读
sidebar_position: 1
---

目标：理解组件模型的动机、接口类型与绑定，并演示模块组合为组件。

> 快速跳转：完整的运行指南与依赖矩阵见 `examples/README.md`（总览导航 + 工具链准备 + FAQ）。

## 5.1 动机与目标

多语言互操作、模块组合、封装能力与版本化。

## 5.2 接口类型与 bindings

接口类型（Interface Types）解决跨语言的类型传递；bindings 自动生成 glue code。

## 5.3 组件拼接演示

参见 `examples/ch05/components_composition` 的脚本与 WIT 草案，逐步完成 componentize/compose/glue。

## 5.4 标准接口族示例

wasi:io, wasi:crypto, wasi:nn 等能力接口的使用与场景。

## 5.5 对比：WASM 组件 vs OCI 容器

目标、隔离边界、镜像/分发、组合方式不同，互补而非替代。

---

更多内容：
- WIT 与 World → ./wit-and-world
- 组合与宿主 → ./composition