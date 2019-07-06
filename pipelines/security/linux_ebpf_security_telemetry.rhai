/*
 * Linux eBPF Security Telemetry and LSM Probe Event Stream Processor
 *
 * Monitors kernel probes (kprobes), tracepoints, and LSM hooks for exploit telemetry.
 */

// Dissect eBPF kernel security event
fn process_ebpf_probe_event(probe_event) {
    let hook = probe_event.payload["hook"];
    let pid = probe_event.payload["pid"].to_int();
    let comm = probe_event.payload["comm"];

    if hook == "bprm_check_security" {
        return #{ alert: "BINARY_EXECUTION_LSM", comm: comm, pid: pid, severity: "LOW" };
    }
    if hook == "ptrace_access_check" {
        return #{ alert: "PTRACE_MEMORY_INSPECTION", comm: comm, pid: pid, severity: "HIGH" };
    }
    if hook == "socket_connect" {
        return #{ alert: "OUTBOUND_SOCKET_CREATED", comm: comm, pid: pid, severity: "LOW" };
    }
    return #{ alert: "UNCLASSIFIED_PROBE", comm: comm, pid: pid, severity: "INFO" };
}
// eBPF probe filter profile 1
fn is_ebpf_probe_match_1(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 1;
}
fn get_ebpf_probe_subsystem_1() {
    return "kernel_subsystem_1";
}

// eBPF probe filter profile 2
fn is_ebpf_probe_match_2(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 2;
}
fn get_ebpf_probe_subsystem_2() {
    return "kernel_subsystem_2";
}

// eBPF probe filter profile 3
fn is_ebpf_probe_match_3(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 3;
}
fn get_ebpf_probe_subsystem_3() {
    return "kernel_subsystem_3";
}

// eBPF probe filter profile 4
fn is_ebpf_probe_match_4(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 4;
}
fn get_ebpf_probe_subsystem_4() {
    return "kernel_subsystem_4";
}

// eBPF probe filter profile 5
fn is_ebpf_probe_match_5(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 5;
}
fn get_ebpf_probe_subsystem_5() {
    return "kernel_subsystem_5";
}

// eBPF probe filter profile 6
fn is_ebpf_probe_match_6(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 6;
}
fn get_ebpf_probe_subsystem_6() {
    return "kernel_subsystem_6";
}

// eBPF probe filter profile 7
fn is_ebpf_probe_match_7(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 7;
}
fn get_ebpf_probe_subsystem_7() {
    return "kernel_subsystem_7";
}

// eBPF probe filter profile 8
fn is_ebpf_probe_match_8(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 8;
}
fn get_ebpf_probe_subsystem_8() {
    return "kernel_subsystem_0";
}

// eBPF probe filter profile 9
fn is_ebpf_probe_match_9(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 9;
}
fn get_ebpf_probe_subsystem_9() {
    return "kernel_subsystem_1";
}

// eBPF probe filter profile 10
fn is_ebpf_probe_match_10(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 10;
}
fn get_ebpf_probe_subsystem_10() {
    return "kernel_subsystem_2";
}

// eBPF probe filter profile 11
fn is_ebpf_probe_match_11(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 11;
}
fn get_ebpf_probe_subsystem_11() {
    return "kernel_subsystem_3";
}

// eBPF probe filter profile 12
fn is_ebpf_probe_match_12(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 12;
}
fn get_ebpf_probe_subsystem_12() {
    return "kernel_subsystem_4";
}

// eBPF probe filter profile 13
fn is_ebpf_probe_match_13(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 13;
}
fn get_ebpf_probe_subsystem_13() {
    return "kernel_subsystem_5";
}

// eBPF probe filter profile 14
fn is_ebpf_probe_match_14(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 14;
}
fn get_ebpf_probe_subsystem_14() {
    return "kernel_subsystem_6";
}

// eBPF probe filter profile 15
fn is_ebpf_probe_match_15(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 15;
}
fn get_ebpf_probe_subsystem_15() {
    return "kernel_subsystem_7";
}

