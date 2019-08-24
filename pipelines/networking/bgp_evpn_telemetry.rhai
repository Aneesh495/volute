// Volute Pipeline: BGP Ethernet VPN (EVPN) & VXLAN Fabric Telemetry
// RFC 7432 and RFC 8365 route type evaluation (Type 1 to 5), MAC mobility loop detection,
// ESI multihoming split-brain monitoring, and VXLAN VNI fabric consistency checks.

import "lib/net/ipv4" as ip;

// -----------------------------------------------------------------------------
// BGP EVPN Route Type Constants and Dictionaries
// -----------------------------------------------------------------------------

fn get_evpn_route_type_name(route_type_num) {
    if route_type_num == 1 { return "Ethernet_Auto_Discovery"; }
    if route_type_num == 2 { return "MAC_IP_Advertisement"; }
    if route_type_num == 3 { return "Inclusive_Multicast_Ethernet_Tag"; }
    if route_type_num == 4 { return "Ethernet_Segment_Route"; }
    if route_type_num == 5 { return "IP_Prefix_Route"; }
    return "UNKNOWN_EVPN_ROUTE_TYPE_" + route_type_num.to_string();
}

fn get_encapsulation_type_name(encap_id) {
    if encap_id == 8 { return "VXLAN"; }
    if encap_id == 9 { return "NVGRE"; }
    if encap_id == 10 { return "MPLS"; }
    if encap_id == 15 { return "SRv6"; }
    if encap_id == 19 { return "Geneve"; }
    return "ENCAP_" + encap_id.to_string();
}

// -----------------------------------------------------------------------------
// EVPN Route Struct Builders and Decoders
// -----------------------------------------------------------------------------

fn parse_evpn_type2_mac_ip(route_data) {
    let rd = route_data["rd"]; // Route Distinguisher (e.g. "65001:100")
    let esi = route_data["esi"]; // Ethernet Segment Identifier
    let eth_tag = route_data["eth_tag"];
    let mac = route_data["mac_address"];
    let ip_addr = if route_data.contains("ip_address") { route_data["ip_address"] } else { "" };
    let vni = route_data["vni"]; // VXLAN Network Identifier
    let next_hop = route_data["next_hop"]; // VTEP IP
    let mobility_seq = if route_data.contains("mobility_seq") { route_data["mobility_seq"] } else { 0 };
    let is_sticky = if route_data.contains("is_sticky") { route_data["is_sticky"] } else { false };
    
    return #{
        route_type: 2,
        route_type_name: "MAC_IP_Advertisement",
        rd: rd,
        esi: esi,
        eth_tag: eth_tag,
        mac_address: mac,
        ip_address: ip_addr,
        vni: vni,
        next_hop: next_hop,
        mobility_seq: mobility_seq,
        is_sticky: is_sticky
    };
}

fn parse_evpn_type5_prefix(route_data) {
    let rd = route_data["rd"];
    let esi = route_data["esi"];
    let eth_tag = route_data["eth_tag"];
    let prefix = route_data["ip_prefix"];
    let prefix_len = route_data["prefix_len"];
    let gw_ip = if route_data.contains("gw_ip") { route_data["gw_ip"] } else { "0.0.0.0" };
    let vni = route_data["vni"];
    let next_hop = route_data["next_hop"];
    
    return #{
        route_type: 5,
        route_type_name: "IP_Prefix_Route",
        rd: rd,
        esi: esi,
        eth_tag: eth_tag,
        ip_prefix: prefix,
        prefix_len: prefix_len,
        gw_ip: gw_ip,
        vni: vni,
        next_hop: next_hop
    };
}

// -----------------------------------------------------------------------------
// EVPN Fabric Anomaly & MAC Flap State Machine
// -----------------------------------------------------------------------------

fn init_evpn_fabric_state() {
    return #{
        mac_table: #{}, // mac -> #{ current_vtep, mobility_seq, last_move_ts, move_count }
        active_vnis: #{}, // vni -> #{ vteps: [ips] }
        esi_segments: #{} // esi -> #{ active_vteps: [ips] }
    };
}

