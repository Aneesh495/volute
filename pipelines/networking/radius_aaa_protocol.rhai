// Volute Pipeline: RADIUS AAA Protocol Parser and Anomaly Detection Engine
// RFC 2865 (Authentication) and RFC 2866 (Accounting) packet parsing, standard AVP dictionary decoding,
// session state tracking, bandwidth surge analysis, and simultaneous-login fraud rules.

import "lib/net/ipv4" as ip;

// -----------------------------------------------------------------------------
// Protocol Constants and Code Dictionaries
// -----------------------------------------------------------------------------

fn get_radius_code_name(code_id) {
    if code_id == 1 { return "Access-Request"; }
    if code_id == 2 { return "Access-Accept"; }
    if code_id == 3 { return "Access-Reject"; }
    if code_id == 4 { return "Accounting-Request"; }
    if code_id == 5 { return "Accounting-Response"; }
    if code_id == 11 { return "Access-Challenge"; }
    if code_id == 12 { return "Status-Server"; }
    if code_id == 13 { return "Status-Client"; }
    if code_id == 40 { return "Disconnect-Request"; }
    if code_id == 41 { return "Disconnect-ACK"; }
    if code_id == 42 { return "Disconnect-NAK"; }
    if code_id == 43 { return "CoA-Request"; }
    if code_id == 44 { return "CoA-ACK"; }
    if code_id == 45 { return "CoA-NAK"; }
    return "Unknown-Code-" + code_id.to_string();
}

fn get_acct_status_type_name(status_id) {
    if status_id == 1 { return "Start"; }
    if status_id == 2 { return "Stop"; }
    if status_id == 3 { return "Interim-Update"; }
    if status_id == 7 { return "Accounting-On"; }
    if status_id == 8 { return "Accounting-Off"; }
    if status_id == 9 { return "Tunnel-Start"; }
    if status_id == 10 { return "Tunnel-Stop"; }
    if status_id == 11 { return "Tunnel-Reject"; }
    if status_id == 12 { return "Tunnel-Link-Start"; }
    if status_id == 13 { return "Tunnel-Link-Stop"; }
    if status_id == 14 { return "Tunnel-Link-Reject"; }
    if status_id == 15 { return "Failed"; }
    return "Unknown-Status-" + status_id.to_string();
}

fn get_terminate_cause_name(cause_id) {
    if cause_id == 1 { return "User-Request"; }
    if cause_id == 2 { return "Lost-Carrier"; }
    if cause_id == 3 { return "Lost-Service"; }
    if cause_id == 4 { return "Idle-Timeout"; }
    if cause_id == 5 { return "Session-Timeout"; }
    if cause_id == 6 { return "Admin-Reset"; }
    if cause_id == 7 { return "Admin-Reboot"; }
    if cause_id == 8 { return "Port-Error"; }
    if cause_id == 9 { return "NAS-Error"; }
    if cause_id == 10 { return "NAS-Request"; }
    if cause_id == 11 { return "NAS-Reboot"; }
    if cause_id == 12 { return "Port-Unneeded"; }
    if cause_id == 13 { return "Port-Preempted"; }
    if cause_id == 14 { return "Port-Suspended"; }
    if cause_id == 15 { return "Service-Unavailable"; }
    if cause_id == 16 { return "Callback"; }
    if cause_id == 17 { return "User-Error"; }
    if cause_id == 18 { return "Host-Request"; }
    return "Unknown-Cause-" + cause_id.to_string();
}

fn get_avp_attr_name(type_id) {
    if type_id == 1 { return "User-Name"; }
    if type_id == 2 { return "User-Password"; }
    if type_id == 3 { return "CHAP-Password"; }
    if type_id == 4 { return "NAS-IP-Address"; }
    if type_id == 5 { return "NAS-Port"; }
    if type_id == 6 { return "Service-Type"; }
    if type_id == 7 { return "Framed-Protocol"; }
    if type_id == 8 { return "Framed-IP-Address"; }
    if type_id == 9 { return "Framed-IP-Netmask"; }
    if type_id == 10 { return "Framed-Routing"; }
    if type_id == 11 { return "Filter-Id"; }
    if type_id == 12 { return "Framed-MTU"; }
    if type_id == 13 { return "Framed-Compression"; }
    if type_id == 14 { return "Login-IP-Host"; }
    if type_id == 15 { return "Login-Service"; }
    if type_id == 16 { return "Login-TCP-Port"; }
    if type_id == 18 { return "Reply-Message"; }
    if type_id == 19 { return "Callback-Number"; }
    if type_id == 20 { return "Callback-Id"; }
    if type_id == 22 { return "Framed-Route"; }
    if type_id == 24 { return "State"; }
    if type_id == 25 { return "Class"; }
    if type_id == 26 { return "Vendor-Specific"; }
    if type_id == 27 { return "Session-Timeout"; }
    if type_id == 28 { return "Idle-Timeout"; }
    if type_id == 29 { return "Termination-Action"; }
    if type_id == 30 { return "Called-Station-Id"; }
    if type_id == 31 { return "Calling-Station-Id"; }
    if type_id == 32 { return "NAS-Identifier"; }
    if type_id == 33 { return "Proxy-State"; }
    if type_id == 40 { return "Acct-Status-Type"; }
    if type_id == 41 { return "Acct-Delay-Time"; }
    if type_id == 42 { return "Acct-Input-Octets"; }
    if type_id == 43 { return "Acct-Output-Octets"; }
    if type_id == 44 { return "Acct-Session-Id"; }
    if type_id == 45 { return "Acct-Authentic"; }
    if type_id == 46 { return "Acct-Session-Time"; }
    if type_id == 47 { return "Acct-Input-Packets"; }
    if type_id == 48 { return "Acct-Output-Packets"; }
    if type_id == 49 { return "Acct-Terminate-Cause"; }
    if type_id == 50 { return "Acct-Multi-Session-Id"; }
    if type_id == 51 { return "Acct-Link-Count"; }
    if type_id == 55 { return "Event-Timestamp"; }
    if type_id == 60 { return "CHAP-Challenge"; }
    if type_id == 61 { return "NAS-Port-Type"; }
    if type_id == 62 { return "Port-Limit"; }
    return "Attr-" + type_id.to_string();
}

