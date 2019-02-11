pub mod event;
pub mod engine;
pub mod packages;
pub mod pipeline;
pub mod cli;

pub use event::{Event, EventValue};
pub use engine::VoluteEngine;
pub use pipeline::{PipelineManifest, PipelineRunner, Stage, StageKind, WindowBuffer, WindowType};

pub fn version() -> &'static str {
    env!("CARGO_PKG_VERSION")
}
