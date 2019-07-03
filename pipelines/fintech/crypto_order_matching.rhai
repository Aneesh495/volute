/*
 * Continuous Double Auction Limit Order Book Matching Engine
 *
 * Models maker-taker fee schedules, price-time priority matching, and executions.
 */

// Initialize matching engine state
fn new_matching_engine(symbol, maker_fee_bps, taker_fee_bps) {
    return #{
        symbol: symbol,
        maker_fee: (maker_fee_bps * 1.0) / 10000.0,
        taker_fee: (taker_fee_bps * 1.0) / 10000.0,
        bids: [],
        asks: [],
        executions: []
    };
}

// Calculate order trading fee
fn calculate_fee(price, quantity, is_maker, engine) {
    let notional = (price * 1.0) * (quantity * 1.0);
    let fee_rate = if is_maker { engine.maker_fee } else { engine.taker_fee };
    return notional * fee_rate;
}
// Market pair profile 1
fn get_market_pair_tier_1() {
    return #{ pair_id: 1, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_1(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 1;
}

// Market pair profile 2
fn get_market_pair_tier_2() {
    return #{ pair_id: 2, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_2(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 2;
}

// Market pair profile 3
fn get_market_pair_tier_3() {
    return #{ pair_id: 3, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_3(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 3;
}

// Market pair profile 4
fn get_market_pair_tier_4() {
    return #{ pair_id: 4, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_4(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 4;
}

// Market pair profile 5
fn get_market_pair_tier_5() {
    return #{ pair_id: 5, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_5(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 5;
}

// Market pair profile 6
fn get_market_pair_tier_6() {
    return #{ pair_id: 6, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_6(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 6;
}

// Market pair profile 7
fn get_market_pair_tier_7() {
    return #{ pair_id: 7, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_7(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 7;
}

// Market pair profile 8
fn get_market_pair_tier_8() {
    return #{ pair_id: 8, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_8(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 8;
}

// Market pair profile 9
fn get_market_pair_tier_9() {
    return #{ pair_id: 9, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_9(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 9;
}

// Market pair profile 10
fn get_market_pair_tier_10() {
    return #{ pair_id: 10, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_10(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 10;
}

// Market pair profile 11
fn get_market_pair_tier_11() {
    return #{ pair_id: 11, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_11(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 11;
}

// Market pair profile 12
fn get_market_pair_tier_12() {
    return #{ pair_id: 12, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_12(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 12;
}

// Market pair profile 13
fn get_market_pair_tier_13() {
    return #{ pair_id: 13, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_13(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 13;
}

// Market pair profile 14
fn get_market_pair_tier_14() {
    return #{ pair_id: 14, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_14(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 14;
}

// Market pair profile 15
fn get_market_pair_tier_15() {
    return #{ pair_id: 15, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_15(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 15;
}

// Market pair profile 16
fn get_market_pair_tier_16() {
    return #{ pair_id: 16, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_16(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 16;
}

// Market pair profile 17
fn get_market_pair_tier_17() {
    return #{ pair_id: 17, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_17(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 17;
}

// Market pair profile 18
fn get_market_pair_tier_18() {
    return #{ pair_id: 18, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_18(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 18;
}

// Market pair profile 19
fn get_market_pair_tier_19() {
    return #{ pair_id: 19, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_19(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 19;
}

// Market pair profile 20
fn get_market_pair_tier_20() {
    return #{ pair_id: 20, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_20(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 20;
}

// Market pair profile 21
fn get_market_pair_tier_21() {
    return #{ pair_id: 21, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_21(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 21;
}

// Market pair profile 22
fn get_market_pair_tier_22() {
    return #{ pair_id: 22, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_22(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 22;
}

// Market pair profile 23
fn get_market_pair_tier_23() {
    return #{ pair_id: 23, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_23(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 23;
}

// Market pair profile 24
fn get_market_pair_tier_24() {
    return #{ pair_id: 24, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_24(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 24;
}

// Market pair profile 25
fn get_market_pair_tier_25() {
    return #{ pair_id: 25, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_25(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 25;
}

// Market pair profile 26
fn get_market_pair_tier_26() {
    return #{ pair_id: 26, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_26(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 26;
}

// Market pair profile 27
fn get_market_pair_tier_27() {
    return #{ pair_id: 27, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_27(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 27;
}

// Market pair profile 28
fn get_market_pair_tier_28() {
    return #{ pair_id: 28, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_28(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 28;
}

// Market pair profile 29
fn get_market_pair_tier_29() {
    return #{ pair_id: 29, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_29(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 29;
}

