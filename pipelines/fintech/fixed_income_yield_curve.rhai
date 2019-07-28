// Volute Pipeline: Fixed Income Yield Curve Fitting & Interest Rate Risk
// Nelson-Siegel and Svensson parametric models, zero-coupon discounting, cash flow pricing,
// Macaulay/Modified duration, Convexity, DV01, Key Rate Durations (KRD), and 2Y-10Y inversion monitors.

import "lib/core/math" as m;

// -----------------------------------------------------------------------------
// Nelson-Siegel & Svensson Parametric Yield Curve Models
// -----------------------------------------------------------------------------

fn nelson_siegel_yield(maturity_years, beta0, beta1, beta2, tau) {
    if maturity_years <= 0.0 || tau <= 0.0 {
        return beta0 + beta1;
    }
    let m_tau = maturity_years / tau;
    let exp_term = (-m_tau).exp();
    let factor1 = (1.0 - exp_term) / m_tau;
    let factor2 = factor1 - exp_term;
    
    return beta0 + beta1 * factor1 + beta2 * factor2;
}

fn nelson_siegel_svensson_yield(maturity_years, beta0, beta1, beta2, beta3, tau1, tau2) {
    if maturity_years <= 0.0 || tau1 <= 0.0 || tau2 <= 0.0 {
        return beta0 + beta1;
    }
    let m_tau1 = maturity_years / tau1;
    let exp_term1 = (-m_tau1).exp();
    let factor1 = (1.0 - exp_term1) / m_tau1;
    let factor2 = factor1 - exp_term1;
    
    let m_tau2 = maturity_years / tau2;
    let exp_term2 = (-m_tau2).exp();
    let factor3 = (1.0 - exp_term2) / m_tau2 - exp_term2;
    
    return beta0 + beta1 * factor1 + beta2 * factor2 + beta3 * factor3;
}

fn discount_factor_continuous(zero_rate, maturity_years) {
    return (-zero_rate * maturity_years).exp();
}

fn discount_factor_annual(annual_yield, maturity_years, compounding_frequency) {
    let freq = compounding_frequency * 1.0;
    let base = 1.0 + (annual_yield / freq);
    let exponent = freq * maturity_years;
    return 1.0 / (base.pow(exponent.to_int()));
}

// -----------------------------------------------------------------------------
// Bond Cash Flow Valuation
// -----------------------------------------------------------------------------

fn generate_bond_cash_flows(par_value, coupon_rate, maturity_years, frequency) {
    let periods = (maturity_years * frequency).to_int();
    let coupon_payment = (par_value * coupon_rate) / (frequency * 1.0);
    let cash_flows = [];
    
    for i in 1..=periods {
        let t = (i * 1.0) / (frequency * 1.0);
        let amount = coupon_payment;
        if i == periods {
            amount = amount + par_value;
        }
        cash_flows.push(#{
            period: i,
            time_years: t,
            amount: amount
        });
    }
    return cash_flows;
}

fn price_bond_discount_curve(cash_flows, beta0, beta1, beta2, tau) {
    let dirty_price = 0.0;
    for cf in cash_flows {
        let t = cf["time_years"];
        let amt = cf["amount"];
        let zero_rate = nelson_siegel_yield(t, beta0, beta1, beta2, tau);
        let df = discount_factor_continuous(zero_rate, t);
        dirty_price = dirty_price + amt * df;
    }
    return dirty_price;
}

// -----------------------------------------------------------------------------
// Duration, Convexity, and DV01 Risk Analytics
// -----------------------------------------------------------------------------

fn calc_bond_risk_metrics(cash_flows, yield_to_maturity, frequency, par_value) {
    let price = 0.0;
    let weighted_time_sum = 0.0;
    let convexity_time_sum = 0.0;
    let freq = frequency * 1.0;
    let per_period_yield = yield_to_maturity / freq;
    
    for cf in cash_flows {
        let t = cf["time_years"];
        let period_idx = (t * freq).to_int();
        let amt = cf["amount"];
        
        let discount = 1.0 / ((1.0 + per_period_yield).pow(period_idx));
        let pv_cf = amt * discount;
        
        price = price + pv_cf;
        weighted_time_sum = weighted_time_sum + t * pv_cf;
        convexity_time_sum = convexity_time_sum + t * (t + (1.0 / freq)) * pv_cf;
    }
    
    if price <= 0.0 {
        return #{ macaulay_duration: 0.0, modified_duration: 0.0, convexity: 0.0, dv01: 0.0, dirty_price: 0.0 };
    }
    
    let mac_duration = weighted_time_sum / price;
    let mod_duration = mac_duration / (1.0 + per_period_yield);
    let convexity = convexity_time_sum / (price * (1.0 + per_period_yield) * (1.0 + per_period_yield));
    
    // DV01 is price change per 1 basis point (0.0001) yield change
    let dv01 = price * mod_duration * 0.0001;
    
    return #{
        dirty_price: price,
        macaulay_duration: mac_duration,
        modified_duration: mod_duration,
        convexity: convexity,
        dv01: dv01
    };
}

