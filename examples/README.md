# examples 目录

本目录与《Beyond the Browser》各章示例一一对应：

- ch02：基础概念与 .wat/.wasm 示例
- ch03：Rust 生成 WASM + Wasmtime 运行
- ch04：WASI 文件/时间示例
- ch05：组件模型与组合
- ch06：场景化示例（浏览器、边缘、区块链、插件、AI/ML）
- ch07：综合实践

如无特别说明，所有命令在 macOS 下以 zsh 执行。

## 环境依赖矩阵
- 基础工具
	- wasm-tools：.wat ↔ .wasm、strip/component 等
	- wasmtime：运行核心 WASM/WASI/组件（CLI）
	- Node (>=18)：Node HTTP/插件/浏览器静态服务等
	- Rust toolchain + `wasm32-wasi`：构建 Rust 组件/二进制
	- Binaryen（可选）：`wasm-opt -Oz` 体积优化
	- Spin CLI（可选）：WASI HTTP 示例

## 快速开始（常用）
```bash
# 安装依赖（示例）
# brew install wasm-tools wasmtime binaryen node
# rustup target add wasm32-wasi

# 运行 ch06 Node HTTP 示例
cd ch06/http_server_node
wasm-tools parse wasm/add.wat -o wasm/add.wasm
node server.mjs

# 运行 ch04 WASI 文件/时间
cd ../../ch04/wasi_fs_time
cargo build --release --target wasm32-wasi
wasmtime --dir=. target/wasm32-wasi/release/wasi_fs_time.wasm sample.txt
```

## 目录速览与指引
- ch03：Rust → WASM → Wasmtime
	- `ch03/rust_wasm_wasmtime`：导出 add 函数，`wasm32-wasi` 目标构建；可用 Wasmtime/Node 运行
- ch04：WASI 文件与时间
	- `ch04/wasi_fs_time`：预打开目录 `--dir=.`，传入 `sample.txt`
- ch05：组件模型与组合
	- 参见第 5 章文档；含 WIT、cargo-component 与 glue/compose
- ch06：场景化示例
	- `browser`：先 `wasm-tools parse add.wat -o add.wasm`，再用静态服务访问 index.html
	- `plugin_host`：`wasm-tools parse plugins/add.wat -o plugins/add.wasm`，`node host.js plugins/add.wasm 2 3`
	- `http_server_node`：`wasm-tools parse wasm/add.wat -o wasm/add.wasm`，`node server.mjs`
	- `wasi_http_spin`：`spin build && spin up`
	- `component_http_host`：`bash compose.sh`（可选），`bash run.sh` 一键构建运行
- ch07：综合实践
	- `size-opt`：`bash run.sh` 生成体积报告（out/report.md）
	- `precompile-wasmtime`：`ITER=30 WARMUP=5 bash run.sh` 生成启动对比报告

## 常见问题（FAQ）
- wasmtime: command not found
	- 安装 wasmtime（或 `cargo install wasmtime-cli`），再重试脚本
- 运行 WASI 访问文件报权限错误
	- 需通过 `--dir=.` 或指定目录显式授权
- 浏览器示例 add.wasm 404
	- 先 `wasm-tools parse add.wat -o add.wasm`，并确保静态服务根目录包含该文件
