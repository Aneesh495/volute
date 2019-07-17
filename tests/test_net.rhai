import "lib/net/ipv4" as ip;
import "lib/net/cidr" as cidr;
import "lib/net/http" as http;
import "lib/net/user_agent" as ua;
import "lib/testing/assert" as test;

// 1. IPv4
test::assert(ip::is_private("192.168.1.1"), "is_private 192.168");
test::assert(ip::is_private("10.0.0.1"), "is_private 10.x");
test::assert(ip::is_private("172.20.0.1"), "is_private 172.16-31");
test::assert(!ip::is_private("8.8.8.8"), "not private 8.8.8.8");
test::assert(ip::is_loopback("127.0.0.1"), "is_loopback");

let int_val = ip::ip_to_int("192.168.1.1");
let roundtrip = ip::int_to_ip(int_val);
test::assert_eq(roundtrip, "192.168.1.1", "ip roundtrip");

// 2. CIDR
test::assert(cidr::contains_ip("192.168.1.0/24", "192.168.1.55"), "cidr match inside");
test::assert(!cidr::contains_ip("192.168.1.0/24", "192.168.2.55"), "cidr match outside");

// 3. HTTP
test::assert(http::is_success(200), "http 200 success");
test::assert(http::is_client_error(404), "http 404 client error");
test::assert(http::is_server_error(503), "http 503 server error");

let params = http::parse_query_string("foo=bar&baz=qux");
test::assert_eq(params["foo"], "bar", "query foo");
test::assert_eq(params["baz"], "qux", "query baz");

// 4. User-Agent
test::assert_eq(ua::classify_device("Mozilla/5.0 (iPhone; CPU iPhone OS 14_0)"), "mobile", "ua mobile");
test::assert_eq(ua::classify_device("Googlebot/2.1 (+http://www.google.com/bot.html)"), "bot", "ua bot");
