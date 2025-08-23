wit_bindgen::generate!("wit");

struct Component;

impl exports::demo::glue::api::Guest for Component {
    fn add_then_inc(a: i32, b: i32) -> i32 {
        let s = imports::demo::add::math::add(a, b);
        imports::demo::inc::math2::inc(s)
    }
}

export!(Component);