// -----------------------------------------------------------------------------
// Key Rate Duration (KRD) Vector
// -----------------------------------------------------------------------------

fn calc_key_rate_durations(cash_flows, base_yield, frequency, par_value) {
    let key_tenors = [2.0, 5.0, 10.0, 30.0];
    let base_metrics = calc_bond_risk_metrics(cash_flows, base_yield, frequency, par_value);
    let base_p = base_metrics["dirty_price"];
    let krds = #{};
    
    let shift_bps = 0.0001; // 1 bp bump
    
    for tenor in key_tenors {
        let shifted_price = 0.0;
        for cf in cash_flows {
            let t = cf["time_years"];
            let period_idx = (t * frequency * 1.0).to_int();
            let amt = cf["amount"];
            
            // Triangle weighting of shock around key tenor
            let weight = 0.0;
            if (t - tenor).abs() < 5.0 {
                weight = 1.0 - ((t - tenor).abs() / 5.0);
            }
            let effective_yield = base_yield + shift_bps * weight;
            let discount = 1.0 / ((1.0 + effective_yield / (frequency * 1.0)).pow(period_idx));
            shifted_price = shifted_price + amt * discount;
        }
        
        let krd_val = - (shifted_price - base_p) / (base_p * shift_bps);
        krds[tenor.to_string() + "Y"] = krd_val;
    }
    
    return krds;
}

// -----------------------------------------------------------------------------
// Yield Curve Inversion and Slope Monitoring
// -----------------------------------------------------------------------------

fn evaluate_curve_slope(beta0, beta1, beta2, tau) {
    let y_3m = nelson_siegel_yield(0.25, beta0, beta1, beta2, tau);
    let y_2y = nelson_siegel_yield(2.0, beta0, beta1, beta2, tau);
    let y_5y = nelson_siegel_yield(5.0, beta0, beta1, beta2, tau);
    let y_10y = nelson_siegel_yield(10.0, beta0, beta1, beta2, tau);
    let y_30y = nelson_siegel_yield(30.0, beta0, beta1, beta2, tau);
    
    let spread_2s10s = y_10y - y_2y;
    let spread_3m10s = y_10y - y_3m;
    
    let alerts = [];
    if spread_2s10s < 0.0 {
        alerts.push(#{
            rule: "YIELD_CURVE_INVERSION_2S10S",
            severity: "CRITICAL",
            spread_bps: spread_2s10s * 10000.0,
            y_2y: y_2y,
            y_10y: y_10y
        });
    }
    if spread_3m10s < 0.0 {
        alerts.push(#{
            rule: "RECESSION_WARNING_3M10S_INVERSION",
            severity: "CRITICAL",
            spread_bps: spread_3m10s * 10000.0,
            y_3m: y_3m,
            y_10y: y_10y
        });
    }
    
    return #{
        y_3m: y_3m,
        y_2y: y_2y,
        y_5y: y_5y,
        y_10y: y_10y,
        y_30y: y_30y,
        spread_2s10s_bps: spread_2s10s * 10000.0,
        spread_3m10s_bps: spread_3m10s * 10000.0,
        alerts: alerts
    };
}

// -----------------------------------------------------------------------------
// Pipeline Event Handlers
// -----------------------------------------------------------------------------

fn process_yield_curve_event(event, curve_state) {
    let beta0 = event["beta0"];
    let beta1 = event["beta1"];
    let beta2 = event["beta2"];
    let tau = event["tau"];
    let timestamp = event["timestamp"];
    
    let slope_analysis = evaluate_curve_slope(beta0, beta1, beta2, tau);
    
    return #{
        timestamp: timestamp,
        slope: slope_analysis,
        alerts: slope_analysis["alerts"]
    };
}
