#!/usr/bin/env bash
set -euo pipefail

# Wrap the ch03 WASI core module as a component using wasm-tools.
# Prereqs: build ch03 first, and install wasm-tools (cargo install wasm-tools)

HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/../../../" && pwd)

WASM_CORE="$ROOT/examples/ch03/rust_wasm_wasmtime/target/wasm32-wasi/release/rust_wasm_wasmtime.wasm"
WASM_INC="$ROOT/examples/ch05/components_composition/core_inc/target/wasm32-wasi/release/core_inc.wasm"
OUT_DIR="$HERE/out"
OUT_COMP_CORE="$OUT_DIR/rust_wasm_wasmtime.component.wasm"
OUT_COMP_INC="$OUT_DIR/core_inc.component.wasm"

if [[ ! -f "$WASM_CORE" ]]; then
  echo "Core wasm not found: $WASM_CORE" >&2
  echo "Build it first: (cd examples/ch03/rust_wasm_wasmtime && rustup target add wasm32-wasi && cargo build --release --target wasm32-wasi)" >&2
  exit 1
fi

mkdir -p "$OUT_DIR"

echo "Wrapping core (add) module into a component..."
wasm-tools component new "$WASM_CORE" -o "$OUT_COMP_CORE"
echo "Component written to: $OUT_COMP_CORE"
echo "Extracting WIT (add):"
wasm-tools component wit "$OUT_COMP_CORE" | sed -n '1,120p'

if [[ -f "$WASM_INC" ]]; then
  echo "Wrapping inc module into a component..."
  wasm-tools component new "$WASM_INC" -o "$OUT_COMP_INC"
  echo "Component written to: $OUT_COMP_INC"
  echo "Extracting WIT (inc):"
  wasm-tools component wit "$OUT_COMP_INC" | sed -n '1,120p'
else
  echo "(optional) You can build inc: (cd examples/ch05/components_composition/core_inc && rustup target add wasm32-wasi && cargo build --release --target wasm32-wasi)"
fi
