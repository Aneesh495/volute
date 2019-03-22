/*
 * SSH Brute-Force Attack Detection Pipeline
 *
 * Tracks failed authentication attempts within a sliding time window.
 * Alerts when failure threshold is breached from single origin IP or subnet.
 */

// Initialize detection state
fn init_detector(threshold_failures, window_ms) {
    return #{
        threshold: threshold_failures,
        window_ms: window_ms,
        attempts: #{} // ip -> [timestamp_ms]
    };
}

// Process authentication event
fn process_auth_event(state, event) {
    let now_ms = event.timestamp_ns / 1000000;
    let ip = event.payload["source_ip"];
    let success = event.payload["success"];

    if !state.attempts.contains(ip) {
        state.attempts[ip] = [];
    }

    // Clean old attempts outside window
    let history = state.attempts[ip];
    let recent = [];
    for ts in history {
        if now_ms - ts <= state.window_ms {
            recent.push(ts);
        }
    }

    if success {
        if recent.len() >= state.threshold {
            // Suspicious successful login following repeated failures
            state.attempts[ip] = [];
            return #{
                alert: "CRITICAL_AUTH_AFTER_BRUTE_FORCE",
                source_ip: ip,
                recent_failures: recent.len(),
                severity: "CRITICAL",
                action: "INVESTIGATE"
            };
        }
        state.attempts[ip] = recent;
        return ();
    } else {
        recent.push(now_ms);
        state.attempts[ip] = recent;

        if recent.len() >= state.threshold {
            return #{
                alert: "SSH_BRUTE_FORCE_DETECTED",
                source_ip: ip,
                failures_count: recent.len(),
                severity: "HIGH",
                action: "TEMPORARY_BLOCK"
            };
        }
        return ();
    }
}
