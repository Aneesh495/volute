import "lib/core/priority_queue" as pq;
import "lib/core/trie" as trie;
import "lib/core/ring_buffer" as rb;
import "lib/core/graph" as g;
import "lib/core/matrix" as mat;
import "lib/core/kmp" as kmp;
import "lib/stats/kalman" as kf;
import "pipelines/fintech/black_scholes" as bs;
import "pipelines/fintech/vwap_twap" as vwap;
import "pipelines/iot/mqtt_router" as mqtt;
import "pipelines/ecommerce/surge_pricing" as surge;
import "lib/testing/assert" as test;

// 1. Priority Queue
let q = pq::new_priority_queue();
q = pq::pq_push(q, 10.0, "low_priority");
q = pq::pq_push(q, 2.0, "high_priority");
q = pq::pq_push(q, 5.0, "mid_priority");

test::assert_eq(pq::pq_len(q), 3, "pq len");
test::assert_eq(pq::pq_peek(q), "high_priority", "pq peek min");

let pop_res = pq::pq_pop(q);
q = pop_res[0];
test::assert_eq(pop_res[1], "high_priority", "pq pop 1");

let pop_res2 = pq::pq_pop(q);
test::assert_eq(pop_res2[1], "mid_priority", "pq pop 2");

// 2. Trie
let t = trie::new_trie();
t = trie::trie_insert(t, "apple", 100);
t = trie::trie_insert(t, "app", 200);

test::assert_eq(trie::trie_search(t, "apple"), 100, "trie search apple");
test::assert_eq(trie::trie_search(t, "app"), 200, "trie search app");
test::assert(trie::trie_starts_with(t, "ap"), "trie prefix ap");
test::assert(!trie::trie_starts_with(t, "ban"), "trie prefix ban false");

// 3. Ring Buffer
let ring = rb::new_ring_buffer(3);
ring = rb::rb_push(ring, 1);
ring = rb::rb_push(ring, 2);
ring = rb::rb_push(ring, 3);
ring = rb::rb_push(ring, 4); // overwrites 1

let items = rb::rb_to_array(ring);
test::assert_eq(items.len(), 3, "ring buffer size");
test::assert_eq(items[0], 2, "oldest remaining 2");
test::assert_eq(items[2], 4, "newest item 4");

// 4. Graph & Dijkstra
let graph = g::new_graph();
graph = g::add_edge(graph, "A", "B", 4.0);
graph = g::add_edge(graph, "A", "C", 2.0);
graph = g::add_edge(graph, "C", "B", 1.0); // A -> C -> B has total weight 3.0

let dists = g::dijkstra(graph, "A");
test::assert_eq(dists["A"], 0.0, "dijkstra A dist");
test::assert_eq(dists["C"], 2.0, "dijkstra C dist");
test::assert_eq(dists["B"], 3.0, "dijkstra B via C dist");

// 5. Matrix Multiplications
let m1 = [[1.0, 2.0], [3.0, 4.0]];
let m2 = [[2.0, 0.0], [1.0, 2.0]];
let m3 = mat::mat_mul(m1, m2);
test::assert_eq(m3[0][0], 4.0, "mat mul (0,0)");
test::assert_eq(m3[0][1], 4.0, "mat mul (0,1)");
test::assert_eq(m3[1][0], 10.0, "mat mul (1,0)");
test::assert_eq(m3[1][1], 8.0, "mat mul (1,1)");

// 6. KMP Search
let text = "ABABDABACDABABCABAB";
let pattern = "ABABCABAB";
let matches = kmp::kmp_search(text, pattern);
test::assert_eq(matches.len(), 1, "kmp single match");
test::assert_eq(matches[0], 10, "kmp match index");

// 7. Kalman Filter
let k = kf::new_kalman_1d(0.0, 1.0, 0.01, 0.1);
k = kf::kalman_update(k, 10.0);
k = kf::kalman_update(k, 10.5);
test::assert(kf::kalman_estimate(k) > 5.0, "kalman converged towards 10");

// 8. Black-Scholes Call Option
// Spot=100, Strike=100, r=0.05, vol=0.20, T=1.0 year -> Call ~ 10.45
let call_premium = bs::call_price(100.0, 100.0, 0.05, 0.20, 1.0);
test::assert(call_premium > 10.0 && call_premium < 11.0, "call option ~ 10.45");

// 9. VWAP Accumulator
let v = vwap::new_vwap_accumulator();
v = vwap::update_vwap(v, 100.0, 10);
v = vwap::update_vwap(v, 200.0, 10);
test::assert_near(vwap::get_vwap(v), 150.0, 0.001, "vwap 150");

// 10. MQTT Wildcards
test::assert(mqtt::mqtt_topic_matches("sensor/+/temperature", "sensor/kitchen/temperature"), "single + wildcard");
test::assert(!mqtt::mqtt_topic_matches("sensor/+/temperature", "sensor/kitchen/living/temperature"), "+ rejects multi-level");
test::assert(mqtt::mqtt_topic_matches("sensor/#", "sensor/kitchen/living/temperature"), "multi # wildcard");

// 11. Surge Pricing
let mult = surge::calculate_surge_multiplier(200, 100, 0.5); // 2x demand, elasticity 0.5 -> 1.5x
test::assert_near(mult, 1.5, 0.01, "surge multiplier 1.5");
