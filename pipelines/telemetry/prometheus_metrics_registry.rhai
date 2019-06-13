/*
 * Infrastructure and Runtime Prometheus Metrics Taxonomy Registry
 *
 * Standardizes metric names, types, labels, and description metadata.
 */

// Return metric descriptor
fn get_metric_descriptor(metric_name) {
    let reg = #{};
    reg["node_cpu_seconds_total"] = #{ name: "node_cpu_seconds_total", kind: "counter", help: "Seconds the CPUs spent in each mode", labels: ["cpu", "mode"] };
    reg["node_memory_MemTotal_bytes"] = #{ name: "node_memory_MemTotal_bytes", kind: "gauge", help: "Memory information field MemTotal_bytes", labels: ["instance"] };
    reg["node_memory_MemFree_bytes"] = #{ name: "node_memory_MemFree_bytes", kind: "gauge", help: "Memory information field MemFree_bytes", labels: ["instance"] };
    reg["node_memory_MemAvailable_bytes"] = #{ name: "node_memory_MemAvailable_bytes", kind: "gauge", help: "Memory information field MemAvailable_bytes", labels: ["instance"] };
    reg["node_disk_read_bytes_total"] = #{ name: "node_disk_read_bytes_total", kind: "counter", help: "Total number of bytes read successfully", labels: ["device"] };
    reg["node_disk_written_bytes_total"] = #{ name: "node_disk_written_bytes_total", kind: "counter", help: "Total number of bytes written successfully", labels: ["device"] };
    reg["node_network_receive_bytes_total"] = #{ name: "node_network_receive_bytes_total", kind: "counter", help: "Network device traffic bytes received", labels: ["device"] };
    reg["node_network_transmit_bytes_total"] = #{ name: "node_network_transmit_bytes_total", kind: "counter", help: "Network device traffic bytes transmitted", labels: ["device"] };
    reg["container_cpu_usage_seconds_total"] = #{ name: "container_cpu_usage_seconds_total", kind: "counter", help: "Cumulative cpu time consumed in seconds", labels: ["container", "pod", "namespace"] };
    reg["container_memory_working_set_bytes"] = #{ name: "container_memory_working_set_bytes", kind: "gauge", help: "Current working set in bytes", labels: ["container", "pod", "namespace"] };
    reg["container_fs_reads_bytes_total"] = #{ name: "container_fs_reads_bytes_total", kind: "counter", help: "Cumulative count of bytes read from filesystem", labels: ["container", "pod"] };
    reg["container_fs_writes_bytes_total"] = #{ name: "container_fs_writes_bytes_total", kind: "counter", help: "Cumulative count of bytes written to filesystem", labels: ["container", "pod"] };
    reg["http_requests_total"] = #{ name: "http_requests_total", kind: "counter", help: "Total number of HTTP requests processed", labels: ["method", "handler", "status"] };
    reg["http_request_duration_seconds"] = #{ name: "http_request_duration_seconds", kind: "histogram", help: "Histogram of response latency in seconds", labels: ["method", "handler", "status"] };
    reg["jvm_memory_used_bytes"] = #{ name: "jvm_memory_used_bytes", kind: "gauge", help: "Current memory allocation in bytes", labels: ["area", "id"] };
    reg["jvm_gc_pause_seconds_total"] = #{ name: "jvm_gc_pause_seconds_total", kind: "counter", help: "Time spent in GC pause", labels: ["action", "cause"] };
    reg["process_resident_memory_bytes"] = #{ name: "process_resident_memory_bytes", kind: "gauge", help: "Resident memory size in bytes", labels: ["pid"] };
    reg["process_cpu_seconds_total"] = #{ name: "process_cpu_seconds_total", kind: "counter", help: "Total user and system CPU time spent in seconds", labels: ["pid"] };
    reg["go_goroutines"] = #{ name: "go_goroutines", kind: "gauge", help: "Number of goroutines currently existing", labels: ["instance"] };
    reg["go_gc_duration_seconds"] = #{ name: "go_gc_duration_seconds", kind: "summary", help: "Summary of GC invocation durations", labels: ["instance"] };
    if reg.contains(metric_name) {
        return reg[metric_name];
    }
    return #{ name: metric_name, kind: "untyped", help: "Custom user metric", labels: [] };
}

// Format sample as Prometheus exposition text line
fn format_prometheus_sample(name, labels_map, value, timestamp_ms) {
    let out = name;
    if !labels_map.is_empty() {
        let pairs = [];
        for k in labels_map.keys() {
            pairs.push(k + "=\"" + labels_map[k].to_string() + "\"");
        }
        let lbl_body = "";
        for idx in 0..pairs.len() {
            if idx > 0 { lbl_body += ","; }
            lbl_body += pairs[idx];
        }
        out += "{" + lbl_body + "}";
    }
    out += " " + value.to_string();
    if timestamp_ms > 0 {
        out += " " + timestamp_ms.to_string();
    }
    return out;
}
// Validate node_cpu_seconds_total
fn validate_metric_nodecpusecondstotal(sample) {
    if !sample.contains("name") || sample["name"] != "node_cpu_seconds_total" { return false; }
    if !sample.contains("value") { return false; }
    return true;
}

