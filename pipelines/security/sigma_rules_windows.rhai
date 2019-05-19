/*
 * Windows Security Event Log Sigma Detection Rules Suite
 *
 * Maps Windows Event IDs (4624, 4625, 4688, 4720, etc.) to security alerts.
 */

// Evaluate event against Windows detection rulepack
fn evaluate_windows_sigma(event) {
    let alerts = [];
    // Rule: proc_creation_powershell_download (EventID 4688)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4688" {
        if event.payload.contains("CommandLine") {
            let field_val = event.payload["CommandLine"].to_string().to_lower();
            if field_val.contains("downloadstring") {
                alerts.push(#{
                    rule: "proc_creation_powershell_download",
                    event_id: 4688,
                    severity: "CRITICAL",
                    description: "PowerShell download cradle via DownloadString"
                });
            }
        }
    }
    // Rule: proc_creation_powershell_enc_cmd (EventID 4688)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4688" {
        if event.payload.contains("CommandLine") {
            let field_val = event.payload["CommandLine"].to_string().to_lower();
            if field_val.contains("-encodedcommand") {
                alerts.push(#{
                    rule: "proc_creation_powershell_enc_cmd",
                    event_id: 4688,
                    severity: "HIGH",
                    description: "PowerShell execution with base64 encoded command"
                });
            }
        }
    }
    // Rule: proc_creation_cmd_recon (EventID 4688)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4688" {
        if event.payload.contains("CommandLine") {
            let field_val = event.payload["CommandLine"].to_string().to_lower();
            if field_val.contains("whoami /all") {
                alerts.push(#{
                    rule: "proc_creation_cmd_recon",
                    event_id: 4688,
                    severity: "LOW",
                    description: "Local reconnaissance command whoami"
                });
            }
        }
    }
    // Rule: proc_creation_net_recon (EventID 4688)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4688" {
        if event.payload.contains("CommandLine") {
            let field_val = event.payload["CommandLine"].to_string().to_lower();
            if field_val.contains("net group domain admins") {
                alerts.push(#{
                    rule: "proc_creation_net_recon",
                    event_id: 4688,
                    severity: "MEDIUM",
                    description: "Active Directory domain administrator enumeration"
                });
            }
        }
    }
    // Rule: proc_creation_vssadmin_delete (EventID 4688)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4688" {
        if event.payload.contains("CommandLine") {
            let field_val = event.payload["CommandLine"].to_string().to_lower();
            if field_val.contains("vssadmin delete shadows") {
                alerts.push(#{
                    rule: "proc_creation_vssadmin_delete",
                    event_id: 4688,
                    severity: "CRITICAL",
                    description: "Shadow copy deletion inhibiting system recovery"
                });
            }
        }
    }
    // Rule: proc_creation_bcdr_wbadmin (EventID 4688)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4688" {
        if event.payload.contains("CommandLine") {
            let field_val = event.payload["CommandLine"].to_string().to_lower();
            if field_val.contains("wbadmin delete catalog") {
                alerts.push(#{
                    rule: "proc_creation_bcdr_wbadmin",
                    event_id: 4688,
                    severity: "CRITICAL",
                    description: "Backup catalog deletion inhibiting recovery"
                });
            }
        }
    }
    // Rule: proc_creation_certutil_decode (EventID 4688)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4688" {
        if event.payload.contains("CommandLine") {
            let field_val = event.payload["CommandLine"].to_string().to_lower();
            if field_val.contains("certutil -decode") {
                alerts.push(#{
                    rule: "proc_creation_certutil_decode",
                    event_id: 4688,
                    severity: "HIGH",
                    description: "Certutil file decode living-off-the-land utility"
                });
            }
        }
    }
    // Rule: proc_creation_rundll32_susp (EventID 4688)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4688" {
        if event.payload.contains("CommandLine") {
            let field_val = event.payload["CommandLine"].to_string().to_lower();
            if field_val.contains("rundll32.exe javascript:") {
                alerts.push(#{
                    rule: "proc_creation_rundll32_susp",
                    event_id: 4688,
                    severity: "CRITICAL",
                    description: "Rundll32 inline JavaScript execution"
                });
            }
        }
    }
    // Rule: proc_creation_reg_add_run (EventID 4688)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4688" {
        if event.payload.contains("CommandLine") {
            let field_val = event.payload["CommandLine"].to_string().to_lower();
            if field_val.contains("reg add hkcu/software/microsoft/windows/currentversion/run") {
                alerts.push(#{
                    rule: "proc_creation_reg_add_run",
                    event_id: 4688,
                    severity: "HIGH",
                    description: "Registry persistence run key modification"
                });
            }
        }
    }
    // Rule: proc_creation_wmic_process_call (EventID 4688)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4688" {
        if event.payload.contains("CommandLine") {
            let field_val = event.payload["CommandLine"].to_string().to_lower();
            if field_val.contains("wmic process call create") {
                alerts.push(#{
                    rule: "proc_creation_wmic_process_call",
                    event_id: 4688,
                    severity: "HIGH",
                    description: "Lateral movement via WMIC process creation"
                });
            }
        }
    }
    // Rule: proc_creation_bitsadmin_transfer (EventID 4688)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4688" {
        if event.payload.contains("CommandLine") {
            let field_val = event.payload["CommandLine"].to_string().to_lower();
            if field_val.contains("bitsadmin /transfer") {
                alerts.push(#{
                    rule: "proc_creation_bitsadmin_transfer",
                    event_id: 4688,
                    severity: "MEDIUM",
                    description: "BITS job file download"
                });
            }
        }
    }
    // Rule: proc_creation_mshta_exec (EventID 4688)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4688" {
        if event.payload.contains("CommandLine") {
            let field_val = event.payload["CommandLine"].to_string().to_lower();
            if field_val.contains("mshta http") {
                alerts.push(#{
                    rule: "proc_creation_mshta_exec",
                    event_id: 4688,
                    severity: "CRITICAL",
                    description: "Remote HTA file execution via mshta.exe"
                });
            }
        }
    }
    // Rule: proc_creation_cscript_vbs (EventID 4688)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4688" {
        if event.payload.contains("CommandLine") {
            let field_val = event.payload["CommandLine"].to_string().to_lower();
            if field_val.contains("cscript //nologo") {
                alerts.push(#{
                    rule: "proc_creation_cscript_vbs",
                    event_id: 4688,
                    severity: "MEDIUM",
                    description: "Script host execution via cscript"
                });
            }
        }
    }
    // Rule: proc_creation_attrib_hidden (EventID 4688)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4688" {
        if event.payload.contains("CommandLine") {
            let field_val = event.payload["CommandLine"].to_string().to_lower();
            if field_val.contains("attrib +h +s") {
                alerts.push(#{
                    rule: "proc_creation_attrib_hidden",
                    event_id: 4688,
                    severity: "LOW",
                    description: "File hidden attribute assignment"
                });
            }
        }
    }
    // Rule: proc_creation_takeown_admin (EventID 4688)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4688" {
        if event.payload.contains("CommandLine") {
            let field_val = event.payload["CommandLine"].to_string().to_lower();
            if field_val.contains("takeown /f") {
                alerts.push(#{
                    rule: "proc_creation_takeown_admin",
                    event_id: 4688,
                    severity: "MEDIUM",
                    description: "Ownership takeover of sensitive file"
                });
            }
        }
    }
    // Rule: win_auth_failed_logon (EventID 4625)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4625" {
        if event.payload.contains("SubStatus") {
            let field_val = event.payload["SubStatus"].to_string().to_lower();
            if field_val.contains("0xc000006a") {
                alerts.push(#{
                    rule: "win_auth_failed_logon",
                    event_id: 4625,
                    severity: "LOW",
                    description: "Failed logon bad password"
                });
            }
        }
    }
    // Rule: win_auth_account_locked (EventID 4740)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4740" {
        if event.payload.contains("TargetUserName") {
            let field_val = event.payload["TargetUserName"].to_string().to_lower();
            if field_val.contains("admin") {
                alerts.push(#{
                    rule: "win_auth_account_locked",
                    event_id: 4740,
                    severity: "HIGH",
                    description: "Administrative account lockout event"
                });
            }
        }
    }
    // Rule: win_auth_pass_spray (EventID 4625)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4625" {
        if event.payload.contains("FailureReason") {
            let field_val = event.payload["FailureReason"].to_string().to_lower();
            if field_val.contains("%%2313") {
                alerts.push(#{
                    rule: "win_auth_pass_spray",
                    event_id: 4625,
                    severity: "HIGH",
                    description: "Potential password spraying detected"
                });
            }
        }
    }
    // Rule: win_auth_special_privs (EventID 4672)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4672" {
        if event.payload.contains("PrivilegeList") {
            let field_val = event.payload["PrivilegeList"].to_string().to_lower();
            if field_val.contains("sedebugprivilege") {
                alerts.push(#{
                    rule: "win_auth_special_privs",
                    event_id: 4672,
                    severity: "MEDIUM",
                    description: "Special administrative privileges assigned to logon session"
                });
            }
        }
    }
    // Rule: win_auth_explicit_creds (EventID 4648)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4648" {
        if event.payload.contains("TargetServerName") {
            let field_val = event.payload["TargetServerName"].to_string().to_lower();
            if field_val.contains("localhost") {
                alerts.push(#{
                    rule: "win_auth_explicit_creds",
                    event_id: 4648,
                    severity: "LOW",
                    description: "Logon attempted with explicit credentials"
                });
            }
        }
    }
    // Rule: win_sec_log_cleared (EventID 1102)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "1102" {
        if event.payload.contains("EventID") {
            let field_val = event.payload["EventID"].to_string().to_lower();
            if field_val.contains("1102") {
                alerts.push(#{
                    rule: "win_sec_log_cleared",
                    event_id: 1102,
                    severity: "CRITICAL",
                    description: "Windows Security audit log cleared"
                });
            }
        }
    }
    // Rule: win_user_account_created (EventID 4720)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4720" {
        if event.payload.contains("TargetUserName") {
            let field_val = event.payload["TargetUserName"].to_string().to_lower();
            if field_val.contains("backdoor") {
                alerts.push(#{
                    rule: "win_user_account_created",
                    event_id: 4720,
                    severity: "HIGH",
                    description: "New user account provisioned"
                });
            }
        }
    }
    // Rule: win_user_account_enabled (EventID 4722)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4722" {
        if event.payload.contains("TargetUserName") {
            let field_val = event.payload["TargetUserName"].to_string().to_lower();
            if field_val.contains("guest") {
                alerts.push(#{
                    rule: "win_user_account_enabled",
                    event_id: 4722,
                    severity: "HIGH",
                    description: "Disabled user account enabled"
                });
            }
        }
    }
    // Rule: win_group_admin_added (EventID 4728)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4728" {
        if event.payload.contains("TargetGroupName") {
            let field_val = event.payload["TargetGroupName"].to_string().to_lower();
            if field_val.contains("domain admins") {
                alerts.push(#{
                    rule: "win_group_admin_added",
                    event_id: 4728,
                    severity: "CRITICAL",
                    description: "User added to global Domain Admins group"
                });
            }
        }
    }
    // Rule: win_service_installed (EventID 7045)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "7045" {
        if event.payload.contains("ServiceName") {
            let field_val = event.payload["ServiceName"].to_string().to_lower();
            if field_val.contains("psexesvc") {
                alerts.push(#{
                    rule: "win_service_installed",
                    event_id: 7045,
                    severity: "HIGH",
                    description: "PsExec lateral movement service installed"
                });
            }
        }
    }
    // Rule: win_share_accessed (EventID 5140)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "5140" {
        if event.payload.contains("ShareName") {
            let field_val = event.payload["ShareName"].to_string().to_lower();
            if field_val.contains("/*/admin$") {
                alerts.push(#{
                    rule: "win_share_accessed",
                    event_id: 5140,
                    severity: "MEDIUM",
                    description: "Administrative share ADMIN$ accessed over SMB"
                });
            }
        }
    }
    // Rule: win_kerb_tgt_request (EventID 4768)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4768" {
        if event.payload.contains("TicketOptions") {
            let field_val = event.payload["TicketOptions"].to_string().to_lower();
            if field_val.contains("0x40810010") {
                alerts.push(#{
                    rule: "win_kerb_tgt_request",
                    event_id: 4768,
                    severity: "LOW",
                    description: "Kerberos TGT requested without pre-authentication"
                });
            }
        }
    }
    // Rule: win_kerb_ticket_encryption (EventID 4769)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4769" {
        if event.payload.contains("TicketEncryptionType") {
            let field_val = event.payload["TicketEncryptionType"].to_string().to_lower();
            if field_val.contains("0x17") {
                alerts.push(#{
                    rule: "win_kerb_ticket_encryption",
                    event_id: 4769,
                    severity: "HIGH",
                    description: "Kerberoasting RC4-HMAC service ticket requested"
                });
            }
        }
    }
    // Rule: win_task_created (EventID 4698)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4698" {
        if event.payload.contains("TaskName") {
            let field_val = event.payload["TaskName"].to_string().to_lower();
            if field_val.contains("persistence") {
                alerts.push(#{
                    rule: "win_task_created",
                    event_id: 4698,
                    severity: "HIGH",
                    description: "New scheduled task registered"
                });
            }
        }
    }
    // Rule: win_task_updated (EventID 4702)
    if event.payload.contains("EventID") && event.payload["EventID"].to_string() == "4702" {
        if event.payload.contains("TaskName") {
            let field_val = event.payload["TaskName"].to_string().to_lower();
            if field_val.contains("updater") {
                alerts.push(#{
                    rule: "win_task_updated",
                    event_id: 4702,
                    severity: "MEDIUM",
                    description: "Existing scheduled task updated"
                });
            }
        }
    }
    return alerts;
}
// proc_creation_powershell_download: PowerShell download cradle via DownloadString
fn check_proc_creation_powershell_download(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4688" { return false; }
    if !event.payload.contains("CommandLine") { return false; }
    let s = event.payload["CommandLine"].to_string().to_lower();
    return s.contains("downloadstring");
}

