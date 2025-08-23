#!/usr/bin/env bash
set -euo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)
OUT="$HERE/out"
mkdir -p "$OUT"

# deps check
command -v wasm-tools >/dev/null 2>&1 || { echo "error: wasm-tools not found" >&2; exit 127; }

echo "[1/5] build base wasm from .wat"
wasm-tools parse "$HERE/add.wat" -o "$OUT/add.base.wasm"

echo "[2/5] strip custom sections (names)"
cp "$OUT/add.base.wasm" "$OUT/add.strip.wasm"
wasm-tools strip "$OUT/add.strip.wasm" -o "$OUT/add.strip.wasm" || true

echo "[3/5] wasm-opt (-Oz) if available"
USED_WASM_OPT=no
if command -v wasm-opt >/dev/null 2>&1; then
  wasm-opt -Oz "$OUT/add.strip.wasm" -o "$OUT/add.opt.wasm"
  USED_WASM_OPT=yes
else
  cp "$OUT/add.strip.wasm" "$OUT/add.opt.wasm"
fi

# size helpers
size_bytes() {
  if stat -f%z "$1" >/dev/null 2>&1; then
    stat -f%z "$1"
  elif stat -c%s "$1" >/dev/null 2>&1; then
    stat -c%s "$1"
  else
    wc -c < "$1"
  fi
}

human() { # bytes -> human readable
  local b=$1
  awk -v b="$b" 'BEGIN{u[1]="B";u[2]="KB";u[3]="MB";u[4]="GB";i=1;while(b>=1024&&i<4){b/=1024;i++} printf "%.2f %s", b,u[i]}'
}

percent() { # (new, base)
  awk -v n="$1" -v b="$2" 'BEGIN{ if(b==0){print "0.00"} else { printf "%.2f", (1-n/b)*100 } }'
}

echo "[4/5] sizes"
ls -lh "$OUT" | sed -n '1,200p'

echo "[5/5] report -> $OUT/report.md"
BASE_B=$(size_bytes "$OUT/add.base.wasm")
STRIP_B=$(size_bytes "$OUT/add.strip.wasm")
OPT_B=$(size_bytes "$OUT/add.opt.wasm")

BASE_H=$(human "$BASE_B")
STRIP_H=$(human "$STRIP_B")
OPT_H=$(human "$OPT_B")

P_STRIP=$(percent "$STRIP_B" "$BASE_B")
P_OPT=$(percent "$OPT_B" "$BASE_B")

wasmtools_ver=$(wasm-tools --version 2>/dev/null | head -n1 || echo "unknown")
wasmopt_ver=$(command -v wasm-opt >/dev/null 2>&1 && wasm-opt --version 2>/dev/null | head -n1 || echo "not-installed")
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ" || echo "unknown-time")

cat > "$OUT/report.md" <<EOF
# WASM 体积对比报告

- 时间: $timestamp
- wasm-tools: $wasmtools_ver
- wasm-opt: $wasmopt_ver (used: $USED_WASM_OPT)

## 文件大小

| 版本 | 字节 | 人类可读 | 相对原始体积节省 |
|---|---:|---:|---:|
| base | $BASE_B | $BASE_H | - |
| strip | $STRIP_B | $STRIP_H | $P_STRIP% |
| opt | $OPT_B | $OPT_H | $P_OPT% |

> 注：strip 去除自定义段，opt 依赖 Binaryen 的 wasm-opt -Oz；若未安装则与 strip 相同。

## 复现

```bash
cd examples/ch07/size-opt
bash run.sh
open out/report.md # macOS 可用
```
EOF
