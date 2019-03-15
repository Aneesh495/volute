/*
 * Geohash Spatial Index Encoding and Decoding
 *
 * Implements Base32 geohash encoding and decoding.
 */

const BASE32_ALPHABET = "0123456789bcdefghjkmnpqrstuvwxyz";

// Encode latitude and longitude to Geohash string of specified precision
fn encode_geohash(lat, lon, precision) {
    let min_lat = -90.0;
    let max_lat = 90.0;
    let min_lon = -180.0;
    let max_lon = 180.0;

    let geohash = "";
    let is_even = true;
    let bit = 0;
    let ch = 0;

    while geohash.len() < precision {
        if is_even {
            let mid = (min_lon + max_lon) / 2.0;
            if lon >= mid {
                ch = ch * 2 + 1;
                min_lon = mid;
            } else {
                ch = ch * 2;
                max_lon = mid;
            }
        } else {
            let mid = (min_lat + max_lat) / 2.0;
            if lat >= mid {
                ch = ch * 2 + 1;
                min_lat = mid;
            } else {
                ch = ch * 2;
                max_lat = mid;
            }
        }
        is_even = !is_even;
        bit += 1;

        if bit == 5 {
            geohash += BASE32_ALPHABET.sub_string(ch, 1);
            bit = 0;
            ch = 0;
        }
    }

    return geohash;
}
