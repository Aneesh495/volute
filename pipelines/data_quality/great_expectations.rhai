/*
 * Great Expectations Streaming Data Quality Engine
 *
 * Evaluates records against declarative data contracts.
 */

// Expect column value to be between min and max bounds
fn expect_column_values_to_be_between(record, column, min_val, max_val) {
    if !record.contains(column) {
        return #{ success: false, reason: "column_missing" };
    }
    let val = record[column] * 1.0;
    if val < (min_val * 1.0) || val > (max_val * 1.0) {
        return #{ success: false, reason: "value_out_of_bounds", value: val };
    }
    return #{ success: true };
}

// Expect column value not to be null
fn expect_column_values_to_not_be_null(record, column) {
    if !record.contains(column) {
        return #{ success: false, reason: "column_missing" };
    }
    if type_of(record[column]) == "()" {
        return #{ success: false, reason: "null_value" };
    }
    return #{ success: true };
}

// Expect column value to be in allowed set of strings
fn expect_column_values_to_be_in_set(record, column, allowed_set) {
    if !record.contains(column) {
        return #{ success: false, reason: "column_missing" };
    }
    let val = record[column].to_string();
    let found = false;
    for allowed in allowed_set {
        if val == allowed {
            found = true;
            break;
        }
    }
    if !found {
        return #{ success: false, reason: "value_not_in_set", value: val };
    }
    return #{ success: true };
}
