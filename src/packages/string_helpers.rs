use rhai::Engine;

pub fn register(engine: &mut Engine) {
    engine.register_fn("to_int", |s: &str| -> i64 {
        s.trim().parse::<i64>().unwrap_or(0)
    });

    engine.register_fn("to_float", |s: &str| -> f64 {
        s.trim().parse::<f64>().unwrap_or(0.0)
    });

    engine.register_fn("parse_int", |s: &str| -> i64 {
        s.trim().parse::<i64>().unwrap_or(0)
    });

    engine.register_fn("parse_float", |s: &str| -> f64 {
        s.trim().parse::<f64>().unwrap_or(0.0)
    });

    engine.set_fast_operators(false);
}
