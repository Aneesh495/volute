/*
 * CIDR Subnet Prefix Matching and Range Verification
 *
 * Implements prefix mask translation, network boundaries, and containment.
 */

import "lib/net/ipv4" as ip_mod;

// Convert prefix length (e.g. 24) to 32-bit subnet mask
fn prefix_to_mask(prefix_len) {
    if prefix_len <= 0 {
        return 0;
    }
    if prefix_len >= 32 {
        return 4294967295;
    }
    let shift = 32 - prefix_len;
    let base = 1;
    for idx in 0..shift {
        base *= 2;
    }
    return 4294967296 - base;
}

// Parse CIDR block string (e.g. 192.168.1.0/24) into struct
fn parse_cidr(cidr_str) {
    let slash_idx = cidr_str.index_of("/");
    if slash_idx == -1 {
        return #{ is_valid: false };
    }
    let ip_part = cidr_str.sub_string(0, slash_idx);
    let prefix_str = cidr_str.sub_string(slash_idx + 1, cidr_str.len() - slash_idx - 1);
    let prefix_len = prefix_str.to_int();

    let ip_int = ip_mod::ip_to_int(ip_part);
    if ip_int == -1 || prefix_len < 0 || prefix_len > 32 {
        return #{ is_valid: false };
    }

    let mask = prefix_to_mask(prefix_len);
    let net_int = ip_int & mask;

    return #{
        network_ip: ip_mod::int_to_ip(net_int),
        network_int: net_int,
        prefix_len: prefix_len,
        mask: mask,
        is_valid: true
    };
}

// Check if target IP string belongs to CIDR block
fn contains_ip(cidr_str, target_ip_str) {
    let cidr = parse_cidr(cidr_str);
    if !cidr.is_valid {
        return false;
    }
    let target_int = ip_mod::ip_to_int(target_ip_str);
    if target_int == -1 {
        return false;
    }
    return (target_int & cidr.mask) == cidr.network_int;
}

// Check if any CIDR in list matches target IP
fn match_any_cidr(cidr_list, target_ip) {
    for cidr in cidr_list {
        if contains_ip(cidr, target_ip) {
            return true;
        }
    }
    return false;
}
