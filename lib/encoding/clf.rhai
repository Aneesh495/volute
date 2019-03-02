/*
 * Common Log Format (CLF) and Combined Log Format Parser
 *
 * Parses HTTP access logs: remote host, user, timestamp, request, status, bytes.
 */

// Parse standard Combined Log Format line
fn parse_clf(line) {
    let parts = [];
    let i = 0;
    let n = line.len();

    // 1. IP
    let ip_end = line.index_of(" ");
    if ip_end == -1 { return #{ is_valid: false }; }
    let remote_ip = line.sub_string(0, ip_end);
    i = ip_end + 1;

    // 2. Identity and User (skip "- -")
    let bracket_open = line.index_of("[");
    if bracket_open == -1 { return #{ is_valid: false }; }
    let bracket_close = line.index_of("]");
    if bracket_close == -1 { return #{ is_valid: false }; }
    let timestamp_str = line.sub_string(bracket_open + 1, bracket_close - bracket_open - 1);
    i = bracket_close + 2;

    // 3. Request in quotes
    if i >= n || line.sub_string(i, 1) != "\"" {
        return #{ is_valid: false };
    }
    let req_close = -1;
    for idx in (i + 1)..n {
        if line.sub_string(idx, 1) == "\"" {
            req_close = idx;
            break;
        }
    }
    if req_close == -1 { return #{ is_valid: false }; }
    let request_line = line.sub_string(i + 1, req_close - i - 1);
    i = req_close + 2;

    // 4. Status code and Bytes
    let remainder = line.sub_string(i, n - i);
    let space_idx = remainder.index_of(" ");
    let status_code = 0;
    let response_bytes = 0;
    if space_idx != -1 {
        status_code = remainder.sub_string(0, space_idx).to_int();
        let bytes_str = remainder.sub_string(space_idx + 1, remainder.len() - space_idx - 1);
        let second_space = bytes_str.index_of(" ");
        if second_space != -1 {
            bytes_str = bytes_str.sub_string(0, second_space);
        }
        if bytes_str != "-" {
            response_bytes = bytes_str.to_int();
        }
    }

    return #{
        client_ip: remote_ip,
        timestamp: timestamp_str,
        request: request_line,
        status: status_code,
        bytes: response_bytes,
        is_valid: true
    };
}