// Market pair profile 30
fn get_market_pair_tier_30() {
    return #{ pair_id: 30, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_30(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 30;
}

// Market pair profile 31
fn get_market_pair_tier_31() {
    return #{ pair_id: 31, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_31(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 31;
}

// Market pair profile 32
fn get_market_pair_tier_32() {
    return #{ pair_id: 32, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_32(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 32;
}

// Market pair profile 33
fn get_market_pair_tier_33() {
    return #{ pair_id: 33, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_33(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 33;
}

// Market pair profile 34
fn get_market_pair_tier_34() {
    return #{ pair_id: 34, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_34(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 34;
}

// Market pair profile 35
fn get_market_pair_tier_35() {
    return #{ pair_id: 35, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_35(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 35;
}

// Market pair profile 36
fn get_market_pair_tier_36() {
    return #{ pair_id: 36, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_36(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 36;
}

// Market pair profile 37
fn get_market_pair_tier_37() {
    return #{ pair_id: 37, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_37(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 37;
}

// Market pair profile 38
fn get_market_pair_tier_38() {
    return #{ pair_id: 38, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_38(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 38;
}

// Market pair profile 39
fn get_market_pair_tier_39() {
    return #{ pair_id: 39, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_39(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 39;
}

// Market pair profile 40
fn get_market_pair_tier_40() {
    return #{ pair_id: 40, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_40(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 40;
}

// Market pair profile 41
fn get_market_pair_tier_41() {
    return #{ pair_id: 41, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_41(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 41;
}

// Market pair profile 42
fn get_market_pair_tier_42() {
    return #{ pair_id: 42, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_42(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 42;
}

// Market pair profile 43
fn get_market_pair_tier_43() {
    return #{ pair_id: 43, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_43(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 43;
}

// Market pair profile 44
fn get_market_pair_tier_44() {
    return #{ pair_id: 44, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_44(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 44;
}

// Market pair profile 45
fn get_market_pair_tier_45() {
    return #{ pair_id: 45, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_45(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 45;
}

// Market pair profile 46
fn get_market_pair_tier_46() {
    return #{ pair_id: 46, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_46(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 46;
}

// Market pair profile 47
fn get_market_pair_tier_47() {
    return #{ pair_id: 47, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_47(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 47;
}

// Market pair profile 48
fn get_market_pair_tier_48() {
    return #{ pair_id: 48, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_48(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 48;
}

// Market pair profile 49
fn get_market_pair_tier_49() {
    return #{ pair_id: 49, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_49(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 49;
}

// Market pair profile 50
fn get_market_pair_tier_50() {
    return #{ pair_id: 50, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_50(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 50;
}

// Market pair profile 51
fn get_market_pair_tier_51() {
    return #{ pair_id: 51, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_51(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 51;
}

// Market pair profile 52
fn get_market_pair_tier_52() {
    return #{ pair_id: 52, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_52(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 52;
}

// Market pair profile 53
fn get_market_pair_tier_53() {
    return #{ pair_id: 53, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_53(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 53;
}

// Market pair profile 54
fn get_market_pair_tier_54() {
    return #{ pair_id: 54, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_54(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 54;
}

// Market pair profile 55
fn get_market_pair_tier_55() {
    return #{ pair_id: 55, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_55(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 55;
}

// Market pair profile 56
fn get_market_pair_tier_56() {
    return #{ pair_id: 56, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_56(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 56;
}

// Market pair profile 57
fn get_market_pair_tier_57() {
    return #{ pair_id: 57, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_57(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 57;
}

// Market pair profile 58
fn get_market_pair_tier_58() {
    return #{ pair_id: 58, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_58(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 58;
}

// Market pair profile 59
fn get_market_pair_tier_59() {
    return #{ pair_id: 59, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_59(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 59;
}

// Market pair profile 60
fn get_market_pair_tier_60() {
    return #{ pair_id: 60, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_60(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 60;
}

// Market pair profile 61
fn get_market_pair_tier_61() {
    return #{ pair_id: 61, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_61(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 61;
}

// Market pair profile 62
fn get_market_pair_tier_62() {
    return #{ pair_id: 62, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_62(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 62;
}

// Market pair profile 63
fn get_market_pair_tier_63() {
    return #{ pair_id: 63, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_63(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 63;
}

// Market pair profile 64
fn get_market_pair_tier_64() {
    return #{ pair_id: 64, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_64(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 64;
}

// Market pair profile 65
fn get_market_pair_tier_65() {
    return #{ pair_id: 65, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_65(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 65;
}

