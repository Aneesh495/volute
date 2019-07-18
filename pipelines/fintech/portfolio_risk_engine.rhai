// Volute Pipeline: Portfolio Risk Engine
// Real-time Parametric and Historical Value-at-Risk (VaR), Expected Shortfall (CVaR),
// Covariance decomposition, Macro Stress-Testing Scenarios, and Margin Buffer Monitoring.

import "lib/core/math" as m;

// -----------------------------------------------------------------------------
// Inverse Normal CDF Approximation (Acklam's Algorithm)
// -----------------------------------------------------------------------------

fn normal_inverse_cdf(p) {
    if p <= 0.0 { return -6.0; }
    if p >= 1.0 { return 6.0; }
    
    // Rational approximation coefficients
    let a1 = -3.969683028665376e+01;
    let a2 =  2.209460984245205e+02;
    let a3 = -2.759285104469687e+02;
    let a4 =  1.383577518672690e+02;
    let a5 = -3.066479806614716e+01;
    let a6 =  2.506628277459239e+00;

    let b1 = -5.447609879822406e+01;
    let b2 =  1.615858368580409e+02;
    let b3 = -1.556989798598866e+02;
    let b4 =  6.680131188771972e+01;
    let b5 = -1.328068155288572e+01;

    let c1 = -7.784894002430293e-03;
    let c2 = -3.223964580411365e-01;
    let c3 = -2.400758277161838e+00;
    let c4 = -2.549732539343734e+00;
    let c5 =  4.374664141464968e+00;
    let c6 =  2.938163982698783e+00;

    let d1 =  7.784695709041462e-03;
    let d2 =  3.224671290700398e-01;
    let d3 =  2.445134137142996e+00;
    let d4 =  3.754408661907416e+00;

    let p_low = 0.02425;
    let p_high = 1.0 - p_low;
    let q = 0.0;
    let r = 0.0;

    if p < p_low {
        // Lower tail
        q = (-2.0 * p.ln()).sqrt();
        return (((((c1 * q + c2) * q + c3) * q + c4) * q + c5) * q + c6) /
               ((((d1 * q + d2) * q + d3) * q + d4) * q + 1.0);
    } else if p <= p_high {
        // Central region
        q = p - 0.5;
        r = q * q;
        return (((((a1 * r + a2) * r + a3) * r + a4) * r + a5) * r + a6) * q /
               (((((b1 * r + b2) * r + b3) * r + b4) * r + b5) * r + 1.0);
    } else {
        // Upper tail
        q = (-2.0 * (1.0 - p).ln()).sqrt();
        return -(((((c1 * q + c2) * q + c3) * q + c4) * q + c5) * q + c6) /
                ((((d1 * q + d2) * q + d3) * q + d4) * q + 1.0);
    }
}

// -----------------------------------------------------------------------------
// Return Series and Covariance Matrix Computation
// -----------------------------------------------------------------------------

fn log_returns(price_series) {
    let returns = [];
    let n = price_series.len();
    if n < 2 { return returns; }
    for i in 1..n {
        let p_prev = price_series[i - 1];
        let p_curr = price_series[i];
        if p_prev > 0.0 && p_curr > 0.0 {
            returns.push((p_curr / p_prev).ln());
        } else {
            returns.push(0.0);
        }
    }
    return returns;
}

fn series_mean(series) {
    let sum = 0.0;
    let n = series.len();
    if n == 0 { return 0.0; }
    for val in series {
        sum = sum + val;
    }
    return sum / (n * 1.0);
}

fn calc_sample_covariance(series_a, series_b) {
    let n = series_a.len();
    if n != series_b.len() || n < 2 { return 0.0; }
    let mean_a = series_mean(series_a);
    let mean_b = series_mean(series_b);
    let sum_prod = 0.0;
    for i in 0..n {
        sum_prod = sum_prod + (series_a[i] - mean_a) * (series_b[i] - mean_b);
    }
    return sum_prod / ((n - 1) * 1.0);
}

fn calc_sample_variance(series) {
    return calc_sample_covariance(series, series);
}

