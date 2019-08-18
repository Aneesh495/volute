// Volute Pipeline: Foreign Exchange (FX) Cross-Currency Triangular Arbitrage Engine
// Directed currency graph modeling, negative cycle detection on -ln(rates) weighted paths,
// orderbook depth slippage estimation, exchange fee erosion, and synthetic cross-rate generation.

import "lib/core/math" as m;

// -----------------------------------------------------------------------------
// FX Currency Graph Representation
// -----------------------------------------------------------------------------

fn create_fx_market_graph() {
    return #{
        currencies: ["USD", "EUR", "GBP", "JPY", "CHF", "AUD", "CAD"],
        rates: #{}, // "EUR/USD" -> #{ bid, ask }
        log_weights: #{} // "EUR->USD" -> -ln(bid), "USD->EUR" -> ln(ask)
    };
}

fn update_fx_pair(graph, pair, bid_px, ask_px) {
    graph["rates"][pair] = #{
        bid: bid_px,
        ask: ask_px
    };
    
    let parts = pair.split("/");
    if parts.len() == 2 {
        let base = parts[0];
        let quote = parts[1];
        
        // Base -> Quote: sell Base at bid price
        if bid_px > 0.0 {
            graph["log_weights"][base + "->" + quote] = -(bid_px.ln());
        }
        // Quote -> Base: buy Base at ask price (rate is 1 / ask)
        if ask_px > 0.0 {
            let inv_rate = 1.0 / ask_px;
            graph["log_weights"][quote + "->" + base] = -(inv_rate.ln());
        }
    }
}

// -----------------------------------------------------------------------------
// Direct Triangular Path Evaluation
// -----------------------------------------------------------------------------

fn evaluate_triangular_path(graph, c1, c2, c3, initial_amount, fee_rate) {
    let leg1_key = c1 + "->" + c2;
    let leg2_key = c2 + "->" + c3;
    let leg3_key = c3 + "->" + c1;
    
    let lw = graph["log_weights"];
    if !lw.contains(leg1_key) || !lw.contains(leg2_key) || !lw.contains(leg3_key) {
        return #{ has_arbitrage: false };
    }
    
    // Negative cycle check: sum of negative log rates < 0 <=> product of rates > 1.0
    let total_log_weight = lw[leg1_key] + lw[leg2_key] + lw[leg3_key];
    let gross_multiplier = (-total_log_weight).exp();
    
    // 3 legs fee compounding: (1 - fee)^3
    let net_fee_multiplier = (1.0 - fee_rate) * (1.0 - fee_rate) * (1.0 - fee_rate);
    let net_multiplier = gross_multiplier * net_fee_multiplier;
    
    let final_amount = initial_amount * net_multiplier;
    let profit = final_amount - initial_amount;
    let profit_bps = (net_multiplier - 1.0) * 10000.0;
    
    let has_arb = profit > 0.0 && profit_bps > 1.5; // Minimum 1.5 bps hurdle
    
    return #{
        path: c1 + " -> " + c2 + " -> " + c3 + " -> " + c1,
        c1: c1,
        c2: c2,
        c3: c3,
        gross_multiplier: gross_multiplier,
        net_multiplier: net_multiplier,
        profit_usd: profit,
        profit_bps: profit_bps,
        has_arbitrage: has_arb
    };
}

fn scan_all_triangles(graph, initial_amount, fee_rate) {
    let opportunities = [];
    let currs = graph["currencies"];
    let n = currs.len();
    
    for i in 0..n {
        let c1 = currs[i];
        for j in 0..n {
            if j == i { continue; }
            let c2 = currs[j];
            for k in 0..n {
                if k == i || k == j { continue; }
                let c3 = currs[k];
                
                let res = evaluate_triangular_path(graph, c1, c2, c3, initial_amount, fee_rate);
                if res["has_arbitrage"] {
                    opportunities.push(res);
                }
            }
        }
    }
    return opportunities;
}

// -----------------------------------------------------------------------------
// Synthetic Cross-Rate Pricing
// -----------------------------------------------------------------------------

fn derive_synthetic_cross(graph, base, quote, vehicle) {
    // Example: derive EUR/GBP via USD vehicle
    let base_usd = base + "/USD";
    let quote_usd = quote + "/USD";
    let usd_quote = "USD/" + quote;
    
    let rates = graph["rates"];
    let syn_bid = 0.0;
    let syn_ask = 0.0;
    
    if rates.contains(base_usd) && rates.contains(quote_usd) {
        // EUR/USD / (GBP/USD) = EUR/GBP
        let base_bid = rates[base_usd]["bid"];
        let base_ask = rates[base_usd]["ask"];
        let quote_bid = rates[quote_usd]["bid"];
        let quote_ask = rates[quote_usd]["ask"];
        
        syn_bid = base_bid / quote_ask;
        syn_ask = base_ask / quote_bid;
    } else if rates.contains(base_usd) && rates.contains(usd_quote) {
        // EUR/USD * USD/JPY = EUR/JPY
        let base_bid = rates[base_usd]["bid"];
        let base_ask = rates[base_usd]["ask"];
        let q_bid = rates[usd_quote]["bid"];
        let q_ask = rates[usd_quote]["ask"];
        
        syn_bid = base_bid * q_bid;
        syn_ask = base_ask * q_ask;
    }
    
    return #{
        pair: base + "/" + quote,
        synthetic_bid: syn_bid,
        synthetic_ask: syn_ask,
        mid: 0.5 * (syn_bid + syn_ask)
    };
}

// -----------------------------------------------------------------------------
// Pipeline Event Handlers
// -----------------------------------------------------------------------------

fn process_fx_ticks_batch(event, pipeline_state) {
    if !pipeline_state.contains("graph") {
        pipeline_state["graph"] = create_fx_market_graph();
    }
    
    let ticks = event["ticks"]; // array of #{ pair, bid, ask }
    for t in ticks {
        update_fx_pair(pipeline_state["graph"], t["pair"], t["bid"], t["ask"]);
    }
    
    let fee = if event.contains("fee_rate") { event["fee_rate"] } else { 0.00005 }; // 0.5 bps fee
    let notional = if event.contains("notional") { event["notional"] } else { 1000000.0 }; // $1M notional
    let opportunities = scan_all_triangles(pipeline_state["graph"], notional, fee);
    
    let alerts = [];
    for opp in opportunities {
        alerts.push(#{
            rule: "FX_TRIANGULAR_ARBITRAGE_DETECTED",
            severity: "HIGH",
            path: opp["path"],
            profit_bps: opp["profit_bps"],
            profit_usd: opp["profit_usd"],
            timestamp: event["timestamp"]
        });
    }
    
    return #{
        status: "OK",
        timestamp: event["timestamp"],
        pairs_tracked: pipeline_state["graph"]["rates"].len(),
        arbitrage_count: opportunities.len(),
        opportunities: opportunities,
        alerts: alerts
    };
}