// -----------------------------------------------------------------------------
// Packet Parsing and Validation
// -----------------------------------------------------------------------------

fn parse_radius_packet(raw_map) {
    let code = raw_map["code"];
    let id = raw_map["id"];
    let length = raw_map["length"];
    let authenticator = raw_map["authenticator"];
    let raw_attributes = raw_map["attributes"];
    
    if length < 20 || length > 4096 {
        return #{
            is_valid: false,
            error: "INVALID_PACKET_LENGTH: " + length.to_string()
        };
    }
    
    let decoded_attrs = #{};
    for attr in raw_attributes {
        let type_id = attr["type"];
        let attr_name = get_avp_attr_name(type_id);
        let val = attr["value"];
        
        // Decode standard integer attributes
        if type_id == 40 {
            decoded_attrs["Acct-Status-Type"] = get_acct_status_type_name(val);
            decoded_attrs["Acct-Status-Type-Code"] = val;
        } else if type_id == 49 {
            decoded_attrs["Acct-Terminate-Cause"] = get_terminate_cause_name(val);
            decoded_attrs["Acct-Terminate-Cause-Code"] = val;
        } else {
            decoded_attrs[attr_name] = val;
        }
    }
    
    return #{
        is_valid: true,
        code: code,
        code_name: get_radius_code_name(code),
        id: id,
        length: length,
        authenticator: authenticator,
        attributes: decoded_attrs
    };
}

// -----------------------------------------------------------------------------
// Session Tracking and Anomaly Detection
// -----------------------------------------------------------------------------

fn init_radius_tracker() {
    return #{
        active_sessions: #{},      // session_id -> session_info
        user_active_sessions: #{}, // username -> [session_id]
        nas_known_registry: #{},   // nas_ip -> nas_info
        alert_log: []
    };
}

fn register_authorized_nas(tracker, nas_ip, nas_identifier, shared_secret_hint) {
    tracker["nas_known_registry"][nas_ip] = #{
        nas_ip: nas_ip,
        identifier: nas_identifier,
        secret_hint: shared_secret_hint,
        registered_at: 1000
    };
}

