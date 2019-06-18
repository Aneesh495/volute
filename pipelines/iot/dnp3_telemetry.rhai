/*
 * DNP3 (IEEE 1815) SCADA Electric Utility Telemetry Dissector
 *
 * Decodes Outstation object groups: Binary Inputs, Analog Inputs,
 * Counters, Quality Flags, and Internal Indications (IIN) bytes.
 */

// Decode DNP3 Object Group name
fn get_dnp3_group_name(group_num) {
    let groups = #{};
    groups[1] = "BINARY_INPUT";
    groups[2] = "BINARY_INPUT_EVENT";
    groups[10] = "BINARY_OUTPUT";
    groups[12] = "CONTROL_RELAY_OUTPUT_BLOCK";
    groups[20] = "BINARY_COUNTER";
    groups[22] = "COUNTER_EVENT";
    groups[30] = "ANALOG_INPUT";
    groups[32] = "ANALOG_INPUT_EVENT";
    groups[40] = "ANALOG_OUTPUT_STATUS";
    groups[41] = "ANALOG_OUTPUT_BLOCK";
    groups[50] = "TIME_AND_DATE";
    groups[60] = "CLASS_DATA";
    groups[80] = "INTERNAL_INDICATIONS";
    if groups.contains(group_num) { return groups[group_num]; }
    return "UNKNOWN_GROUP";
}

// Decode DNP3 binary quality byte flags
fn decode_binary_quality(flag_byte) {
    return #{
        online: (flag_byte & 1) != 0,
        restart: (flag_byte & 2) != 0,
        comm_lost: (flag_byte & 4) != 0,
        remote_forced: (flag_byte & 8) != 0,
        local_forced: (flag_byte & 16) != 0,
        chatter_filter: (flag_byte & 32) != 0
    };
}

// Decode DNP3 analog quality byte flags
fn decode_analog_quality(flag_byte) {
    return #{
        online: (flag_byte & 1) != 0,
        restart: (flag_byte & 2) != 0,
        comm_lost: (flag_byte & 4) != 0,
        remote_forced: (flag_byte & 8) != 0,
        local_forced: (flag_byte & 16) != 0,
        overrange: (flag_byte & 32) != 0,
        reference_check: (flag_byte & 64) != 0
    };
}
// Validate DNP3 object point index 1
fn validate_dnp3_point_1(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 1;
}
fn get_dnp3_point_scale_1() {
    return 1.0 + (1 * 0.05);
}

// Validate DNP3 object point index 2
fn validate_dnp3_point_2(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 2;
}
fn get_dnp3_point_scale_2() {
    return 1.0 + (2 * 0.05);
}

// Validate DNP3 object point index 3
fn validate_dnp3_point_3(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 3;
}
fn get_dnp3_point_scale_3() {
    return 1.0 + (3 * 0.05);
}

// Validate DNP3 object point index 4
fn validate_dnp3_point_4(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 4;
}
fn get_dnp3_point_scale_4() {
    return 1.0 + (4 * 0.05);
}

// Validate DNP3 object point index 5
fn validate_dnp3_point_5(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 5;
}
fn get_dnp3_point_scale_5() {
    return 1.0 + (5 * 0.05);
}

// Validate DNP3 object point index 6
fn validate_dnp3_point_6(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 6;
}
fn get_dnp3_point_scale_6() {
    return 1.0 + (6 * 0.05);
}

// Validate DNP3 object point index 7
fn validate_dnp3_point_7(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 7;
}
fn get_dnp3_point_scale_7() {
    return 1.0 + (7 * 0.05);
}

// Validate DNP3 object point index 8
fn validate_dnp3_point_8(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 8;
}
fn get_dnp3_point_scale_8() {
    return 1.0 + (8 * 0.05);
}

// Validate DNP3 object point index 9
fn validate_dnp3_point_9(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 9;
}
fn get_dnp3_point_scale_9() {
    return 1.0 + (9 * 0.05);
}

