/*
 * Zigbee Cluster Library (ZCL) Home Automation IoT Telemetry Dissector
 *
 * Parses standard ZCL clusters: Basic, On/Off, Temperature, Illuminance, and Power.
 */

// Decode Zigbee Cluster ID name
fn get_zigbee_cluster_name(cluster_id) {
    let clusters = #{};
    clusters[0] = "BASIC";
    clusters[1] = "POWER_CONFIGURATION";
    clusters[3] = "IDENTIFY";
    clusters[6] = "ON_OFF";
    clusters[8] = "LEVEL_CONTROL";
    clusters[25] = "OTA_UPGRADE";
    clusters[1024] = "ILLUMINANCE_MEASUREMENT";
    clusters[1026] = "TEMPERATURE_MEASUREMENT";
    clusters[1029] = "RELATIVE_HUMIDITY_MEASUREMENT";
    clusters[1030] = "OCCUPANCY_SENSING";
    if clusters.contains(cluster_id) { return clusters[cluster_id]; }
    return "MANUFACTURER_SPECIFIC";
}

// Decode ZCL Temperature Measurement (0x0402) value: 100 * deg C
fn decode_zcl_temperature(raw_value) {
    let temp_val = raw_value * 1.0;
    return temp_val / 100.0;
}
// Zigbee endpoint device profile 1
fn get_zigbee_device_profile_1() {
    return #{ profile_id: 1, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_1(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 1;
}

// Zigbee endpoint device profile 2
fn get_zigbee_device_profile_2() {
    return #{ profile_id: 2, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_2(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 2;
}

// Zigbee endpoint device profile 3
fn get_zigbee_device_profile_3() {
    return #{ profile_id: 3, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_3(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 3;
}

// Zigbee endpoint device profile 4
fn get_zigbee_device_profile_4() {
    return #{ profile_id: 4, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_4(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 4;
}

// Zigbee endpoint device profile 5
fn get_zigbee_device_profile_5() {
    return #{ profile_id: 5, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_5(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 5;
}

// Zigbee endpoint device profile 6
fn get_zigbee_device_profile_6() {
    return #{ profile_id: 6, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_6(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 6;
}

// Zigbee endpoint device profile 7
fn get_zigbee_device_profile_7() {
    return #{ profile_id: 7, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_7(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 7;
}

// Zigbee endpoint device profile 8
fn get_zigbee_device_profile_8() {
    return #{ profile_id: 8, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_8(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 8;
}

// Zigbee endpoint device profile 9
fn get_zigbee_device_profile_9() {
    return #{ profile_id: 9, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_9(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 9;
}

// Zigbee endpoint device profile 10
fn get_zigbee_device_profile_10() {
    return #{ profile_id: 10, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_10(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 10;
}

// Zigbee endpoint device profile 11
fn get_zigbee_device_profile_11() {
    return #{ profile_id: 11, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_11(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 11;
}

// Zigbee endpoint device profile 12
fn get_zigbee_device_profile_12() {
    return #{ profile_id: 12, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_12(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 12;
}

// Zigbee endpoint device profile 13
fn get_zigbee_device_profile_13() {
    return #{ profile_id: 13, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_13(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 13;
}

// Zigbee endpoint device profile 14
fn get_zigbee_device_profile_14() {
    return #{ profile_id: 14, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_14(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 14;
}

// Zigbee endpoint device profile 15
fn get_zigbee_device_profile_15() {
    return #{ profile_id: 15, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_15(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 15;
}

// Zigbee endpoint device profile 16
fn get_zigbee_device_profile_16() {
    return #{ profile_id: 16, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_16(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 16;
}

// Zigbee endpoint device profile 17
fn get_zigbee_device_profile_17() {
    return #{ profile_id: 17, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_17(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 17;
}

// Zigbee endpoint device profile 18
fn get_zigbee_device_profile_18() {
    return #{ profile_id: 18, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_18(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 18;
}

// Zigbee endpoint device profile 19
fn get_zigbee_device_profile_19() {
    return #{ profile_id: 19, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_19(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 19;
}

