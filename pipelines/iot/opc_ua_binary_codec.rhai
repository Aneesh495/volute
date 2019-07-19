// Volute Pipeline: OPC Unified Architecture (OPC UA) Binary Telemetry Codec
// IEC 62541 Part 6 binary message parsing, NodeId addressing, Variant data type resolution,
// StatusCode quality bitmask decoding, and industrial alarm limit (HH/H/L/LL) state machines.

// -----------------------------------------------------------------------------
// OPC UA Constants and Dictionaries
// -----------------------------------------------------------------------------

fn get_opcua_msg_type_name(msg_type_str) {
    if msg_type_str == "HEL" { return "Hello"; }
    if msg_type_str == "ACK" { return "Acknowledge"; }
    if msg_type_str == "ERR" { return "Error"; }
    if msg_type_str == "OPN" { return "OpenSecureChannel"; }
    if msg_type_str == "MSG" { return "SecureMessage"; }
    if msg_type_str == "CLO" { return "CloseSecureChannel"; }
    return "Unknown-" + msg_type_str;
}

fn get_variant_type_name(type_id) {
    if type_id == 1 { return "Boolean"; }
    if type_id == 2 { return "SByte"; }
    if type_id == 3 { return "Byte"; }
    if type_id == 4 { return "Int16"; }
    if type_id == 5 { return "UInt16"; }
    if type_id == 6 { return "Int32"; }
    if type_id == 7 { return "UInt32"; }
    if type_id == 8 { return "Int64"; }
    if type_id == 9 { return "UInt64"; }
    if type_id == 10 { return "Float"; }
    if type_id == 11 { return "Double"; }
    if type_id == 12 { return "String"; }
    if type_id == 13 { return "DateTime"; }
    if type_id == 14 { return "Guid"; }
    if type_id == 15 { return "ByteString"; }
    if type_id == 19 { return "StatusCode"; }
    if type_id == 22 { return "ExtensionObject"; }
    if type_id == 23 { return "DataValue"; }
    return "Variant-" + type_id.to_string();
}

fn decode_status_code_quality(status_code_hex) {
    // Quality mask: top 2 bits (0x00=Good, 0x40=Uncertain, 0x80=Bad)
    if status_code_hex == "0x00000000" || status_code_hex == "Good" {
        return #{ severity: "GOOD", description: "The value is good and reliable." };
    }
    if status_code_hex.starts_with("0x4") {
        return #{ severity: "UNCERTAIN", description: "Sensor accuracy degraded or using last usable value." };
    }
    if status_code_hex.starts_with("0x8") {
        return #{ severity: "BAD", description: "Hardware device failure, timeout, or out-of-range sensor." };
    }
    return #{ severity: "UNKNOWN", description: "Unrecognized status code." };
}

// -----------------------------------------------------------------------------
// NodeId Resolution
// -----------------------------------------------------------------------------

fn format_node_id(node_id_struct) {
    let encoding_type = node_id_struct["encoding"];
    let ns = node_id_struct["namespace"];
    let id_val = node_id_struct["id"];
    
    if encoding_type == "TwoByte" {
        return "ns=0;i=" + id_val.to_string();
    } else if encoding_type == "FourByte" {
        return "ns=" + ns.to_string() + ";i=" + id_val.to_string();
    } else if encoding_type == "Numeric" {
        return "ns=" + ns.to_string() + ";i=" + id_val.to_string();
    } else if encoding_type == "String" {
        return "ns=" + ns.to_string() + ";s=" + id_val.to_string();
    } else if encoding_type == "Guid" {
        return "ns=" + ns.to_string() + ";g=" + id_val.to_string();
    }
    return "ns=" + ns.to_string() + ";raw=" + id_val.to_string();
}

// -----------------------------------------------------------------------------
// Message Header and Payload Parsing
// -----------------------------------------------------------------------------

