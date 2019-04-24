/*
 * AWS CloudTrail IAM Privilege Escalation Detection Rule
 *
 * Detects high-risk IAM operations: AttachUserPolicy, PutUserPolicy, CreateAccessKey.
 */

fn evaluate_cloudtrail_event(event) {
    let event_name = event.payload["eventName"];
    let user_identity = event.payload["userIdentity"];
    let read_only = event.payload["readOnly"];

    if read_only {
        return ();
    }

    let high_risk_actions = [
        "AttachUserPolicy",
        "PutUserPolicy",
        "AttachRolePolicy",
        "PutRolePolicy",
        "CreateAccessKey",
        "CreateLoginProfile",
        "UpdateLoginProfile"
    ];

    let matched_action = false;
    for action in high_risk_actions {
        if event_name == action {
            matched_action = true;
            break;
        }
    }

    if matched_action {
        return #{
            alert: "IAM_PRIVILEGE_ESCALATION_ATTEMPT",
            action: event_name,
            identity: user_identity,
            severity: "HIGH",
            mitre_tactic: "TA0004_PRIVILEGE_ESCALATION"
        };
    }
    return ();
}
