/*
 * AWS GuardDuty Threat Findings Evaluator and Alert Router
 *
 * Analyzes CloudTrail, VPC Flow, and DNS logs for active threats.
 */

// Route GuardDuty finding event to incident response tier
fn evaluate_guardduty_finding(finding) {
    let ftype = finding.payload["type"];
    let sev = finding.payload["severity"].to_float();

    let tier = "LOW";
    if sev >= 7.0 {
        tier = "CRITICAL";
    } else if sev >= 4.0 {
        tier = "MEDIUM";
    }

    return #{
        finding_type: ftype,
        severity_score: sev,
        urgency_tier: tier,
        requires_immediate_isolation: sev >= 8.5
    };
}
// GuardDuty Rule: Recon_EC2_Portscan - EC2 instance is scanning open ports on remote host
fn check_guardduty_recon_ec2_portscan(finding) {
    if !finding.payload.contains("type") { return false; }
    return finding.payload["type"] == "Reconnaissance:EC2/Portscan";
}

// GuardDuty Rule: UnauthorizedAccess_EC2_SSHBruteForce - EC2 instance running SSH brute-force attack
fn check_guardduty_unauthorizedaccess_ec2_sshbruteforce(finding) {
    if !finding.payload.contains("type") { return false; }
    return finding.payload["type"] == "UnauthorizedAccess:EC2/SSHBruteForce";
}

// GuardDuty Rule: CryptoCurrency_EC2_BitcoinTool_B - EC2 querying Bitcoin or cryptocurrency mining pool
fn check_guardduty_cryptocurrency_ec2_bitcointool_b(finding) {
    if !finding.payload.contains("type") { return false; }
    return finding.payload["type"] == "CryptoCurrency:EC2/BitcoinTool.B";
}

// GuardDuty Rule: Trojan_EC2_BlackHoleTraffic - EC2 instance attempting contact with known blackhole C2
fn check_guardduty_trojan_ec2_blackholetraffic(finding) {
    if !finding.payload.contains("type") { return false; }
    return finding.payload["type"] == "Trojan:EC2/BlackHoleTraffic";
}

// GuardDuty Rule: Backdoor_EC2_XORDDOS - EC2 instance infected with XOR.DDoS malware strain
fn check_guardduty_backdoor_ec2_xorddos(finding) {
    if !finding.payload.contains("type") { return false; }
    return finding.payload["type"] == "Backdoor:EC2/XORDDOS";
}

// GuardDuty Rule: Execution_EC2_MaliciousPayload - Suspicious script downloaded from paste site
fn check_guardduty_execution_ec2_maliciouspayload(finding) {
    if !finding.payload.contains("type") { return false; }
    return finding.payload["type"] == "Execution:EC2/MaliciousPayload";
}

// GuardDuty Rule: PrivilegeEscalation_IAM_UserPolicy - IAM user policy modified without change request
fn check_guardduty_privilegeescalation_iam_userpolicy(finding) {
    if !finding.payload.contains("type") { return false; }
    return finding.payload["type"] == "PrivilegeEscalation:IAM/UserPolicy";
}

// GuardDuty Rule: Stealth_IAM_PasswordPolicyLowered - Account password policy complexity decreased
fn check_guardduty_stealth_iam_passwordpolicylowered(finding) {
    if !finding.payload.contains("type") { return false; }
    return finding.payload["type"] == "Stealth:IAM/PasswordPolicyLowered";
}

// GuardDuty Rule: Policy_IAM_RootCredentialUsage - Root account credentials used for console or API call
fn check_guardduty_policy_iam_rootcredentialusage(finding) {
    if !finding.payload.contains("type") { return false; }
    return finding.payload["type"] == "Policy:IAM/RootCredentialUsage";
}

// GuardDuty Rule: Discovery_S3_BucketEnumeration - Rapid API enumeration of S3 bucket names
fn check_guardduty_discovery_s3_bucketenumeration(finding) {
    if !finding.payload.contains("type") { return false; }
    return finding.payload["type"] == "Discovery:S3/BucketEnumeration";
}

// GuardDuty Rule: Exfiltration_S3_ObjectReadAnomalous - Anomalous volume of S3 objects read from external IP
fn check_guardduty_exfiltration_s3_objectreadanomalous(finding) {
    if !finding.payload.contains("type") { return false; }
    return finding.payload["type"] == "Exfiltration:S3/ObjectReadAnomalous";
}

// GuardDuty Rule: Impact_S3_AnomalousDelete - High rate of S3 object deletions detected
fn check_guardduty_impact_s3_anomalousdelete(finding) {
    if !finding.payload.contains("type") { return false; }
    return finding.payload["type"] == "Impact:S3/AnomalousDelete";
}
