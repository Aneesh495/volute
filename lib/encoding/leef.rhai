/*
 * Log Event Extended Format (LEEF) Protocol Parser
 *
 * Parses LEEF:Version|Vendor|Product|Version|EventID|Delimiter|Extension
 */

import "lib/encoding/kv" as kv_mod;

fn parse_leef(line) {
    if !line.contains("LEEF:") {
        return #{ is_valid: false };
    }
    let start = line.index_of("LEEF:");
    let body = line.sub_string(start + 5, line.len() - start - 5);

    let parts = [];
    let current = "";
    let i = 0;
    let n = body.len();

    while i < n && parts.len() < 5 {
        let ch = body.sub_string(i, 1);
        if ch == "|" {
            parts.push(current);
            current = "";
        } else {
            current += ch;
        }
        i += 1;
    }

    if parts.len() < 5 {
        return #{ is_valid: false };
    }

    let remainder = body.sub_string(i, n - i);
    let ext_map = kv_mod::parse_kv(remainder);

    return #{
        version: parts[0],
        vendor: parts[1],
        product: parts[2],
        dev_version: parts[3],
        event_id: parts[4],
        attributes: ext_map,
        is_valid: true
    };
}
