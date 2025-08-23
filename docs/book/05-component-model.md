---
title: 第 5 章 组件模型与未来标准
slug: /book/05-component-model
---

目标：理解组件模型的动机、接口类型与绑定，并演示模块组合为组件。

> 快速跳转：完整的运行指南与依赖矩阵见 `examples/README.md`（总览导航 + 工具链准备 + FAQ）。

## 5.1 动机与目标

多语言互操作、模块组合、封装能力与版本化。

## 5.2 接口类型与 bindings

接口类型（Interface Types）解决跨语言的类型传递；bindings 自动生成 glue code。

## 5.3 组件拼接演示
从组件化开始（基于第 3 章生成的 WASM）：

```bash
# 构建 ch03 的核心模块
cd examples/ch03/rust_wasm_wasmtime
rustup target add wasm32-wasi
cargo build --release --target wasm32-wasi

# 组件化（生成 .component.wasm 并查看 WIT）
cd ../../ch05/components_composition
bash componentize-ch03.sh
```

随后补充第二个模块 `inc(x)->x+1`，并先通过宿主级组合验证流程，再引入 WIT 与 `component compose` 做真正的组件组合：

```bash
# 构建 inc 模块
cd examples/ch05/components_composition/core_inc
rustup target add wasm32-wasi
cargo build --release --target wasm32-wasi

# 宿主级组合（先验证行为）
cd ..
node host-compose.js \
	../../ch03/rust_wasm_wasmtime/target/wasm32-wasi/release/rust_wasm_wasmtime.wasm \
	./core_inc/target/wasm32-wasi/release/core_inc.wasm \
	2 3
# => {"a":2,"b":3,"sum":5,"result":6}

# 组件化（产生 .component.wasm）
bash componentize-ch03.sh

# 组件级组合（产生 add+inc 组合组件）
bash compose-add-inc.sh

# 快速构建三个组件并查看 WIT（脚本包装）
bash build-components.sh

# 运行 glue 组件导出（脚本会尝试多种导出名）
bash run-glue.sh 2 3
```

下一步将提供 WIT 与 `component compose` 的完整示例。

提示：示例目录包含说明与 WIT 草案，见：
- `examples/ch05/components_composition/NOTES.md`
 - `examples/ch05/components_composition/wit/`
 - `examples/ch05/components_composition/{add_component,inc_component,glue_component}/`

## 5.4 wasi:io, wasi:crypto, wasi:nn 使用场景

I/O 抽象、密码学原语、神经网络推理等标准化接口。

## 5.5 对比：WASM 组件 vs OCI 容器

目标、隔离边界、镜像/分发、组合方式不同，互补而非替代。

---

小结：组件模型将成为多语言与多模块协作的关键基座。

---

更多内容：
- WIT 与 World → ./05-component-model/wit-and-world
- 组合与宿主 → ./05-component-model/composition
