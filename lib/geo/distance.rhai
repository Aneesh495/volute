/*
 * Geodesic Distance and Spherical Trigonometry
 *
 * Implements Haversine distance in meters, initial bearing, and Manhattan distance.
 */

const EARTH_RADIUS_METERS = 6371000.0;
const PI = 3.141592653589793;

// Convert degrees to radians
fn to_radians(deg) {
    return (deg * 1.0) * PI / 180.0;
}

// Convert radians to degrees
fn to_degrees(rad) {
    return (rad * 1.0) * 180.0 / PI;
}

// Compute Haversine distance in meters between two (lat, lon) coordinates
fn haversine_distance(lat1, lon1, lat2, lon2) {
    let phi1 = to_radians(lat1);
    let phi2 = to_radians(lat2);
    let delta_phi = to_radians(lat2 - lat1);
    let delta_lambda = to_radians(lon2 - lon1);

    let sin_half_phi = (delta_phi / 2.0).sin();
    let sin_half_lambda = (delta_lambda / 2.0).sin();

    let a = sin_half_phi * sin_half_phi +
            phi1.cos() * phi2.cos() * sin_half_lambda * sin_half_lambda;

    let c = 2.0 * a.sqrt().atan2((1.0 - a).sqrt());
    return EARTH_RADIUS_METERS * c;
}

// Compute initial forward bearing in degrees from point 1 to point 2
fn initial_bearing(lat1, lon1, lat2, lon2) {
    let phi1 = to_radians(lat1);
    let phi2 = to_radians(lat2);
    let delta_lambda = to_radians(lon2 - lon1);

    let y = delta_lambda.sin() * phi2.cos();
    let x = phi1.cos() * phi2.sin() -
            phi1.sin() * phi2.cos() * delta_lambda.cos();

    let theta = y.atan2(x);
    let deg = to_degrees(theta);
    return (deg + 360.0) % 360.0;
}
