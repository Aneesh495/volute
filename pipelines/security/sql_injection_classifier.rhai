/*
 * SQL Injection Heuristic Classifier and Risk Scorer
 *
 * Scans HTTP query parameters and headers for malicious injection payloads.
 */

// Heuristic SQL injection risk scorer
fn score_sqli_payload(input_str) {
    let lower = input_str.to_lower();
    let score = 0;
    let detections = [];

    // Tautology check
    if lower.contains("or 1=1") || lower.contains("' or '1'='1") || lower.contains("or true") {
        score += 50;
        detections.push("TAUTOLOGY_OR_1=1");
    }

    // UNION SELECT check
    if lower.contains("union") && lower.contains("select") {
        score += 60;
        detections.push("UNION_SELECT_INJECTION");
    }

    // Stacked queries check
    if lower.contains("; drop ") || lower.contains("; delete ") || lower.contains("; insert ") {
        score += 70;
        detections.push("STACKED_QUERY_MUTATION");
    }

    // SQL comments check
    if lower.contains("/*") || lower.contains("*/") || lower.contains("#") {
        score += 25;
        detections.push("COMMENT_EVASION");
    }

    // Sleep / benchmark time-based blind injection
    if lower.contains("sleep(") || lower.contains("benchmark(") || lower.contains("waitfor delay") {
        score += 65;
        detections.push("TIME_BASED_BLIND_SQLI");
    }

    let is_malicious = score >= 50;
    return #{
        is_malicious: is_malicious,
        score: score,
        detections: detections
    };
}
