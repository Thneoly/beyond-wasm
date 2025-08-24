---
id: component-host-and-runtime
title: 宿主与运行时
sidebar_label: 宿主与运行时
sidebar_position: 8
---

# 宿主与运行时

## 组件 API 支持
- Wasmtime：提供组件 API，适合服务端场景；
- 其他运行时：关注组件模型与 WASI 支持矩阵。

## 调用与池化
- 按路由绑定 world/接口导出；
- 实例池降低冷启动；
- 限流、超时与熔断防止级联故障。

## 示例
- HTTP 宿主： [examples/ch06/component_http_host](https://github.com/Thneoly/beyond-wasm/tree/main/examples/ch06/component_http_host)
