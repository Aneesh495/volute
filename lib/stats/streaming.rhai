/*
 * Online Streaming Statistics and Moving Windows
 *
 * Implements Welford online mean/variance accumulator,
 * Exponentially Weighted Moving Average (EWMA), and Holt linear trends.
 */

// Initialize empty Welford state accumulator
fn new_welford() {
    return #{
        count: 0,
        mean: 0.0,
        m2: 0.0,
        min: 0.0,
        max: 0.0,
        is_init: false
    };
}

// Update Welford accumulator with new observation
fn update_welford(acc, x) {
    let val = x * 1.0;
    acc.count += 1;
    let delta = val - acc.mean;
    acc.mean += delta / (acc.count * 1.0);
    let delta2 = val - acc.mean;
    acc.m2 += delta * delta2;

    if !acc.is_init {
        acc.min = val;
        acc.max = val;
        acc.is_init = true;
    } else {
        if val < acc.min { acc.min = val; }
        if val > acc.max { acc.max = val; }
    }
    return acc;
}

// Get sample variance from Welford accumulator
fn get_variance(acc) {
    if acc.count < 2 {
        return 0.0;
    }
    return acc.m2 / ((acc.count - 1) * 1.0);
}

// Get standard deviation from Welford accumulator
fn get_stddev(acc) {
    return get_variance(acc).sqrt();
}

// Initialize EWMA state tracker
fn new_ewma(alpha) {
    return #{
        alpha: alpha,
        value: 0.0,
        is_init: false
    };
}

// Update EWMA tracker with observation
fn update_ewma(ewma, x) {
    let val = x * 1.0;
    if !ewma.is_init {
        ewma.value = val;
        ewma.is_init = true;
    } else {
        ewma.value = ewma.alpha * val + (1.0 - ewma.alpha) * ewma.value;
    }
    return ewma.value;
}

// Initialize Holt linear trend model
fn new_holt_trend(alpha, beta) {
    return #{
        alpha: alpha,
        beta: beta,
        level: 0.0,
        trend: 0.0,
        is_init: false
    };
}

// Update Holt linear trend model with observation
fn update_holt(holt, x) {
    let val = x * 1.0;
    if !holt.is_init {
        holt.level = val;
        holt.trend = 0.0;
        holt.is_init = true;
        return val;
    }
    let prev_level = holt.level;
    let prev_trend = holt.trend;
    holt.level = holt.alpha * val + (1.0 - holt.alpha) * (prev_level + prev_trend);
    holt.trend = holt.beta * (holt.level - prev_level) + (1.0 - holt.beta) * prev_trend;
    return holt.level + holt.trend;
}

// Forecast H steps ahead using Holt linear model
fn forecast_holt(holt, steps) {
    if !holt.is_init {
        return 0.0;
    }
    return holt.level + (steps * 1.0) * holt.trend;
}
