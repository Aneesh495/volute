/*
 * Ordinary Least Squares (OLS) Linear Regression
 *
 * Implements linear slope, intercept, correlation coefficient, and predictions.
 */

// Fit simple linear regression y = slope * x + intercept
fn fit_linear_regression(xs, ys) {
    if xs.len() != ys.len() || xs.len() < 2 {
        return #{
            slope: 0.0,
            intercept: 0.0,
            r_squared: 0.0,
            is_valid: false
        };
    }

    let n = xs.len() * 1.0;
    let sum_x = 0.0;
    let sum_y = 0.0;
    let sum_xy = 0.0;
    let sum_xx = 0.0;
    let sum_yy = 0.0;

    for i in 0..xs.len() {
        let x = xs[i] * 1.0;
        let y = ys[i] * 1.0;
        sum_x += x;
        sum_y += y;
        sum_xy += x * y;
        sum_xx += x * x;
        sum_yy += y * y;
    }

    let denom = n * sum_xx - sum_x * sum_x;
    if denom == 0.0 {
        return #{
            slope: 0.0,
            intercept: sum_y / n,
            r_squared: 0.0,
            is_valid: false
        };
    }

    let slope = (n * sum_xy - sum_x * sum_y) / denom;
    let intercept = (sum_y - slope * sum_x) / n;

    // Compute R-squared
    let mean_y = sum_y / n;
    let ss_tot = 0.0;
    let ss_res = 0.0;
    for i in 0..xs.len() {
        let y = ys[i] * 1.0;
        let pred = slope * (xs[i] * 1.0) + intercept;
        let diff_tot = y - mean_y;
        let diff_res = y - pred;
        ss_tot += diff_tot * diff_tot;
        ss_res += diff_res * diff_res;
    }

    let r_sq = if ss_tot == 0.0 { 1.0 } else { 1.0 - (ss_res / ss_tot) };

    return #{
        slope: slope,
        intercept: intercept,
        r_squared: r_sq,
        is_valid: true
    };
}

// Predict Y for given X using linear model
fn predict(model, x) {
    if !model.is_valid {
        return 0.0;
    }
    return model.slope * (x * 1.0) + model.intercept;
}

// Compute Pearson correlation coefficient
fn pearson_correlation(xs, ys) {
    if xs.len() != ys.len() || xs.len() < 2 {
        return 0.0;
    }
    let n = xs.len() * 1.0;
    let sum_x = 0.0;
    let sum_y = 0.0;
    let sum_xy = 0.0;
    let sum_xx = 0.0;
    let sum_yy = 0.0;

    for i in 0..xs.len() {
        let x = xs[i] * 1.0;
        let y = ys[i] * 1.0;
        sum_x += x;
        sum_y += y;
        sum_xy += x * y;
        sum_xx += x * x;
        sum_yy += y * y;
    }

    let num = n * sum_xy - sum_x * sum_y;
    let den_x = n * sum_xx - sum_x * sum_x;
    let den_y = n * sum_yy - sum_y * sum_y;

    if den_x <= 0.0 || den_y <= 0.0 {
        return 0.0;
    }

    return num / (den_x.sqrt() * den_y.sqrt());
}
