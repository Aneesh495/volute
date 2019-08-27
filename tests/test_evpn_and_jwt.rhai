// Volute Test Suite: EVPN Fabric, JWT Security, and Order Book Microstructure
// Unit and integration tests for BGP EVPN NLRI, MAC mobility flapping, JWT claim validation,
// algorithm confusion defense, order book weighted imbalance, and VM page cache telemetry.

import "lib/testing/assert" as a;
import "pipelines/networking/bgp_evpn_telemetry" as evpn;
import "pipelines/security/oauth2_oidc_jwt_validator" as jwt;
import "pipelines/fintech/fx_order_book_microstructure" as ob;
import "pipelines/telemetry/ebpf_page_cache_latency" as vm;

fn test_evpn_type2_mac_ip_parsing() {
    let raw_data = #{
        rd: "65001:100",
        esi: "00:11:22:33:44:55:66:77:88:99",
        eth_tag: 0,
        mac_address: "52:54:00:12:34:56",
        ip_address: "10.100.1.50",
        vni: 10100,
        next_hop: "192.168.1.1",
        mobility_seq: 1,
        is_sticky: false
    };
    
    let parsed = evpn::parse_evpn_type2_mac_ip(raw_data);
    a::assert_eq(parsed["route_type"], 2);
    a::assert_eq(parsed["mac_address"], "52:54:00:12:34:56");
    a::assert_eq(parsed["vni"], 10100);
}

fn test_evpn_mac_mobility_and_loop_detection() {
    let state = evpn::init_evpn_fabric_state();
    let mac = "aa:bb:cc:dd:ee:01";
    
    // Initial placement at Leaf-1
    let r1 = #{
        rd: "65001:100", esi: "0", eth_tag: 0, mac_address: mac,
        vni: 10100, next_hop: "10.0.0.1", mobility_seq: 0, is_sticky: false
    };
    let al1 = evpn::evaluate_mac_mobility(state, r1, 1000);
    a::assert_eq(al1.len(), 0);
    
    // Simulate rapid flapping across Leaf-1 and Leaf-2
    let moves = [
        "10.0.0.2", "10.0.0.1", "10.0.0.2", "10.0.0.1", "10.0.0.2"
    ];
    let detected_loop = false;
    for i in 0..moves.len() {
        let vtep = moves[i];
        let r = #{
            rd: "65001:100", esi: "0", eth_tag: 0, mac_address: mac,
            vni: 10100, next_hop: vtep, mobility_seq: i + 1, is_sticky: false
        };
        let als = evpn::evaluate_mac_mobility(state, r, 1000 + i * 500); // 500ms intervals
        for al in als {
            if al["rule"] == "EVPN_MAC_FLAPPING_LOOP_DETECTED" {
                detected_loop = true;
            }
        }
    }
    
    a::assert_true(detected_loop, "Rapid moves within 10s must trigger EVPN_MAC_FLAPPING_LOOP_DETECTED");
}

fn test_jwt_none_algorithm_and_confusion() {
    let issuers = ["https://auth.company.internal"];
    let state = jwt::init_jwt_validator_state(issuers, "api://payments");
    
    // Test 1: Attack with alg = "none"
    let bad_header = #{ alg: "none", typ: "JWT" };
    let payload = #{ iss: "https://auth.company.internal", aud: "api://payments", exp: 2000000000 };
    let res1 = jwt::evaluate_jwt_security(bad_header, payload, state, 1700000000);
    
    a::assert_false(res1["is_authorized"]);
    a::assert_eq(res1["alerts"][0]["rule"], "CRITICAL_JWT_NONE_ALGORITHM_ATTACK");
    
    // Test 2: Attack with alg confusion HS256 with RSA kid
    let confusion_header = #{ alg: "HS256", typ: "JWT", kid: "rsa-key-2026-prod" };
    let res2 = jwt::evaluate_jwt_security(confusion_header, payload, state, 1700000000);
    let has_confusion_alert = false;
    for al in res2["alerts"] {
        if al["rule"] == "SUSPECTED_ALGORITHM_CONFUSION_ATTACK" {
            has_confusion_alert = true;
        }
    }
    a::assert_true(has_confusion_alert, "HS256 with RSA kid must trigger confusion warning");
}

fn test_jwt_jti_replay_cache() {
    let issuers = ["https://auth.company.internal"];
    let state = jwt::init_jwt_validator_state(issuers, "api://payments");
    let header = #{ alg: "RS256", typ: "JWT" };
    let payload = #{
        iss: "https://auth.company.internal",
        aud: "api://payments",
        exp: 2000000000,
        jti: "token-nonce-991284"
    };
    
    // First evaluation: Authorized
    let res1 = jwt::evaluate_jwt_security(header, payload, state, 1700000000);
    a::assert_true(res1["is_authorized"]);
    
    // Second evaluation with identical jti: Replay attack detected
    let res2 = jwt::evaluate_jwt_security(header, payload, state, 1700000005);
    a::assert_false(res2["is_authorized"]);
    a::assert_eq(res2["alerts"][0]["rule"], "REPLAYED_JWT_IDENTIFIER_DETECTED");
}

fn test_order_book_vobi_and_iceberg() {
    let bids = [
        #{ price: 100.0, size: 50.0 },
        #{ price: 99.9, size: 40.0 },
        #{ price: 99.8, size: 30.0 }
    ];
    let asks = [
        #{ price: 100.1, size: 10.0 },
        #{ price: 100.2, size: 10.0 },
        #{ price: 100.3, size: 10.0 }
    ];
    
    let vobi = ob::calc_weighted_order_imbalance(bids, asks, 3);
    a::assert_true(vobi > 0.40, "Heavy bid side should generate positive VOBI imbalance > 0.40");
    
    let micro_px = ob::calc_depth_micro_price(100.0, 100.1, bids, asks, 3);
    a::assert_true(micro_px > 100.05, "Micro-price should skew towards ask when bid pressure is high");
    
    // Test Iceberg Detector
    let det = ob::init_iceberg_detector();
    // 5 fills of 10 lots at 100.0 when initial visible was only 5 lots
    for i in 0..5 {
        let ice = ob::track_iceberg_candidate(det, 100.0, 10.0, 5.0);
        if i == 4 {
            a::assert_true(ice["is_iceberg"], "50 lots filled against 5 visible must flag iceberg");
        }
    }
}

fn test_page_cache_dirty_ratio_and_reclaim() {
    let dirty_ratio = vm::calc_dirty_page_ratio(25000, 100000);
    a::assert_eq(dirty_ratio, 25.0);
    
    let state = vm::init_page_cache_state();
    state["cached_pages"] = 100000;
    state["dirty_pages"] = 25000;
    
    let reclaim = #{ duration_us: 15000.0, nr_reclaimed: 128, order: 0 };
    let alerts = vm::evaluate_page_cache_anomalies(state, reclaim, 1000);
    
    a::assert_true(alerts.len() >= 2, "Must trigger both DIRTY_RATIO and DIRECT_RECLAIM_STALL alerts");
}

fn main() {
    test_evpn_type2_mac_ip_parsing();
    test_evpn_mac_mobility_and_loop_detection();
    test_jwt_none_algorithm_and_confusion();
    test_jwt_jti_replay_cache();
    test_order_book_vobi_and_iceberg();
    test_page_cache_dirty_ratio_and_reclaim();
}
