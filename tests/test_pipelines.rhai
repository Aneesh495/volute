import "pipelines/security/ssh_brute_force" as ssh;
import "pipelines/security/impossible_travel" as travel;
import "pipelines/fintech/card_fraud_scorer" as fraud;
import "pipelines/data_quality/data_contract_validator" as dq;
import "lib/testing/assert" as test;

// 1. SSH Brute-Force
let detector = ssh::init_detector(3, 60000); // 3 failures in 1 min
let ev_fail = #{
    timestamp_ns: 1000000000,
    payload: #{ "source_ip": "198.51.100.2", "success": false }
};

let res1 = ssh::process_auth_event(detector, ev_fail);
detector = res1[0];

let res2 = ssh::process_auth_event(detector, ev_fail);
detector = res2[0];

let res3 = ssh::process_auth_event(detector, ev_fail);
detector = res3[0];
let alert = res3[1];

test::assert(alert != (), "alert triggered on 3rd failure");
test::assert_eq(alert.alert, "SSH_BRUTE_FORCE_DETECTED", "alert name");

// 2. Card Fraud Scorer
let tx = #{
    payload: #{
        "amount": 6000.0,
        "card_present": false,
        "is_international": true,
        "velocity_1h": 6
    }
};
let score_res = fraud::score_card_transaction(tx);
test::assert(score_res.risk_score >= 75, "risk score high");
test::assert_eq(score_res.decision, "DECLINE", "card declined");

// 3. Data Contract Validator
let event_good = #{
    id: "evt-1",
    payload: #{ "name": "alice", "age": 30 }
};
let check_good = dq::validate_contract(event_good, ["name", "age"]);
test::assert(check_good.valid, "good contract valid");

let event_bad = #{
    id: "evt-2",
    payload: #{ "name": "bob" }
};
let check_bad = dq::validate_contract(event_bad, ["name", "age"]);
test::assert(!check_bad.valid, "bad contract invalid");
