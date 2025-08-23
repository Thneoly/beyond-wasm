# Beyond the Browser: WebAssembly 全景解析（书 + 可运行示例）

本仓库包含一本基于 Docusaurus 的电子书与配套可运行示例（examples）。目标是系统性理解 WASM：基础 → 运行时/工具链 → WASI → 组件模型 → 场景实践 → 工程落地与展望。

在线阅读（GitHub Pages）：https://thneoly.github.io/beyond-wasm/

文档入口：/docs/book（侧边栏“📘 书籍：Beyond the Browser”）

## 环境依赖（常用）
- Node >= 20（文档站与部分示例）
- wasm-tools（.wat↔.wasm、strip/component 等）
- Wasmtime（运行核心 WASM/WASI/组件，部分示例）
- Rust toolchain + wasm32-wasi（构建 Rust 示例/组件）
- Binaryen（可选，`wasm-opt -Oz` 体积优化）
- Spin CLI（可选，WASI HTTP 示例）

更多见 `examples/README.md` 的“环境依赖矩阵”。

## 快速开始（文档站）
```bash
# 安装依赖（任选其一）
yarn        # 或 npm ci

# 本地开发
yarn start  # http://localhost:3000

# 构建静态站点
yarn build  # 产物在 build/
```

## 示例速览（examples/）
- ch03 Rust → WASM → Wasmtime：`examples/ch03/`
- ch04 WASI 文件/时间：`examples/ch04/wasi_fs_time/`
- ch06 场景化示例：浏览器、插件式宿主、Node HTTP、Spin（WASI HTTP）、组件模型 HTTP 宿主
- ch07 实践：体积优化与 Wasmtime 预编译对比，自动生成 Markdown 报告

常用示例一键：
```bash
# Node HTTP + Wasm（ch06）
cd examples/ch06/http_server_node
wasm-tools parse wasm/add.wat -o wasm/add.wasm
node server.mjs  # 浏览器打开 http://localhost:8787/add?a=1&b=2

# 体积优化报告（ch07）
cd ../../ch07/size-opt
bash run.sh      # 查看 out/report.md

# 预编译对比（ch07）
cd ../precompile-wasmtime
ITER=30 WARMUP=5 bash run.sh  # 查看 out/report.md
```

更多示例导航、依赖与 FAQ：见 `examples/README.md`。

## CI / 部署
- GitHub Actions：
	- `.github/workflows/ci.yml` 与 `docs.yml` 进行类型/链接/结构检查并构建站点（部分检查非阻塞）。
	- `.github/workflows/deploy.yml` 推送 `gh-pages`（STRICT_LINKS=0，避免断链阻塞发布）。
- 本地可用 `yarn build` 生成静态站点。

发布后的在线地址：
- https://thneoly.github.io/beyond-wasm/

## 目录结构（要点）
- `docs/book/`：第 1–8 章与附录
- `examples/`：各章配套示例与脚本
- `scripts/`：链接/路径/mermaid 标签等检查脚本

反馈/建议欢迎提 Issue 或 PR 🙌
