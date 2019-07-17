// Volute Pipeline: Options Greeks and Volatility Surface Engine
// Production-grade Black-Scholes analytical pricer, Greeks suite, implied volatility solver,
// volatility smile interpolation (SVI and cubic splines), and multi-leg risk aggregation.

import "lib/core/math" as m;

// -----------------------------------------------------------------------------
// Core Normal Distribution Functions
// -----------------------------------------------------------------------------

fn standard_normal_pdf(x) {
    let pi_val = 3.141592653589793;
    let inv_sqrt_2pi = 0.3989422804014327;
    return inv_sqrt_2pi * (-0.5 * x * x).exp();
}

fn standard_normal_cdf(x) {
    // High-precision Abramowitz and Stegun 7.1.26 polynomial approximation
    let p = 0.2316419;
    let b1 = 0.319381530;
    let b2 = -0.356563782;
    let b3 = 1.781477937;
    let b4 = -1.821255978;
    let b5 = 1.330274429;
    
    let is_negative = x < 0.0;
    let abs_x = if is_negative { -x } else { x };
    
    let t = 1.0 / (1.0 + p * abs_x);
    let poly = t * (b1 + t * (b2 + t * (b3 + t * (b4 + t * b5))));
    let pdf_val = standard_normal_pdf(abs_x);
    let cdf = 1.0 - pdf_val * poly;
    
    if is_negative {
        return 1.0 - cdf;
    } else {
        return cdf;
    }
}

// -----------------------------------------------------------------------------
// Black-Scholes Formula and Analytical Derivatives (Greeks)
// -----------------------------------------------------------------------------

fn calc_d1(spot, strike, rate, div_yield, vol, time_to_expiry) {
    if time_to_expiry <= 0.0 || vol <= 0.0 || spot <= 0.0 || strike <= 0.0 {
        return 0.0;
    }
    let numerator = (spot / strike).ln() + (rate - div_yield + 0.5 * vol * vol) * time_to_expiry;
    let denominator = vol * time_to_expiry.sqrt();
    return numerator / denominator;
}

fn calc_d2(d1_val, vol, time_to_expiry) {
    return d1_val - vol * time_to_expiry.sqrt();
}

fn bs_price_call(spot, strike, rate, div_yield, vol, time_to_expiry) {
    if time_to_expiry <= 0.0 {
        let intrinsic = spot - strike;
        return if intrinsic > 0.0 { intrinsic } else { 0.0 };
    }
    let d1_val = calc_d1(spot, strike, rate, div_yield, vol, time_to_expiry);
    let d2_val = calc_d2(d1_val, vol, time_to_expiry);
    
    let discount_rate = (-rate * time_to_expiry).exp();
    let discount_div = (-div_yield * time_to_expiry).exp();
    
    let nd1 = standard_normal_cdf(d1_val);
    let nd2 = standard_normal_cdf(d2_val);
    
    return spot * discount_div * nd1 - strike * discount_rate * nd2;
}

fn bs_price_put(spot, strike, rate, div_yield, vol, time_to_expiry) {
    if time_to_expiry <= 0.0 {
        let intrinsic = strike - spot;
        return if intrinsic > 0.0 { intrinsic } else { 0.0 };
    }
    let d1_val = calc_d1(spot, strike, rate, div_yield, vol, time_to_expiry);
    let d2_val = calc_d2(d1_val, vol, time_to_expiry);
    
    let discount_rate = (-rate * time_to_expiry).exp();
    let discount_div = (-div_yield * time_to_expiry).exp();
    
    let n_minus_d1 = standard_normal_cdf(-d1_val);
    let n_minus_d2 = standard_normal_cdf(-d2_val);
    
    return strike * discount_rate * n_minus_d2 - spot * discount_div * n_minus_d1;
}

// -----------------------------------------------------------------------------
// First-Order Greeks
// -----------------------------------------------------------------------------