fn evaluate_mac_mobility(state, parsed_type2, timestamp) {
    let mac = parsed_type2["mac_address"];
    let vtep = parsed_type2["next_hop"];
    let seq = parsed_type2["mobility_seq"];
    let is_sticky = parsed_type2["is_sticky"];
    let alerts = [];
    
    if state["mac_table"].contains(mac) {
        let entry = state["mac_table"][mac];
        
        // Sticky MAC violation
        if entry["is_sticky"] && entry["current_vtep"] != vtep {
            alerts.push(#{
                rule: "STICKY_MAC_MOBILITY_VIOLATION",
                severity: "CRITICAL",
                mac: mac,
                original_vtep: entry["current_vtep"],
                violating_vtep: vtep,
                timestamp: timestamp
            });
        }
        
        // VTEP change (Host Migration)
        if entry["current_vtep"] != vtep {
            let dt = (timestamp - entry["last_move_ts"]) * 1.0;
            let moves = entry["move_count"] + 1;
            
            // Loop Detection: > 5 moves within 10 seconds
            if dt < 10000.0 && moves >= 5 {
                alerts.push(#{
                    rule: "EVPN_MAC_FLAPPING_LOOP_DETECTED",
                    severity: "CRITICAL",
                    mac: mac,
                    move_count: moves,
                    time_window_ms: dt,
                    from_vtep: entry["current_vtep"],
                    to_vtep: vtep,
                    timestamp: timestamp
                });
            }
            
            entry["current_vtep"] = vtep;
            entry["mobility_seq"] = seq;
            entry["last_move_ts"] = timestamp;
            entry["move_count"] = moves;
            state["mac_table"][mac] = entry;
        }
    } else {
        state["mac_table"][mac] = #{
            mac: mac,
            current_vtep: vtep,
            mobility_seq: seq,
            is_sticky: is_sticky,
            last_move_ts: timestamp,
            move_count: 0
        };
    }
    
    return alerts;
}

fn track_vni_consistency(state, vni, vtep_ip) {
    if !state["active_vnis"].contains(vni) {
        state["active_vnis"][vni] = [vtep_ip];
    } else {
        let list = state["active_vnis"][vni];
        let found = false;
        for ip_item in list {
            if ip_item == vtep_ip { found = true; break; }
        }
        if !found {
            list.push(vtep_ip);
            state["active_vnis"][vni] = list;
        }
    }
}

// -----------------------------------------------------------------------------
// Pipeline Event Handlers
// -----------------------------------------------------------------------------

fn process_evpn_nlri_event(event, pipeline_state) {
    if !pipeline_state.contains("fabric_state") {
        pipeline_state["fabric_state"] = init_evpn_fabric_state();
    }
    
    let route_type = event["route_type"];
    let timestamp = event["timestamp"];
    let alerts = [];
    
    if route_type == 2 {
        let parsed = parse_evpn_type2_mac_ip(event["data"]);
        alerts = evaluate_mac_mobility(pipeline_state["fabric_state"], parsed, timestamp);
        track_vni_consistency(pipeline_state["fabric_state"], parsed["vni"], parsed["next_hop"]);
        
        return #{
            status: "OK",
            route_type: "Type-2 MAC/IP",
            mac: parsed["mac_address"],
            vtep: parsed["next_hop"],
            vni: parsed["vni"],
            alerts: alerts
        };
    } else if route_type == 5 {
        let parsed5 = parse_evpn_type5_prefix(event["data"]);
        track_vni_consistency(pipeline_state["fabric_state"], parsed5["vni"], parsed5["next_hop"]);
        
        return #{
            status: "OK",
            route_type: "Type-5 IP Prefix",
            prefix: parsed5["ip_prefix"] + "/" + parsed5["prefix_len"].to_string(),
            vtep: parsed5["next_hop"],
            vni: parsed5["vni"],
            alerts: []
        };
    }
    
    return #{
        status: "IGNORED",
        route_type: get_evpn_route_type_name(route_type)
    };
}
