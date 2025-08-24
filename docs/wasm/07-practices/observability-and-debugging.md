---
id: practices-observability
title: 观测与调试
sidebar_label: 观测与调试
sidebar_position: 3
---

# 观测与调试

目标：为组件/宿主建立可观测性基线（日志、指标、追踪）与基础调试手段。

## 日志
- 组件侧：以接口返回值或事件方式回传关键日志，避免直接 stdout 污染；
- 宿主侧：统一日志格式（JSON），包含 trace_id、component、version、route、status；
- 采样：对高频路由按比例采样，错误全量。

## 指标
- 统一维度：`component`, `version`, `route`, `code`；
- 关键指标：QPS、P50/P90/P99、错误率、内存/实例数；
- 基线：在 CI 中运行 [examples/ch07/precompile-wasmtime](https://github.com/Thneoly/beyond-wasm/tree/main/examples/ch07/precompile-wasmtime) 与 size-opt，产出对比报告并入库。

## 追踪
- 宿主生成 trace 并透传上下文到组件调用；
- 组件通过返回值或回调上报 span 关键事件（开始/结束/错误）。

## 调试
- Name 段：保留符号信息以便本地调试；
- 反编译/查看：`wasm-tools dump`/`objdump`；
- 本地最小化复现：将组件单测或 host 调用提取为最小脚本，复现场景。
