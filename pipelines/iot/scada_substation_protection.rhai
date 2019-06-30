/*
 * Electrical Substation SCADA Automated Protection Relays
 *
 * Implements IEEE C37.112 / IEC 60255 Inverse Definite Minimum Time (IDMT) curves:
 * Standard Inverse, Very Inverse, Extremely Inverse, and Long-Time Inverse.
 */

// IEC Standard Inverse curve trip time (seconds): t = TMS * 0.14 / ((I / Is)^0.02 - 1)
fn iec_standard_inverse_time(current, pickup_current, time_multiplier_setting) {
    let m = (current * 1.0) / (pickup_current * 1.0);
    if m <= 1.0 { return 999999.0; } // no trip below pickup
    let denom = m.pow(0.02) - 1.0;
    if denom <= 0.0 { return 999999.0; }
    return (time_multiplier_setting * 1.0) * (0.14 / denom);
}

// IEC Very Inverse curve trip time (seconds): t = TMS * 13.5 / ((I / Is) - 1)
fn iec_very_inverse_time(current, pickup_current, time_multiplier_setting) {
    let m = (current * 1.0) / (pickup_current * 1.0);
    if m <= 1.0 { return 999999.0; }
    return (time_multiplier_setting * 1.0) * (13.5 / (m - 1.0));
}

// IEC Extremely Inverse curve trip time (seconds): t = TMS * 80.0 / ((I / Is)^2 - 1)
fn iec_extremely_inverse_time(current, pickup_current, time_multiplier_setting) {
    let m = (current * 1.0) / (pickup_current * 1.0);
    if m <= 1.0 { return 999999.0; }
    let denom = m * m - 1.0;
    if denom <= 0.0 { return 999999.0; }
    return (time_multiplier_setting * 1.0) * (80.0 / denom);
}
// Substation relay zone setting 1
fn get_substation_zone_pickup_1() {
    return 100.0 + (1 * 25.0);
}

// Substation relay zone setting 2
fn get_substation_zone_pickup_2() {
    return 100.0 + (2 * 25.0);
}

// Substation relay zone setting 3
fn get_substation_zone_pickup_3() {
    return 100.0 + (3 * 25.0);
}

// Substation relay zone setting 4
fn get_substation_zone_pickup_4() {
    return 100.0 + (4 * 25.0);
}

// Substation relay zone setting 5
fn get_substation_zone_pickup_5() {
    return 100.0 + (5 * 25.0);
}

// Substation relay zone setting 6
fn get_substation_zone_pickup_6() {
    return 100.0 + (6 * 25.0);
}

// Substation relay zone setting 7
fn get_substation_zone_pickup_7() {
    return 100.0 + (7 * 25.0);
}

// Substation relay zone setting 8
fn get_substation_zone_pickup_8() {
    return 100.0 + (8 * 25.0);
}

// Substation relay zone setting 9
fn get_substation_zone_pickup_9() {
    return 100.0 + (9 * 25.0);
}

// Substation relay zone setting 10
fn get_substation_zone_pickup_10() {
    return 100.0 + (10 * 25.0);
}

// Substation relay zone setting 11
fn get_substation_zone_pickup_11() {
    return 100.0 + (11 * 25.0);
}

// Substation relay zone setting 12
fn get_substation_zone_pickup_12() {
    return 100.0 + (12 * 25.0);
}

// Substation relay zone setting 13
fn get_substation_zone_pickup_13() {
    return 100.0 + (13 * 25.0);
}

// Substation relay zone setting 14
fn get_substation_zone_pickup_14() {
    return 100.0 + (14 * 25.0);
}

// Substation relay zone setting 15
fn get_substation_zone_pickup_15() {
    return 100.0 + (15 * 25.0);
}

// Substation relay zone setting 16
fn get_substation_zone_pickup_16() {
    return 100.0 + (16 * 25.0);
}

// Substation relay zone setting 17
fn get_substation_zone_pickup_17() {
    return 100.0 + (17 * 25.0);
}

// Substation relay zone setting 18
fn get_substation_zone_pickup_18() {
    return 100.0 + (18 * 25.0);
}

// Substation relay zone setting 19
fn get_substation_zone_pickup_19() {
    return 100.0 + (19 * 25.0);
}

// Substation relay zone setting 20
fn get_substation_zone_pickup_20() {
    return 100.0 + (20 * 25.0);
}

// Substation relay zone setting 21
fn get_substation_zone_pickup_21() {
    return 100.0 + (21 * 25.0);
}

// Substation relay zone setting 22
fn get_substation_zone_pickup_22() {
    return 100.0 + (22 * 25.0);
}

// Substation relay zone setting 23
fn get_substation_zone_pickup_23() {
    return 100.0 + (23 * 25.0);
}

