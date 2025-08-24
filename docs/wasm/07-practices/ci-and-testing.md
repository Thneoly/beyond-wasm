---
id: practices-ci-testing
title: CI 与测试
sidebar_label: CI 与测试
sidebar_position: 4
---

# CI 与测试

## 目标
- 保障组件与宿主在多运行时、多平台的稳定性与可重复构建。

## 建议流水线
- Lint/Typecheck：前端/文档/宿主工程类型检查；
- Build：构建组件与宿主，产出 `.component.wasm` 与可执行文件；
- 报告：运行 [examples/ch07/size-opt](https://github.com/Thneoly/beyond-wasm/tree/main/examples/ch07/size-opt) 与 precompile 基准，上传报告；
- 测试：单测 + 端到端，模拟并发与超时；
- 发布：签名产物、生成 SBOM、推送到制品库（OCI Artifact/文件仓库）。

## 测试类型
- 单元测试：组件导出函数的纯逻辑校验；
- 合约测试：WIT/world 的兼容性测试（新增字段/接口的向后兼容）；
- 集成测试：宿主与多组件组装后的端到端校验；
- 性能回归：以固定迭代与无噪声环境取 min/avg。
