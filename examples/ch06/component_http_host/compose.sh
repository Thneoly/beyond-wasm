#!/usr/bin/env bash
set -euo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)
OUT_DIR="$HERE/out"
mkdir -p "$OUT_DIR"

if ! command -v cargo-component >/dev/null 2>&1; then
  echo "error: cargo-component not found. Install: cargo install cargo-component" >&2
  exit 127
fi

echo "[1/4] build add component"
(
  cd "$HERE/business_component"
  cargo component build --release
)

echo "[2/4] build inc component"
(
  cd "$HERE/inc_component"
  cargo component build --release
)

echo "[3/4] build glue component"
(
  cd "$HERE/glue_component"
  cargo component build --release
)

ADD_COMP="$HERE/business_component/target/wasm32-wasi/release/business_component.wasm"
INC_COMP="$HERE/inc_component/target/wasm32-wasi/release/inc_component.wasm"
GLUE_COMP="$HERE/glue_component/target/wasm32-wasi/release/glue_component.wasm"

echo "[4/4] compose components (glue <- add, then <- inc)"
TMP_COMP="$OUT_DIR/glue_plus_add.component.wasm"
OUT_COMP="$OUT_DIR/glue_composed.component.wasm"

wasm-tools component compose "$GLUE_COMP" "$ADD_COMP" -o "$TMP_COMP"
wasm-tools component compose "$TMP_COMP" "$INC_COMP" -o "$OUT_COMP"

echo "Composed -> $OUT_COMP"
echo "Composed WIT preview:"
wasm-tools component wit "$OUT_COMP" | sed -n '1,200p'

echo
echo "Artifacts:"
echo "  add:      $ADD_COMP"
echo "  inc:      $INC_COMP"
echo "  glue raw: $GLUE_COMP"
echo "  glue composed: $OUT_COMP"
