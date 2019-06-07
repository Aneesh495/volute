/*
 * SWIFT MT Financial Messaging Parser (MT103 / MT202 / MT940)
 *
 * Parses ISO 15022 / SWIFT FIN block structures (1, 2, 3, 4, 5) and validates tag fields.
 */

// Parse SWIFT FIN block headers
fn parse_swift_blocks(raw_swift) {
    let blocks = #{};
    let i = 0;
    let n = raw_swift.len();
    while i < n {
        let b_start = raw_swift.sub_string(i, n - i).index_of("{");
        if b_start == -1 { break; }
        let actual_start = i + b_start;
        let colon_idx = raw_swift.sub_string(actual_start, n - actual_start).index_of(":");
        if colon_idx == -1 { break; }
        let block_id = raw_swift.sub_string(actual_start + 1, colon_idx - 1);
        let b_end = raw_swift.sub_string(actual_start, n - actual_start).index_of("}");
        if b_end == -1 { break; }
        let content = raw_swift.sub_string(actual_start + colon_idx + 1, b_end - colon_idx - 1);
        blocks[block_id] = content;
        i = actual_start + b_end + 1;
    }
    return blocks;
}

// Parse Block 4 tagged fields (:20:, :32A:, :50K:, :59:, etc.)
fn parse_block4_fields(block4_content) {
    let fields = #{};
    let i = 0;
    let n = block4_content.len();
    while i < n {
        if block4_content.sub_string(i, 1) == ":" {
            let tag_end = -1;
            for j in (i + 1)..n {
                if block4_content.sub_string(j, 1) == ":" {
                    tag_end = j;
                    break;
                }
            }
            if tag_end != -1 {
                let tag_name = block4_content.sub_string(i + 1, tag_end - i - 1);
                let next_colon = -1;
                for k in (tag_end + 1)..n {
                    if block4_content.sub_string(k, 1) == ":" {
                        next_colon = k;
                        break;
                    }
                }
                if next_colon == -1 { next_colon = n; }
                let val = block4_content.sub_string(tag_end + 1, next_colon - tag_end - 1);
                fields[tag_name] = val.trim();
                i = next_colon;
                continue;
            }
        }
        i += 1;
    }
    return fields;
}
// SWIFT Tag :20: (SendersReference) - Mandatory transaction reference
fn get_swift_sendersreference(fields) {
    let k = "20";
    if fields.contains(k) { return fields[k]; }
    return ();
}
fn validate_swift_sendersreference(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// SWIFT Tag :21: (RelatedReference) - Reference to previous message
fn get_swift_relatedreference(fields) {
    let k = "21";
    if fields.contains(k) { return fields[k]; }
    return ();
}
fn validate_swift_relatedreference(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// SWIFT Tag :23B: (BankOperationCode) - Standard operation code (CRED, CRTS)
fn get_swift_bankoperationcode(fields) {
    let k = "23B";
    if fields.contains(k) { return fields[k]; }
    return ();
}
fn validate_swift_bankoperationcode(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// SWIFT Tag :23E: (InstructionCode) - Instruction code for payment routing
fn get_swift_instructioncode(fields) {
    let k = "23E";
    if fields.contains(k) { return fields[k]; }
    return ();
}
fn validate_swift_instructioncode(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// SWIFT Tag :26T: (TransactionTypeCode) - Financial transaction nature code
fn get_swift_transactiontypecode(fields) {
    let k = "26T";
    if fields.contains(k) { return fields[k]; }
    return ();
}
fn validate_swift_transactiontypecode(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// SWIFT Tag :32A: (ValueDateCurrencyAmount) - Interbank settlement value date and amount
fn get_swift_valuedatecurrencyamount(fields) {
    let k = "32A";
    if fields.contains(k) { return fields[k]; }
    return ();
}
fn validate_swift_valuedatecurrencyamount(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// SWIFT Tag :33B: (InstructedAmount) - Amount instructed by ordering customer
fn get_swift_instructedamount(fields) {
    let k = "33B";
    if fields.contains(k) { return fields[k]; }
    return ();
}
fn validate_swift_instructedamount(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// SWIFT Tag :36: (ExchangeRate) - Agreed currency conversion exchange rate
fn get_swift_exchangerate(fields) {
    let k = "36";
    if fields.contains(k) { return fields[k]; }
    return ();
}
fn validate_swift_exchangerate(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// SWIFT Tag :50A: (OrderingCustomerBIC) - Ordering customer account / BIC
fn get_swift_orderingcustomerbic(fields) {
    let k = "50A";
    if fields.contains(k) { return fields[k]; }
    return ();
}
fn validate_swift_orderingcustomerbic(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// SWIFT Tag :50K: (OrderingCustomerNameAddr) - Ordering customer name and postal address
fn get_swift_orderingcustomernameaddr(fields) {
    let k = "50K";
    if fields.contains(k) { return fields[k]; }
    return ();
}
fn validate_swift_orderingcustomernameaddr(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// SWIFT Tag :51A: (SendingInstitution) - Identifier of originating financial institution
fn get_swift_sendinginstitution(fields) {
    let k = "51A";
    if fields.contains(k) { return fields[k]; }
    return ();
}
fn validate_swift_sendinginstitution(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// SWIFT Tag :52A: (OrderingInstitution) - Financial institution of ordering party
fn get_swift_orderinginstitution(fields) {
    let k = "52A";
    if fields.contains(k) { return fields[k]; }
    return ();
}
fn validate_swift_orderinginstitution(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// SWIFT Tag :53A: (SenderCorrespondent) - Correspondent account of sender bank
fn get_swift_sendercorrespondent(fields) {
    let k = "53A";
    if fields.contains(k) { return fields[k]; }
    return ();
}
fn validate_swift_sendercorrespondent(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// SWIFT Tag :54A: (ReceiverCorrespondent) - Correspondent account of receiver bank
fn get_swift_receivercorrespondent(fields) {
    let k = "54A";
    if fields.contains(k) { return fields[k]; }
    return ();
}
fn validate_swift_receivercorrespondent(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// SWIFT Tag :55A: (ThirdReimbursementInst) - Third-party reimbursement institution
fn get_swift_thirdreimbursementinst(fields) {
    let k = "55A";
    if fields.contains(k) { return fields[k]; }
    return ();
}
fn validate_swift_thirdreimbursementinst(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// SWIFT Tag :56A: (IntermediaryInstitution) - Intermediary routing institution
fn get_swift_intermediaryinstitution(fields) {
    let k = "56A";
    if fields.contains(k) { return fields[k]; }
    return ();
}
fn validate_swift_intermediaryinstitution(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// SWIFT Tag :57A: (AccountWithInstitution) - Beneficiary bank identifier
fn get_swift_accountwithinstitution(fields) {
    let k = "57A";
    if fields.contains(k) { return fields[k]; }
    return ();
}
fn validate_swift_accountwithinstitution(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// SWIFT Tag :59: (BeneficiaryCustomer) - Ultimate payment beneficiary customer
fn get_swift_beneficiarycustomer(fields) {
    let k = "59";
    if fields.contains(k) { return fields[k]; }
    return ();
}
fn validate_swift_beneficiarycustomer(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// SWIFT Tag :70: (RemittanceInformation) - Payment reference for beneficiary
fn get_swift_remittanceinformation(fields) {
    let k = "70";
    if fields.contains(k) { return fields[k]; }
    return ();
}
fn validate_swift_remittanceinformation(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// SWIFT Tag :71A: (DetailsOfCharges) - Charge allocation (OUR, BEN, SHA)
fn get_swift_detailsofcharges(fields) {
    let k = "71A";
    if fields.contains(k) { return fields[k]; }
    return ();
}
fn validate_swift_detailsofcharges(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// SWIFT Tag :71F: (SenderCharges) - Charges debited by sender bank
fn get_swift_sendercharges(fields) {
    let k = "71F";
    if fields.contains(k) { return fields[k]; }
    return ();
}
fn validate_swift_sendercharges(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// SWIFT Tag :71G: (ReceiverCharges) - Charges claimed by receiver bank
fn get_swift_receivercharges(fields) {
    let k = "71G";
    if fields.contains(k) { return fields[k]; }
    return ();
}
fn validate_swift_receivercharges(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// SWIFT Tag :72: (SenderToReceiverInfo) - Narrative instructions for receiver
fn get_swift_sendertoreceiverinfo(fields) {
    let k = "72";
    if fields.contains(k) { return fields[k]; }
    return ();
}
fn validate_swift_sendertoreceiverinfo(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}

// SWIFT Tag :77B: (RegulatoryReporting) - Regulatory and compliance reporting codes
fn get_swift_regulatoryreporting(fields) {
    let k = "77B";
    if fields.contains(k) { return fields[k]; }
    return ();
}
fn validate_swift_regulatoryreporting(val) {
    if type_of(val) == "()" { return false; }
    let s = val.to_string();
    return !s.is_empty();
}
