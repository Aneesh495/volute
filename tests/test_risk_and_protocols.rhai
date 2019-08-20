// Volute Test Suite: Risk Models and Network Protocol Fabric
// Unit and integration tests for Drift Detection, eBPF RTT Histograms, Yield Curves,
// TLS Handshake Auditing, FAST Protocol, CoAP Telemetry, DoH Wire Auditor, Basel IRB, and FX Triangular Arbitrage.

import "lib/testing/assert" as a;
import "pipelines/data_quality/anomalous_drift_detector" as drift;
import "pipelines/telemetry/ebpf_tcp_rtt_histogram" as rtt;
import "pipelines/fintech/fixed_income_yield_curve" as fi;
import "pipelines/security/tls_cipher_suite_auditor" as tls;
import "pipelines/fintech/fix_fast_protocol" as fast;
import "pipelines/iot/coap_sensor_protocol" as coap;
import "pipelines/security/dns_over_https_auditor" as doh;
import "pipelines/fintech/credit_risk_scoring_engine" as irb;
import "pipelines/fintech/fx_triangular_arbitrage" as arb;

fn test_data_drift_psi_and_ks() {
    let baseline = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0];
    let identical = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0];
    let drifted = [20.0, 22.0, 25.0, 28.0, 30.0, 32.0, 35.0, 38.0, 40.0, 50.0];
    
    let psi_ident = drift::compute_psi(baseline, identical, 5);
    a::assert_eq(psi_ident["status"], "STABLE");
    a::assert_true(psi_ident["psi"] < 0.05, "Identical samples must have near-zero PSI");
    
    let psi_drift = drift::compute_psi(baseline, drifted, 5);
    a::assert_eq(psi_drift["status"], "CRITICAL_DRIFT");
    a::assert_true(psi_drift["psi"] >= 0.25, "Separated samples must exhibit critical drift");
    
    let ks_ident = drift::compute_ks_statistic(baseline, identical);
    a::assert_false(ks_ident["is_drift"], "Identical samples should not fail KS test");
    
    let ks_drift = drift::compute_ks_statistic(baseline, drifted);
    a::assert_true(ks_drift["is_drift"], "Drifted samples must trigger KS statistic threshold");
}

fn test_ebpf_tcp_rtt_log2_histogram() {
    let hist = rtt::init_rtt_histogram();
    
    // Record microsecond latency samples
    for i in 0..100 {
        rtt::record_rtt_sample(hist, 50); // 50 us
    }
    for i in 0..10 {
        rtt::record_rtt_sample(hist, 150000); // 150 ms tail spike
    }
    
    let summary = rtt::compute_histogram_summary(hist);
    a::assert_eq(summary["count"], 110);
    a::assert_true(summary["p50_us"] < 100.0, "p50 latency should be around 50 us");
    a::assert_true(summary["p99_us"] > 100000.0, "p99 latency should capture tail spike");
    
    let alerts = rtt::evaluate_latency_anomalies(summary, "payment-gateway", 1000);
    a::assert_true(alerts.len() > 0, "Must alert on p99 > 100ms threshold");
}

fn test_fixed_income_yield_curve_and_duration() {
    let beta0 = 0.045; // Long term level: 4.5%
    let beta1 = -0.015; // Slope
    let beta2 = 0.010; // Curvature
    let tau = 2.5;
    
    let y_2y = fi::nelson_siegel_yield(2.0, beta0, beta1, beta2, tau);
    let y_10y = fi::nelson_siegel_yield(10.0, beta0, beta1, beta2, tau);
    
    a::assert_true(y_2y > 0.03 && y_2y < 0.06, "2Y yield in expected range");
    a::assert_true(y_10y > 0.03 && y_10y < 0.06, "10Y yield in expected range");
    
    let cfs = fi::generate_bond_cash_flows(1000.0, 0.05, 5.0, 2);
    a::assert_eq(cfs.len(), 10); // 5 years * 2 semi-annual payments
    
    let risk_metrics = fi::calc_bond_risk_metrics(cfs, 0.05, 2, 1000.0);
    a::assert_true((risk_metrics["dirty_price"] - 1000.0).abs() < 1.0, "Par bond price equals ~1000");
    a::assert_true(risk_metrics["modified_duration"] > 4.0 && risk_metrics["modified_duration"] < 4.6, "5Y bond duration ~4.3");
    a::assert_true(risk_metrics["dv01"] > 0.40, "DV01 must be positive");
}

fn test_tls_cipher_auditor_and_ja3() {
    let modern_cipher = tls::classify_cipher_suite("0x1301"); // TLS_AES_128_GCM_SHA256
    a::assert_eq(modern_cipher["grade"], "SECURE");
    a::assert_true(modern_cipher["aead"]);
    a::assert_true(modern_cipher["pfs"]);
    
    let sweet32_cipher = tls::classify_cipher_suite("0x000a"); // 3DES
    a::assert_eq(sweet32_cipher["grade"], "INSECURE");
    a::assert_eq(sweet32_cipher["vulnerability"], "SWEET32_64BIT_BLOCK");
    
    let ja3_str = tls::build_ja3_string("0303", ["002f", "0035"], ["0000", "000a"], ["0017"], ["00"]);
    a::assert_eq(ja3_str, "0303,002f-0035,0000-000a,0017,00");
}

