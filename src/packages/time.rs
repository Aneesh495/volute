use rhai::Engine;
use chrono::{Utc, DateTime};

pub fn register(engine: &mut Engine) {
    engine.register_fn("now_ms", || -> i64 {
        Utc::now().timestamp_millis()
    });

    engine.register_fn("now_ns", || -> i64 {
        Utc::now().timestamp_nanos_opt().unwrap_or(0)
    });

    engine.register_fn("now_iso8601", || -> String {
        Utc::now().to_rfc3339()
    });

    engine.register_fn("parse_iso8601_ms", |s: &str| -> i64 {
        match DateTime::parse_from_rfc3339(s) {
            Ok(dt) => dt.timestamp_millis(),
            Err(_) => -1,
        }
    });

    engine.register_fn("format_epoch_ms", |ms: i64| -> String {
        DateTime::from_timestamp_millis(ms)
            .map(|dt| dt.to_rfc3339())
            .unwrap_or_default()
    });
}
