// Volute Pipeline: Distributed Tracing Sampler & Critical Path Analyzer
// W3C TraceContext (traceparent and tracestate) parser, Span Tree DAG assembly,
// critical-path latency bottleneck isolation, and intelligent tail-based trace sampling.

// -----------------------------------------------------------------------------
// W3C TraceContext Parsing (traceparent and tracestate)
// -----------------------------------------------------------------------------

fn parse_w3c_traceparent(header_val) {
    let clean = header_val.trim();
    let parts = clean.split("-");
    if parts.len() != 4 {
        return #{ is_valid: false, error: "MALFORMED_TRACEPARENT_DELIMITERS" };
    }
    
    let version = parts[0];
    let trace_id = parts[1];
    let parent_id = parts[2];
    let flags_str = parts[3];
    
    if version != "00" {
        return #{ is_valid: false, error: "UNSUPPORTED_W3C_VERSION: " + version };
    }
    if trace_id.len() != 32 || trace_id == "00000000000000000000000000000000" {
        return #{ is_valid: false, error: "INVALID_TRACE_ID" };
    }
    if parent_id.len() != 16 || parent_id == "0000000000000000" {
        return #{ is_valid: false, error: "INVALID_PARENT_ID" };
    }
    if flags_str.len() != 2 {
        return #{ is_valid: false, error: "INVALID_FLAGS_LENGTH" };
    }
    
    // Check sampled flag (least significant bit of byte)
    let is_sampled = flags_str == "01" || flags_str.ends_with("1") || flags_str.ends_with("3") || flags_str.ends_with("5") || flags_str.ends_with("7") || flags_str.ends_with("9") || flags_str.ends_with("b") || flags_str.ends_with("d") || flags_str.ends_with("f");
    
    return #{
        is_valid: true,
        version: version,
        trace_id: trace_id,
        parent_id: parent_id,
        flags: flags_str,
        is_sampled: is_sampled
    };
}

fn parse_w3c_tracestate(header_val) {
    let state_map = #{};
    let clean = header_val.trim();
    if clean.is_empty() { return state_map; }
    
    let pairs = clean.split(",");
    for pair in pairs {
        let trimmed_pair = pair.trim();
        let kv = trimmed_pair.split("=");
        if kv.len() == 2 {
            state_map[kv[0].trim()] = kv[1].trim();
        }
    }
    return state_map;
}

// -----------------------------------------------------------------------------
// Span Representation and Helpers
// -----------------------------------------------------------------------------

fn create_span(trace_id, span_id, parent_span_id, name, service, kind, start_time_ns, end_time_ns, status_code, attributes) {
    let duration_ns = end_time_ns - start_time_ns;
    let duration_ms = (duration_ns * 1.0) / 1000000.0;
    
    return #{
        trace_id: trace_id,
        span_id: span_id,
        parent_span_id: parent_span_id,
        name: name,
        service: service,
        kind: kind,
        start_time_ns: start_time_ns,
        end_time_ns: end_time_ns,
        duration_ms: duration_ms,
        status_code: status_code, // "OK", "ERROR", "UNSET"
        attributes: attributes
    };
}

// -----------------------------------------------------------------------------
// Span Tree Assembly and Critical Path Analysis
// -----------------------------------------------------------------------------

fn build_trace_tree(spans) {
    let root_span = ();
    let children_by_parent = #{};
    let span_by_id = #{};
    
    for s in spans {
        let sid = s["span_id"];
        let pid = s["parent_span_id"];
        span_by_id[sid] = s;
        
        if pid.is_empty() || pid == "0000000000000000" {
            root_span = s;
        } else {
            if !children_by_parent.contains(pid) {
                children_by_parent[pid] = [];
            }
            let children = children_by_parent[pid];
            children.push(s);
            children_by_parent[pid] = children;
        }
    }
    
    return #{
        root: root_span,
        children_map: children_by_parent,
        span_map: span_by_id
    };
}

