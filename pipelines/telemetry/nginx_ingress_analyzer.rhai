/*
 * Nginx Ingress Controller Stream Telemetry Analyzer
 *
 * Computes rolling p95 latency, 5xx error rate spikes, and upstream health.
 */

import "lib/stats/descriptive" as desc;

// Initialize ingress monitor
fn new_ingress_monitor() {
    return #{
        latencies: [],
        total_requests: 0,
        errors_5xx: 0
    };
}

// Record request metrics into monitor; returns updated monitor
fn record_request(monitor, status_code, request_time_ms) {
    monitor.total_requests += 1;
    if status_code >= 500 && status_code < 600 {
        monitor.errors_5xx += 1;
    }
    monitor.latencies.push(request_time_ms * 1.0);
    return monitor;
}

// Compute snapshot summary
fn get_ingress_summary(monitor) {
    if monitor.total_requests == 0 {
        return #{
            total_requests: 0,
            error_rate_5xx: 0.0,
            latency_p50_ms: 0.0,
            latency_p95_ms: 0.0
        };
    }

    let p50 = desc::quantile(monitor.latencies, 0.50);
    let p95 = desc::quantile(monitor.latencies, 0.95);
    let err_rate = (monitor.errors_5xx * 1.0) / (monitor.total_requests * 1.0);

    return #{
        total_requests: monitor.total_requests,
        error_rate_5xx: err_rate,
        latency_p50_ms: p50,
        latency_p95_ms: p95
    };
}
