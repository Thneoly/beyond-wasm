id: basics-text-binary
title: 文本格式与二进制
sidebar_label: 文本与二进制
sidebar_position: 1
---

# 文本格式与二进制

- .wat 与 .wasm 的映射关系（S-表达式 → 段）
- wasm-tools parse/print 的基本使用
- 边界：名称段、调试信息与 strip

## 转换流程

```mermaid
flowchart LR
	WAT[.wat] -->|parse| WASM[.wasm]
	WASM -->|print| WAT
	WASM -->|strip| WASM_stripped[".wasm (stripped)"]
```

示例命令：

```bash
wasm-tools parse min.wat -o min.wasm
wasm-tools print min.wasm | head -n 30
wasm-tools strip min.wasm -o min.strip.wasm
```
