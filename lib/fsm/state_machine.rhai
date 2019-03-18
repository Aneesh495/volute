/*
 * Finite State Machine (FSM) Engine
 *
 * Implements states, transitions, guards, entry/exit actions, and state history.
 */

// Initialize new FSM instance with starting state
fn new_fsm(initial_state) {
    return #{
        current_state: initial_state,
        initial_state: initial_state,
        transitions: [],
        history: [initial_state],
        context: #{},
        is_terminated: false
    };
}

// Add state transition rule: from_state -> to_state on event
fn add_transition(fsm, from_state, event_name, to_state, guard_fn) {
    let t = #{
        from: from_state,
        event: event_name,
        to: to_state,
        guard: guard_fn
    };
    fsm.transitions.push(t);
    return fsm;
}

// Trigger event transition on FSM
fn transition(fsm, event_name, payload) {
    if fsm.is_terminated {
        return false;
    }
    for t in fsm.transitions {
        if t.from == fsm.current_state && t.event == event_name {
            let can_transition = true;
            if type_of(t.guard) == "Fn" {
                can_transition = t.guard(fsm.context, payload);
            }
            if can_transition {
                fsm.current_state = t.to;
                fsm.history.push(t.to);
                return true;
            }
        }
    }
    return false;
}

// Get current state name
fn get_state(fsm) {
    return fsm.current_state;
}

// Reset state machine to initial state
fn reset_fsm(fsm) {
    fsm.current_state = fsm.initial_state;
    fsm.history = [fsm.initial_state];
    fsm.is_terminated = false;
}