fn parse_opcua_message(raw_msg) {
    let msg_type = raw_msg["msg_type"]; // "HEL", "ACK", "MSG", etc.
    let chunk_type = raw_msg["chunk_type"]; // "F", "C", "A"
    let msg_size = raw_msg["size"];
    
    if msg_size < 8 || msg_size > 67108864 { // Max 64MB frame
        return #{
            is_valid: false,
            error: "INVALID_MESSAGE_SIZE: " + msg_size.to_string()
        };
    }
    
    let secure_channel_id = if raw_msg.contains("channel_id") { raw_msg["channel_id"] } else { 0 };
    let security_token_id = if raw_msg.contains("token_id") { raw_msg["token_id"] } else { 0 };
    let sequence_number = if raw_msg.contains("seq_num") { raw_msg["seq_num"] } else { 0 };
    let request_id = if raw_msg.contains("req_id") { raw_msg["req_id"] } else { 0 };
    
    let items = [];
    if raw_msg.contains("data_values") {
        for dv in raw_msg["data_values"] {
            let node_str = format_node_id(dv["node_id"]);
            let v_type = get_variant_type_name(dv["variant_type"]);
            let quality = decode_status_code_quality(dv["status_code"]);
            
            items.push(#{
                node_id: node_str,
                variant_type: v_type,
                value: dv["value"],
                status_code: dv["status_code"],
                quality: quality["severity"],
                quality_desc: quality["description"],
                source_timestamp: dv["source_timestamp"],
                server_timestamp: dv["server_timestamp"]
            });
        }
    }
    
    return #{
        is_valid: true,
        msg_type: msg_type,
        msg_type_name: get_opcua_msg_type_name(msg_type),
        chunk_type: chunk_type,
        is_final: chunk_type == "F",
        size: msg_size,
        channel_id: secure_channel_id,
        token_id: security_token_id,
        seq_num: sequence_number,
        req_id: request_id,
        items: items
    };
}

// -----------------------------------------------------------------------------
// Industrial Alarm & Limit Condition Engine
// -----------------------------------------------------------------------------

fn create_analog_alarm_config(node_id, low_low, low, high, high_high, deadband, max_rate_of_change) {
    return #{
        node_id: node_id,
        low_low: low_low,
        low: low,
        high: high,
        high_high: high_high,
        deadband: deadband,
        max_rate_of_change: max_rate_of_change
    };
}

fn init_alarm_state(config) {
    return #{
        config: config,
        last_value: 0.0,
        last_timestamp: 0,
        current_alarm: "NORMAL",
        is_active: false,
        is_acknowledged: true,
        alarm_entry_timestamp: 0,
        rate_of_change: 0.0
    };
}

