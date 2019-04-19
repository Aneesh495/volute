/*
 * One-Dimensional Kalman Filter for Sensor Telemetry
 *
 * Implements recursive state estimation: prediction and measurement update.
 */

// Initialize 1D Kalman filter state
fn new_kalman_1d(initial_state, initial_covariance, process_noise_q, measurement_noise_r) {
    return #{
        x: initial_state * 1.0,        // Estimated state
        p: initial_covariance * 1.0,   // Estimation covariance
        q: process_noise_q * 1.0,      // Process noise covariance
        r: measurement_noise_r * 1.0,  // Measurement noise covariance
        k: 0.0                         // Kalman gain
    };
}

// Update filter with new measurement observation z; returns updated filter
fn kalman_update(kf, z) {
    let measurement = z * 1.0;

    // 1. Prediction stage
    let x_pred = kf.x;
    let p_pred = kf.p + kf.q;

    // 2. Kalman Gain calculation
    let k = p_pred / (p_pred + kf.r);

    // 3. Measurement update
    let x_new = x_pred + k * (measurement - x_pred);
    let p_new = (1.0 - k) * p_pred;

    kf.x = x_new;
    kf.p = p_new;
    kf.k = k;

    return kf;
}

// Get current estimated value
fn kalman_estimate(kf) {
    return kf.x;
}