// proc_creation_powershell_enc_cmd: PowerShell execution with base64 encoded command
fn check_proc_creation_powershell_enc_cmd(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4688" { return false; }
    if !event.payload.contains("CommandLine") { return false; }
    let s = event.payload["CommandLine"].to_string().to_lower();
    return s.contains("-encodedcommand");
}

// proc_creation_cmd_recon: Local reconnaissance command whoami
fn check_proc_creation_cmd_recon(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4688" { return false; }
    if !event.payload.contains("CommandLine") { return false; }
    let s = event.payload["CommandLine"].to_string().to_lower();
    return s.contains("whoami /all");
}

// proc_creation_net_recon: Active Directory domain administrator enumeration
fn check_proc_creation_net_recon(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4688" { return false; }
    if !event.payload.contains("CommandLine") { return false; }
    let s = event.payload["CommandLine"].to_string().to_lower();
    return s.contains("net group domain admins");
}

// proc_creation_vssadmin_delete: Shadow copy deletion inhibiting system recovery
fn check_proc_creation_vssadmin_delete(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4688" { return false; }
    if !event.payload.contains("CommandLine") { return false; }
    let s = event.payload["CommandLine"].to_string().to_lower();
    return s.contains("vssadmin delete shadows");
}

// proc_creation_bcdr_wbadmin: Backup catalog deletion inhibiting recovery
fn check_proc_creation_bcdr_wbadmin(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4688" { return false; }
    if !event.payload.contains("CommandLine") { return false; }
    let s = event.payload["CommandLine"].to_string().to_lower();
    return s.contains("wbadmin delete catalog");
}

