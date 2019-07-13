/*
 * Diameter Base Protocol (RFC 6733) and 3GPP LTE EPC Stream Dissector
 *
 * Parses Diameter command codes, Application IDs, and Attribute-Value Pairs (AVPs).
 */

// Decode Diameter command code name
fn get_diameter_command_name(cmd_code) {
    let cmds = #{};
    cmds[257] = "Capabilities-Exchange";
    cmds[258] = "Re-Auth";
    cmds[271] = "Accounting";
    cmds[272] = "Credit-Control";
    cmds[274] = "Abort-Session";
    cmds[275] = "Session-Termination";
    cmds[280] = "Device-Watchdog";
    cmds[282] = "Disconnect-Peer";
    if cmds.contains(cmd_code) { return cmds[cmd_code]; }
    return "UNKNOWN_COMMAND";
}

// Decode Diameter Result-Code (RFC 6733)
fn decode_diameter_result_code(code) {
    if code == 2001 { return "DIAMETER_SUCCESS"; }
    if code == 3001 { return "DIAMETER_COMMAND_UNSUPPORTED"; }
    if code == 4001 { return "DIAMETER_AUTHENTICATION_REJECTED"; }
    if code == 5001 { return "DIAMETER_AVP_UNSUPPORTED"; }
    if code == 5003 { return "DIAMETER_AUTHORIZATION_REJECTED"; }
    return "DIAMETER_ERROR";
}
// Diameter AVP Code Validator 1
fn validate_diameter_avp_1(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 1;
}
fn get_diameter_avp_type_1() {
    return "UTF8String";
}

// Diameter AVP Code Validator 2
fn validate_diameter_avp_2(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 2;
}
fn get_diameter_avp_type_2() {
    return "UTF8String";
}

// Diameter AVP Code Validator 3
fn validate_diameter_avp_3(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 3;
}
fn get_diameter_avp_type_3() {
    return "UTF8String";
}

// Diameter AVP Code Validator 4
fn validate_diameter_avp_4(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 4;
}
fn get_diameter_avp_type_4() {
    return "UTF8String";
}

// Diameter AVP Code Validator 5
fn validate_diameter_avp_5(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 5;
}
fn get_diameter_avp_type_5() {
    return "UTF8String";
}

// Diameter AVP Code Validator 6
fn validate_diameter_avp_6(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 6;
}
fn get_diameter_avp_type_6() {
    return "UTF8String";
}

// Diameter AVP Code Validator 7
fn validate_diameter_avp_7(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 7;
}
fn get_diameter_avp_type_7() {
    return "UTF8String";
}

// Diameter AVP Code Validator 8
fn validate_diameter_avp_8(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 8;
}
fn get_diameter_avp_type_8() {
    return "UTF8String";
}

// Diameter AVP Code Validator 9
fn validate_diameter_avp_9(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 9;
}
fn get_diameter_avp_type_9() {
    return "UTF8String";
}

// Diameter AVP Code Validator 10
fn validate_diameter_avp_10(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 10;
}
fn get_diameter_avp_type_10() {
    return "UTF8String";
}

// Diameter AVP Code Validator 11
fn validate_diameter_avp_11(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 11;
}
fn get_diameter_avp_type_11() {
    return "UTF8String";
}

// Diameter AVP Code Validator 12
fn validate_diameter_avp_12(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 12;
}
fn get_diameter_avp_type_12() {
    return "UTF8String";
}

// Diameter AVP Code Validator 13
fn validate_diameter_avp_13(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 13;
}
fn get_diameter_avp_type_13() {
    return "UTF8String";
}

// Diameter AVP Code Validator 14
fn validate_diameter_avp_14(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 14;
}
fn get_diameter_avp_type_14() {
    return "UTF8String";
}

// Diameter AVP Code Validator 15
fn validate_diameter_avp_15(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 15;
}
fn get_diameter_avp_type_15() {
    return "UTF8String";
}

// Diameter AVP Code Validator 16
fn validate_diameter_avp_16(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 16;
}
fn get_diameter_avp_type_16() {
    return "UTF8String";
}

// Diameter AVP Code Validator 17
fn validate_diameter_avp_17(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 17;
}
fn get_diameter_avp_type_17() {
    return "UTF8String";
}

// Diameter AVP Code Validator 18
fn validate_diameter_avp_18(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 18;
}
fn get_diameter_avp_type_18() {
    return "UTF8String";
}

// Diameter AVP Code Validator 19
fn validate_diameter_avp_19(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 19;
}
fn get_diameter_avp_type_19() {
    return "UTF8String";
}

