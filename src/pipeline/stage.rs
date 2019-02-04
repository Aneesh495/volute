use crate::event::Event;
use crate::engine::VoluteEngine;
use rhai::{Scope, AST, Dynamic, Map};
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum StageKind {
    Filter,
    Transform,
    Tap,
}

pub struct Stage {
    pub name: String,
    pub kind: StageKind,
    pub ast: AST,
}

impl Stage {
    pub fn new(name: impl Into<String>, kind: StageKind, ast: AST) -> Self {
        Self {
            name: name.into(),
            kind,
            ast,
        }
    }

    pub fn execute(&self, engine: &VoluteEngine, event: &mut Event) -> Result<bool, String> {
        let mut scope = Scope::new();
        
        let mut event_map = Map::new();
        event_map.insert("id".into(), Dynamic::from(event.id.clone()));
        event_map.insert("topic".into(), Dynamic::from(event.topic.clone()));
        event_map.insert("timestamp_ns".into(), Dynamic::from(event.timestamp_ns));

        let mut payload_map = Map::new();
        for (k, v) in &event.payload {
            payload_map.insert(k.clone().into(), dynamic_from_event_val(v));
        }
        event_map.insert("payload".into(), Dynamic::from(payload_map));

        let mut meta_map = Map::new();
        for (k, v) in &event.metadata {
            meta_map.insert(k.clone().into(), Dynamic::from(v.clone()));
        }
        event_map.insert("metadata".into(), Dynamic::from(meta_map));

        scope.push("event", event_map);

        match self.kind {
            StageKind::Filter => {
                let keep: bool = engine
                    .eval_ast_with_scope(&mut scope, &self.ast)
                    .map_err(|e| e.to_string())?;
                Ok(keep)
            }
            StageKind::Transform => {
                let modified: Dynamic = engine
                    .eval_ast_with_scope(&mut scope, &self.ast)
                    .map_err(|e| e.to_string())?;
                
                if let Some(map) = modified.try_cast::<Map>() {
                    if let Some(payload_dyn) = map.get("payload") {
                        if let Some(pmap) = payload_dyn.clone().try_cast::<Map>() {
                            for (k, v) in pmap {
                                event.set_field(k.to_string(), event_val_from_dynamic(&v));
                            }
                        }
                    }
                    if let Some(topic_dyn) = map.get("topic") {
                        if let Ok(top) = topic_dyn.clone().into_string() {
                            event.topic = top;
                        }
                    }
                }
                Ok(true)
            }
            StageKind::Tap => {
                let _res: Dynamic = engine
                    .eval_ast_with_scope(&mut scope, &self.ast)
                    .map_err(|e| e.to_string())?;
                Ok(true)
            }
        }
    }
}

fn dynamic_from_event_val(val: &crate::event::EventValue) -> Dynamic {
    use crate::event::EventValue::*;
    match val {
        Null => Dynamic::UNIT,
        Bool(b) => Dynamic::from(*b),
        Int(i) => Dynamic::from(*i),
        Float(f) => Dynamic::from(*f),
        String(s) => Dynamic::from(s.clone()),
        Array(arr) => {
            let vec: Vec<Dynamic> = arr.iter().map(dynamic_from_event_val).collect();
            Dynamic::from(vec)
        }
        Map(m) => {
            let mut map = rhai::Map::new();
            for (k, v) in m {
                map.insert(k.clone().into(), dynamic_from_event_val(v));
            }
            Dynamic::from(map)
        }
    }
}

fn event_val_from_dynamic(dyn_val: &Dynamic) -> crate::event::EventValue {
    use crate::event::EventValue;
    if dyn_val.is_unit() {
        EventValue::Null
    } else if let Ok(b) = dyn_val.as_bool() {
        EventValue::Bool(b)
    } else if let Ok(i) = dyn_val.as_int() {
        EventValue::Int(i)
    } else if let Ok(f) = dyn_val.as_float() {
        EventValue::Float(f)
    } else if let Some(s) = dyn_val.clone().try_cast::<String>() {
        EventValue::String(s)
    } else if let Some(arr) = dyn_val.clone().try_cast::<rhai::Array>() {
        EventValue::Array(arr.iter().map(event_val_from_dynamic).collect())
    } else if let Some(m) = dyn_val.clone().try_cast::<Map>() {
        let mut map = std::collections::HashMap::new();
        for (k, v) in m {
            map.insert(k.to_string(), event_val_from_dynamic(&v));
        }
        EventValue::Map(map)
    } else {
        EventValue::String(dyn_val.to_string())
    }
}
