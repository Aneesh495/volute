/*
 * Hierarchical Statechart Engine
 *
 * Implements parent-child composite states and event bubbling.
 */

// Initialize hierarchical state chart
fn new_statechart(initial_state) {
    return #{
        current_state: initial_state,
        parent_map: #{},
        transitions: []
    };
}

// Define parent relationship (child belongs to parent)
fn set_parent(chart, child_state, parent_state) {
    chart.parent_map[child_state] = parent_state;
}

// Add transition from state or ancestor on event
fn add_chart_transition(chart, state, event_name, target_state) {
    chart.transitions.push(#{
        state: state,
        event: event_name,
        target: target_state
    });
}

// Dispatch event with bubbling to parent states
fn dispatch_event(chart, event_name) {
    let curr = chart.current_state;
    while true {
        for t in chart.transitions {
            if t.state == curr && t.event == event_name {
                chart.current_state = t.target;
                return true;
            }
        }
        if chart.parent_map.contains(curr) {
            curr = chart.parent_map[curr];
        } else {
            break;
        }
    }
    return false;
}
