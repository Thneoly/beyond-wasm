use spin_sdk::http::{Request, Response};
use spin_sdk::http_component;

#[http_component]
fn handle_http(req: Request) -> anyhow::Result<Response> {
    let (path, query) = split_path_query(
        req.uri()
            .path_and_query()
            .map(|pq| pq.as_str())
            .unwrap_or("/"),
    );
    match path {
        "/" => Ok(Response::builder()
            .status(200)
            .header("content-type", "text/plain; charset=utf-8")
            .body("hello from spin + wasi http".into())?),
        "/add" => {
            let (a, b) = parse_ab(query).ok_or_else(|| anyhow::anyhow!("invalid query"))?;
            let result = a.saturating_add(b);
            let body = serde_json::json!({ "a": a, "b": b, "result": result }).to_string();
            Ok(Response::builder()
                .status(200)
                .header("content-type", "application/json; charset=utf-8")
                .body(body.into())?)
        }
        _ => Ok(Response::builder()
            .status(404)
            .header("content-type", "application/json; charset=utf-8")
            .body("{\"error\":\"not found\"}".into())?),
    }
}

fn split_path_query(pq: &str) -> (&str, &str) {
    if let Some(i) = pq.find('?') {
        (&pq[..i], &pq[i + 1..])
    } else {
        (pq, "")
    }
}

fn parse_ab(query: &str) -> Option<(i64, i64)> {
    let mut a: Option<i64> = None;
    let mut b: Option<i64> = None;
    for pair in query.split('&') {
        let mut it = pair.splitn(2, '=');
        let k = it.next()?;
        let v = it.next().unwrap_or("");
        match k {
            "a" => a = v.parse::<i64>().ok(),
            "b" => b = v.parse::<i64>().ok(),
            _ => {}
        }
    }
    match (a, b) {
        (Some(a), Some(b)) => Some((a, b)),
        _ => None,
    }
}
