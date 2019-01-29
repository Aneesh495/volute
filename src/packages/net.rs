use rhai::Engine;
use std::net::Ipv4Addr;
use std::str::FromStr;

pub fn register(engine: &mut Engine) {
    engine.register_fn("is_ipv4", |s: &str| -> bool {
        Ipv4Addr::from_str(s).is_ok()
    });

    engine.register_fn("ipv4_to_int", |s: &str| -> i64 {
        match Ipv4Addr::from_str(s) {
            Ok(addr) => u32::from(addr) as i64,
            Err(_) => -1,
        }
    });

    engine.register_fn("int_to_ipv4", |val: i64| -> String {
        if val < 0 || val > u32::MAX as i64 {
            String::new()
        } else {
            Ipv4Addr::from(val as u32).to_string()
        }
    });

    engine.register_fn("ip_in_cidr", |ip_str: &str, cidr_str: &str| -> bool {
        let parts: Vec<&str> = cidr_str.split('/').collect();
        if parts.len() != 2 {
            return false;
        }
        let base_ip = match Ipv4Addr::from_str(parts[0]) {
            Ok(ip) => u32::from(ip),
            Err(_) => return false,
        };
        let prefix_len = match parts[1].parse::<u32>() {
            Ok(len) if len <= 32 => len,
            _ => return false,
        };
        let target_ip = match Ipv4Addr::from_str(ip_str) {
            Ok(ip) => u32::from(ip),
            Err(_) => return false,
        };

        if prefix_len == 0 {
            return true;
        }
        let mask = !((1u32 << (32 - prefix_len)) - 1);
        (target_ip & mask) == (base_ip & mask)
    });
}
