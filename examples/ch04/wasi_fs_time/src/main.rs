use std::env;
use std::fs;
use std::time::{SystemTime, UNIX_EPOCH};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Read target file path from args or default to sample.txt
    let path = env::args()
        .nth(1)
        .unwrap_or_else(|| "sample.txt".to_string());

    // Current time since UNIX epoch (requires WASI clock capability; allowed by default in Wasmtime)
    let now = SystemTime::now().duration_since(UNIX_EPOCH)?;
    println!("epoch_seconds={}", now.as_secs());

    // Read file content (requires preopened dir: e.g., --dir=.)
    let content = fs::read_to_string(&path)?;
    println!("file={} bytes={}", path, content.len());
    println!("--- BEGIN ---\n{}\n--- END ---", content);

    Ok(())
}