fn calc_sample_stddev(series) {
    let v = calc_sample_variance(series);
    return if v > 0.0 { v.sqrt() } else { 0.0 };
}

fn calc_correlation(series_a, series_b) {
    let std_a = calc_sample_stddev(series_a);
    let std_b = calc_sample_stddev(series_b);
    if std_a <= 0.0 || std_b <= 0.0 { return 0.0; }
    let cov = calc_sample_covariance(series_a, series_b);
    let corr = cov / (std_a * std_b);
    if corr > 1.0 { return 1.0; }
    if corr < -1.0 { return -1.0; }
    return corr;
}

fn build_covariance_matrix(asset_keys, returns_by_asset) {
    let n = asset_keys.len();
    let cov_matrix = [];
    for i in 0..n {
        let row = [];
        let key_i = asset_keys[i];
        let ret_i = returns_by_asset[key_i];
        for j in 0..n {
            let key_j = asset_keys[j];
            let ret_j = returns_by_asset[key_j];
            row.push(calc_sample_covariance(ret_i, ret_j));
        }
        cov_matrix.push(row);
    }
    return cov_matrix;
}

fn portfolio_variance(weights, cov_matrix) {
    let n = weights.len();
    let total_var = 0.0;
    for i in 0..n {
        let w_i = weights[i];
        for j in 0..n {
            let w_j = weights[j];
            let cov_ij = cov_matrix[i][j];
            total_var = total_var + w_i * w_j * cov_ij;
        }
    }
    return if total_var > 0.0 { total_var } else { 0.0 };
}

fn portfolio_volatility(weights, cov_matrix) {
    return portfolio_variance(weights, cov_matrix).sqrt();
}

// -----------------------------------------------------------------------------
// Parametric Value-at-Risk (VaR) & Marginal Risk Contributions
// -----------------------------------------------------------------------------

fn parametric_var(total_value, portfolio_daily_vol, confidence_level, time_horizon_days) {
    let z_score = normal_inverse_cdf(confidence_level);
    let horizon_factor = (time_horizon_days * 1.0).sqrt();
    return total_value * z_score * portfolio_daily_vol * horizon_factor;
}

fn marginal_var_contributions(weights, cov_matrix, total_vol, confidence_level) {
    let n = weights.len();
    let z_score = normal_inverse_cdf(confidence_level);
    let mvar = [];
    if total_vol <= 0.0 {
        for i in 0..n { mvar.push(0.0); }
        return mvar;
    }
    for i in 0..n {
        let cov_sum = 0.0;
        for j in 0..n {
            cov_sum = cov_sum + cov_matrix[i][j] * weights[j];
        }
        let marginal_beta = cov_sum / total_vol;
        mvar.push(z_score * marginal_beta);
    }
    return mvar;
}

fn component_var_contributions(weights, cov_matrix, total_vol, total_value, confidence_level) {
    let n = weights.len();
    let mvar = marginal_var_contributions(weights, cov_matrix, total_vol, confidence_level);
    let cvar = [];
    for i in 0..n {
        cvar.push(weights[i] * mvar[i] * total_value);
    }
    return cvar;
}

// -----------------------------------------------------------------------------
// Historical Value-at-Risk (VaR) & Conditional VaR (Expected Shortfall)
// -----------------------------------------------------------------------------

fn quicksort_asc(arr) {
    let len = arr.len();
    if len <= 1 { return arr; }
    let pivot = arr[len / 2];
    let left = [];
    let middle = [];
    let right = [];
    for x in arr {
        if x < pivot {
            left.push(x);
        } else if x > pivot {
            right.push(x);
        } else {
            middle.push(x);
        }
    }
    let res = quicksort_asc(left);
    for m_val in middle { res.push(m_val); }
    let r_sorted = quicksort_asc(right);
    for r_val in r_sorted { res.push(r_val); }
    return res;
}

