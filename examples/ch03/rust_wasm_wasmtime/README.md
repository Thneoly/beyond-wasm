# Rust → WASM → Wasmtime 示例

本示例用 Rust 导出一个 `add(i32,i32)->i32` 函数，编译为 `wasm32-wasi` 并使用 Wasmtime 在宿主调用。

## 准备
- 安装 Rust 与目标：
  - rustup target add wasm32-wasi
- 安装 Wasmtime（或使用 `cargo install wasmtime-cli`）

## 构建
```bash
# 在项目根目录（包含 Cargo.toml）执行
cargo build --release --target wasm32-wasi
```
生成产物：`target/wasm32-wasi/release/rust_wasm_wasmtime.wasm`

## 运行（两种方式）
1) 直接运行模块（无导入）：
```bash
wasmtime target/wasm32-wasi/release/rust_wasm_wasmtime.wasm
```
2) 通过 Wasmtime CLI 调用导出函数：
```bash
wasmtime target/wasm32-wasi/release/rust_wasm_wasmtime.wasm \
  --invoke add 1 2
# 期望输出：3
```
