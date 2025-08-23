#!/usr/bin/env bash
set -euo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)
OUT="$HERE/out"
mkdir -p "$OUT"

# Config
ITER=${ITER:-20}
WARMUP=${WARMUP:-3}

# Deps check
command -v wasm-tools >/dev/null 2>&1 || { echo "error: wasm-tools not found" >&2; exit 127; }
command -v wasmtime   >/dev/null 2>&1 || { echo "error: wasmtime not found"   >&2; exit 127; }

# Cross-platform monotonic ns
now_ns() {
	if command -v python3 >/dev/null 2>&1; then
		python3 - <<'PY'
import time; print(time.perf_counter_ns())
PY
	elif command -v node >/dev/null 2>&1; then
		node -e 'console.log(process.hrtime.bigint().toString())'
	elif command -v gdate >/dev/null 2>&1; then
		gdate +%s%N
	else
		# Best-effort on BSD date (macOS): not strictly ns, but keep the interface
		date +%s000000000
	fi
}

measure_ns() { # cmd...
	local start end
	start=$(now_ns)
	"$@" >/dev/null 2>&1
	end=$(now_ns)
	echo $((end-start))
}

avg_min() { # reads ns values from stdin
	awk 'BEGIN{min=0;sum=0;cnt=0} {v=$1; if (cnt==0||v<min) min=v; sum+=v; cnt++} END{ if (cnt>0) printf "%d %d\n", sum/cnt, min; else print "0 0" }'
}

echo "[1/6] build wasm"
wasm-tools parse "$HERE/add.wat" -o "$OUT/add.wasm"

echo "[2/6] warmup direct ($WARMUP)"
# quiet flag if available (use long form to avoid ambiguity)
QUIET_FLAG=""
if wasmtime run --help 2>/dev/null | grep -q -- "--quiet"; then
	QUIET_FLAG="--quiet"
fi
for ((i=0;i<WARMUP;i++)); do wasmtime run $QUIET_FLAG --invoke add "$OUT/add.wasm" 1 2 >/dev/null 2>&1; done

echo "[3/6] measure direct ($ITER)"
direct_file="$OUT/direct.ns"
: > "$direct_file"
for ((i=0;i<ITER;i++)); do
	measure_ns wasmtime run $QUIET_FLAG --invoke add "$OUT/add.wasm" 1 2 >>"$direct_file"
done
read DIRECT_AVG DIRECT_MIN < <(avg_min < "$direct_file")

echo "[4/6] precompile"
wasmtime compile "$OUT/add.wasm" -o "$OUT/add.cwasm"

echo "[5/6] warmup precompiled ($WARMUP)"
# Wasmtime 17+ 运行预编译模块可能需要 --allow-precompiled
ALLOW_FLAG=""
if wasmtime run --help 2>/dev/null | grep -q -- "--allow-precompiled"; then
	ALLOW_FLAG="--allow-precompiled"
fi
for ((i=0;i<WARMUP;i++)); do wasmtime run $QUIET_FLAG $ALLOW_FLAG --invoke add "$OUT/add.cwasm" 1 2 >/dev/null 2>&1; done

echo "[6/6] measure precompiled ($ITER)"
pre_file="$OUT/pre.ns"
: > "$pre_file"
for ((i=0;i<ITER;i++)); do
	measure_ns wasmtime run $QUIET_FLAG $ALLOW_FLAG --invoke add "$OUT/add.cwasm" 1 2 >>"$pre_file"
done
read PRE_AVG PRE_MIN < <(avg_min < "$pre_file")

printf "\nReport (ns):\n"
printf "  direct:      avg=%d  min=%d\n" "$DIRECT_AVG" "$DIRECT_MIN"
printf "  precompiled: avg=%d  min=%d\n" "$PRE_AVG"   "$PRE_MIN"

# Markdown report
wasmtime_ver=$(wasmtime --version | head -n1 || true)
wasmtools_ver=$(wasm-tools --version 2>/dev/null | head -n1 || echo "unknown")
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ" || echo "unknown-time")
ns_to_ms() { awk -v v="$1" 'BEGIN{printf "%.3f", v/1000000.0}'; }
DIRECT_AVG_MS=$(ns_to_ms "$DIRECT_AVG")
DIRECT_MIN_MS=$(ns_to_ms "$DIRECT_MIN")
PRE_AVG_MS=$(ns_to_ms "$PRE_AVG")
PRE_MIN_MS=$(ns_to_ms "$PRE_MIN")

cat > "$OUT/report.md" <<EOF
# Wasmtime 预编译对比报告

- 时间: $timestamp
- 迭代: ITER=$ITER, WARMUP=$WARMUP
- wasmtime: $wasmtime_ver
- wasm-tools: $wasmtools_ver

## 结果

| 模式 | avg (ns) | min (ns) | avg (ms) | min (ms) |
|---|---:|---:|---:|---:|
| direct | $DIRECT_AVG | $DIRECT_MIN | $DIRECT_AVG_MS | $DIRECT_MIN_MS |
| precompiled | $PRE_AVG | $PRE_MIN | $PRE_AVG_MS | $PRE_MIN_MS |

> 注：数据为近似对比，受本机负载影响；更稳定的对比可增大 ITER 并固定环境。

## 复现

```bash
cd examples/ch07/precompile-wasmtime
ITER=$ITER WARMUP=$WARMUP bash run.sh
open out/report.md # macOS 可用
```
EOF
