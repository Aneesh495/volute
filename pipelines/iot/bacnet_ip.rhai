/*
 * BACnet/IP (Building Automation and Control Networks) Dissector
 *
 * Decodes BVLL (BACnet Virtual Link Layer) and APDU application layer services.
 */

// Decode BVLL function code
fn get_bvll_function_name(func_code) {
    if func_code == 0 { return "BVLC_RESULT"; }
    if func_code == 1 { return "WRITE_BROADCAST_DIST_TABLE"; }
    if func_code == 2 { return "READ_BROADCAST_DIST_TABLE"; }
    if func_code == 4 { return "FORWARDED_NPDU"; }
    if func_code == 10 { return "ORIGINAL_UNICAST_NPDU"; }
    if func_code == 11 { return "ORIGINAL_BROADCAST_NPDU"; }
    return "UNKNOWN_BVLL";
}

// Decode standard BACnet object types
fn get_bacnet_object_type(obj_type_id) {
    let types = #{};
    types[0] = "ANALOG_INPUT";
    types[1] = "ANALOG_OUTPUT";
    types[2] = "ANALOG_VALUE";
    types[3] = "BINARY_INPUT";
    types[4] = "BINARY_OUTPUT";
    types[5] = "BINARY_VALUE";
    types[8] = "DEVICE";
    types[13] = "MULTISTATE_INPUT";
    types[14] = "MULTISTATE_OUTPUT";
    types[19] = "MULTISTATE_VALUE";
    if types.contains(obj_type_id) { return types[obj_type_id]; }
    return "CUSTOM_OBJECT";
}

// Validate BACnet telemetry payload
fn validate_bacnet_telemetry(payload) {
    if !payload.contains("object_type") || !payload.contains("instance_id") {
        return false;
    }
    return true;
}
// Validate BACnet profile 1
fn validate_bacnet_profile_1(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 1;
}

// Validate BACnet profile 2
fn validate_bacnet_profile_2(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 2;
}

// Validate BACnet profile 3
fn validate_bacnet_profile_3(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 3;
}

// Validate BACnet profile 4
fn validate_bacnet_profile_4(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 4;
}

// Validate BACnet profile 5
fn validate_bacnet_profile_5(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 5;
}

// Validate BACnet profile 6
fn validate_bacnet_profile_6(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 6;
}

// Validate BACnet profile 7
fn validate_bacnet_profile_7(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 7;
}

// Validate BACnet profile 8
fn validate_bacnet_profile_8(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 8;
}

// Validate BACnet profile 9
fn validate_bacnet_profile_9(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 9;
}

// Validate BACnet profile 10
fn validate_bacnet_profile_10(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 10;
}

// Validate BACnet profile 11
fn validate_bacnet_profile_11(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 11;
}

// Validate BACnet profile 12
fn validate_bacnet_profile_12(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 12;
}

// Validate BACnet profile 13
fn validate_bacnet_profile_13(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 13;
}

// Validate BACnet profile 14
fn validate_bacnet_profile_14(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 14;
}

// Validate BACnet profile 15
fn validate_bacnet_profile_15(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 15;
}

// Validate BACnet profile 16
fn validate_bacnet_profile_16(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 16;
}

// Validate BACnet profile 17
fn validate_bacnet_profile_17(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 17;
}

// Validate BACnet profile 18
fn validate_bacnet_profile_18(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 18;
}

// Validate BACnet profile 19
fn validate_bacnet_profile_19(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 19;
}

// Validate BACnet profile 20
fn validate_bacnet_profile_20(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 20;
}

// Validate BACnet profile 21
fn validate_bacnet_profile_21(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 21;
}

// Validate BACnet profile 22
fn validate_bacnet_profile_22(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 22;
}

// Validate BACnet profile 23
fn validate_bacnet_profile_23(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 23;
}

// Validate BACnet profile 24
fn validate_bacnet_profile_24(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 24;
}

// Validate BACnet profile 25
fn validate_bacnet_profile_25(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 25;
}

// Validate BACnet profile 26
fn validate_bacnet_profile_26(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 26;
}

// Validate BACnet profile 27
fn validate_bacnet_profile_27(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 27;
}

// Validate BACnet profile 28
fn validate_bacnet_profile_28(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 28;
}

// Validate BACnet profile 29
fn validate_bacnet_profile_29(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 29;
}

// Validate BACnet profile 30
fn validate_bacnet_profile_30(telemetry) {
    if !telemetry.contains("device_id") { return false; }
    return telemetry["device_id"].to_int() == 30;
}
