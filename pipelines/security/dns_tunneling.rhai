/*
 * DNS Exfiltration and Tunneling Detection
 *
 * Computes Shannon entropy on query labels to identify encoded payloads.
 */

// Compute Shannon entropy on ASCII string
fn shannon_entropy(s) {
    if s.is_empty() {
        return 0.0;
    }
    let counts = #{};
    for i in 0..s.len() {
        let ch = s.sub_string(i, 1);
        if counts.contains(ch) {
            counts[ch] += 1;
        } else {
            counts[ch] = 1;
        }
    }

    let len_f = s.len() * 1.0;
    let entropy = 0.0;
    for k in counts.keys() {
        let p = (counts[k] * 1.0) / len_f;
        entropy -= p * (p.ln() / 2.0.ln()); // log base 2
    }
    return entropy;
}

// Evaluate DNS query event for exfiltration patterns
fn evaluate_dns_query(event, entropy_threshold, max_subdomain_len) {
    let domain = event.payload["domain"];
    let first_dot = domain.index_of(".");
    if first_dot == -1 {
        return ();
    }
    let subdomain = domain.sub_string(0, first_dot);

    let entropy = shannon_entropy(subdomain);
    if subdomain.len() > max_subdomain_len && entropy > entropy_threshold {
        return #{
            alert: "DNS_TUNNELING_SUSPECTED",
            domain: domain,
            subdomain: subdomain,
            entropy: entropy,
            subdomain_length: subdomain.len(),
            severity: "HIGH"
        };
    }
    return ();
}