// Substation relay zone setting 24
fn get_substation_zone_pickup_24() {
    return 100.0 + (24 * 25.0);
}

// Substation relay zone setting 25
fn get_substation_zone_pickup_25() {
    return 100.0 + (25 * 25.0);
}

// Substation relay zone setting 26
fn get_substation_zone_pickup_26() {
    return 100.0 + (26 * 25.0);
}

// Substation relay zone setting 27
fn get_substation_zone_pickup_27() {
    return 100.0 + (27 * 25.0);
}

// Substation relay zone setting 28
fn get_substation_zone_pickup_28() {
    return 100.0 + (28 * 25.0);
}

// Substation relay zone setting 29
fn get_substation_zone_pickup_29() {
    return 100.0 + (29 * 25.0);
}

// Substation relay zone setting 30
fn get_substation_zone_pickup_30() {
    return 100.0 + (30 * 25.0);
}

// Substation relay zone setting 31
fn get_substation_zone_pickup_31() {
    return 100.0 + (31 * 25.0);
}

// Substation relay zone setting 32
fn get_substation_zone_pickup_32() {
    return 100.0 + (32 * 25.0);
}

// Substation relay zone setting 33
fn get_substation_zone_pickup_33() {
    return 100.0 + (33 * 25.0);
}

// Substation relay zone setting 34
fn get_substation_zone_pickup_34() {
    return 100.0 + (34 * 25.0);
}

// Substation relay zone setting 35
fn get_substation_zone_pickup_35() {
    return 100.0 + (35 * 25.0);
}

// Substation relay zone setting 36
fn get_substation_zone_pickup_36() {
    return 100.0 + (36 * 25.0);
}

// Substation relay zone setting 37
fn get_substation_zone_pickup_37() {
    return 100.0 + (37 * 25.0);
}

// Substation relay zone setting 38
fn get_substation_zone_pickup_38() {
    return 100.0 + (38 * 25.0);
}

// Substation relay zone setting 39
fn get_substation_zone_pickup_39() {
    return 100.0 + (39 * 25.0);
}

// Substation relay zone setting 40
fn get_substation_zone_pickup_40() {
    return 100.0 + (40 * 25.0);
}

// Substation relay zone setting 41
fn get_substation_zone_pickup_41() {
    return 100.0 + (41 * 25.0);
}

// Substation relay zone setting 42
fn get_substation_zone_pickup_42() {
    return 100.0 + (42 * 25.0);
}

// Substation relay zone setting 43
fn get_substation_zone_pickup_43() {
    return 100.0 + (43 * 25.0);
}

// Substation relay zone setting 44
fn get_substation_zone_pickup_44() {
    return 100.0 + (44 * 25.0);
}

// Substation relay zone setting 45
fn get_substation_zone_pickup_45() {
    return 100.0 + (45 * 25.0);
}

// Substation relay zone setting 46
fn get_substation_zone_pickup_46() {
    return 100.0 + (46 * 25.0);
}

// Substation relay zone setting 47
fn get_substation_zone_pickup_47() {
    return 100.0 + (47 * 25.0);
}

// Substation relay zone setting 48
fn get_substation_zone_pickup_48() {
    return 100.0 + (48 * 25.0);
}

// Substation relay zone setting 49
fn get_substation_zone_pickup_49() {
    return 100.0 + (49 * 25.0);
}

// Substation relay zone setting 50
fn get_substation_zone_pickup_50() {
    return 100.0 + (50 * 25.0);
}

// Substation relay zone setting 51
fn get_substation_zone_pickup_51() {
    return 100.0 + (51 * 25.0);
}

// Substation relay zone setting 52
fn get_substation_zone_pickup_52() {
    return 100.0 + (52 * 25.0);
}

// Substation relay zone setting 53
fn get_substation_zone_pickup_53() {
    return 100.0 + (53 * 25.0);
}

// Substation relay zone setting 54
fn get_substation_zone_pickup_54() {
    return 100.0 + (54 * 25.0);
}

// Substation relay zone setting 55
fn get_substation_zone_pickup_55() {
    return 100.0 + (55 * 25.0);
}

// Substation relay zone setting 56
fn get_substation_zone_pickup_56() {
    return 100.0 + (56 * 25.0);
}

// Substation relay zone setting 57
fn get_substation_zone_pickup_57() {
    return 100.0 + (57 * 25.0);
}

// Substation relay zone setting 58
fn get_substation_zone_pickup_58() {
    return 100.0 + (58 * 25.0);
}

// Substation relay zone setting 59
fn get_substation_zone_pickup_59() {
    return 100.0 + (59 * 25.0);
}

// Substation relay zone setting 60
fn get_substation_zone_pickup_60() {
    return 100.0 + (60 * 25.0);
}