// Diameter AVP Code Validator 20
fn validate_diameter_avp_20(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 20;
}
fn get_diameter_avp_type_20() {
    return "UTF8String";
}

// Diameter AVP Code Validator 21
fn validate_diameter_avp_21(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 21;
}
fn get_diameter_avp_type_21() {
    return "UTF8String";
}

// Diameter AVP Code Validator 22
fn validate_diameter_avp_22(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 22;
}
fn get_diameter_avp_type_22() {
    return "UTF8String";
}

// Diameter AVP Code Validator 23
fn validate_diameter_avp_23(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 23;
}
fn get_diameter_avp_type_23() {
    return "UTF8String";
}

// Diameter AVP Code Validator 24
fn validate_diameter_avp_24(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 24;
}
fn get_diameter_avp_type_24() {
    return "UTF8String";
}

// Diameter AVP Code Validator 25
fn validate_diameter_avp_25(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 25;
}
fn get_diameter_avp_type_25() {
    return "UTF8String";
}

// Diameter AVP Code Validator 26
fn validate_diameter_avp_26(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 26;
}
fn get_diameter_avp_type_26() {
    return "UTF8String";
}

// Diameter AVP Code Validator 27
fn validate_diameter_avp_27(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 27;
}
fn get_diameter_avp_type_27() {
    return "UTF8String";
}

// Diameter AVP Code Validator 28
fn validate_diameter_avp_28(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 28;
}
fn get_diameter_avp_type_28() {
    return "UTF8String";
}

// Diameter AVP Code Validator 29
fn validate_diameter_avp_29(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 29;
}
fn get_diameter_avp_type_29() {
    return "UTF8String";
}

// Diameter AVP Code Validator 30
fn validate_diameter_avp_30(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 30;
}
fn get_diameter_avp_type_30() {
    return "UTF8String";
}

// Diameter AVP Code Validator 31
fn validate_diameter_avp_31(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 31;
}
fn get_diameter_avp_type_31() {
    return "UTF8String";
}

// Diameter AVP Code Validator 32
fn validate_diameter_avp_32(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 32;
}
fn get_diameter_avp_type_32() {
    return "UTF8String";
}

// Diameter AVP Code Validator 33
fn validate_diameter_avp_33(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 33;
}
fn get_diameter_avp_type_33() {
    return "UTF8String";
}

// Diameter AVP Code Validator 34
fn validate_diameter_avp_34(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 34;
}
fn get_diameter_avp_type_34() {
    return "UTF8String";
}

// Diameter AVP Code Validator 35
fn validate_diameter_avp_35(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 35;
}
fn get_diameter_avp_type_35() {
    return "UTF8String";
}

// Diameter AVP Code Validator 36
fn validate_diameter_avp_36(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 36;
}
fn get_diameter_avp_type_36() {
    return "UTF8String";
}

// Diameter AVP Code Validator 37
fn validate_diameter_avp_37(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 37;
}
fn get_diameter_avp_type_37() {
    return "UTF8String";
}

// Diameter AVP Code Validator 38
fn validate_diameter_avp_38(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 38;
}
fn get_diameter_avp_type_38() {
    return "UTF8String";
}

// Diameter AVP Code Validator 39
fn validate_diameter_avp_39(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 39;
}
fn get_diameter_avp_type_39() {
    return "UTF8String";
}

// Diameter AVP Code Validator 40
fn validate_diameter_avp_40(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 40;
}
fn get_diameter_avp_type_40() {
    return "UTF8String";
}

// Diameter AVP Code Validator 41
fn validate_diameter_avp_41(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 41;
}
fn get_diameter_avp_type_41() {
    return "UTF8String";
}

// Diameter AVP Code Validator 42
fn validate_diameter_avp_42(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 42;
}
fn get_diameter_avp_type_42() {
    return "UTF8String";
}

// Diameter AVP Code Validator 43
fn validate_diameter_avp_43(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 43;
}
fn get_diameter_avp_type_43() {
    return "UTF8String";
}

// Diameter AVP Code Validator 44
fn validate_diameter_avp_44(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 44;
}
fn get_diameter_avp_type_44() {
    return "UTF8String";
}

// Diameter AVP Code Validator 45
fn validate_diameter_avp_45(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 45;
}
fn get_diameter_avp_type_45() {
    return "UTF8String";
}

// Diameter AVP Code Validator 46
fn validate_diameter_avp_46(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 46;
}
fn get_diameter_avp_type_46() {
    return "UTF8String";
}

