#!/usr/bin/env bash
set -euo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)

echo "[1/3] build business component (cargo-component)"
(
  cd "$HERE/business_component"
  if ! command -v cargo-component >/dev/null 2>&1; then
    echo "error: cargo-component not found. Install: cargo install cargo-component" >&2
    exit 127
  fi
  cargo component build --release
)

echo "[2/3] build host (cargo)"
(
  cd "$HERE"
  cargo build --release -p component_http_host
)

echo "[3/3] run host"
COMP=${COMPONENT_PATH:-}
if [[ -z "${COMP}" ]]; then
  if [[ "${GLUE:-0}" == "1" ]]; then
    if [[ -f "$HERE/out/glue_composed.component.wasm" ]]; then
      COMP="$HERE/out/glue_composed.component.wasm"
    else
      COMP="$HERE/glue_component/target/wasm32-wasi/release/glue_component.wasm"
    fi
  else
    COMP="$HERE/business_component/target/wasm32-wasi/release/business_component.wasm"
  fi
fi
COMPONENT_PATH="$COMP" "$HERE/host/../target/release/component_http_host"
