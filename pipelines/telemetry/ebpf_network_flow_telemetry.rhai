// Volute Pipeline: Linux eBPF Kernel Network Flow Telemetry
// High-frequency TCP/UDP socket lifecycle monitoring, XDP/TC drop analysis,
// RTT kernel latency tracking, TCP zero-window detection, and connection churn alerts.

import "lib/net/ipv4" as ip;

// -----------------------------------------------------------------------------
// TCP State Dictionaries and Flags
// -----------------------------------------------------------------------------

fn get_tcp_state_name(state_num) {
    if state_num == 1 { return "ESTABLISHED"; }
    if state_num == 2 { return "SYN_SENT"; }
    if state_num == 3 { return "SYN_RECV"; }
    if state_num == 4 { return "FIN_WAIT1"; }
    if state_num == 5 { return "FIN_WAIT2"; }
    if state_num == 6 { return "TIME_WAIT"; }
    if state_num == 7 { return "CLOSE"; }
    if state_num == 8 { return "CLOSE_WAIT"; }
    if state_num == 9 { return "LAST_ACK"; }
    if state_num == 10 { return "LISTEN"; }
    if state_num == 11 { return "CLOSING"; }
    if state_num == 12 { return "NEW_SYN_RECV"; }
    return "UNKNOWN_TCP_STATE_" + state_num.to_string();
}

fn get_xdp_action_name(action_id) {
    if action_id == 0 { return "XDP_ABORTED"; }
    if action_id == 1 { return "XDP_DROP"; }
    if action_id == 2 { return "XDP_PASS"; }
    if action_id == 3 { return "XDP_TX"; }
    if action_id == 4 { return "XDP_REDIRECT"; }
    return "XDP_UNKNOWN_" + action_id.to_string();
}

// -----------------------------------------------------------------------------
// Connection Flow Key Hash
// -----------------------------------------------------------------------------

fn format_flow_key(src_ip, src_port, dst_ip, dst_port, protocol) {
    return src_ip + ":" + src_port.to_string() + "->" + dst_ip + ":" + dst_port.to_string() + "/" + protocol;
}

// -----------------------------------------------------------------------------
// Flow Tracker State Machine
// -----------------------------------------------------------------------------

fn init_ebpf_flow_tracker() {
    return #{
        active_flows: #{},
        dropped_packets_counter: 0,
        retransmission_events: 0,
        rtt_history: [],
        alerts: []
    };
}

fn record_flow_packet(tracker, flow_event) {
    let s_ip = flow_event["src_ip"];
    let s_port = flow_event["src_port"];
    let d_ip = flow_event["dst_ip"];
    let d_port = flow_event["dst_port"];
    let proto = flow_event["proto"];
    let bytes = flow_event["bytes"];
    let flags = flow_event["tcp_flags"]; // e.g. "SYN", "ACK", "FIN", "RST"
    let rtt_us = flow_event["srtt_us"]; // Smoothed RTT in microseconds
    let retrans = flow_event["retransmits"];
    let snd_wnd = flow_event["snd_wnd"];
    let ts = flow_event["timestamp_ns"];
    
    let key = format_flow_key(s_ip, s_port, d_ip, d_port, proto);
    let alerts = [];
    
    // Check 1: TCP Zero-Window Detection (Receiver buffer exhaustion)
    if snd_wnd == 0 && flags.contains("ACK") {
        alerts.push(#{
            rule: "TCP_ZERO_WINDOW_STALL",
            severity: "MEDIUM",
            flow: key,
            src_ip: s_ip,
            dst_ip: d_ip,
            timestamp_ns: ts
        });
    }
    
    // Check 2: Severe Packet Retransmission Surge
    if retrans > 5 {
        alerts.push(#{
            rule: "EXCESSIVE_TCP_RETRANSMISSIONS",
            severity: "HIGH",
            flow: key,
            retrans_count: retrans,
            srtt_us: rtt_us,
            timestamp_ns: ts
        });
        tracker["retransmission_events"] = tracker["retransmission_events"] + 1;
    }
    
    // Check 3: Kernel RTT Latency Spike (> 250ms = 250000 us)
    if rtt_us > 250000 {
        alerts.push(#{
            rule: "KERNEL_RTT_LATENCY_SPIKE",
            severity: "HIGH",
            flow: key,
            srtt_ms: (rtt_us * 1.0) / 1000.0,
            timestamp_ns: ts
        });
    }
    
    // Flow lifecycle accumulation
    if tracker["active_flows"].contains(key) {
        let fl = tracker["active_flows"][key];
        fl["bytes_sent"] = fl["bytes_sent"] + bytes;
        fl["packets_count"] = fl["packets_count"] + 1;
        fl["last_rtt_us"] = rtt_us;
        fl["retrans_total"] = fl["retrans_total"] + retrans;
        fl["last_seen_ns"] = ts;
        
        if flags.contains("FIN") || flags.contains("RST") {
            fl["state"] = "CLOSED";
            tracker["active_flows"].remove(key);
        } else {
            tracker["active_flows"][key] = fl;
        }
    } else {
        if !flags.contains("FIN") && !flags.contains("RST") {
            tracker["active_flows"][key] = #{
                flow_key: key,
                src_ip: s_ip,
                src_port: s_port,
                dst_ip: d_ip,
                dst_port: d_port,
                proto: proto,
                state: "ESTABLISHED",
                bytes_sent: bytes,
                packets_count: 1,
                last_rtt_us: rtt_us,
                retrans_total: retrans,
                start_time_ns: ts,
                last_seen_ns: ts
            };
        }
    }
    
    return alerts;
}

fn record_xdp_drop_event(tracker, xdp_event) {
    let action_id = xdp_event["action"];
    let reason = xdp_event["reason"];
    let s_ip = xdp_event["src_ip"];
    let d_ip = xdp_event["dst_ip"];
    let ts = xdp_event["timestamp_ns"];
    
    let alerts = [];
    if action_id == 1 { // XDP_DROP
        tracker["dropped_packets_counter"] = tracker["dropped_packets_counter"] + 1;
        if tracker["dropped_packets_counter"] % 100 == 0 {
            alerts.push(#{
                rule: "HIGH_VOLUME_XDP_DROPS",
                severity: "HIGH",
                cumulative_drops: tracker["dropped_packets_counter"],
                sample_src: s_ip,
                sample_dst: d_ip,
                reason: reason,
                timestamp_ns: ts
            });
        }
    }
    return alerts;
}

// -----------------------------------------------------------------------------
// Pipeline Event Handlers
// -----------------------------------------------------------------------------

fn process_ebpf_telemetry(event, pipeline_state) {
    if !pipeline_state.contains("tracker") {
        pipeline_state["tracker"] = init_ebpf_flow_tracker();
    }
    
    let event_type = event["type"]; // "TCP_PROBE", "XDP_TRACE"
    let alerts = [];
    
    if event_type == "TCP_PROBE" {
        alerts = record_flow_packet(pipeline_state["tracker"], event);
    } else if event_type == "XDP_TRACE" {
        alerts = record_xdp_drop_event(pipeline_state["tracker"], event);
    }
    
    return #{
        event_type: event_type,
        timestamp_ns: event["timestamp_ns"],
        active_flows: pipeline_state["tracker"]["active_flows"].len(),
        cumulative_xdp_drops: pipeline_state["tracker"]["dropped_packets_counter"],
        alerts: alerts
    };
}
