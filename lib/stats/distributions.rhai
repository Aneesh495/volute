/*
 * Statistical Probability Distributions and Error Functions
 *
 * Implements Gaussian Normal PDF, CDF (via Chebyshev/Abramowitz polynomial),
 * and Exponential distributions.
 */

const PI = 3.141592653589793;

// Normal distribution Probability Density Function (PDF)
fn normal_pdf(x, mean_val, stddev_val) {
    if stddev_val <= 0.0 {
        return 0.0;
    }
    let diff = (x * 1.0) - (mean_val * 1.0);
    let exponent = -0.5 * (diff / (stddev_val * 1.0)) * (diff / (stddev_val * 1.0));
    let coef = 1.0 / (stddev_val * (2.0 * PI).sqrt());
    return coef * exponent.exp();
}

// Error function erf(x) approximation via Abramowitz and Stegun 7.1.26
fn erf_approx(x) {
    let sign = if x < 0.0 { -1.0 } else { 1.0 };
    let abs_x = if x < 0.0 { -x * 1.0 } else { x * 1.0 };

    let p = 0.3275911;
    let a1 = 0.254829592;
    let a2 = -0.284496736;
    let a3 = 1.421413741;
    let a4 = -1.453152027;
    let a5 = 1.061405429;

    let t = 1.0 / (1.0 + p * abs_x);
    let poly = t * (a1 + t * (a2 + t * (a3 + t * (a4 + t * a5))));
    let val = 1.0 - poly * (-abs_x * abs_x).exp();

    return sign * val;
}

// Normal Cumulative Distribution Function (CDF)
fn normal_cdf(x, mean_val, stddev_val) {
    if stddev_val <= 0.0 {
        return if x < mean_val { 0.0 } else { 1.0 };
    }
    let z = ((x * 1.0) - (mean_val * 1.0)) / (stddev_val * (2.0).sqrt());
    return 0.5 * (1.0 + erf_approx(z));
}
