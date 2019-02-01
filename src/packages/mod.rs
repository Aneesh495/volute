pub mod crypto;
pub mod net;
pub mod time;
pub mod stats;

pub fn register_all(engine: &mut rhai::Engine) {
    crypto::register(engine);
    net::register(engine);
    time::register(engine);
    stats::register(engine);
}
