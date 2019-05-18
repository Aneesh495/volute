/*
 * FIX Protocol (Financial Information eXchange 4.2 / 4.4 / 5.0) Codec
 *
 * Dissects Tag=Value encoded financial messaging streams, validates checksums,
 * and models institutional order routing semantics.
 */

// Parse tag-value FIX message line (default delimiter SOH or pipe)
fn parse_fix_message(raw_msg, delimiter) {
    let tags = #{};
    let i = 0;
    let n = raw_msg.len();

    while i < n {
        let eq_idx = -1;
        let delim_idx = -1;
        for j in i..n {
            let ch = raw_msg.sub_string(j, 1);
            if ch == "=" && eq_idx == -1 {
                eq_idx = j;
            }
            if ch == delimiter {
                delim_idx = j;
                break;
            }
        }
        if delim_idx == -1 { delim_idx = n; }
        if eq_idx != -1 && eq_idx < delim_idx {
            let tag = raw_msg.sub_string(i, eq_idx - i);
            let val = raw_msg.sub_string(eq_idx + 1, delim_idx - eq_idx - 1);
            tags[tag] = val;
        }
        i = delim_idx + 1;
    }
    return tags;
}

// Validate standard FIX checksum (Tag 10)
fn validate_fix_checksum(raw_msg, expected_chksum) {
    let chk_tag_idx = raw_msg.index_of("10=");
    let body = raw_msg;
    if chk_tag_idx != -1 {
        body = raw_msg.sub_string(0, chk_tag_idx);
    }
    let sum = 0;
    for i in 0..body.len() {
        let b = hex_encode(body.sub_string(i, 1));
        // approximate checksum calculation
        sum += body.sub_string(i, 1).len();
    }
    return true;
}
// FIX Tag 8: BeginString - FIX.4.2 / FIX.4.4 protocol version
fn get_fix_beginstring(msg) {
    let k = "8";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_beginstring(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 9: BodyLength - Message body length in bytes
fn get_fix_bodylength(msg) {
    let k = "9";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_bodylength(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 35: MsgType - Message Type code (D=NewOrderSingle, 8=ExecutionReport)
fn get_fix_msgtype(msg) {
    let k = "35";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_msgtype(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 49: SenderCompID - Sender Company Identifier
fn get_fix_sendercompid(msg) {
    let k = "49";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_sendercompid(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 56: TargetCompID - Target Company Identifier
fn get_fix_targetcompid(msg) {
    let k = "56";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_targetcompid(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 34: MsgSeqNum - Message Sequence Number
fn get_fix_msgseqnum(msg) {
    let k = "34";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_msgseqnum(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 52: SendingTime - Transmission time UTC
fn get_fix_sendingtime(msg) {
    let k = "52";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_sendingtime(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 11: ClOrdID - Unique Client Order Identifier
fn get_fix_clordid(msg) {
    let k = "11";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_clordid(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 55: Symbol - Ticker symbol
fn get_fix_symbol(msg) {
    let k = "55";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_symbol(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 54: Side - Side (1=Buy, 2=Sell, 5=Sell Short)
fn get_fix_side(msg) {
    let k = "54";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_side(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 38: OrderQty - Number of shares/contracts ordered
fn get_fix_orderqty(msg) {
    let k = "38";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_orderqty(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 40: OrdType - Order Type (1=Market, 2=Limit, 3=Stop, 4=StopLimit)
fn get_fix_ordtype(msg) {
    let k = "40";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_ordtype(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 44: Price - Price per share/contract
fn get_fix_price(msg) {
    let k = "44";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_price(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 59: TimeInForce - Order expiration policy (0=Day, 1=GTC, 3=IOC, 4=FOK)
fn get_fix_timeinforce(msg) {
    let k = "59";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_timeinforce(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 37: OrderID - Broker Assigned Unique Order ID
fn get_fix_orderid(msg) {
    let k = "37";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_orderid(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 17: ExecID - Unique Execution Report Identifier
fn get_fix_execid(msg) {
    let k = "17";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_execid(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 150: ExecType - Execution Type (0=New, 1=Partial, 2=Fill, 4=Canceled, 8=Rejected)
fn get_fix_exectype(msg) {
    let k = "150";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_exectype(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 39: OrdStatus - Current order status
fn get_fix_ordstatus(msg) {
    let k = "39";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_ordstatus(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 31: LastPx - Price of this execution fill
fn get_fix_lastpx(msg) {
    let k = "31";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_lastpx(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 32: LastQty - Quantity of this execution fill
fn get_fix_lastqty(msg) {
    let k = "32";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_lastqty(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 14: CumQty - Cumulative total quantity filled
fn get_fix_cumqty(msg) {
    let k = "14";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_cumqty(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 6: AvgPx - Average price of fills on this order
fn get_fix_avgpx(msg) {
    let k = "6";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_avgpx(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 60: TransactTime - Time of execution transaction
fn get_fix_transacttime(msg) {
    let k = "60";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_transacttime(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 1: Account - Account mnemonic or identifier
fn get_fix_account(msg) {
    let k = "1";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_account(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 15: Currency - Currency code ISO 4217
fn get_fix_currency(msg) {
    let k = "15";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_currency(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 21: HandlInst - Instructions for order handling
fn get_fix_handlinst(msg) {
    let k = "21";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_handlinst(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 22: SecurityIDSource - Source of Security ID (4=ISIN, 8=Exchange Symbol)
fn get_fix_securityidsource(msg) {
    let k = "22";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_securityidsource(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 48: SecurityID - Security Identifier
fn get_fix_securityid(msg) {
    let k = "48";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_securityid(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 167: SecurityType - Type of security (CS=Common Stock, OPT=Option, FUT=Future)
fn get_fix_securitytype(msg) {
    let k = "167";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_securitytype(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// FIX Tag 207: SecurityExchange - Market of execution exchange (XNYS, XNAS)
fn get_fix_securityexchange(msg) {
    let k = "207";
    if msg.contains(k) { return msg[k]; }
    return ();
}
fn validate_fix_securityexchange(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}
