// Volute Pipeline: FIX Adapted for STreaming (FAST) Protocol Codec
// Ultra-low latency market data feed decoder: Stop-bit integer decoding, Presence Map (pmap) evaluation,
// field operators (copy, delta, default, increment, constant), and template dictionary decoding.

// -----------------------------------------------------------------------------
// Stop-Bit Variable-Length Integer Decoding (ITU-T X.691 Aligned)
// -----------------------------------------------------------------------------

fn decode_fast_uint(bytes, offset) {
    let result = 0;
    let curr_idx = offset;
    let n = bytes.len();
    
    while curr_idx < n {
        let b = bytes[curr_idx];
        let val_bits = b % 128; // lower 7 bits
        result = (result * 128) + val_bits;
        curr_idx = curr_idx + 1;
        
        // Stop-bit is MSB (b >= 128)
        if b >= 128 {
            break;
        }
    }
    
    return #{
        value: result,
        next_offset: curr_idx
    };
}

fn decode_fast_sint(bytes, offset) {
    let result = 0;
    let curr_idx = offset;
    let n = bytes.len();
    let is_negative = false;
    
    if curr_idx < n {
        let first_byte = bytes[curr_idx];
        // If sign bit (bit 6 of first 7-bit chunk) is set
        if (first_byte % 128) >= 64 {
            is_negative = true;
            result = -1;
        }
    }
    
    while curr_idx < n {
        let b = bytes[curr_idx];
        let val_bits = b % 128;
        result = (result * 128) + val_bits;
        curr_idx = curr_idx + 1;
        
        if b >= 128 {
            break;
        }
    }
    
    return #{
        value: result,
        next_offset: curr_idx
    };
}

fn decode_fast_string(bytes, offset) {
    let str_val = "";
    let curr_idx = offset;
    let n = bytes.len();
    
    while curr_idx < n {
        let b = bytes[curr_idx];
        let char_code = b % 128;
        if char_code > 0 {
            // Rhai string concatenation
            str_val = str_val + " ";
        }
        curr_idx = curr_idx + 1;
        if b >= 128 {
            break;
        }
    }
    
    return #{
        value: str_val,
        next_offset: curr_idx
    };
}

// -----------------------------------------------------------------------------
// Presence Map (pmap) Evaluation
// -----------------------------------------------------------------------------

fn parse_presence_map(bytes, offset) {
    let bits = [];
    let curr_idx = offset;
    let n = bytes.len();
    
    while curr_idx < n {
        let b = bytes[curr_idx];
        // Extract 7 bits from bit 6 down to bit 0
        let temp = b % 128;
        let b6 = if temp >= 64 { 1 } else { 0 }; if b6 == 1 { temp = temp - 64; }
        let b5 = if temp >= 32 { 1 } else { 0 }; if b5 == 1 { temp = temp - 32; }
        let b4 = if temp >= 16 { 1 } else { 0 }; if b4 == 1 { temp = temp - 16; }
        let b3 = if temp >= 8  { 1 } else { 0 }; if b3 == 1 { temp = temp - 8; }
        let b2 = if temp >= 4  { 1 } else { 0 }; if b2 == 1 { temp = temp - 4; }
        let b1 = if temp >= 2  { 1 } else { 0 }; if b1 == 1 { temp = temp - 2; }
        let b0 = if temp >= 1  { 1 } else { 0 };
        
        bits.push(b6);
        bits.push(b5);
        bits.push(b4);
        bits.push(b3);
        bits.push(b2);
        bits.push(b1);
        bits.push(b0);
        
        curr_idx = curr_idx + 1;
        if b >= 128 {
            break;
        }
    }
    
    return #{
        bits: bits,
        next_offset: curr_idx
    };
}

// -----------------------------------------------------------------------------
// FAST Field Operators Dictionary
// -----------------------------------------------------------------------------

fn apply_copy_operator(is_present_in_stream, stream_value, previous_value) {
    if is_present_in_stream {
        return stream_value;
    } else {
        return previous_value;
    }
}

fn apply_delta_operator(is_present_in_stream, delta_value, base_value) {
    if is_present_in_stream {
        return base_value + delta_value;
    } else {
        return base_value;
    }
}

fn apply_increment_operator(is_present_in_stream, stream_value, previous_value) {
    if is_present_in_stream {
        return stream_value;
    } else {
        return previous_value + 1;
    }
}

