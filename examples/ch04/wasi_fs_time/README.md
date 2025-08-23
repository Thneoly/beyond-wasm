# WASI：文件与时间示例

本示例演示在 WASI 下读取文件并打印当前时间（自 UNIX EPOCH 起的秒数）。

## 准备
- 安装 Rust 与目标：
```bash
rustup target add wasm32-wasi
```
- 安装 Wasmtime（或 `cargo install wasmtime-cli`）

## 构建
```bash
cd examples/ch04/wasi_fs_time
cargo build --release --target wasm32-wasi
```

## 运行
准备一个要读取的文件（仓库已提供 `sample.txt`），然后使用 Wasmtime 并预打开当前目录：
```bash
wasmtime --dir=. target/wasm32-wasi/release/wasi_fs_time.wasm sample.txt
```
输出示例：
```
epoch_seconds=1724100000
file=sample.txt bytes=27
--- BEGIN ---
hello from wasi sample file
--- END ---
```

说明：
- `--dir=.` 表示将当前目录映射为 WASI 沙箱内的可访问目录。
- 时钟能力在 Wasmtime 中默认允许；文件访问需通过 `--dir` 显式授予。
