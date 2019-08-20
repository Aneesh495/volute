// Volute Pipeline: Order Book Market Microstructure & Flow Toxicity
// Multi-level volume-weighted order book imbalance (VOBI), depth micro-price,
// Kyle's lambda price impact estimator, iceberg order detection, and liquidity collapse alerts.

import "lib/core/math" as m;

// -----------------------------------------------------------------------------
// Multi-Level Microstructure Metrics
// -----------------------------------------------------------------------------

fn calc_weighted_order_imbalance(bids, asks, max_levels) {
    let levels = if bids.len() < asks.len() { bids.len() } else { asks.len() };
    if levels > max_levels { levels = max_levels; }
    if levels == 0 { return 0.0; }
    
    let weighted_bid_vol = 0.0;
    let weighted_ask_vol = 0.0;
    
    for i in 0..levels {
        // Linear decay weighting across depth levels (level 0 has weight 1.0)
        let weight = (levels - i) * 1.0;
        weighted_bid_vol = weighted_bid_vol + bids[i]["size"] * weight;
        weighted_ask_vol = weighted_ask_vol + asks[i]["size"] * weight;
    }
    
    let total_vol = weighted_bid_vol + weighted_ask_vol;
    if total_vol <= 0.0 { return 0.0; }
    
    return (weighted_bid_vol - weighted_ask_vol) / total_vol;
}

fn calc_depth_micro_price(best_bid, best_ask, bids, asks, depth_levels) {
    let spread = best_ask - best_bid;
    let mid = 0.5 * (best_bid + best_ask);
    let vobi = calc_weighted_order_imbalance(bids, asks, depth_levels);
    
    // Depth-adjusted micro-price: mid shifted by fractional spread proportion
    return mid + 0.5 * spread * vobi;
}

// -----------------------------------------------------------------------------
// Effective Spread & Price Impact Decomposition
// -----------------------------------------------------------------------------

fn calc_trade_spread_metrics(trade_px, trade_size, is_buyer_initiated, pre_trade_mid, post_trade_mid_5s) {
    let q = if is_buyer_initiated { 1.0 } else { -1.0 };
    
    // Effective Half-Spread
    let effective_half_spread = q * (trade_px - pre_trade_mid);
    let effective_spread_bps = if pre_trade_mid > 0.0 { (2.0 * effective_half_spread / pre_trade_mid) * 10000.0 } else { 0.0 };
    
    // Realized Half-Spread (5-second benchmark)
    let realized_half_spread = q * (trade_px - post_trade_mid_5s);
    let realized_spread_bps = if pre_trade_mid > 0.0 { (2.0 * realized_half_spread / pre_trade_mid) * 10000.0 } else { 0.0 };
    
    // Price Impact (Adverse Selection component)
    let price_impact_bps = effective_spread_bps - realized_spread_bps;
    
    return #{
        effective_spread_bps: effective_spread_bps,
        realized_spread_bps: realized_spread_bps,
        price_impact_bps: price_impact_bps
    };
}

// -----------------------------------------------------------------------------
// Iceberg Hidden Volume Reload Detector
// -----------------------------------------------------------------------------

fn init_iceberg_detector() {
    return #{
        last_trade_px: 0.0,
        consecutive_fills_at_price: 0,
        accumulated_filled_size: 0.0,
        initial_displayed_size: 0.0
    };
}

fn track_iceberg_candidate(detector, trade_px, trade_size, current_visible_depth_at_px) {
    if (trade_px - detector["last_trade_px"]).abs() < 0.00001 {
        detector["consecutive_fills_at_price"] = detector["consecutive_fills_at_price"] + 1;
        detector["accumulated_filled_size"] = detector["accumulated_filled_size"] + trade_size;
    } else {
        detector["last_trade_px"] = trade_px;
        detector["consecutive_fills_at_price"] = 1;
        detector["accumulated_filled_size"] = trade_size;
        detector["initial_displayed_size"] = current_visible_depth_at_px;
    }
    
    // An iceberg order is suspected if executed volume at exact price exceeds 3.5x initial visible size
    let is_iceberg_suspect = false;
    let reload_ratio = 0.0;
    
    if detector["initial_displayed_size"] > 0.0 {
        reload_ratio = detector["accumulated_filled_size"] / detector["initial_displayed_size"];
        if reload_ratio >= 3.5 && detector["consecutive_fills_at_price"] >= 4 {
            is_iceberg_suspect = true;
        }
    }
    
    return #{
        is_iceberg: is_iceberg_suspect,
        price: trade_px,
        fills_count: detector["consecutive_fills_at_price"],
        accumulated_size: detector["accumulated_filled_size"],
        reload_ratio: reload_ratio
    };
}

