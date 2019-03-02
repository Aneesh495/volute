/*
 * RFC 5424 and RFC 3164 Syslog Message Parser
 *
 * Decodes priority, facility, severity, timestamp, hostname, and message body.
 */

// Decode syslog facility name from facility code
fn facility_name(facility) {
    let names = [
        "kern", "user", "mail", "daemon", "auth", "syslog", "lpr", "news",
        "uucp", "cron", "authpriv", "ftp", "ntp", "security", "console", "solaris",
        "local0", "local1", "local2", "local3", "local4", "local5", "local6", "local7"
    ];
    if facility >= 0 && facility < names.len() {
        return names[facility];
    }
    return "unknown";
}

// Decode syslog severity name from severity code
fn severity_name(severity) {
    let names = [
        "emerg", "alert", "crit", "err", "warning", "notice", "info", "debug"
    ];
    if severity >= 0 && severity < names.len() {
        return names[severity];
    }
    return "unknown";
}

// Parse PRI header <PRIVAL>
fn parse_pri(line) {
    if line.len() < 3 || line.sub_string(0, 1) != "<" {
        return #{ is_valid: false };
    }
    let close_idx = line.index_of(">");
    if close_idx == -1 || close_idx > 5 {
        return #{ is_valid: false };
    }
    let pri_str = line.sub_string(1, close_idx - 1);
    let pri_val = pri_str.to_int();
    let facility = pri_val / 8;
    let severity = pri_val % 8;

    return #{
        priority: pri_val,
        facility: facility,
        facility_name: facility_name(facility),
        severity: severity,
        severity_name: severity_name(severity),
        header_len: close_idx + 1,
        is_valid: true
    };
}

// Parse complete Syslog line into structured map
fn parse_syslog(line) {
    let pri = parse_pri(line);
    if !pri.is_valid {
        return #{
            raw: line,
            is_valid: false
        };
    }

    let remainder = line.sub_string(pri.header_len, line.len() - pri.header_len);
    // Trim leading space if present
    if remainder.len() > 0 && remainder.sub_string(0, 1) == " " {
        remainder = remainder.sub_string(1, remainder.len() - 1);
    }

    return #{
        priority: pri.priority,
        facility: pri.facility,
        facility_name: pri.facility_name,
        severity: pri.severity,
        severity_name: pri.severity_name,
        message: remainder,
        is_valid: true
    };
}
