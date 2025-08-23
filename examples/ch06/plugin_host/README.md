# ch06：插件式宿主（Node）最小示例

此示例模拟插件加载：宿主进程从 `plugins/` 目录加载 WASM 并调用导出函数。

## 准备与运行
先将插件 .wat 转为 .wasm（需要 `wasm-tools`）：
```bash
wasm-tools parse plugins/add.wat -o plugins/add.wasm
```
执行宿主并传参：
```bash
node host.js plugins/add.wasm 2 3
```

`host.js` 会检查插件是否导出 `add(i32,i32)->i32` 并打印结果。
