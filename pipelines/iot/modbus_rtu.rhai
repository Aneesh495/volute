/*
 * SCADA Modbus RTU Packet Frame Validator
 *
 * Computes standard CRC-16 (Modbus polynomial 0xA001) and validates frames.
 */

// Compute Modbus RTU CRC-16 over byte array
fn modbus_crc16(bytes) {
    let crc = 65535; // 0xFFFF
    for b in bytes {
        crc = crc ^ (b % 256);
        for i in 0..8 {
            let lsb = crc % 2;
            crc = crc / 2;
            if lsb == 1 {
                crc = crc ^ 40961; // 0xA001
            }
        }
    }
    return crc;
}

// Validate Modbus RTU response frame [slave_id, func_code, byte_count, ...data, crc_lo, crc_hi]
fn validate_modbus_frame(frame_bytes) {
    if frame_bytes.len() < 4 {
        return false;
    }
    let data_len = frame_bytes.len() - 2;
    let payload = [];
    for i in 0..data_len {
        payload.push(frame_bytes[i]);
    }

    let calculated_crc = modbus_crc16(payload);
    let expected_lo = calculated_crc % 256;
    let expected_hi = (calculated_crc / 256) % 256;

    let actual_lo = frame_bytes[data_len];
    let actual_hi = frame_bytes[data_len + 1];

    return actual_lo == expected_lo && actual_hi == expected_hi;
}
