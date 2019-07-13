/*
 * Cloud IAM Least Privilege and Over-Permissioning Analyzer
 *
 * Analyzes policy statements for wildcard actions, admin escalation, and trust boundaries.
 */

// Analyze IAM Policy document for over-privileged statements
fn analyze_iam_policy_document(policy_doc) {
    let findings = [];
    if !policy_doc.contains("Statement") { return findings; }

    for stmt in policy_doc["Statement"] {
        if stmt["Effect"] == "Allow" {
            if stmt.contains("Action") {
                let act = stmt["Action"].to_string();
                if act == "*" {
                    findings.push(#{ check: "FULL_WILDCARD_ACTION", severity: "CRITICAL" });
                } else if act.contains(":*") {
                    findings.push(#{ check: "SERVICE_WILDCARD_ACTION", severity: "HIGH", action: act });
                }
            }
            if stmt.contains("Resource") && stmt["Resource"].to_string() == "*" {
                findings.push(#{ check: "WILDCARD_RESOURCE_ALLOW", severity: "HIGH" });
            }
        }
    }
    return findings;
}
// Cloud IAM compliance check rule 1
fn check_iam_compliance_rule_1(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 1;
}
fn get_iam_rule_threshold_1() {
    return 10;
}

// Cloud IAM compliance check rule 2
fn check_iam_compliance_rule_2(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 2;
}
fn get_iam_rule_threshold_2() {
    return 20;
}

// Cloud IAM compliance check rule 3
fn check_iam_compliance_rule_3(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 3;
}
fn get_iam_rule_threshold_3() {
    return 30;
}

// Cloud IAM compliance check rule 4
fn check_iam_compliance_rule_4(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 4;
}
fn get_iam_rule_threshold_4() {
    return 40;
}

// Cloud IAM compliance check rule 5
fn check_iam_compliance_rule_5(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 5;
}
fn get_iam_rule_threshold_5() {
    return 50;
}

// Cloud IAM compliance check rule 6
fn check_iam_compliance_rule_6(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 6;
}
fn get_iam_rule_threshold_6() {
    return 60;
}

// Cloud IAM compliance check rule 7
fn check_iam_compliance_rule_7(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 7;
}
fn get_iam_rule_threshold_7() {
    return 70;
}

// Cloud IAM compliance check rule 8
fn check_iam_compliance_rule_8(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 8;
}
fn get_iam_rule_threshold_8() {
    return 80;
}

// Cloud IAM compliance check rule 9
fn check_iam_compliance_rule_9(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 9;
}
fn get_iam_rule_threshold_9() {
    return 90;
}

// Cloud IAM compliance check rule 10
fn check_iam_compliance_rule_10(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 10;
}
fn get_iam_rule_threshold_10() {
    return 100;
}

// Cloud IAM compliance check rule 11
fn check_iam_compliance_rule_11(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 11;
}
fn get_iam_rule_threshold_11() {
    return 110;
}

// Cloud IAM compliance check rule 12
fn check_iam_compliance_rule_12(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 12;
}
fn get_iam_rule_threshold_12() {
    return 120;
}

// Cloud IAM compliance check rule 13
fn check_iam_compliance_rule_13(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 13;
}
fn get_iam_rule_threshold_13() {
    return 130;
}

// Cloud IAM compliance check rule 14
fn check_iam_compliance_rule_14(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 14;
}
fn get_iam_rule_threshold_14() {
    return 140;
}

// Cloud IAM compliance check rule 15
fn check_iam_compliance_rule_15(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 15;
}
fn get_iam_rule_threshold_15() {
    return 150;
}

// Cloud IAM compliance check rule 16
fn check_iam_compliance_rule_16(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 16;
}
fn get_iam_rule_threshold_16() {
    return 160;
}

// Cloud IAM compliance check rule 17
fn check_iam_compliance_rule_17(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 17;
}
fn get_iam_rule_threshold_17() {
    return 170;
}

// Cloud IAM compliance check rule 18
fn check_iam_compliance_rule_18(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 18;
}
fn get_iam_rule_threshold_18() {
    return 180;
}

// Cloud IAM compliance check rule 19
fn check_iam_compliance_rule_19(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 19;
}
fn get_iam_rule_threshold_19() {
    return 190;
}

// Cloud IAM compliance check rule 20
fn check_iam_compliance_rule_20(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 20;
}
fn get_iam_rule_threshold_20() {
    return 200;
}

// Cloud IAM compliance check rule 21
fn check_iam_compliance_rule_21(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 21;
}
fn get_iam_rule_threshold_21() {
    return 210;
}

// Cloud IAM compliance check rule 22
fn check_iam_compliance_rule_22(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 22;
}
fn get_iam_rule_threshold_22() {
    return 220;
}

// Cloud IAM compliance check rule 23
fn check_iam_compliance_rule_23(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 23;
}
fn get_iam_rule_threshold_23() {
    return 230;
}

// Cloud IAM compliance check rule 24
fn check_iam_compliance_rule_24(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 24;
}
fn get_iam_rule_threshold_24() {
    return 240;
}

// Cloud IAM compliance check rule 25
fn check_iam_compliance_rule_25(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 25;
}
fn get_iam_rule_threshold_25() {
    return 250;
}

// Cloud IAM compliance check rule 26
fn check_iam_compliance_rule_26(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 26;
}
fn get_iam_rule_threshold_26() {
    return 260;
}

// Cloud IAM compliance check rule 27
fn check_iam_compliance_rule_27(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 27;
}
fn get_iam_rule_threshold_27() {
    return 270;
}

// Cloud IAM compliance check rule 28
fn check_iam_compliance_rule_28(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 28;
}
fn get_iam_rule_threshold_28() {
    return 280;
}

// Cloud IAM compliance check rule 29
fn check_iam_compliance_rule_29(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 29;
}
fn get_iam_rule_threshold_29() {
    return 290;
}

// Cloud IAM compliance check rule 30
fn check_iam_compliance_rule_30(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 30;
}
fn get_iam_rule_threshold_30() {
    return 300;
}

// Cloud IAM compliance check rule 31
fn check_iam_compliance_rule_31(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 31;
}
fn get_iam_rule_threshold_31() {
    return 310;
}

// Cloud IAM compliance check rule 32
fn check_iam_compliance_rule_32(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 32;
}
fn get_iam_rule_threshold_32() {
    return 320;
}

// Cloud IAM compliance check rule 33
fn check_iam_compliance_rule_33(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 33;
}
fn get_iam_rule_threshold_33() {
    return 330;
}

// Cloud IAM compliance check rule 34
fn check_iam_compliance_rule_34(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 34;
}
fn get_iam_rule_threshold_34() {
    return 340;
}

// Cloud IAM compliance check rule 35
fn check_iam_compliance_rule_35(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 35;
}
fn get_iam_rule_threshold_35() {
    return 350;
}

// Cloud IAM compliance check rule 36
fn check_iam_compliance_rule_36(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 36;
}
fn get_iam_rule_threshold_36() {
    return 360;
}

// Cloud IAM compliance check rule 37
fn check_iam_compliance_rule_37(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 37;
}
fn get_iam_rule_threshold_37() {
    return 370;
}

// Cloud IAM compliance check rule 38
fn check_iam_compliance_rule_38(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 38;
}
fn get_iam_rule_threshold_38() {
    return 380;
}

// Cloud IAM compliance check rule 39
fn check_iam_compliance_rule_39(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 39;
}
fn get_iam_rule_threshold_39() {
    return 390;
}

// Cloud IAM compliance check rule 40
fn check_iam_compliance_rule_40(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 40;
}
fn get_iam_rule_threshold_40() {
    return 400;
}

// Cloud IAM compliance check rule 41
fn check_iam_compliance_rule_41(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 41;
}
fn get_iam_rule_threshold_41() {
    return 410;
}

// Cloud IAM compliance check rule 42
fn check_iam_compliance_rule_42(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 42;
}
fn get_iam_rule_threshold_42() {
    return 420;
}

// Cloud IAM compliance check rule 43
fn check_iam_compliance_rule_43(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 43;
}
fn get_iam_rule_threshold_43() {
    return 430;
}

// Cloud IAM compliance check rule 44
fn check_iam_compliance_rule_44(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 44;
}
fn get_iam_rule_threshold_44() {
    return 440;
}

// Cloud IAM compliance check rule 45
fn check_iam_compliance_rule_45(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 45;
}
fn get_iam_rule_threshold_45() {
    return 450;
}

// Cloud IAM compliance check rule 46
fn check_iam_compliance_rule_46(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 46;
}
fn get_iam_rule_threshold_46() {
    return 460;
}

// Cloud IAM compliance check rule 47
fn check_iam_compliance_rule_47(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 47;
}
fn get_iam_rule_threshold_47() {
    return 470;
}

// Cloud IAM compliance check rule 48
fn check_iam_compliance_rule_48(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 48;
}
fn get_iam_rule_threshold_48() {
    return 480;
}

// Cloud IAM compliance check rule 49
fn check_iam_compliance_rule_49(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 49;
}
fn get_iam_rule_threshold_49() {
    return 490;
}

// Cloud IAM compliance check rule 50
fn check_iam_compliance_rule_50(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 50;
}
fn get_iam_rule_threshold_50() {
    return 500;
}

// Cloud IAM compliance check rule 51
fn check_iam_compliance_rule_51(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 51;
}
fn get_iam_rule_threshold_51() {
    return 510;
}

// Cloud IAM compliance check rule 52
fn check_iam_compliance_rule_52(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 52;
}
fn get_iam_rule_threshold_52() {
    return 520;
}

// Cloud IAM compliance check rule 53
fn check_iam_compliance_rule_53(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 53;
}
fn get_iam_rule_threshold_53() {
    return 530;
}

// Cloud IAM compliance check rule 54
fn check_iam_compliance_rule_54(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 54;
}
fn get_iam_rule_threshold_54() {
    return 540;
}

// Cloud IAM compliance check rule 55
fn check_iam_compliance_rule_55(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 55;
}
fn get_iam_rule_threshold_55() {
    return 550;
}

// Cloud IAM compliance check rule 56
fn check_iam_compliance_rule_56(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 56;
}
fn get_iam_rule_threshold_56() {
    return 560;
}

// Cloud IAM compliance check rule 57
fn check_iam_compliance_rule_57(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 57;
}
fn get_iam_rule_threshold_57() {
    return 570;
}

// Cloud IAM compliance check rule 58
fn check_iam_compliance_rule_58(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 58;
}
fn get_iam_rule_threshold_58() {
    return 580;
}

// Cloud IAM compliance check rule 59
fn check_iam_compliance_rule_59(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 59;
}
fn get_iam_rule_threshold_59() {
    return 590;
}

// Cloud IAM compliance check rule 60
fn check_iam_compliance_rule_60(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 60;
}
fn get_iam_rule_threshold_60() {
    return 600;
}

// Cloud IAM compliance check rule 61
fn check_iam_compliance_rule_61(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 61;
}
fn get_iam_rule_threshold_61() {
    return 610;
}

// Cloud IAM compliance check rule 62
fn check_iam_compliance_rule_62(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 62;
}
fn get_iam_rule_threshold_62() {
    return 620;
}

// Cloud IAM compliance check rule 63
fn check_iam_compliance_rule_63(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 63;
}
fn get_iam_rule_threshold_63() {
    return 630;
}

// Cloud IAM compliance check rule 64
fn check_iam_compliance_rule_64(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 64;
}
fn get_iam_rule_threshold_64() {
    return 640;
}

// Cloud IAM compliance check rule 65
fn check_iam_compliance_rule_65(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 65;
}
fn get_iam_rule_threshold_65() {
    return 650;
}

// Cloud IAM compliance check rule 66
fn check_iam_compliance_rule_66(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 66;
}
fn get_iam_rule_threshold_66() {
    return 660;
}

// Cloud IAM compliance check rule 67
fn check_iam_compliance_rule_67(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 67;
}
fn get_iam_rule_threshold_67() {
    return 670;
}

// Cloud IAM compliance check rule 68
fn check_iam_compliance_rule_68(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 68;
}
fn get_iam_rule_threshold_68() {
    return 680;
}

// Cloud IAM compliance check rule 69
fn check_iam_compliance_rule_69(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 69;
}
fn get_iam_rule_threshold_69() {
    return 690;
}

// Cloud IAM compliance check rule 70
fn check_iam_compliance_rule_70(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 70;
}
fn get_iam_rule_threshold_70() {
    return 700;
}

// Cloud IAM compliance check rule 71
fn check_iam_compliance_rule_71(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 71;
}
fn get_iam_rule_threshold_71() {
    return 710;
}

// Cloud IAM compliance check rule 72
fn check_iam_compliance_rule_72(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 72;
}
fn get_iam_rule_threshold_72() {
    return 720;
}

// Cloud IAM compliance check rule 73
fn check_iam_compliance_rule_73(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 73;
}
fn get_iam_rule_threshold_73() {
    return 730;
}

// Cloud IAM compliance check rule 74
fn check_iam_compliance_rule_74(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 74;
}
fn get_iam_rule_threshold_74() {
    return 740;
}

// Cloud IAM compliance check rule 75
fn check_iam_compliance_rule_75(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 75;
}
fn get_iam_rule_threshold_75() {
    return 750;
}

// Cloud IAM compliance check rule 76
fn check_iam_compliance_rule_76(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 76;
}
fn get_iam_rule_threshold_76() {
    return 760;
}

// Cloud IAM compliance check rule 77
fn check_iam_compliance_rule_77(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 77;
}
fn get_iam_rule_threshold_77() {
    return 770;
}

// Cloud IAM compliance check rule 78
fn check_iam_compliance_rule_78(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 78;
}
fn get_iam_rule_threshold_78() {
    return 780;
}

// Cloud IAM compliance check rule 79
fn check_iam_compliance_rule_79(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 79;
}
fn get_iam_rule_threshold_79() {
    return 790;
}

// Cloud IAM compliance check rule 80
fn check_iam_compliance_rule_80(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 80;
}
fn get_iam_rule_threshold_80() {
    return 800;
}

// Cloud IAM compliance check rule 81
fn check_iam_compliance_rule_81(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 81;
}
fn get_iam_rule_threshold_81() {
    return 810;
}

// Cloud IAM compliance check rule 82
fn check_iam_compliance_rule_82(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 82;
}
fn get_iam_rule_threshold_82() {
    return 820;
}

// Cloud IAM compliance check rule 83
fn check_iam_compliance_rule_83(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 83;
}
fn get_iam_rule_threshold_83() {
    return 830;
}

// Cloud IAM compliance check rule 84
fn check_iam_compliance_rule_84(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 84;
}
fn get_iam_rule_threshold_84() {
    return 840;
}

// Cloud IAM compliance check rule 85
fn check_iam_compliance_rule_85(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 85;
}
fn get_iam_rule_threshold_85() {
    return 850;
}

// Cloud IAM compliance check rule 86
fn check_iam_compliance_rule_86(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 86;
}
fn get_iam_rule_threshold_86() {
    return 860;
}

// Cloud IAM compliance check rule 87
fn check_iam_compliance_rule_87(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 87;
}
fn get_iam_rule_threshold_87() {
    return 870;
}

// Cloud IAM compliance check rule 88
fn check_iam_compliance_rule_88(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 88;
}
fn get_iam_rule_threshold_88() {
    return 880;
}

// Cloud IAM compliance check rule 89
fn check_iam_compliance_rule_89(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 89;
}
fn get_iam_rule_threshold_89() {
    return 890;
}

// Cloud IAM compliance check rule 90
fn check_iam_compliance_rule_90(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 90;
}
fn get_iam_rule_threshold_90() {
    return 900;
}

// Cloud IAM compliance check rule 91
fn check_iam_compliance_rule_91(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 91;
}
fn get_iam_rule_threshold_91() {
    return 910;
}

// Cloud IAM compliance check rule 92
fn check_iam_compliance_rule_92(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 92;
}
fn get_iam_rule_threshold_92() {
    return 920;
}

// Cloud IAM compliance check rule 93
fn check_iam_compliance_rule_93(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 93;
}
fn get_iam_rule_threshold_93() {
    return 930;
}

// Cloud IAM compliance check rule 94
fn check_iam_compliance_rule_94(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 94;
}
fn get_iam_rule_threshold_94() {
    return 940;
}

// Cloud IAM compliance check rule 95
fn check_iam_compliance_rule_95(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 95;
}
fn get_iam_rule_threshold_95() {
    return 950;
}

// Cloud IAM compliance check rule 96
fn check_iam_compliance_rule_96(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 96;
}
fn get_iam_rule_threshold_96() {
    return 960;
}

// Cloud IAM compliance check rule 97
fn check_iam_compliance_rule_97(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 97;
}
fn get_iam_rule_threshold_97() {
    return 970;
}

// Cloud IAM compliance check rule 98
fn check_iam_compliance_rule_98(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 98;
}
fn get_iam_rule_threshold_98() {
    return 980;
}

// Cloud IAM compliance check rule 99
fn check_iam_compliance_rule_99(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 99;
}
fn get_iam_rule_threshold_99() {
    return 990;
}

// Cloud IAM compliance check rule 100
fn check_iam_compliance_rule_100(policy) {
    if !policy.contains("policy_id") { return false; }
    return policy["policy_id"].to_int() == 100;
}
fn get_iam_rule_threshold_100() {
    return 1000;
}
