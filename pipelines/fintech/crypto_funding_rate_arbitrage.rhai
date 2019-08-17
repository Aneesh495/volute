// Volute Pipeline: Crypto Perpetual Futures Funding Rate Arbitrage Engine
// 8-hour funding rate calculation, premium index estimation, spot-perp cash-and-carry basis,
// delta-neutral basis arbitrage yield, rebalancing triggers, and liquidation buffer monitoring.

// -----------------------------------------------------------------------------
// Premium Index and Funding Rate Mathematics
// -----------------------------------------------------------------------------

fn calc_impact_prices(orderbook_bids, orderbook_asks, impact_notional_usd) {
    // Impact Bid Price: average execution price to sell impact_notional_usd
    let remaining_usd = impact_notional_usd;
    let filled_base = 0.0;
    
    for b in orderbook_bids {
        let px = b["price"];
        let sz = b["size"];
        let level_usd = px * sz;
        
        if remaining_usd <= level_usd {
            let needed_sz = remaining_usd / px;
            filled_base = filled_base + needed_sz;
            remaining_usd = 0.0;
            break;
        } else {
            filled_base = filled_base + sz;
            remaining_usd = remaining_usd - level_usd;
        }
    }
    let impact_bid = if filled_base > 0.0 { impact_notional_usd / filled_base } else { 0.0 };
    
    // Impact Ask Price: average execution price to buy impact_notional_usd
    remaining_usd = impact_notional_usd;
    filled_base = 0.0;
    
    for a in orderbook_asks {
        let px = a["price"];
        let sz = a["size"];
        let level_usd = px * sz;
        
        if remaining_usd <= level_usd {
            let needed_sz = remaining_usd / px;
            filled_base = filled_base + needed_sz;
            remaining_usd = 0.0;
            break;
        } else {
            filled_base = filled_base + sz;
            remaining_usd = remaining_usd - level_usd;
        }
    }
    let impact_ask = if filled_base > 0.0 { impact_notional_usd / filled_base } else { 0.0 };
    
    return #{
        impact_bid: impact_bid,
        impact_ask: impact_ask
    };
}

fn calc_premium_index(spot_index_price, impact_bid, impact_ask) {
    if spot_index_price <= 0.0 { return 0.0; }
    
    let bid_diff = impact_bid - spot_index_price;
    let ask_diff = spot_index_price - impact_ask;
    
    let term1 = if bid_diff > 0.0 { bid_diff } else { 0.0 };
    let term2 = if ask_diff > 0.0 { ask_diff } else { 0.0 };
    
    return (term1 - term2) / spot_index_price;
}

fn clamp_value(val, min_bound, max_bound) {
    if val < min_bound { return min_bound; }
    if val > max_bound { return max_bound; }
    return val;
}

fn calc_8hour_funding_rate(premium_index, interest_rate) {
    // Standard perpetual contract funding rate formula
    // F = PremiumIndex + clamp(InterestRate - PremiumIndex, -0.05%, +0.05%)
    let rate_diff = interest_rate - premium_index;
    let clamped_diff = clamp_value(rate_diff, -0.0005, 0.0005);
    let funding_rate = premium_index + clamped_diff;
    
    // Clamp to exchange maximum boundary (typically +/- 0.75% per 8h)
    return clamp_value(funding_rate, -0.0075, 0.0075);
}

fn calc_annualized_funding_yield(funding_rate_8h) {
    // 3 funding intervals per day * 365 days = 1095 payments per year
    return funding_rate_8h * 1095.0;
}

// -----------------------------------------------------------------------------
// Spot-Perpetual Cash-and-Carry Basis
// -----------------------------------------------------------------------------

fn calc_spot_perp_basis(spot_price, perp_price) {
    if spot_price <= 0.0 { return 0.0; }
    return (perp_price - spot_price) / spot_price;
}

