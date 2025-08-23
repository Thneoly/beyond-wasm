# ch07：实践与优化示例

本目录包含两类最小可运行示例：

- size-opt：体积优化与对比
- precompile-wasmtime：wasmtime 预编译对比启动耗时

运行前置：
- 安装 wasm-tools（wasm-tools, wasm-tools component, wit 等）
- 如使用 wasm-opt，请安装 Binaryen（可选）
- 安装 wasmtime CLI（用于运行与预编译）

## 快速开始
```bash
# 体积优化
cd examples/ch07/size-opt
bash run.sh

# 预编译对比
cd ../precompile-wasmtime
bash run.sh
```# ch07：综合实践

集成 Host+Plugin、组件拼接与 WASI 能力的完整小型应用（后续补充）。
