/*
 * Multi-Factor Credit Card Fraud Risk Scorer
 *
 * Computes heuristic risk score [0, 100] based on card attributes.
 */

fn score_card_transaction(event) {
    let score = 0;
    let amount = event.payload["amount"] * 1.0;
    let is_card_present = event.payload["card_present"];
    let is_international = event.payload["is_international"];
    let velocity_1h = event.payload["velocity_1h"];

    // Factor 1: High value
    if amount > 5000.0 {
        score += 30;
    } else if amount > 1000.0 {
        score += 15;
    }

    // Factor 2: Card Not Present
    if !is_card_present {
        score += 20;
    }

    // Factor 3: Cross-border
    if is_international {
        score += 25;
    }

    // Factor 4: High velocity
    if velocity_1h > 5 {
        score += 35;
    } else if velocity_1h > 2 {
        score += 15;
    }

    let decision = "APPROVE";
    if score >= 75 {
        decision = "DECLINE";
    } else if score >= 45 {
        decision = "MANUAL_REVIEW";
    }

    return #{
        risk_score: score,
        decision: decision
    };
}
