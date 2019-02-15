/*
 * High-precision Mathematical and Numerical Algorithms
 *
 * Implements clamps, linear interpolation, geometric distances, fast powers,
 * factorial, combinations, vector dot products, and matrix operations.
 */

// Constrain value between min and max bounds
fn clamp(val, min_val, max_val) {
    if val < min_val {
        return min_val;
    }
    if val > max_val {
        return max_val;
    }
    return val;
}

// Linear interpolation between two points
fn lerp(start, finish, t) {
    return start + (finish - start) * t;
}

// Absolute value for numeric types
fn abs(val) {
    if val < 0 {
        return -val;
    }
    return val;
}

// Compute greatest common divisor via Euclidean algorithm
fn gcd(a, b) {
    let x = a;
    let y = b;
    if x < 0 { x = -x; }
    if y < 0 { y = -y; }
    while y != 0 {
        let temp = y;
        y = x % y;
        x = temp;
    }
    return x;
}

// Compute least common multiple
fn lcm(a, b) {
    if a == 0 || b == 0 {
        return 0;
    }
    let d = gcd(a, b);
    return abs(a * b) / d;
}

// Compute factorial of integer N
fn factorial(n) {
    if n <= 1 {
        return 1;
    }
    let acc = 1;
    for i in 2..=n {
        acc *= i;
    }
    return acc;
}

// Compute binomial combination nCr
fn combination(n, r) {
    if r < 0 || r > n {
        return 0;
    }
    if r == 0 || r == n {
        return 1;
    }
    let k = r;
    if k > n - k {
        k = n - k;
    }
    let c = 1;
    for i in 0..k {
        c = c * (n - i) / (i + 1);
    }
    return c;
}

// Fast integer exponentiation by squaring
fn pow_int(base, exp) {
    if exp < 0 {
        return 0;
    }
    let result = 1;
    let b = base;
    let e = exp;
    while e > 0 {
        if e % 2 == 1 {
            result *= b;
        }
        b *= b;
        e /= 2;
    }
    return result;
}

// Compute dot product of two numerical vectors
fn vector_dot(v1, v2) {
    if v1.len() != v2.len() {
        return 0.0;
    }
    let sum = 0.0;
    for i in 0..v1.len() {
        sum += v1[i] * v2[i];
    }
    return sum;
}

// Compute Euclidean norm (magnitude) of vector
fn vector_magnitude(v) {
    let sum_sq = 0.0;
    for x in v {
        sum_sq += x * x;
    }
    return sum_sq.sqrt();
}

// Normalize vector to unit length
fn vector_normalize(v) {
    let mag = vector_magnitude(v);
    if mag == 0.0 {
        return v;
    }
    let out = [];
    for x in v {
        out.push(x / mag);
    }
    return out;
}

// 2x2 Matrix multiplication
fn matrix_mul_2x2(m1, m2) {
    let a00 = m1[0][0] * m2[0][0] + m1[0][1] * m2[1][0];
    let a01 = m1[0][0] * m2[0][1] + m1[0][1] * m2[1][1];
    let a10 = m1[1][0] * m2[0][0] + m1[1][1] * m2[1][0];
    let a11 = m1[1][0] * m2[0][1] + m1[1][1] * m2[1][1];
    return [[a00, a01], [a10, a11]];
}

// Determinant of 2x2 matrix
fn matrix_det_2x2(m) {
    return m[0][0] * m[1][1] - m[0][1] * m[1][0];
}
