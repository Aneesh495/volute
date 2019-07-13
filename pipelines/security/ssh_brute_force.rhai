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

// Process authentication event; returns [updated_state, alert_or_unit]
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
            state.attempts[ip] = [];
            let alert = #{
                alert: "CRITICAL_AUTH_AFTER_BRUTE_FORCE",
                source_ip: ip,
                recent_failures: recent.len(),
                severity: "CRITICAL",
                action: "INVESTIGATE"
            };
            return [state, alert];
        }
        state.attempts[ip] = recent;
        return [state, ()];
    } else {
        recent.push(now_ms);
        state.attempts[ip] = recent;

        if recent.len() >= state.threshold {
            let alert = #{
                alert: "SSH_BRUTE_FORCE_DETECTED",
                source_ip: ip,
                failures_count: recent.len(),
                severity: "HIGH",
                action: "TEMPORARY_BLOCK"
            };
            return [state, alert];
        }
        return [state, ()];
    }
}
