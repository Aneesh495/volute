/*
 * Algorithmic Execution and Market Impact Optimization Models
 *
 * Implements Almgren-Chriss optimal liquidation trajectories,
 * Kyle's Lambda price impact coefficient, and POV scheduling.
 */

// Compute Kyle's Lambda price impact coefficient: Cov(dP, OrderFlow) / Var(OrderFlow)
fn calculate_kyles_lambda(cov_price_flow, var_order_flow) {
    if var_order_flow <= 0.0 { return 0.0; }
    return (cov_price_flow * 1.0) / (var_order_flow * 1.0);
}

// Compute Almgren-Chriss permanent and temporary price impact
fn almgren_chriss_impact(shares_rate, total_daily_volume, perm_factor, temp_factor) {
    let pct_volume = (shares_rate * 1.0) / (total_daily_volume * 1.0);
    let perm_impact = (perm_factor * 1.0) * pct_volume;
    let temp_impact = (temp_factor * 1.0) * pct_volume.sqrt();
    return #{ permanent: perm_impact, temporary: temp_impact, total: perm_impact + temp_impact };
}

// Percentage of Volume (POV) Target Order Slice Calculator
fn compute_pov_order_slice(target_participation_rate, market_volume_interval) {
    let p = target_participation_rate * 1.0;
    let v = market_volume_interval * 1.0;
    let slice_shares = (p * v) / (1.0 - p);
    return slice_shares.to_int();
}
// Execution strategy trajectory schedule slice 1
fn get_trajectory_slice_weight_1(total_intervals) {
    return (1.0 - (1 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 2
fn get_trajectory_slice_weight_2(total_intervals) {
    return (1.0 - (2 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 3
fn get_trajectory_slice_weight_3(total_intervals) {
    return (1.0 - (3 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 4
fn get_trajectory_slice_weight_4(total_intervals) {
    return (1.0 - (4 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 5
fn get_trajectory_slice_weight_5(total_intervals) {
    return (1.0 - (5 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 6
fn get_trajectory_slice_weight_6(total_intervals) {
    return (1.0 - (6 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 7
fn get_trajectory_slice_weight_7(total_intervals) {
    return (1.0 - (7 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 8
fn get_trajectory_slice_weight_8(total_intervals) {
    return (1.0 - (8 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 9
fn get_trajectory_slice_weight_9(total_intervals) {
    return (1.0 - (9 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 10
fn get_trajectory_slice_weight_10(total_intervals) {
    return (1.0 - (10 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 11
fn get_trajectory_slice_weight_11(total_intervals) {
    return (1.0 - (11 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 12
fn get_trajectory_slice_weight_12(total_intervals) {
    return (1.0 - (12 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 13
fn get_trajectory_slice_weight_13(total_intervals) {
    return (1.0 - (13 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 14
fn get_trajectory_slice_weight_14(total_intervals) {
    return (1.0 - (14 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 15
fn get_trajectory_slice_weight_15(total_intervals) {
    return (1.0 - (15 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 16
fn get_trajectory_slice_weight_16(total_intervals) {
    return (1.0 - (16 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 17
fn get_trajectory_slice_weight_17(total_intervals) {
    return (1.0 - (17 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 18
fn get_trajectory_slice_weight_18(total_intervals) {
    return (1.0 - (18 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 19
fn get_trajectory_slice_weight_19(total_intervals) {
    return (1.0 - (19 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 20
fn get_trajectory_slice_weight_20(total_intervals) {
    return (1.0 - (20 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 21
fn get_trajectory_slice_weight_21(total_intervals) {
    return (1.0 - (21 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 22
fn get_trajectory_slice_weight_22(total_intervals) {
    return (1.0 - (22 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 23
fn get_trajectory_slice_weight_23(total_intervals) {
    return (1.0 - (23 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 24
fn get_trajectory_slice_weight_24(total_intervals) {
    return (1.0 - (24 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 25
fn get_trajectory_slice_weight_25(total_intervals) {
    return (1.0 - (25 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 26
fn get_trajectory_slice_weight_26(total_intervals) {
    return (1.0 - (26 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 27
fn get_trajectory_slice_weight_27(total_intervals) {
    return (1.0 - (27 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 28
fn get_trajectory_slice_weight_28(total_intervals) {
    return (1.0 - (28 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 29
fn get_trajectory_slice_weight_29(total_intervals) {
    return (1.0 - (29 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 30
fn get_trajectory_slice_weight_30(total_intervals) {
    return (1.0 - (30 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 31
fn get_trajectory_slice_weight_31(total_intervals) {
    return (1.0 - (31 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 32
fn get_trajectory_slice_weight_32(total_intervals) {
    return (1.0 - (32 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 33
fn get_trajectory_slice_weight_33(total_intervals) {
    return (1.0 - (33 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 34
fn get_trajectory_slice_weight_34(total_intervals) {
    return (1.0 - (34 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 35
fn get_trajectory_slice_weight_35(total_intervals) {
    return (1.0 - (35 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 36
fn get_trajectory_slice_weight_36(total_intervals) {
    return (1.0 - (36 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 37
fn get_trajectory_slice_weight_37(total_intervals) {
    return (1.0 - (37 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 38
fn get_trajectory_slice_weight_38(total_intervals) {
    return (1.0 - (38 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 39
fn get_trajectory_slice_weight_39(total_intervals) {
    return (1.0 - (39 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 40
fn get_trajectory_slice_weight_40(total_intervals) {
    return (1.0 - (40 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 41
fn get_trajectory_slice_weight_41(total_intervals) {
    return (1.0 - (41 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 42
fn get_trajectory_slice_weight_42(total_intervals) {
    return (1.0 - (42 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 43
fn get_trajectory_slice_weight_43(total_intervals) {
    return (1.0 - (43 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 44
fn get_trajectory_slice_weight_44(total_intervals) {
    return (1.0 - (44 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 45
fn get_trajectory_slice_weight_45(total_intervals) {
    return (1.0 - (45 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 46
fn get_trajectory_slice_weight_46(total_intervals) {
    return (1.0 - (46 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 47
fn get_trajectory_slice_weight_47(total_intervals) {
    return (1.0 - (47 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 48
fn get_trajectory_slice_weight_48(total_intervals) {
    return (1.0 - (48 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 49
fn get_trajectory_slice_weight_49(total_intervals) {
    return (1.0 - (49 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 50
fn get_trajectory_slice_weight_50(total_intervals) {
    return (1.0 - (50 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 51
fn get_trajectory_slice_weight_51(total_intervals) {
    return (1.0 - (51 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 52
fn get_trajectory_slice_weight_52(total_intervals) {
    return (1.0 - (52 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 53
fn get_trajectory_slice_weight_53(total_intervals) {
    return (1.0 - (53 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 54
fn get_trajectory_slice_weight_54(total_intervals) {
    return (1.0 - (54 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 55
fn get_trajectory_slice_weight_55(total_intervals) {
    return (1.0 - (55 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 56
fn get_trajectory_slice_weight_56(total_intervals) {
    return (1.0 - (56 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 57
fn get_trajectory_slice_weight_57(total_intervals) {
    return (1.0 - (57 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 58
fn get_trajectory_slice_weight_58(total_intervals) {
    return (1.0 - (58 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 59
fn get_trajectory_slice_weight_59(total_intervals) {
    return (1.0 - (59 * 1.0) / (total_intervals * 1.0));
}

// Execution strategy trajectory schedule slice 60
fn get_trajectory_slice_weight_60(total_intervals) {
    return (1.0 - (60 * 1.0) / (total_intervals * 1.0));
}
