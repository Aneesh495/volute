/*
 * High-resolution Time and Duration Formatting Library
 *
 * Implements interval bucket calculations, humanized elapsed strings,
 * epoch conversions, and duration arithmetic.
 */

// Format milliseconds as human-readable string
fn humanize_duration_ms(ms) {
    if ms < 1000 {
        return ms.to_string() + "ms";
    }
    let sec = ms / 1000;
    if sec < 60 {
        let frac = ms % 1000;
        return sec.to_string() + "." + (frac / 100).to_string() + "s";
    }
    let min = sec / 60;
    let rem_sec = sec % 60;
    if min < 60 {
        return min.to_string() + "m " + rem_sec.to_string() + "s";
    }
    let hr = min / 60;
    let rem_min = min % 60;
    return hr.to_string() + "h " + rem_min.to_string() + "m";
}

// Calculate sliding window bucket index for given timestamp
fn bucket_index(timestamp_ms, bucket_size_ms) {
    if bucket_size_ms <= 0 {
        return 0;
    }
    return timestamp_ms / bucket_size_ms;
}

// Align timestamp to start of window bucket
fn align_to_bucket(timestamp_ms, bucket_size_ms) {
    if bucket_size_ms <= 0 {
        return timestamp_ms;
    }
    let idx = timestamp_ms / bucket_size_ms;
    return idx * bucket_size_ms;
}

// Check if timestamp falls within start and end boundaries
fn is_in_range(ts, start_ts, end_ts) {
    return ts >= start_ts && ts <= end_ts;
}

// Difference between two epoch timestamps in seconds
fn diff_seconds(start_ms, end_ms) {
    return (end_ms - start_ms) / 1000;
}

// Difference between two epoch timestamps in minutes
fn diff_minutes(start_ms, end_ms) {
    return (end_ms - start_ms) / (1000 * 60);
}

// Difference between two epoch timestamps in hours
fn diff_hours(start_ms, end_ms) {
    return (end_ms - start_ms) / (1000 * 3600);
}

// Estimate rate per second over interval
fn calculate_rate_per_sec(count, duration_ms) {
    if duration_ms <= 0 {
        return 0.0;
    }
    return (count * 1000.0) / duration_ms;
}