// -----------------------------------------------------------------------------
// Liquidity Collapse / Flash Crash Guardrail
// -----------------------------------------------------------------------------

fn evaluate_liquidity_hole(bids, asks, prev_depth_notional, current_timestamp) {
    let current_bid_notional = 0.0;
    for b in bids { current_bid_notional = current_bid_notional + b["price"] * b["size"]; }
    
    let current_ask_notional = 0.0;
    for a in asks { current_ask_notional = current_ask_notional + a["price"] * a["size"]; }
    
    let total_current_depth = current_bid_notional + current_ask_notional;
    let alerts = [];
    
    if prev_depth_notional > 500000.0 {
        let depth_drawdown = (prev_depth_notional - total_current_depth) / prev_depth_notional;
        // If > 75% of order book depth vanishes in a single tick
        if depth_drawdown >= 0.75 {
            alerts.push(#{
                rule: "SUDDEN_LIQUIDITY_COLLAPSE",
                severity: "CRITICAL",
                depth_loss_pct: depth_drawdown * 100.0,
                prior_depth_usd: prev_depth_notional,
                current_depth_usd: total_current_depth,
                timestamp: current_timestamp
            });
        }
    }
    
    return #{
        current_total_depth: total_current_depth,
        alerts: alerts
    };
}

// -----------------------------------------------------------------------------
// Pipeline Event Handlers
// -----------------------------------------------------------------------------

fn process_microstructure_tick(event, pipeline_state) {
    let symbol = event["symbol"];
    let bids = event["bids"];
    let asks = event["asks"];
    let ts = event["timestamp"];
    
    if !pipeline_state.contains("iceberg_detectors") {
        pipeline_state["iceberg_detectors"] = #{};
        pipeline_state["last_depth_by_symbol"] = #{};
    }
    
    if !pipeline_state["iceberg_detectors"].contains(symbol) {
        pipeline_state["iceberg_detectors"][symbol] = init_iceberg_detector();
        pipeline_state["last_depth_by_symbol"][symbol] = 1000000.0;
    }
    
    let best_bid = if bids.len() > 0 { bids[0]["price"] } else { 0.0 };
    let best_ask = if asks.len() > 0 { asks[0]["price"] } else { 0.0 };
    let vobi = calc_weighted_order_imbalance(bids, asks, 5);
    let micro_px = calc_depth_micro_price(best_bid, best_ask, bids, asks, 5);
    
    let prev_depth = pipeline_state["last_depth_by_symbol"][symbol];
    let liq_eval = evaluate_liquidity_hole(bids, asks, prev_depth, ts);
    pipeline_state["last_depth_by_symbol"][symbol] = liq_eval["current_total_depth"];
    
    let alerts = liq_eval["alerts"];
    
    // Check trade execution if present in event
    if event.contains("trade") {
        let tr = event["trade"];
        let ice = track_iceberg_candidate(pipeline_state["iceberg_detectors"][symbol], tr["price"], tr["size"], tr["visible_size"]);
        if ice["is_iceberg"] {
            alerts.push(#{
                rule: "ICEBERG_ORDER_DETECTED",
                severity: "MEDIUM",
                symbol: symbol,
                price: ice["price"],
                accumulated_size: ice["accumulated_size"],
                reload_ratio: ice["reload_ratio"],
                timestamp: ts
            });
        }
    }
    
    return #{
        symbol: symbol,
        timestamp: ts,
        best_bid: best_bid,
        best_ask: best_ask,
        mid_price: 0.5 * (best_bid + best_ask),
        micro_price: micro_px,
        vobi_imbalance: vobi,
        total_depth_usd: liq_eval["current_total_depth"],
        alerts: alerts
    };
}
