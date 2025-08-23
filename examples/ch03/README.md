# ch03：Rust → WASM → Wasmtime

目标：用 Rust 生成 WASM 并在 Wasmtime 中运行。

子目录：`rust_wasm_wasmtime/`（Rust cdylib 导出 add 函数）

依赖：
- Rust toolchain（rustup）
- 目标：`wasm32-wasi`
- Wasmtime CLI（或 `cargo install wasmtime-cli`）

构建：
```bash
cd examples/ch03/rust_wasm_wasmtime
rustup target add wasm32-wasi
cargo build --release --target wasm32-wasi
```

运行（两种方式）：
```bash
# 1) 直接运行 wasm（如无导入）
wasmtime target/wasm32-wasi/release/rust_wasm_wasmtime.wasm

# 2) 调用导出函数 add
wasmtime target/wasm32-wasi/release/rust_wasm_wasmtime.wasm --invoke add 1 2
```

可选：用 Node 的 WebAssembly API 运行（不依赖 WASI）：
```bash
node host.js target/wasm32-wasi/release/rust_wasm_wasmtime.wasm 1 2
```
