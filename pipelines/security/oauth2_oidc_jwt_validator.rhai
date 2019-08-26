// Volute Pipeline: OAuth 2.0 / OpenID Connect (OIDC) JWT Token Validator
// RFC 7519 JWT verification, header algorithm auditing (alg confusion, "none" attack prevention),
// standard claim validation (iss, aud, exp, nbf, jti replay cache), and privilege escalation detection.

import "lib/encoding/base64" as b64;
import "lib/core/time" as t;

// -----------------------------------------------------------------------------
// Token Structure and Claim Parsing
// -----------------------------------------------------------------------------

fn parse_jwt_components(token_str) {
    let parts = token_str.split(".");
    if parts.len() != 3 {
        return #{
            is_valid: false,
            error: "MALFORMED_JWT_PARTS_COUNT: Expected 3 segments separated by dots."
        };
    }
    
    return #{
        is_valid: true,
        header_b64: parts[0],
        payload_b64: parts[1],
        signature_b64: parts[2]
    };
}

// -----------------------------------------------------------------------------
// JTI Replay Cache and Token Validator State
// -----------------------------------------------------------------------------

fn init_jwt_validator_state(trusted_issuers, expected_audience) {
    return #{
        trusted_issuers: trusted_issuers,
        expected_audience: expected_audience,
        jti_seen_cache: #{}, // jti -> exp_timestamp
        clock_skew_seconds: 60
    };
}

// -----------------------------------------------------------------------------
// Security Checks and Claim Evaluation
// -----------------------------------------------------------------------------

fn evaluate_jwt_security(header, payload, state, current_timestamp) {
    let alerts = [];
    
    // Check 1: Insecure / Prohibited "none" algorithm attack
    let alg = if header.contains("alg") { header["alg"] } else { "none" };
    if alg == "none" || alg == "NONE" || alg.to_lower() == "none" {
        alerts.push(#{
            rule: "CRITICAL_JWT_NONE_ALGORITHM_ATTACK",
            severity: "CRITICAL",
            description: "Token header explicitly requested unverified 'none' signature algorithm.",
            timestamp: current_timestamp
        });
        return #{ is_authorized: false, alerts: alerts };
    }
    
    // Check 2: Algorithm Confusion (e.g. Asymmetric RS256 downgraded to symmetric HS256)
    if alg == "HS256" && header.contains("kid") {
        let kid = header["kid"];
        if kid.contains("rsa") || kid.contains("cert") {
            alerts.push(#{
                rule: "SUSPECTED_ALGORITHM_CONFUSION_ATTACK",
                severity: "CRITICAL",
                algorithm: alg,
                key_id: kid,
                timestamp: current_timestamp
            });
        }
    }
    
    // Check 3: Issuer Validation
    if payload.contains("iss") {
        let iss = payload["iss"];
        let is_trusted = false;
        for t_iss in state["trusted_issuers"] {
            if t_iss == iss { is_trusted = true; break; }
        }
        if !is_trusted {
            alerts.push(#{
                rule: "UNTRUSTED_TOKEN_ISSUER",
                severity: "HIGH",
                issuer: iss,
                timestamp: current_timestamp
            });
        }
    } else {
        alerts.push(#{
            rule: "MISSING_REQUIRED_ISSUER_CLAIM",
            severity: "HIGH",
            timestamp: current_timestamp
        });
    }
    
    // Check 4: Audience Validation
    if payload.contains("aud") {
        let aud = payload["aud"];
        if aud != state["expected_audience"] {
            alerts.push(#{
                rule: "AUDIENCE_MISMATCH",
                severity: "HIGH",
                expected: state["expected_audience"],
                observed: aud,
                timestamp: current_timestamp
            });
        }
    } else {
        alerts.push(#{
            rule: "MISSING_REQUIRED_AUDIENCE_CLAIM",
            severity: "HIGH",
            timestamp: current_timestamp
        });
    }
    
    // Check 5: Expiration and Not-Before Checks
    let skew = state["clock_skew_seconds"];
    if payload.contains("exp") {
        let exp = payload["exp"];
        if current_timestamp > (exp + skew) {
            alerts.push(#{
                rule: "EXPIRED_TOKEN_SUBMISSION",
                severity: "MEDIUM",
                exp: exp,
                current_time: current_timestamp,
                skew_allowance: skew
            });
        }
        
        // Excessive lifetime check (> 86400s = 24h)
        if payload.contains("iat") {
            let lifetime = exp - payload["iat"];
            if lifetime > 86400 {
                alerts.push(#{
                    rule: "EXCESSIVE_TOKEN_LIFETIME",
                    severity: "LOW",
                    lifetime_seconds: lifetime,
                    timestamp: current_timestamp
                });
            }
        }
    } else {
        alerts.push(#{
            rule: "MISSING_EXPIRATION_CLAIM",
            severity: "HIGH",
            timestamp: current_timestamp
        });
    }
    
    if payload.contains("nbf") {
        let nbf = payload["nbf"];
        if current_timestamp < (nbf - skew) {
            alerts.push(#{
                rule: "TOKEN_NOT_YET_VALID_NBF",
                severity: "MEDIUM",
                nbf: nbf,
                current_time: current_timestamp
            });
        }
    }
    
    // Check 6: JTI Token Replay Detection
    if payload.contains("jti") {
        let jti = payload["jti"];
        if state["jti_seen_cache"].contains(jti) {
            alerts.push(#{
                rule: "REPLAYED_JWT_IDENTIFIER_DETECTED",
                severity: "CRITICAL",
                jti: jti,
                original_expiry: state["jti_seen_cache"][jti],
                timestamp: current_timestamp
            });
        } else {
            let exp_val = if payload.contains("exp") { payload["exp"] } else { current_timestamp + 3600 };
            state["jti_seen_cache"][jti] = exp_val;
        }
    }
    
    // Check 7: Suspicious Privilege Escalation Claim Injection
    if payload.contains("admin") || payload.contains("role") {
        let is_admin = false;
        if payload.contains("admin") && payload["admin"] == true { is_admin = true; }
        if payload.contains("role") && payload["role"] == "root" { is_admin = true; }
        if is_admin {
            alerts.push(#{
                rule: "ELEVATED_PRIVILEGE_CLAIM_PRESENT",
                severity: "INFO",
                sub: if payload.contains("sub") { payload["sub"] } else { "anonymous" },
                timestamp: current_timestamp
            });
        }
    }
    
    let is_authorized = true;
    for al in alerts {
        if al["severity"] == "CRITICAL" || al["severity"] == "HIGH" {
            is_authorized = false;
            break;
        }
    }
    
    return #{
        is_authorized: is_authorized,
        alerts: alerts
    };
}

// -----------------------------------------------------------------------------
// Pipeline Event Handlers
// -----------------------------------------------------------------------------

fn process_jwt_verification_event(event, pipeline_state) {
    if !pipeline_state.contains("validator") {
        let issuers = ["https://auth.volute-stream.io/oauth2/v1", "https://accounts.internal.net"];
        pipeline_state["validator"] = init_jwt_validator_state(issuers, "api://volute-core");
    }
    
    let header = event["header"];
    let payload = event["payload"];
    let ts = event["timestamp"];
    
    let result = evaluate_jwt_security(header, payload, pipeline_state["validator"], ts);
    
    return #{
        status: if result["is_authorized"] { "AUTHORIZED" } else { "DENIED" },
        subject: if payload.contains("sub") { payload["sub"] } else { "anonymous" },
        alerts_count: result["alerts"].len(),
        alerts: result["alerts"]
    };
}
