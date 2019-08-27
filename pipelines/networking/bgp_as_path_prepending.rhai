// Volute Pipeline: BGP AS-Path Policy, Prepending, & Route Leak Detection
// RFC 4271 AS-Path sequence analysis, RFC 7908 valley-free route leak identification,
// AS-Path loop detection, origin hijack alerts, and transit peering policy validation.

// -----------------------------------------------------------------------------
// AS-Path Parsing and Basic Inspection
// -----------------------------------------------------------------------------

fn parse_as_path(as_path_str) {
    let clean = as_path_str.trim();
    let asns = [];
    if clean.is_empty() { return asns; }
    
    let tokens = clean.split(" ");
    for t in tokens {
        let trimmed = t.trim();
        if !trimmed.is_empty() {
            asns.push(trimmed.to_int());
        }
    }
    return asns;
}

fn get_origin_asn(as_path_list) {
    let n = as_path_list.len();
    if n == 0 { return 0; }
    // Origin AS is the last element in AS_SEQUENCE
    return as_path_list[n - 1];
}

fn get_neighbor_asn(as_path_list) {
    if as_path_list.len() == 0 { return 0; }
    // Neighbor AS is the first element
    return as_path_list[0];
}

// -----------------------------------------------------------------------------
// Route Leak and Policy Evaluators (RFC 7908 Valley-Free Routing)
// -----------------------------------------------------------------------------

fn check_as_path_loop(as_path_list, local_asn) {
    for asn in as_path_list {
        if asn == local_asn {
            return true;
        }
    }
    return false;
}

fn count_as_prepending(as_path_list) {
    let prepends = 0;
    let n = as_path_list.len();
    if n < 2 { return 0; }
    
    for i in 1..n {
        if as_path_list[i] == as_path_list[i - 1] {
            prepends = prepends + 1;
        }
    }
    return prepends;
}

fn evaluate_bgp_route_leak(as_path_list, prefix, peer_type, sender_asn, known_customer_asns, known_peer_asns) {
    // Peer types: "CUSTOMER", "PEER", "PROVIDER"
    let alerts = [];
    let n = as_path_list.len();
    if n < 2 { return alerts; }
    
    // RFC 7908 Route Leak Rule: A route received from a Peer or Provider must NOT
    // contain transit through another Peer or Provider when announced by a Peer.
    if peer_type == "PEER" || peer_type == "PROVIDER" {
        for i in 1..n {
            let intermediate_asn = as_path_list[i];
            let is_known_peer = false;
            for p in known_peer_asns {
                if p == intermediate_asn { is_known_peer = true; break; }
            }
            if is_known_peer {
                alerts.push(#{
                    rule: "RFC7908_PEER_TO_PEER_ROUTE_LEAK",
                    severity: "CRITICAL",
                    prefix: prefix,
                    leaking_asn: sender_asn,
                    transit_peer_asn: intermediate_asn,
                    as_path: as_path_list
                });
                break;
            }
        }
    }
    
    return alerts;
}

// -----------------------------------------------------------------------------
// Pipeline Event Handlers
// -----------------------------------------------------------------------------

fn process_bgp_announcement(event, pipeline_state) {
    let prefix = event["prefix"];
    let raw_path = event["as_path"];
    let sender_asn = event["sender_asn"];
    let peer_type = event["peer_type"]; // "CUSTOMER", "PEER", "PROVIDER"
    let local_asn = if event.contains("local_asn") { event["local_asn"] } else { 65000 };
    let timestamp = event["timestamp"];
    
    let path = parse_as_path(raw_path);
    let alerts = [];
    
    // Check 1: AS-Path Loop
    if check_as_path_loop(path, local_asn) {
        alerts.push(#{
            rule: "BGP_AS_PATH_LOOP_DETECTED",
            severity: "HIGH",
            prefix: prefix,
            local_asn: local_asn,
            timestamp: timestamp
        });
    }
    
    // Check 2: Excessive Prepending (> 8 prepended hops)
    let prepends = count_as_prepending(path);
    if prepends >= 8 {
        alerts.push(#{
            rule: "EXCESSIVE_AS_PATH_PREPENDING",
            severity: "MEDIUM",
            prefix: prefix,
            prepend_count: prepends,
            total_path_length: path.len(),
            timestamp: timestamp
        });
    }
    
    // Check 3: Route Leak Check against known IXP peers
    let known_peers = [15169, 13335, 20940, 32934]; // Google, Cloudflare, Akamai, Meta
    let leak_alerts = evaluate_bgp_route_leak(path, prefix, peer_type, sender_asn, [], known_peers);
    for la in leak_alerts {
        alerts.push(la);
    }
    
    return #{
        status: "OK",
        prefix: prefix,
        origin_asn: get_origin_asn(path),
        path_length: path.len(),
        prepends: prepends,
        alerts: alerts
    };
}
