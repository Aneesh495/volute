use rhai::Engine;
use sha2::{Sha256, Sha512, Digest};
use hmac::{Hmac, Mac};
use md5::Md5;

pub fn register(engine: &mut Engine) {
    engine.register_fn("sha256", |input: &str| -> String {
        let mut hasher = Sha256::new();
        hasher.update(input.as_bytes());
        format!("{:x}", hasher.finalize())
    });

    engine.register_fn("sha512", |input: &str| -> String {
        let mut hasher = Sha512::new();
        hasher.update(input.as_bytes());
        format!("{:x}", hasher.finalize())
    });

    engine.register_fn("md5", |input: &str| -> String {
        let mut hasher = Md5::new();
        hasher.update(input.as_bytes());
        format!("{:x}", hasher.finalize())
    });

    engine.register_fn("hmac_sha256", |key: &str, data: &str| -> String {
        type HmacSha256 = Hmac<Sha256>;
        if let Ok(mut mac) = HmacSha256::new_from_slice(key.as_bytes()) {
            mac.update(data.as_bytes());
            format!("{:x}", mac.finalize().into_bytes())
        } else {
            String::new()
        }
    });

    engine.register_fn("uuid_v4", || -> String {
        uuid::Uuid::new_v4().to_string()
    });

    engine.register_fn("hex_encode", |input: &str| -> String {
        input.as_bytes().iter().map(|b| format!("{:02x}", b)).collect()
    });
}
