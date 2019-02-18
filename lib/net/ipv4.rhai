/*
 * IPv4 Address Arithmetic and Subnet Operations
 *
 * Implements address conversion, classification, private address checks,
 * loopback detection, and broadcast calculation.
 */

// Parse IPv4 string into array of 4 octets
fn parse_octets(ip_str) {
    let octets = [];
    let current = 0;
    let count = 0;
    for i in 0..ip_str.len() {
        let ch = ip_str.sub_string(i, 1);
        if ch == "." {
            octets.push(current);
            current = 0;
            count += 1;
        } else {
            let digit = ch.to_int();
            current = current * 10 + digit;
        }
    }
    octets.push(current);
    if octets.len() != 4 {
        return [];
    }
    for octet in octets {
        if octet < 0 || octet > 255 {
            return [];
        }
    }
    return octets;
}

// Convert 4 octets to 32-bit integer
fn octets_to_int(octets) {
    if octets.len() != 4 {
        return -1;
    }
    let res = (octets[0] * 16777216) + (octets[1] * 65536) + (octets[2] * 256) + octets[3];
    return res;
}

// Convert IPv4 string to integer
fn ip_to_int(ip_str) {
    let octets = parse_octets(ip_str);
    return octets_to_int(octets);
}

// Convert 32-bit integer back to IPv4 string
fn int_to_ip(val) {
    if val < 0 {
        return "";
    }
    let o1 = (val / 16777216) % 256;
    let o2 = (val / 65536) % 256;
    let o3 = (val / 256) % 256;
    let o4 = val % 256;
    return o1.to_string() + "." + o2.to_string() + "." + o3.to_string() + "." + o4.to_string();
}

// Check if IP is in private range RFC 1918
fn is_private(ip_str) {
    let octets = parse_octets(ip_str);
    if octets.len() != 4 {
        return false;
    }
    // 10.0.0.0/8
    if octets[0] == 10 {
        return true;
    }
    // 172.16.0.0/12
    if octets[0] == 172 && octets[1] >= 16 && octets[1] <= 31 {
        return true;
    }
    // 192.168.0.0/16
    if octets[0] == 192 && octets[1] == 168 {
        return true;
    }
    return false;
}

// Check if IP is loopback 127.0.0.0/8
fn is_loopback(ip_str) {
    let octets = parse_octets(ip_str);
    if octets.len() != 4 {
        return false;
    }
    return octets[0] == 127;
}

// Check if IP is link-local 169.254.0.0/16
fn is_link_local(ip_str) {
    let octets = parse_octets(ip_str);
    if octets.len() != 4 {
        return false;
    }
    return octets[0] == 169 && octets[1] == 254;
}
