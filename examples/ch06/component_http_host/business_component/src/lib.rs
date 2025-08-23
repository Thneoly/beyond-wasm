wit_bindgen::generate!("wit");

struct Component;

impl exports::demo::add::math::Guest for Component {
    fn add(a: i32, b: i32) -> i32 {
        a.saturating_add(b)
    }
}

export!(Component);
