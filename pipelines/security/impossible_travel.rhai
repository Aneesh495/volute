/*
 * Impossible Travel Geolocation Anomaly Detector
 *
 * Computes speed of transit between consecutive user logins.
 * Alerts on velocities exceeding commercial aviation limits (>900 km/h).
 */

import "lib/geo/distance" as geo_dist;

// Initialize travel tracker
fn init_travel_tracker(max_velocity_kmh) {
    return #{
        max_speed_kmh: max_velocity_kmh,
        last_locations: #{} // user_id -> #{ lat, lon, ts_ms }
    };
}

// Process login event
fn evaluate_login(tracker, event) {
    let user_id = event.payload["user_id"];
    let lat = event.payload["latitude"];
    let lon = event.payload["longitude"];
    let ts_ms = event.timestamp_ns / 1000000;

    if !tracker.last_locations.contains(user_id) {
        tracker.last_locations[user_id] = #{ lat: lat, lon: lon, ts_ms: ts_ms };
        return ();
    }

    let prev = tracker.last_locations[user_id];
    let elapsed_hours = (ts_ms - prev.ts_ms) * 1.0 / (3600.0 * 1000.0);

    // Update location for next turn
    tracker.last_locations[user_id] = #{ lat: lat, lon: lon, ts_ms: ts_ms };

    if elapsed_hours <= 0.0 {
        return ();
    }

    let dist_meters = geo_dist::haversine_distance(prev.lat, prev.lon, lat, lon);
    let dist_km = dist_meters / 1000.0;
    let speed_kmh = dist_km / elapsed_hours;

    if speed_kmh > tracker.max_speed_kmh {
        return #{
            alert: "IMPOSSIBLE_TRAVEL_DETECTED",
            user_id: user_id,
            distance_km: dist_km,
            elapsed_hours: elapsed_hours,
            calculated_speed_kmh: speed_kmh,
            from_location: [prev.lat, prev.lon],
            to_location: [lat, lon],
            severity: "HIGH"
        };
    }

    return ();
}
