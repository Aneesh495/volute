/*
 * Geodesic Coordinates Validation and Formatting
 *
 * Implements latitude/longitude validation and degree-minute-second conversions.
 */

// Validate latitude in range [-90.0, 90.0]
fn is_valid_latitude(lat) {
    let l = lat * 1.0;
    return l >= -90.0 && l <= 90.0;
}

// Validate longitude in range [-180.0, 180.0]
fn is_valid_longitude(lon) {
    let l = lon * 1.0;
    return l >= -180.0 && l <= 180.0;
}

// Convert Degrees Minutes Seconds (DMS) to Decimal Degrees
fn dms_to_dd(deg, min, sec, dir) {
    let dd = (deg * 1.0) + (min * 1.0) / 60.0 + (sec * 1.0) / 3600.0;
    let d = dir.to_upper();
    if d == "S" || d == "W" {
        dd = -dd;
    }
    return dd;
}

// Normalize longitude to [-180, 180]
fn normalize_longitude(lon) {
    let l = lon * 1.0;
    while l > 180.0 {
        l -= 360.0;
    }
    while l < -180.0 {
        l += 360.0;
    }
    return l;
}