fn greeks_delta(is_call, spot, strike, rate, div_yield, vol, time_to_expiry) {
    if time_to_expiry <= 0.0 {
        if is_call {
            return if spot > strike { 1.0 } else { 0.0 };
        } else {
            return if spot < strike { -1.0 } else { 0.0 };
        }
    }
    let d1_val = calc_d1(spot, strike, rate, div_yield, vol, time_to_expiry);
    let discount_div = (-div_yield * time_to_expiry).exp();
    
    if is_call {
        return discount_div * standard_normal_cdf(d1_val);
    } else {
        return discount_div * (standard_normal_cdf(d1_val) - 1.0);
    }
}

fn greeks_vega(spot, strike, rate, div_yield, vol, time_to_expiry) {
    if time_to_expiry <= 0.0 || vol <= 0.0 {
        return 0.0;
    }
    let d1_val = calc_d1(spot, strike, rate, div_yield, vol, time_to_expiry);
    let discount_div = (-div_yield * time_to_expiry).exp();
    let pdf_val = standard_normal_pdf(d1_val);
    
    // Expressed per 1% change in volatility (standard industry scale)
    return spot * discount_div * pdf_val * time_to_expiry.sqrt() * 0.01;
}

fn greeks_theta(is_call, spot, strike, rate, div_yield, vol, time_to_expiry) {
    if time_to_expiry <= 0.0 {
        return 0.0;
    }
    let d1_val = calc_d1(spot, strike, rate, div_yield, vol, time_to_expiry);
    let d2_val = calc_d2(d1_val, vol, time_to_expiry);
    
    let discount_div = (-div_yield * time_to_expiry).exp();
    let discount_rate = (-rate * time_to_expiry).exp();
    let pdf_d1 = standard_normal_pdf(d1_val);
    
    let term1 = - (spot * discount_div * pdf_d1 * vol) / (2.0 * time_to_expiry.sqrt());
    
    let annual_theta = 0.0;
    if is_call {
        let term2 = div_yield * spot * discount_div * standard_normal_cdf(d1_val);
        let term3 = - rate * strike * discount_rate * standard_normal_cdf(d2_val);
        annual_theta = term1 + term2 + term3;
    } else {
        let term2 = - div_yield * spot * discount_div * standard_normal_cdf(-d1_val);
        let term3 = rate * strike * discount_rate * standard_normal_cdf(-d2_val);
        annual_theta = term1 + term2 + term3;
    }
    // Expressed per calendar day decay
    return annual_theta / 365.0;
}

fn greeks_rho(is_call, spot, strike, rate, div_yield, vol, time_to_expiry) {
    if time_to_expiry <= 0.0 {
        return 0.0;
    }
    let d1_val = calc_d1(spot, strike, rate, div_yield, vol, time_to_expiry);
    let d2_val = calc_d2(d1_val, vol, time_to_expiry);
    let discount_rate = (-rate * time_to_expiry).exp();
    
    // Expressed per 1% change in interest rates
    if is_call {
        return strike * time_to_expiry * discount_rate * standard_normal_cdf(d2_val) * 0.01;
    } else {
        return -strike * time_to_expiry * discount_rate * standard_normal_cdf(-d2_val) * 0.01;
    }
}

// -----------------------------------------------------------------------------
// Second-Order and Higher Greeks
// -----------------------------------------------------------------------------

fn greeks_gamma(spot, strike, rate, div_yield, vol, time_to_expiry) {
    if time_to_expiry <= 0.0 || vol <= 0.0 || spot <= 0.0 {
        return 0.0;
    }
    let d1_val = calc_d1(spot, strike, rate, div_yield, vol, time_to_expiry);
    let discount_div = (-div_yield * time_to_expiry).exp();
    let pdf_d1 = standard_normal_pdf(d1_val);
    
    return (discount_div * pdf_d1) / (spot * vol * time_to_expiry.sqrt());
}

fn greeks_vanna(spot, strike, rate, div_yield, vol, time_to_expiry) {
    if time_to_expiry <= 0.0 || vol <= 0.0 {
        return 0.0;
    }
    let d1_val = calc_d1(spot, strike, rate, div_yield, vol, time_to_expiry);
    let d2_val = calc_d2(d1_val, vol, time_to_expiry);
    let discount_div = (-div_yield * time_to_expiry).exp();
    let pdf_d1 = standard_normal_pdf(d1_val);
    
    return -discount_div * pdf_d1 * (d2_val / vol) * 0.01;
}