// proc_creation_certutil_decode: Certutil file decode living-off-the-land utility
fn check_proc_creation_certutil_decode(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4688" { return false; }
    if !event.payload.contains("CommandLine") { return false; }
    let s = event.payload["CommandLine"].to_string().to_lower();
    return s.contains("certutil -decode");
}

// proc_creation_rundll32_susp: Rundll32 inline JavaScript execution
fn check_proc_creation_rundll32_susp(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4688" { return false; }
    if !event.payload.contains("CommandLine") { return false; }
    let s = event.payload["CommandLine"].to_string().to_lower();
    return s.contains("rundll32.exe javascript:");
}

// proc_creation_reg_add_run: Registry persistence run key modification
fn check_proc_creation_reg_add_run(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4688" { return false; }
    if !event.payload.contains("CommandLine") { return false; }
    let s = event.payload["CommandLine"].to_string().to_lower();
    return s.contains("reg add hkcu/software/microsoft/windows/currentversion/run");
}

// proc_creation_wmic_process_call: Lateral movement via WMIC process creation
fn check_proc_creation_wmic_process_call(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4688" { return false; }
    if !event.payload.contains("CommandLine") { return false; }
    let s = event.payload["CommandLine"].to_string().to_lower();
    return s.contains("wmic process call create");
}

