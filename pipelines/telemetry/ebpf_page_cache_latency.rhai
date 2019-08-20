// Volute Pipeline: Linux eBPF Virtual Memory & Page Cache Latency Tracer
// mm_filemap kernel tracepoint parsing, page cache dirty ratio tracking, major/minor fault ratios,
// direct memory reclaim stall detection, and synchronous disk writeback alerts.

// -----------------------------------------------------------------------------
// Page Cache State Tracker
// -----------------------------------------------------------------------------

fn init_page_cache_state() {
    return #{
        cached_pages: 0,
        dirty_pages: 0,
        writeback_pages: 0,
        minor_faults_total: 0,
        major_faults_total: 0,
        direct_reclaim_events: 0,
        reclaim_stall_time_us: 0.0
    };
}

fn update_memory_counters(state, mem_info) {
    state["cached_pages"] = mem_info["cached_pages"];
    state["dirty_pages"] = mem_info["dirty_pages"];
    state["writeback_pages"] = mem_info["writeback_pages"];
    state["minor_faults_total"] = state["minor_faults_total"] + mem_info["minor_faults_delta"];
    state["major_faults_total"] = state["major_faults_total"] + mem_info["major_faults_delta"];
}

// -----------------------------------------------------------------------------
// Ratio Analysis & Latency Anomaly Evaluators
// -----------------------------------------------------------------------------

fn calc_dirty_page_ratio(dirty_pages, total_cached_pages) {
    if total_cached_pages <= 0 { return 0.0; }
    return ((dirty_pages * 1.0) / (total_cached_pages * 1.0)) * 100.0;
}

fn calc_major_fault_percentage(major_delta, minor_delta) {
    let total = major_delta + minor_delta;
    if total <= 0 { return 0.0; }
    return ((major_delta * 1.0) / (total * 1.0)) * 100.0;
}

fn evaluate_page_cache_anomalies(state, reclaim_event, timestamp) {
    let alerts = [];
    
    // Check 1: High Dirty Ratio (Risk of kernel throttling synchronous flush)
    let dirty_pct = calc_dirty_page_ratio(state["dirty_pages"], state["cached_pages"]);
    if dirty_pct >= 20.0 {
        alerts.push(#{
            rule: "PAGE_CACHE_DIRTY_RATIO_EXCEEDED",
            severity: "HIGH",
            dirty_ratio_pct: dirty_pct,
            dirty_pages: state["dirty_pages"],
            threshold_pct: 20.0,
            timestamp: timestamp
        });
    }
    
    // Check 2: Direct Reclaim Stall (Synchronous memory allocation blockage)
    if reclaim_event.contains("duration_us") {
        let dur = reclaim_event["duration_us"];
        if dur > 10000.0 { // > 10ms spent in direct reclaim
            alerts.push(#{
                rule: "KERNEL_DIRECT_RECLAIM_STALL",
                severity: "CRITICAL",
                stall_ms: dur / 1000.0,
                nr_reclaimed: reclaim_event["nr_reclaimed"],
                order: reclaim_event["order"],
                timestamp: timestamp
            });
            state["direct_reclaim_events"] = state["direct_reclaim_events"] + 1;
            state["reclaim_stall_time_us"] = state["reclaim_stall_time_us"] + dur;
        }
    }
    
    // Check 3: Major Page Fault Storm (> 500 disk faults/sec)
    if reclaim_event.contains("major_faults_delta") && reclaim_event["major_faults_delta"] > 500 {
        alerts.push(#{
            rule: "MAJOR_PAGE_FAULT_DISK_THRASHING",
            severity: "HIGH",
            major_faults: reclaim_event["major_faults_delta"],
            timestamp: timestamp
        });
    }
    
    return alerts;
}

// -----------------------------------------------------------------------------
// Pipeline Event Handlers
// -----------------------------------------------------------------------------

fn process_vm_telemetry(event, pipeline_state) {
    if !pipeline_state.contains("vm_state") {
        pipeline_state["vm_state"] = init_page_cache_state();
    }
    
    let mem_info = event["memory_info"];
    let timestamp = event["timestamp"];
    update_memory_counters(pipeline_state["vm_state"], mem_info);
    
    let reclaim_ev = if event.contains("reclaim") { event["reclaim"] } else { #{} };
    let alerts = evaluate_page_cache_anomalies(pipeline_state["vm_state"], reclaim_ev, timestamp);
    
    return #{
        status: "OK",
        timestamp: timestamp,
        dirty_ratio_pct: calc_dirty_page_ratio(pipeline_state["vm_state"]["dirty_pages"], pipeline_state["vm_state"]["cached_pages"]),
        total_minor_faults: pipeline_state["vm_state"]["minor_faults_total"],
        total_major_faults: pipeline_state["vm_state"]["major_faults_total"],
        alerts: alerts
    };
}
