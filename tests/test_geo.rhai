import "lib/geo/coordinates" as coord;
import "lib/geo/distance" as dist;
import "lib/geo/geohash" as gh;
import "lib/geo/polygon" as poly;
import "lib/testing/assert" as test;

// 1. Coordinates
test::assert(coord::is_valid_latitude(40.7128), "valid lat");
test::assert(!coord::is_valid_latitude(95.0), "invalid lat");

// 2. Distance: New York (40.7128, -74.0060) to London (51.5074, -0.1278) ~ 5,570 km
let d_m = dist::haversine_distance(40.7128, -74.0060, 51.5074, -0.1278);
let d_km = d_m / 1000.0;
test::assert(d_km > 5500.0 && d_km < 5600.0, "haversine NY to London ~5570 km");

// 3. Geohash
let hash = gh::encode_geohash(37.7749, -122.4194, 7);
test::assert_eq(hash.len(), 7, "geohash len");

// 4. Polygon geofence (square from 0,0 to 10,10)
let square = [
    [0.0, 0.0],
    [10.0, 0.0],
    [10.0, 10.0],
    [0.0, 10.0]
];
test::assert(poly::point_in_polygon(5.0, 5.0, square), "point inside square");
test::assert(!poly::point_in_polygon(15.0, 5.0, square), "point outside square");
