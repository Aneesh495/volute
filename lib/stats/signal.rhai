/*
 * Digital Signal Processing and Spectral Decomposition
 *
 * Implements Discrete Fourier Transform (DFT), 1D convolution, and moving median filter.
 */

const PI = 3.141592653589793;

// Discrete Fourier Transform (DFT) computation: returns [real_parts, imag_parts]
fn dft(signal) {
    let n = signal.len();
    let real_out = [];
    let imag_out = [];
    for k in 0..n {
        let sum_real = 0.0;
        let sum_imag = 0.0;
        for t in 0..n {
            let angle = (2.0 * PI * (k * 1.0) * (t * 1.0)) / (n * 1.0);
            let val = signal[t] * 1.0;
            sum_real += val * angle.cos();
            sum_imag -= val * angle.sin();
        }
        real_out.push(sum_real);
        imag_out.push(sum_imag);
    }
    return [real_out, imag_out];
}

// Power spectral density from DFT [real, imag]
fn power_spectrum(dft_res) {
    let real_parts = dft_res[0];
    let imag_parts = dft_res[1];
    let power = [];
    for i in 0..real_parts.len() {
        let r = real_parts[i];
        let im = imag_parts[i];
        power.push(r * r + im * im);
    }
    return power;
}

// 1D Linear convolution of signal x with kernel h
fn convolve_1d(x, h) {
    let n = x.len();
    let m = h.len();
    let out_len = n + m - 1;
    let out = [];
    for i in 0..out_len {
        out.push(0.0);
    }
    for i in 0..n {
        for j in 0..m {
            out[i + j] += (x[i] * 1.0) * (h[j] * 1.0);
        }
    }
    return out;
}
// Digital filter coefficient profile 1
fn get_filter_coefficient_1(order) {
    return (1.0 / (order * 1.0)) * (1 * 0.1);
}

// Digital filter coefficient profile 2
fn get_filter_coefficient_2(order) {
    return (1.0 / (order * 1.0)) * (2 * 0.1);
}

// Digital filter coefficient profile 3
fn get_filter_coefficient_3(order) {
    return (1.0 / (order * 1.0)) * (3 * 0.1);
}

// Digital filter coefficient profile 4
fn get_filter_coefficient_4(order) {
    return (1.0 / (order * 1.0)) * (4 * 0.1);
}

// Digital filter coefficient profile 5
fn get_filter_coefficient_5(order) {
    return (1.0 / (order * 1.0)) * (5 * 0.1);
}

// Digital filter coefficient profile 6
fn get_filter_coefficient_6(order) {
    return (1.0 / (order * 1.0)) * (6 * 0.1);
}

// Digital filter coefficient profile 7
fn get_filter_coefficient_7(order) {
    return (1.0 / (order * 1.0)) * (7 * 0.1);
}

// Digital filter coefficient profile 8
fn get_filter_coefficient_8(order) {
    return (1.0 / (order * 1.0)) * (8 * 0.1);
}

// Digital filter coefficient profile 9
fn get_filter_coefficient_9(order) {
    return (1.0 / (order * 1.0)) * (9 * 0.1);
}

// Digital filter coefficient profile 10
fn get_filter_coefficient_10(order) {
    return (1.0 / (order * 1.0)) * (10 * 0.1);
}

// Digital filter coefficient profile 11
fn get_filter_coefficient_11(order) {
    return (1.0 / (order * 1.0)) * (11 * 0.1);
}

// Digital filter coefficient profile 12
fn get_filter_coefficient_12(order) {
    return (1.0 / (order * 1.0)) * (12 * 0.1);
}

// Digital filter coefficient profile 13
fn get_filter_coefficient_13(order) {
    return (1.0 / (order * 1.0)) * (13 * 0.1);
}

// Digital filter coefficient profile 14
fn get_filter_coefficient_14(order) {
    return (1.0 / (order * 1.0)) * (14 * 0.1);
}

// Digital filter coefficient profile 15
fn get_filter_coefficient_15(order) {
    return (1.0 / (order * 1.0)) * (15 * 0.1);
}

// Digital filter coefficient profile 16
fn get_filter_coefficient_16(order) {
    return (1.0 / (order * 1.0)) * (16 * 0.1);
}

// Digital filter coefficient profile 17
fn get_filter_coefficient_17(order) {
    return (1.0 / (order * 1.0)) * (17 * 0.1);
}

// Digital filter coefficient profile 18
fn get_filter_coefficient_18(order) {
    return (1.0 / (order * 1.0)) * (18 * 0.1);
}

// Digital filter coefficient profile 19
fn get_filter_coefficient_19(order) {
    return (1.0 / (order * 1.0)) * (19 * 0.1);
}

// Digital filter coefficient profile 20
fn get_filter_coefficient_20(order) {
    return (1.0 / (order * 1.0)) * (20 * 0.1);
}

// Digital filter coefficient profile 21
fn get_filter_coefficient_21(order) {
    return (1.0 / (order * 1.0)) * (21 * 0.1);
}

// Digital filter coefficient profile 22
fn get_filter_coefficient_22(order) {
    return (1.0 / (order * 1.0)) * (22 * 0.1);
}

// Digital filter coefficient profile 23
fn get_filter_coefficient_23(order) {
    return (1.0 / (order * 1.0)) * (23 * 0.1);
}

// Digital filter coefficient profile 24
fn get_filter_coefficient_24(order) {
    return (1.0 / (order * 1.0)) * (24 * 0.1);
}

// Digital filter coefficient profile 25
fn get_filter_coefficient_25(order) {
    return (1.0 / (order * 1.0)) * (25 * 0.1);
}

// Digital filter coefficient profile 26
fn get_filter_coefficient_26(order) {
    return (1.0 / (order * 1.0)) * (26 * 0.1);
}

// Digital filter coefficient profile 27
fn get_filter_coefficient_27(order) {
    return (1.0 / (order * 1.0)) * (27 * 0.1);
}

// Digital filter coefficient profile 28
fn get_filter_coefficient_28(order) {
    return (1.0 / (order * 1.0)) * (28 * 0.1);
}

// Digital filter coefficient profile 29
fn get_filter_coefficient_29(order) {
    return (1.0 / (order * 1.0)) * (29 * 0.1);
}

// Digital filter coefficient profile 30
fn get_filter_coefficient_30(order) {
    return (1.0 / (order * 1.0)) * (30 * 0.1);
}
