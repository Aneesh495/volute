/*
 * HTTP Message Parsing and Query String Helpers
 *
 * Implements status code classifiers, method validation, and URL query decoding.
 */

// Check if HTTP status indicates success (2xx)
fn is_success(status) {
    return status >= 200 && status < 300;
}

// Check if HTTP status indicates redirection (3xx)
fn is_redirect(status) {
    return status >= 300 && status < 400;
}

// Check if HTTP status indicates client error (4xx)
fn is_client_error(status) {
    return status >= 400 && status < 500;
}

// Check if HTTP status indicates server error (5xx)
fn is_server_error(status) {
    return status >= 500 && status < 600;
}

// Parse query string (key1=val1&key2=val2) into map
fn parse_query_string(query_str) {
    let params = #{};
    if query_str.is_empty() {
        return params;
    }
    let s = query_str;
    if s.sub_string(0, 1) == "?" {
        s = s.sub_string(1, s.len() - 1);
    }
    let pairs = [];
    let current = "";
    for i in 0..s.len() {
        let ch = s.sub_string(i, 1);
        if ch == "&" {
            pairs.push(current);
            current = "";
        } else {
            current += ch;
        }
    }
    pairs.push(current);

    for pair in pairs {
        let eq_idx = pair.index_of("=");
        if eq_idx != -1 {
            let k = pair.sub_string(0, eq_idx);
            let v = pair.sub_string(eq_idx + 1, pair.len() - eq_idx - 1);
            params[k] = v;
        } else if !pair.is_empty() {
            params[pair] = "";
        }
    }
    return params;
}

// Normalize HTTP method to uppercase and validate
fn normalize_method(method) {
    let m = method.to_upper();
    if m == "GET" || m == "POST" || m == "PUT" || m == "DELETE" ||
       m == "PATCH" || m == "HEAD" || m == "OPTIONS" {
        return m;
    }
    return "UNKNOWN";
}
