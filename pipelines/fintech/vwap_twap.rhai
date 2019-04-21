/*
 * Volume-Weighted Average Price (VWAP) and TWAP Engine
 *
 * Tracks cumulative volume and time-weighted metrics over trading sessions.
 */

// Initialize VWAP/TWAP accumulator
fn new_vwap_accumulator() {
    return #{
        cumulative_volume: 0.0,
        cumulative_dollar_volume: 0.0,
        price_sum: 0.0,
        ticks_count: 0
    };
}

// Update with trade tick: price and volume; returns updated accumulator
fn update_vwap(acc, price, volume) {
    let p = price * 1.0;
    let v = volume * 1.0;

    acc.cumulative_volume += v;
    acc.cumulative_dollar_volume += p * v;
    acc.price_sum += p;
    acc.ticks_count += 1;

    return acc;
}

// Calculate current session VWAP
fn get_vwap(acc) {
    if acc.cumulative_volume <= 0.0 {
        return 0.0;
    }
    return acc.cumulative_dollar_volume / acc.cumulative_volume;
}

// Calculate current session simple TWAP
fn get_twap(acc) {
    if acc.ticks_count == 0 {
        return 0.0;
    }
    return acc.price_sum / (acc.ticks_count * 1.0);
}