// Diameter AVP Code Validator 47
fn validate_diameter_avp_47(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 47;
}
fn get_diameter_avp_type_47() {
    return "UTF8String";
}

// Diameter AVP Code Validator 48
fn validate_diameter_avp_48(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 48;
}
fn get_diameter_avp_type_48() {
    return "UTF8String";
}

// Diameter AVP Code Validator 49
fn validate_diameter_avp_49(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 49;
}
fn get_diameter_avp_type_49() {
    return "UTF8String";
}

// Diameter AVP Code Validator 50
fn validate_diameter_avp_50(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 50;
}
fn get_diameter_avp_type_50() {
    return "UTF8String";
}

// Diameter AVP Code Validator 51
fn validate_diameter_avp_51(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 51;
}
fn get_diameter_avp_type_51() {
    return "UTF8String";
}

// Diameter AVP Code Validator 52
fn validate_diameter_avp_52(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 52;
}
fn get_diameter_avp_type_52() {
    return "UTF8String";
}

// Diameter AVP Code Validator 53
fn validate_diameter_avp_53(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 53;
}
fn get_diameter_avp_type_53() {
    return "UTF8String";
}

// Diameter AVP Code Validator 54
fn validate_diameter_avp_54(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 54;
}
fn get_diameter_avp_type_54() {
    return "UTF8String";
}

// Diameter AVP Code Validator 55
fn validate_diameter_avp_55(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 55;
}
fn get_diameter_avp_type_55() {
    return "UTF8String";
}

// Diameter AVP Code Validator 56
fn validate_diameter_avp_56(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 56;
}
fn get_diameter_avp_type_56() {
    return "UTF8String";
}

// Diameter AVP Code Validator 57
fn validate_diameter_avp_57(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 57;
}
fn get_diameter_avp_type_57() {
    return "UTF8String";
}

// Diameter AVP Code Validator 58
fn validate_diameter_avp_58(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 58;
}
fn get_diameter_avp_type_58() {
    return "UTF8String";
}

// Diameter AVP Code Validator 59
fn validate_diameter_avp_59(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 59;
}
fn get_diameter_avp_type_59() {
    return "UTF8String";
}

// Diameter AVP Code Validator 60
fn validate_diameter_avp_60(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 60;
}
fn get_diameter_avp_type_60() {
    return "UTF8String";
}

// Diameter AVP Code Validator 61
fn validate_diameter_avp_61(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 61;
}
fn get_diameter_avp_type_61() {
    return "UTF8String";
}

// Diameter AVP Code Validator 62
fn validate_diameter_avp_62(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 62;
}
fn get_diameter_avp_type_62() {
    return "UTF8String";
}

// Diameter AVP Code Validator 63
fn validate_diameter_avp_63(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 63;
}
fn get_diameter_avp_type_63() {
    return "UTF8String";
}

// Diameter AVP Code Validator 64
fn validate_diameter_avp_64(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 64;
}
fn get_diameter_avp_type_64() {
    return "UTF8String";
}

// Diameter AVP Code Validator 65
fn validate_diameter_avp_65(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 65;
}
fn get_diameter_avp_type_65() {
    return "UTF8String";
}

// Diameter AVP Code Validator 66
fn validate_diameter_avp_66(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 66;
}
fn get_diameter_avp_type_66() {
    return "UTF8String";
}

// Diameter AVP Code Validator 67
fn validate_diameter_avp_67(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 67;
}
fn get_diameter_avp_type_67() {
    return "UTF8String";
}

// Diameter AVP Code Validator 68
fn validate_diameter_avp_68(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 68;
}
fn get_diameter_avp_type_68() {
    return "UTF8String";
}

// Diameter AVP Code Validator 69
fn validate_diameter_avp_69(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 69;
}
fn get_diameter_avp_type_69() {
    return "UTF8String";
}

// Diameter AVP Code Validator 70
fn validate_diameter_avp_70(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 70;
}
fn get_diameter_avp_type_70() {
    return "UTF8String";
}

// Diameter AVP Code Validator 71
fn validate_diameter_avp_71(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 71;
}
fn get_diameter_avp_type_71() {
    return "UTF8String";
}

// Diameter AVP Code Validator 72
fn validate_diameter_avp_72(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 72;
}
fn get_diameter_avp_type_72() {
    return "UTF8String";
}

// Diameter AVP Code Validator 73
fn validate_diameter_avp_73(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 73;
}
fn get_diameter_avp_type_73() {
    return "UTF8String";
}