fn greeks_volga(spot, strike, rate, div_yield, vol, time_to_expiry) {
    if time_to_expiry <= 0.0 || vol <= 0.0 {
        return 0.0;
    }
    let d1_val = calc_d1(spot, strike, rate, div_yield, vol, time_to_expiry);
    let d2_val = calc_d2(d1_val, vol, time_to_expiry);
    let raw_vega = spot * (-div_yield * time_to_expiry).exp() * standard_normal_pdf(d1_val) * time_to_expiry.sqrt();
    
    return raw_vega * (d1_val * d2_val / vol) * 0.0001;
}

fn greeks_charm(is_call, spot, strike, rate, div_yield, vol, time_to_expiry) {
    if time_to_expiry <= 0.0 || vol <= 0.0 {
        return 0.0;
    }
    let d1_val = calc_d1(spot, strike, rate, div_yield, vol, time_to_expiry);
    let d2_val = calc_d2(d1_val, vol, time_to_expiry);
    let discount_div = (-div_yield * time_to_expiry).exp();
    let pdf_d1 = standard_normal_pdf(d1_val);
    
    let term1 = div_yield * discount_div * standard_normal_cdf(if is_call { d1_val } else { -d1_val });
    let term2 = discount_div * pdf_d1 * (2.0 * (rate - div_yield) * time_to_expiry - d2_val * vol * time_to_expiry.sqrt()) / (2.0 * time_to_expiry * vol * time_to_expiry.sqrt());
    
    let annual_charm = if is_call { term1 - term2 } else { -term1 - term2 };
    return annual_charm / 365.0;
}

// -----------------------------------------------------------------------------
// Implied Volatility Solvers (Newton-Raphson with Bisection Fallback)
// -----------------------------------------------------------------------------

fn solve_implied_vol_newton(target_price, is_call, spot, strike, rate, div_yield, time_to_expiry, max_iter, tol) {
    // Intrinsic value bounds check
    let discount_rate = (-rate * time_to_expiry).exp();
    let discount_div = (-div_yield * time_to_expiry).exp();
    let intrinsic = if is_call {
        spot * discount_div - strike * discount_rate
    } else {
        strike * discount_rate - spot * discount_div
    };
    if intrinsic < 0.0 { intrinsic = 0.0; }
    
    if target_price < intrinsic {
        return 0.0;
    }
    
    // Initial guess using Brenner-Subrahmanyam approximation
    let sigma = (2.0 * 3.141592653589793 / time_to_expiry).sqrt() * (target_price / spot);
    if sigma < 0.05 { sigma = 0.20; }
    if sigma > 2.0 { sigma = 0.50; }
    
    for i in 0..max_iter {
        let price = if is_call {
            bs_price_call(spot, strike, rate, div_yield, sigma, time_to_expiry)
        } else {
            bs_price_put(spot, strike, rate, div_yield, sigma, time_to_expiry)
        };
        
        let diff = price - target_price;
        let abs_diff = if diff < 0.0 { -diff } else { diff };
        if abs_diff < tol {
            return sigma;
        }
        
        // Vega calculation without 1% multiplier for exact derivative
        let d1_val = calc_d1(spot, strike, rate, div_yield, sigma, time_to_expiry);
        let raw_vega = spot * discount_div * standard_normal_pdf(d1_val) * time_to_expiry.sqrt();
        
        if raw_vega < 1e-8 {
            break;
        }
        
        let step = diff / raw_vega;
        sigma = sigma - step;
        
        if sigma <= 0.001 || sigma > 5.0 {
            break;
        }
    }
    
    // Fallback to robust bisection search
    return solve_implied_vol_bisection(target_price, is_call, spot, strike, rate, div_yield, time_to_expiry, 60, tol);
}

