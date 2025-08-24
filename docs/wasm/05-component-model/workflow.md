---
id: component-workflow
title: 组件化工作流
sidebar_label: 组件化工作流
sidebar_position: 5
---

# 组件化工作流

从契约到运行的最小闭环：

1) 设计契约：以 WIT 定义接口与 world；
2) 实现组件：按语言生成/编写绑定与实现；
3) 组件化封装：`wasm-tools component new`；
4) 组合：`wasm-tools component compose` 静态拼装；
5) 宿主集成：在 Wasmtime 等宿主中按路由/策略调用；
6) 观测与调优：记录耗时/错误与内存，迭代优化。

参考脚本：
- [examples/ch05/components_composition](https://github.com/Thneoly/beyond-wasm/tree/main/examples/ch05/components_composition)
- [examples/ch06/component_http_host](https://github.com/Thneoly/beyond-wasm/tree/main/examples/ch06/component_http_host)

常见坑：
- world 变更引发的兼容问题；
- 组合后导出名冲突；
- 运行时差异（字符串编码/内存布局）。
