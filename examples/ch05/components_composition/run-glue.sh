#!/usr/bin/env bash
set -euo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)
OUT_DIR="$HERE/out"

# Preferred: cargo-component output
CARGO_COMP="$HERE/glue_component/target/wasm32-wasi/release/glue_component.component.wasm"
# Fallbacks: componentized glue or composed add+inc
GLUE_COMP="$OUT_DIR/glue_component.component.wasm"
COMPOSED_COMP="$OUT_DIR/add_inc.component.wasm"

COMP=""
if [[ -f "$CARGO_COMP" ]]; then COMP="$CARGO_COMP";
elif [[ -f "$GLUE_COMP" ]]; then COMP="$GLUE_COMP";
elif [[ -f "$COMPOSED_COMP" ]]; then COMP="$COMPOSED_COMP";
else
  echo "No component found. Build one of the following first:" >&2
  echo "  cargo component build -p glue_component" >&2
  echo "  or: bash build-components.sh && bash compose-add-inc.sh" >&2
  exit 1
fi

A=${1:-2}
B=${2:-3}

if ! command -v wasmtime >/dev/null 2>&1; then
  echo "wasmtime not found. Install via 'cargo install wasmtime-cli' or system package manager." >&2
  exit 1
fi

echo "Using component: $COMP"
echo "Args: A=$A B=$B"

# Try multiple invocation name variants (depends on how the export is surfaced)
NAMES=(
  "add-then-inc"
  "demo:glue/api.add-then-inc"
  "demo:glue/api#add-then-inc"
)

for name in "${NAMES[@]}"; do
  echo "Trying --invoke $name ..."
  if wasmtime run --invoke "$name" "$COMP" "$A" "$B"; then
    exit 0
  fi
done

echo "All invocation variants failed. Export names may differ. Inspect WIT:"
wasm-tools component wit "$COMP" | sed -n '1,160p'
exit 2
