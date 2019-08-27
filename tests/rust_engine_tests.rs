use volute::engine::VoluteEngine;
use volute::event::{Event, EventValue};
use volute::pipeline::stage::{Stage, StageKind};

#[test]
fn test_engine_eval_simple_math() {
    let engine = VoluteEngine::new();
    let script = "2 + 3 * 4";
    let res: i64 = engine.eval(script).expect("Eval failed");
    assert_eq!(res, 14);
}

#[test]
fn test_engine_crypto_package() {
    let engine = VoluteEngine::new();
    let script = r#"
        let s = "volute-stream";
        let h = sha256(s);
        let u = uuid_v4();
        h.len() == 64 && u.len() == 36
    "#;
    let res: bool = engine.eval(script).expect("Crypto package eval failed");
    assert!(res);
}

#[test]
fn test_engine_net_cidr_matching() {
    let engine = VoluteEngine::new();
    let script = r#"
        let match1 = ip_in_cidr("192.168.1.50", "192.168.1.0/24");
        let match2 = ip_in_cidr("10.0.0.1", "192.168.1.0/24");
        match1 && !match2
    "#;
    let res: bool = engine.eval(script).expect("Net package eval failed");
    assert!(res);
}

#[test]
fn test_engine_time_iso8601() {
    let engine = VoluteEngine::new();
    let script = r#"
        let ts_str = "2026-11-22T12:00:00Z";
        let ms = parse_iso8601_ms(ts_str);
        ms > 1700000000000
    "#;
    let res: bool = engine.eval(script).expect("Time package eval failed");
    assert!(res);
}

#[test]
fn test_engine_stats_calculations() {
    let engine = VoluteEngine::new();
    let script = r#"
        let arr = [10.0, 20.0, 30.0];
        let mean = calc_mean(arr);
        let variance = calc_variance(arr);
        (mean - 20.0).abs() < 0.001 && (variance - 100.0).abs() < 0.001
    "#;
    let res: bool = engine.eval(script).expect("Stats package eval failed");
    assert!(res);
}

#[test]
fn test_stage_filter_execution() {
    let engine = VoluteEngine::new();
    let script = r#"
        event["payload"]["latency_ms"] < 100.0 && event["payload"]["status"] == 200
    "#;
    let ast = engine.compile_script(script).expect("Compile failed");
    let stage = Stage::new("latency_check", StageKind::Filter, ast);

    let mut event = Event::new("http_request");
    event.set_field("status", EventValue::Int(200));
    event.set_field("latency_ms", EventValue::Float(45.2));

    let keep = stage.execute(&engine, &mut event).expect("Stage execution failed");
    assert!(keep);

    // Update with high latency
    event.set_field("latency_ms", EventValue::Float(250.0));
    let keep2 = stage.execute(&engine, &mut event).expect("Stage execution failed");
    assert!(!keep2);
}
