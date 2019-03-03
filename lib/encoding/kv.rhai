/*
 * Structured Key-Value Log Parser
 *
 * Parses log lines with key=value pairs, handling quotes and escapes.
 */

// Parse key=value string into map
fn parse_kv(line) {
    let result = #{};
    let i = 0;
    let n = line.len();

    while i < n {
        // Skip leading whitespace
        while i < n && line.sub_string(i, 1) == " " {
            i += 1;
        }
        if i >= n { break; }

        // Extract key
        let key_start = i;
        while i < n && line.sub_string(i, 1) != "=" && line.sub_string(i, 1) != " " {
            i += 1;
        }
        if i >= n || line.sub_string(i, 1) != "=" {
            break;
        }
        let key = line.sub_string(key_start, i - key_start);
        i += 1; // skip '='

        // Extract value
        let val = "";
        if i < n && line.sub_string(i, 1) == "\"" {
            i += 1; // skip opening quote
            let val_start = i;
            let escaped = false;
            while i < n {
                let ch = line.sub_string(i, 1);
                if escaped {
                    val += ch;
                    escaped = false;
                } else if ch == "\\" {
                    escaped = true;
                } else if ch == "\"" {
                    i += 1;
                    break;
                } else {
                    val += ch;
                }
                i += 1;
            }
        } else {
            let val_start = i;
            while i < n && line.sub_string(i, 1) != " " {
                i += 1;
            }
            val = line.sub_string(val_start, i - val_start);
        }

        result[key] = val;
    }

    return result;
}
