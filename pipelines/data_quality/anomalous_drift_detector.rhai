// Volute Pipeline: Anomalous Data & Feature Drift Detector
// Streaming Population Stability Index (PSI), Kolmogorov-Smirnov (KS) two-sample divergence,
// Jensen-Shannon Divergence (JSD), and Wasserstein distance for continuous model monitoring.

import "lib/core/math" as m;

// -----------------------------------------------------------------------------
// Basic Sorting and Quantile Utilities
// -----------------------------------------------------------------------------

fn sort_float_array(arr) {
    let len = arr.len();
    if len <= 1 { return arr; }
    let pivot = arr[len / 2];
    let left = [];
    let middle = [];
    let right = [];
    for x in arr {
        if x < pivot {
            left.push(x);
        } else if x > pivot {
            right.push(x);
        } else {
            middle.push(x);
        }
    }
    let res = sort_float_array(left);
    for m_val in middle { res.push(m_val); }
    let r_sorted = sort_float_array(right);
    for r_val in r_sorted { res.push(r_val); }
    return res;
}

fn compute_quantile(sorted_arr, q) {
    let n = sorted_arr.len();
    if n == 0 { return 0.0; }
    if q <= 0.0 { return sorted_arr[0]; }
    if q >= 1.0 { return sorted_arr[n - 1]; }
    
    let pos = (n - 1) * q;
    let idx = pos.to_int();
    let frac = pos - idx;
    
    if idx + 1 < n {
        return sorted_arr[idx] * (1.0 - frac) + sorted_arr[idx + 1] * frac;
    } else {
        return sorted_arr[idx];
    }
}

// -----------------------------------------------------------------------------
// Population Stability Index (PSI)
// -----------------------------------------------------------------------------

fn build_quantile_bins(reference_sample, num_bins) {
    let sorted = sort_float_array(reference_sample);
    let bin_cutoffs = [];
    for i in 1..num_bins {
        let q = (i * 1.0) / (num_bins * 1.0);
        bin_cutoffs.push(compute_quantile(sorted, q));
    }
    return bin_cutoffs;
}

fn compute_bin_frequencies(sample, cutoffs) {
    let num_bins = cutoffs.len() + 1;
    let counts = [];
    for i in 0..num_bins { counts.push(0); }
    
    for val in sample {
        let placed = false;
        for j in 0..cutoffs.len() {
            if val <= cutoffs[j] {
                counts[j] = counts[j] + 1;
                placed = true;
                break;
            }
        }
        if !placed {
            counts[num_bins - 1] = counts[num_bins - 1] + 1;
        }
    }
    
    let total = sample.len() * 1.0;
    let proportions = [];
    let eps = 0.0001; // Smoothing factor
    for c in counts {
        let p = (c * 1.0) / total;
        proportions.push(if p < eps { eps } else { p });
    }
    return proportions;
}

fn compute_psi(reference_sample, current_sample, num_bins) {
    if reference_sample.len() == 0 || current_sample.len() == 0 {
        return 0.0;
    }
    let cutoffs = build_quantile_bins(reference_sample, num_bins);
    let ref_props = compute_bin_frequencies(reference_sample, cutoffs);
    let curr_props = compute_bin_frequencies(current_sample, cutoffs);
    
    let total_psi = 0.0;
    let n = ref_props.len();
    for i in 0..n {
        let p_expected = ref_props[i];
        let p_actual = curr_props[i];
        let diff = p_actual - p_expected;
        let ratio = p_actual / p_expected;
        let comp = diff * ratio.ln();
        total_psi = total_psi + comp;
    }
    
    let drift_status = "STABLE";
    if total_psi >= 0.25 {
        drift_status = "CRITICAL_DRIFT";
    } else if total_psi >= 0.10 {
        drift_status = "MODERATE_SHIFT";
    }
    
    return #{
        psi: total_psi,
        status: drift_status,
        bin_count: num_bins
    };
}

// -----------------------------------------------------------------------------
// Kolmogorov-Smirnov (KS) Two-Sample Test
// -----------------------------------------------------------------------------

