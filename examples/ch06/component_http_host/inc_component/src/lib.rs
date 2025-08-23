wit_bindgen::generate!("wit");

struct Component;

impl exports::demo::inc::math2::Guest for Component {
    fn inc(x: i32) -> i32 {
        x.saturating_add(1)
    }
}

export!(Component);
