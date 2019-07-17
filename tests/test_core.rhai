import "lib/core/types" as types;
import "lib/core/collections" as col;
import "lib/core/strings" as str_mod;
import "lib/core/math" as m;
import "lib/core/time" as t;
import "lib/testing/assert" as test;

// 1. Types
test::assert(types::is_int(42), "is_int check");
test::assert(types::is_float(3.14), "is_float check");
test::assert(types::is_string("hello"), "is_string check");
test::assert(types::is_map(#{ a: 1 }), "is_map check");
test::assert_eq(types::to_float(10), 10.0, "to_float int");

// 2. Collections
let nums = [1, 2, 3, 4, 5, 6];
let evens = col::filter(nums, |x| x % 2 == 0);
test::assert_eq(evens.len(), 3, "filter evens count");
test::assert_eq(evens[0], 2, "first even");

let doubled = col::map([1, 2, 3], |x| x * 2);
test::assert_eq(doubled[1], 4, "doubled map");

let sum = col::fold(nums, 0, |acc, x| acc + x);
test::assert_eq(sum, 21, "sum fold");

let chunks = col::chunk(nums, 2);
test::assert_eq(chunks.len(), 3, "chunk count");
test::assert_eq(chunks[0][1], 2, "chunk content");

// 3. Strings
let padded = str_mod::pad_left("42", 5, "0");
test::assert_eq(padded, "00042", "pad_left check");
test::assert(str_mod::starts_with("volute_engine", "volute"), "starts_with");
test::assert(str_mod::ends_with("volute_engine", "engine"), "ends_with");
test::assert_eq(str_mod::to_kebab_case("hello_world foo"), "hello-world-foo", "kebab");

// 4. Math
test::assert_eq(m::clamp(15, 0, 10), 10, "clamp upper");
test::assert_eq(m::clamp(-5, 0, 10), 0, "clamp lower");
test::assert_eq(m::gcd(48, 18), 6, "gcd");
test::assert_eq(m::factorial(5), 120, "factorial");
test::assert_eq(m::combination(5, 2), 10, "combination 5C2");

// 5. Time
test::assert_eq(t::bucket_index(12500, 5000), 2, "bucket index");
test::assert_eq(t::align_to_bucket(12500, 5000), 10000, "align bucket");
