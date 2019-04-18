/*
 * Knuth-Morris-Pratt (KMP) Substring Pattern Matcher
 *
 * Precomputes longest proper prefix-suffix (LPS) array for O(N + M) search.
 */

// Compute LPS table for pattern
fn compute_lps(pattern) {
    let m = pattern.len();
    let lps = [];
    for i in 0..m {
        lps.push(0);
    }

    let len = 0;
    let i = 1;

    while i < m {
        if pattern.sub_string(i, 1) == pattern.sub_string(len, 1) {
            len += 1;
            lps[i] = len;
            i += 1;
        } else {
            if len != 0 {
                len = lps[len - 1];
            } else {
                lps[i] = 0;
                i += 1;
            }
        }
    }
    return lps;
}

// Search for pattern in text; returns array of match start indices
fn kmp_search(text, pattern) {
    let matches = [];
    let n = text.len();
    let m = pattern.len();
    if m == 0 || n < m {
        return matches;
    }

    let lps = compute_lps(pattern);
    let i = 0; // index in text
    let j = 0; // index in pattern

    while i < n {
        if text.sub_string(i, 1) == pattern.sub_string(j, 1) {
            i += 1;
            j += 1;
        }

        if j == m {
            matches.push(i - j);
            j = lps[j - 1];
        } else if i < n && text.sub_string(i, 1) != pattern.sub_string(j, 1) {
            if j != 0 {
                j = lps[j - 1];
            } else {
                i += 1;
            }
        }
    }

    return matches;
}
