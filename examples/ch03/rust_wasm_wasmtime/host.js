// Optional host: load and invoke exported function using wasmtime via CLI is preferred.
// This placeholder shows how to call add() using WebAssembly JS APIs in Node.
const fs = require('node:fs');

async function main() {
  const wasmPath = process.argv[2] || 'target/wasm32-wasi/release/rust_wasm_wasmtime.wasm';
  const wasm = await WebAssembly.instantiate(fs.readFileSync(wasmPath), {});
  const { add } = wasm.instance.exports;
  const a = Number(process.argv[3] || 1);
  const b = Number(process.argv[4] || 2);
  console.log(add(a, b));
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
