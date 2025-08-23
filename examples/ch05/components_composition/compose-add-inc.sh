#!/usr/bin/env bash
set -euo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)
OUT_DIR="$HERE/out"
CORE_COMP="$OUT_DIR/rust_wasm_wasmtime.component.wasm"
INC_COMP="$OUT_DIR/core_inc.component.wasm"
OUT_COMP="$OUT_DIR/add_inc.component.wasm"

if [[ ! -f "$CORE_COMP" || ! -f "$INC_COMP" ]]; then
  echo "Required component(s) missing. Run componentize first:" >&2
  echo "  bash $HERE/componentize-ch03.sh" >&2
  exit 1
fi

echo "Composing components -> $OUT_COMP"
wasm-tools component compose "$CORE_COMP" "$INC_COMP" -o "$OUT_COMP"

echo "Composed component WIT:"
wasm-tools component wit "$OUT_COMP" | sed -n '1,160p'

echo "Done. Output: $OUT_COMP"
