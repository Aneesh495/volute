// Volute Pipeline: DNS-over-HTTPS (DoH) & Wire Protocol Security Auditor
// RFC 8484 and RFC 1035 wire format parsing, Shannon entropy label evaluation for DGA detection,
// fast-flux resilient infrastructure alerts, and DNS tunneling exfiltration detection.

import "lib/core/math" as m;

// -----------------------------------------------------------------------------
// DNS Dictionaries and Constants
// -----------------------------------------------------------------------------

fn get_dns_type_name(qtype) {
    if qtype == 1 { return "A"; }
    if qtype == 2 { return "NS"; }
    if qtype == 5 { return "CNAME"; }
    if qtype == 6 { return "SOA"; }
    if qtype == 12 { return "PTR"; }
    if qtype == 15 { return "MX"; }
    if qtype == 16 { return "TXT"; }
    if qtype == 28 { return "AAAA"; }
    if qtype == 33 { return "SRV"; }
    if qtype == 41 { return "OPT"; }
    if qtype == 65 { return "HTTPS"; }
    return "TYPE-" + qtype.to_string();
}

fn get_dns_rcode_name(rcode) {
    if rcode == 0 { return "NoError"; }
    if rcode == 1 { return "FormErr"; }
    if rcode == 2 { return "ServFail"; }
    if rcode == 3 { return "NXDomain"; }
    if rcode == 4 { return "NotImp"; }
    if rcode == 5 { return "Refused"; }
    if rcode == 9 { return "NotAuth"; }
    return "RCODE-" + rcode.to_string();
}

// -----------------------------------------------------------------------------
// Shannon Entropy Metric for Domain Generation Algorithms (DGA)
// -----------------------------------------------------------------------------

fn calc_label_entropy(label) {
    let len = label.len();
    if len <= 1 { return 0.0; }
    
    let char_counts = #{};
    for i in 0..len {
        let ch = label.sub_string(i, 1);
        if char_counts.contains(ch) {
            char_counts[ch] = char_counts[ch] + 1;
        } else {
            char_counts[ch] = 1;
        }
    }
    
    let entropy = 0.0;
    let inv_ln2 = 1.4426950408889634; // 1 / ln(2)
    let total_chars = len * 1.0;
    
    // In Rhai, iterating over map gives (key, value)
    for entry in char_counts {
        let count = entry.value();
        let p = (count * 1.0) / total_chars;
        if p > 0.0 {
            entropy = entropy - (p * p.ln() * inv_ln2);
        }
    }
    
    return entropy;
}

// -----------------------------------------------------------------------------
// DNS Message Wire Parser
// -----------------------------------------------------------------------------

fn parse_dns_message(raw_msg) {
    let id = raw_msg["id"];
    let is_response = raw_msg["is_response"];
    let opcode = raw_msg["opcode"];
    let rcode = raw_msg["rcode"];
    let questions = raw_msg["questions"];
    let answers = if raw_msg.contains("answers") { raw_msg["answers"] } else { [] };
    
    let parsed_questions = [];
    for q in questions {
        let qname = q["qname"];
        let qtype = q["qtype"];
        let labels = qname.split(".");
        let max_label_entropy = 0.0;
        
        for lbl in labels {
            if lbl.len() > 3 {
                let ent = calc_label_entropy(lbl);
                if ent > max_label_entropy {
                    max_label_entropy = ent;
                }
            }
        }
        
        parsed_questions.push(#{
            qname: qname,
            qtype_id: qtype,
            qtype: get_dns_type_name(qtype),
            max_entropy: max_label_entropy
        });
    }
    
    let parsed_answers = [];
    for ans in answers {
        parsed_answers.push(#{
            name: ans["name"],
            type_id: ans["type"],
            type: get_dns_type_name(ans["type"]),
            ttl: ans["ttl"],
            rdata: ans["rdata"]
        });
    }
    
    return #{
        id: id,
        is_response: is_response,
        opcode: opcode,
        rcode: rcode,
        rcode_name: get_dns_rcode_name(rcode),
        questions: parsed_questions,
        answers: parsed_answers
    };
}

// -----------------------------------------------------------------------------
// C2 & Tunneling Threat Detection
// -----------------------------------------------------------------------------

fn audit_dns_traffic(parsed_msg, client_ip, timestamp) {
    let alerts = [];
    
    // Check 1: DGA High Entropy Domain
    for q in parsed_msg["questions"] {
        if q["max_entropy"] >= 3.85 {
            alerts.push(#{
                rule: "DGA_HIGH_ENTROPY_DOMAIN",
                severity: "HIGH",
                qname: q["qname"],
                entropy: q["max_entropy"],
                client_ip: client_ip,
                timestamp: timestamp
            });
        }
        
        // Check 2: DNS Tunneling via Query Name Payload (> 120 chars)
        if q["qname"].len() > 120 {
            alerts.push(#{
                rule: "DNS_TUNNELING_EXCESSIVE_QNAME_LENGTH",
                severity: "CRITICAL",
                qname: q["qname"],
                length: q["qname"].len(),
                client_ip: client_ip,
                timestamp: timestamp
            });
        }
    }
    
    // Check 3: Fast-Flux DNS Infrastructure (Low TTL + Multiple IPs)
    if parsed_msg["is_response"] && parsed_msg["answers"].len() >= 3 {
        let has_short_ttl = false;
        let min_ttl = 999999;
        let ip_count = 0;
        
        for a in parsed_msg["answers"] {
            if a["type"] == "A" || a["type"] == "AAAA" {
                ip_count = ip_count + 1;
                if a["ttl"] < min_ttl { min_ttl = a["ttl"]; }
                if a["ttl"] <= 60 { has_short_ttl = true; }
            }
        }
        
        if has_short_ttl && ip_count >= 3 {
            alerts.push(#{
                rule: "FAST_FLUX_INFRASTRUCTURE_SUSPECT",
                severity: "HIGH",
                min_ttl: min_ttl,
                resolved_ips: ip_count,
                client_ip: client_ip,
                timestamp: timestamp
            });
        }
    }
    
    // Check 4: Large TXT Record Exfiltration (> 200 bytes in answer)
    for a in parsed_msg["answers"] {
        if a["type"] == "TXT" {
            let txt_len = a["rdata"].len();
            if txt_len > 200 {
                alerts.push(#{
                    rule: "OVERSIZED_DNS_TXT_EXFILTRATION",
                    severity: "CRITICAL",
                    txt_length: txt_len,
                    client_ip: client_ip,
                    timestamp: timestamp
                });
            }
        }
    }
    
    return alerts;
}

// -----------------------------------------------------------------------------
// Pipeline Event Handlers
// -----------------------------------------------------------------------------

fn process_doh_event(event, pipeline_state) {
    let client_ip = event["client_ip"];
    let timestamp = event["timestamp"];
    let parsed = parse_dns_message(event["dns_wire_msg"]);
    let alerts = audit_dns_traffic(parsed, client_ip, timestamp);
    
    return #{
        status: "OK",
        rcode: parsed["rcode_name"],
        is_response: parsed["is_response"],
        question_count: parsed["questions"].len(),
        answer_count: parsed["answers"].len(),
        alerts: alerts
    };
}
