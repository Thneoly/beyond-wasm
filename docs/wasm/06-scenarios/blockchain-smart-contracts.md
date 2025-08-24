---
id: scenarios-blockchain
title: 区块链智能合约
sidebar_label: 区块链合约
sidebar_position: 4
---

# 区块链智能合约

WASM 在多条公链作为原生或兼容执行环境，具备跨语言与可移植优势。

## 主流生态
- Substrate/Polkadot：ink!（Rust）编写合约，wasm 作为执行字节码；
- CosmWasm（Cosmos SDK）：Rust 合约编译为 wasm，执行于 CosmWasm VM；
- NEAR：AssemblyScript/Rust 合约，wasm 执行；
- Solana/Sui/Move：虽以 BPF/Move 为主，但亦有 Wasm 相关探索。

## 能力与限制
- 纯计算与确定性：禁止不确定系统调用，需显式输入确定性数据；
- 资源计量：gas/weight 按指令或 host 调用计费；
- 存储接口：键值/状态机由链提供 host functions；
- 安全：不允许任意 I/O/网络，能力极度受限。

## 开发与测试建议
- 本地链/模拟器：使用各生态提供的本地节点或测试框架；
- 合约接口稳定性：以明确 ABI/事件设计为先；
- Fuzz/属性测试：对关键入口进行模糊与属性测试；
- 基准：记录 gas/存储使用，纳入 CI 基线。

> 注：本仓库以通用运行时与组件为主，区块链示例可参考各生态官方模板与教程。
