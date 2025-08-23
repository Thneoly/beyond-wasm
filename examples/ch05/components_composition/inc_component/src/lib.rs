use wit_bindgen::generate;

generate!({
    path: "wit",
    world: "inc-world",
});

struct Component;

impl exports::demo::inc::math2::Guest for Component {
    fn inc(x: i32) -> i32 {
        x + 1
    }
}

export!(Component);