fn compute_ks_statistic(sample1, sample2) {
    let n1 = sample1.len();
    let n2 = sample2.len();
    if n1 == 0 || n2 == 0 {
        return #{ statistic: 0.0, is_drift: false };
    }
    
    let s1 = sort_float_array(sample1);
    let s2 = sort_float_array(sample2);
    
    let i = 0;
    let j = 0;
    let max_diff = 0.0;
    
    while i < n1 && j < n2 {
        let v1 = s1[i];
        let v2 = s2[j];
        
        let cdf1 = ((i + 1) * 1.0) / (n1 * 1.0);
        let cdf2 = ((j + 1) * 1.0) / (n2 * 1.0);
        
        let diff = cdf1 - cdf2;
        let abs_diff = if diff < 0.0 { -diff } else { diff };
        if abs_diff > max_diff {
            max_diff = abs_diff;
        }
        
        if v1 <= v2 {
            i = i + 1;
        } else {
            j = j + 1;
        }
    }
    
    // Critical value at alpha = 0.05 is ~ 1.36 * sqrt((n1 + n2) / (n1 * n2))
    let crit_threshold = 1.36 * (((n1 + n2) * 1.0) / ((n1 * n2) * 1.0)).sqrt();
    let is_drift = max_diff > crit_threshold;
    
    return #{
        statistic: max_diff,
        critical_threshold: crit_threshold,
        is_drift: is_drift
    };
}

// -----------------------------------------------------------------------------
// Jensen-Shannon Divergence (JSD)
// -----------------------------------------------------------------------------

fn kl_divergence(p, q) {
    let kl = 0.0;
    let n = p.len();
    for i in 0..n {
        let p_i = p[i];
        let q_i = q[i];
        if p_i > 0.0 && q_i > 0.0 {
            kl = kl + p_i * (p_i / q_i).ln();
        }
    }
    return kl;
}

fn compute_jsd(p, q) {
    let n = p.len();
    let m = [];
    for i in 0..n {
        m.push(0.5 * (p[i] + q[i]));
    }
    let jsd = 0.5 * kl_divergence(p, m) + 0.5 * kl_divergence(q, m);
    let distance = if jsd > 0.0 { jsd.sqrt() } else { 0.0 };
    return #{
        divergence: jsd,
        distance: distance
    };
}

// -----------------------------------------------------------------------------
// Wasserstein Distance (1D Continuous)
// -----------------------------------------------------------------------------

fn compute_wasserstein_1d(sample1, sample2) {
    let n1 = sample1.len();
    let n2 = sample2.len();
    if n1 == 0 || n2 == 0 { return 0.0; }
    
    let s1 = sort_float_array(sample1);
    let s2 = sort_float_array(sample2);
    
    // Step through quantile grid 0..100
    let steps = 100;
    let total_dist = 0.0;
    for k in 0..steps {
        let q = (k * 1.0) / (steps * 1.0);
        let q1 = compute_quantile(s1, q);
        let q2 = compute_quantile(s2, q);
        let diff = q1 - q2;
        total_dist = total_dist + (if diff < 0.0 { -diff } else { diff });
    }
    return total_dist / (steps * 1.0);
}

// -----------------------------------------------------------------------------
// Pipeline Event Handlers
// -----------------------------------------------------------------------------

fn process_drift_batch(event, monitor_state) {
    let feature_name = event["feature_name"];
    let baseline_sample = event["baseline_sample"];
    let current_sample = event["current_sample"];
    let timestamp = event["timestamp"];
    
    let psi_result = compute_psi(baseline_sample, current_sample, 10);
    let ks_result = compute_ks_statistic(baseline_sample, current_sample);
    let w_dist = compute_wasserstein_1d(baseline_sample, current_sample);
    
    let alerts = [];
    if psi_result["status"] == "CRITICAL_DRIFT" {
        alerts.push(#{
            rule: "FEATURE_PSI_CRITICAL_DRIFT",
            severity: "CRITICAL",
            feature: feature_name,
            psi_value: psi_result["psi"],
            timestamp: timestamp
        });
    } else if psi_result["status"] == "MODERATE_SHIFT" {
        alerts.push(#{
            rule: "FEATURE_PSI_MODERATE_SHIFT",
            severity: "WARNING",
            feature: feature_name,
            psi_value: psi_result["psi"],
            timestamp: timestamp
        });
    }
    
    if ks_result["is_drift"] {
        alerts.push(#{
            rule: "FEATURE_KS_DISTRIBUTION_MISMATCH",
            severity: "HIGH",
            feature: feature_name,
            ks_stat: ks_result["statistic"],
            threshold: ks_result["critical_threshold"],
            timestamp: timestamp
        });
    }
    
    return #{
        feature: feature_name,
        timestamp: timestamp,
        psi: psi_result["psi"],
        drift_status: psi_result["status"],
        ks_statistic: ks_result["statistic"],
        wasserstein_distance: w_dist,
        alerts: alerts
    };
}