fn solve_implied_vol_bisection(target_price, is_call, spot, strike, rate, div_yield, time_to_expiry, max_iter, tol) {
    let low = 0.0001;
    let high = 5.0;
    let mid = 0.25;
    
    for i in 0..max_iter {
        mid = 0.5 * (low + high);
        let price = if is_call {
            bs_price_call(spot, strike, rate, div_yield, mid, time_to_expiry)
        } else {
            bs_price_put(spot, strike, rate, div_yield, mid, time_to_expiry)
        };
        
        let diff = price - target_price;
        let abs_diff = if diff < 0.0 { -diff } else { diff };
        if abs_diff < tol {
            return mid;
        }
        
        if diff > 0.0 {
            high = mid;
        } else {
            low = mid;
        }
    }
    return mid;
}

// -----------------------------------------------------------------------------
// Volatility Surface Models (SVI: Stochastic Volatility Inspired)
// -----------------------------------------------------------------------------

// SVI Quasi-explicit parameterization: w(k) = a + b * (rho * (k - m) + sqrt((k - m)^2 + sigma^2))
fn svi_total_variance(log_moneyness, a, b, rho, m, sigma) {
    let diff = log_moneyness - m;
    let hyp = (diff * diff + sigma * sigma).sqrt();
    let total_var = a + b * (rho * diff + hyp);
    return if total_var > 0.0 { total_var } else { 0.00001 };
}

fn svi_implied_vol(log_moneyness, time_to_expiry, a, b, rho, m, sigma) {
    if time_to_expiry <= 0.0 { return 0.0; }
    let tot_var = svi_total_variance(log_moneyness, a, b, rho, m, sigma);
    return (tot_var / time_to_expiry).sqrt();
}

// -----------------------------------------------------------------------------
// Multi-Leg Option Strategies Risk Profiler
// -----------------------------------------------------------------------------

fn create_option_leg(is_call, strike, expiry, quantity, premium) {
    return #{
        is_call: is_call,
        strike: strike,
        expiry: expiry,
        quantity: quantity,
        premium: premium
    };
}

fn evaluate_strategy_payoff(legs, terminal_spot) {
    let total_payoff = 0.0;
    for leg in legs {
        let intrinsic = 0.0;
        if leg["is_call"] {
            let diff = terminal_spot - leg["strike"];
            intrinsic = if diff > 0.0 { diff } else { 0.0 };
        } else {
            let diff = leg["strike"] - terminal_spot;
            intrinsic = if diff > 0.0 { diff } else { 0.0 };
        }
        let net_pnl = (intrinsic - leg["premium"]) * leg["quantity"];
        total_payoff = total_payoff + net_pnl;
    }
    return total_payoff;
}

fn evaluate_strategy_greeks(legs, spot, rate, div_yield, vol) {
    let net_delta = 0.0;
    let net_gamma = 0.0;
    let net_vega = 0.0;
    let net_theta = 0.0;
    let net_rho = 0.0;
    
    for leg in legs {
        let qty = leg["quantity"];
        let is_call = leg["is_call"];
        let strike = leg["strike"];
        let t = leg["expiry"];
        
        let d = greeks_delta(is_call, spot, strike, rate, div_yield, vol, t);
        let g = greeks_gamma(spot, strike, rate, div_yield, vol, t);
        let v = greeks_vega(spot, strike, rate, div_yield, vol, t);
        let th = greeks_theta(is_call, spot, strike, rate, div_yield, vol, t);
        let rh = greeks_rho(is_call, spot, strike, rate, div_yield, vol, t);
        
        net_delta = net_delta + d * qty;
        net_gamma = net_gamma + g * qty;
        net_vega = net_vega + v * qty;
        net_theta = net_theta + th * qty;
        net_rho = net_rho + rh * qty;
    }
    
    return #{
        delta: net_delta,
        gamma: net_gamma,
        vega: net_vega,
        theta: net_theta,
        rho: net_rho
    };
}

