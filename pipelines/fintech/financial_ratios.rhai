import "lib/stats/regression" as reg;
/*
 * Comprehensive Quantitative and Portfolio Financial Metrics Library
 *
 * Implements portfolio risk metrics (Sharpe, Sortino, Treynor, Calmar, VaR, CVaR),
 * performance ratios, drawdowns, and trading analytics.
 */

import "lib/stats/descriptive" as desc;

// Annualized Sharpe Ratio
fn sharpe_ratio(returns, risk_free_annual, periods_per_year) {
    if returns.len() < 2 { return 0.0; }
    let mean_ret = desc::mean(returns);
    let rf_period = (risk_free_annual * 1.0) / (periods_per_year * 1.0);
    let excess = mean_ret - rf_period;
    let s_dev = desc::stddev(returns);
    if s_dev <= 0.0 { return 0.0; }
    let period_sharpe = excess / s_dev;
    return period_sharpe * (periods_per_year * 1.0).sqrt();
}

// Downside semi-deviation (volatility of negative returns only)
fn downside_deviation(returns, target_return) {
    if returns.is_empty() { return 0.0; }
    let sum_sq = 0.0;
    let count = 0.0;
    for r in returns {
        let diff = (r * 1.0) - (target_return * 1.0);
        if diff < 0.0 {
            sum_sq += diff * diff;
            count += 1.0;
        }
    }
    if count <= 0.0 { return 0.0; }
    return (sum_sq / (returns.len() * 1.0)).sqrt();
}

// Annualized Sortino Ratio
fn sortino_ratio(returns, risk_free_annual, periods_per_year) {
    let rf_period = (risk_free_annual * 1.0) / (periods_per_year * 1.0);
    let mean_ret = desc::mean(returns);
    let excess = mean_ret - rf_period;
    let dd = downside_deviation(returns, rf_period);
    if dd <= 0.0 { return 0.0; }
    let period_sortino = excess / dd;
    return period_sortino * (periods_per_year * 1.0).sqrt();
}

// Compute cumulative returns trajectory and Maximum Drawdown (MDD)
fn maximum_drawdown(equity_curve) {
    if equity_curve.is_empty() { return 0.0; }
    let peak = equity_curve[0] * 1.0;
    let max_dd = 0.0;
    for eq in equity_curve {
        let val = eq * 1.0;
        if val > peak { peak = val; }
        if peak > 0.0 {
            let dd = (peak - val) / peak;
            if dd > max_dd { max_dd = dd; }
        }
    }
    return max_dd;
}

// Calmar Ratio (Annualized Return / Maximum Drawdown)
fn calmar_ratio(annualized_return, max_dd) {
    if max_dd <= 0.0 { return 0.0; }
    return (annualized_return * 1.0) / max_dd;
}

// Historical Value at Risk (VaR) at alpha confidence level (e.g. 0.05 for 95% confidence)
fn historical_var(returns, alpha) {
    if returns.is_empty() { return 0.0; }
    let q = desc::quantile(returns, alpha);
    return -q;
}

// Expected Shortfall (Conditional VaR / CVaR)
fn expected_shortfall(returns, alpha) {
    let var_val = historical_var(returns, alpha);
    let cutoff = -var_val;
    let sum = 0.0;
    let count = 0.0;
    for r in returns {
        let val = r * 1.0;
        if val <= cutoff {
            sum += val;
            count += 1.0;
        }
    }
    if count <= 0.0 { return var_val; }
    return -(sum / count);
}
// Compute beta
fn beta(portfolio_returns, benchmark_returns) {
    
    let model = reg::fit_linear_regression(benchmark_returns, portfolio_returns);
    return model.slope;
}

// Compute alpha
fn alpha(portfolio_returns, benchmark_returns, risk_free_rate) {
    
    let model = reg::fit_linear_regression(benchmark_returns, portfolio_returns);
    return model.intercept;
}

// Compute treynor_ratio
fn treynor_ratio(portfolio_annual_return, risk_free_rate, beta_val) {
    if beta_val == 0.0 { return 0.0; }
    return (portfolio_annual_return - risk_free_rate) / beta_val;
}

// Compute information_ratio
fn information_ratio(portfolio_returns, benchmark_returns) {
    let diffs = [];
    for i in 0..portfolio_returns.len() { diffs.push(portfolio_returns[i] - benchmark_returns[i]); }
    let active_return = desc::mean(diffs);
    let tracking_error = desc::stddev(diffs);
    if tracking_error <= 0.0 { return 0.0; }
    return active_return / tracking_error;
}

// Compute omega_ratio
fn omega_ratio(returns, threshold) {
    let gain = 0.0; let loss = 0.0;
    for r in returns { if r > threshold { gain += r - threshold; } else { loss += threshold - r; } }
    if loss <= 0.0 { return 100.0; }
    return gain / loss;
}

// Compute current_ratio
fn current_ratio(current_assets, current_liabilities) {
    if current_liabilities == 0.0 { return 0.0; } return current_assets / current_liabilities;
}

// Compute quick_ratio
fn quick_ratio(cash, marketable_securities, receivables, current_liabilities) {
    if current_liabilities == 0.0 { return 0.0; } return (cash + marketable_securities + receivables) / current_liabilities;
}

// Compute debt_to_equity
fn debt_to_equity(total_debt, total_equity) {
    if total_equity == 0.0 { return 0.0; } return total_debt / total_equity;
}

// Compute interest_coverage
fn interest_coverage(ebit, interest_expense) {
    if interest_expense == 0.0 { return 0.0; } return ebit / interest_expense;
}

// Compute return_on_equity
fn return_on_equity(net_income, shareholders_equity) {
    if shareholders_equity == 0.0 { return 0.0; } return net_income / shareholders_equity;
}

// Compute return_on_assets
fn return_on_assets(net_income, total_assets) {
    if total_assets == 0.0 { return 0.0; } return net_income / total_assets;
}

// Compute asset_turnover
fn asset_turnover(revenue, average_total_assets) {
    if average_total_assets == 0.0 { return 0.0; } return revenue / average_total_assets;
}

// Compute gross_margin
fn gross_margin(gross_profit, revenue) {
    if revenue == 0.0 { return 0.0; } return gross_profit / revenue;
}

// Compute operating_margin
fn operating_margin(operating_income, revenue) {
    if revenue == 0.0 { return 0.0; } return operating_income / revenue;
}

// Compute net_profit_margin
fn net_profit_margin(net_income, revenue) {
    if revenue == 0.0 { return 0.0; } return net_income / revenue;
}

// Compute free_cash_flow
fn free_cash_flow(operating_cash_flow, capital_expenditures) {
    return operating_cash_flow - capital_expenditures;
}

// Compute pe_ratio
fn pe_ratio(share_price, earnings_per_share) {
    if earnings_per_share == 0.0 { return 0.0; } return share_price / earnings_per_share;
}

// Compute pb_ratio
fn pb_ratio(market_capitalization, book_value) {
    if book_value == 0.0 { return 0.0; } return market_capitalization / book_value;
}

// Compute ev_ebitda
fn ev_ebitda(enterprise_value, ebitda) {
    if ebitda == 0.0 { return 0.0; } return enterprise_value / ebitda;
}

// Compute dividend_yield
fn dividend_yield(annual_dividend_per_share, current_price) {
    if current_price == 0.0 { return 0.0; } return annual_dividend_per_share / current_price;
}
