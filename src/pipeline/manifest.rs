use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PipelineManifest {
    pub name: String,
    pub description: Option<String>,
    pub input_topic: String,
    pub output_topic: Option<String>,
    pub stages: Vec<StageConfig>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct StageConfig {
    pub name: String,
    pub kind: String,
    pub script_file: Option<String>,
    pub inline_script: Option<String>,
}

impl PipelineManifest {
    pub fn from_yaml(s: &str) -> Result<Self, serde_yaml::Error> {
        serde_yaml::from_str(s)
    }

    pub fn from_json(s: &str) -> Result<Self, serde_json::Error> {
        serde_json::from_str(s)
    }
}
