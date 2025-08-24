---
id: practices-perf-and-size
title: 启动、性能与体积
sidebar_label: 性能与体积
sidebar_position: 2
---

## 性能与体积

本页汇总如何量化体积与启动性能，并给出可复现脚本。

## 体积优化对比（size-opt）

步骤：
1. 生成原始 wasm；
2. `wasm-tools strip` 去除调试/名称段；
3. 可选 `wasm-opt -Oz` 压缩；
4. 统计各版本字节数与降幅，输出 Markdown 报告。

运行：

```bash
cd examples/ch07/size-opt
bash run.sh
cat out/report.md
```

报告包含：
- 原始/strip/opt 三个版本大小（字节与人类可读）；
- 节省百分比；
- 处理日志与命令行（便于审计）。

注意：
- `wasm-opt` 的激进优化可能与特定运行时行为有差异，需回归测试；
- 若使用调试信息定位问题，请保留名称段或单独产出带符号版本；
- 体积与启动存在权衡：极致压缩可能增加解压/编译时间。

## 启动时间对比（precompile-wasmtime）

步骤：
1. 使用 `wasmtime compile` 生成 cwasm（预编译）；
2. 多次迭代对比“直接运行 vs 预编译运行”；
3. 输出 ns/ms 两种单位的统计（min/avg）。

运行：

```bash
cd examples/ch07/precompile-wasmtime
ITER=30 WARMUP=5 bash run.sh
cat out/report.md
```

注意：
- 已在脚本中自动探测 `--allow-precompiled` 并静默冗余输出；
- 确保安装 wasmtime 与 wasm-tools，详见 [examples/README.md](https://github.com/Thneoly/beyond-wasm/blob/main/examples/README.md)。
 - 噪声控制：固定 CPU 频率/性能模式、避免后台进程、进行多次迭代取 min/avg。

边界：
- 预编译产物与目标机器/wasmtime 版本绑定，跨机分发需兼容策略；
- 热端路径可能受 I/O 或宿主调度影响，分开测量纯计算与端到端。
