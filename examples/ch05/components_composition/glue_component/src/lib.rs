use wit_bindgen::generate;

generate!({
    path: "wit",
    world: "glue-world",
});

struct Component;

impl exports::demo::glue::api::Guest for Component {
    fn add_then_inc(a: i32, b: i32) -> i32 {
        let sum = imports::demo::add::math::add(a, b);
        imports::demo::inc::math2::inc(sum)
    }
}

export!(Component);
