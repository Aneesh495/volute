// Volute Test Suite: Advanced Analytics & Financial Telemetry
// Unit tests and integration tests for Options Greeks, Portfolio Risk, RADIUS AAA, OPC UA, and Distributed Tracing.

import "lib/testing/assert" as a;
import "pipelines/fintech/options_greeks_surface" as opt;
import "pipelines/fintech/portfolio_risk_engine" as risk;
import "pipelines/networking/radius_aaa_protocol" as rad;
import "pipelines/iot/opc_ua_binary_codec" as opc;
import "pipelines/telemetry/distributed_tracing_sampler" as trace;

fn test_normal_distribution_approximations() {
    let pdf0 = opt::standard_normal_pdf(0.0);
    a::assert_true((pdf0 - 0.398942).abs() < 0.0001, "PDF at 0 should equal 1/sqrt(2pi)");
    
    let cdf0 = opt::standard_normal_cdf(0.0);
    a::assert_true((cdf0 - 0.50).abs() < 0.0001, "CDF at 0 should equal 0.50");
    
    let cdf_196 = opt::standard_normal_cdf(1.96);
    a::assert_true((cdf_196 - 0.9750).abs() < 0.001, "CDF at 1.96 should equal ~0.975");
    
    let cdf_minus = opt::standard_normal_cdf(-1.96);
    a::assert_true((cdf_minus - 0.0250).abs() < 0.001, "CDF at -1.96 should equal ~0.025");
}

fn test_black_scholes_pricing_and_put_call_parity() {
    let spot = 100.0;
    let strike = 100.0;
    let rate = 0.05;
    let div = 0.0;
    let vol = 0.20;
    let t = 1.0;
    
    let call_px = opt::bs_price_call(spot, strike, rate, div, vol, t);
    let put_px = opt::bs_price_put(spot, strike, rate, div, vol, t);
    
    a::assert_true(call_px > 0.0, "Call price must be positive");
    a::assert_true(put_px > 0.0, "Put price must be positive");
    
    // Put-Call Parity: C - P = S - K * exp(-r*T)
    let discount = (-rate * t).exp();
    let parity_diff = (call_px - put_px) - (spot - strike * discount);
    a::assert_true(parity_diff.abs() < 0.001, "Put-call parity must hold");
}

fn test_first_and_second_order_greeks() {
    let spot = 100.0;
    let strike = 100.0;
    let rate = 0.05;
    let div = 0.0;
    let vol = 0.20;
    let t = 1.0;
    
    let delta_c = opt::greeks_delta(true, spot, strike, rate, div, vol, t);
    let delta_p = opt::greeks_delta(false, spot, strike, rate, div, vol, t);
    
    a::assert_true(delta_c > 0.5 && delta_c < 0.7, "ATM call delta should be around 0.6");
    a::assert_true(delta_p < 0.0 && delta_p > -0.5, "ATM put delta should be negative");
    a::assert_true(((delta_c - delta_p) - 1.0).abs() < 0.01, "Delta call minus delta put should equal 1");
    
    let gamma = opt::greeks_gamma(spot, strike, rate, div, vol, t);
    a::assert_true(gamma > 0.0, "Gamma must be positive");
    
    let vega = opt::greeks_vega(spot, strike, rate, div, vol, t);
    a::assert_true(vega > 0.0, "Vega must be positive");
    
    let theta_c = opt::greeks_theta(true, spot, strike, rate, div, vol, t);
    a::assert_true(theta_c < 0.0, "Calendar theta decay must be negative for long call");
}

fn test_implied_volatility_solver() {
    let spot = 100.0;
    let strike = 100.0;
    let rate = 0.05;
    let div = 0.0;
    let true_vol = 0.25;
    let t = 0.5;
    
    let mkt_call_price = opt::bs_price_call(spot, strike, rate, div, true_vol, t);
    let solved_vol = opt::solve_implied_vol_newton(mkt_call_price, true, spot, strike, rate, div, t, 30, 0.0001);
    
    a::assert_true((solved_vol - true_vol).abs() < 0.001, "Newton solver must recover true volatility");
}

fn test_multi_leg_strategy_profiles() {
    let condor = opt::build_iron_condor(100.0, 85.0, 90.0, 110.0, 115.0, 0.25, 0.50, 1.80, 1.80, 0.50);
    a::assert_eq(condor["strategy"], "IRON_CONDOR");
    a::assert_true(condor["net_credit"] > 0.0, "Iron condor must have positive net credit");
    a::assert_true(condor["max_loss"] > 0.0, "Iron condor max loss must be positive");
    
    let straddle = opt::build_straddle(100.0, 100.0, 0.25, 4.0, 3.5);
    a::assert_eq(straddle["total_cost"], 7.5);
    a::assert_eq(straddle["lower_breakeven"], 92.5);
    a::assert_eq(straddle["upper_breakeven"], 107.5);
}

