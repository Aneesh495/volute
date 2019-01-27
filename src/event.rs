use serde::{Deserialize, Serialize};
use std::collections::HashMap;

#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub enum EventValue {
    Null,
    Bool(bool),
    Int(i64),
    Float(f64),
    String(String),
    Array(Vec<EventValue>),
    Map(HashMap<String, EventValue>),
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Event {
    pub id: String,
    pub timestamp_ns: i64,
    pub topic: String,
    pub payload: HashMap<String, EventValue>,
    pub metadata: HashMap<String, String>,
}

impl Event {
    pub fn new(topic: impl Into<String>) -> Self {
        let now = chrono::Utc::now().timestamp_nanos_opt().unwrap_or(0);
        let id = uuid::Uuid::new_v4().to_string();
        Self {
            id,
            timestamp_ns: now,
            topic: topic.into(),
            payload: HashMap::new(),
            metadata: HashMap::new(),
        }
    }

    pub fn with_id(mut self, id: impl Into<String>) -> Self {
        self.id = id.into();
        self
    }

    pub fn with_timestamp(mut self, ts: i64) -> Self {
        self.timestamp_ns = ts;
        self
    }

    pub fn set_field(&mut self, key: impl Into<String>, val: EventValue) {
        self.payload.insert(key.into(), val);
    }

    pub fn get_field(&self, key: &str) -> Option<&EventValue> {
        self.payload.get(key)
    }

    pub fn set_meta(&mut self, key: impl Into<String>, val: impl Into<String>) {
        self.metadata.insert(key.into(), val.into());
    }

    pub fn get_meta(&self, key: &str) -> Option<&str> {
        self.metadata.get(key).map(|s| s.as_str())
    }
}
