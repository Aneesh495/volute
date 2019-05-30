/*
 * Basel III Regulatory Capital and Risk-Weighted Assets (RWA) Engine
 *
 * Implements Standardized Approach for Credit Risk, Liquidity Coverage Ratio (LCR),
 * and Capital Adequacy Ratio (CAR) calculations.
 */

// Standardized Risk Weight for Sovereign exposures based on ECAI rating
fn sovereign_risk_weight(rating) {
    let r = rating.to_upper();
    if r == "AAA" || r == "AA+" || r == "AA" || r == "AA-" { return 0.00; }
    if r == "A+" || r == "A" || r == "A-" { return 0.20; }
    if r == "BBB+" || r == "BBB" || r == "BBB-" { return 0.50; }
    if r == "BB+" || r == "BB" || r == "BB-" { return 1.00; }
    if r == "B+" || r == "B" || r == "B-" { return 1.00; }
    return 1.50; // Below B- or unrated
}

// Standardized Risk Weight for Corporate exposures based on ECAI rating
fn corporate_risk_weight(rating) {
    let r = rating.to_upper();
    if r == "AAA" || r == "AA+" || r == "AA" || r == "AA-" { return 0.20; }
    if r == "A+" || r == "A" || r == "A-" { return 0.50; }
    if r == "BBB+" || r == "BBB" || r == "BBB-" { return 1.00; }
    if r == "BB+" || r == "BB" || r == "BB-" { return 1.00; }
    return 1.50; // Below BB- or unrated
}

// Compute Risk-Weighted Asset (RWA) for exposure
fn calculate_rwa(exposure_amount, risk_weight) {
    return (exposure_amount * 1.0) * (risk_weight * 1.0);
}

// Calculate Capital Adequacy Ratio (CAR = Total Capital / Total RWA)
fn capital_adequacy_ratio(tier1_capital, tier2_capital, total_rwa) {
    if total_rwa <= 0.0 { return 1.0; }
    let total_capital = (tier1_capital * 1.0) + (tier2_capital * 1.0);
    return total_capital / (total_rwa * 1.0);
}

// Calculate Liquidity Coverage Ratio (LCR = HQLA / Net 30-Day Cash Outflows)
fn liquidity_coverage_ratio(hqla_stock, net_outflows_30d) {
    if net_outflows_30d <= 0.0 { return 10.0; }
    return (hqla_stock * 1.0) / (net_outflows_30d * 1.0);
}