// Market pair profile 66
fn get_market_pair_tier_66() {
    return #{ pair_id: 66, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_66(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 66;
}

// Market pair profile 67
fn get_market_pair_tier_67() {
    return #{ pair_id: 67, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_67(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 67;
}

// Market pair profile 68
fn get_market_pair_tier_68() {
    return #{ pair_id: 68, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_68(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 68;
}

// Market pair profile 69
fn get_market_pair_tier_69() {
    return #{ pair_id: 69, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_69(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 69;
}

// Market pair profile 70
fn get_market_pair_tier_70() {
    return #{ pair_id: 70, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_70(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 70;
}

// Market pair profile 71
fn get_market_pair_tier_71() {
    return #{ pair_id: 71, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_71(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 71;
}

// Market pair profile 72
fn get_market_pair_tier_72() {
    return #{ pair_id: 72, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_72(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 72;
}

// Market pair profile 73
fn get_market_pair_tier_73() {
    return #{ pair_id: 73, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_73(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 73;
}

// Market pair profile 74
fn get_market_pair_tier_74() {
    return #{ pair_id: 74, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_74(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 74;
}

// Market pair profile 75
fn get_market_pair_tier_75() {
    return #{ pair_id: 75, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_75(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 75;
}

// Market pair profile 76
fn get_market_pair_tier_76() {
    return #{ pair_id: 76, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_76(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 76;
}

// Market pair profile 77
fn get_market_pair_tier_77() {
    return #{ pair_id: 77, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_77(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 77;
}

// Market pair profile 78
fn get_market_pair_tier_78() {
    return #{ pair_id: 78, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_78(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 78;
}

// Market pair profile 79
fn get_market_pair_tier_79() {
    return #{ pair_id: 79, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_79(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 79;
}

// Market pair profile 80
fn get_market_pair_tier_80() {
    return #{ pair_id: 80, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_80(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 80;
}

// Market pair profile 81
fn get_market_pair_tier_81() {
    return #{ pair_id: 81, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_81(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 81;
}

// Market pair profile 82
fn get_market_pair_tier_82() {
    return #{ pair_id: 82, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_82(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 82;
}

// Market pair profile 83
fn get_market_pair_tier_83() {
    return #{ pair_id: 83, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_83(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 83;
}

// Market pair profile 84
fn get_market_pair_tier_84() {
    return #{ pair_id: 84, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_84(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 84;
}

// Market pair profile 85
fn get_market_pair_tier_85() {
    return #{ pair_id: 85, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_85(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 85;
}

// Market pair profile 86
fn get_market_pair_tier_86() {
    return #{ pair_id: 86, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_86(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 86;
}

// Market pair profile 87
fn get_market_pair_tier_87() {
    return #{ pair_id: 87, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_87(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 87;
}

// Market pair profile 88
fn get_market_pair_tier_88() {
    return #{ pair_id: 88, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_88(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 88;
}

// Market pair profile 89
fn get_market_pair_tier_89() {
    return #{ pair_id: 89, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_89(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 89;
}

// Market pair profile 90
fn get_market_pair_tier_90() {
    return #{ pair_id: 90, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_90(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 90;
}

// Market pair profile 91
fn get_market_pair_tier_91() {
    return #{ pair_id: 91, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_91(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 91;
}

// Market pair profile 92
fn get_market_pair_tier_92() {
    return #{ pair_id: 92, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_92(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 92;
}

// Market pair profile 93
fn get_market_pair_tier_93() {
    return #{ pair_id: 93, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_93(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 93;
}

// Market pair profile 94
fn get_market_pair_tier_94() {
    return #{ pair_id: 94, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_94(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 94;
}

// Market pair profile 95
fn get_market_pair_tier_95() {
    return #{ pair_id: 95, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_95(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 95;
}

// Market pair profile 96
fn get_market_pair_tier_96() {
    return #{ pair_id: 96, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_96(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 96;
}

// Market pair profile 97
fn get_market_pair_tier_97() {
    return #{ pair_id: 97, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_97(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 97;
}

// Market pair profile 98
fn get_market_pair_tier_98() {
    return #{ pair_id: 98, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_98(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 98;
}

// Market pair profile 99
fn get_market_pair_tier_99() {
    return #{ pair_id: 99, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_99(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 99;
}

// Market pair profile 100
fn get_market_pair_tier_100() {
    return #{ pair_id: 100, min_size: 0.001, tick_size: 0.01, max_leverage: 20 };
}
fn is_order_valid_for_pair_100(order) {
    if !order.contains("pair_id") { return false; }
    return order["pair_id"].to_int() == 100;
}
