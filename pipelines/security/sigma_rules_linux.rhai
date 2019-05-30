/*
 * Linux Auditd and Host Telemetry Sigma Detection Rules Suite
 *
 * Monitors system calls, file integrity, reverse shells, and privilege escalation.
 */

// Evaluate event against Linux detection rulepack
fn evaluate_linux_sigma(event) {
    let alerts = [];
    // Rule: lnx_reverse_shell_bash
    if event.payload.contains("cmdline") {
        let field_val = event.payload["cmdline"].to_string().to_lower();
        if field_val.contains("bash -i >& /dev/tcp") {
            alerts.push(#{
                rule: "lnx_reverse_shell_bash",
                severity: "CRITICAL",
                description: "Interactive Bash reverse shell redirection"
            });
        }
    }
    // Rule: lnx_reverse_shell_nc
    if event.payload.contains("cmdline") {
        let field_val = event.payload["cmdline"].to_string().to_lower();
        if field_val.contains("nc -e /bin/sh") {
            alerts.push(#{
                rule: "lnx_reverse_shell_nc",
                severity: "CRITICAL",
                description: "Netcat reverse shell execution"
            });
        }
    }
    // Rule: lnx_reverse_shell_python
    if event.payload.contains("cmdline") {
        let field_val = event.payload["cmdline"].to_string().to_lower();
        if field_val.contains("python -c import socket") {
            alerts.push(#{
                rule: "lnx_reverse_shell_python",
                severity: "HIGH",
                description: "Python socket reverse shell execution"
            });
        }
    }
    // Rule: lnx_cron_tampering
    if event.payload.contains("filepath") {
        let field_val = event.payload["filepath"].to_string().to_lower();
        if field_val.contains("/etc/cron") {
            alerts.push(#{
                rule: "lnx_cron_tampering",
                severity: "HIGH",
                description: "Modification of cron scheduling tables"
            });
        }
    }
    // Rule: lnx_shadow_read
    if event.payload.contains("filepath") {
        let field_val = event.payload["filepath"].to_string().to_lower();
        if field_val.contains("/etc/shadow") {
            alerts.push(#{
                rule: "lnx_shadow_read",
                severity: "CRITICAL",
                description: "Unauthorized read access to password shadow file"
            });
        }
    }
    // Rule: lnx_sudoers_tampering
    if event.payload.contains("filepath") {
        let field_val = event.payload["filepath"].to_string().to_lower();
        if field_val.contains("/etc/sudoers") {
            alerts.push(#{
                rule: "lnx_sudoers_tampering",
                severity: "CRITICAL",
                description: "Sudoers privilege elevation configuration modified"
            });
        }
    }
    // Rule: lnx_kmod_loading
    if event.payload.contains("syscall") {
        let field_val = event.payload["syscall"].to_string().to_lower();
        if field_val.contains("init_module") {
            alerts.push(#{
                rule: "lnx_kmod_loading",
                severity: "HIGH",
                description: "Direct kernel module loading via init_module"
            });
        }
    }
    // Rule: lnx_ptrace_injection
    if event.payload.contains("syscall") {
        let field_val = event.payload["syscall"].to_string().to_lower();
        if field_val.contains("ptrace") {
            alerts.push(#{
                rule: "lnx_ptrace_injection",
                severity: "HIGH",
                description: "Process tracing or memory injection via ptrace"
            });
        }
    }
    // Rule: lnx_setuid_creation
    if event.payload.contains("cmdline") {
        let field_val = event.payload["cmdline"].to_string().to_lower();
        if field_val.contains("chmod +s") {
            alerts.push(#{
                rule: "lnx_setuid_creation",
                severity: "HIGH",
                description: "SetUID bit added to executable"
            });
        }
    }
    // Rule: lnx_user_addition
    if event.payload.contains("cmdline") {
        let field_val = event.payload["cmdline"].to_string().to_lower();
        if field_val.contains("useradd -m -s /bin/bash") {
            alerts.push(#{
                rule: "lnx_user_addition",
                severity: "MEDIUM",
                description: "New user account created via useradd"
            });
        }
    }
    // Rule: lnx_group_wheel_add
    if event.payload.contains("cmdline") {
        let field_val = event.payload["cmdline"].to_string().to_lower();
        if field_val.contains("usermod -ag wheel") {
            alerts.push(#{
                rule: "lnx_group_wheel_add",
                severity: "HIGH",
                description: "User added to administrative wheel group"
            });
        }
    }
    // Rule: lnx_log_wiping
    if event.payload.contains("cmdline") {
        let field_val = event.payload["cmdline"].to_string().to_lower();
        if field_val.contains("rm -rf /var/log") {
            alerts.push(#{
                rule: "lnx_log_wiping",
                severity: "CRITICAL",
                description: "Mass log wiping in /var/log"
            });
        }
    }
    // Rule: lnx_shell_history_clear
    if event.payload.contains("cmdline") {
        let field_val = event.payload["cmdline"].to_string().to_lower();
        if field_val.contains("history -c") {
            alerts.push(#{
                rule: "lnx_shell_history_clear",
                severity: "LOW",
                description: "Bash shell command history cleared"
            });
        }
    }
    // Rule: lnx_ssh_authorized_keys
    if event.payload.contains("filepath") {
        let field_val = event.payload["filepath"].to_string().to_lower();
        if field_val.contains(".ssh/authorized_keys") {
            alerts.push(#{
                rule: "lnx_ssh_authorized_keys",
                severity: "HIGH",
                description: "New public key injected into authorized_keys"
            });
        }
    }
    // Rule: lnx_ld_preload_tamper
    if event.payload.contains("filepath") {
        let field_val = event.payload["filepath"].to_string().to_lower();
        if field_val.contains("/etc/ld.so.preload") {
            alerts.push(#{
                rule: "lnx_ld_preload_tamper",
                severity: "CRITICAL",
                description: "Dynamic linker hijacking via ld.so.preload"
            });
        }
    }
    // Rule: lnx_pam_tampering
    if event.payload.contains("filepath") {
        let field_val = event.payload["filepath"].to_string().to_lower();
        if field_val.contains("/etc/pam.d") {
            alerts.push(#{
                rule: "lnx_pam_tampering",
                severity: "CRITICAL",
                description: "PAM authentication module configuration modified"
            });
        }
    }
    // Rule: lnx_iptables_flush
    if event.payload.contains("cmdline") {
        let field_val = event.payload["cmdline"].to_string().to_lower();
        if field_val.contains("iptables -f") {
            alerts.push(#{
                rule: "lnx_iptables_flush",
                severity: "HIGH",
                description: "Host firewall rules flushed"
            });
        }
    }
    // Rule: lnx_systemd_service_add
    if event.payload.contains("filepath") {
        let field_val = event.payload["filepath"].to_string().to_lower();
        if field_val.contains("/etc/systemd/system") {
            alerts.push(#{
                rule: "lnx_systemd_service_add",
                severity: "MEDIUM",
                description: "New systemd service unit registered"
            });
        }
    }
    // Rule: lnx_chattr_immutable
    if event.payload.contains("cmdline") {
        let field_val = event.payload["cmdline"].to_string().to_lower();
        if field_val.contains("chattr +i") {
            alerts.push(#{
                rule: "lnx_chattr_immutable",
                severity: "LOW",
                description: "Immutable file attribute set"
            });
        }
    }
    // Rule: lnx_curl_piped_bash
    if event.payload.contains("cmdline") {
        let field_val = event.payload["cmdline"].to_string().to_lower();
        if field_val.contains("curl | bash") {
            alerts.push(#{
                rule: "lnx_curl_piped_bash",
                severity: "HIGH",
                description: "Unverified remote script piped directly to bash"
            });
        }
    }
    return alerts;
}
// lnx_reverse_shell_bash: Interactive Bash reverse shell redirection
fn check_lnx_reverse_shell_bash(event) {
    if !event.payload.contains("cmdline") { return false; }
    let s = event.payload["cmdline"].to_string().to_lower();
    return s.contains("bash -i >& /dev/tcp");
}

