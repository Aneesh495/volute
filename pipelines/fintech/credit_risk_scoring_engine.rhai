// Volute Pipeline: Basel Internal Ratings-Based (IRB) Credit Risk Engine
// Comprehensive Probability of Default (PD), Loss Given Default (LGD), Exposure at Default (EAD),
// Expected Loss (EL), and Basel II/III Risk-Weighted Assets (RWA) asymptotic capital calculations.

import "lib/core/math" as m;

// -----------------------------------------------------------------------------
// Normal Distribution and Inverse Approximations
// -----------------------------------------------------------------------------

fn standard_norm_cdf(x) {
    let p = 0.2316419;
    let b1 = 0.319381530;
    let b2 = -0.356563782;
    let b3 = 1.781477937;
    let b4 = -1.821255978;
    let b5 = 1.330274429;
    
    let is_negative = x < 0.0;
    let abs_x = if is_negative { -x } else { x };
    let inv_sqrt_2pi = 0.3989422804014327;
    let pdf_val = inv_sqrt_2pi * (-0.5 * abs_x * abs_x).exp();
    
    let t = 1.0 / (1.0 + p * abs_x);
    let poly = t * (b1 + t * (b2 + t * (b3 + t * (b4 + t * b5))));
    let cdf = 1.0 - pdf_val * poly;
    
    return if is_negative { 1.0 - cdf } else { cdf };
}

fn standard_norm_inv(p) {
    if p <= 0.000001 { return -4.75; }
    if p >= 0.999999 { return 4.75; }
    
    let q = p - 0.5;
    if q.abs() <= 0.42 {
        let r = q * q;
        return q * (((-25.44106049637 * r + 41.39119773534) * r - 18.61500062529) * r + 2.50662823884) /
               ((((3.13082909833 * r - 21.06224101826) * r + 23.08336743743) * r - 8.47351093090) * r + 1.0);
    }
    
    let r = if q < 0.0 { p } else { 1.0 - p };
    let s = (-r.ln()).sqrt();
    let val = (((2.32121276858 * s + 4.57495297490) * s - 0.270832094) * s - 0.001) /
              ((s + 3.7544086619) * s + 1.0);
    return if q < 0.0 { -val } else { val };
}

// -----------------------------------------------------------------------------
// Logistic Credit Scoring & Weight-of-Evidence (WOE)
// -----------------------------------------------------------------------------

fn calc_debt_to_income_woe(dti_ratio) {
    if dti_ratio < 0.20 { return -0.65; }
    if dti_ratio < 0.35 { return -0.20; }
    if dti_ratio < 0.50 { return 0.35; }
    return 0.95;
}

fn calc_ltv_woe(loan_to_value) {
    if loan_to_value < 0.60 { return -0.55; }
    if loan_to_value < 0.80 { return -0.10; }
    if loan_to_value < 0.95 { return 0.40; }
    return 1.10;
}

fn calc_delinquency_woe(past_due_days) {
    if past_due_days == 0 { return -0.75; }
    if past_due_days <= 30 { return 0.45; }
    if past_due_days <= 60 { return 1.20; }
    return 2.40;
}

fn estimate_probability_of_default(dti, ltv, past_due_days, bureau_score) {
    // Intercept
    let log_odds = -3.20;
    
    // Add WOE contributions
    log_odds = log_odds + 0.85 * calc_debt_to_income_woe(dti);
    log_odds = log_odds + 0.90 * calc_ltv_woe(ltv);
    log_odds = log_odds + 1.15 * calc_delinquency_woe(past_due_days);
    
    // Bureau score impact (-0.005 per point above/below 680)
    let bureau_delta = (bureau_score - 680) * 1.0;
    log_odds = log_odds - 0.0065 * bureau_delta;
    
    // Logistic sigmoid transformation
    let pd = 1.0 / (1.0 + (-log_odds).exp());
    
    // Floor PD at 0.03% (Basel regulatory floor)
    if pd < 0.0003 { pd = 0.0003; }
    if pd > 0.9999 { pd = 0.9999; }
    
    return pd;
}

// -----------------------------------------------------------------------------
// Loss Given Default (LGD) Workout Model
// -----------------------------------------------------------------------------

fn estimate_loss_given_default(collateral_type, collateral_value, exposure_amount, seniority) {
    let baseline_lgd = 0.45; // Senior unsecured standard baseline
    
    if seniority == "SENIOR_SECURED" {
        baseline_lgd = 0.25;
    } else if seniority == "SUBORDINATED" {
        baseline_lgd = 0.75;
    }
    
    // Haircut based on collateral liquidity
    let haircut = 0.15;
    if collateral_type == "CASH" {
        haircut = 0.0;
    } else if collateral_type == "GOVERNMENT_BONDS" {
        haircut = 0.05;
    } else if collateral_type == "COMMERCIAL_REAL_ESTATE" {
        haircut = 0.35;
    } else if collateral_type == "EQUIPMENT" {
        haircut = 0.50;
    }
    
    let effective_collateral = collateral_value * (1.0 - haircut);
    let recovery_pct = if exposure_amount > 0.0 { effective_collateral / exposure_amount } else { 0.0 };
    if recovery_pct > 0.95 { recovery_pct = 0.95; }
    
    let lgd = 1.0 - recovery_pct;
    if lgd < 0.05 { lgd = 0.05; } // Regulatory floor
    if lgd > 1.0 { lgd = 1.0; }
    
    return lgd;
}

