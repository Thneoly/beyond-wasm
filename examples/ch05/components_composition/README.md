# 组件模型：最小组件化与拼接（起步）

本示例演示：先将 ch03 的 WASI Core 模块组件化，再扩展到多模块拼接。

## 准备
- 安装 `wasm-tools`：`cargo install wasm-tools`
- 先构建 ch03 的核心模块：
```bash
cd ../../ch03/rust_wasm_wasmtime
rustup target add wasm32-wasi
cargo build --release --target wasm32-wasi
```

## 组件化 ch03 模块
```bash
cd ../../ch05/components_composition
bash componentize-ch03.sh
```
脚本输出：
- `out/rust_wasm_wasmtime.component.wasm`：组件产物
- 终端打印组件的 WIT 接口签名（便于理解导出）

## 下一步（即将补充）
### 1) 构建第二个模块 inc 并组件化（可选）
```bash
cd core_inc
rustup target add wasm32-wasi
cargo build --release --target wasm32-wasi
cd ..
bash componentize-ch03.sh  # 会尝试同时组件化 inc
```

### 2) 宿主级组合（不依赖组件模型，仅示意）
```bash
node host-compose.js \
	../../ch03/rust_wasm_wasmtime/target/wasm32-wasi/release/rust_wasm_wasmtime.wasm \
	./core_inc/target/wasm32-wasi/release/core_inc.wasm \
	2 3
# 输出：{"a":2,"b":3,"sum":5,"result":6}
```

### 3) 组件级组合（即将补充）
在组件化 `add` 与 `inc` 后，进行组合：
```bash
bash compose-add-inc.sh
```
脚本会生成 `out/add_inc.component.wasm` 并打印其 WIT 接口。后续将补充以 Wasmtime/组件运行器调用导出函数的方式。

### 4) 胶水 WIT（规划）
参见 `wit/glue.wit`：定义一个 `glue-world`，导入 add/inc 接口并导出 `add-then-inc`。后续将提供一个“胶水组件”实现，用以调用两个导入、导出合成能力。

### 5) cargo-component 路线（骨架已放置）
在 `add_component/`、`inc_component/` 与 `glue_component/` 已放置最小骨架（使用 `wit-bindgen` 宏）。为了便捷构建与运行组件，推荐安装：

```
cargo install cargo-component
```

随后将补充 `Cargo.toml` 中的 component 配置与构建命令，完成统一 world 的组件构建与运行。

现在可直接用 cargo-component 构建：
```bash
# 构建/检查三个组件
cargo component build -p add_component
cargo component build -p inc_component
cargo component build -p glue_component

# 使用 Wasmtime（组件支持）调用 glue 的导出
# wasmtime run --invoke demo:glue/api.add-then-inc target/wasm32-wasi/release/glue_component.component.wasm 2 3
```

暂未使用 cargo-component 的情况下，也可以用脚本快速构建 core wasm 并组件化：
```bash
bash build-components.sh
# 产物在 out/*.component.wasm，并打印各自的 WIT
```

运行 glue 组件导出（自动尝试多种导出名）：
```bash
bash run-glue.sh 2 3
```
