# size-opt：WASM 体积优化对比

步骤：
1. 使用 wasm-tools parse 将 add.wat 转换为 add.base.wasm
2. 使用 wasm-tools strip 去掉 names 等自定义段（降体积）
3. 若安装了 Binaryen 的 wasm-opt，使用 -Oz 进一步瘦身
4. 列出 out/ 下各版本大小，便于对比

运行：
```bash
bash run.sh
```

输出：
- out/add.base.wasm：原始产物
- out/add.strip.wasm：剥离自定义段
- out/add.opt.wasm：进一步优化（若未安装 wasm-opt，则与 strip 相同）
- out/report.md：Markdown 报告（字节、可读体积与相对节省百分比）