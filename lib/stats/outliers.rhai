/*
 * Anomaly and Outlier Detection Algorithms
 *
 * Implements Z-Score, Modified Z-Score (MAD), Tukey Fences, and IQR boundaries.
 */

// Compute Z-score for value given population mean and standard deviation
fn z_score(val, mean_val, stddev_val) {
    if stddev_val == 0.0 {
        return 0.0;
    }
    return ((val * 1.0) - mean_val) / stddev_val;
}

// Check if value exceeds Z-score threshold
fn is_z_outlier(val, mean_val, stddev_val, threshold) {
    let z = z_score(val, mean_val, stddev_val);
    let abs_z = if z < 0.0 { -z } else { z };
    return abs_z > threshold;
}

// Compute Median Absolute Deviation (MAD)
fn mad(arr, median_val) {
    if arr.is_empty() {
        return 0.0;
    }
    let diffs = [];
    for x in arr {
        let diff = (x * 1.0) - median_val;
        let abs_diff = if diff < 0.0 { -diff } else { diff };
        diffs.push(abs_diff);
    }
    diffs.sort();
    let n = diffs.len();
    if n % 2 == 1 {
        return diffs[n / 2];
    }
    return (diffs[(n / 2) - 1] + diffs[n / 2]) / 2.0;
}

// Modified Z-score using MAD: 0.6745 * (x - median) / MAD
fn modified_z_score(val, med, mad_val) {
    if mad_val == 0.0 {
        return 0.0;
    }
    let diff = (val * 1.0) - med;
    return 0.6745 * diff / mad_val;
}

// Compute Tukey fences boundaries [lower_fence, upper_fence]
fn tukey_fences(q1, q3, multiplier) {
    let iqr_val = q3 - q1;
    let lower = q1 - multiplier * iqr_val;
    let upper = q3 + multiplier * iqr_val;
    return [lower, upper];
}

// Check if value falls outside Tukey boundaries
fn is_tukey_outlier(val, q1, q3, multiplier) {
    let fences = tukey_fences(q1, q3, multiplier);
    let v = val * 1.0;
    return v < fences[0] || v > fences[1];
}