fn find_critical_path(tree) {
    let critical_path = [];
    let curr = tree["root"];
    if curr == () { return critical_path; }
    
    critical_path.push(curr);
    let children_map = tree["children_map"];
    
    while children_map.contains(curr["span_id"]) {
        let children = children_map[curr["span_id"]];
        if children.len() == 0 { break; }
        
        // Select child with largest duration
        let max_child = children[0];
        let max_dur = max_child["duration_ms"];
        for c in children {
            if c["duration_ms"] > max_dur {
                max_dur = c["duration_ms"];
                max_child = c;
            }
        }
        critical_path.push(max_child);
        curr = max_child;
    }
    
    return critical_path;
}

fn analyze_latency_bottleneck(critical_path) {
    if critical_path.len() == 0 {
        return #{ bottleneck_found: false };
    }
    
    let root_span = critical_path[0];
    let total_duration = root_span["duration_ms"];
    let max_span = critical_path[0];
    let max_dur = 0.0;
    
    for s in critical_path {
        if s["duration_ms"] > max_dur {
            max_dur = s["duration_ms"];
            max_span = s;
        }
    }
    
    let contribution_pct = if total_duration > 0.0 { (max_dur / total_duration) * 100.0 } else { 0.0 };
    
    return #{
        bottleneck_found: true,
        bottleneck_span_id: max_span["span_id"],
        service: max_span["service"],
        operation: max_span["name"],
        duration_ms: max_dur,
        total_trace_duration_ms: total_duration,
        contribution_percent: contribution_pct
    };
}

// -----------------------------------------------------------------------------
// Tail-based Sampling Rules
// -----------------------------------------------------------------------------

fn evaluate_tail_sampling_decision(spans, latency_threshold_ms) {
    let should_sample = false;
    let sampling_reasons = [];
    
    for s in spans {
        // Rule 1: Always sample traces with Error spans or HTTP 5xx status
        if s["status_code"] == "ERROR" {
            should_sample = true;
            sampling_reasons.push("ERROR_STATUS_IN_SPAN: " + s["name"] + "@" + s["service"]);
        }
        if s["attributes"].contains("http.status_code") {
            let status_num = s["attributes"]["http.status_code"];
            if status_num >= 500 {
                should_sample = true;
                sampling_reasons.push("HTTP_5XX_ERROR: " + status_num.to_string());
            }
        }
        
        // Rule 2: Latency threshold exceedance
        if s["duration_ms"] >= latency_threshold_ms {
            should_sample = true;
            sampling_reasons.push("LATENCY_THRESHOLD_EXCEEDED: " + s["duration_ms"].to_string() + "ms");
        }
        
        // Rule 3: Database slow query attribute
        if s["attributes"].contains("db.statement") && s["duration_ms"] > 300.0 {
            should_sample = true;
            sampling_reasons.push("SLOW_DATABASE_QUERY: " + s["name"]);
        }
        
        // Rule 4: Critical Business Flow / Payment route
        if s["attributes"].contains("http.route") {
            let route = s["attributes"]["http.route"];
            if route.contains("/checkout") || route.contains("/payment") || route.contains("/transfer") {
                should_sample = true;
                sampling_reasons.push("CRITICAL_BUSINESS_ENDPOINT: " + route);
            }
        }
    }
    
    return #{
        sampled: should_sample,
        reasons: sampling_reasons
    };
}

// -----------------------------------------------------------------------------
// Pipeline Event Handlers
// -----------------------------------------------------------------------------

fn process_trace_event(event, sampler_state) {
    let spans = event["spans"];
    let latency_cutoff = if sampler_state.contains("latency_cutoff_ms") { sampler_state["latency_cutoff_ms"] } else { 800.0 };
    
    let sampling_decision = evaluate_tail_sampling_decision(spans, latency_cutoff);
    let tree = build_trace_tree(spans);
    let critical_path = find_critical_path(tree);
    let bottleneck = analyze_latency_bottleneck(critical_path);
    
    return #{
        trace_id: if spans.len() > 0 { spans[0]["trace_id"] } else { "" },
        total_spans: spans.len(),
        sampled: sampling_decision["sampled"],
        sampling_reasons: sampling_decision["reasons"],
        critical_path_length: critical_path.len(),
        bottleneck: bottleneck
    };
}