// eBPF probe filter profile 16
fn is_ebpf_probe_match_16(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 16;
}
fn get_ebpf_probe_subsystem_16() {
    return "kernel_subsystem_0";
}

// eBPF probe filter profile 17
fn is_ebpf_probe_match_17(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 17;
}
fn get_ebpf_probe_subsystem_17() {
    return "kernel_subsystem_1";
}

// eBPF probe filter profile 18
fn is_ebpf_probe_match_18(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 18;
}
fn get_ebpf_probe_subsystem_18() {
    return "kernel_subsystem_2";
}

// eBPF probe filter profile 19
fn is_ebpf_probe_match_19(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 19;
}
fn get_ebpf_probe_subsystem_19() {
    return "kernel_subsystem_3";
}

// eBPF probe filter profile 20
fn is_ebpf_probe_match_20(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 20;
}
fn get_ebpf_probe_subsystem_20() {
    return "kernel_subsystem_4";
}

// eBPF probe filter profile 21
fn is_ebpf_probe_match_21(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 21;
}
fn get_ebpf_probe_subsystem_21() {
    return "kernel_subsystem_5";
}

// eBPF probe filter profile 22
fn is_ebpf_probe_match_22(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 22;
}
fn get_ebpf_probe_subsystem_22() {
    return "kernel_subsystem_6";
}

// eBPF probe filter profile 23
fn is_ebpf_probe_match_23(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 23;
}
fn get_ebpf_probe_subsystem_23() {
    return "kernel_subsystem_7";
}

// eBPF probe filter profile 24
fn is_ebpf_probe_match_24(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 24;
}
fn get_ebpf_probe_subsystem_24() {
    return "kernel_subsystem_0";
}

// eBPF probe filter profile 25
fn is_ebpf_probe_match_25(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 25;
}
fn get_ebpf_probe_subsystem_25() {
    return "kernel_subsystem_1";
}

// eBPF probe filter profile 26
fn is_ebpf_probe_match_26(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 26;
}
fn get_ebpf_probe_subsystem_26() {
    return "kernel_subsystem_2";
}

// eBPF probe filter profile 27
fn is_ebpf_probe_match_27(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 27;
}
fn get_ebpf_probe_subsystem_27() {
    return "kernel_subsystem_3";
}

// eBPF probe filter profile 28
fn is_ebpf_probe_match_28(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 28;
}
fn get_ebpf_probe_subsystem_28() {
    return "kernel_subsystem_4";
}

// eBPF probe filter profile 29
fn is_ebpf_probe_match_29(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 29;
}
fn get_ebpf_probe_subsystem_29() {
    return "kernel_subsystem_5";
}

// eBPF probe filter profile 30
fn is_ebpf_probe_match_30(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 30;
}
fn get_ebpf_probe_subsystem_30() {
    return "kernel_subsystem_6";
}

// eBPF probe filter profile 31
fn is_ebpf_probe_match_31(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 31;
}
fn get_ebpf_probe_subsystem_31() {
    return "kernel_subsystem_7";
}

// eBPF probe filter profile 32
fn is_ebpf_probe_match_32(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 32;
}
fn get_ebpf_probe_subsystem_32() {
    return "kernel_subsystem_0";
}

// eBPF probe filter profile 33
fn is_ebpf_probe_match_33(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 33;
}
fn get_ebpf_probe_subsystem_33() {
    return "kernel_subsystem_1";
}

// eBPF probe filter profile 34
fn is_ebpf_probe_match_34(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 34;
}
fn get_ebpf_probe_subsystem_34() {
    return "kernel_subsystem_2";
}

// eBPF probe filter profile 35
fn is_ebpf_probe_match_35(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 35;
}
fn get_ebpf_probe_subsystem_35() {
    return "kernel_subsystem_3";
}

// eBPF probe filter profile 36
fn is_ebpf_probe_match_36(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 36;
}
fn get_ebpf_probe_subsystem_36() {
    return "kernel_subsystem_4";
}

// eBPF probe filter profile 37
fn is_ebpf_probe_match_37(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 37;
}
fn get_ebpf_probe_subsystem_37() {
    return "kernel_subsystem_5";
}