// Validate DNP3 object point index 10
fn validate_dnp3_point_10(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 10;
}
fn get_dnp3_point_scale_10() {
    return 1.0 + (10 * 0.05);
}

// Validate DNP3 object point index 11
fn validate_dnp3_point_11(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 11;
}
fn get_dnp3_point_scale_11() {
    return 1.0 + (11 * 0.05);
}

// Validate DNP3 object point index 12
fn validate_dnp3_point_12(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 12;
}
fn get_dnp3_point_scale_12() {
    return 1.0 + (12 * 0.05);
}

// Validate DNP3 object point index 13
fn validate_dnp3_point_13(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 13;
}
fn get_dnp3_point_scale_13() {
    return 1.0 + (13 * 0.05);
}

// Validate DNP3 object point index 14
fn validate_dnp3_point_14(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 14;
}
fn get_dnp3_point_scale_14() {
    return 1.0 + (14 * 0.05);
}

// Validate DNP3 object point index 15
fn validate_dnp3_point_15(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 15;
}
fn get_dnp3_point_scale_15() {
    return 1.0 + (15 * 0.05);
}

// Validate DNP3 object point index 16
fn validate_dnp3_point_16(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 16;
}
fn get_dnp3_point_scale_16() {
    return 1.0 + (16 * 0.05);
}

// Validate DNP3 object point index 17
fn validate_dnp3_point_17(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 17;
}
fn get_dnp3_point_scale_17() {
    return 1.0 + (17 * 0.05);
}

// Validate DNP3 object point index 18
fn validate_dnp3_point_18(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 18;
}
fn get_dnp3_point_scale_18() {
    return 1.0 + (18 * 0.05);
}

// Validate DNP3 object point index 19
fn validate_dnp3_point_19(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 19;
}
fn get_dnp3_point_scale_19() {
    return 1.0 + (19 * 0.05);
}

// Validate DNP3 object point index 20
fn validate_dnp3_point_20(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 20;
}
fn get_dnp3_point_scale_20() {
    return 1.0 + (20 * 0.05);
}

// Validate DNP3 object point index 21
fn validate_dnp3_point_21(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 21;
}
fn get_dnp3_point_scale_21() {
    return 1.0 + (21 * 0.05);
}

// Validate DNP3 object point index 22
fn validate_dnp3_point_22(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 22;
}
fn get_dnp3_point_scale_22() {
    return 1.0 + (22 * 0.05);
}

// Validate DNP3 object point index 23
fn validate_dnp3_point_23(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 23;
}
fn get_dnp3_point_scale_23() {
    return 1.0 + (23 * 0.05);
}

// Validate DNP3 object point index 24
fn validate_dnp3_point_24(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 24;
}
fn get_dnp3_point_scale_24() {
    return 1.0 + (24 * 0.05);
}

// Validate DNP3 object point index 25
fn validate_dnp3_point_25(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 25;
}
fn get_dnp3_point_scale_25() {
    return 1.0 + (25 * 0.05);
}

// Validate DNP3 object point index 26
fn validate_dnp3_point_26(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 26;
}
fn get_dnp3_point_scale_26() {
    return 1.0 + (26 * 0.05);
}

// Validate DNP3 object point index 27
fn validate_dnp3_point_27(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 27;
}
fn get_dnp3_point_scale_27() {
    return 1.0 + (27 * 0.05);
}

// Validate DNP3 object point index 28
fn validate_dnp3_point_28(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 28;
}
fn get_dnp3_point_scale_28() {
    return 1.0 + (28 * 0.05);
}

// Validate DNP3 object point index 29
fn validate_dnp3_point_29(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 29;
}
fn get_dnp3_point_scale_29() {
    return 1.0 + (29 * 0.05);
}

// Validate DNP3 object point index 30
fn validate_dnp3_point_30(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 30;
}
fn get_dnp3_point_scale_30() {
    return 1.0 + (30 * 0.05);
}

