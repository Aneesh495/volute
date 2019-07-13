/*
 * Base64 Encoding and Decoding Algorithms
 */

fn b64_chars() {
    return "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
}

// Decode base64 character to 6-bit value
fn b64_val(ch) {
    let chars = b64_chars();
    for i in 0..64 {
        if chars.sub_string(i, 1) == ch {
            return i;
        }
    }
    return -1;
}

// Validate base64 formatted string
fn is_valid_base64(s) {
    if s.len() % 4 != 0 {
        return false;
    }
    for i in 0..s.len() {
        let ch = s.sub_string(i, 1);
        if ch != "=" && b64_val(ch) == -1 {
            return false;
        }
    }
    return true;
}
