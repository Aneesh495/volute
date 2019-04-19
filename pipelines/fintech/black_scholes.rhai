/*
 * Black-Scholes European Option Pricing and Greeks Model
 *
 * Implements analytical option pricing formula and first/second order Greeks.
 */

import "lib/stats/distributions" as dist;

// Calculate d1 and d2 parameters
fn calculate_d1_d2(spot, strike, risk_free_r, vol_sigma, time_t) {
    let s = spot * 1.0;
    let k = strike * 1.0;
    let r = risk_free_r * 1.0;
    let sigma = vol_sigma * 1.0;
    let t = time_t * 1.0;

    let numerator = (s / k).ln() + (r + 0.5 * sigma * sigma) * t;
    let denom = sigma * t.sqrt();

    let d1 = numerator / denom;
    let d2 = d1 - denom;

    return [d1, d2];
}

// Calculate European Call option premium
fn call_price(spot, strike, risk_free_r, vol_sigma, time_t) {
    let s = spot * 1.0;
    let k = strike * 1.0;
    let r = risk_free_r * 1.0;
    let t = time_t * 1.0;

    let d_vals = calculate_d1_d2(s, k, r, vol_sigma, t);
    let d1 = d_vals[0];
    let d2 = d_vals[1];

    let nd1 = dist::normal_cdf(d1, 0.0, 1.0);
    let nd2 = dist::normal_cdf(d2, 0.0, 1.0);

    let discount = (-r * t).exp();
    return s * nd1 - k * discount * nd2;
}

// Calculate European Put option premium via Put-Call Parity
fn put_price(spot, strike, risk_free_r, vol_sigma, time_t) {
    let s = spot * 1.0;
    let k = strike * 1.0;
    let r = risk_free_r * 1.0;
    let t = time_t * 1.0;

    let c_val = call_price(s, k, r, vol_sigma, t);
    let discount = (-r * t).exp();
    return c_val + k * discount - s;
}

// Compute option Delta Greek
fn option_delta(spot, strike, risk_free_r, vol_sigma, time_t, is_call) {
    let d_vals = calculate_d1_d2(spot, strike, risk_free_r, vol_sigma, time_t);
    let nd1 = dist::normal_cdf(d_vals[0], 0.0, 1.0);
    if is_call {
        return nd1;
    } else {
        return nd1 - 1.0;
    }
}

// Compute option Gamma Greek
fn option_gamma(spot, strike, risk_free_r, vol_sigma, time_t) {
    let s = spot * 1.0;
    let sigma = vol_sigma * 1.0;
    let t = time_t * 1.0;
    let d_vals = calculate_d1_d2(s, strike, risk_free_r, sigma, t);
    let np_d1 = dist::normal_pdf(d_vals[0], 0.0, 1.0);
    return np_d1 / (s * sigma * t.sqrt());
}
