// Volute Pipeline: TLS Handshake & Cipher Suite Security Auditor
// RFC 8446 (TLS 1.3) and RFC 5246 (TLS 1.2) handshake analysis, JA3/JA3S fingerprint generation,
// cipher suite vulnerability classification (SWEET32, POODLE, RC4, DROWN), and SNI domain inspection.

// -----------------------------------------------------------------------------
// TLS Protocol Versions & Dictionaries
// -----------------------------------------------------------------------------

fn get_tls_version_name(version_hex) {
    if version_hex == "0x0300" || version_hex == "0300" { return "SSL 3.0"; }
    if version_hex == "0x0301" || version_hex == "0301" { return "TLS 1.0"; }
    if version_hex == "0x0302" || version_hex == "0302" { return "TLS 1.1"; }
    if version_hex == "0x0303" || version_hex == "0303" { return "TLS 1.2"; }
    if version_hex == "0x0304" || version_hex == "0304" { return "TLS 1.3"; }
    return "Unknown-TLS-" + version_hex;
}

// -----------------------------------------------------------------------------
// Cipher Suite Security Classification
// -----------------------------------------------------------------------------

fn classify_cipher_suite(cipher_code) {
    // Modern TLS 1.3 AEAD Ciphers
    if cipher_code == "0x1301" { return #{ name: "TLS_AES_128_GCM_SHA256", grade: "SECURE", pfs: true, aead: true }; }
    if cipher_code == "0x1302" { return #{ name: "TLS_AES_256_GCM_SHA384", grade: "SECURE", pfs: true, aead: true }; }
    if cipher_code == "0x1303" { return #{ name: "TLS_CHACHA20_POLY1305_SHA256", grade: "SECURE", pfs: true, aead: true }; }
    if cipher_code == "0x1304" { return #{ name: "TLS_AES_128_CCM_SHA256", grade: "SECURE", pfs: true, aead: true }; }
    
    // Modern TLS 1.2 ECDHE AEAD Ciphers
    if cipher_code == "0xc02f" { return #{ name: "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256", grade: "SECURE", pfs: true, aead: true }; }
    if cipher_code == "0xc030" { return #{ name: "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384", grade: "SECURE", pfs: true, aead: true }; }
    if cipher_code == "0xc02b" { return #{ name: "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256", grade: "SECURE", pfs: true, aead: true }; }
    if cipher_code == "0xc02c" { return #{ name: "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384", grade: "SECURE", pfs: true, aead: true }; }
    if cipher_code == "0xcca8" { return #{ name: "TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256", grade: "SECURE", pfs: true, aead: true }; }
    if cipher_code == "0xcca9" { return #{ name: "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256", grade: "SECURE", pfs: true, aead: true }; }

    // Weak Ciphers: CBC mode without AEAD (Vulnerable to padding oracles)
    if cipher_code == "0xc013" { return #{ name: "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA", grade: "WEAK", vulnerability: "CBC_PADDING_ORACLE", pfs: true, aead: false }; }
    if cipher_code == "0xc014" { return #{ name: "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA", grade: "WEAK", vulnerability: "CBC_PADDING_ORACLE", pfs: true, aead: false }; }
    if cipher_code == "0x009c" { return #{ name: "TLS_RSA_WITH_AES_128_GCM_SHA256", grade: "WEAK", vulnerability: "NO_FORWARD_SECRECY", pfs: false, aead: true }; }
    if cipher_code == "0x002f" { return #{ name: "TLS_RSA_WITH_AES_128_CBC_SHA", grade: "WEAK", vulnerability: "NO_PFS_AND_CBC", pfs: false, aead: false }; }

    // Insecure / Prohibited Ciphers
    if cipher_code == "0x000a" { return #{ name: "TLS_RSA_WITH_3DES_EDE_CBC_SHA", grade: "INSECURE", vulnerability: "SWEET32_64BIT_BLOCK", pfs: false, aead: false }; }
    if cipher_code == "0x0005" { return #{ name: "TLS_RSA_WITH_RC4_128_SHA", grade: "INSECURE", vulnerability: "RC4_BIAS_EXPLOIT", pfs: false, aead: false }; }
    if cipher_code == "0x0004" { return #{ name: "TLS_RSA_WITH_RC4_128_MD5", grade: "INSECURE", vulnerability: "RC4_MD5_COLLISION", pfs: false, aead: false }; }
    if cipher_code == "0x0000" { return #{ name: "TLS_NULL_WITH_NULL_NULL", grade: "CRITICAL_INSECURE", vulnerability: "NULL_CIPHER_CLEARTEXT", pfs: false, aead: false }; }
    
    return #{
        name: "UNKNOWN_CIPHER_" + cipher_code,
        grade: "UNKNOWN",
        pfs: false,
        aead: false
    };
}

// -----------------------------------------------------------------------------
// JA3 Fingerprint Construction
// -----------------------------------------------------------------------------

fn build_ja3_string(ssl_version, cipher_suites, extensions, elliptic_curves, ec_point_formats) {
    let ciphers_str = "";
    for i in 0..cipher_suites.len() {
        if i > 0 { ciphers_str = ciphers_str + "-"; }
        ciphers_str = ciphers_str + cipher_suites[i];
    }
    
    let exts_str = "";
    for i in 0..extensions.len() {
        if i > 0 { exts_str = exts_str + "-"; }
        exts_str = exts_str + extensions[i];
    }
    
    let curves_str = "";
    for i in 0..elliptic_curves.len() {
        if i > 0 { curves_str = curves_str + "-"; }
        curves_str = curves_str + elliptic_curves[i];
    }
    
    let ec_points_str = "";
    for i in 0..ec_point_formats.len() {
        if i > 0 { ec_points_str = ec_points_str + "-"; }
        ec_points_str = ec_points_str + ec_point_formats[i];
    }
    
    // JA3 string format: SSLVersion,Cipher,SSLExtension,EllipticCurve,EllipticCurvePointFormat
    return ssl_version + "," + ciphers_str + "," + exts_str + "," + curves_str + "," + ec_points_str;
}

// -----------------------------------------------------------------------------
// Handshake Auditing Engine
// -----------------------------------------------------------------------------

fn audit_client_hello(hello_event) {
    let version = hello_event["version"];
    let version_name = get_tls_version_name(version);
    let ciphers = hello_event["cipher_suites"];
    let extensions = hello_event["extensions"];
    let sni = if hello_event.contains("sni") { hello_event["sni"] } else { "" };
    let timestamp = hello_event["timestamp"];
    
    let alerts = [];
    
    // Check 1: Deprecated Protocol Version Check
    if version == "0x0300" || version == "0x0301" || version == "0x0302" {
        alerts.push(#{
            rule: "DEPRECATED_TLS_VERSION_OFFERED",
            severity: "HIGH",
            version: version_name,
            timestamp: timestamp
        });
    }
    
    // Check 2: Insecure / Broken Ciphers in Offered List
    let insecure_offered = [];
    for c in ciphers {
        let classification = classify_cipher_suite(c);
        if classification["grade"] == "INSECURE" || classification["grade"] == "CRITICAL_INSECURE" {
            insecure_offered.push(classification["name"]);
        }
    }
    if insecure_offered.len() > 0 {
        alerts.push(#{
            rule: "INSECURE_CIPHERS_OFFERED",
            severity: "CRITICAL",
            ciphers: insecure_offered,
            timestamp: timestamp
        });
    }
    
    // Check 3: Raw IP address in SNI or missing SNI
    if sni.is_empty() {
        alerts.push(#{
            rule: "MISSING_SNI_EXTENSION",
            severity: "LOW",
            timestamp: timestamp
        });
    } else {
        let is_ip = false;
        let parts = sni.split(".");
        if parts.len() == 4 {
            let all_digits = true;
            for p in parts {
                if p.to_int() == 0 && p != "0" {
                    all_digits = false;
                }
            }
            if all_digits { is_ip = true; }
        }
        if is_ip {
            alerts.push(#{
                rule: "DIRECT_IP_IN_SNI_EXTENSION",
                severity: "MEDIUM",
                sni: sni,
                timestamp: timestamp
            });
        }
    }
    
    // Compute JA3 string
    let curves = if hello_event.contains("curves") { hello_event["curves"] } else { [] };
    let ec_points = if hello_event.contains("ec_points") { hello_event["ec_points"] } else { [] };
    let ja3_raw = build_ja3_string(version, ciphers, extensions, curves, ec_points);
    let ja3_hash = md5(ja3_raw);
    
    return #{
        version: version_name,
        sni: sni,
        ja3_raw: ja3_raw,
        ja3_hash: ja3_hash,
        cipher_count: ciphers.len(),
        alerts: alerts
    };
}

// -----------------------------------------------------------------------------
// Pipeline Event Handlers
// -----------------------------------------------------------------------------

fn process_tls_event(event, auditor_state) {
    let handshake_type = event["handshake_type"]; // "ClientHello", "ServerHello"
    let timestamp = event["timestamp"];
    
    if handshake_type == "ClientHello" {
        let audit = audit_client_hello(event);
        return #{
            status: "OK",
            handshake: handshake_type,
            audit: audit,
            alerts: audit["alerts"]
        };
    } else if handshake_type == "ServerHello" {
        let selected_cipher = event["selected_cipher"];
        let classification = classify_cipher_suite(selected_cipher);
        let alerts = [];
        
        if classification["grade"] == "INSECURE" || classification["grade"] == "CRITICAL_INSECURE" {
            alerts.push(#{
                rule: "INSECURE_CIPHER_NEGOTIATED",
                severity: "CRITICAL",
                selected_cipher: classification["name"],
                vulnerability: classification["vulnerability"],
                timestamp: timestamp
            });
        }
        
        return #{
            status: "OK",
            handshake: handshake_type,
            selected_cipher: classification["name"],
            grade: classification["grade"],
            alerts: alerts
        };
    }
    
    return #{
        status: "IGNORED",
        handshake: handshake_type
    };
}