// proc_creation_bitsadmin_transfer: BITS job file download
fn check_proc_creation_bitsadmin_transfer(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4688" { return false; }
    if !event.payload.contains("CommandLine") { return false; }
    let s = event.payload["CommandLine"].to_string().to_lower();
    return s.contains("bitsadmin /transfer");
}

// proc_creation_mshta_exec: Remote HTA file execution via mshta.exe
fn check_proc_creation_mshta_exec(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4688" { return false; }
    if !event.payload.contains("CommandLine") { return false; }
    let s = event.payload["CommandLine"].to_string().to_lower();
    return s.contains("mshta http");
}

// proc_creation_cscript_vbs: Script host execution via cscript
fn check_proc_creation_cscript_vbs(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4688" { return false; }
    if !event.payload.contains("CommandLine") { return false; }
    let s = event.payload["CommandLine"].to_string().to_lower();
    return s.contains("cscript //nologo");
}

// proc_creation_attrib_hidden: File hidden attribute assignment
fn check_proc_creation_attrib_hidden(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4688" { return false; }
    if !event.payload.contains("CommandLine") { return false; }
    let s = event.payload["CommandLine"].to_string().to_lower();
    return s.contains("attrib +h +s");
}

// proc_creation_takeown_admin: Ownership takeover of sensitive file
fn check_proc_creation_takeown_admin(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4688" { return false; }
    if !event.payload.contains("CommandLine") { return false; }
    let s = event.payload["CommandLine"].to_string().to_lower();
    return s.contains("takeown /f");
}

