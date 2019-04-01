/*
 * Kubernetes Container Log Enrichment Pipeline
 *
 * Normalizes log level, extracts stack traces, and tags pod namespace.
 */

fn enrich_k8s_log(event) {
    let raw_msg = event.payload["log"];
    let level = "INFO";

    let upper = raw_msg.to_upper();
    if upper.contains("ERROR") || upper.contains("FATAL") || upper.contains("EXCEPTION") {
        level = "ERROR";
    } else if upper.contains("WARN") {
        level = "WARN";
    } else if upper.contains("DEBUG") {
        level = "DEBUG";
    }

    event.payload["level"] = level;
    event.payload["has_stack_trace"] = upper.contains("AT ") || upper.contains("TRACEBACK");
    event.payload["cluster"] = "prod-east";
    return event;
}
