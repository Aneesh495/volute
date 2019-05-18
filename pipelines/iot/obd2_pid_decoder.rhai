/*
 * SAE J1979 / OBD-II Automotive Diagnostic Telemetry Decoder
 *
 * Decodes standard Mode 01 Diagnostic PIDs (0x00 - 0x60) into engineering units.
 */

// Decode Mode 01 standard PIDs from raw byte payload [pid, A, B, C, D]
fn decode_obd2_pid(bytes) {
    if bytes.len() < 2 { return #{ is_valid: false }; }
    let pid = bytes[0];
    let a = bytes[1] * 1.0;
    let b = if bytes.len() > 2 { bytes[2] * 1.0 } else { 0.0 };
    let c = if bytes.len() > 3 { bytes[3] * 1.0 } else { 0.0 };
    let d = if bytes.len() > 4 { bytes[4] * 1.0 } else { 0.0 };

    // PID 0x04: Calculated Engine Load (%)
    if pid == 4 {
        return #{ pid: 4, name: "ENGINE_LOAD", value: a / 2.55, unit: "%", is_valid: true };
    }
    // PID 0x05: Engine Coolant Temperature (deg C)
    if pid == 5 {
        return #{ pid: 5, name: "COOLANT_TEMP", value: a - 40.0, unit: "C", is_valid: true };
    }
    // PID 0x0C: Engine RPM (RPM)
    if pid == 12 {
        return #{ pid: 12, name: "ENGINE_RPM", value: (256.0 * a + b) / 4.0, unit: "RPM", is_valid: true };
    }
    // PID 0x0D: Vehicle Speed (km/h)
    if pid == 13 {
        return #{ pid: 13, name: "VEHICLE_SPEED", value: a, unit: "km/h", is_valid: true };
    }
    // PID 0x0F: Intake Air Temperature (deg C)
    if pid == 15 {
        return #{ pid: 15, name: "INTAKE_AIR_TEMP", value: a - 40.0, unit: "C", is_valid: true };
    }
    // PID 0x10: Mass Air Flow Rate (MAF) (g/s)
    if pid == 16 {
        return #{ pid: 16, name: "MAF_FLOW_RATE", value: (256.0 * a + b) / 100.0, unit: "g/s", is_valid: true };
    }
    // PID 0x11: Throttle Position (%)
    if pid == 17 {
        return #{ pid: 17, name: "THROTTLE_POSITION", value: a / 2.55, unit: "%", is_valid: true };
    }
    // PID 0x2F: Fuel Tank Level Input (%)
    if pid == 47 {
        return #{ pid: 47, name: "FUEL_TANK_LEVEL", value: a / 2.55, unit: "%", is_valid: true };
    }
    // PID 0x33: Absolute Barometric Pressure (kPa)
    if pid == 51 {
        return #{ pid: 51, name: "BAROMETRIC_PRESSURE", value: a, unit: "kPa", is_valid: true };
    }
    // PID 0x42: Control Module Voltage (V)
    if pid == 66 {
        return #{ pid: 66, name: "MODULE_VOLTAGE", value: (256.0 * a + b) / 1000.0, unit: "V", is_valid: true };
    }
    // PID 0x5C: Engine Oil Temperature (deg C)
    if pid == 92 {
        return #{ pid: 92, name: "OIL_TEMP", value: a - 40.0, unit: "C", is_valid: true };
    }

    return #{ pid: pid, name: "GENERIC_PID", raw: bytes, is_valid: false };
}
