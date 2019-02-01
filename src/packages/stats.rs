use rhai::{Engine, Array, Dynamic};

pub fn register(engine: &mut Engine) {
    engine.register_fn("calc_mean", |arr: Array| -> f64 {
        let mut sum = 0.0;
        let mut count = 0.0;
        for val in arr {
            if let Ok(num) = val.as_float() {
                sum += num;
                count += 1.0;
            } else if let Ok(num) = val.as_int() {
                sum += num as f64;
                count += 1.0;
            }
        }
        if count > 0.0 { sum / count } else { 0.0 }
    });

    engine.register_fn("calc_variance", |arr: Array| -> f64 {
        let mut count = 0.0;
        let mut mean = 0.0;
        let mut m2 = 0.0;

        for val in arr {
            let num = if let Ok(n) = val.as_float() {
                n
            } else if let Ok(n) = val.as_int() {
                n as f64
            } else {
                continue;
            };

            count += 1.0;
            let delta = num - mean;
            mean += delta / count;
            let delta2 = num - mean;
            m2 += delta * delta2;
        }

        if count > 1.0 { m2 / (count - 1.0) } else { 0.0 }
    });

    engine.register_fn("calc_stddev", |arr: Array| -> f64 {
        let var: f64 = engine_calc_variance(&arr);
        var.sqrt()
    });
}

fn engine_calc_variance(arr: &[Dynamic]) -> f64 {
    let mut count = 0.0;
    let mut mean = 0.0;
    let mut m2 = 0.0;

    for val in arr {
        let num = if let Ok(n) = val.as_float() {
            n
        } else if let Ok(n) = val.as_int() {
            n as f64
        } else {
            continue;
        };

        count += 1.0;
        let delta = num - mean;
        mean += delta / count;
        let delta2 = num - mean;
        m2 += delta * delta2;
    }

    if count > 1.0 { m2 / (count - 1.0) } else { 0.0 }
}
