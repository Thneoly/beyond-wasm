# precompile-wasmtime：预编译对比启动耗时

对比两种执行方式的耗时：
- 直接运行 .wasm
- 先 `wasmtime compile` 生成 .cwasm，再运行

步骤：
```bash
bash run.sh
```

输出：
- direct(ns) 与 precompiled(ns) 两个耗时（纳秒级，macOS 以 date +%s%N 近似测量）
- 仅用于相对比较，结果受本机负载影响
 - out/report.md：Markdown 报告（含 ns 与 ms、工具版本、迭代参数）

依赖：
- wasm-tools（已用于从 .wat 生成 .wasm）
- wasmtime（若缺少脚本会报错并退出）