// Diameter AVP Code Validator 74
fn validate_diameter_avp_74(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 74;
}
fn get_diameter_avp_type_74() {
    return "UTF8String";
}

// Diameter AVP Code Validator 75
fn validate_diameter_avp_75(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 75;
}
fn get_diameter_avp_type_75() {
    return "UTF8String";
}

// Diameter AVP Code Validator 76
fn validate_diameter_avp_76(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 76;
}
fn get_diameter_avp_type_76() {
    return "UTF8String";
}

// Diameter AVP Code Validator 77
fn validate_diameter_avp_77(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 77;
}
fn get_diameter_avp_type_77() {
    return "UTF8String";
}

// Diameter AVP Code Validator 78
fn validate_diameter_avp_78(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 78;
}
fn get_diameter_avp_type_78() {
    return "UTF8String";
}

// Diameter AVP Code Validator 79
fn validate_diameter_avp_79(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 79;
}
fn get_diameter_avp_type_79() {
    return "UTF8String";
}

// Diameter AVP Code Validator 80
fn validate_diameter_avp_80(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 80;
}
fn get_diameter_avp_type_80() {
    return "UTF8String";
}

// Diameter AVP Code Validator 81
fn validate_diameter_avp_81(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 81;
}
fn get_diameter_avp_type_81() {
    return "UTF8String";
}

// Diameter AVP Code Validator 82
fn validate_diameter_avp_82(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 82;
}
fn get_diameter_avp_type_82() {
    return "UTF8String";
}

// Diameter AVP Code Validator 83
fn validate_diameter_avp_83(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 83;
}
fn get_diameter_avp_type_83() {
    return "UTF8String";
}

// Diameter AVP Code Validator 84
fn validate_diameter_avp_84(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 84;
}
fn get_diameter_avp_type_84() {
    return "UTF8String";
}

// Diameter AVP Code Validator 85
fn validate_diameter_avp_85(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 85;
}
fn get_diameter_avp_type_85() {
    return "UTF8String";
}

// Diameter AVP Code Validator 86
fn validate_diameter_avp_86(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 86;
}
fn get_diameter_avp_type_86() {
    return "UTF8String";
}

// Diameter AVP Code Validator 87
fn validate_diameter_avp_87(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 87;
}
fn get_diameter_avp_type_87() {
    return "UTF8String";
}

// Diameter AVP Code Validator 88
fn validate_diameter_avp_88(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 88;
}
fn get_diameter_avp_type_88() {
    return "UTF8String";
}

// Diameter AVP Code Validator 89
fn validate_diameter_avp_89(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 89;
}
fn get_diameter_avp_type_89() {
    return "UTF8String";
}

// Diameter AVP Code Validator 90
fn validate_diameter_avp_90(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 90;
}
fn get_diameter_avp_type_90() {
    return "UTF8String";
}

// Diameter AVP Code Validator 91
fn validate_diameter_avp_91(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 91;
}
fn get_diameter_avp_type_91() {
    return "UTF8String";
}

// Diameter AVP Code Validator 92
fn validate_diameter_avp_92(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 92;
}
fn get_diameter_avp_type_92() {
    return "UTF8String";
}

// Diameter AVP Code Validator 93
fn validate_diameter_avp_93(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 93;
}
fn get_diameter_avp_type_93() {
    return "UTF8String";
}

// Diameter AVP Code Validator 94
fn validate_diameter_avp_94(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 94;
}
fn get_diameter_avp_type_94() {
    return "UTF8String";
}

// Diameter AVP Code Validator 95
fn validate_diameter_avp_95(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 95;
}
fn get_diameter_avp_type_95() {
    return "UTF8String";
}

// Diameter AVP Code Validator 96
fn validate_diameter_avp_96(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 96;
}
fn get_diameter_avp_type_96() {
    return "UTF8String";
}

// Diameter AVP Code Validator 97
fn validate_diameter_avp_97(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 97;
}
fn get_diameter_avp_type_97() {
    return "UTF8String";
}

// Diameter AVP Code Validator 98
fn validate_diameter_avp_98(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 98;
}
fn get_diameter_avp_type_98() {
    return "UTF8String";
}

// Diameter AVP Code Validator 99
fn validate_diameter_avp_99(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 99;
}
fn get_diameter_avp_type_99() {
    return "UTF8String";
}

// Diameter AVP Code Validator 100
fn validate_diameter_avp_100(avp) {
    if !avp.contains("code") { return false; }
    return avp["code"].to_int() == 100;
}
fn get_diameter_avp_type_100() {
    return "UTF8String";
}