fn historical_var(historical_pnl_returns, confidence_level) {
    let sorted = quicksort_asc(historical_pnl_returns);
    let n = sorted.len();
    if n == 0 { return 0.0; }
    
    // Tail cutoff index (e.g. 99% confidence -> 1% worst percentile)
    let tail_percentile = 1.0 - confidence_level;
    let idx = (n * tail_percentile).to_int();
    if idx >= n { idx = n - 1; }
    if idx < 0 { idx = 0; }
    
    let worst_return = sorted[idx];
    return if worst_return < 0.0 { -worst_return } else { 0.0 };
}

fn historical_expected_shortfall(historical_pnl_returns, confidence_level) {
    let sorted = quicksort_asc(historical_pnl_returns);
    let n = sorted.len();
    if n == 0 { return 0.0; }
    
    let tail_percentile = 1.0 - confidence_level;
    let cutoff_idx = (n * tail_percentile).to_int();
    if cutoff_idx >= n { cutoff_idx = n - 1; }
    if cutoff_idx < 1 { cutoff_idx = 1; }
    
    let tail_sum = 0.0;
    for i in 0..cutoff_idx {
        tail_sum = tail_sum + sorted[i];
    }
    let mean_tail_loss = tail_sum / (cutoff_idx * 1.0);
    return if mean_tail_loss < 0.0 { -mean_tail_loss } else { 0.0 };
}

// -----------------------------------------------------------------------------
// Macro Stress-Testing Scenarios
// -----------------------------------------------------------------------------

fn create_stress_scenario(name, description, asset_shocks, vol_multiplier) {
    return #{
        name: name,
        description: description,
        shocks: asset_shocks,
        vol_multiplier: vol_multiplier
    };
}

fn get_standard_stress_scenarios() {
    let scenarios = [];
    
    // 2008 Lehman Liquidity Crunch
    scenarios.push(create_stress_scenario(
        "2008_LEHMAN_CRUNCH",
        "Global financial system credit and equity collapse",
        #{ "EQUITIES": -0.42, "BONDS": 0.08, "COMMODITIES": -0.35, "CRYPTO": -0.65, "FX_USD": 0.12 },
        2.5
    ));
    
    // 2020 COVID Liquidity Shock
    scenarios.push(create_stress_scenario(
        "2020_COVID_SHOCK",
        "Rapid cross-asset deflationary and volatility spike",
        #{ "EQUITIES": -0.34, "BONDS": 0.02, "COMMODITIES": -0.45, "CRYPTO": -0.50, "FX_USD": 0.08 },
        3.0
    ));
    
    // 1987 Black Monday Equity Crash
    scenarios.push(create_stress_scenario(
        "1987_BLACK_MONDAY",
        "Single-day catastrophic equity selloff",
        #{ "EQUITIES": -0.226, "BONDS": 0.04, "COMMODITIES": -0.10, "CRYPTO": -0.35, "FX_USD": 0.03 },
        2.0
    ));
    
    // Rapid Inflation Rate Hike Cycle (2022)
    scenarios.push(create_stress_scenario(
        "2022_RATES_SPIKE",
        "Parallel upward shift of yield curve with tech multiple compression",
        #{ "EQUITIES": -0.28, "BONDS": -0.16, "COMMODITIES": 0.25, "CRYPTO": -0.60, "FX_USD": 0.15 },
        1.5
    ));
    
    return scenarios;
}

fn evaluate_stress_scenarios(positions, scenarios) {
    let results = [];
    for sc in scenarios {
        let sc_name = sc["name"];
        let shocks = sc["shocks"];
        let scenario_pnl = 0.0;
        let original_portfolio_value = 0.0;
        
        for pos in positions {
            let asset_class = pos["asset_class"];
            let market_val = pos["market_value"];
            original_portfolio_value = original_portfolio_value + market_val;
            
            let shock_pct = 0.0;
            if shocks.contains(asset_class) {
                shock_pct = shocks[asset_class];
            } else if shocks.contains("EQUITIES") {
                shock_pct = shocks["EQUITIES"] * 0.5;
            }
            
            let leg_pnl = market_val * shock_pct;
            scenario_pnl = scenario_pnl + leg_pnl;
        }
        
        let pnl_pct = if original_portfolio_value > 0.0 { scenario_pnl / original_portfolio_value } else { 0.0 };
        results.push(#{
            scenario: sc_name,
            original_value: original_portfolio_value,
            stressed_pnl: scenario_pnl,
            stressed_pnl_pct: pnl_pct,
            stressed_ending_value: original_portfolio_value + scenario_pnl
        });
    }
    return results;
}