fn handle_accounting_event(tracker, packet, current_timestamp) {
    let alerts = [];
    let attrs = packet["attributes"];
    
    let nas_ip = if attrs.contains("NAS-IP-Address") { attrs["NAS-IP-Address"] } else { "UNKNOWN_NAS" };
    let username = if attrs.contains("User-Name") { attrs["User-Name"] } else { "ANONYMOUS" };
    let session_id = if attrs.contains("Acct-Session-Id") { attrs["Acct-Session-Id"] } else { "NONE" };
    let status_code = if attrs.contains("Acct-Status-Type-Code") { attrs["Acct-Status-Type-Code"] } else { 0 };
    
    // Check 1: Rogue / Unregistered NAS validation
    if !tracker["nas_known_registry"].contains(nas_ip) {
        alerts.push(#{
            rule: "ROGUE_NAS_DETECTED",
            severity: "HIGH",
            nas_ip: nas_ip,
            username: username,
            timestamp: current_timestamp
        });
    }
    
    // Status 1: Acct-Start
    if status_code == 1 {
        // Check 2: Concurrent Session / Multiple Login Detection
        if tracker["user_active_sessions"].contains(username) {
            let active_list = tracker["user_active_sessions"][username];
            if active_list.len() >= 2 {
                alerts.push(#{
                    rule: "CONCURRENT_SESSION_LIMIT_EXCEEDED",
                    severity: "MEDIUM",
                    username: username,
                    session_count: active_list.len() + 1,
                    new_session: session_id,
                    timestamp: current_timestamp
                });
            }
            active_list.push(session_id);
            tracker["user_active_sessions"][username] = active_list;
        } else {
            tracker["user_active_sessions"][username] = [session_id];
        }
        
        let client_ip = if attrs.contains("Framed-IP-Address") { attrs["Framed-IP-Address"] } else { "0.0.0.0" };
        let calling_station = if attrs.contains("Calling-Station-Id") { attrs["Calling-Station-Id"] } else { "UNKNOWN_MAC" };
        
        tracker["active_sessions"][session_id] = #{
            session_id: session_id,
            username: username,
            nas_ip: nas_ip,
            client_ip: client_ip,
            calling_station: calling_station,
            start_timestamp: current_timestamp,
            last_update: current_timestamp,
            input_octets: 0,
            output_octets: 0
        };
    }
    
    // Status 3: Interim-Update or Status 2: Stop
    if status_code == 2 || status_code == 3 {
        if tracker["active_sessions"].contains(session_id) {
            let sess = tracker["active_sessions"][session_id];
            let in_octets = if attrs.contains("Acct-Input-Octets") { attrs["Acct-Input-Octets"] } else { 0 };
            let out_octets = if attrs.contains("Acct-Output-Octets") { attrs["Acct-Output-Octets"] } else { 0 };
            let session_time = if attrs.contains("Acct-Session-Time") { attrs["Acct-Session-Time"] } else { 1 };
            if session_time < 1 { session_time = 1; }
            
            // Check 3: Abnormal Data Transfer Velocity (> 50 MB/s sustained)
            let total_bytes = in_octets + out_octets;
            let byte_rate = total_bytes / session_time;
            let mb_rate = byte_rate / (1024 * 1024);
            if mb_rate > 50 {
                alerts.push(#{
                    rule: "EXCESSIVE_BANDWIDTH_VELOCITY",
                    severity: "HIGH",
                    username: username,
                    session_id: session_id,
                    mb_per_sec: mb_rate,
                    timestamp: current_timestamp
                });
            }
            
            // Check 4: Calling-Station (MAC) Spoofing or Hijacking
            if attrs.contains("Calling-Station-Id") {
                let current_mac = attrs["Calling-Station-Id"];
                if current_mac != sess["calling_station"] {
                    alerts.push(#{
                        rule: "SESSION_STATION_MAC_MISMATCH",
                        severity: "CRITICAL",
                        username: username,
                        session_id: session_id,
                        expected_mac: sess["calling_station"],
                        observed_mac: current_mac,
                        timestamp: current_timestamp
                    });
                }
            }
            
            sess["last_update"] = current_timestamp;
            sess["input_octets"] = in_octets;
            sess["output_octets"] = out_octets;
            tracker["active_sessions"][session_id] = sess;
            
            // If Session Stop, remove from tracking
            if status_code == 2 {
                tracker["active_sessions"].remove(session_id);
                if tracker["user_active_sessions"].contains(username) {
                    let u_sessions = tracker["user_active_sessions"][username];
                    let updated_list = [];
                    for s in u_sessions {
                        if s != session_id {
                            updated_list.push(s);
                        }
                    }
                    if updated_list.len() == 0 {
                        tracker["user_active_sessions"].remove(username);
                    } else {
                        tracker["user_active_sessions"][username] = updated_list;
                    }
                }
            }
        } else if status_code == 2 {
            // Orphaned Acct-Stop packet
            alerts.push(#{
                rule: "ORPHANED_ACCOUNTING_STOP",
                severity: "LOW",
                session_id: session_id,
                username: username,
                timestamp: current_timestamp
            });
        }
    }
    
    return alerts;
}

// -----------------------------------------------------------------------------
// Pipeline Event Handlers
// -----------------------------------------------------------------------------

fn process_radius_event(event, pipeline_state) {
    if !pipeline_state.contains("tracker") {
        pipeline_state["tracker"] = init_radius_tracker();
        // Register known authorized gateways
        register_authorized_nas(pipeline_state["tracker"], "10.0.0.1", "GATEWAY-NYC-01", "secret-core-1");
        register_authorized_nas(pipeline_state["tracker"], "10.0.0.2", "GATEWAY-LON-01", "secret-core-2");
    }
    
    let raw_packet = event["packet"];
    let timestamp = event["timestamp"];
    let parsed = parse_radius_packet(raw_packet);
    
    if !parsed["is_valid"] {
        return #{
            status: "ERROR",
            error: parsed["error"],
            alerts: [#{ rule: "MALFORMED_RADIUS_PACKET", severity: "HIGH", timestamp: timestamp }]
        };
    }
    
    let alerts = [];
    if parsed["code"] == 4 { // Accounting-Request
        alerts = handle_accounting_event(pipeline_state["tracker"], parsed, timestamp);
    }
    
    return #{
        status: "OK",
        code: parsed["code_name"],
        session_id: if parsed["attributes"].contains("Acct-Session-Id") { parsed["attributes"]["Acct-Session-Id"] } else { "" },
        username: if parsed["attributes"].contains("User-Name") { parsed["attributes"]["User-Name"] } else { "" },
        alerts: alerts,
        active_sessions_count: pipeline_state["tracker"]["active_sessions"].len()
    };
}
