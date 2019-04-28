/*
 * Recency, Frequency, Monetary (RFM) Customer Segmentation
 *
 * Scores customer interaction stream into distinct behavioral tiers.
 */

// Compute RFM score component [1, 5] given percentiles
fn score_quintile(val, thresholds, inverse) {
    let score = 1;
    for t in thresholds {
        if (val * 1.0) >= (t * 1.0) {
            score += 1;
        } else {
            break;
        }
    }
    if inverse {
        return 6 - score;
    }
    return score;
}

// Classify customer into RFM segment tier
fn classify_rfm_customer(days_since_last_order, lifetime_orders, total_spend) {
    // Thresholds: [q20, q40, q60, q80]
    let recency_score = score_quintile(days_since_last_order, [7, 30, 90, 180], true);
    let frequency_score = score_quintile(lifetime_orders, [2, 5, 10, 20], false);
    let monetary_score = score_quintile(total_spend, [50, 150, 350, 1000], false);

    let composite = recency_score * 100 + frequency_score * 10 + monetary_score;

    let segment = "STANDARD";
    if recency_score >= 4 && frequency_score >= 4 && monetary_score >= 4 {
        segment = "CHAMPION";
    } else if frequency_score >= 4 {
        segment = "LOYAL_CUSTOMER";
    } else if recency_score <= 2 && monetary_score >= 4 {
        segment = "AT_RISK_HIGH_VALUE";
    } else if recency_score <= 1 {
        segment = "LOST";
    }

    return #{
        recency: recency_score,
        frequency: frequency_score,
        monetary: monetary_score,
        composite_score: composite,
        segment: segment
    };
}
