/*
 * Lightweight Assertion Library for Rhai Tests
 */

// Assert that condition is true
fn assert(condition, message) {
    if !condition {
        throw "Assertion failed: " + message;
    }
}

// Assert equality of two values
fn assert_eq(actual, expected, message) {
    if actual != expected {
        throw "Assertion failed: " + message + " (expected: " + expected.to_string() + ", got: " + actual.to_string() + ")";
    }
}

// Assert inequality of two values
fn assert_ne(actual, expected, message) {
    if actual == expected {
        throw "Assertion failed: " + message + " (did not expect: " + expected.to_string() + ")";
    }
}

// Assert floating point values are close within epsilon
fn assert_near(actual, expected, epsilon, message) {
    let diff = (actual * 1.0) - (expected * 1.0);
    let abs_diff = if diff < 0.0 { -diff } else { diff };
    if abs_diff > epsilon {
        throw "Assertion failed: " + message + " (diff: " + abs_diff.to_string() + " > " + epsilon.to_string() + ")";
    }
}
