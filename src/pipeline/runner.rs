use super::stage::{Stage, StageKind};
use super::manifest::PipelineManifest;
use crate::engine::VoluteEngine;
use crate::event::Event;
use std::sync::Arc;
use std::path::Path;

pub struct PipelineRunner {
    pub name: String,
    pub engine: Arc<VoluteEngine>,
    pub stages: Vec<Stage>,
}

impl PipelineRunner {
    pub fn from_manifest<P: AsRef<Path>>(
        manifest: &PipelineManifest,
        base_dir: P,
    ) -> Result<Self, String> {
        let engine = Arc::new(VoluteEngine::new());
        let mut stages = Vec::new();

        for cfg in &manifest.stages {
            let kind = match cfg.kind.to_lowercase().as_str() {
                "filter" => StageKind::Filter,
                "transform" => StageKind::Transform,
                "tap" => StageKind::Tap,
                other => return Err(format!("Unknown stage kind: {}", other)),
            };

            let ast = if let Some(ref script_file) = cfg.script_file {
                let path = base_dir.as_ref().join(script_file);
                engine
                    .compile_file(&path)
                    .map_err(|e| format!("Failed to compile {}: {}", path.display(), e))?
            } else if let Some(ref code) = cfg.inline_script {
                engine
                    .compile_script(code)
                    .map_err(|e| format!("Failed to compile inline script: {}", e))?
            } else {
                return Err(format!("Stage '{}' has no script specified", cfg.name));
            };

            stages.push(Stage::new(cfg.name.clone(), kind, ast));
        }

        Ok(Self {
            name: manifest.name.clone(),
            engine,
            stages,
        })
    }

    pub fn process(&self, mut event: Event) -> Result<Option<Event>, String> {
        for stage in &self.stages {
            let continue_flow = stage.execute(&self.engine, &mut event)?;
            if !continue_flow {
                return Ok(None);
            }
        }
        Ok(Some(event))
    }
}
