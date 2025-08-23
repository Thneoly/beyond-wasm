use anyhow::{Context, Result};
use std::env;
use std::path::PathBuf;
use std::sync::{Arc, Mutex};
use tiny_http::{Request, Response, Server};
use wasmtime::component::{Component, Linker};
use wasmtime::{Engine, Store};

// Host 侧绑定（与组件的 WIT 对齐）
wasmtime::component::bindgen!(path = "wit", world = "add-world");
wasmtime::component::bindgen!(path = "wit", world = "glue-world");
wasmtime::component::bindgen!(path = "wit", world = "inc-world");

struct Shared {
    engine: Engine,
    linker: Linker<()>,
    add_component: Component,
    inc_component: Option<Component>,
    pool: StorePool,
    dual_mode: bool,
}

struct StorePool {
    inner: Mutex<Vec<Store<()>>>,
    cap: usize,
}

impl StorePool {
    fn new(cap: usize) -> Self {
        Self {
            inner: Mutex::new(Vec::with_capacity(cap)),
            cap,
        }
    }
    fn get(&self, engine: &Engine) -> Store<()> {
        let mut g = self.inner.lock().unwrap();
        g.pop().unwrap_or_else(|| Store::new(engine, ()))
    }
    fn put(&self, store: Store<()>) {
        let mut g = self.inner.lock().unwrap();
        if g.len() < self.cap {
            g.push(store);
        }
    }
}

fn main() -> Result<()> {
    // 1) 引擎与链接器（常驻）
    let engine = Engine::default();
    let linker: Linker<()> = Linker::new(&engine);

    // 2) 组件路径
    let default_add =
        PathBuf::from("./business_component/target/wasm32-wasi/release/business_component.wasm");
    let add_path = env::var("COMPONENT_PATH")
        .map(PathBuf::from)
        .unwrap_or(default_add);

    let dual_mode = env::var("DUAL_COMPONENTS").ok().as_deref() == Some("1");
    let default_inc =
        PathBuf::from("./inc_component/target/wasm32-wasi/release/inc_component.wasm");
    let inc_path = env::var("INC_COMPONENT_PATH")
        .map(PathBuf::from)
        .unwrap_or(default_inc);

    // 3) 加载组件
    let add_component = Component::from_file(&engine, &add_path)
        .with_context(|| format!("failed to load add/glue component: {}", add_path.display()))?;
    let inc_component = if dual_mode {
        match Component::from_file(&engine, &inc_path) {
            Ok(c) => Some(c),
            Err(e) => {
                eprintln!(
                    "[warn] DUAL_COMPONENTS=1 but failed to load inc component at {}: {e:#}",
                    inc_path.display()
                );
                None
            }
        }
    } else {
        None
    };

    let pool = StorePool::new(
        env::var("POOL_SIZE")
            .ok()
            .and_then(|v| v.parse().ok())
            .unwrap_or(4),
    );
    let shared = Arc::new(Shared {
        engine,
        linker,
        add_component,
        inc_component,
        pool,
        dual_mode,
    });

    // 4) HTTP 服务
    let server = Server::http("127.0.0.1:7878").context("failed to bind 127.0.0.1:7878")?;
    eprintln!("HTTP listening on http://127.0.0.1:7878");
    for mut req in server.incoming_requests() {
        if let Err(err) = handle_request(shared.clone(), &mut req) {
            let _ = req.respond(
                Response::from_string(format!("Internal error: {err:#}")).with_status_code(500),
            );
        }
    }
    Ok(())
}

