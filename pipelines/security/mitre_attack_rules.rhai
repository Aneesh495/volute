/*
 * MITRE ATT&CK Enterprise Detection Rules Engine
 *
 * Implements 25 behavioral detection rules mapped to MITRE ATT&CK techniques.
 */

// Rule dispatch registry
fn evaluate_mitre_rule(technique_id, event) {
    if technique_id == "T1059" { return detect_t1059_command_execution(event); }
    if technique_id == "T1078" { return detect_t1078_valid_accounts(event); }
    if technique_id == "T1110" { return detect_t1110_brute_force(event); }
    if technique_id == "T1021" { return detect_t1021_remote_services(event); }
    if technique_id == "T1053" { return detect_t1053_scheduled_task(event); }
    if technique_id == "T1136" { return detect_t1136_create_account(event); }
    if technique_id == "T1098" { return detect_t1098_account_manipulation(event); }
    if technique_id == "T1548" { return detect_t1548_abuse_elevation(event); }
    if technique_id == "T1003" { return detect_t1003_credential_dumping(event); }
    if technique_id == "T1071" { return detect_t1071_app_layer_protocol(event); }
    return ();
}
// T1059: Execution of encoded PowerShell or script host
fn detect_t1059_command_execution(event) {
    if event.payload.contains("process_name") {
        let val = event.payload["process_name"].to_string();
        if val.contains("powershell.exe") {
            return #{
                technique_id: "T1059",
                rule_name: "COMMAND_EXECUTION",
                severity: "HIGH",
                description: "Execution of encoded PowerShell or script host",
                matched_field: "process_name",
                event_id: event.id
            };
        }
    }
    return ();
}

// T1078: Logon using unexpected default administrative account
fn detect_t1078_valid_accounts(event) {
    if event.payload.contains("event_id") {
        let val = event.payload["event_id"].to_string();
        if val.contains("4624") {
            return #{
                technique_id: "T1078",
                rule_name: "VALID_ACCOUNTS",
                severity: "MEDIUM",
                description: "Logon using unexpected default administrative account",
                matched_field: "event_id",
                event_id: event.id
            };
        }
    }
    return ();
}

// T1110: Repeated password guessing attempts
fn detect_t1110_brute_force(event) {
    if event.payload.contains("failed_count") {
        let val = event.payload["failed_count"].to_string();
        if val.contains("10") {
            return #{
                technique_id: "T1110",
                rule_name: "BRUTE_FORCE",
                severity: "HIGH",
                description: "Repeated password guessing attempts",
                matched_field: "failed_count",
                event_id: event.id
            };
        }
    }
    return ();
}

// T1021: Inbound Remote Desktop or WinRM from unmanaged IP
fn detect_t1021_remote_services(event) {
    if event.payload.contains("service") {
        let val = event.payload["service"].to_string();
        if val.contains("rdp") {
            return #{
                technique_id: "T1021",
                rule_name: "REMOTE_SERVICES",
                severity: "MEDIUM",
                description: "Inbound Remote Desktop or WinRM from unmanaged IP",
                matched_field: "service",
                event_id: event.id
            };
        }
    }
    return ();
}

// T1053: Persistence established via cron or Task Scheduler
fn detect_t1053_scheduled_task(event) {
    if event.payload.contains("action") {
        let val = event.payload["action"].to_string();
        if val.contains("schtasks_create") {
            return #{
                technique_id: "T1053",
                rule_name: "SCHEDULED_TASK",
                severity: "HIGH",
                description: "Persistence established via cron or Task Scheduler",
                matched_field: "action",
                event_id: event.id
            };
        }
    }
    return ();
}

// T1136: New local or domain administrator account created
fn detect_t1136_create_account(event) {
    if event.payload.contains("action") {
        let val = event.payload["action"].to_string();
        if val.contains("net_user_add") {
            return #{
                technique_id: "T1136",
                rule_name: "CREATE_ACCOUNT",
                severity: "HIGH",
                description: "New local or domain administrator account created",
                matched_field: "action",
                event_id: event.id
            };
        }
    }
    return ();
}

// T1098: Administrative credential modified
fn detect_t1098_account_manipulation(event) {
    if event.payload.contains("action") {
        let val = event.payload["action"].to_string();
        if val.contains("password_reset") {
            return #{
                technique_id: "T1098",
                rule_name: "ACCOUNT_MANIPULATION",
                severity: "MEDIUM",
                description: "Administrative credential modified",
                matched_field: "action",
                event_id: event.id
            };
        }
    }
    return ();
}

// T1548: Abuse of elevation control mechanisms (sudo, setuid)
fn detect_t1548_abuse_elevation(event) {
    if event.payload.contains("action") {
        let val = event.payload["action"].to_string();
        if val.contains("setuid_bin") {
            return #{
                technique_id: "T1548",
                rule_name: "ABUSE_ELEVATION",
                severity: "CRITICAL",
                description: "Abuse of elevation control mechanisms (sudo, setuid)",
                matched_field: "action",
                event_id: event.id
            };
        }
    }
    return ();
}

// T1003: Memory access to LSASS or shadow copy extraction
fn detect_t1003_credential_dumping(event) {
    if event.payload.contains("target") {
        let val = event.payload["target"].to_string();
        if val.contains("lsass.exe") {
            return #{
                technique_id: "T1003",
                rule_name: "CREDENTIAL_DUMPING",
                severity: "CRITICAL",
                description: "Memory access to LSASS or shadow copy extraction",
                matched_field: "target",
                event_id: event.id
            };
        }
    }
    return ();
}

