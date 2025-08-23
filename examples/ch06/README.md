# ch06：场景化示例

本目录包含多个最小可运行示例：

- browser：浏览器端加载 .wasm 并调用导出函数
- plugin_host：Node 宿主加载插件式 .wasm
- http_server_node：Node 原生 HTTP + Wasm 路由计算
- wasi_http_spin：使用 Fermyon Spin（WASI HTTP）运行 HTTP 处理
- component_http_host：组件模型 + Wasmtime 组件 API 的 HTTP 宿主（业务以组件导出，宿主按路由调用）

预处理（需要 `wasm-tools`）：
```bash
wasm-tools parse browser/add.wat -o browser/add.wasm
wasm-tools parse plugin_host/plugins/add.wat -o plugin_host/plugins/add.wasm
wasm-tools parse http_server_node/wasm/add.wat -o http_server_node/wasm/add.wasm
```

子示例快速指南：

1) browser
```bash
cd browser
# 启动静态服务器（任选其一）
# npx serve .
# python3 -m http.server 8000
# 打开 http://localhost:8000/index.html 并在控制台查看 add(2,3)
```

2) plugin_host
```bash
cd plugin_host
wasm-tools parse plugins/add.wat -o plugins/add.wasm
node host.js plugins/add.wasm 2 3  # 输出 5
```

3) http_server_node
```bash
cd http_server_node
wasm-tools parse wasm/add.wat -o wasm/add.wasm
node server.mjs
# 打开：http://localhost:8787/ 与 http://localhost:8787/add?a=1&b=2
```

4) wasi_http_spin
```bash
cd wasi_http_spin
spin build && spin up
# 打开：http://127.0.0.1:3000/
```

5) component_http_host
```bash
cd component_http_host
bash run.sh            # 默认加载 business_component
GLUE=1 bash run.sh     # 优先加载 glue 组合件（若已 compose）
```

以上示例覆盖浏览器、插件、HTTP 服务端、WASI HTTP 与组件模型主机等常见场景，可在此基础上拓展更复杂业务。
