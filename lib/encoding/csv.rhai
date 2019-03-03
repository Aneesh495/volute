/*
 * RFC 4180 Compliant CSV Stream Tokenizer
 *
 * Handles quoted fields, escaped quotes, and customizable delimiters.
 */

// Parse single CSV record into array of field strings
fn parse_csv_line(line, delimiter) {
    let fields = [];
    let current = "";
    let in_quotes = false;
    let i = 0;
    let n = line.len();

    while i < n {
        let ch = line.sub_string(i, 1);
        if in_quotes {
            if ch == "\"" {
                if i + 1 < n && line.sub_string(i + 1, 1) == "\"" {
                    current += "\"";
                    i += 1;
                } else {
                    in_quotes = false;
                }
            } else {
                current += ch;
            }
        } else {
            if ch == "\"" {
                in_quotes = true;
            } else if ch == delimiter {
                fields.push(current);
                current = "";
            } else {
                current += ch;
            }
        }
        i += 1;
    }
    fields.push(current);
    return fields;
}

// Parse header line and return map for CSV row
fn parse_csv_row_with_headers(line, headers, delimiter) {
    let values = parse_csv_line(line, delimiter);
    let record = #{};
    let min_len = headers.len();
    if values.len() < min_len {
        min_len = values.len();
    }
    for i in 0..min_len {
        record[headers[i]] = values[i];
    }
    return record;
}