fn handle_request(shared: Arc<Shared>, req: &mut Request) -> Result<()> {
    let url = req.url().to_string();
    let (path, query) = split_path_query(&url);
    match (req.method(), path) {
        (m, "/") if m.as_str() == "GET" => {
            let resp = Response::from_string(
                "component http host: try /add?a=1&b=2 or /add-then-inc?a=1&b=2",
            )
            .with_status_code(200)
            .with_header("content-type: text/plain; charset=utf-8".parse().unwrap());
            req.respond(resp)?;
        }
        (m, "/add") if m.as_str() == "GET" => {
            let (a, b) = parse_ab(query).ok_or_else(|| anyhow::anyhow!("invalid query"))?;
            let mut store = shared.pool.get(&shared.engine);
            let addw = AddWorld::instantiate(&mut store, &shared.add_component, &shared.linker)
                .context("instantiate add component failed")?;
            let result = addw.call_add(&mut store, a, b).context("call add failed")?;
            let body = format!("{{\"a\":{a},\"b\":{b},\"result\":{result}}}");
            let resp = Response::from_string(body)
                .with_status_code(200)
                .with_header(
                    "content-type: application/json; charset=utf-8"
                        .parse()
                        .unwrap(),
                );
            req.respond(resp)?;
            shared.pool.put(store);
        }
        (m, "/add-then-inc") if m.as_str() == "GET" => {
            let (a, b) = parse_ab(query).ok_or_else(|| anyhow::anyhow!("invalid query"))?;
            let mut store = shared.pool.get(&shared.engine);
            // 优先：如果 add_path 实际是 glue 组件（WIT: glue-world），直接调用
            if let Ok(glue) =
                GlueWorld::instantiate(&mut store, &shared.add_component, &shared.linker)
            {
                let v = glue
                    .call_add_then_inc(&mut store, a, b)
                    .context("call add-then-inc failed")?;
                let body = format!("{{\"a\":{a},\"b\":{b},\"result\":{v}}}");
                let resp = Response::from_string(body)
                    .with_status_code(200)
                    .with_header(
                        "content-type: application/json; charset=utf-8"
                            .parse()
                            .unwrap(),
                    );
                req.respond(resp)?;
            } else if shared.dual_mode {
                // 其次：DUAL_COMPONENTS=1 时，分别调用 add 与 inc 两个组件
                let addw = AddWorld::instantiate(&mut store, &shared.add_component, &shared.linker)
                    .context("instantiate add component failed")?;
                let sum = addw.call_add(&mut store, a, b).context("call add failed")?;
                if let Some(inc_comp) = &shared.inc_component {
                    let incw = IncWorld::instantiate(&mut store, inc_comp, &shared.linker)
                        .context("instantiate inc component failed")?;
                    let v = incw.call_inc(&mut store, sum).context("call inc failed")?;
                    let body = format!("{{\"a\":{a},\"b\":{b},\"result\":{v}}}");
                    let resp = Response::from_string(body)
                        .with_status_code(200)
                        .with_header(
                            "content-type: application/json; charset=utf-8"
                                .parse()
                                .unwrap(),
                        );
                    req.respond(resp)?;
                } else {
                    let v = sum + 1; // inc 未加载，退化为 +1
                    let body = format!("{{\"a\":{a},\"b\":{b},\"result\":{v}}}");
                    let resp = Response::from_string(body)
                        .with_status_code(200)
                        .with_header(
                            "content-type: application/json; charset=utf-8"
                                .parse()
                                .unwrap(),
                        );
                    req.respond(resp)?;
                }
            } else {
                // 最后：简单回退 add + 1
                let addw = AddWorld::instantiate(&mut store, &shared.add_component, &shared.linker)
                    .context("instantiate add component failed")?;
                let v = addw.call_add(&mut store, a, b).context("call add failed")? + 1;
                let body = format!("{{\"a\":{a},\"b\":{b},\"result\":{v}}}");
                let resp = Response::from_string(body)
                    .with_status_code(200)
                    .with_header(
                        "content-type: application/json; charset=utf-8"
                            .parse()
                            .unwrap(),
                    );
                req.respond(resp)?;
            }
            shared.pool.put(store);
        }
        _ => {
            let resp = Response::from_string("{\"error\":\"not found\"}")
                .with_status_code(404)
                .with_header(
                    "content-type: application/json; charset=utf-8"
                        .parse()
                        .unwrap(),
                );
            req.respond(resp)?;
        }
    }
    Ok(())
}

fn split_path_query(pq: &str) -> (&str, &str) {
    if let Some(i) = pq.find('?') {
        (&pq[..i], &pq[i + 1..])
    } else {
        (pq, "")
    }
}

fn parse_ab(query: &str) -> Option<(i32, i32)> {
    let mut a: Option<i32> = None;
    let mut b: Option<i32> = None;
    for pair in query.split('&') {
        if pair.is_empty() {
            continue;
        }
        let mut it = pair.splitn(2, '=');
        let k = it.next()?;
        let v = it.next().unwrap_or("");
        match k {
            "a" => a = v.parse().ok(),
            "b" => b = v.parse().ok(),
            _ => {}
        }
    }
    match (a, b) {
        (Some(a), Some(b)) => Some((a, b)),
        _ => None,
    }
}
