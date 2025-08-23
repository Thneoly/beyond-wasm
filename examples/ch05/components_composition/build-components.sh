#!/usr/bin/env bash
set -euo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/../../../" && pwd)
OUT_DIR="$HERE/out"

mkdir -p "$OUT_DIR"

build_one() {
  local dir="$1" name="$2"
  echo "==> Building $name (core wasm)"
  (cd "$dir" && rustup target add wasm32-wasi >/dev/null 2>&1 || true && cargo build --release --target wasm32-wasi)
  local core_wasm="$dir/target/wasm32-wasi/release/${name}.wasm"
  local comp_wasm="$OUT_DIR/${name}.component.wasm"
  if [[ ! -f "$core_wasm" ]]; then
    echo "Build failed: $core_wasm not found" >&2; exit 1;
  fi
  echo "==> Componentizing $name"
  wasm-tools component new "$core_wasm" -o "$comp_wasm"
  echo "-- WIT for $name --"
  wasm-tools component wit "$comp_wasm" | sed -n '1,120p'
}

build_one "$HERE/add_component" "add_component"
build_one "$HERE/inc_component" "inc_component"
build_one "$HERE/glue_component" "glue_component"

echo "All components written to: $OUT_DIR"
