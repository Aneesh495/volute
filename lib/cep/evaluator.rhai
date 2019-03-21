/*
 * Streaming Complex Event Processing (CEP) Match Evaluator
 *
 * Evaluates event streams against temporal patterns and emits correlation alerts.
 */

// Initialize CEP engine instance
fn new_cep_engine() {
    return #{
        patterns: [],
        partial_matches: [],
        alerts: []
    };
}

// Register pattern into CEP engine
fn register_pattern(engine, pattern) {
    engine.patterns.push(pattern);
}

// Process single event through CEP engine
fn process_event(engine, event) {
    let now_ms = event.timestamp_ns / 1000000;
    let new_alerts = [];

    // 1. Check existing partial matches
    let active_matches = [];
    for cand in engine.partial_matches {
        if now_ms - cand.start_time_ms > cand.window_ms {
            continue; // expired
        }
        if cand.kind == "followed_by" && event.topic == cand.second {
            new_alerts.push(#{
                pattern: "followed_by",
                first_event: cand.first_event,
                second_event: event,
                elapsed_ms: now_ms - cand.start_time_ms
            });
        } else {
            active_matches.push(cand);
        }
    }
    engine.partial_matches = active_matches;

    // 2. Initiate new potential matches
    for pat in engine.patterns {
        if pat.kind == "followed_by" && event.topic == pat.first {
            engine.partial_matches.push(#{
                kind: "followed_by",
                first: pat.first,
                second: pat.second,
                window_ms: pat.window_ms,
                start_time_ms: now_ms,
                first_event: event
            });
        }
    }

    return new_alerts;
}
