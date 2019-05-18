/*
 * Netflow v9 and IPFIX (RFC 7011) Flow Dissector and Field Registry
 *
 * Maps standard Information Element (IE) identifiers to semantics,
 * decodes flow records, and aggregates network volume statistics.
 */

import "lib/net/ipv4" as ip_mod;

// Lookup Netflow v9 field information element definition
fn get_netflow_element_def(ie_id) {
    let registry = #{};
    registry[1] = #{ id: 1, name: "IN_BYTES", description: "Incoming counter, in bytes" };
    registry[2] = #{ id: 2, name: "IN_PKTS", description: "Incoming counter, in packets" };
    registry[3] = #{ id: 3, name: "FLOWS", description: "Number of flows switched" };
    registry[4] = #{ id: 4, name: "PROTOCOL", description: "IP protocol byte" };
    registry[5] = #{ id: 5, name: "SRC_TOS", description: "Type of Service byte on incoming packets" };
    registry[6] = #{ id: 6, name: "TCP_FLAGS", description: "Cumulative OR of TCP flags" };
    registry[7] = #{ id: 7, name: "L4_SRC_PORT", description: "Layer 4 source port" };
    registry[8] = #{ id: 8, name: "IPV4_SRC_ADDR", description: "IPv4 source address" };
    registry[9] = #{ id: 9, name: "SRC_MASK", description: "Subnet mask bits for source address" };
    registry[10] = #{ id: 10, name: "INPUT_SNMP", description: "Input interface SNMP index" };
    registry[11] = #{ id: 11, name: "L4_DST_PORT", description: "Layer 4 destination port" };
    registry[12] = #{ id: 12, name: "IPV4_DST_ADDR", description: "IPv4 destination address" };
    registry[13] = #{ id: 13, name: "DST_MASK", description: "Subnet mask bits for destination address" };
    registry[14] = #{ id: 14, name: "OUTPUT_SNMP", description: "Output interface SNMP index" };
    registry[15] = #{ id: 15, name: "IPV4_NEXT_HOP", description: "IPv4 next-hop address" };
    registry[16] = #{ id: 16, name: "SRC_AS", description: "Source BGP Autonomous System number" };
    registry[17] = #{ id: 17, name: "DST_AS", description: "Destination BGP Autonomous System number" };
    registry[18] = #{ id: 18, name: "BGP_IPV4_NEXT_HOP", description: "Next-hop BGP router IPv4 address" };
    registry[19] = #{ id: 19, name: "MUL_DST_PKTS", description: "Multicast packets incoming" };
    registry[20] = #{ id: 20, name: "MUL_DST_BYTES", description: "Multicast bytes incoming" };
    registry[21] = #{ id: 21, name: "LAST_SWITCHED", description: "SysUpTime in msec of last packet" };
    registry[22] = #{ id: 22, name: "FIRST_SWITCHED", description: "SysUpTime in msec of first packet" };
    registry[23] = #{ id: 23, name: "OUT_BYTES", description: "Outgoing counter, in bytes" };
    registry[24] = #{ id: 24, name: "OUT_PKTS", description: "Outgoing counter, in packets" };
    registry[25] = #{ id: 25, name: "MIN_PKT_LNGTH", description: "Minimum packet length" };
    registry[26] = #{ id: 26, name: "MAX_PKT_LNGTH", description: "Maximum packet length" };
    registry[27] = #{ id: 27, name: "IPV6_SRC_ADDR", description: "IPv6 source address" };
    registry[28] = #{ id: 28, name: "IPV6_DST_ADDR", description: "IPv6 destination address" };
    registry[29] = #{ id: 29, name: "IPV6_SRC_MASK", description: "Subnet mask bits for IPv6 source" };
    registry[30] = #{ id: 30, name: "IPV6_DST_MASK", description: "Subnet mask bits for IPv6 destination" };
    registry[31] = #{ id: 31, name: "IPV6_FLOW_LABEL", description: "IPv6 flow label" };
    registry[32] = #{ id: 32, name: "ICMP_TYPE", description: "ICMP packet type and code" };
    registry[33] = #{ id: 33, name: "MUL_IGMP_TYPE", description: "IGMP packet type" };
    registry[34] = #{ id: 34, name: "SAMPLING_INTERVAL", description: "Sampling rate interval" };
    registry[35] = #{ id: 35, name: "SAMPLING_ALGORITHM", description: "Sampling algorithm in use" };
    registry[36] = #{ id: 36, name: "FLOW_ACTIVE_TIMEOUT", description: "Timeout value in seconds for active flows" };
    registry[37] = #{ id: 37, name: "FLOW_INACTIVE_TIMEOUT", description: "Timeout value in seconds for idle flows" };
    registry[38] = #{ id: 38, name: "ENGINE_TYPE", description: "Type of flow switching engine" };
    registry[39] = #{ id: 39, name: "ENGINE_ID", description: "ID of flow switching engine" };
    registry[40] = #{ id: 40, name: "TOTAL_BYTES_EXP", description: "Total bytes exported" };
    registry[41] = #{ id: 41, name: "TOTAL_PKTS_EXP", description: "Total packets exported" };
    registry[42] = #{ id: 42, name: "TOTAL_FLOWS_EXP", description: "Total flows exported" };
    registry[44] = #{ id: 44, name: "IPV4_SRC_PREFIX", description: "IPv4 source address prefix" };
    registry[45] = #{ id: 45, name: "IPV4_DST_PREFIX", description: "IPv4 destination address prefix" };
    registry[46] = #{ id: 46, name: "MPLS_TOP_LABEL_TYPE", description: "MPLS Top Label Type" };
    registry[47] = #{ id: 47, name: "MPLS_TOP_LABEL_ADDR", description: "Forwarding address of MPLS top label" };
    registry[48] = #{ id: 48, name: "FLOW_SAMPLER_ID", description: "Identifier for sampling configuration" };
    registry[49] = #{ id: 49, name: "FLOW_SAMPLER_MODE", description: "Sampling mode in use" };
    registry[50] = #{ id: 50, name: "FLOW_SAMPLER_RANDOM_INTERVAL", description: "Random sampling interval" };
    registry[55] = #{ id: 55, name: "DST_TOS", description: "Type of Service byte on outgoing packets" };
    registry[56] = #{ id: 56, name: "SRC_MAC", description: "Source MAC address" };
    registry[57] = #{ id: 57, name: "DST_MAC", description: "Destination MAC address" };
    registry[58] = #{ id: 58, name: "SRC_VLAN", description: "Virtual LAN ID on source interface" };
    registry[59] = #{ id: 59, name: "DST_VLAN", description: "Virtual LAN ID on destination interface" };
    registry[60] = #{ id: 60, name: "IP_PROTOCOL_VERSION", description: "IP version (4 or 6)" };
    registry[61] = #{ id: 61, name: "DIRECTION", description: "Flow direction: 0 for ingress, 1 for egress" };
    registry[62] = #{ id: 62, name: "IPV6_NEXT_HOP", description: "IPv6 next-hop address" };
    registry[63] = #{ id: 63, name: "BGP_IPV6_NEXT_HOP", description: "Next-hop BGP router IPv6 address" };
    registry[64] = #{ id: 64, name: "IPV6_OPTION_HEADERS", description: "Bitmask of IPv6 option headers" };
    registry[70] = #{ id: 70, name: "MPLS_LABEL_1", description: "MPLS label stack position 1" };
    registry[71] = #{ id: 71, name: "MPLS_LABEL_2", description: "MPLS label stack position 2" };
    registry[72] = #{ id: 72, name: "MPLS_LABEL_3", description: "MPLS label stack position 3" };
    registry[73] = #{ id: 73, name: "MPLS_LABEL_4", description: "MPLS label stack position 4" };
    registry[74] = #{ id: 74, name: "MPLS_LABEL_5", description: "MPLS label stack position 5" };
    registry[75] = #{ id: 75, name: "MPLS_LABEL_6", description: "MPLS label stack position 6" };
    registry[76] = #{ id: 76, name: "MPLS_LABEL_7", description: "MPLS label stack position 7" };
    registry[77] = #{ id: 77, name: "MPLS_LABEL_8", description: "MPLS label stack position 8" };
    registry[78] = #{ id: 78, name: "MPLS_LABEL_9", description: "MPLS label stack position 9" };
    registry[79] = #{ id: 79, name: "MPLS_LABEL_10", description: "MPLS label stack position 10" };
    registry[80] = #{ id: 80, name: "IN_DST_MAC", description: "Incoming destination MAC address" };
    registry[81] = #{ id: 81, name: "OUT_SRC_MAC", description: "Outgoing source MAC address" };
    registry[82] = #{ id: 82, name: "IF_NAME", description: "Short interface name" };
    registry[83] = #{ id: 83, name: "IF_DESC", description: "Detailed interface description" };
    registry[84] = #{ id: 84, name: "SAMPLER_NAME", description: "Sampler name" };
    registry[85] = #{ id: 85, name: "IN_PERMANENT_BYTES", description: "Cumulative byte count for permanent flow" };
    registry[86] = #{ id: 86, name: "IN_PERMANENT_PKTS", description: "Cumulative packet count for permanent flow" };
    registry[88] = #{ id: 88, name: "FRAGMENT_OFFSET", description: "IP fragment offset" };
    registry[89] = #{ id: 89, name: "FORWARDING_STATUS", description: "Forwarding status of flow" };
    registry[90] = #{ id: 90, name: "MPLS_PAL_RD", description: "MPLS VPN Route Distinguisher" };
    registry[91] = #{ id: 91, name: "MPLS_PREFIX_LEN", description: "Number of consecutive bits in MPLS prefix" };
    registry[92] = #{ id: 92, name: "SRC_TRAFFIC_INDEX", description: "BGP Policy Accounting source traffic index" };
    registry[93] = #{ id: 93, name: "DST_TRAFFIC_INDEX", description: "BGP Policy Accounting destination traffic index" };
    registry[94] = #{ id: 94, name: "APPLICATION_DESC", description: "User-assigned name of application" };
    registry[95] = #{ id: 95, name: "APPLICATION_ID", description: "Application ID (engine:classifier)" };
    registry[96] = #{ id: 96, name: "APPLICATION_NAME", description: "Standardized application name" };
    if registry.contains(ie_id) {
        return registry[ie_id];
    }
    return #{ id: ie_id, name: "UNKNOWN_IE_" + ie_id.to_string(), description: "Custom Information Element" };
}