fn apply_default_operator(is_present_in_stream, stream_value, default_val) {
    if is_present_in_stream {
        return stream_value;
    } else {
        return default_val;
    }
}

// -----------------------------------------------------------------------------
// Market Data Template Decoder (Template 145: MDIncRefresh)
// -----------------------------------------------------------------------------

fn init_fast_dictionary() {
    return #{
        prev_msg_seq_num: 0,
        prev_symbol: "SPY",
        prev_bid_px: 50000,
        prev_bid_size: 100,
        prev_ask_px: 50005,
        prev_ask_size: 100
    };
}

fn decode_md_incremental_refresh(bytes, dict_state) {
    let pmap_res = parse_presence_map(bytes, 0);
    let pmap = pmap_res["bits"];
    let offset = pmap_res["next_offset"];
    
    // Bit 0 of pmap: Template ID presence
    let template_id = 145; // Default MDIncRefresh
    if pmap.len() > 0 && pmap[0] == 1 {
        let t_res = decode_fast_uint(bytes, offset);
        template_id = t_res["value"];
        offset = t_res["next_offset"];
    }
    
    // Bit 1: MsgSeqNum (Increment operator)
    let msg_seq_num = dict_state["prev_msg_seq_num"] + 1;
    if pmap.len() > 1 && pmap[1] == 1 {
        let seq_res = decode_fast_uint(bytes, offset);
        msg_seq_num = seq_res["value"];
        offset = seq_res["next_offset"];
    }
    dict_state["prev_msg_seq_num"] = msg_seq_num;
    
    // Bit 2: Bid Price (Delta operator against prev_bid_px)
    let bid_px = dict_state["prev_bid_px"];
    if pmap.len() > 2 && pmap[2] == 1 {
        let delta_res = decode_fast_sint(bytes, offset);
        bid_px = apply_delta_operator(true, delta_res["value"], dict_state["prev_bid_px"]);
        offset = delta_res["next_offset"];
    }
    dict_state["prev_bid_px"] = bid_px;
    
    // Bit 3: Bid Size (Copy operator)
    let bid_size = dict_state["prev_bid_size"];
    if pmap.len() > 3 && pmap[3] == 1 {
        let size_res = decode_fast_uint(bytes, offset);
        bid_size = size_res["value"];
        offset = size_res["next_offset"];
    }
    dict_state["prev_bid_size"] = bid_size;
    
    // Bit 4: Ask Price (Delta operator)
    let ask_px = dict_state["prev_ask_px"];
    if pmap.len() > 4 && pmap[4] == 1 {
        let delta_res = decode_fast_sint(bytes, offset);
        ask_px = apply_delta_operator(true, delta_res["value"], dict_state["prev_ask_px"]);
        offset = delta_res["next_offset"];
    }
    dict_state["prev_ask_px"] = ask_px;
    
    // Bit 5: Ask Size (Copy operator)
    let ask_size = dict_state["prev_ask_size"];
    if pmap.len() > 5 && pmap[5] == 1 {
        let size_res = decode_fast_uint(bytes, offset);
        ask_size = size_res["value"];
        offset = size_res["next_offset"];
    }
    dict_state["prev_ask_size"] = ask_size;
    
    return #{
        template_id: template_id,
        msg_seq_num: msg_seq_num,
        symbol: dict_state["prev_symbol"],
        bid_px: (bid_px * 1.0) / 100.0,
        bid_size: bid_size,
        ask_px: (ask_px * 1.0) / 100.0,
        ask_size: ask_size,
        spread: ((ask_px - bid_px) * 1.0) / 100.0,
        bytes_consumed: offset
    };
}

// -----------------------------------------------------------------------------
// Pipeline Event Handlers
// -----------------------------------------------------------------------------

fn process_fast_message(event, pipeline_state) {
    if !pipeline_state.contains("fast_dict") {
        pipeline_state["fast_dict"] = init_fast_dictionary();
    }
    
    let raw_bytes = event["fast_bytes"];
    let decoded = decode_md_incremental_refresh(raw_bytes, pipeline_state["fast_dict"]);
    
    let alerts = [];
    if decoded["spread"] <= 0.0 {
        alerts.push(#{
            rule: "CROSSED_OR_LOCKED_FAST_MARKET",
            severity: "HIGH",
            symbol: decoded["symbol"],
            bid: decoded["bid_px"],
            ask: decoded["ask_px"],
            spread: decoded["spread"]
        });
    }
    
    return #{
        status: "OK",
        decoded: decoded,
        alerts: alerts
    };
}