// lnx_reverse_shell_nc: Netcat reverse shell execution
fn check_lnx_reverse_shell_nc(event) {
    if !event.payload.contains("cmdline") { return false; }
    let s = event.payload["cmdline"].to_string().to_lower();
    return s.contains("nc -e /bin/sh");
}

// lnx_reverse_shell_python: Python socket reverse shell execution
fn check_lnx_reverse_shell_python(event) {
    if !event.payload.contains("cmdline") { return false; }
    let s = event.payload["cmdline"].to_string().to_lower();
    return s.contains("python -c import socket");
}

// lnx_cron_tampering: Modification of cron scheduling tables
fn check_lnx_cron_tampering(event) {
    if !event.payload.contains("filepath") { return false; }
    let s = event.payload["filepath"].to_string().to_lower();
    return s.contains("/etc/cron");
}

// lnx_shadow_read: Unauthorized read access to password shadow file
fn check_lnx_shadow_read(event) {
    if !event.payload.contains("filepath") { return false; }
    let s = event.payload["filepath"].to_string().to_lower();
    return s.contains("/etc/shadow");
}

// lnx_sudoers_tampering: Sudoers privilege elevation configuration modified
fn check_lnx_sudoers_tampering(event) {
    if !event.payload.contains("filepath") { return false; }
    let s = event.payload["filepath"].to_string().to_lower();
    return s.contains("/etc/sudoers");
}