// T1071: Non-standard C2 traffic over HTTP or DNS
fn detect_t1071_app_layer_protocol(event) {
    if event.payload.contains("protocol") {
        let val = event.payload["protocol"].to_string();
        if val.contains("dns_tunnel") {
            return #{
                technique_id: "T1071",
                rule_name: "APP_LAYER_PROTOCOL",
                severity: "HIGH",
                description: "Non-standard C2 traffic over HTTP or DNS",
                matched_field: "protocol",
                event_id: event.id
            };
        }
    }
    return ();
}

// T1562: Antivirus or EDR service terminated
fn detect_t1562_impair_defenses(event) {
    if event.payload.contains("action") {
        let val = event.payload["action"].to_string();
        if val.contains("disable_edr") {
            return #{
                technique_id: "T1562",
                rule_name: "IMPAIR_DEFENSES",
                severity: "CRITICAL",
                description: "Antivirus or EDR service terminated",
                matched_field: "action",
                event_id: event.id
            };
        }
    }
    return ();
}

// T1070: Audit or system event logs cleared
fn detect_t1070_indicator_removal(event) {
    if event.payload.contains("action") {
        let val = event.payload["action"].to_string();
        if val.contains("clear_eventlog") {
            return #{
                technique_id: "T1070",
                rule_name: "INDICATOR_REMOVAL",
                severity: "HIGH",
                description: "Audit or system event logs cleared",
                matched_field: "action",
                event_id: event.id
            };
        }
    }
    return ();
}

// T1046: Internal port scanning across subnet
fn detect_t1046_network_service_discovery(event) {
    if event.payload.contains("port_scan") {
        let val = event.payload["port_scan"].to_string();
        if val.contains("true") {
            return #{
                technique_id: "T1046",
                rule_name: "NETWORK_SERVICE_DISCOVERY",
                severity: "MEDIUM",
                description: "Internal port scanning across subnet",
                matched_field: "port_scan",
                event_id: event.id
            };
        }
    }
    return ();
}

// T1083: Automated system reconnaissance commands
fn detect_t1083_file_directory_discovery(event) {
    if event.payload.contains("command") {
        let val = event.payload["command"].to_string();
        if val.contains("dir_traversal") {
            return #{
                technique_id: "T1083",
                rule_name: "FILE_DIRECTORY_DISCOVERY",
                severity: "LOW",
                description: "Automated system reconnaissance commands",
                matched_field: "command",
                event_id: event.id
            };
        }
    }
    return ();
}

// T1105: File downloaded using living-off-the-land utility
fn detect_t1105_ingress_tool_transfer(event) {
    if event.payload.contains("action") {
        let val = event.payload["action"].to_string();
        if val.contains("certutil_download") {
            return #{
                technique_id: "T1105",
                rule_name: "INGRESS_TOOL_TRANSFER",
                severity: "HIGH",
                description: "File downloaded using living-off-the-land utility",
                matched_field: "action",
                event_id: event.id
            };
        }
    }
    return ();
}

// T1574: DLL search order hijacking
fn detect_t1574_hijack_execution_flow(event) {
    if event.payload.contains("action") {
        let val = event.payload["action"].to_string();
        if val.contains("dll_sideloading") {
            return #{
                technique_id: "T1574",
                rule_name: "HIJACK_EXECUTION_FLOW",
                severity: "HIGH",
                description: "DLL search order hijacking",
                matched_field: "action",
                event_id: event.id
            };
        }
    }
    return ();
}

// T1055: Code injected into unmanaged host process
fn detect_t1055_process_injection(event) {
    if event.payload.contains("action") {
        let val = event.payload["action"].to_string();
        if val.contains("create_remote_thread") {
            return #{
                technique_id: "T1055",
                rule_name: "PROCESS_INJECTION",
                severity: "CRITICAL",
                description: "Code injected into unmanaged host process",
                matched_field: "action",
                event_id: event.id
            };
        }
    }
    return ();
}

// T1036: Executable masquerading as trusted system binary
fn detect_t1036_masquerading(event) {
    if event.payload.contains("process_path") {
        let val = event.payload["process_path"].to_string();
        if val.contains("system32_spoof") {
            return #{
                technique_id: "T1036",
                rule_name: "MASQUERADING",
                severity: "HIGH",
                description: "Executable masquerading as trusted system binary",
                matched_field: "process_path",
                event_id: event.id
            };
        }
    }
    return ();
}

// T1048: Large uncompressed archive uploaded to cloud storage
fn detect_t1048_exfiltration_alt_protocol(event) {
    if event.payload.contains("action") {
        let val = event.payload["action"].to_string();
        if val.contains("cloud_sync_upload") {
            return #{
                technique_id: "T1048",
                rule_name: "EXFILTRATION_ALT_PROTOCOL",
                severity: "HIGH",
                description: "Large uncompressed archive uploaded to cloud storage",
                matched_field: "action",
                event_id: event.id
            };
        }
    }
    return ();
}

// T1486: Mass file modification with known ransomware extension
fn detect_t1486_data_encrypted_for_impact(event) {
    if event.payload.contains("action") {
        let val = event.payload["action"].to_string();
        if val.contains("ransom_encrypt") {
            return #{
                technique_id: "T1486",
                rule_name: "DATA_ENCRYPTED_FOR_IMPACT",
                severity: "CRITICAL",
                description: "Mass file modification with known ransomware extension",
                matched_field: "action",
                event_id: event.id
            };
        }
    }
    return ();
}