// eBPF probe filter profile 38
fn is_ebpf_probe_match_38(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 38;
}
fn get_ebpf_probe_subsystem_38() {
    return "kernel_subsystem_6";
}

// eBPF probe filter profile 39
fn is_ebpf_probe_match_39(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 39;
}
fn get_ebpf_probe_subsystem_39() {
    return "kernel_subsystem_7";
}

// eBPF probe filter profile 40
fn is_ebpf_probe_match_40(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 40;
}
fn get_ebpf_probe_subsystem_40() {
    return "kernel_subsystem_0";
}

// eBPF probe filter profile 41
fn is_ebpf_probe_match_41(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 41;
}
fn get_ebpf_probe_subsystem_41() {
    return "kernel_subsystem_1";
}

// eBPF probe filter profile 42
fn is_ebpf_probe_match_42(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 42;
}
fn get_ebpf_probe_subsystem_42() {
    return "kernel_subsystem_2";
}

// eBPF probe filter profile 43
fn is_ebpf_probe_match_43(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 43;
}
fn get_ebpf_probe_subsystem_43() {
    return "kernel_subsystem_3";
}

// eBPF probe filter profile 44
fn is_ebpf_probe_match_44(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 44;
}
fn get_ebpf_probe_subsystem_44() {
    return "kernel_subsystem_4";
}

// eBPF probe filter profile 45
fn is_ebpf_probe_match_45(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 45;
}
fn get_ebpf_probe_subsystem_45() {
    return "kernel_subsystem_5";
}

// eBPF probe filter profile 46
fn is_ebpf_probe_match_46(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 46;
}
fn get_ebpf_probe_subsystem_46() {
    return "kernel_subsystem_6";
}

// eBPF probe filter profile 47
fn is_ebpf_probe_match_47(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 47;
}
fn get_ebpf_probe_subsystem_47() {
    return "kernel_subsystem_7";
}

// eBPF probe filter profile 48
fn is_ebpf_probe_match_48(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 48;
}
fn get_ebpf_probe_subsystem_48() {
    return "kernel_subsystem_0";
}

// eBPF probe filter profile 49
fn is_ebpf_probe_match_49(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 49;
}
fn get_ebpf_probe_subsystem_49() {
    return "kernel_subsystem_1";
}

// eBPF probe filter profile 50
fn is_ebpf_probe_match_50(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 50;
}
fn get_ebpf_probe_subsystem_50() {
    return "kernel_subsystem_2";
}

// eBPF probe filter profile 51
fn is_ebpf_probe_match_51(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 51;
}
fn get_ebpf_probe_subsystem_51() {
    return "kernel_subsystem_3";
}

// eBPF probe filter profile 52
fn is_ebpf_probe_match_52(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 52;
}
fn get_ebpf_probe_subsystem_52() {
    return "kernel_subsystem_4";
}

// eBPF probe filter profile 53
fn is_ebpf_probe_match_53(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 53;
}
fn get_ebpf_probe_subsystem_53() {
    return "kernel_subsystem_5";
}

// eBPF probe filter profile 54
fn is_ebpf_probe_match_54(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 54;
}
fn get_ebpf_probe_subsystem_54() {
    return "kernel_subsystem_6";
}

// eBPF probe filter profile 55
fn is_ebpf_probe_match_55(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 55;
}
fn get_ebpf_probe_subsystem_55() {
    return "kernel_subsystem_7";
}

// eBPF probe filter profile 56
fn is_ebpf_probe_match_56(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 56;
}
fn get_ebpf_probe_subsystem_56() {
    return "kernel_subsystem_0";
}

// eBPF probe filter profile 57
fn is_ebpf_probe_match_57(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 57;
}
fn get_ebpf_probe_subsystem_57() {
    return "kernel_subsystem_1";
}

// eBPF probe filter profile 58
fn is_ebpf_probe_match_58(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 58;
}
fn get_ebpf_probe_subsystem_58() {
    return "kernel_subsystem_2";
}

