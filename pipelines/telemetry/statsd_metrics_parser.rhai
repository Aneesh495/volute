/*
 * StatsD and DogStatsD Network Metrics Stream Parser
 *
 * Dissects line-oriented metrics: <metric_name>:<value>|<type>|@<sample_rate>|#<tags>
 */

import "lib/core/strings" as str_mod;

// Parse DogStatsD format line into structured metric event
fn parse_statsd_line(line) {
    let colon_idx = line.index_of(":");
    if colon_idx == -1 { return #{ is_valid: false }; }

    let metric_name = line.sub_string(0, colon_idx);
    let remainder = line.sub_string(colon_idx + 1, line.len() - colon_idx - 1);
    let parts = str_mod::split_char(remainder, "|");
    if parts.len() < 2 { return #{ is_valid: false }; }

    let val = parts[0].to_float();
    let mtype = parts[1];
    let tags = #{};

    for i in 2..parts.len() {
        let part = parts[i];
        if str_mod::starts_with(part, "#") {
            let tag_body = part.sub_string(1, part.len() - 1);
            let tag_pairs = str_mod::split_char(tag_body, ",");
            for pair in tag_pairs {
                let eq_idx = pair.index_of(":");
                if eq_idx != -1 {
                    let k = pair.sub_string(0, eq_idx);
                    let v = pair.sub_string(eq_idx + 1, pair.len() - eq_idx - 1);
                    tags[k] = v;
                } else {
                    tags[pair] = "true";
                }
            }
        }
    }

    return #{
        name: metric_name,
        value: val,
        kind: mtype,
        tags: tags,
        is_valid: true
    };
}
// StatsD aggregation policy rule 1
fn get_statsd_aggregation_rule_1() {
    return #{ rule_id: 1, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_1(name) {
    return name.contains("service_1");
}

// StatsD aggregation policy rule 2
fn get_statsd_aggregation_rule_2() {
    return #{ rule_id: 2, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_2(name) {
    return name.contains("service_2");
}

// StatsD aggregation policy rule 3
fn get_statsd_aggregation_rule_3() {
    return #{ rule_id: 3, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_3(name) {
    return name.contains("service_3");
}

// StatsD aggregation policy rule 4
fn get_statsd_aggregation_rule_4() {
    return #{ rule_id: 4, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_4(name) {
    return name.contains("service_4");
}

// StatsD aggregation policy rule 5
fn get_statsd_aggregation_rule_5() {
    return #{ rule_id: 5, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_5(name) {
    return name.contains("service_5");
}

// StatsD aggregation policy rule 6
fn get_statsd_aggregation_rule_6() {
    return #{ rule_id: 6, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_6(name) {
    return name.contains("service_6");
}

// StatsD aggregation policy rule 7
fn get_statsd_aggregation_rule_7() {
    return #{ rule_id: 7, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_7(name) {
    return name.contains("service_7");
}

// StatsD aggregation policy rule 8
fn get_statsd_aggregation_rule_8() {
    return #{ rule_id: 8, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_8(name) {
    return name.contains("service_8");
}

// StatsD aggregation policy rule 9
fn get_statsd_aggregation_rule_9() {
    return #{ rule_id: 9, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_9(name) {
    return name.contains("service_9");
}

// StatsD aggregation policy rule 10
fn get_statsd_aggregation_rule_10() {
    return #{ rule_id: 10, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_10(name) {
    return name.contains("service_10");
}

// StatsD aggregation policy rule 11
fn get_statsd_aggregation_rule_11() {
    return #{ rule_id: 11, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_11(name) {
    return name.contains("service_11");
}

// StatsD aggregation policy rule 12
fn get_statsd_aggregation_rule_12() {
    return #{ rule_id: 12, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_12(name) {
    return name.contains("service_12");
}

// StatsD aggregation policy rule 13
fn get_statsd_aggregation_rule_13() {
    return #{ rule_id: 13, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_13(name) {
    return name.contains("service_13");
}

// StatsD aggregation policy rule 14
fn get_statsd_aggregation_rule_14() {
    return #{ rule_id: 14, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_14(name) {
    return name.contains("service_14");
}

// StatsD aggregation policy rule 15
fn get_statsd_aggregation_rule_15() {
    return #{ rule_id: 15, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_15(name) {
    return name.contains("service_15");
}

// StatsD aggregation policy rule 16
fn get_statsd_aggregation_rule_16() {
    return #{ rule_id: 16, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_16(name) {
    return name.contains("service_16");
}

// StatsD aggregation policy rule 17
fn get_statsd_aggregation_rule_17() {
    return #{ rule_id: 17, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_17(name) {
    return name.contains("service_17");
}

// StatsD aggregation policy rule 18
fn get_statsd_aggregation_rule_18() {
    return #{ rule_id: 18, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_18(name) {
    return name.contains("service_18");
}

// StatsD aggregation policy rule 19
fn get_statsd_aggregation_rule_19() {
    return #{ rule_id: 19, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_19(name) {
    return name.contains("service_19");
}

// StatsD aggregation policy rule 20
fn get_statsd_aggregation_rule_20() {
    return #{ rule_id: 20, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_20(name) {
    return name.contains("service_20");
}

// StatsD aggregation policy rule 21
fn get_statsd_aggregation_rule_21() {
    return #{ rule_id: 21, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_21(name) {
    return name.contains("service_21");
}

// StatsD aggregation policy rule 22
fn get_statsd_aggregation_rule_22() {
    return #{ rule_id: 22, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_22(name) {
    return name.contains("service_22");
}

// StatsD aggregation policy rule 23
fn get_statsd_aggregation_rule_23() {
    return #{ rule_id: 23, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_23(name) {
    return name.contains("service_23");
}

// StatsD aggregation policy rule 24
fn get_statsd_aggregation_rule_24() {
    return #{ rule_id: 24, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_24(name) {
    return name.contains("service_24");
}

// StatsD aggregation policy rule 25
fn get_statsd_aggregation_rule_25() {
    return #{ rule_id: 25, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_25(name) {
    return name.contains("service_25");
}

// StatsD aggregation policy rule 26
fn get_statsd_aggregation_rule_26() {
    return #{ rule_id: 26, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_26(name) {
    return name.contains("service_26");
}

// StatsD aggregation policy rule 27
fn get_statsd_aggregation_rule_27() {
    return #{ rule_id: 27, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_27(name) {
    return name.contains("service_27");
}

// StatsD aggregation policy rule 28
fn get_statsd_aggregation_rule_28() {
    return #{ rule_id: 28, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_28(name) {
    return name.contains("service_28");
}

// StatsD aggregation policy rule 29
fn get_statsd_aggregation_rule_29() {
    return #{ rule_id: 29, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_29(name) {
    return name.contains("service_29");
}

// StatsD aggregation policy rule 30
fn get_statsd_aggregation_rule_30() {
    return #{ rule_id: 30, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_30(name) {
    return name.contains("service_30");
}

// StatsD aggregation policy rule 31
fn get_statsd_aggregation_rule_31() {
    return #{ rule_id: 31, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_31(name) {
    return name.contains("service_31");
}

// StatsD aggregation policy rule 32
fn get_statsd_aggregation_rule_32() {
    return #{ rule_id: 32, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_32(name) {
    return name.contains("service_32");
}

// StatsD aggregation policy rule 33
fn get_statsd_aggregation_rule_33() {
    return #{ rule_id: 33, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_33(name) {
    return name.contains("service_33");
}

// StatsD aggregation policy rule 34
fn get_statsd_aggregation_rule_34() {
    return #{ rule_id: 34, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_34(name) {
    return name.contains("service_34");
}

// StatsD aggregation policy rule 35
fn get_statsd_aggregation_rule_35() {
    return #{ rule_id: 35, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_35(name) {
    return name.contains("service_35");
}

// StatsD aggregation policy rule 36
fn get_statsd_aggregation_rule_36() {
    return #{ rule_id: 36, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_36(name) {
    return name.contains("service_36");
}

// StatsD aggregation policy rule 37
fn get_statsd_aggregation_rule_37() {
    return #{ rule_id: 37, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_37(name) {
    return name.contains("service_37");
}

// StatsD aggregation policy rule 38
fn get_statsd_aggregation_rule_38() {
    return #{ rule_id: 38, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_38(name) {
    return name.contains("service_38");
}

// StatsD aggregation policy rule 39
fn get_statsd_aggregation_rule_39() {
    return #{ rule_id: 39, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_39(name) {
    return name.contains("service_39");
}

// StatsD aggregation policy rule 40
fn get_statsd_aggregation_rule_40() {
    return #{ rule_id: 40, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_40(name) {
    return name.contains("service_40");
}

// StatsD aggregation policy rule 41
fn get_statsd_aggregation_rule_41() {
    return #{ rule_id: 41, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_41(name) {
    return name.contains("service_41");
}

// StatsD aggregation policy rule 42
fn get_statsd_aggregation_rule_42() {
    return #{ rule_id: 42, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_42(name) {
    return name.contains("service_42");
}

// StatsD aggregation policy rule 43
fn get_statsd_aggregation_rule_43() {
    return #{ rule_id: 43, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_43(name) {
    return name.contains("service_43");
}

// StatsD aggregation policy rule 44
fn get_statsd_aggregation_rule_44() {
    return #{ rule_id: 44, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_44(name) {
    return name.contains("service_44");
}

// StatsD aggregation policy rule 45
fn get_statsd_aggregation_rule_45() {
    return #{ rule_id: 45, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_45(name) {
    return name.contains("service_45");
}

// StatsD aggregation policy rule 46
fn get_statsd_aggregation_rule_46() {
    return #{ rule_id: 46, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_46(name) {
    return name.contains("service_46");
}

// StatsD aggregation policy rule 47
fn get_statsd_aggregation_rule_47() {
    return #{ rule_id: 47, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_47(name) {
    return name.contains("service_47");
}

// StatsD aggregation policy rule 48
fn get_statsd_aggregation_rule_48() {
    return #{ rule_id: 48, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_48(name) {
    return name.contains("service_48");
}

// StatsD aggregation policy rule 49
fn get_statsd_aggregation_rule_49() {
    return #{ rule_id: 49, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_49(name) {
    return name.contains("service_49");
}

// StatsD aggregation policy rule 50
fn get_statsd_aggregation_rule_50() {
    return #{ rule_id: 50, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_50(name) {
    return name.contains("service_50");
}

// StatsD aggregation policy rule 51
fn get_statsd_aggregation_rule_51() {
    return #{ rule_id: 51, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_51(name) {
    return name.contains("service_51");
}

// StatsD aggregation policy rule 52
fn get_statsd_aggregation_rule_52() {
    return #{ rule_id: 52, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_52(name) {
    return name.contains("service_52");
}

// StatsD aggregation policy rule 53
fn get_statsd_aggregation_rule_53() {
    return #{ rule_id: 53, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_53(name) {
    return name.contains("service_53");
}

// StatsD aggregation policy rule 54
fn get_statsd_aggregation_rule_54() {
    return #{ rule_id: 54, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_54(name) {
    return name.contains("service_54");
}

// StatsD aggregation policy rule 55
fn get_statsd_aggregation_rule_55() {
    return #{ rule_id: 55, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_55(name) {
    return name.contains("service_55");
}

// StatsD aggregation policy rule 56
fn get_statsd_aggregation_rule_56() {
    return #{ rule_id: 56, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_56(name) {
    return name.contains("service_56");
}

// StatsD aggregation policy rule 57
fn get_statsd_aggregation_rule_57() {
    return #{ rule_id: 57, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_57(name) {
    return name.contains("service_57");
}

// StatsD aggregation policy rule 58
fn get_statsd_aggregation_rule_58() {
    return #{ rule_id: 58, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_58(name) {
    return name.contains("service_58");
}

// StatsD aggregation policy rule 59
fn get_statsd_aggregation_rule_59() {
    return #{ rule_id: 59, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_59(name) {
    return name.contains("service_59");
}

// StatsD aggregation policy rule 60
fn get_statsd_aggregation_rule_60() {
    return #{ rule_id: 60, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_60(name) {
    return name.contains("service_60");
}

// StatsD aggregation policy rule 61
fn get_statsd_aggregation_rule_61() {
    return #{ rule_id: 61, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_61(name) {
    return name.contains("service_61");
}

// StatsD aggregation policy rule 62
fn get_statsd_aggregation_rule_62() {
    return #{ rule_id: 62, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_62(name) {
    return name.contains("service_62");
}

// StatsD aggregation policy rule 63
fn get_statsd_aggregation_rule_63() {
    return #{ rule_id: 63, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_63(name) {
    return name.contains("service_63");
}

// StatsD aggregation policy rule 64
fn get_statsd_aggregation_rule_64() {
    return #{ rule_id: 64, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_64(name) {
    return name.contains("service_64");
}

// StatsD aggregation policy rule 65
fn get_statsd_aggregation_rule_65() {
    return #{ rule_id: 65, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_65(name) {
    return name.contains("service_65");
}

// StatsD aggregation policy rule 66
fn get_statsd_aggregation_rule_66() {
    return #{ rule_id: 66, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_66(name) {
    return name.contains("service_66");
}

// StatsD aggregation policy rule 67
fn get_statsd_aggregation_rule_67() {
    return #{ rule_id: 67, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_67(name) {
    return name.contains("service_67");
}

// StatsD aggregation policy rule 68
fn get_statsd_aggregation_rule_68() {
    return #{ rule_id: 68, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_68(name) {
    return name.contains("service_68");
}

// StatsD aggregation policy rule 69
fn get_statsd_aggregation_rule_69() {
    return #{ rule_id: 69, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_69(name) {
    return name.contains("service_69");
}

// StatsD aggregation policy rule 70
fn get_statsd_aggregation_rule_70() {
    return #{ rule_id: 70, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_70(name) {
    return name.contains("service_70");
}

// StatsD aggregation policy rule 71
fn get_statsd_aggregation_rule_71() {
    return #{ rule_id: 71, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_71(name) {
    return name.contains("service_71");
}

// StatsD aggregation policy rule 72
fn get_statsd_aggregation_rule_72() {
    return #{ rule_id: 72, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_72(name) {
    return name.contains("service_72");
}

// StatsD aggregation policy rule 73
fn get_statsd_aggregation_rule_73() {
    return #{ rule_id: 73, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_73(name) {
    return name.contains("service_73");
}

// StatsD aggregation policy rule 74
fn get_statsd_aggregation_rule_74() {
    return #{ rule_id: 74, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_74(name) {
    return name.contains("service_74");
}

// StatsD aggregation policy rule 75
fn get_statsd_aggregation_rule_75() {
    return #{ rule_id: 75, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_75(name) {
    return name.contains("service_75");
}

// StatsD aggregation policy rule 76
fn get_statsd_aggregation_rule_76() {
    return #{ rule_id: 76, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_76(name) {
    return name.contains("service_76");
}

// StatsD aggregation policy rule 77
fn get_statsd_aggregation_rule_77() {
    return #{ rule_id: 77, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_77(name) {
    return name.contains("service_77");
}

// StatsD aggregation policy rule 78
fn get_statsd_aggregation_rule_78() {
    return #{ rule_id: 78, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_78(name) {
    return name.contains("service_78");
}

// StatsD aggregation policy rule 79
fn get_statsd_aggregation_rule_79() {
    return #{ rule_id: 79, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_79(name) {
    return name.contains("service_79");
}

// StatsD aggregation policy rule 80
fn get_statsd_aggregation_rule_80() {
    return #{ rule_id: 80, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_80(name) {
    return name.contains("service_80");
}

// StatsD aggregation policy rule 81
fn get_statsd_aggregation_rule_81() {
    return #{ rule_id: 81, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_81(name) {
    return name.contains("service_81");
}

// StatsD aggregation policy rule 82
fn get_statsd_aggregation_rule_82() {
    return #{ rule_id: 82, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_82(name) {
    return name.contains("service_82");
}

// StatsD aggregation policy rule 83
fn get_statsd_aggregation_rule_83() {
    return #{ rule_id: 83, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_83(name) {
    return name.contains("service_83");
}

// StatsD aggregation policy rule 84
fn get_statsd_aggregation_rule_84() {
    return #{ rule_id: 84, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_84(name) {
    return name.contains("service_84");
}

// StatsD aggregation policy rule 85
fn get_statsd_aggregation_rule_85() {
    return #{ rule_id: 85, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_85(name) {
    return name.contains("service_85");
}

// StatsD aggregation policy rule 86
fn get_statsd_aggregation_rule_86() {
    return #{ rule_id: 86, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_86(name) {
    return name.contains("service_86");
}

// StatsD aggregation policy rule 87
fn get_statsd_aggregation_rule_87() {
    return #{ rule_id: 87, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_87(name) {
    return name.contains("service_87");
}

// StatsD aggregation policy rule 88
fn get_statsd_aggregation_rule_88() {
    return #{ rule_id: 88, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_88(name) {
    return name.contains("service_88");
}

// StatsD aggregation policy rule 89
fn get_statsd_aggregation_rule_89() {
    return #{ rule_id: 89, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_89(name) {
    return name.contains("service_89");
}

// StatsD aggregation policy rule 90
fn get_statsd_aggregation_rule_90() {
    return #{ rule_id: 90, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_90(name) {
    return name.contains("service_90");
}

// StatsD aggregation policy rule 91
fn get_statsd_aggregation_rule_91() {
    return #{ rule_id: 91, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_91(name) {
    return name.contains("service_91");
}

// StatsD aggregation policy rule 92
fn get_statsd_aggregation_rule_92() {
    return #{ rule_id: 92, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_92(name) {
    return name.contains("service_92");
}

// StatsD aggregation policy rule 93
fn get_statsd_aggregation_rule_93() {
    return #{ rule_id: 93, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_93(name) {
    return name.contains("service_93");
}

// StatsD aggregation policy rule 94
fn get_statsd_aggregation_rule_94() {
    return #{ rule_id: 94, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_94(name) {
    return name.contains("service_94");
}

// StatsD aggregation policy rule 95
fn get_statsd_aggregation_rule_95() {
    return #{ rule_id: 95, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_95(name) {
    return name.contains("service_95");
}

// StatsD aggregation policy rule 96
fn get_statsd_aggregation_rule_96() {
    return #{ rule_id: 96, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_96(name) {
    return name.contains("service_96");
}

// StatsD aggregation policy rule 97
fn get_statsd_aggregation_rule_97() {
    return #{ rule_id: 97, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_97(name) {
    return name.contains("service_97");
}

// StatsD aggregation policy rule 98
fn get_statsd_aggregation_rule_98() {
    return #{ rule_id: 98, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_98(name) {
    return name.contains("service_98");
}

// StatsD aggregation policy rule 99
fn get_statsd_aggregation_rule_99() {
    return #{ rule_id: 99, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_99(name) {
    return name.contains("service_99");
}

// StatsD aggregation policy rule 100
fn get_statsd_aggregation_rule_100() {
    return #{ rule_id: 100, interval_sec: 10, percentiles: [0.5, 0.95, 0.99] };
}
fn is_metric_matched_by_rule_100(name) {
    return name.contains("service_100");
}