// -----------------------------------------------------------------------------
// Exposure at Default (EAD)
// -----------------------------------------------------------------------------

fn calc_exposure_at_default(drawn_balance, undrawn_commitment, facility_type) {
    // Credit Conversion Factor (CCF)
    let ccf = 0.75;
    if facility_type == "UNCONDITIONALLY_CANCELABLE" {
        ccf = 0.10;
    } else if facility_type == "TERM_LOAN" {
        ccf = 1.0;
    } else if facility_type == "REVOLVING_CREDIT" {
        ccf = 0.50;
    }
    
    return drawn_balance + undrawn_commitment * ccf;
}

// -----------------------------------------------------------------------------
// Basel II / III Advanced Internal Ratings-Based (A-IRB) RWA
// -----------------------------------------------------------------------------

fn calc_basel_irb_capital(pd, lgd, ead, maturity_years, is_corporate) {
    // Asset correlation R
    let r = 0.0;
    if is_corporate {
        let exp_factor = (-50.0 * pd).exp();
        r = 0.12 * ((1.0 - exp_factor) / (1.0 - (-50.0).exp())) + 0.24 * (1.0 - ((1.0 - exp_factor) / (1.0 - (-50.0).exp())));
    } else {
        // Retail mortgages / consumer
        r = 0.15;
    }
    
    // Maturity adjustment b(PD)
    let b = (0.11852 - 0.05478 * pd.ln()).pow(2);
    let maturity = if maturity_years < 1.0 { 1.0 } else { maturity_years };
    let maturity_adj = (1.0 + (maturity - 2.5) * b) / (1.0 - 1.5 * b);
    
    // Vasicek single risk factor asymptotic capital formula
    let g_pd = standard_norm_inv(pd);
    let g_999 = 3.090232; // norm_inv(0.999)
    let cond_prob = standard_norm_cdf((g_pd + r.sqrt() * g_999) / (1.0 - r).sqrt());
    
    let k_capital = (lgd * cond_prob - pd * lgd) * maturity_adj;
    if k_capital < 0.0 { k_capital = 0.0; }
    
    let rwa = k_capital * 12.5 * ead;
    let expected_loss = pd * lgd * ead;
    
    return #{
        correlation_r: r,
        maturity_adjustment: maturity_adj,
        capital_ratio_k: k_capital,
        rwa: rwa,
        expected_loss: expected_loss
    };
}

// -----------------------------------------------------------------------------
// Pipeline Event Handlers
// -----------------------------------------------------------------------------

fn process_loan_application(event, pipeline_state) {
    let app_id = event["application_id"];
    let dti = event["debt_to_income"];
    let ltv = event["loan_to_value"];
    let past_due = event["past_due_days"];
    let bureau_score = event["bureau_score"];
    let drawn = event["drawn_amount"];
    let undrawn = event["undrawn_commitment"];
    let facility_type = event["facility_type"];
    let col_type = event["collateral_type"];
    let col_val = event["collateral_value"];
    let seniority = event["seniority"];
    let maturity = event["maturity_years"];
    let timestamp = event["timestamp"];
    
    let pd = estimate_probability_of_default(dti, ltv, past_due, bureau_score);
    let ead = calc_exposure_at_default(drawn, undrawn, facility_type);
    let lgd = estimate_loss_given_default(col_type, col_val, ead, seniority);
    let irb = calc_basel_irb_capital(pd, lgd, ead, maturity, true);
    
    let alerts = [];
    if pd > 0.12 {
        alerts.push(#{
            rule: "HIGH_DEFAULT_PROBABILITY_ALERT",
            severity: "HIGH",
            pd: pd,
            app_id: app_id,
            timestamp: timestamp
        });
    }
    if irb["expected_loss"] > 50000.0 {
        alerts.push(#{
            rule: "EXCESSIVE_PORTFOLIO_EXPECTED_LOSS",
            severity: "CRITICAL",
            expected_loss: irb["expected_loss"],
            app_id: app_id,
            timestamp: timestamp
        });
    }
    
    return #{
        application_id: app_id,
        pd: pd,
        lgd: lgd,
        ead: ead,
        expected_loss: irb["expected_loss"],
        rwa: irb["rwa"],
        capital_k: irb["capital_ratio_k"],
        alerts: alerts
    };
}
