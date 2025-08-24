---
id: practices-security
title: 安全与签名/SBOM
sidebar_label: 安全与供应链
sidebar_position: 5
---

# 安全与签名/SBOM

## 目标
- 降低供应链风险，确保组件与宿主产物可验证与可追溯。

## 签名与验证
- 对 `.component.wasm`、容器镜像进行签名（如 cosign），发布前在 CI 验证；
- 运行前宿主校验签名与策略（允许来源/时间窗/用途）。

## SBOM 与依赖
- 产出 SBOM（SPDX/CycloneDX），记录依赖与许可证；
- 监控已知漏洞（SCA），及时打补丁与重建。

## 权限最小化
- WASI 权限：只授予必要接口（fs/cli/http 等）；
- Host Functions：暴露最小集合，避免越权能力；
- 沙箱：资源上限（内存/时间），隔离多租户。

## 运行时加固
- 预编译与缓存：减少运行时编译攻击面；
- 隔离策略：按租户/路由/版本划分隔离域；
- 审计：记录组件调用签名、版本、哈希与策略命中情况。
