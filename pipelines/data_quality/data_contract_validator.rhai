/*
 * Declarative Data Contract Enforcement
 *
 * Validates streaming events against field presence and non-null constraints.
 */

fn validate_contract(event, required_fields) {
    let missing = [];
    for f in required_fields {
        if !event.payload.contains(f) {
            missing.push(f);
        } else if type_of(event.payload[f]) == "()" {
            missing.push(f + " (is null)");
        }
    }
    if !missing.is_empty() {
        return #{
            valid: false,
            event_id: event.id,
            missing_fields: missing
        };
    }
    return #{ valid: true };
}