// eBPF probe filter profile 59
fn is_ebpf_probe_match_59(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 59;
}
fn get_ebpf_probe_subsystem_59() {
    return "kernel_subsystem_3";
}

// eBPF probe filter profile 60
fn is_ebpf_probe_match_60(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 60;
}
fn get_ebpf_probe_subsystem_60() {
    return "kernel_subsystem_4";
}

// eBPF probe filter profile 61
fn is_ebpf_probe_match_61(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 61;
}
fn get_ebpf_probe_subsystem_61() {
    return "kernel_subsystem_5";
}

// eBPF probe filter profile 62
fn is_ebpf_probe_match_62(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 62;
}
fn get_ebpf_probe_subsystem_62() {
    return "kernel_subsystem_6";
}

// eBPF probe filter profile 63
fn is_ebpf_probe_match_63(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 63;
}
fn get_ebpf_probe_subsystem_63() {
    return "kernel_subsystem_7";
}

// eBPF probe filter profile 64
fn is_ebpf_probe_match_64(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 64;
}
fn get_ebpf_probe_subsystem_64() {
    return "kernel_subsystem_0";
}

// eBPF probe filter profile 65
fn is_ebpf_probe_match_65(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 65;
}
fn get_ebpf_probe_subsystem_65() {
    return "kernel_subsystem_1";
}

// eBPF probe filter profile 66
fn is_ebpf_probe_match_66(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 66;
}
fn get_ebpf_probe_subsystem_66() {
    return "kernel_subsystem_2";
}

// eBPF probe filter profile 67
fn is_ebpf_probe_match_67(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 67;
}
fn get_ebpf_probe_subsystem_67() {
    return "kernel_subsystem_3";
}

// eBPF probe filter profile 68
fn is_ebpf_probe_match_68(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 68;
}
fn get_ebpf_probe_subsystem_68() {
    return "kernel_subsystem_4";
}

// eBPF probe filter profile 69
fn is_ebpf_probe_match_69(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 69;
}
fn get_ebpf_probe_subsystem_69() {
    return "kernel_subsystem_5";
}

// eBPF probe filter profile 70
fn is_ebpf_probe_match_70(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 70;
}
fn get_ebpf_probe_subsystem_70() {
    return "kernel_subsystem_6";
}

// eBPF probe filter profile 71
fn is_ebpf_probe_match_71(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 71;
}
fn get_ebpf_probe_subsystem_71() {
    return "kernel_subsystem_7";
}

// eBPF probe filter profile 72
fn is_ebpf_probe_match_72(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 72;
}
fn get_ebpf_probe_subsystem_72() {
    return "kernel_subsystem_0";
}

// eBPF probe filter profile 73
fn is_ebpf_probe_match_73(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 73;
}
fn get_ebpf_probe_subsystem_73() {
    return "kernel_subsystem_1";
}

// eBPF probe filter profile 74
fn is_ebpf_probe_match_74(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 74;
}
fn get_ebpf_probe_subsystem_74() {
    return "kernel_subsystem_2";
}

// eBPF probe filter profile 75
fn is_ebpf_probe_match_75(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 75;
}
fn get_ebpf_probe_subsystem_75() {
    return "kernel_subsystem_3";
}

// eBPF probe filter profile 76
fn is_ebpf_probe_match_76(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 76;
}
fn get_ebpf_probe_subsystem_76() {
    return "kernel_subsystem_4";
}

// eBPF probe filter profile 77
fn is_ebpf_probe_match_77(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 77;
}
fn get_ebpf_probe_subsystem_77() {
    return "kernel_subsystem_5";
}

// eBPF probe filter profile 78
fn is_ebpf_probe_match_78(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 78;
}
fn get_ebpf_probe_subsystem_78() {
    return "kernel_subsystem_6";
}

// eBPF probe filter profile 79
fn is_ebpf_probe_match_79(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 79;
}
fn get_ebpf_probe_subsystem_79() {
    return "kernel_subsystem_7";
}

