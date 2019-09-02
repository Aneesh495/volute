# Volute Rhai Standard Library Reference (`lib/`)

The Volute Standard Library provides a comprehensive collection of domain-neutral, highly optimized algorithmic modules written in native Rhai.

---

## Table of Contents

1. [Core Data Structures & Algorithms (`lib/core/`)](#1-core-data-structures--algorithms)
2. [Numerical Analysis & Streaming Statistics (`lib/stats/`)](#2-numerical-analysis--streaming-statistics)
3. [Network Codecs & Protocols (`lib/net/`)](#3-network-codecs--protocols)
4. [Encodings & Log Formats (`lib/encoding/`)](#4-encodings--log-formats)
5. [Geospatial & Spatial Indexing (`lib/geo/`)](#5-geospatial--spatial-indexing)
6. [Finite State Machines & Complex Event Processing (`lib/fsm/` & `lib/cep/`)](#6-fsm--cep)
7. [Unit Testing & Assertions (`lib/testing/`)](#7-testing--assertions)

---

## 1. Core Data Structures & Algorithms

### `lib/core/types.rhai`
Type inspection and dynamic coercion utilities.
- `is_null(val) -> bool`: Checks if a value is unit `()`.
- `is_bool(val) -> bool`: Validates boolean primitives.
- `is_int(val) -> bool`: Validates 64-bit integer values.
- `is_float(val) -> bool`: Validates 64-bit floating point values.
- `is_string(val) -> bool`: Validates string representations.
- `is_array(val) -> bool`: Checks for vector lists.
- `is_map(val) -> bool`: Validates key-value dictionaries.

### `lib/core/collections.rhai`
Functional collection manipulation methods.
- `map(arr, fn_ptr) -> Array`: Transforms elements via function closure.
- `filter(arr, fn_ptr) -> Array`: Retains elements matching the predicate.
- `reduce(arr, init, fn_ptr) -> Dynamic`: Folds collection into accumulator.
- `find(arr, fn_ptr) -> Dynamic`: Returns first match or `()`.
- `all(arr, fn_ptr) -> bool`: Universal check (all items satisfy predicate).
- `any(arr, fn_ptr) -> bool`: Existential check (at least one item satisfies predicate).
- `zip(arr1, arr2) -> Array`: Pairs elements into two-element tuples.
- `chunk(arr, size) -> Array`: Partitions array into sub-arrays of length `size`.

### `lib/core/priority_queue.rhai`
Binary min-heap and max-heap implementation using flat array index storage.
- `create_heap(is_min_heap) -> Map`: Initializes a binary heap structure.
- `heap_push(heap, item, priority)`: Inserts element and bubbles up.
- `heap_pop(heap) -> Dynamic`: Removes and returns root item with bubble down.
- `heap_peek(heap) -> Dynamic`: Reads root element without mutation.

### `lib/core/trie.rhai`
Arena-allocated prefix search tree (Trie).
- `create_trie() -> Map`: Allocates an indexed node arena.
- `trie_insert(trie, word, value)`: Stores word and associates arbitrary payload.
- `trie_search(trie, word) -> Dynamic`: Exact word lookup.
- `trie_starts_with(trie, prefix) -> bool`: Evaluates prefix presence.

### `lib/core/ring_buffer.rhai`
Fixed-capacity circular buffer with O(1) overwrite semantics.
- `create_ring_buffer(capacity) -> Map`: Allocates buffer slots and pointers.
- `ring_push(rb, item)`: Inserts item, overwriting oldest entry when full.
- `ring_to_array(rb) -> Array`: Dumps chronological array of elements.

### `lib/core/graph.rhai`
Directed and weighted graph structure with shortest-path algorithms.
- `create_graph() -> Map`: Allocates adjacency list representation.
- `add_edge(g, u, v, weight)`: Inserts directed edge from `u` to `v`.
- `dijkstra(g, start_node) -> Map`: Computes single-source shortest path distances.

### `lib/core/kmp.rhai`
Knuth-Morris-Pratt string search algorithm with linear time precomputed prefix failure tables.
- `kmp_search(text, pattern) -> Array`: Returns all starting indices of pattern in text.

---

## 2. Numerical Analysis & Streaming Statistics

### `lib/stats/streaming.rhai`
Welford algorithm online single-pass variance and standard deviation.
- `create_welford() -> Map`: Initializes mean and M2 accumulators.
- `update_welford(acc, x)`: Updates online statistics in O(1) time and space.
- `welford_mean(acc) -> f64`: Current sample mean.
- `welford_variance(acc) -> f64`: Unbiased sample variance.
- `welford_stddev(acc) -> f64`: Sample standard deviation.

### `lib/stats/outliers.rhai`
Statistical outlier filtering and anomaly scoring.
- `calc_z_score(val, mean, stddev) -> f64`: Standardized deviation score.
- `is_outlier_z(val, mean, stddev, threshold) -> bool`: Flags values beyond threshold (e.g. 3.0 sigma).
- `interquartile_range(sorted_arr) -> Map`: Computes Q1, Q3, and IQR boundaries.

### `lib/stats/kalman.rhai`
1D linear Kalman filter for noisy sensor telemetry state estimation.
- `create_kalman(q_process_noise, r_measurement_noise) -> Map`: Initializes state and covariance.
- `update_kalman(kf, measurement) -> f64`: Returns optimal state estimate.

### `lib/stats/distributions.rhai`
Probabilistic probability density functions and cumulative distributions.
- `normal_pdf(x, mean, stddev) -> f64`: Gaussian probability density.
- `exponential_pdf(x, lambda) -> f64`: Exponential distribution density.
- `poisson_pmf(k, lambda) -> f64`: Poisson probability mass.

---

## 3. Network Codecs & Protocols

### `lib/net/ipv4.rhai`
IPv4 address parsing and bitwise manipulations.
- `parse_ipv4(str) -> Map`: Validates and parses dotted-quad representation into 4 octets.
- `ipv4_to_u32(str) -> i64`: Converts IPv4 address to 32-bit unsigned integer equivalent.
- `u32_to_ipv4(int_val) -> String`: Formats integer into dotted-quad notation.
- `is_private_ip(str) -> bool`: Checks RFC 1918 private ranges (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16).

### `lib/net/cidr.rhai`
Classless Inter-Domain Routing (CIDR) subnet validation.
- `parse_cidr(cidr_str) -> Map`: Extracts network address and subnet mask prefix length.
- `ip_in_subnet(ip_str, cidr_str) -> bool`: High-speed subnet containment check.

### `lib/net/http.rhai`
HTTP header and status code validation.
- `parse_query_string(query) -> Map`: Decodes URL query parameters into dictionary.
- `is_success(code) -> bool`: Checks for 2xx response codes.
- `is_client_error(code) -> bool`: Checks for 4xx status codes.
- `is_server_error(code) -> bool`: Checks for 5xx status codes.

---

## 4. Encodings & Log Formats

### `lib/encoding/syslog.rhai`
RFC 5424 and RFC 3164 Syslog message parser.
- `parse_syslog(line) -> Map`: Decodes priority, facility, severity, timestamp, hostname, and message.

### `lib/encoding/clf.rhai`
NCSA Common Log Format (CLF) and Combined Log Format web server parser.
- `parse_combined_log(line) -> Map`: Extracts client IP, ident, authuser, timestamp, request line, status, bytes, referer, user-agent.

### `lib/encoding/cef.rhai`
Common Event Format (CEF) security event log parser.
- `parse_cef(line) -> Map`: Decodes CEF header and extension key-value pairs.

### `lib/encoding/hex.rhai` & `lib/encoding/base64.rhai`
Binary-to-text decoding and encoding utilities.
- `hex_encode(str) -> String`: Converts ASCII string to lowercase hexadecimal.
- `hex_decode(hex_str) -> String`: Decodes hexadecimal back to byte string.
- `base64_encode(str) -> String`: Base64 standard RFC 4648 encoding.
- `base64_decode(b64_str) -> String`: Base64 decoding.

---

## 5. Geospatial & Spatial Indexing

### `lib/geo/distance.rhai`
Great-circle distance calculations.
- `haversine_distance_km(lat1, lon1, lat2, lon2) -> f64`: Spherical earth distance in kilometers.
- `vincenty_distance_km(lat1, lon1, lat2, lon2) -> f64`: High-precision ellipsoidal distance calculation.

### `lib/geo/geohash.rhai`
Hierarchical spatial geohash encoding and bounding box calculations.
- `encode_geohash(lat, lon, precision) -> String`: Computes base32 geohash string.
- `decode_geohash(hash) -> Map`: Decodes geohash string into latitude, longitude, and error bounding box.

### `lib/geo/polygon.rhai`
Point-in-polygon containment test using the ray-casting algorithm.
- `point_in_polygon(px, py, polygon_vertices) -> bool`: Returns true if point lies within boundaries.

---

## 6. FSM & CEP

### `lib/fsm/state_machine.rhai`
Deterministic Finite State Machine (FSM).
- `create_fsm(initial_state) -> Map`: Initializes state machine.
- `add_transition(fsm, from_state, event, to_state)`: Registers valid state transition.
- `trigger_event(fsm, event) -> bool`: Transitions state if matched.

### `lib/cep/evaluator.rhai`
Complex Event Processing pattern matcher.
- `create_cep_engine() -> Map`: Allocates match candidate tracker.
- `register_pattern(cep, pattern)`: Adds multi-event sequence predicate.
- `process_event(cep, event) -> Array`: Evaluates event against active candidates and emits triggered alerts.

---

## 7. Testing & Assertions

### `lib/testing/assert.rhai`
Comprehensive unit test assertions with clear error diagnostics.
- `assert_true(cond, msg)`: Asserts condition evaluates to true.
- `assert_false(cond, msg)`: Asserts condition evaluates to false.
- `assert_eq(actual, expected)`: Asserts structural equality.
- `assert_ne(actual, expected)`: Asserts inequality.
