---
id: component-distribution
title: 分发、签名与制品
sidebar_label: 分发与签名
sidebar_position: 7
---

# 分发、签名与制品

## 分发形态
- `.component.wasm` 作为交付单元；
- 以 OCI Artifact 进行版本化与推送（可与镜像并存）。

## 签名与 SBOM
- 对组件产物进行签名（如 cosign），在 CI/CD 验证；
- 生成 SBOM（SPDX/CycloneDX），与容器镜像一并归档。

## 运行前校验
- 宿主校验签名、哈希与策略（来源/用途/有效期）；
- 拒绝未签名或策略不匹配的组件。

延伸阅读：
- 第 7 章 安全与供应链 → ../07-practices/security-and-supply-chain