// Zigbee endpoint device profile 20
fn get_zigbee_device_profile_20() {
    return #{ profile_id: 20, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_20(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 20;
}

// Zigbee endpoint device profile 21
fn get_zigbee_device_profile_21() {
    return #{ profile_id: 21, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_21(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 21;
}

// Zigbee endpoint device profile 22
fn get_zigbee_device_profile_22() {
    return #{ profile_id: 22, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_22(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 22;
}

// Zigbee endpoint device profile 23
fn get_zigbee_device_profile_23() {
    return #{ profile_id: 23, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_23(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 23;
}

// Zigbee endpoint device profile 24
fn get_zigbee_device_profile_24() {
    return #{ profile_id: 24, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_24(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 24;
}

// Zigbee endpoint device profile 25
fn get_zigbee_device_profile_25() {
    return #{ profile_id: 25, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_25(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 25;
}

// Zigbee endpoint device profile 26
fn get_zigbee_device_profile_26() {
    return #{ profile_id: 26, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_26(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 26;
}

// Zigbee endpoint device profile 27
fn get_zigbee_device_profile_27() {
    return #{ profile_id: 27, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_27(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 27;
}

// Zigbee endpoint device profile 28
fn get_zigbee_device_profile_28() {
    return #{ profile_id: 28, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_28(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 28;
}

// Zigbee endpoint device profile 29
fn get_zigbee_device_profile_29() {
    return #{ profile_id: 29, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_29(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 29;
}

// Zigbee endpoint device profile 30
fn get_zigbee_device_profile_30() {
    return #{ profile_id: 30, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_30(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 30;
}

// Zigbee endpoint device profile 31
fn get_zigbee_device_profile_31() {
    return #{ profile_id: 31, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_31(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 31;
}

// Zigbee endpoint device profile 32
fn get_zigbee_device_profile_32() {
    return #{ profile_id: 32, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_32(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 32;
}

// Zigbee endpoint device profile 33
fn get_zigbee_device_profile_33() {
    return #{ profile_id: 33, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_33(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 33;
}

// Zigbee endpoint device profile 34
fn get_zigbee_device_profile_34() {
    return #{ profile_id: 34, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_34(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 34;
}

// Zigbee endpoint device profile 35
fn get_zigbee_device_profile_35() {
    return #{ profile_id: 35, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_35(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 35;
}

// Zigbee endpoint device profile 36
fn get_zigbee_device_profile_36() {
    return #{ profile_id: 36, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_36(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 36;
}

// Zigbee endpoint device profile 37
fn get_zigbee_device_profile_37() {
    return #{ profile_id: 37, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_37(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 37;
}

// Zigbee endpoint device profile 38
fn get_zigbee_device_profile_38() {
    return #{ profile_id: 38, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_38(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 38;
}

// Zigbee endpoint device profile 39
fn get_zigbee_device_profile_39() {
    return #{ profile_id: 39, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_39(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 39;
}

// Zigbee endpoint device profile 40
fn get_zigbee_device_profile_40() {
    return #{ profile_id: 40, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_40(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 40;
}

// Zigbee endpoint device profile 41
fn get_zigbee_device_profile_41() {
    return #{ profile_id: 41, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_41(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 41;
}

// Zigbee endpoint device profile 42
fn get_zigbee_device_profile_42() {
    return #{ profile_id: 42, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_42(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 42;
}

// Zigbee endpoint device profile 43
fn get_zigbee_device_profile_43() {
    return #{ profile_id: 43, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_43(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 43;
}

// Zigbee endpoint device profile 44
fn get_zigbee_device_profile_44() {
    return #{ profile_id: 44, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_44(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 44;
}

// Zigbee endpoint device profile 45
fn get_zigbee_device_profile_45() {
    return #{ profile_id: 45, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_45(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 45;
}

// Zigbee endpoint device profile 46
fn get_zigbee_device_profile_46() {
    return #{ profile_id: 46, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_46(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 46;
}

