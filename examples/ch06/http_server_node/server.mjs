import http from 'node:http';
import { readFile } from 'node:fs/promises';
import { URL } from 'node:url';

let wasmInstance;
let add;

async function initWasm() {
  const wasm = await readFile(new URL('./wasm/add.wasm', import.meta.url));
  const { instance } = await WebAssembly.instantiate(wasm, {});
  wasmInstance = instance;
  add = wasmInstance.exports.add;
  if (typeof add !== 'function') {
    throw new Error('WASM export "add" not found');
  }
}

const port = Number(process.env.PORT || 8787);

function handler(req, res) {
  const url = new URL(req.url, `http://${req.headers.host}`);

  if (req.method === 'GET' && url.pathname === '/') {
    res.writeHead(200, { 'content-type': 'text/plain; charset=utf-8' });
    res.end('Wasm HTTP demo. Try /add?a=1&b=2');
    return;
  }

  if (req.method === 'GET' && url.pathname === '/add') {
    const aStr = url.searchParams.get('a');
    const bStr = url.searchParams.get('b');
    const a = Number.parseInt(aStr ?? '', 10);
    const b = Number.parseInt(bStr ?? '', 10);
    if (!Number.isInteger(a) || !Number.isInteger(b)) {
      res.writeHead(400, { 'content-type': 'application/json; charset=utf-8' });
      res.end(JSON.stringify({ error: 'query params a,b are required integers' }));
      return;
    }
    const result = (add(a | 0, b | 0) | 0);
    res.writeHead(200, { 'content-type': 'application/json; charset=utf-8' });
    res.end(JSON.stringify({ a, b, result }));
    return;
  }

  res.writeHead(404, { 'content-type': 'application/json; charset=utf-8' });
  res.end(JSON.stringify({ error: 'not found' }));
}

initWasm()
  .then(() => {
    http.createServer(handler).listen(port, () => {
      console.log(`HTTP server listening on http://localhost:${port}`);
    });
  })
  .catch((err) => {
    console.error('Failed to init WASM', err);
    process.exit(1);
  });