// lnx_kmod_loading: Direct kernel module loading via init_module
fn check_lnx_kmod_loading(event) {
    if !event.payload.contains("syscall") { return false; }
    let s = event.payload["syscall"].to_string().to_lower();
    return s.contains("init_module");
}

// lnx_ptrace_injection: Process tracing or memory injection via ptrace
fn check_lnx_ptrace_injection(event) {
    if !event.payload.contains("syscall") { return false; }
    let s = event.payload["syscall"].to_string().to_lower();
    return s.contains("ptrace");
}

// lnx_setuid_creation: SetUID bit added to executable
fn check_lnx_setuid_creation(event) {
    if !event.payload.contains("cmdline") { return false; }
    let s = event.payload["cmdline"].to_string().to_lower();
    return s.contains("chmod +s");
}

// lnx_user_addition: New user account created via useradd
fn check_lnx_user_addition(event) {
    if !event.payload.contains("cmdline") { return false; }
    let s = event.payload["cmdline"].to_string().to_lower();
    return s.contains("useradd -m -s /bin/bash");
}

// lnx_group_wheel_add: User added to administrative wheel group
fn check_lnx_group_wheel_add(event) {
    if !event.payload.contains("cmdline") { return false; }
    let s = event.payload["cmdline"].to_string().to_lower();
    return s.contains("usermod -ag wheel");
}

// lnx_log_wiping: Mass log wiping in /var/log
fn check_lnx_log_wiping(event) {
    if !event.payload.contains("cmdline") { return false; }
    let s = event.payload["cmdline"].to_string().to_lower();
    return s.contains("rm -rf /var/log");
}

// lnx_shell_history_clear: Bash shell command history cleared
fn check_lnx_shell_history_clear(event) {
    if !event.payload.contains("cmdline") { return false; }
    let s = event.payload["cmdline"].to_string().to_lower();
    return s.contains("history -c");
}

// lnx_ssh_authorized_keys: New public key injected into authorized_keys
fn check_lnx_ssh_authorized_keys(event) {
    if !event.payload.contains("filepath") { return false; }
    let s = event.payload["filepath"].to_string().to_lower();
    return s.contains(".ssh/authorized_keys");
}

// lnx_ld_preload_tamper: Dynamic linker hijacking via ld.so.preload
fn check_lnx_ld_preload_tamper(event) {
    if !event.payload.contains("filepath") { return false; }
    let s = event.payload["filepath"].to_string().to_lower();
    return s.contains("/etc/ld.so.preload");
}

// lnx_pam_tampering: PAM authentication module configuration modified
fn check_lnx_pam_tampering(event) {
    if !event.payload.contains("filepath") { return false; }
    let s = event.payload["filepath"].to_string().to_lower();
    return s.contains("/etc/pam.d");
}

// lnx_iptables_flush: Host firewall rules flushed
fn check_lnx_iptables_flush(event) {
    if !event.payload.contains("cmdline") { return false; }
    let s = event.payload["cmdline"].to_string().to_lower();
    return s.contains("iptables -f");
}

// lnx_systemd_service_add: New systemd service unit registered
fn check_lnx_systemd_service_add(event) {
    if !event.payload.contains("filepath") { return false; }
    let s = event.payload["filepath"].to_string().to_lower();
    return s.contains("/etc/systemd/system");
}

// lnx_chattr_immutable: Immutable file attribute set
fn check_lnx_chattr_immutable(event) {
    if !event.payload.contains("cmdline") { return false; }
    let s = event.payload["cmdline"].to_string().to_lower();
    return s.contains("chattr +i");
}

// lnx_curl_piped_bash: Unverified remote script piped directly to bash
fn check_lnx_curl_piped_bash(event) {
    if !event.payload.contains("cmdline") { return false; }
    let s = event.payload["cmdline"].to_string().to_lower();
    return s.contains("curl | bash");
}
