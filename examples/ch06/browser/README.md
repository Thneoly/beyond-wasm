# ch06：浏览器端 WASM 示例（最小）

此示例展示如何在浏览器中加载 .wasm 并调用导出的 add 函数。

## 准备与运行（静态服务）
先将 .wat 转为 .wasm（需要 `wasm-tools`）：
```bash
wasm-tools parse add.wat -o add.wasm
```
再用任意静态服务器启动：
```bash
# 使用任意静态服务器（Node、Python 等），例如：
# npx serve .
# 或：python3 -m http.server 8000
```

访问页面 `index.html`，打开控制台查看输出。