fn build_iron_condor(spot, put_long_strike, put_short_strike, call_short_strike, call_long_strike, expiry, put_long_prem, put_short_prem, call_short_prem, call_long_prem) {
    let legs = [
        create_option_leg(false, put_long_strike, expiry, 1.0, put_long_prem),
        create_option_leg(false, put_short_strike, expiry, -1.0, put_short_prem),
        create_option_leg(true, call_short_strike, expiry, -1.0, call_short_prem),
        create_option_leg(true, call_long_strike, expiry, 1.0, call_long_prem)
    ];
    let net_credit = put_short_prem + call_short_prem - put_long_prem - call_long_prem;
    let put_wing_width = put_short_strike - put_long_strike;
    let max_loss = put_wing_width - net_credit;
    
    return #{
        strategy: "IRON_CONDOR",
        legs: legs,
        net_credit: net_credit,
        max_profit: net_credit,
        max_loss: max_loss,
        lower_breakeven: put_short_strike - net_credit,
        upper_breakeven: call_short_strike + net_credit
    };
}

fn build_straddle(spot, strike, expiry, call_prem, put_prem) {
    let legs = [
        create_option_leg(true, strike, expiry, 1.0, call_prem),
        create_option_leg(false, strike, expiry, 1.0, put_prem)
    ];
    let total_cost = call_prem + put_prem;
    return #{
        strategy: "LONG_STRADDLE",
        legs: legs,
        total_cost: total_cost,
        lower_breakeven: strike - total_cost,
        upper_breakeven: strike + total_cost
    };
}

fn build_strangle(spot, put_strike, call_strike, expiry, put_prem, call_prem) {
    let legs = [
        create_option_leg(false, put_strike, expiry, 1.0, put_prem),
        create_option_leg(true, call_strike, expiry, 1.0, call_prem)
    ];
    let total_cost = call_prem + put_prem;
    return #{
        strategy: "LONG_STRANGLE",
        legs: legs,
        total_cost: total_cost,
        lower_breakeven: put_strike - total_cost,
        upper_breakeven: call_strike + total_cost
    };
}

fn build_butterfly_spread(spot, lower_strike, middle_strike, upper_strike, expiry, lower_prem, middle_prem, upper_prem) {
    let legs = [
        create_option_leg(true, lower_strike, expiry, 1.0, lower_prem),
        create_option_leg(true, middle_strike, expiry, -2.0, middle_prem),
        create_option_leg(true, upper_strike, expiry, 1.0, upper_prem)
    ];
    let net_debit = lower_prem + upper_prem - 2.0 * middle_prem;
    let max_profit = (middle_strike - lower_strike) - net_debit;
    return #{
        strategy: "LONG_BUTTERFLY",
        legs: legs,
        net_debit: net_debit,
        max_profit: max_profit,
        max_loss: net_debit,
        lower_breakeven: lower_strike + net_debit,
        upper_breakeven: upper_strike - net_debit
    };
}

// -----------------------------------------------------------------------------
// Pipeline Event Handlers
// -----------------------------------------------------------------------------

fn process_option_tick(event, risk_state) {
    let spot = event["spot"];
    let strike = event["strike"];
    let is_call = event["is_call"];
    let rate = event["rate"];
    let div_yield = event["div_yield"];
    let t = event["expiry_years"];
    let market_price = event["price"];
    
    let implied_vol = solve_implied_vol_newton(market_price, is_call, spot, strike, rate, div_yield, t, 40, 1e-5);
    let delta = greeks_delta(is_call, spot, strike, rate, div_yield, implied_vol, t);
    let gamma = greeks_gamma(spot, strike, rate, div_yield, implied_vol, t);
    let vega = greeks_vega(spot, strike, rate, div_yield, implied_vol, t);
    let theta = greeks_theta(is_call, spot, strike, rate, div_yield, implied_vol, t);
    let rho = greeks_rho(is_call, spot, strike, rate, div_yield, implied_vol, t);
    
    let enriched = #{
        symbol: event["symbol"],
        timestamp: event["timestamp"],
        spot: spot,
        strike: strike,
        is_call: is_call,
        market_price: market_price,
        implied_vol: implied_vol,
        delta: delta,
        gamma: gamma,
        vega: vega,
        theta: theta,
        rho: rho
    };
    
    return enriched;
}
