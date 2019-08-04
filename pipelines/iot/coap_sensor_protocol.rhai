// Volute Pipeline: Constrained Application Protocol (CoAP) IoT Telemetry Engine
// RFC 7252 message parsing, header bitmask decoding, delta-length option decompression,
// RFC 7641 Observe subscription tracking, content-format negotiation, and sensor retransmission monitors.

// -----------------------------------------------------------------------------
// CoAP Constants and Code Dictionaries
// -----------------------------------------------------------------------------

fn get_coap_type_name(type_id) {
    if type_id == 0 { return "CON"; } // Confirmable
    if type_id == 1 { return "NON"; } // Non-confirmable
    if type_id == 2 { return "ACK"; } // Acknowledgement
    if type_id == 3 { return "RST"; } // Reset
    return "UNKNOWN_TYPE_" + type_id.to_string();
}

fn get_coap_code_name(code_class, code_detail) {
    // 0.xx Method Codes
    if code_class == 0 && code_detail == 0 { return "Empty"; }
    if code_class == 0 && code_detail == 1 { return "GET"; }
    if code_class == 0 && code_detail == 2 { return "POST"; }
    if code_class == 0 && code_detail == 3 { return "PUT"; }
    if code_class == 0 && code_detail == 4 { return "DELETE"; }
    
    // 2.xx Success Codes
    if code_class == 2 && code_detail == 1 { return "2.01 Created"; }
    if code_class == 2 && code_detail == 2 { return "2.02 Deleted"; }
    if code_class == 2 && code_detail == 3 { return "2.03 Valid"; }
    if code_class == 2 && code_detail == 4 { return "2.04 Changed"; }
    if code_class == 2 && code_detail == 5 { return "2.05 Content"; }
    
    // 4.xx Client Error Codes
    if code_class == 4 && code_detail == 0 { return "4.00 Bad Request"; }
    if code_class == 4 && code_detail == 1 { return "4.01 Unauthorized"; }
    if code_class == 4 && code_detail == 3 { return "4.03 Forbidden"; }
    if code_class == 4 && code_detail == 4 { return "4.04 Not Found"; }
    if code_class == 4 && code_detail == 5 { return "4.05 Method Not Allowed"; }
    
    // 5.xx Server Error Codes
    if code_class == 5 && code_detail == 0 { return "5.00 Internal Server Error"; }
    if code_class == 5 && code_detail == 2 { return "5.02 Bad Gateway"; }
    if code_class == 5 && code_detail == 3 { return "5.03 Service Unavailable"; }
    if code_class == 5 && code_detail == 4 { return "5.04 Gateway Timeout"; }
    
    return code_class.to_string() + "." + (if code_detail < 10 { "0" } else { "" }) + code_detail.to_string();
}

fn get_content_format_name(format_id) {
    if format_id == 0 { return "text/plain;charset=utf-8"; }
    if format_id == 40 { return "application/link-format"; }
    if format_id == 41 { return "application/xml"; }
    if format_id == 42 { return "application/octet-stream"; }
    if format_id == 47 { return "application/exi"; }
    if format_id == 50 { return "application/json"; }
    if format_id == 60 { return "application/cbor"; }
    return "custom/content-format-" + format_id.to_string();
}

fn get_option_number_name(opt_num) {
    if opt_num == 1 { return "If-Match"; }
    if opt_num == 3 { return "Uri-Host"; }
    if opt_num == 4 { return "ETag"; }
    if opt_num == 5 { return "If-None-Match"; }
    if opt_num == 6 { return "Observe"; }
    if opt_num == 7 { return "Uri-Port"; }
    if opt_num == 8 { return "Location-Path"; }
    if opt_num == 11 { return "Uri-Path"; }
    if opt_num == 12 { return "Content-Format"; }
    if opt_num == 14 { return "Max-Age"; }
    if opt_num == 15 { return "Uri-Query"; }
    if opt_num == 17 { return "Accept"; }
    if opt_num == 20 { return "Location-Query"; }
    if opt_num == 23 { return "Block2"; }
    if opt_num == 27 { return "Block1"; }
    if opt_num == 28 { return "Size2"; }
    if opt_num == 35 { return "Proxy-Uri"; }
    if opt_num == 39 { return "Proxy-Scheme"; }
    if opt_num == 60 { return "Size1"; }
    return "Option-" + opt_num.to_string();
}

// -----------------------------------------------------------------------------
// CoAP Message Parser
// -----------------------------------------------------------------------------