fn test_fast_protocol_stop_bit_decoding() {
    // 0x39 (57 with MSB unset) then 0x82 (2 with MSB set): 57 * 128 + 2 = 7298
    let bytes = [57, 130];
    let decoded = fast::decode_fast_uint(bytes, 0);
    a::assert_eq(decoded["value"], 7298);
    a::assert_eq(decoded["next_offset"], 2);
    
    // Test presence map
    let pmap_bytes = [128 + 32 + 8]; // bits 5 and 3 set with stop bit
    let pmap_res = fast::parse_presence_map(pmap_bytes, 0);
    a::assert_eq(pmap_res["bits"].len(), 7);
}

fn test_coap_sensor_protocol_parsing() {
    let raw_pkt = #{
        version: 1,
        type: 0, // CON
        tkl: 4,
        code_class: 0,
        code_detail: 1, // GET
        message_id: 4096,
        token: "abcd",
        options: [
            #{ delta: 11, value: "sensors" },
            #{ delta: 0, value: "temperature" },
            #{ delta: 6, value: 1 } // Option 17 (Accept)
        ]
    };
    
    let parsed = coap::parse_coap_packet(raw_pkt);
    a::assert_true(parsed["is_valid"]);
    a::assert_eq(parsed["type"], "CON");
    a::assert_eq(parsed["code"], "GET");
    a::assert_eq(parsed["path"], "/sensors/temperature");
}

fn test_doh_dns_wire_and_entropy() {
    let low_entropy = doh::calc_label_entropy("google");
    let high_entropy = doh::calc_label_entropy("x7k9q2m1w8z4p0");
    a::assert_true(high_entropy > low_entropy, "Random DGA string must have higher Shannon entropy");
    
    let raw_dns = #{
        id: 54321,
        is_response: false,
        opcode: 0,
        rcode: 0,
        questions: [
            #{ qname: "api.volute-stream.io", qtype: 1 }
        ]
    };
    
    let parsed = doh::parse_dns_message(raw_dns);
    a::assert_eq(parsed["id"], 54321);
    a::assert_eq(parsed["questions"][0]["qtype"], "A");
}

fn test_basel_irb_credit_risk() {
    let pd = irb::estimate_probability_of_default(0.25, 0.70, 0, 720);
    a::assert_true(pd < 0.05, "Prime borrower should have PD < 5%");
    
    let ead = irb::calc_exposure_at_default(500000.0, 200000.0, "REVOLVING_CREDIT");
    a::assert_eq(ead, 600000.0); // 500k + 200k * 0.50
    
    let lgd = irb::estimate_loss_given_default("CASH", 300000.0, ead, "SENIOR_SECURED");
    a::assert_true(lgd < 0.60, "Secured loan with cash collateral must have low LGD");
    
    let irb_res = irb::calc_basel_irb_capital(pd, lgd, ead, 3.0, true);
    a::assert_true(irb_res["rwa"] > 0.0, "RWA must be positive");
    a::assert_true(irb_res["expected_loss"] > 0.0, "Expected loss must be positive");
}

fn test_fx_triangular_arbitrage() {
    let graph = arb::create_fx_market_graph();
    
    // Normal no-arbitrage market
    arb::update_fx_pair(graph, "EUR/USD", 1.1000, 1.1002);
    arb::update_fx_pair(graph, "GBP/USD", 1.3000, 1.3002);
    arb::update_fx_pair(graph, "EUR/GBP", 0.8460, 0.8462);
    
    let opps = arb::scan_all_triangles(graph, 1000000.0, 0.00005);
    // Under tight fair pricing, no positive cycle exists
    a::assert_eq(opps.len(), 0);
    
    // Inject artificial triangular arbitrage mispricing on EUR/GBP bid
    arb::update_fx_pair(graph, "EUR/GBP", 0.8520, 0.8522);
    let opps2 = arb::scan_all_triangles(graph, 1000000.0, 0.00005);
    a::assert_true(opps2.len() > 0, "Mispricing must trigger triangular arbitrage opportunity");
}

fn main() {
    test_data_drift_psi_and_ks();
    test_ebpf_tcp_rtt_log2_histogram();
    test_fixed_income_yield_curve_and_duration();
    test_tls_cipher_auditor_and_ja3();
    test_fast_protocol_stop_bit_decoding();
    test_coap_sensor_protocol_parsing();
    test_doh_dns_wire_and_entropy();
    test_basel_irb_credit_risk();
    test_fx_triangular_arbitrage();
}
