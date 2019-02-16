/*
 * Descriptive Statistics and Distribution Metrics
 *
 * Implements sample moments, quantiles, dispersion, and shape parameters.
 */

// Compute arithmetic mean of numerical array
fn mean(arr) {
    if arr.is_empty() {
        return 0.0;
    }
    let sum = 0.0;
    for x in arr {
        sum += x * 1.0;
    }
    return sum / (arr.len() * 1.0);
}

// Compute sample variance using two-pass algorithm for numerical stability
fn variance(arr) {
    if arr.len() < 2 {
        return 0.0;
    }
    let m = mean(arr);
    let sum_sq = 0.0;
    for x in arr {
        let diff = (x * 1.0) - m;
        sum_sq += diff * diff;
    }
    return sum_sq / ((arr.len() - 1) * 1.0);
}

// Compute sample standard deviation
fn stddev(arr) {
    return variance(arr).sqrt();
}

// Compute population variance
fn population_variance(arr) {
    if arr.is_empty() {
        return 0.0;
    }
    let m = mean(arr);
    let sum_sq = 0.0;
    for x in arr {
        let diff = (x * 1.0) - m;
        sum_sq += diff * diff;
    }
    return sum_sq / (arr.len() * 1.0);
}

// Compute median using simple selection
fn median(arr) {
    if arr.is_empty() {
        return 0.0;
    }
    let sorted = arr;
    sorted.sort();
    let n = sorted.len();
    if n % 2 == 1 {
        return sorted[n / 2] * 1.0;
    }
    let m1 = sorted[(n / 2) - 1] * 1.0;
    let m2 = sorted[n / 2] * 1.0;
    return (m1 + m2) / 2.0;
}

// Compute estimated quantile p in range [0.0, 1.0]
fn quantile(arr, p) {
    if arr.is_empty() {
        return 0.0;
    }
    if p <= 0.0 {
        let sorted = arr;
        sorted.sort();
        return sorted[0] * 1.0;
    }
    if p >= 1.0 {
        let sorted = arr;
        sorted.sort();
        return sorted[sorted.len() - 1] * 1.0;
    }
    let sorted = arr;
    sorted.sort();
    let idx = p * ((sorted.len() - 1) * 1.0);
    let low = idx.to_int();
    let high = low + 1;
    let weight = idx - (low * 1.0);
    if high >= sorted.len() {
        return sorted[low] * 1.0;
    }
    return (sorted[low] * 1.0) * (1.0 - weight) + (sorted[high] * 1.0) * weight;
}

// Interquartile range (IQR = Q3 - Q1)
fn iqr(arr) {
    let q1 = quantile(arr, 0.25);
    let q3 = quantile(arr, 0.75);
    return q3 - q1;
}

// Sample skewness (third standardized moment)
fn skewness(arr) {
    if arr.len() < 3 {
        return 0.0;
    }
    let m = mean(arr);
    let s = stddev(arr);
    if s == 0.0 {
        return 0.0;
    }
    let n = arr.len() * 1.0;
    let sum_cube = 0.0;
    for x in arr {
        let z = ((x * 1.0) - m) / s;
        sum_cube += z * z * z;
    }
    let factor = (n / ((n - 1.0) * (n - 2.0)));
    return factor * sum_cube;
}

// Sample excess kurtosis (fourth standardized moment - 3)
fn excess_kurtosis(arr) {
    if arr.len() < 4 {
        return 0.0;
    }
    let m = mean(arr);
    let s = stddev(arr);
    if s == 0.0 {
        return 0.0;
    }
    let n = arr.len() * 1.0;
    let sum_quad = 0.0;
    for x in arr {
        let z = ((x * 1.0) - m) / s;
        sum_quad += z * z * z * z;
    }
    let term1 = (n * (n + 1.0)) / ((n - 1.0) * (n - 2.0) * (n - 3.0));
    let term2 = (3.0 * (n - 1.0) * (n - 1.0)) / ((n - 2.0) * (n - 3.0));
    return (term1 * sum_quad) - term2;
}
