---
title: 第 7 章 实践与示例
slug: /book/07-practices/overview
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

## 7.2 安全与权限（WASI 能力）
- 最小权限：仅开放所需的 fd/network 等能力
- 不信任输入：对宿主/组件边界的参数做校验
- 组件签名与供应链：可选 Sigstore/签名校验

## 7.3 性能与体积
- 编译选项：Rust LTO/opt-level/strip；Binaryen wasm-opt -Oz
- 观察指标：二进制体积、启动耗时、P50/P99
- 示例：`examples/ch07/size-opt`（生成多版本二进制并输出报告）

## 7.4 启动与部署
- 预编译：`wasmtime compile` 产生 cwasm，降低冷启动
- 缓存复用：落盘 cache/按版本命中
- 示例：`examples/ch07/precompile-wasmtime`（多次迭代输出统计与 Markdown 报告）

## 7.5 观测与调试
- Host 埋点：请求级计时、错误率、QPS
- 组件可观测：导出错误码 vs 字符串，便于聚合
- 问题复现：固定工具链版本、锁定输入

## 7.6 测试与 CI
- WIT 驱动用例：契约/边界值/类型校验
- 体积回归阈值：超出阈值报警
- 启动时间基线：冷/热启动对比

## 7.7 组合与演进
- compose/glue 与 Host 串联两种模式的利弊
- 版本演进：world/接口更名、兼容窗口

---

运行提示：
- 体积优化报告
	- 进入 `examples/ch07/size-opt`，执行 `bash run.sh`，查看 `out/report.md`
- 预编译对比报告
	- 进入 `examples/ch07/precompile-wasmtime`，执行 `bash run.sh`，查看 `out/report.md`

---

更多内容：
- 性能与体积 → ./perf-and-size