fn test_portfolio_risk_parametric_var() {
    let port_value = 10000000.0; // $10M
    let daily_vol = 0.015; // 1.5% daily vol
    let var_99_1d = risk::parametric_var(port_value, daily_vol, 0.99, 1);
    
    a::assert_true(var_99_1d > 300000.0 && var_99_1d < 400000.0, "1-day 99% VaR on $10M at 1.5% vol should be ~348k");
    
    let var_99_10d = risk::parametric_var(port_value, daily_vol, 0.99, 10);
    a::assert_true(var_99_10d > var_99_1d * 3.0, "10-day VaR scales by sqrt(10)");
}

fn test_portfolio_covariance_and_stress() {
    let returns_a = [0.01, -0.02, 0.015, -0.005, 0.03];
    let returns_b = [0.008, -0.015, 0.012, -0.003, 0.025];
    
    let cov = risk::calc_sample_covariance(returns_a, returns_b);
    let corr = risk::calc_correlation(returns_a, returns_b);
    a::assert_true(corr > 0.90, "Positively aligned series should have correlation > 0.90");
    
    let positions = [
        #{ asset_class: "EQUITIES", market_value: 6000000.0 },
        #{ asset_class: "BONDS", market_value: 4000000.0 }
    ];
    let scenarios = risk::get_standard_stress_scenarios();
    let stress_results = risk::evaluate_stress_scenarios(positions, scenarios);
    
    a::assert_true(stress_results.len() >= 4, "Must evaluate at least 4 macro stress scenarios");
    let lehman = stress_results[0];
    a::assert_eq(lehman["scenario"], "2008_LEHMAN_CRUNCH");
    a::assert_true(lehman["stressed_pnl"] < 0.0, "Lehman crisis must generate portfolio loss");
}

fn test_radius_aaa_packet_decoding() {
    let raw_pkt = #{
        code: 4, // Accounting-Request
        id: 101,
        length: 64,
        authenticator: "0102030405060708090a0b0c0d0e0f10",
        attributes: [
            #{ type: 1, value: "trader_alice" },
            #{ type: 4, value: "10.0.0.1" },
            #{ type: 40, value: 1 }, // Start
            #{ type: 44, value: "sess-99482" }
        ]
    };
    
    let parsed = rad::parse_radius_packet(raw_pkt);
    a::assert_true(parsed["is_valid"], "Radius packet must parse successfully");
    a::assert_eq(parsed["code_name"], "Accounting-Request");
    a::assert_eq(parsed["attributes"]["User-Name"], "trader_alice");
    a::assert_eq(parsed["attributes"]["Acct-Status-Type"], "Start");
}

fn test_opc_ua_binary_node_id_and_alarms() {
    let nid = #{ encoding: "FourByte", namespace: 2, id: 1004 };
    let formatted = opc::format_node_id(nid);
    a::assert_eq(formatted, "ns=2;i=1004");
    
    let cfg = opc::create_analog_alarm_config("ns=2;s=Turbine.Temp", 20.0, 30.0, 85.0, 105.0, 2.0, 10.0);
    let st = opc::init_alarm_state(cfg);
    
    // Normal operation
    let ev1 = opc::evaluate_alarm_state(st, 50.0, 1000);
    a::assert_eq(st["current_alarm"], "NORMAL");
    
    // Trigger High Alarm
    let ev2 = opc::evaluate_alarm_state(st, 88.0, 1001);
    a::assert_eq(st["current_alarm"], "HIGH");
    a::assert_true(ev2.len() > 0, "Must generate state transition event to HIGH");
    
    // Trigger HighHigh Trip
    let ev3 = opc::evaluate_alarm_state(st, 108.0, 1002);
    a::assert_eq(st["current_alarm"], "HIGH_HIGH");
}

fn test_distributed_tracing_critical_path() {
    let spans = [
        trace::create_span("t1", "root", "", "GET /checkout", "gateway", "SERVER", 0, 1000000000, "OK", #{ "http.route": "/checkout" }),
        trace::create_span("t1", "auth", "root", "POST /auth", "auth-service", "SERVER", 50000000, 200000000, "OK", #{}),
        trace::create_span("t1", "db", "root", "SELECT items", "db-service", "CLIENT", 250000000, 950000000, "OK", #{ "db.statement": "SELECT * FROM orders" })
    ];
    
    let tree = trace::build_trace_tree(spans);
    let cp = trace::find_critical_path(tree);
    a::assert_eq(cp.len(), 2);
    a::assert_eq(cp[0]["span_id"], "root");
    a::assert_eq(cp[1]["span_id"], "db");
    
    let bottleneck = trace::analyze_latency_bottleneck(cp);
    a::assert_true(bottleneck["bottleneck_found"]);
    a::assert_eq(bottleneck["bottleneck_span_id"], "root");
}

fn main() {
    test_normal_distribution_approximations();
    test_black_scholes_pricing_and_put_call_parity();
    test_first_and_second_order_greeks();
    test_implied_volatility_solver();
    test_multi_leg_strategy_profiles();
    test_portfolio_risk_parametric_var();
    test_portfolio_covariance_and_stress();
    test_radius_aaa_packet_decoding();
    test_opc_ua_binary_node_id_and_alarms();
    test_distributed_tracing_critical_path();
}
