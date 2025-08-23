id: outlook-trends-and-roadmap
title: 趋势与路线图
sidebar_label: 趋势与路线图
sidebar_position: 1
---

# 趋势与路线图

## 生态趋势

- 组件模型成熟度与生态采纳持续提升（WIT 工具链完善）；
- 容器/插件系统融合（OCI Artifact、runwasi、Spin 等）；
- 安全与可观测性从“可选项”变为“默认需求”。

## 实践路线图（示意）

```mermaid
gantt
	dateFormat  YYYY-MM-DD
	title 30/60/90 天实践路线图
	section 30 天
	WIT 契约与组件化最小实现  :done,    des1, 2025-08-01, 15d
	体积/启动基线建立          :active,  des2, 2025-08-01, 30d
	section 60 天
	2-3 个业务组件拆分与升级策略:        des3, 2025-08-16, 30d
	安全与签名校验接入 CI       :        des4, 2025-08-20, 25d
	section 90 天
	统一交付（OCI/WASM）与多运行时适配 : des5, 2025-09-15, 30d
```

## 度量与风险

- 度量：以“体积/启动/内存/错误率”为主线，建立可比基线；
- 风险：
	- 组件模型/预览规范变更带来的兼容性；
	- 多运行时差异导致的行为偏差；
	- 签名/供应链与 SBOM 管理的缺失。