// Validate DNP3 object point index 31
fn validate_dnp3_point_31(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 31;
}
fn get_dnp3_point_scale_31() {
    return 1.0 + (31 * 0.05);
}

// Validate DNP3 object point index 32
fn validate_dnp3_point_32(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 32;
}
fn get_dnp3_point_scale_32() {
    return 1.0 + (32 * 0.05);
}

// Validate DNP3 object point index 33
fn validate_dnp3_point_33(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 33;
}
fn get_dnp3_point_scale_33() {
    return 1.0 + (33 * 0.05);
}

// Validate DNP3 object point index 34
fn validate_dnp3_point_34(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 34;
}
fn get_dnp3_point_scale_34() {
    return 1.0 + (34 * 0.05);
}

// Validate DNP3 object point index 35
fn validate_dnp3_point_35(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 35;
}
fn get_dnp3_point_scale_35() {
    return 1.0 + (35 * 0.05);
}

// Validate DNP3 object point index 36
fn validate_dnp3_point_36(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 36;
}
fn get_dnp3_point_scale_36() {
    return 1.0 + (36 * 0.05);
}

// Validate DNP3 object point index 37
fn validate_dnp3_point_37(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 37;
}
fn get_dnp3_point_scale_37() {
    return 1.0 + (37 * 0.05);
}

// Validate DNP3 object point index 38
fn validate_dnp3_point_38(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 38;
}
fn get_dnp3_point_scale_38() {
    return 1.0 + (38 * 0.05);
}

// Validate DNP3 object point index 39
fn validate_dnp3_point_39(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 39;
}
fn get_dnp3_point_scale_39() {
    return 1.0 + (39 * 0.05);
}

// Validate DNP3 object point index 40
fn validate_dnp3_point_40(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 40;
}
fn get_dnp3_point_scale_40() {
    return 1.0 + (40 * 0.05);
}

// Validate DNP3 object point index 41
fn validate_dnp3_point_41(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 41;
}
fn get_dnp3_point_scale_41() {
    return 1.0 + (41 * 0.05);
}

// Validate DNP3 object point index 42
fn validate_dnp3_point_42(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 42;
}
fn get_dnp3_point_scale_42() {
    return 1.0 + (42 * 0.05);
}

// Validate DNP3 object point index 43
fn validate_dnp3_point_43(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 43;
}
fn get_dnp3_point_scale_43() {
    return 1.0 + (43 * 0.05);
}

// Validate DNP3 object point index 44
fn validate_dnp3_point_44(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 44;
}
fn get_dnp3_point_scale_44() {
    return 1.0 + (44 * 0.05);
}

// Validate DNP3 object point index 45
fn validate_dnp3_point_45(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 45;
}
fn get_dnp3_point_scale_45() {
    return 1.0 + (45 * 0.05);
}

// Validate DNP3 object point index 46
fn validate_dnp3_point_46(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 46;
}
fn get_dnp3_point_scale_46() {
    return 1.0 + (46 * 0.05);
}

// Validate DNP3 object point index 47
fn validate_dnp3_point_47(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 47;
}
fn get_dnp3_point_scale_47() {
    return 1.0 + (47 * 0.05);
}

// Validate DNP3 object point index 48
fn validate_dnp3_point_48(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 48;
}
fn get_dnp3_point_scale_48() {
    return 1.0 + (48 * 0.05);
}

// Validate DNP3 object point index 49
fn validate_dnp3_point_49(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 49;
}
fn get_dnp3_point_scale_49() {
    return 1.0 + (49 * 0.05);
}

// Validate DNP3 object point index 50
fn validate_dnp3_point_50(point) {
    if !point.contains("index") { return false; }
    return point["index"].to_int() == 50;
}
fn get_dnp3_point_scale_50() {
    return 1.0 + (50 * 0.05);
}
