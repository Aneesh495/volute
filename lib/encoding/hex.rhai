/*
 * Hexadecimal Encoding and Decoding Utilities
 */

fn hex_chars() {
    return "0123456789abcdef";
}

// Convert single byte value to two hex characters
fn byte_to_hex(b) {
    let chars = hex_chars();
    let hi = (b / 16) % 16;
    let lo = b % 16;
    return chars.sub_string(hi, 1) + chars.sub_string(lo, 1);
}

// Convert hex character to integer value
fn hex_char_to_val(ch) {
    let chars = hex_chars();
    let c = ch.to_lower();
    for i in 0..16 {
        if chars.sub_string(i, 1) == c {
            return i;
        }
    }
    return -1;
}

// Convert two hex characters to byte value
fn hex_to_byte(hex_pair) {
    if hex_pair.len() != 2 {
        return -1;
    }
    let h1 = hex_char_to_val(hex_pair.sub_string(0, 1));
    let h2 = hex_char_to_val(hex_pair.sub_string(1, 1));
    if h1 == -1 || h2 == -1 {
        return -1;
    }
    return h1 * 16 + h2;
}