fn evaluate_cash_and_carry_opportunity(spot_price, perp_price, funding_rate_8h, taker_fee_pct) {
    let basis_pct = calc_spot_perp_basis(spot_price, perp_price);
    let annual_yield = calc_annualized_funding_yield(funding_rate_8h);
    let roundtrip_fees = taker_fee_pct * 4.0; // Entry (spot buy + perp sell) + Exit
    let net_annual_yield = annual_yield - roundtrip_fees;
    
    let is_attractive = false;
    let strategy_action = "HOLD";
    
    // Contango: Perp trades above spot and funding is strongly positive (> 15% annualized)
    if funding_rate_8h > 0.0003 && net_annual_yield > 0.15 {
        is_attractive = true;
        strategy_action = "LONG_SPOT_SHORT_PERP";
    } else if funding_rate_8h < -0.0003 && (-net_annual_yield) > 0.15 {
        // Backwardation: Perp trades below spot and funding is deeply negative
        is_attractive = true;
        strategy_action = "SHORT_SPOT_LONG_PERP";
    }
    
    return #{
        spot_price: spot_price,
        perp_price: perp_price,
        basis_pct: basis_pct,
        funding_rate_8h: funding_rate_8h,
        annualized_yield: annual_yield,
        net_annualized_yield: net_annual_yield,
        is_attractive: is_attractive,
        action: strategy_action
    };
}

// -----------------------------------------------------------------------------
// Position & Delta-Neutral Risk Tracking
// -----------------------------------------------------------------------------

fn init_basis_arbitrage_portfolio() {
    return #{
        spot_holdings: #{}, // symbol -> #{ amount, avg_price }
        perp_positions: #{}, // symbol -> #{ amount, avg_price, leverage, margin }
        collateral_usd: 1000000.0,
        realized_funding_pnl: 0.0
    };
}

fn evaluate_delta_neutrality(portfolio, symbol, current_spot_px, current_perp_px) {
    let spot_amt = 0.0;
    if portfolio["spot_holdings"].contains(symbol) {
        spot_amt = portfolio["spot_holdings"][symbol]["amount"];
    }
    
    let perp_amt = 0.0;
    if portfolio["perp_positions"].contains(symbol) {
        perp_amt = portfolio["perp_positions"][symbol]["amount"];
    }
    
    // Net delta in base currency
    let net_delta_base = spot_amt + perp_amt; // Perp short has negative amount
    let net_delta_usd = net_delta_base * current_spot_px;
    let total_notional = (spot_amt * current_spot_px).abs() + (perp_amt * current_perp_px).abs();
    let delta_imbalance_pct = if total_notional > 0.0 { (net_delta_usd.abs() / total_notional) * 100.0 } else { 0.0 };
    
    let needs_rebalance = delta_imbalance_pct > 2.0; // Rebalance if delta deviation > 2%
    
    return #{
        symbol: symbol,
        spot_base: spot_amt,
        perp_base: perp_amt,
        net_delta_usd: net_delta_usd,
        delta_imbalance_pct: delta_imbalance_pct,
        needs_rebalance: needs_rebalance
    };
}

// -----------------------------------------------------------------------------
// Pipeline Event Handlers
// -----------------------------------------------------------------------------

fn process_perpetual_market_tick(event, pipeline_state) {
    let symbol = event["symbol"];
    let spot_px = event["spot_price"];
    let perp_px = event["perp_price"];
    let bids = event["perp_bids"];
    let asks = event["perp_asks"];
    let impact_usd = 20000.0; // $20,000 impact depth
    let interest_rate = 0.0001; // 0.01% standard base interest rate per 8h
    let timestamp = event["timestamp"];
    
    let impact_res = calc_impact_prices(bids, asks, impact_usd);
    let premium_idx = calc_premium_index(spot_px, impact_res["impact_bid"], impact_res["impact_ask"]);
    let funding_rate = calc_8hour_funding_rate(premium_idx, interest_rate);
    let opp = evaluate_cash_and_carry_opportunity(spot_px, perp_px, funding_rate, 0.0004);
    
    let alerts = [];
    if opp["is_attractive"] {
        alerts.push(#{
            rule: "HIGH_YIELD_BASIS_ARBITRAGE_SIGNAL",
            severity: "MEDIUM",
            symbol: symbol,
            action: opp["action"],
            net_yield_pct: opp["net_annualized_yield"] * 100.0,
            basis_bps: opp["basis_pct"] * 10000.0,
            timestamp: timestamp
        });
    }
    
    return #{
        symbol: symbol,
        timestamp: timestamp,
        spot_price: spot_px,
        perp_price: perp_px,
        premium_index: premium_idx,
        funding_rate_8h: funding_rate,
        annualized_yield: opp["annualized_yield"],
        opportunity: opp,
        alerts: alerts
    };
}
