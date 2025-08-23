# http_server_node：Node HTTP + Wasm 最小示例

本示例使用 Node 原生 `http` 模块启动服务，并在路由 `/add` 内调用 WebAssembly 导出函数 `add`。

## 预备
- 需要 Node >= 18（原生支持 `WebAssembly.instantiate` 与 ES 模块）
- 需要安装 `wasm-tools` 将 `.wat` 转 `.wasm`

## 构建 .wasm
```bash
wasm-tools parse wasm/add.wat -o wasm/add.wasm
```

## 运行
```bash
node server.mjs
# 或指定端口
PORT=8080 node server.mjs
```

## 试用
- 打开根路径
  - http://localhost:8787/
- 计算加法
  - http://localhost:8787/add?a=1&b=2 -> {"a":1,"b":2,"result":3}

## 说明
- `server.mjs` 在启动时加载 `wasm/add.wasm`，并将其导出函数 `add` 暴露到路由处理逻辑。
- 该 Wasm 模块是最基础的核心模块（非 WASI），无需 imports。
- 你可以将此模式迁移到 Koa/Express、边缘函数（如 Cloudflare Workers/Next Edge）等环境。