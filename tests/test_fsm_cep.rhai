import "lib/fsm/state_machine" as fsm_mod;
import "lib/cep/pattern" as cep_pat;
import "lib/cep/evaluator" as cep_eval;
import "lib/testing/assert" as test;

// 1. FSM
let f = fsm_mod::new_fsm("INIT");
f = fsm_mod::add_transition(f, "INIT", "START", "RUNNING", ());
f = fsm_mod::add_transition(f, "RUNNING", "STOP", "STOPPED", ());

test::assert_eq(fsm_mod::get_state(f), "INIT", "initial state");
f = fsm_mod::transition(f, "START", ());
test::assert_eq(fsm_mod::get_state(f), "RUNNING", "running state");

f = fsm_mod::transition(f, "STOP", ());
test::assert_eq(fsm_mod::get_state(f), "STOPPED", "stopped state");

// 2. CEP Evaluator
let cep = cep_eval::new_cep_engine();
let pat = cep_pat::pattern_followed_by("order_placed", "payment_received", 5000);
cep = cep_eval::register_pattern(cep, pat);

let ev1 = #{ id: "1", topic: "order_placed", timestamp_ns: 1000000000 };
let res1 = cep_eval::process_event(cep, ev1);
cep = res1[0];
let alerts1 = res1[1];
test::assert_eq(alerts1.len(), 0, "no alerts on first event");

let ev2 = #{ id: "2", topic: "payment_received", timestamp_ns: 2000000000 };
let res2 = cep_eval::process_event(cep, ev2);
cep = res2[0];
let alerts2 = res2[1];
test::assert_eq(alerts2.len(), 1, "alert triggered on followed_by sequence");
test::assert_eq(alerts2[0].pattern, "followed_by", "alert pattern name");