fn evaluate_alarm_state(state, new_value, timestamp) {
    let cfg = state["config"];
    let prev_val = state["last_value"];
    let prev_ts = state["last_timestamp"];
    let deadband = cfg["deadband"];
    
    // 1. Calculate Rate-of-Change
    let dt = (timestamp - prev_ts) * 1.0;
    let roc = 0.0;
    if dt > 0.0 && prev_ts > 0 {
        let dv = new_value - prev_val;
        let abs_dv = if dv < 0.0 { -dv } else { dv };
        roc = abs_dv / dt;
    }
    state["rate_of_change"] = roc;
    
    let generated_events = [];
    
    // Check Rate-of-Change Threshold
    if cfg["max_rate_of_change"] > 0.0 && roc > cfg["max_rate_of_change"] {
        generated_events.push(#{
            node_id: cfg["node_id"],
            alarm_type: "RATE_OF_CHANGE_EXCEEDED",
            severity: "HIGH",
            observed_roc: roc,
            limit: cfg["max_rate_of_change"],
            timestamp: timestamp
        });
    }
    
    // 2. Limit Thresholds with Hysteresis Deadband
    let candidate_alarm = "NORMAL";
    if new_value >= cfg["high_high"] {
        candidate_alarm = "HIGH_HIGH";
    } else if new_value >= cfg["high"] {
        candidate_alarm = "HIGH";
    } else if new_value <= cfg["low_low"] {
        candidate_alarm = "LOW_LOW";
    } else if new_value <= cfg["low"] {
        candidate_alarm = "LOW";
    }
    
    // Hysteresis deadband filter on recovery
    let current_alarm = state["current_alarm"];
    let resolved_alarm = candidate_alarm;
    
    if current_alarm == "HIGH_HIGH" && candidate_alarm != "HIGH_HIGH" {
        if new_value > (cfg["high_high"] - deadband) {
            resolved_alarm = "HIGH_HIGH";
        }
    } else if current_alarm == "HIGH" && candidate_alarm == "NORMAL" {
        if new_value > (cfg["high"] - deadband) {
            resolved_alarm = "HIGH";
        }
    } else if current_alarm == "LOW_LOW" && candidate_alarm != "LOW_LOW" {
        if new_value < (cfg["low_low"] + deadband) {
            resolved_alarm = "LOW_LOW";
        }
    } else if current_alarm == "LOW" && candidate_alarm == "NORMAL" {
        if new_value < (cfg["low"] + deadband) {
            resolved_alarm = "LOW";
        }
    }
    
    // State transitions
    if resolved_alarm != current_alarm {
        let severity = "INFO";
        if resolved_alarm == "HIGH_HIGH" || resolved_alarm == "LOW_LOW" {
            severity = "CRITICAL_TRIP";
        } else if resolved_alarm == "HIGH" || resolved_alarm == "LOW" {
            severity = "WARNING";
        }
        
        generated_events.push(#{
            node_id: cfg["node_id"],
            alarm_type: "ALARM_STATE_TRANSITION",
            from_state: current_alarm,
            to_state: resolved_alarm,
            severity: severity,
            value: new_value,
            timestamp: timestamp
        });
        
        state["current_alarm"] = resolved_alarm;
        state["is_active"] = resolved_alarm != "NORMAL";
        state["is_acknowledged"] = false;
        state["alarm_entry_timestamp"] = timestamp;
    }
    
    state["last_value"] = new_value;
    state["last_timestamp"] = timestamp;
    
    return generated_events;
}

// -----------------------------------------------------------------------------
// Pipeline Event Handlers
// -----------------------------------------------------------------------------

fn process_opcua_event(event, pipeline_state) {
    if !pipeline_state.contains("alarm_states") {
        pipeline_state["alarm_states"] = #{};
        // Setup boiler turbine vibration alarm
        let vib_cfg = create_analog_alarm_config("ns=2;s=Turbine.Vibration.RMS", 0.0, 1.0, 8.5, 12.0, 0.5, 5.0);
        pipeline_state["alarm_states"]["ns=2;s=Turbine.Vibration.RMS"] = init_alarm_state(vib_cfg);
        // Setup reactor pressure alarm
        let pres_cfg = create_analog_alarm_config("ns=2;s=Reactor.Pressure.Bar", 2.0, 5.0, 25.0, 32.0, 1.0, 8.0);
        pipeline_state["alarm_states"]["ns=2;s=Reactor.Pressure.Bar"] = init_alarm_state(pres_cfg);
    }
    
    let raw_msg = event["message"];
    let parsed = parse_opcua_message(raw_msg);
    if !parsed["is_valid"] {
        return #{
            status: "ERROR",
            error: parsed["error"]
        };
    }
    
    let triggered_alarms = [];
    for item in parsed["items"] {
        let nid = item["node_id"];
        if item["quality"] == "BAD" {
            triggered_alarms.push(#{
                node_id: nid,
                alarm_type: "SENSOR_BAD_QUALITY",
                severity: "HIGH",
                desc: item["quality_desc"],
                timestamp: item["source_timestamp"]
            });
        }
        
        if pipeline_state["alarm_states"].contains(nid) {
            let alarm_st = pipeline_state["alarm_states"][nid];
            let evs = evaluate_alarm_state(alarm_st, item["value"], item["source_timestamp"]);
            for ev in evs {
                triggered_alarms.push(ev);
            }
        }
    }
    
    return #{
        status: "OK",
        msg_type: parsed["msg_type_name"],
        item_count: parsed["items"].len(),
        alarms: triggered_alarms
    };
}
