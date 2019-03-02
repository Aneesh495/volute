/*
 * ArcSight Common Event Format (CEF) Decoder
 *
 * Parses CEF header: CEF:Version|Device Vendor|Device Product|Device Version|Device Event Class ID|Name|Severity|Extension
 */

import "lib/encoding/kv" as kv_mod;

fn parse_cef(line) {
    if !line.contains("CEF:") {
        return #{ is_valid: false };
    }
    let start = line.index_of("CEF:");
    let body = line.sub_string(start + 4, line.len() - start - 4);
    
    let parts = [];
    let current = "";
    let escaped = false;
    let i = 0;
    let n = body.len();

    while i < n && parts.len() < 7 {
        let ch = body.sub_string(i, 1);
        if escaped {
            current += ch;
            escaped = false;
        } else if ch == "\\" {
            escaped = true;
        } else if ch == "|" {
            parts.push(current);
            current = "";
        } else {
            current += ch;
        }
        i += 1;
    }

    if parts.len() < 7 {
        return #{ is_valid: false };
    }

    let extension_str = body.sub_string(i, n - i);
    let ext_map = kv_mod::parse_kv(extension_str);

    return #{
        version: parts[0],
        vendor: parts[1],
        product: parts[2],
        dev_version: parts[3],
        signature_id: parts[4],
        name: parts[5],
        severity: parts[6],
        extensions: ext_map,
        is_valid: true
    };
}
