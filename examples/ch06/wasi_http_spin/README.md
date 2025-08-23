# wasi_http_spin：基于 Spin 的 WASI HTTP 示例

本示例使用 Fermyon Spin 提供的 HTTP 触发器（WASI HTTP）运行一个最小的 Web 处理函数。

## 先决条件
- 安装 Rust 工具链（用于构建）
- 安装 Spin CLI：https://developer.fermyon.com/spin/install

## 运行
```bash
# 构建（会产出 target/wasm32-wasi/release/http_spin.wasm）
spin build

# 启动本地服务（默认 127.0.0.1:3000）
spin up
```

## 试用
- GET http://127.0.0.1:3000/ -> 200 OK, body: "hello from spin + wasi http"
- GET http://127.0.0.1:3000/add?a=1&b=2 -> 200 OK, body: {"a":1,"b":2,"result":3}

## 说明
- 该示例使用 `spin_sdk` 提供的 HTTP 处理宏，将请求路由给 Rust 函数。
- 其底层使用 WASI HTTP，适合部署到边缘/Serverless 场景。
- 你可以将相同逻辑迁移到多语言组件（如 TinyGo、JavaScript 运行时等）。