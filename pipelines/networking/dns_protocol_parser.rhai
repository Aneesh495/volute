/*
 * DNS Protocol Resource Records and Message Dissector
 *
 * Maps RR types, response codes (RCODE), and parses query/response records.
 */

// Return DNS Resource Record type mnemonic
fn get_dns_rr_type_name(rr_type) {
    let types = #{};
    types[1] = #{ id: 1, name: "A", description: "IPv4 Host Address" };
    types[2] = #{ id: 2, name: "NS", description: "Authoritative Name Server" };
    types[5] = #{ id: 5, name: "CNAME", description: "Canonical Name for an Alias" };
    types[6] = #{ id: 6, name: "SOA", description: "Start of Zone of Authority" };
    types[12] = #{ id: 12, name: "PTR", description: "Domain Name Pointer" };
    types[15] = #{ id: 15, name: "MX", description: "Mail Exchange" };
    types[16] = #{ id: 16, name: "TXT", description: "Text Strings" };
    types[28] = #{ id: 28, name: "AAAA", description: "IPv6 Host Address" };
    types[33] = #{ id: 33, name: "SRV", description: "Server Selection Location" };
    types[43] = #{ id: 43, name: "DS", description: "Delegation Signer" };
    types[46] = #{ id: 46, name: "RRSIG", description: "DNSSEC Resource Record Signature" };
    types[47] = #{ id: 47, name: "NSEC", description: "Next Secure Record" };
    types[48] = #{ id: 48, name: "DNSKEY", description: "DNSSEC Key Record" };
    types[50] = #{ id: 50, name: "NSEC3", description: "Next Secure Record version 3" };
    types[51] = #{ id: 51, name: "NSEC3PARAM", description: "NSEC3 Parameters" };
    types[52] = #{ id: 52, name: "TLSA", description: "Transport Layer Security Authentication" };
    types[255] = #{ id: 255, name: "ANY", description: "All Records" };
    types[257] = #{ id: 257, name: "CAA", description: "Certification Authority Authorization" };
    if types.contains(rr_type) { return types[rr_type]; }
    return #{ id: rr_type, name: "TYPE_" + rr_type.to_string(), description: "Custom RR" };
}

// Decode DNS RCODE
fn decode_dns_rcode(rcode) {
    let codes = ["NOERROR", "FORMERR", "SERVFAIL", "NXDOMAIN", "NOTIMP", "REFUSED"];
    if rcode >= 0 && rcode < codes.len() { return codes[rcode]; }
    return "EXTENDED_RCODE";
}
// Validate DNS A record
fn validate_dns_a_record(rr) {
    if !rr.contains("type") || rr["type"].to_int() != 1 { return false; }
    return true;
}

// Validate DNS NS record
fn validate_dns_ns_record(rr) {
    if !rr.contains("type") || rr["type"].to_int() != 2 { return false; }
    return true;
}

// Validate DNS CNAME record
fn validate_dns_cname_record(rr) {
    if !rr.contains("type") || rr["type"].to_int() != 5 { return false; }
    return true;
}

// Validate DNS SOA record
fn validate_dns_soa_record(rr) {
    if !rr.contains("type") || rr["type"].to_int() != 6 { return false; }
    return true;
}

// Validate DNS PTR record
fn validate_dns_ptr_record(rr) {
    if !rr.contains("type") || rr["type"].to_int() != 12 { return false; }
    return true;
}

// Validate DNS MX record
fn validate_dns_mx_record(rr) {
    if !rr.contains("type") || rr["type"].to_int() != 15 { return false; }
    return true;
}

// Validate DNS TXT record
fn validate_dns_txt_record(rr) {
    if !rr.contains("type") || rr["type"].to_int() != 16 { return false; }
    return true;
}

// Validate DNS AAAA record
fn validate_dns_aaaa_record(rr) {
    if !rr.contains("type") || rr["type"].to_int() != 28 { return false; }
    return true;
}

// Validate DNS SRV record
fn validate_dns_srv_record(rr) {
    if !rr.contains("type") || rr["type"].to_int() != 33 { return false; }
    return true;
}

// Validate DNS DS record
fn validate_dns_ds_record(rr) {
    if !rr.contains("type") || rr["type"].to_int() != 43 { return false; }
    return true;
}

// Validate DNS RRSIG record
fn validate_dns_rrsig_record(rr) {
    if !rr.contains("type") || rr["type"].to_int() != 46 { return false; }
    return true;
}

// Validate DNS NSEC record
fn validate_dns_nsec_record(rr) {
    if !rr.contains("type") || rr["type"].to_int() != 47 { return false; }
    return true;
}

// Validate DNS DNSKEY record
fn validate_dns_dnskey_record(rr) {
    if !rr.contains("type") || rr["type"].to_int() != 48 { return false; }
    return true;
}

// Validate DNS NSEC3 record
fn validate_dns_nsec3_record(rr) {
    if !rr.contains("type") || rr["type"].to_int() != 50 { return false; }
    return true;
}

// Validate DNS NSEC3PARAM record
fn validate_dns_nsec3param_record(rr) {
    if !rr.contains("type") || rr["type"].to_int() != 51 { return false; }
    return true;
}

// Validate DNS TLSA record
fn validate_dns_tlsa_record(rr) {
    if !rr.contains("type") || rr["type"].to_int() != 52 { return false; }
    return true;
}

// Validate DNS ANY record
fn validate_dns_any_record(rr) {
    if !rr.contains("type") || rr["type"].to_int() != 255 { return false; }
    return true;
}

// Validate DNS CAA record
fn validate_dns_caa_record(rr) {
    if !rr.contains("type") || rr["type"].to_int() != 257 { return false; }
    return true;
}