// Zigbee endpoint device profile 47
fn get_zigbee_device_profile_47() {
    return #{ profile_id: 47, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_47(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 47;
}

// Zigbee endpoint device profile 48
fn get_zigbee_device_profile_48() {
    return #{ profile_id: 48, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_48(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 48;
}

// Zigbee endpoint device profile 49
fn get_zigbee_device_profile_49() {
    return #{ profile_id: 49, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_49(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 49;
}

// Zigbee endpoint device profile 50
fn get_zigbee_device_profile_50() {
    return #{ profile_id: 50, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_50(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 50;
}

// Zigbee endpoint device profile 51
fn get_zigbee_device_profile_51() {
    return #{ profile_id: 51, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_51(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 51;
}

// Zigbee endpoint device profile 52
fn get_zigbee_device_profile_52() {
    return #{ profile_id: 52, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_52(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 52;
}

// Zigbee endpoint device profile 53
fn get_zigbee_device_profile_53() {
    return #{ profile_id: 53, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_53(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 53;
}

// Zigbee endpoint device profile 54
fn get_zigbee_device_profile_54() {
    return #{ profile_id: 54, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_54(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 54;
}

// Zigbee endpoint device profile 55
fn get_zigbee_device_profile_55() {
    return #{ profile_id: 55, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_55(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 55;
}

// Zigbee endpoint device profile 56
fn get_zigbee_device_profile_56() {
    return #{ profile_id: 56, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_56(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 56;
}

// Zigbee endpoint device profile 57
fn get_zigbee_device_profile_57() {
    return #{ profile_id: 57, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_57(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 57;
}

// Zigbee endpoint device profile 58
fn get_zigbee_device_profile_58() {
    return #{ profile_id: 58, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_58(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 58;
}

// Zigbee endpoint device profile 59
fn get_zigbee_device_profile_59() {
    return #{ profile_id: 59, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_59(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 59;
}

// Zigbee endpoint device profile 60
fn get_zigbee_device_profile_60() {
    return #{ profile_id: 60, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_60(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 60;
}

// Zigbee endpoint device profile 61
fn get_zigbee_device_profile_61() {
    return #{ profile_id: 61, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_61(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 61;
}

// Zigbee endpoint device profile 62
fn get_zigbee_device_profile_62() {
    return #{ profile_id: 62, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_62(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 62;
}

// Zigbee endpoint device profile 63
fn get_zigbee_device_profile_63() {
    return #{ profile_id: 63, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_63(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 63;
}

// Zigbee endpoint device profile 64
fn get_zigbee_device_profile_64() {
    return #{ profile_id: 64, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_64(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 64;
}

// Zigbee endpoint device profile 65
fn get_zigbee_device_profile_65() {
    return #{ profile_id: 65, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_65(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 65;
}

// Zigbee endpoint device profile 66
fn get_zigbee_device_profile_66() {
    return #{ profile_id: 66, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_66(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 66;
}

// Zigbee endpoint device profile 67
fn get_zigbee_device_profile_67() {
    return #{ profile_id: 67, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_67(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 67;
}

// Zigbee endpoint device profile 68
fn get_zigbee_device_profile_68() {
    return #{ profile_id: 68, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_68(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 68;
}

// Zigbee endpoint device profile 69
fn get_zigbee_device_profile_69() {
    return #{ profile_id: 69, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_69(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 69;
}

// Zigbee endpoint device profile 70
fn get_zigbee_device_profile_70() {
    return #{ profile_id: 70, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_70(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 70;
}

// Zigbee endpoint device profile 71
fn get_zigbee_device_profile_71() {
    return #{ profile_id: 71, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_71(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 71;
}

// Zigbee endpoint device profile 72
fn get_zigbee_device_profile_72() {
    return #{ profile_id: 72, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_72(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 72;
}

// Zigbee endpoint device profile 73
fn get_zigbee_device_profile_73() {
    return #{ profile_id: 73, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_73(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 73;
}

// Zigbee endpoint device profile 74
fn get_zigbee_device_profile_74() {
    return #{ profile_id: 74, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_74(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 74;
}

