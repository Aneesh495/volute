import "lib/encoding/syslog" as syslog;
import "lib/encoding/clf" as clf;
import "lib/encoding/cef" as cef;
import "lib/encoding/kv" as kv;
import "lib/encoding/csv" as csv;
import "lib/encoding/hex" as hex;
import "lib/testing/assert" as test;

// 1. Syslog
let raw_syslog = "<34>1 2023-10-11T22:14:15.003Z mymachine.example.com su - ID47 - 'su root' failed for lonvick";
let parsed = syslog::parse_syslog(raw_syslog);
test::assert(parsed.is_valid, "syslog valid");
test::assert_eq(parsed.priority, 34, "syslog priority");
test::assert_eq(parsed.facility, 4, "syslog facility");
test::assert_eq(parsed.severity, 2, "syslog severity");

// 2. KV Parser
let kv_line = "src_ip=192.168.1.10 dst_port=443 action=\"ALLOW ENTRY\" user=alice";
let kv_map = kv::parse_kv(kv_line);
test::assert_eq(kv_map["src_ip"], "192.168.1.10", "kv src_ip");
test::assert_eq(kv_map["dst_port"], "443", "kv dst_port");
test::assert_eq(kv_map["action"], "ALLOW ENTRY", "kv quoted action");
test::assert_eq(kv_map["user"], "alice", "kv user");

// 3. CSV Parser
let csv_line = "alice,30,\"New York, NY\",true";
let fields = csv::parse_csv_line(csv_line, ",");
test::assert_eq(fields.len(), 4, "csv fields len");
test::assert_eq(fields[0], "alice", "csv field 0");
test::assert_eq(fields[2], "New York, NY", "csv quoted comma");

// 4. Hex
test::assert_eq(hex::byte_to_hex(255), "ff", "hex 255");
test::assert_eq(hex::hex_to_byte("ff"), 255, "byte 255");
