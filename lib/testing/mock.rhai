/*
 * Synthetic Event Stream Generator for Testing
 */

// Generate a synthetic stream event
fn create_mock_event(topic, id, ts_ms, payload) {
    return #{
        id: id,
        topic: topic,
        timestamp_ns: ts_ms * 1000000,
        payload: payload,
        metadata: #{}
    };
}