// Zigbee endpoint device profile 75
fn get_zigbee_device_profile_75() {
    return #{ profile_id: 75, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_75(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 75;
}

// Zigbee endpoint device profile 76
fn get_zigbee_device_profile_76() {
    return #{ profile_id: 76, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_76(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 76;
}

// Zigbee endpoint device profile 77
fn get_zigbee_device_profile_77() {
    return #{ profile_id: 77, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_77(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 77;
}

// Zigbee endpoint device profile 78
fn get_zigbee_device_profile_78() {
    return #{ profile_id: 78, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_78(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 78;
}

// Zigbee endpoint device profile 79
fn get_zigbee_device_profile_79() {
    return #{ profile_id: 79, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_79(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 79;
}

// Zigbee endpoint device profile 80
fn get_zigbee_device_profile_80() {
    return #{ profile_id: 80, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_80(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 80;
}

// Zigbee endpoint device profile 81
fn get_zigbee_device_profile_81() {
    return #{ profile_id: 81, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_81(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 81;
}

// Zigbee endpoint device profile 82
fn get_zigbee_device_profile_82() {
    return #{ profile_id: 82, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_82(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 82;
}

// Zigbee endpoint device profile 83
fn get_zigbee_device_profile_83() {
    return #{ profile_id: 83, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_83(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 83;
}

// Zigbee endpoint device profile 84
fn get_zigbee_device_profile_84() {
    return #{ profile_id: 84, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_84(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 84;
}

// Zigbee endpoint device profile 85
fn get_zigbee_device_profile_85() {
    return #{ profile_id: 85, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_85(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 85;
}

// Zigbee endpoint device profile 86
fn get_zigbee_device_profile_86() {
    return #{ profile_id: 86, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_86(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 86;
}

// Zigbee endpoint device profile 87
fn get_zigbee_device_profile_87() {
    return #{ profile_id: 87, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_87(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 87;
}

// Zigbee endpoint device profile 88
fn get_zigbee_device_profile_88() {
    return #{ profile_id: 88, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_88(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 88;
}

// Zigbee endpoint device profile 89
fn get_zigbee_device_profile_89() {
    return #{ profile_id: 89, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_89(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 89;
}

// Zigbee endpoint device profile 90
fn get_zigbee_device_profile_90() {
    return #{ profile_id: 90, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_90(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 90;
}

// Zigbee endpoint device profile 91
fn get_zigbee_device_profile_91() {
    return #{ profile_id: 91, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_91(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 91;
}

// Zigbee endpoint device profile 92
fn get_zigbee_device_profile_92() {
    return #{ profile_id: 92, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_92(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 92;
}

// Zigbee endpoint device profile 93
fn get_zigbee_device_profile_93() {
    return #{ profile_id: 93, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_93(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 93;
}

// Zigbee endpoint device profile 94
fn get_zigbee_device_profile_94() {
    return #{ profile_id: 94, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_94(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 94;
}

// Zigbee endpoint device profile 95
fn get_zigbee_device_profile_95() {
    return #{ profile_id: 95, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_95(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 95;
}

// Zigbee endpoint device profile 96
fn get_zigbee_device_profile_96() {
    return #{ profile_id: 96, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_96(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 96;
}

// Zigbee endpoint device profile 97
fn get_zigbee_device_profile_97() {
    return #{ profile_id: 97, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_97(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 97;
}

// Zigbee endpoint device profile 98
fn get_zigbee_device_profile_98() {
    return #{ profile_id: 98, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_98(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 98;
}

// Zigbee endpoint device profile 99
fn get_zigbee_device_profile_99() {
    return #{ profile_id: 99, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_99(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 99;
}

// Zigbee endpoint device profile 100
fn get_zigbee_device_profile_100() {
    return #{ profile_id: 100, cluster_count: 8, is_router: true };
}
fn check_zigbee_endpoint_100(msg) {
    if !msg.contains("endpoint") { return false; }
    return msg["endpoint"].to_int() == 100;
}
