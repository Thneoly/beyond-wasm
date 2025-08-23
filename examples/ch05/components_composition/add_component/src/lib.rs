use wit_bindgen::generate;

generate!({
    path: "wit",
    world: "add-world",
});

struct Component;

impl exports::demo::add::math::Guest for Component {
    fn add(a: i32, b: i32) -> i32 {
        a + b
    }
}

export!(Component);
