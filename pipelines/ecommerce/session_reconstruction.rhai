/*
 * Clickstream Session Reconstruction
 *
 * Assembles events into user sessions with 30-minute inactivity timeout.
 */

fn init_session_manager(timeout_ms) {
    return #{
        timeout_ms: timeout_ms,
        sessions: #{} // user_id -> #{ session_id, last_ts, event_count }
    };
}

fn assign_session(manager, event) {
    let user_id = event.payload["user_id"];
    let now_ms = event.timestamp_ns / 1000000;

    if !manager.sessions.contains(user_id) {
        let new_sess_id = uuid_v4();
        manager.sessions[user_id] = #{
            session_id: new_sess_id,
            last_ts: now_ms,
            event_count: 1
        };
        event.payload["session_id"] = new_sess_id;
        return event;
    }

    let sess = manager.sessions[user_id];
    if now_ms - sess.last_ts > manager.timeout_ms {
        // Expired; create new session
        let new_sess_id = uuid_v4();
        manager.sessions[user_id] = #{
            session_id: new_sess_id,
            last_ts: now_ms,
            event_count: 1
        };
        event.payload["session_id"] = new_sess_id;
    } else {
        sess.last_ts = now_ms;
        sess.event_count += 1;
        manager.sessions[user_id] = sess;
        event.payload["session_id"] = sess.session_id;
    }
    return event;
}
