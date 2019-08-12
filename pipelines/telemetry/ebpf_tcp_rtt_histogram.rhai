// Volute Pipeline: Linux eBPF TCP RTT Latency Histogram Accumulator
// Kernel socket tracepoint telemetry, log2 power-of-two logarithmic histogram binning,
// quantile estimation (p50, p90, p95, p99, p99.9), and jitter / bimodal anomaly detection.

// -----------------------------------------------------------------------------
// Power-of-Two Logarithmic Slot Math
// -----------------------------------------------------------------------------

fn log2_slot(val_us) {
    if val_us <= 1 { return 0; }
    let v = val_us;
    let slot = 0;
    while v > 1 {
        v = v / 2;
        slot = slot + 1;
        if slot >= 32 { break; }
    }
    return slot;
}

fn slot_lower_bound(slot) {
    if slot == 0 { return 0; }
    let val = 1;
    for i in 0..(slot - 1) {
        val = val * 2;
    }
    return val;
}

fn slot_upper_bound(slot) {
    let val = 1;
    for i in 0..slot {
        val = val * 2;
    }
    return val - 1;
}

// -----------------------------------------------------------------------------
// Histogram State and Accumulation
// -----------------------------------------------------------------------------

fn init_rtt_histogram() {
    let buckets = [];
    for i in 0..32 {
        buckets.push(0);
    }
    return #{
        buckets: buckets,
        total_count: 0,
        sum_us: 0.0,
        min_us: 999999999,
        max_us: 0
    };
}

fn record_rtt_sample(hist, rtt_us) {
    let slot = log2_slot(rtt_us);
    if slot < 32 {
        hist["buckets"][slot] = hist["buckets"][slot] + 1;
    }
    hist["total_count"] = hist["total_count"] + 1;
    hist["sum_us"] = hist["sum_us"] + (rtt_us * 1.0);
    
    if rtt_us < hist["min_us"] { hist["min_us"] = rtt_us; }
    if rtt_us > hist["max_us"] { hist["max_us"] = rtt_us; }
}

// -----------------------------------------------------------------------------
// Quantile Estimation via Bucket Interpolation
// -----------------------------------------------------------------------------

fn estimate_histogram_percentile(hist, percentile) {
    let n = hist["total_count"];
    if n == 0 { return 0.0; }
    
    let target_rank = (n * 1.0) * percentile;
    let cumulative = 0;
    
    for s in 0..32 {
        let count = hist["buckets"][s];
        if (cumulative + count) >= target_rank {
            let rank_in_slot = target_rank - cumulative;
            let frac = if count > 0 { rank_in_slot / (count * 1.0) } else { 0.0 };
            let low = slot_lower_bound(s) * 1.0;
            let high = slot_upper_bound(s) * 1.0;
            return low + frac * (high - low);
        }
        cumulative = cumulative + count;
    }
    
    return hist["max_us"] * 1.0;
}

fn compute_histogram_summary(hist) {
    let n = hist["total_count"];
    if n == 0 {
        return #{ count: 0, mean_us: 0.0, p50: 0.0, p90: 0.0, p95: 0.0, p99: 0.0, p99_9: 0.0 };
    }
    
    let mean_val = hist["sum_us"] / (n * 1.0);
    let p50 = estimate_histogram_percentile(hist, 0.50);
    let p90 = estimate_histogram_percentile(hist, 0.90);
    let p95 = estimate_histogram_percentile(hist, 0.95);
    let p99 = estimate_histogram_percentile(hist, 0.99);
    let p99_9 = estimate_histogram_percentile(hist, 0.999);
    
    return #{
        count: n,
        mean_us: mean_val,
        min_us: hist["min_us"],
        max_us: hist["max_us"],
        p50_us: p50,
        p90_us: p90,
        p95_us: p95,
        p99_us: p99,
        p99_9_us: p99_9,
        jitter_us: p99 - p50
    };
}

// -----------------------------------------------------------------------------
// Latency Anomaly and Tail Jitter Detection
// -----------------------------------------------------------------------------

fn evaluate_latency_anomalies(summary, service_name, timestamp) {
    let alerts = [];
    
    // Check 1: p99 Tail Latency > 100ms (100000 us)
    if summary["p99_us"] > 100000.0 {
        alerts.push(#{
            rule: "CRITICAL_KERNEL_RTT_P99_EXCEEDED",
            severity: "CRITICAL",
            service: service_name,
            p99_ms: summary["p99_us"] / 1000.0,
            threshold_ms: 100.0,
            timestamp: timestamp
        });
    }
    
    // Check 2: Severe Tail Jitter (p99 - p50 > 10x p50)
    if summary["p50_us"] > 50.0 {
        let jitter_ratio = summary["jitter_us"] / summary["p50_us"];
        if jitter_ratio > 10.0 {
            alerts.push(#{
                rule: "EXCESSIVE_LATENCY_JITTER_DISPERSION",
                severity: "HIGH",
                service: service_name,
                jitter_ratio: jitter_ratio,
                p50_us: summary["p50_us"],
                p99_us: summary["p99_us"],
                timestamp: timestamp
            });
        }
    }
    
    return alerts;
}

// -----------------------------------------------------------------------------
// Pipeline Event Handlers
// -----------------------------------------------------------------------------

fn process_rtt_sample_event(event, pipeline_state) {
    let service = event["service_name"];
    let rtt_us = event["rtt_us"];
    let timestamp = event["timestamp"];
    
    if !pipeline_state.contains("histograms") {
        pipeline_state["histograms"] = #{};
    }
    
    if !pipeline_state["histograms"].contains(service) {
        pipeline_state["histograms"][service] = init_rtt_histogram();
    }
    
    let hist = pipeline_state["histograms"][service];
    record_rtt_sample(hist, rtt_us);
    
    let alerts = [];
    // Every 50 samples evaluate anomaly summary
    if hist["total_count"] % 50 == 0 {
        let summary = compute_histogram_summary(hist);
        alerts = evaluate_latency_anomalies(summary, service, timestamp);
    }
    
    return #{
        status: "OK",
        service: service,
        samples: hist["total_count"],
        alerts: alerts
    };
}
