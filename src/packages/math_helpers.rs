use rhai::Engine;

pub fn register(engine: &mut Engine) {
    engine.register_fn("atan2", |y: f64, x: f64| -> f64 {
        y.atan2(x)
    });

    engine.register_fn("sin", |x: f64| -> f64 {
        x.sin()
    });

    engine.register_fn("cos", |x: f64| -> f64 {
        x.cos()
    });

    engine.register_fn("sqrt", |x: f64| -> f64 {
        x.sqrt()
    });

    engine.register_fn("ln", |x: f64| -> f64 {
        x.ln()
    });
}