// win_auth_failed_logon: Failed logon bad password
fn check_win_auth_failed_logon(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4625" { return false; }
    if !event.payload.contains("SubStatus") { return false; }
    let s = event.payload["SubStatus"].to_string().to_lower();
    return s.contains("0xc000006a");
}

// win_auth_account_locked: Administrative account lockout event
fn check_win_auth_account_locked(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4740" { return false; }
    if !event.payload.contains("TargetUserName") { return false; }
    let s = event.payload["TargetUserName"].to_string().to_lower();
    return s.contains("admin");
}

// win_auth_pass_spray: Potential password spraying detected
fn check_win_auth_pass_spray(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4625" { return false; }
    if !event.payload.contains("FailureReason") { return false; }
    let s = event.payload["FailureReason"].to_string().to_lower();
    return s.contains("%%2313");
}

// win_auth_special_privs: Special administrative privileges assigned to logon session
fn check_win_auth_special_privs(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4672" { return false; }
    if !event.payload.contains("PrivilegeList") { return false; }
    let s = event.payload["PrivilegeList"].to_string().to_lower();
    return s.contains("sedebugprivilege");
}

// win_auth_explicit_creds: Logon attempted with explicit credentials
fn check_win_auth_explicit_creds(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4648" { return false; }
    if !event.payload.contains("TargetServerName") { return false; }
    let s = event.payload["TargetServerName"].to_string().to_lower();
    return s.contains("localhost");
}

// win_sec_log_cleared: Windows Security audit log cleared
fn check_win_sec_log_cleared(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "1102" { return false; }
    if !event.payload.contains("EventID") { return false; }
    let s = event.payload["EventID"].to_string().to_lower();
    return s.contains("1102");
}

// win_user_account_created: New user account provisioned
fn check_win_user_account_created(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4720" { return false; }
    if !event.payload.contains("TargetUserName") { return false; }
    let s = event.payload["TargetUserName"].to_string().to_lower();
    return s.contains("backdoor");
}

// win_user_account_enabled: Disabled user account enabled
fn check_win_user_account_enabled(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4722" { return false; }
    if !event.payload.contains("TargetUserName") { return false; }
    let s = event.payload["TargetUserName"].to_string().to_lower();
    return s.contains("guest");
}

// win_group_admin_added: User added to global Domain Admins group
fn check_win_group_admin_added(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4728" { return false; }
    if !event.payload.contains("TargetGroupName") { return false; }
    let s = event.payload["TargetGroupName"].to_string().to_lower();
    return s.contains("domain admins");
}

// win_service_installed: PsExec lateral movement service installed
fn check_win_service_installed(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "7045" { return false; }
    if !event.payload.contains("ServiceName") { return false; }
    let s = event.payload["ServiceName"].to_string().to_lower();
    return s.contains("psexesvc");
}

// win_share_accessed: Administrative share ADMIN$ accessed over SMB
fn check_win_share_accessed(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "5140" { return false; }
    if !event.payload.contains("ShareName") { return false; }
    let s = event.payload["ShareName"].to_string().to_lower();
    return s.contains("/*/admin$");
}

// win_kerb_tgt_request: Kerberos TGT requested without pre-authentication
fn check_win_kerb_tgt_request(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4768" { return false; }
    if !event.payload.contains("TicketOptions") { return false; }
    let s = event.payload["TicketOptions"].to_string().to_lower();
    return s.contains("0x40810010");
}

// win_kerb_ticket_encryption: Kerberoasting RC4-HMAC service ticket requested
fn check_win_kerb_ticket_encryption(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4769" { return false; }
    if !event.payload.contains("TicketEncryptionType") { return false; }
    let s = event.payload["TicketEncryptionType"].to_string().to_lower();
    return s.contains("0x17");
}

// win_task_created: New scheduled task registered
fn check_win_task_created(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4698" { return false; }
    if !event.payload.contains("TaskName") { return false; }
    let s = event.payload["TaskName"].to_string().to_lower();
    return s.contains("persistence");
}

// win_task_updated: Existing scheduled task updated
fn check_win_task_updated(event) {
    if !event.payload.contains("EventID") { return false; }
    if event.payload["EventID"].to_string() != "4702" { return false; }
    if !event.payload.contains("TaskName") { return false; }
    let s = event.payload["TaskName"].to_string().to_lower();
    return s.contains("updater");
}
