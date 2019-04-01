/*
 * OpenTelemetry Span Sanitizer and PII Redactor
 *
 * Masks sensitive attributes (bearer tokens, passwords, authorization headers).
 */

fn sanitize_span(span) {
    let attrs = span.payload["attributes"];
    let sensitive_keys = ["authorization", "password", "token", "secret", "api_key", "credit_card"];

    for key in attrs.keys() {
        let k_lower = key.to_lower();
        for sens in sensitive_keys {
            if k_lower.contains(sens) {
                attrs[key] = "[REDACTED]";
                break;
            }
        }
    }
    span.payload["attributes"] = attrs;
    return span;
}
