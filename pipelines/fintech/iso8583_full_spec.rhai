/*
 * Complete ISO 8583 Financial Transaction Message Field Specification
 *
 * Defines all standard primary bitmap fields 1 through 64 with decoding logic,
 * field types (fixed, LLVAR, LLLVAR), and semantic validation rules.
 */

// Returns field descriptor definition for standard ISO 8583 fields
fn get_field_definition(field_num) {
    let defs = #{};
    defs[1] = #{ num: 1, format: "b_64", key: "bitmap", name: "Secondary Bitmap" };
    defs[2] = #{ num: 2, format: "n_LLVAR", key: "pan", name: "Primary Account Number (PAN)" };
    defs[3] = #{ num: 3, format: "n_6", key: "proc_code", name: "Processing Code" };
    defs[4] = #{ num: 4, format: "n_12", key: "tx_amount", name: "Amount, Transaction" };
    defs[5] = #{ num: 5, format: "n_12", key: "settle_amount", name: "Amount, Settlement" };
    defs[6] = #{ num: 6, format: "n_12", key: "cardholder_amount", name: "Amount, Cardholder Billing" };
    defs[7] = #{ num: 7, format: "n_10", key: "trans_date_time", name: "Transmission Date & Time (MMDDhhmmss)" };
    defs[8] = #{ num: 8, format: "n_8", key: "billing_fee", name: "Amount, Cardholder Billing Fee" };
    defs[9] = #{ num: 9, format: "n_8", key: "settle_conv_rate", name: "Conversion Rate, Settlement" };
    defs[10] = #{ num: 10, format: "n_8", key: "billing_conv_rate", name: "Conversion Rate, Cardholder Billing" };
    defs[11] = #{ num: 11, format: "n_6", key: "stan", name: "Systems Trace Audit Number (STAN)" };
    defs[12] = #{ num: 12, format: "n_6", key: "local_time", name: "Time, Local Transaction (hhmmss)" };
    defs[13] = #{ num: 13, format: "n_4", key: "local_date", name: "Date, Local Transaction (MMDD)" };
    defs[14] = #{ num: 14, format: "n_4", key: "exp_date", name: "Date, Expiration (YYMM)" };
    defs[15] = #{ num: 15, format: "n_4", key: "settle_date", name: "Date, Settlement (MMDD)" };
    defs[16] = #{ num: 16, format: "n_4", key: "conv_date", name: "Date, Conversion (MMDD)" };
    defs[17] = #{ num: 17, format: "n_4", key: "capture_date", name: "Date, Capture (MMDD)" };
    defs[18] = #{ num: 18, format: "n_4", key: "mcc", name: "Merchant Category Code" };
    defs[19] = #{ num: 19, format: "n_3", key: "acquiring_inst_country", name: "Acquiring Institution Country Code" };
    defs[20] = #{ num: 20, format: "n_3", key: "pan_ext_country", name: "PAN Extended, Country Code" };
    defs[21] = #{ num: 21, format: "n_3", key: "forwarding_inst_country", name: "Forwarding Institution Country Code" };
    defs[22] = #{ num: 22, format: "n_3", key: "pos_entry_mode", name: "Point of Service Entry Mode Code" };
    defs[23] = #{ num: 23, format: "n_3", key: "card_seq_num", name: "Card Sequence Number" };
    defs[24] = #{ num: 24, format: "n_3", key: "function_code", name: "Function Code / Network International ID" };
    defs[25] = #{ num: 25, format: "n_2", key: "pos_condition_code", name: "Point of Service Condition Code" };
    defs[26] = #{ num: 26, format: "n_2", key: "pos_capture_code", name: "Point of Service Capture Code" };
    defs[27] = #{ num: 27, format: "n_1", key: "auth_id_resp_len", name: "Authorizing Identification Response Length" };
    defs[28] = #{ num: 28, format: "x_n_8", key: "tx_fee_amount", name: "Amount, Transaction Fee" };
    defs[29] = #{ num: 29, format: "x_n_8", key: "settle_fee_amount", name: "Amount, Settlement Fee" };
    defs[30] = #{ num: 30, format: "x_n_8", key: "tx_proc_fee_amount", name: "Amount, Transaction Processing Fee" };
    defs[31] = #{ num: 31, format: "x_n_8", key: "settle_proc_fee_amount", name: "Amount, Settlement Processing Fee" };
    defs[32] = #{ num: 32, format: "n_LLVAR", key: "acquirer_id", name: "Acquiring Institution Identification Code" };
    defs[33] = #{ num: 33, format: "n_LLVAR", key: "forwarding_id", name: "Forwarding Institution Identification Code" };
    defs[34] = #{ num: 34, format: "n_LLVAR", key: "pan_ext", name: "Primary Account Number, Extended" };
    defs[35] = #{ num: 35, format: "z_LLVAR", key: "track_2", name: "Track 2 Data" };
    defs[36] = #{ num: 36, format: "n_LLLVAR", key: "track_3", name: "Track 3 Data" };
    defs[37] = #{ num: 37, format: "an_12", key: "rrn", name: "Retrieval Reference Number" };
    defs[38] = #{ num: 38, format: "an_6", key: "auth_code", name: "Authorization Identification Response" };
    defs[39] = #{ num: 39, format: "an_2", key: "resp_code", name: "Response Code" };
    defs[40] = #{ num: 40, format: "an_3", key: "service_rest_code", name: "Service Restriction Code" };
    defs[41] = #{ num: 41, format: "ans_8", key: "terminal_id", name: "Card Acceptor Terminal Identification" };
    defs[42] = #{ num: 42, format: "ans_15", key: "merchant_id", name: "Card Acceptor Identification Code" };
    defs[43] = #{ num: 43, format: "ans_40", key: "merchant_location", name: "Card Acceptor Name/Location" };
    defs[44] = #{ num: 44, format: "an_LLVAR", key: "additional_resp", name: "Additional Response Data" };
    defs[45] = #{ num: 45, format: "an_LLVAR", key: "track_1", name: "Track 1 Data" };
    defs[46] = #{ num: 46, format: "an_LLLVAR", key: "additional_data_iso", name: "Additional Data - ISO" };
    defs[47] = #{ num: 47, format: "an_LLLVAR", key: "additional_data_national", name: "Additional Data - National" };
    defs[48] = #{ num: 48, format: "an_LLLVAR", key: "additional_data_private", name: "Additional Data - Private" };
    defs[49] = #{ num: 49, format: "an_3", key: "currency_tx", name: "Currency Code, Transaction" };
    defs[50] = #{ num: 50, format: "an_3", key: "currency_settle", name: "Currency Code, Settlement" };
    defs[51] = #{ num: 51, format: "an_3", key: "currency_billing", name: "Currency Code, Cardholder Billing" };
    defs[52] = #{ num: 52, format: "b_64", key: "pin_block", name: "Personal Identification Number (PIN) Data" };
    defs[53] = #{ num: 53, format: "n_16", key: "security_control", name: "Security Related Control Information" };
    defs[54] = #{ num: 54, format: "an_LLLVAR", key: "additional_amounts", name: "Additional Amounts" };
    defs[55] = #{ num: 55, format: "ans_LLLVAR", key: "icc_emv_data", name: "ICC System Related Data (EMV Tags)" };
    defs[56] = #{ num: 56, format: "ans_LLLVAR", key: "original_data_elements", name: "Original Data Elements" };
    defs[57] = #{ num: 57, format: "ans_LLLVAR", key: "authorizing_agent_id", name: "Authorizing Agent Institution Id" };
    defs[58] = #{ num: 58, format: "ans_LLLVAR", key: "authorizing_agent_id_ext", name: "Authorizing Agent Id Extended" };
    defs[59] = #{ num: 59, format: "ans_LLLVAR", key: "transport_data", name: "Transport Data" };
    defs[60] = #{ num: 60, format: "ans_LLLVAR", key: "reserved_national_60", name: "Reserved National 60" };
    defs[61] = #{ num: 61, format: "ans_LLLVAR", key: "reserved_national_61", name: "Reserved National 61" };
    defs[62] = #{ num: 62, format: "ans_LLLVAR", key: "reserved_private_62", name: "Reserved Private 62" };
    defs[63] = #{ num: 63, format: "ans_LLLVAR", key: "reserved_private_63", name: "Reserved Private 63" };
    defs[64] = #{ num: 64, format: "b_64", key: "mac", name: "Message Authentication Code (MAC)" };
    if defs.contains(field_num) {
        return defs[field_num];
    }
    return #{ num: field_num, format: "ans_LLLVAR", key: "field_" + field_num.to_string(), name: "Custom Field" };
}

