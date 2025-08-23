# ch04：WASI 文件与时间

目标：通过 WASI 访问受限的文件系统与时间能力。

子目录：`wasi_fs_time/`（Rust 示例：读取文件并打印 epoch 秒）

依赖：
- Rust toolchain（rustup）
- 目标：`wasm32-wasi`
- Wasmtime CLI（或 `cargo install wasmtime-cli`）

构建：
```bash
cd examples/ch04/wasi_fs_time
rustup target add wasm32-wasi
cargo build --release --target wasm32-wasi
```

运行（预打开当前目录，并传入文件名）：
```bash
wasmtime --dir=. target/wasm32-wasi/release/wasi_fs_time.wasm sample.txt
```

输出会包含当前 epoch 秒数、文件名与读取内容摘要；`--dir=.` 用于显式授予文件访问能力。