// Dissect flow record map
fn dissect_flow_record(flow_map) {
    let src_ip = if flow_map.contains("8") { flow_map["8"] } else { "0.0.0.0" };
    let dst_ip = if flow_map.contains("12") { flow_map["12"] } else { "0.0.0.0" };
    let src_port = if flow_map.contains("7") { flow_map["7"].to_int() } else { 0 };
    let dst_port = if flow_map.contains("11") { flow_map["11"].to_int() } else { 0 };
    let protocol = if flow_map.contains("4") { flow_map["4"].to_int() } else { 0 };
    let bytes_count = if flow_map.contains("1") { flow_map["1"].to_int() } else { 0 };
    let packets_count = if flow_map.contains("2") { flow_map["2"].to_int() } else { 0 };

    let proto_name = "OTHER";
    if protocol == 6 { proto_name = "TCP"; }
    if protocol == 17 { proto_name = "UDP"; }
    if protocol == 1 { proto_name = "ICMP"; }

    return #{
        source_ip: src_ip,
        destination_ip: dst_ip,
        source_port: src_port,
        destination_port: dst_port,
        protocol_number: protocol,
        protocol_name: proto_name,
        bytes: bytes_count,
        packets: packets_count,
        is_internal: ip_mod::is_private(src_ip) && ip_mod::is_private(dst_ip)
    };
}
// Extract and validate Netflow IE 1: IN_BYTES
fn get_flow_in_bytes(flow) {
    let k = "1";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("in_bytes") { return flow["in_bytes"]; }
    return ();
}
fn validate_flow_in_bytes(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 2: IN_PKTS
fn get_flow_in_pkts(flow) {
    let k = "2";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("in_pkts") { return flow["in_pkts"]; }
    return ();
}
fn validate_flow_in_pkts(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 3: FLOWS
fn get_flow_flows(flow) {
    let k = "3";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("flows") { return flow["flows"]; }
    return ();
}
fn validate_flow_flows(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 4: PROTOCOL
fn get_flow_protocol(flow) {
    let k = "4";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("protocol") { return flow["protocol"]; }
    return ();
}
fn validate_flow_protocol(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 5: SRC_TOS
fn get_flow_src_tos(flow) {
    let k = "5";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("src_tos") { return flow["src_tos"]; }
    return ();
}
fn validate_flow_src_tos(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 6: TCP_FLAGS
fn get_flow_tcp_flags(flow) {
    let k = "6";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("tcp_flags") { return flow["tcp_flags"]; }
    return ();
}
fn validate_flow_tcp_flags(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 7: L4_SRC_PORT
fn get_flow_l4_src_port(flow) {
    let k = "7";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("l4_src_port") { return flow["l4_src_port"]; }
    return ();
}
fn validate_flow_l4_src_port(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 8: IPV4_SRC_ADDR
fn get_flow_ipv4_src_addr(flow) {
    let k = "8";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("ipv4_src_addr") { return flow["ipv4_src_addr"]; }
    return ();
}
fn validate_flow_ipv4_src_addr(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 9: SRC_MASK
fn get_flow_src_mask(flow) {
    let k = "9";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("src_mask") { return flow["src_mask"]; }
    return ();
}
fn validate_flow_src_mask(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 10: INPUT_SNMP
fn get_flow_input_snmp(flow) {
    let k = "10";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("input_snmp") { return flow["input_snmp"]; }
    return ();
}
fn validate_flow_input_snmp(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 11: L4_DST_PORT
fn get_flow_l4_dst_port(flow) {
    let k = "11";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("l4_dst_port") { return flow["l4_dst_port"]; }
    return ();
}
fn validate_flow_l4_dst_port(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 12: IPV4_DST_ADDR
fn get_flow_ipv4_dst_addr(flow) {
    let k = "12";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("ipv4_dst_addr") { return flow["ipv4_dst_addr"]; }
    return ();
}
fn validate_flow_ipv4_dst_addr(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 13: DST_MASK
fn get_flow_dst_mask(flow) {
    let k = "13";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("dst_mask") { return flow["dst_mask"]; }
    return ();
}
fn validate_flow_dst_mask(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 14: OUTPUT_SNMP
fn get_flow_output_snmp(flow) {
    let k = "14";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("output_snmp") { return flow["output_snmp"]; }
    return ();
}
fn validate_flow_output_snmp(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 15: IPV4_NEXT_HOP
fn get_flow_ipv4_next_hop(flow) {
    let k = "15";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("ipv4_next_hop") { return flow["ipv4_next_hop"]; }
    return ();
}
fn validate_flow_ipv4_next_hop(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 16: SRC_AS
fn get_flow_src_as(flow) {
    let k = "16";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("src_as") { return flow["src_as"]; }
    return ();
}
fn validate_flow_src_as(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 17: DST_AS
fn get_flow_dst_as(flow) {
    let k = "17";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("dst_as") { return flow["dst_as"]; }
    return ();
}
fn validate_flow_dst_as(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 18: BGP_IPV4_NEXT_HOP
fn get_flow_bgp_ipv4_next_hop(flow) {
    let k = "18";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("bgp_ipv4_next_hop") { return flow["bgp_ipv4_next_hop"]; }
    return ();
}
fn validate_flow_bgp_ipv4_next_hop(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 19: MUL_DST_PKTS
fn get_flow_mul_dst_pkts(flow) {
    let k = "19";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("mul_dst_pkts") { return flow["mul_dst_pkts"]; }
    return ();
}
fn validate_flow_mul_dst_pkts(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 20: MUL_DST_BYTES
fn get_flow_mul_dst_bytes(flow) {
    let k = "20";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("mul_dst_bytes") { return flow["mul_dst_bytes"]; }
    return ();
}
fn validate_flow_mul_dst_bytes(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 21: LAST_SWITCHED
fn get_flow_last_switched(flow) {
    let k = "21";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("last_switched") { return flow["last_switched"]; }
    return ();
}
fn validate_flow_last_switched(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 22: FIRST_SWITCHED
fn get_flow_first_switched(flow) {
    let k = "22";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("first_switched") { return flow["first_switched"]; }
    return ();
}
fn validate_flow_first_switched(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 23: OUT_BYTES
fn get_flow_out_bytes(flow) {
    let k = "23";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("out_bytes") { return flow["out_bytes"]; }
    return ();
}
fn validate_flow_out_bytes(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 24: OUT_PKTS
fn get_flow_out_pkts(flow) {
    let k = "24";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("out_pkts") { return flow["out_pkts"]; }
    return ();
}
fn validate_flow_out_pkts(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 25: MIN_PKT_LNGTH
fn get_flow_min_pkt_lngth(flow) {
    let k = "25";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("min_pkt_lngth") { return flow["min_pkt_lngth"]; }
    return ();
}
fn validate_flow_min_pkt_lngth(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 26: MAX_PKT_LNGTH
fn get_flow_max_pkt_lngth(flow) {
    let k = "26";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("max_pkt_lngth") { return flow["max_pkt_lngth"]; }
    return ();
}
fn validate_flow_max_pkt_lngth(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 27: IPV6_SRC_ADDR
fn get_flow_ipv6_src_addr(flow) {
    let k = "27";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("ipv6_src_addr") { return flow["ipv6_src_addr"]; }
    return ();
}
fn validate_flow_ipv6_src_addr(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 28: IPV6_DST_ADDR
fn get_flow_ipv6_dst_addr(flow) {
    let k = "28";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("ipv6_dst_addr") { return flow["ipv6_dst_addr"]; }
    return ();
}
fn validate_flow_ipv6_dst_addr(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 29: IPV6_SRC_MASK
fn get_flow_ipv6_src_mask(flow) {
    let k = "29";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("ipv6_src_mask") { return flow["ipv6_src_mask"]; }
    return ();
}
fn validate_flow_ipv6_src_mask(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 30: IPV6_DST_MASK
fn get_flow_ipv6_dst_mask(flow) {
    let k = "30";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("ipv6_dst_mask") { return flow["ipv6_dst_mask"]; }
    return ();
}
fn validate_flow_ipv6_dst_mask(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 31: IPV6_FLOW_LABEL
fn get_flow_ipv6_flow_label(flow) {
    let k = "31";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("ipv6_flow_label") { return flow["ipv6_flow_label"]; }
    return ();
}
fn validate_flow_ipv6_flow_label(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 32: ICMP_TYPE
fn get_flow_icmp_type(flow) {
    let k = "32";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("icmp_type") { return flow["icmp_type"]; }
    return ();
}
fn validate_flow_icmp_type(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 33: MUL_IGMP_TYPE
fn get_flow_mul_igmp_type(flow) {
    let k = "33";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("mul_igmp_type") { return flow["mul_igmp_type"]; }
    return ();
}
fn validate_flow_mul_igmp_type(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 34: SAMPLING_INTERVAL
fn get_flow_sampling_interval(flow) {
    let k = "34";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("sampling_interval") { return flow["sampling_interval"]; }
    return ();
}
fn validate_flow_sampling_interval(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 35: SAMPLING_ALGORITHM
fn get_flow_sampling_algorithm(flow) {
    let k = "35";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("sampling_algorithm") { return flow["sampling_algorithm"]; }
    return ();
}
fn validate_flow_sampling_algorithm(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 36: FLOW_ACTIVE_TIMEOUT
fn get_flow_flow_active_timeout(flow) {
    let k = "36";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("flow_active_timeout") { return flow["flow_active_timeout"]; }
    return ();
}
fn validate_flow_flow_active_timeout(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 37: FLOW_INACTIVE_TIMEOUT
fn get_flow_flow_inactive_timeout(flow) {
    let k = "37";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("flow_inactive_timeout") { return flow["flow_inactive_timeout"]; }
    return ();
}
fn validate_flow_flow_inactive_timeout(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 38: ENGINE_TYPE
fn get_flow_engine_type(flow) {
    let k = "38";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("engine_type") { return flow["engine_type"]; }
    return ();
}
fn validate_flow_engine_type(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 39: ENGINE_ID
fn get_flow_engine_id(flow) {
    let k = "39";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("engine_id") { return flow["engine_id"]; }
    return ();
}
fn validate_flow_engine_id(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 40: TOTAL_BYTES_EXP
fn get_flow_total_bytes_exp(flow) {
    let k = "40";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("total_bytes_exp") { return flow["total_bytes_exp"]; }
    return ();
}
fn validate_flow_total_bytes_exp(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 41: TOTAL_PKTS_EXP
fn get_flow_total_pkts_exp(flow) {
    let k = "41";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("total_pkts_exp") { return flow["total_pkts_exp"]; }
    return ();
}
fn validate_flow_total_pkts_exp(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 42: TOTAL_FLOWS_EXP
fn get_flow_total_flows_exp(flow) {
    let k = "42";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("total_flows_exp") { return flow["total_flows_exp"]; }
    return ();
}
fn validate_flow_total_flows_exp(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 44: IPV4_SRC_PREFIX
fn get_flow_ipv4_src_prefix(flow) {
    let k = "44";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("ipv4_src_prefix") { return flow["ipv4_src_prefix"]; }
    return ();
}
fn validate_flow_ipv4_src_prefix(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 45: IPV4_DST_PREFIX
fn get_flow_ipv4_dst_prefix(flow) {
    let k = "45";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("ipv4_dst_prefix") { return flow["ipv4_dst_prefix"]; }
    return ();
}
fn validate_flow_ipv4_dst_prefix(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 46: MPLS_TOP_LABEL_TYPE
fn get_flow_mpls_top_label_type(flow) {
    let k = "46";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("mpls_top_label_type") { return flow["mpls_top_label_type"]; }
    return ();
}
fn validate_flow_mpls_top_label_type(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 47: MPLS_TOP_LABEL_ADDR
fn get_flow_mpls_top_label_addr(flow) {
    let k = "47";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("mpls_top_label_addr") { return flow["mpls_top_label_addr"]; }
    return ();
}
fn validate_flow_mpls_top_label_addr(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 48: FLOW_SAMPLER_ID
fn get_flow_flow_sampler_id(flow) {
    let k = "48";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("flow_sampler_id") { return flow["flow_sampler_id"]; }
    return ();
}
fn validate_flow_flow_sampler_id(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 49: FLOW_SAMPLER_MODE
fn get_flow_flow_sampler_mode(flow) {
    let k = "49";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("flow_sampler_mode") { return flow["flow_sampler_mode"]; }
    return ();
}
fn validate_flow_flow_sampler_mode(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 50: FLOW_SAMPLER_RANDOM_INTERVAL
fn get_flow_flow_sampler_random_interval(flow) {
    let k = "50";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("flow_sampler_random_interval") { return flow["flow_sampler_random_interval"]; }
    return ();
}
fn validate_flow_flow_sampler_random_interval(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 55: DST_TOS
fn get_flow_dst_tos(flow) {
    let k = "55";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("dst_tos") { return flow["dst_tos"]; }
    return ();
}
fn validate_flow_dst_tos(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 56: SRC_MAC
fn get_flow_src_mac(flow) {
    let k = "56";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("src_mac") { return flow["src_mac"]; }
    return ();
}
fn validate_flow_src_mac(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 57: DST_MAC
fn get_flow_dst_mac(flow) {
    let k = "57";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("dst_mac") { return flow["dst_mac"]; }
    return ();
}
fn validate_flow_dst_mac(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 58: SRC_VLAN
fn get_flow_src_vlan(flow) {
    let k = "58";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("src_vlan") { return flow["src_vlan"]; }
    return ();
}
fn validate_flow_src_vlan(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 59: DST_VLAN
fn get_flow_dst_vlan(flow) {
    let k = "59";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("dst_vlan") { return flow["dst_vlan"]; }
    return ();
}
fn validate_flow_dst_vlan(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 60: IP_PROTOCOL_VERSION
fn get_flow_ip_protocol_version(flow) {
    let k = "60";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("ip_protocol_version") { return flow["ip_protocol_version"]; }
    return ();
}
fn validate_flow_ip_protocol_version(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 61: DIRECTION
fn get_flow_direction(flow) {
    let k = "61";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("direction") { return flow["direction"]; }
    return ();
}
fn validate_flow_direction(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 62: IPV6_NEXT_HOP
fn get_flow_ipv6_next_hop(flow) {
    let k = "62";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("ipv6_next_hop") { return flow["ipv6_next_hop"]; }
    return ();
}
fn validate_flow_ipv6_next_hop(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 63: BGP_IPV6_NEXT_HOP
fn get_flow_bgp_ipv6_next_hop(flow) {
    let k = "63";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("bgp_ipv6_next_hop") { return flow["bgp_ipv6_next_hop"]; }
    return ();
}
fn validate_flow_bgp_ipv6_next_hop(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 64: IPV6_OPTION_HEADERS
fn get_flow_ipv6_option_headers(flow) {
    let k = "64";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("ipv6_option_headers") { return flow["ipv6_option_headers"]; }
    return ();
}
fn validate_flow_ipv6_option_headers(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 70: MPLS_LABEL_1
fn get_flow_mpls_label_1(flow) {
    let k = "70";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("mpls_label_1") { return flow["mpls_label_1"]; }
    return ();
}
fn validate_flow_mpls_label_1(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 71: MPLS_LABEL_2
fn get_flow_mpls_label_2(flow) {
    let k = "71";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("mpls_label_2") { return flow["mpls_label_2"]; }
    return ();
}
fn validate_flow_mpls_label_2(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 72: MPLS_LABEL_3
fn get_flow_mpls_label_3(flow) {
    let k = "72";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("mpls_label_3") { return flow["mpls_label_3"]; }
    return ();
}
fn validate_flow_mpls_label_3(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 73: MPLS_LABEL_4
fn get_flow_mpls_label_4(flow) {
    let k = "73";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("mpls_label_4") { return flow["mpls_label_4"]; }
    return ();
}
fn validate_flow_mpls_label_4(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 74: MPLS_LABEL_5
fn get_flow_mpls_label_5(flow) {
    let k = "74";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("mpls_label_5") { return flow["mpls_label_5"]; }
    return ();
}
fn validate_flow_mpls_label_5(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 75: MPLS_LABEL_6
fn get_flow_mpls_label_6(flow) {
    let k = "75";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("mpls_label_6") { return flow["mpls_label_6"]; }
    return ();
}
fn validate_flow_mpls_label_6(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 76: MPLS_LABEL_7
fn get_flow_mpls_label_7(flow) {
    let k = "76";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("mpls_label_7") { return flow["mpls_label_7"]; }
    return ();
}
fn validate_flow_mpls_label_7(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 77: MPLS_LABEL_8
fn get_flow_mpls_label_8(flow) {
    let k = "77";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("mpls_label_8") { return flow["mpls_label_8"]; }
    return ();
}
fn validate_flow_mpls_label_8(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 78: MPLS_LABEL_9
fn get_flow_mpls_label_9(flow) {
    let k = "78";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("mpls_label_9") { return flow["mpls_label_9"]; }
    return ();
}
fn validate_flow_mpls_label_9(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 79: MPLS_LABEL_10
fn get_flow_mpls_label_10(flow) {
    let k = "79";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("mpls_label_10") { return flow["mpls_label_10"]; }
    return ();
}
fn validate_flow_mpls_label_10(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 80: IN_DST_MAC
fn get_flow_in_dst_mac(flow) {
    let k = "80";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("in_dst_mac") { return flow["in_dst_mac"]; }
    return ();
}
fn validate_flow_in_dst_mac(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 81: OUT_SRC_MAC
fn get_flow_out_src_mac(flow) {
    let k = "81";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("out_src_mac") { return flow["out_src_mac"]; }
    return ();
}
fn validate_flow_out_src_mac(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 82: IF_NAME
fn get_flow_if_name(flow) {
    let k = "82";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("if_name") { return flow["if_name"]; }
    return ();
}
fn validate_flow_if_name(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 83: IF_DESC
fn get_flow_if_desc(flow) {
    let k = "83";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("if_desc") { return flow["if_desc"]; }
    return ();
}
fn validate_flow_if_desc(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 84: SAMPLER_NAME
fn get_flow_sampler_name(flow) {
    let k = "84";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("sampler_name") { return flow["sampler_name"]; }
    return ();
}
fn validate_flow_sampler_name(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 85: IN_PERMANENT_BYTES
fn get_flow_in_permanent_bytes(flow) {
    let k = "85";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("in_permanent_bytes") { return flow["in_permanent_bytes"]; }
    return ();
}
fn validate_flow_in_permanent_bytes(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 86: IN_PERMANENT_PKTS
fn get_flow_in_permanent_pkts(flow) {
    let k = "86";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("in_permanent_pkts") { return flow["in_permanent_pkts"]; }
    return ();
}
fn validate_flow_in_permanent_pkts(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 88: FRAGMENT_OFFSET
fn get_flow_fragment_offset(flow) {
    let k = "88";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("fragment_offset") { return flow["fragment_offset"]; }
    return ();
}
fn validate_flow_fragment_offset(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 89: FORWARDING_STATUS
fn get_flow_forwarding_status(flow) {
    let k = "89";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("forwarding_status") { return flow["forwarding_status"]; }
    return ();
}
fn validate_flow_forwarding_status(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 90: MPLS_PAL_RD
fn get_flow_mpls_pal_rd(flow) {
    let k = "90";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("mpls_pal_rd") { return flow["mpls_pal_rd"]; }
    return ();
}
fn validate_flow_mpls_pal_rd(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 91: MPLS_PREFIX_LEN
fn get_flow_mpls_prefix_len(flow) {
    let k = "91";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("mpls_prefix_len") { return flow["mpls_prefix_len"]; }
    return ();
}
fn validate_flow_mpls_prefix_len(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 92: SRC_TRAFFIC_INDEX
fn get_flow_src_traffic_index(flow) {
    let k = "92";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("src_traffic_index") { return flow["src_traffic_index"]; }
    return ();
}
fn validate_flow_src_traffic_index(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 93: DST_TRAFFIC_INDEX
fn get_flow_dst_traffic_index(flow) {
    let k = "93";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("dst_traffic_index") { return flow["dst_traffic_index"]; }
    return ();
}
fn validate_flow_dst_traffic_index(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 94: APPLICATION_DESC
fn get_flow_application_desc(flow) {
    let k = "94";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("application_desc") { return flow["application_desc"]; }
    return ();
}
fn validate_flow_application_desc(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 95: APPLICATION_ID
fn get_flow_application_id(flow) {
    let k = "95";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("application_id") { return flow["application_id"]; }
    return ();
}
fn validate_flow_application_id(val) {
    if type_of(val) == "()" { return false; }
    return true;
}

// Extract and validate Netflow IE 96: APPLICATION_NAME
fn get_flow_application_name(flow) {
    let k = "96";
    if flow.contains(k) { return flow[k]; }
    if flow.contains("application_name") { return flow["application_name"]; }
    return ();
}
fn validate_flow_application_name(val) {
    if type_of(val) == "()" { return false; }
    return true;
}