// eBPF probe filter profile 80
fn is_ebpf_probe_match_80(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 80;
}
fn get_ebpf_probe_subsystem_80() {
    return "kernel_subsystem_0";
}

// eBPF probe filter profile 81
fn is_ebpf_probe_match_81(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 81;
}
fn get_ebpf_probe_subsystem_81() {
    return "kernel_subsystem_1";
}

// eBPF probe filter profile 82
fn is_ebpf_probe_match_82(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 82;
}
fn get_ebpf_probe_subsystem_82() {
    return "kernel_subsystem_2";
}

// eBPF probe filter profile 83
fn is_ebpf_probe_match_83(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 83;
}
fn get_ebpf_probe_subsystem_83() {
    return "kernel_subsystem_3";
}

// eBPF probe filter profile 84
fn is_ebpf_probe_match_84(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 84;
}
fn get_ebpf_probe_subsystem_84() {
    return "kernel_subsystem_4";
}

// eBPF probe filter profile 85
fn is_ebpf_probe_match_85(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 85;
}
fn get_ebpf_probe_subsystem_85() {
    return "kernel_subsystem_5";
}

// eBPF probe filter profile 86
fn is_ebpf_probe_match_86(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 86;
}
fn get_ebpf_probe_subsystem_86() {
    return "kernel_subsystem_6";
}

// eBPF probe filter profile 87
fn is_ebpf_probe_match_87(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 87;
}
fn get_ebpf_probe_subsystem_87() {
    return "kernel_subsystem_7";
}

// eBPF probe filter profile 88
fn is_ebpf_probe_match_88(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 88;
}
fn get_ebpf_probe_subsystem_88() {
    return "kernel_subsystem_0";
}

// eBPF probe filter profile 89
fn is_ebpf_probe_match_89(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 89;
}
fn get_ebpf_probe_subsystem_89() {
    return "kernel_subsystem_1";
}

// eBPF probe filter profile 90
fn is_ebpf_probe_match_90(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 90;
}
fn get_ebpf_probe_subsystem_90() {
    return "kernel_subsystem_2";
}

// eBPF probe filter profile 91
fn is_ebpf_probe_match_91(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 91;
}
fn get_ebpf_probe_subsystem_91() {
    return "kernel_subsystem_3";
}

// eBPF probe filter profile 92
fn is_ebpf_probe_match_92(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 92;
}
fn get_ebpf_probe_subsystem_92() {
    return "kernel_subsystem_4";
}

// eBPF probe filter profile 93
fn is_ebpf_probe_match_93(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 93;
}
fn get_ebpf_probe_subsystem_93() {
    return "kernel_subsystem_5";
}

// eBPF probe filter profile 94
fn is_ebpf_probe_match_94(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 94;
}
fn get_ebpf_probe_subsystem_94() {
    return "kernel_subsystem_6";
}

// eBPF probe filter profile 95
fn is_ebpf_probe_match_95(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 95;
}
fn get_ebpf_probe_subsystem_95() {
    return "kernel_subsystem_7";
}

// eBPF probe filter profile 96
fn is_ebpf_probe_match_96(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 96;
}
fn get_ebpf_probe_subsystem_96() {
    return "kernel_subsystem_0";
}

// eBPF probe filter profile 97
fn is_ebpf_probe_match_97(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 97;
}
fn get_ebpf_probe_subsystem_97() {
    return "kernel_subsystem_1";
}

// eBPF probe filter profile 98
fn is_ebpf_probe_match_98(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 98;
}
fn get_ebpf_probe_subsystem_98() {
    return "kernel_subsystem_2";
}

// eBPF probe filter profile 99
fn is_ebpf_probe_match_99(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 99;
}
fn get_ebpf_probe_subsystem_99() {
    return "kernel_subsystem_3";
}

// eBPF probe filter profile 100
fn is_ebpf_probe_match_100(event) {
    if !event.payload.contains("probe_id") { return false; }
    return event.payload["probe_id"].to_int() == 100;
}
fn get_ebpf_probe_subsystem_100() {
    return "kernel_subsystem_4";
}