fn parse_coap_packet(raw_map) {
    let ver = raw_map["version"];
    let msg_type = raw_map["type"];
    let tkl = raw_map["tkl"]; // Token length 0..8
    let code_class = raw_map["code_class"];
    let code_detail = raw_map["code_detail"];
    let msg_id = raw_map["message_id"];
    let token = raw_map["token"];
    let raw_options = raw_map["options"]; // array of #{ delta: num, value: val }
    let payload = if raw_map.contains("payload") { raw_map["payload"] } else { "" };
    
    if ver != 1 {
        return #{ is_valid: false, error: "UNSUPPORTED_COAP_VERSION: " + ver.to_string() };
    }
    if tkl > 8 {
        return #{ is_valid: false, error: "INVALID_TOKEN_LENGTH: " + tkl.to_string() };
    }
    
    // Parse delta-encoded options
    let running_opt_num = 0;
    let decoded_options = #{};
    let uri_path_segments = [];
    let is_observe = false;
    let observe_sequence = 0;
    let content_format_num = -1;
    
    for opt in raw_options {
        let delta = opt["delta"];
        running_opt_num = running_opt_num + delta;
        let opt_name = get_option_number_name(running_opt_num);
        let val = opt["value"];
        
        if running_opt_num == 11 { // Uri-Path
            uri_path_segments.push(val.to_string());
        } else if running_opt_num == 6 { // Observe
            is_observe = true;
            observe_sequence = val;
        } else if running_opt_num == 12 { // Content-Format
            content_format_num = val;
        }
        decoded_options[opt_name] = val;
    }
    
    let full_path = "";
    for s in uri_path_segments {
        full_path = full_path + "/" + s;
    }
    if full_path.is_empty() { full_path = "/"; }
    
    return #{
        is_valid: true,
        version: ver,
        type: get_coap_type_name(msg_type),
        code: get_coap_code_name(code_class, code_detail),
        is_request: code_class == 0 && code_detail > 0,
        is_response: code_class >= 2,
        message_id: msg_id,
        token: token,
        path: full_path,
        is_observe: is_observe,
        observe_sequence: observe_sequence,
        content_format: if content_format_num >= 0 { get_content_format_name(content_format_num) } else { "none" },
        options: decoded_options,
        payload: payload
    };
}

// -----------------------------------------------------------------------------
// IoT Telemetry Session & Observe Tracker
// -----------------------------------------------------------------------------

fn init_coap_tracker() {
    return #{
        active_observers: #{}, // uri_path -> [client_endpoints]
        in_flight_con_messages: #{}, // msg_id -> #{ timestamp, retries, client }
        rst_rate_window: []
    };
}

fn handle_coap_observe(tracker, parsed_msg, client_endpoint, timestamp) {
    let alerts = [];
    let path = parsed_msg["path"];
    
    if parsed_msg["is_observe"] {
        if !tracker["active_observers"].contains(path) {
            tracker["active_observers"][path] = [];
        }
        let obs_list = tracker["active_observers"][path];
        let exists = false;
        for ep in obs_list {
            if ep == client_endpoint { exists = true; break; }
        }
        if !exists {
            obs_list.push(client_endpoint);
            tracker["active_observers"][path] = obs_list;
        }
    }
    
    // Check RST storm / Reset error rate
    if parsed_msg["type"] == "RST" {
        tracker["rst_rate_window"].push(timestamp);
        if tracker["rst_rate_window"].len() > 20 {
            alerts.push(#{
                rule: "COAP_RESET_STORM_DETECTED",
                severity: "HIGH",
                client: client_endpoint,
                rst_count: tracker["rst_rate_window"].len(),
                timestamp: timestamp
            });
        }
    }
    
    return alerts;
}

// -----------------------------------------------------------------------------
// Pipeline Event Handlers
// -----------------------------------------------------------------------------

fn process_coap_event(event, pipeline_state) {
    if !pipeline_state.contains("tracker") {
        pipeline_state["tracker"] = init_coap_tracker();
    }
    
    let client = event["client_endpoint"];
    let timestamp = event["timestamp"];
    let parsed = parse_coap_packet(event["packet"]);
    
    if !parsed["is_valid"] {
        return #{
            status: "ERROR",
            error: parsed["error"]
        };
    }
    
    let alerts = handle_coap_observe(pipeline_state["tracker"], parsed, client, timestamp);
    
    return #{
        status: "OK",
        type: parsed["type"],
        code: parsed["code"],
        path: parsed["path"],
        is_observe: parsed["is_observe"],
        content_format: parsed["content_format"],
        alerts: alerts
    };
}
