/*
 * Payment Transaction Enrichment and Classification
 *
 * Enriches payment events with normalized merchant names and risk scores.
 */

// Categorize transaction by Merchant Category Code (MCC)
fn categorize_mcc(mcc) {
    let code = mcc.to_int();
    if code >= 3000 && code <= 3300 { return "AIRLINES"; }
    if code >= 3501 && code <= 3999 { return "HOTELS"; }
    if code >= 5400 && code <= 5499 { return "GROCERIES"; }
    if code >= 5811 && code <= 5814 { return "RESTAURANTS"; }
    if code == 7995 { return "GAMBLING"; }
    if code >= 6010 && code <= 6012 { return "FINANCIAL_SERVICES"; }
    return "GENERAL_MERCHANDISE";
}

// Enrich transaction event
fn enrich_transaction(event) {
    let mcc = event.payload["mcc"];
    let amount = event.payload["amount"] * 1.0;
    let category = categorize_mcc(mcc);

    let risk_tier = "LOW";
    if category == "GAMBLING" || amount > 10000.0 {
        risk_tier = "HIGH";
    } else if amount > 2500.0 {
        risk_tier = "MEDIUM";
    }

    event.payload["category"] = category;
    event.payload["risk_tier"] = risk_tier;
    event.payload["processed_timestamp_ns"] = now_ns();
    return event;
}
