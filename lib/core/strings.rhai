/*
 * High-performance String Manipulation and Text Processing
 *
 * Implements tokenizers, padding, template interpolation, pattern checks,
 * slug generation, and case conversions.
 */

// Left-pad string to target width with filler character
fn pad_left(s, width, pad_char) {
    let str_val = s.to_string();
    if str_val.len() >= width {
        return str_val;
    }
    let deficit = width - str_val.len();
    let pad = "";
    for idx in 0..deficit {
        pad += pad_char;
    }
    return pad + str_val;
}

// Right-pad string to target width with filler character
fn pad_right(s, width, pad_char) {
    let str_val = s.to_string();
    if str_val.len() >= width {
        return str_val;
    }
    let deficit = width - str_val.len();
    let pad = "";
    for idx in 0..deficit {
        pad += pad_char;
    }
    return str_val + pad;
}

// Check if string starts with prefix
fn starts_with(s, prefix) {
    if prefix.len() > s.len() {
        return false;
    }
    return s.sub_string(0, prefix.len()) == prefix;
}

// Check if string ends with suffix
fn ends_with(s, suffix) {
    if suffix.len() > s.len() {
        return false;
    }
    let start_idx = s.len() - suffix.len();
    return s.sub_string(start_idx, suffix.len()) == suffix;
}

// Split string by single character delimiter
fn split_char(s, delim) {
    let tokens = [];
    let current = "";
    for i in 0..s.len() {
        let ch = s.sub_string(i, 1);
        if ch == delim {
            tokens.push(current);
            current = "";
        } else {
            current += ch;
        }
    }
    tokens.push(current);
    return tokens;
}

// Join array of elements with delimiter
fn join(arr, delim) {
    if arr.is_empty() {
        return "";
    }
    let out = arr[0].to_string();
    for i in 1..arr.len() {
        out += delim + arr[i].to_string();
    }
    return out;
}

// Convert string to lower-case kebab-case
fn to_kebab_case(s) {
    let out = "";
    for i in 0..s.len() {
        let ch = s.sub_string(i, 1);
        if ch == " " || ch == "_" {
            out += "-";
        } else {
            out += ch.to_lower();
        }
    }
    return out;
}

// Convert string to lower-case snake_case
fn to_snake_case(s) {
    let out = "";
    for i in 0..s.len() {
        let ch = s.sub_string(i, 1);
        if ch == " " || ch == "-" {
            out += "_";
        } else {
            out += ch.to_lower();
        }
    }
    return out;
}

// Interpolate string with named map values
fn interpolate(template_str, vars) {
    let out = "";
    let i = 0;
    while i < template_str.len() {
        if i + 1 < template_str.len() && template_str.sub_string(i, 2) == "${" {
            let close_pos = -1;
            for j in (i + 2)..template_str.len() {
                if template_str.sub_string(j, 1) == "}" {
                    close_pos = j;
                    break;
                }
            }
            if close_pos != -1 {
                let var_name = template_str.sub_string(i + 2, close_pos - (i + 2));
                if vars.contains(var_name) {
                    out += vars[var_name].to_string();
                }
                i = close_pos + 1;
                continue;
            }
        }
        out += template_str.sub_string(i, 1);
        i += 1;
    }
    return out;
}

// Compute simple Levenshtein edit distance
fn edit_distance(s1, s2) {
    let len1 = s1.len();
    let len2 = s2.len();
    if len1 == 0 { return len2; }
    if len2 == 0 { return len1; }

    let prev = [];
    for j in 0..=len2 {
        prev.push(j);
    }

    for i in 1..=len1 {
        let curr = [i];
        let ch1 = s1.sub_string(i - 1, 1);
        for j in 1..=len2 {
            let ch2 = s2.sub_string(j - 1, 1);
            let cost = if ch1 == ch2 { 0 } else { 1 };
            let ins = curr[j - 1] + 1;
            let del = prev[j] + 1;
            let sub = prev[j - 1] + cost;
            let min_cost = ins;
            if del < min_cost { min_cost = del; }
            if sub < min_cost { min_cost = sub; }
            curr.push(min_cost);
        }
        prev = curr;
    }
    return prev[len2];
}
