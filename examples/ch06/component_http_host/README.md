# component_http_host：组件模型 + HTTP 服务端示例

目标：用组件模型拆分“业务逻辑”和“宿主 HTTP 服务”。
- 业务组件：导出 `add(a: s32, b: s32) -> s32`，通过 WIT 定义接口并构建为 WebAssembly 组件
- HTTP Host（Rust）：使用 Wasmtime 组件 API 加载组件，在路由中调用导出函数

## 构建
```bash
# 1) 构建业务组件（cargo-component）
cd business_component
cargo component build --release
cd ..

# 2) 构建 HTTP Host（Rust）
cargo build --release -p component_http_host

# 可选：构建 inc 与 glue 组件（多组件装配）
bash compose.sh  # 生成 out/glue_composed.component.wasm
```

## 运行
```bash
# 默认从 ./business_component/target/wasm32-wasi/release/business_component.wasm 加载组件
./target/release/component_http_host
# 或指定组件路径
COMPONENT_PATH=./business_component/target/wasm32-wasi/release/business_component.wasm \
  ./target/release/component_http_host

# 一键脚本（自动构建组件与宿主并运行）
bash run.sh             # 默认加载 business_component
GLUE=1 bash run.sh      # 优先加载 out/glue_composed.component.wasm（存在时），否则回退 glue_component
```

## 试用
- GET http://127.0.0.1:7878/ -> 文本
- GET http://127.0.0.1:7878/add?a=1&b=2 -> JSON: {"a":1,"b":2,"result":3}
- GET http://127.0.0.1:7878/add-then-inc?a=1&b=2
  - 默认：回退为 add 后 +1
  - GLUE=1：调用 glue 组件导出 api.add-then-inc（WIT: demo:glue/glue-world）

## 结构
- business_component：WIT + Rust 组件（无 WASI 依赖）
- host：Rust HTTP 服务端（tiny_http）+ wasmtime 组件 API + WIT 绑定（host 侧）

> 提示：WIT 在 host 与 component 双侧对齐（同一 `package`/`world`），便于通过 bindgen 生成类型安全的调用。`/add-then-inc` 路由预留了“多组件装配”的位置，你可以改为加载由 add+inc 组合得到的 glue 组件（参考 ch05 的 compose 与 glue 样例）。