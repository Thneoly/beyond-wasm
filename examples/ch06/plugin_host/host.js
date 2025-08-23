// Minimal plugin host: load a core wasm plugin and call add()
const fs = require('node:fs');

async function main() {
  const wasmPath = process.argv[2] || 'plugins/add.wasm';
  const a = Number(process.argv[3] || 2);
  const b = Number(process.argv[4] || 3);
  const buf = fs.readFileSync(wasmPath);
  const { instance } = await WebAssembly.instantiate(buf, {});
  if (typeof instance.exports.add !== 'function') {
    throw new Error('Plugin must export add(i32,i32)->i32');
  }
  console.log(instance.exports.add(a, b));
}

main().catch((e)=>{ console.error(e); process.exit(1); });
