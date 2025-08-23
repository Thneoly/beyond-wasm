// Compose two core WASM modules at the host level: add(a,b) then inc(x)
// Usage: node host-compose.js <add_wasm> <inc_wasm> <a> <b>
// Defaults resolve to built artifacts from ch03 and core_inc.
const fs = require('node:fs');

async function instantiate(path) {
  const buf = fs.readFileSync(path);
  // Try without imports first; these cores shouldn't require WASI if they don't use I/O
  return WebAssembly.instantiate(buf, {});
}

async function main() {
  const addPath = process.argv[2] || '../../ch03/rust_wasm_wasmtime/target/wasm32-wasi/release/rust_wasm_wasmtime.wasm';
  const incPath = process.argv[3] || './core_inc/target/wasm32-wasi/release/core_inc.wasm';
  const a = Number(process.argv[4] || 2);
  const b = Number(process.argv[5] || 3);

  const addMod = await instantiate(addPath);
  const incMod = await instantiate(incPath);

  const add = addMod.instance.exports.add;
  const inc = incMod.instance.exports.inc;

  if (typeof add !== 'function' || typeof inc !== 'function') {
    throw new Error('Missing expected exports: add/inc');
  }

  const sum = add(a, b);
  const result = inc(sum);
  console.log(JSON.stringify({ a, b, sum, result }));
}

main().catch((e) => { console.error(e); process.exit(1); });