// Validate node_memory_MemTotal_bytes
fn validate_metric_nodememoryMemTotalbytes(sample) {
    if !sample.contains("name") || sample["name"] != "node_memory_MemTotal_bytes" { return false; }
    if !sample.contains("value") { return false; }
    return true;
}

// Validate node_memory_MemFree_bytes
fn validate_metric_nodememoryMemFreebytes(sample) {
    if !sample.contains("name") || sample["name"] != "node_memory_MemFree_bytes" { return false; }
    if !sample.contains("value") { return false; }
    return true;
}

// Validate node_memory_MemAvailable_bytes
fn validate_metric_nodememoryMemAvailablebytes(sample) {
    if !sample.contains("name") || sample["name"] != "node_memory_MemAvailable_bytes" { return false; }
    if !sample.contains("value") { return false; }
    return true;
}

// Validate node_disk_read_bytes_total
fn validate_metric_nodediskreadbytestotal(sample) {
    if !sample.contains("name") || sample["name"] != "node_disk_read_bytes_total" { return false; }
    if !sample.contains("value") { return false; }
    return true;
}

// Validate node_disk_written_bytes_total
fn validate_metric_nodediskwrittenbytestotal(sample) {
    if !sample.contains("name") || sample["name"] != "node_disk_written_bytes_total" { return false; }
    if !sample.contains("value") { return false; }
    return true;
}

// Validate node_network_receive_bytes_total
fn validate_metric_nodenetworkreceivebytestotal(sample) {
    if !sample.contains("name") || sample["name"] != "node_network_receive_bytes_total" { return false; }
    if !sample.contains("value") { return false; }
    return true;
}

// Validate node_network_transmit_bytes_total
fn validate_metric_nodenetworktransmitbytestotal(sample) {
    if !sample.contains("name") || sample["name"] != "node_network_transmit_bytes_total" { return false; }
    if !sample.contains("value") { return false; }
    return true;
}

// Validate container_cpu_usage_seconds_total
fn validate_metric_containercpuusagesecondstotal(sample) {
    if !sample.contains("name") || sample["name"] != "container_cpu_usage_seconds_total" { return false; }
    if !sample.contains("value") { return false; }
    return true;
}

// Validate container_memory_working_set_bytes
fn validate_metric_containermemoryworkingsetbytes(sample) {
    if !sample.contains("name") || sample["name"] != "container_memory_working_set_bytes" { return false; }
    if !sample.contains("value") { return false; }
    return true;
}

// Validate container_fs_reads_bytes_total
fn validate_metric_containerfsreadsbytestotal(sample) {
    if !sample.contains("name") || sample["name"] != "container_fs_reads_bytes_total" { return false; }
    if !sample.contains("value") { return false; }
    return true;
}

// Validate container_fs_writes_bytes_total
fn validate_metric_containerfswritesbytestotal(sample) {
    if !sample.contains("name") || sample["name"] != "container_fs_writes_bytes_total" { return false; }
    if !sample.contains("value") { return false; }
    return true;
}

// Validate http_requests_total
fn validate_metric_httprequeststotal(sample) {
    if !sample.contains("name") || sample["name"] != "http_requests_total" { return false; }
    if !sample.contains("value") { return false; }
    return true;
}

// Validate http_request_duration_seconds
fn validate_metric_httprequestdurationseconds(sample) {
    if !sample.contains("name") || sample["name"] != "http_request_duration_seconds" { return false; }
    if !sample.contains("value") { return false; }
    return true;
}

// Validate jvm_memory_used_bytes
fn validate_metric_jvmmemoryusedbytes(sample) {
    if !sample.contains("name") || sample["name"] != "jvm_memory_used_bytes" { return false; }
    if !sample.contains("value") { return false; }
    return true;
}

// Validate jvm_gc_pause_seconds_total
fn validate_metric_jvmgcpausesecondstotal(sample) {
    if !sample.contains("name") || sample["name"] != "jvm_gc_pause_seconds_total" { return false; }
    if !sample.contains("value") { return false; }
    return true;
}

// Validate process_resident_memory_bytes
fn validate_metric_processresidentmemorybytes(sample) {
    if !sample.contains("name") || sample["name"] != "process_resident_memory_bytes" { return false; }
    if !sample.contains("value") { return false; }
    return true;
}

// Validate process_cpu_seconds_total
fn validate_metric_processcpusecondstotal(sample) {
    if !sample.contains("name") || sample["name"] != "process_cpu_seconds_total" { return false; }
    if !sample.contains("value") { return false; }
    return true;
}

// Validate go_goroutines
fn validate_metric_gogoroutines(sample) {
    if !sample.contains("name") || sample["name"] != "go_goroutines" { return false; }
    if !sample.contains("value") { return false; }
    return true;
}

// Validate go_gc_duration_seconds
fn validate_metric_gogcdurationseconds(sample) {
    if !sample.contains("name") || sample["name"] != "go_gc_duration_seconds" { return false; }
    if !sample.contains("value") { return false; }
    return true;
}