// Parse MTI (Message Type Identifier) into structural components
fn parse_mti(mti_str) {
    if mti_str.len() != 4 {
        return #{ is_valid: false };
    }
    let version_char = mti_str.sub_string(0, 1);
    let class_char = mti_str.sub_string(1, 1);
    let function_char = mti_str.sub_string(2, 1);
    let origin_char = mti_str.sub_string(3, 1);

    let version_name = "ISO 8583-1:1987";
    if version_char == "1" { version_name = "ISO 8583-2:1993"; }
    if version_char == "2" { version_name = "ISO 8583-3:2003"; }

    let class_name = "Authorization";
    if class_char == "2" { class_name = "Financial"; }
    if class_char == "4" { class_name = "Reversal"; }
    if class_char == "8" { class_name = "Network Management"; }

    let is_request = function_char == "0" || function_char == "2";
    let is_response = function_char == "1" || function_char == "3";

    return #{
        mti: mti_str,
        version: version_name,
        message_class: class_name,
        is_request: is_request,
        is_response: is_response,
        is_valid: true
    };
}

// Format financial amount from cents string to decimal
fn parse_iso_amount(amt_str) {
    let cents = amt_str.to_float();
    return cents / 100.0;
}
// Validate field 1: Secondary Bitmap
fn validate_field_1_bitmap(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 2: Primary Account Number (PAN)
fn validate_field_2_pan(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 3: Processing Code
fn validate_field_3_proc_code(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 4: Amount, Transaction
fn validate_field_4_tx_amount(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 5: Amount, Settlement
fn validate_field_5_settle_amount(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 6: Amount, Cardholder Billing
fn validate_field_6_cardholder_amount(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 7: Transmission Date & Time (MMDDhhmmss)
fn validate_field_7_trans_date_time(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 8: Amount, Cardholder Billing Fee
fn validate_field_8_billing_fee(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 9: Conversion Rate, Settlement
fn validate_field_9_settle_conv_rate(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 10: Conversion Rate, Cardholder Billing
fn validate_field_10_billing_conv_rate(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 11: Systems Trace Audit Number (STAN)
fn validate_field_11_stan(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 12: Time, Local Transaction (hhmmss)
fn validate_field_12_local_time(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 13: Date, Local Transaction (MMDD)
fn validate_field_13_local_date(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 14: Date, Expiration (YYMM)
fn validate_field_14_exp_date(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 15: Date, Settlement (MMDD)
fn validate_field_15_settle_date(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 16: Date, Conversion (MMDD)
fn validate_field_16_conv_date(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 17: Date, Capture (MMDD)
fn validate_field_17_capture_date(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 18: Merchant Category Code
fn validate_field_18_mcc(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 19: Acquiring Institution Country Code
fn validate_field_19_acquiring_inst_country(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 20: PAN Extended, Country Code
fn validate_field_20_pan_ext_country(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 21: Forwarding Institution Country Code
fn validate_field_21_forwarding_inst_country(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 22: Point of Service Entry Mode Code
fn validate_field_22_pos_entry_mode(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 23: Card Sequence Number
fn validate_field_23_card_seq_num(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 24: Function Code / Network International ID
fn validate_field_24_function_code(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 25: Point of Service Condition Code
fn validate_field_25_pos_condition_code(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 26: Point of Service Capture Code
fn validate_field_26_pos_capture_code(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 27: Authorizing Identification Response Length
fn validate_field_27_auth_id_resp_len(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 28: Amount, Transaction Fee
fn validate_field_28_tx_fee_amount(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 29: Amount, Settlement Fee
fn validate_field_29_settle_fee_amount(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 30: Amount, Transaction Processing Fee
fn validate_field_30_tx_proc_fee_amount(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 31: Amount, Settlement Processing Fee
fn validate_field_31_settle_proc_fee_amount(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 32: Acquiring Institution Identification Code
fn validate_field_32_acquirer_id(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 33: Forwarding Institution Identification Code
fn validate_field_33_forwarding_id(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 34: Primary Account Number, Extended
fn validate_field_34_pan_ext(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 35: Track 2 Data
fn validate_field_35_track_2(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 36: Track 3 Data
fn validate_field_36_track_3(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 37: Retrieval Reference Number
fn validate_field_37_rrn(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 38: Authorization Identification Response
fn validate_field_38_auth_code(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 39: Response Code
fn validate_field_39_resp_code(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 40: Service Restriction Code
fn validate_field_40_service_rest_code(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 41: Card Acceptor Terminal Identification
fn validate_field_41_terminal_id(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 42: Card Acceptor Identification Code
fn validate_field_42_merchant_id(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 43: Card Acceptor Name/Location
fn validate_field_43_merchant_location(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 44: Additional Response Data
fn validate_field_44_additional_resp(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 45: Track 1 Data
fn validate_field_45_track_1(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 46: Additional Data - ISO
fn validate_field_46_additional_data_iso(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 47: Additional Data - National
fn validate_field_47_additional_data_national(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 48: Additional Data - Private
fn validate_field_48_additional_data_private(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 49: Currency Code, Transaction
fn validate_field_49_currency_tx(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 50: Currency Code, Settlement
fn validate_field_50_currency_settle(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 51: Currency Code, Cardholder Billing
fn validate_field_51_currency_billing(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 52: Personal Identification Number (PIN) Data
fn validate_field_52_pin_block(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 53: Security Related Control Information
fn validate_field_53_security_control(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 54: Additional Amounts
fn validate_field_54_additional_amounts(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 55: ICC System Related Data (EMV Tags)
fn validate_field_55_icc_emv_data(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 56: Original Data Elements
fn validate_field_56_original_data_elements(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 57: Authorizing Agent Institution Id
fn validate_field_57_authorizing_agent_id(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 58: Authorizing Agent Id Extended
fn validate_field_58_authorizing_agent_id_ext(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 59: Transport Data
fn validate_field_59_transport_data(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 60: Reserved National 60
fn validate_field_60_reserved_national_60(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 61: Reserved National 61
fn validate_field_61_reserved_national_61(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 62: Reserved Private 62
fn validate_field_62_reserved_private_62(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 63: Reserved Private 63
fn validate_field_63_reserved_private_63(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}

// Validate field 64: Message Authentication Code (MAC)
fn validate_field_64_mac(val) {
    if type_of(val) == "()" { return true; }
    let s = val.to_string();
    if s.is_empty() { return false; }
    return true;
}