// -----------------------------------------------------------------------------
// Margin Buffer & Concentration Risk Monitor
// -----------------------------------------------------------------------------

fn evaluate_margin_requirements(positions, total_equity) {
    let initial_margin_req = 0.0;
    let maint_margin_req = 0.0;
    let concentration_penalties = 0.0;
    
    for pos in positions {
        let notional = pos["market_value"];
        let abs_notional = if notional < 0.0 { -notional } else { notional };
        let asset_class = pos["asset_class"];
        
        let im_rate = 0.15;
        let mm_rate = 0.10;
        if asset_class == "CRYPTO" {
            im_rate = 0.50;
            mm_rate = 0.35;
        } else if asset_class == "BONDS" {
            im_rate = 0.05;
            mm_rate = 0.03;
        }
        
        let pos_weight = abs_notional / total_equity;
        // Concentration penalty if single position exceeds 20% of equity
        let conc_factor = 1.0;
        if pos_weight > 0.20 {
            conc_factor = 1.0 + (pos_weight - 0.20) * 2.0;
            concentration_penalties = concentration_penalties + abs_notional * (conc_factor - 1.0) * mm_rate;
        }
        
        initial_margin_req = initial_margin_req + abs_notional * im_rate * conc_factor;
        maint_margin_req = maint_margin_req + abs_notional * mm_rate * conc_factor;
    }
    
    let margin_buffer = total_equity - maint_margin_req;
    let margin_ratio = if maint_margin_req > 0.0 { total_equity / maint_margin_req } else { 999.0 };
    let is_margin_call = total_equity < maint_margin_req;
    
    return #{
        total_equity: total_equity,
        initial_margin: initial_margin_req,
        maintenance_margin: maint_margin_req,
        concentration_penalty: concentration_penalties,
        free_margin_buffer: margin_buffer,
        margin_coverage_ratio: margin_ratio,
        is_margin_call: is_margin_call
    };
}

// -----------------------------------------------------------------------------
// Pipeline Event Handlers
// -----------------------------------------------------------------------------

fn process_portfolio_event(event, risk_state) {
    let event_type = event["event_type"];
    let timestamp = event["timestamp"];
    
    if event_type == "POSITION_UPDATE" {
        risk_state["positions"] = event["positions"];
        risk_state["total_equity"] = event["total_equity"];
    } else if event_type == "RETURNS_REFRESH" {
        risk_state["returns_history"] = event["returns"];
    }
    
    let positions = risk_state["positions"];
    let equity = risk_state["total_equity"];
    let margin_status = evaluate_margin_requirements(positions, equity);
    let scenarios = get_standard_stress_scenarios();
    let stress_eval = evaluate_stress_scenarios(positions, scenarios);
    
    let alerts = [];
    if margin_status["is_margin_call"] {
        alerts.push(#{
            level: "CRITICAL",
            code: "MARGIN_CALL_DEFICIT",
            deficit: margin_status["maintenance_margin"] - equity
        });
    } else if margin_status["margin_coverage_ratio"] < 1.15 {
        alerts.push(#{
            level: "WARNING",
            code: "LOW_MARGIN_BUFFER",
            ratio: margin_status["margin_coverage_ratio"]
        });
    }
    
    for sc in stress_eval {
        if sc["stressed_pnl_pct"] < -0.30 {
            alerts.push(#{
                level: "HIGH",
                code: "STRESS_TEST_EXCESSIVE_DRAWDOWN",
                scenario: sc["scenario"],
                drawdown: sc["stressed_pnl_pct"]
            });
        }
    }
    
    return #{
        timestamp: timestamp,
        margin_status: margin_status,
        stress_eval: stress_eval,
        alerts: alerts
    };
}
