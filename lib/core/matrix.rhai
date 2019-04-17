/*
 * Matrix Algebra and Linear Transformation Engine
 *
 * Implements matrix creation, transpose, multiplication, and determinant.
 */

// Create M x N zero matrix
fn zeros(rows, cols) {
    let mat = [];
    for r in 0..rows {
        let row = [];
        for c in 0..cols {
            row.push(0.0);
        }
        mat.push(row);
    }
    return mat;
}

// Create N x N identity matrix
fn eye(n) {
    let mat = zeros(n, n);
    for i in 0..n {
        mat[i][i] = 1.0;
    }
    return mat;
}

// Transpose M x N matrix to N x M matrix
fn transpose(mat) {
    if mat.is_empty() {
        return [];
    }
    let rows = mat.len();
    let cols = mat[0].len();
    let res = zeros(cols, rows);

    for r in 0..rows {
        for c in 0..cols {
            res[c][r] = mat[r][c] * 1.0;
        }
    }
    return res;
}

// Matrix multiplication A (M x K) * B (K x N) -> (M x N)
fn mat_mul(a, b) {
    if a.is_empty() || b.is_empty() {
        return [];
    }
    let rows_a = a.len();
    let cols_a = a[0].len();
    let rows_b = b.len();
    let cols_b = b[0].len();

    if cols_a != rows_b {
        return [];
    }

    let res = zeros(rows_a, cols_b);

    for i in 0..rows_a {
        for j in 0..cols_b {
            let sum = 0.0;
            for k in 0..cols_a {
                sum += (a[i][k] * 1.0) * (b[k][j] * 1.0);
            }
            res[i][j] = sum;
        }
    }
    return res;
}

// Compute determinant of 3x3 matrix via Sarrus rule
fn det_3x3(m) {
    let a = m[0][0] * 1.0;
    let b = m[0][1] * 1.0;
    let c = m[0][2] * 1.0;
    let d = m[1][0] * 1.0;
    let e = m[1][1] * 1.0;
    let f = m[1][2] * 1.0;
    let g = m[2][0] * 1.0;
    let h = m[2][1] * 1.0;
    let i = m[2][2] * 1.0;

    return a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g);
}
