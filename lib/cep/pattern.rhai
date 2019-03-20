/*
 * Complex Event Processing (CEP) Pattern Definitions
 *
 * Implements sequence detection (A followed by B), conjunctions, and windows.
 */

// Construct sequence pattern (A followed by B within max_window_ms)
fn pattern_followed_by(event_a_type, event_b_type, max_window_ms) {
    return #{
        kind: "followed_by",
        first: event_a_type,
        second: event_b_type,
        window_ms: max_window_ms
    };
}

// Construct count threshold pattern (N occurrences of event_type within window_ms)
fn pattern_count_threshold(event_type, threshold, window_ms) {
    return #{
        kind: "count_threshold",
        target: event_type,
        threshold: threshold,
        window_ms: window_ms
    };
}

// Construct absence pattern (event A NOT followed by event B within window_ms)
fn pattern_absence(event_a_type, event_b_type, window_ms) {
    return #{
        kind: "absence",
        initial: event_a_type,
        expected: event_b_type,
        window_ms: window_ms
    };
}
