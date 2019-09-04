# Volute Domain Pipelines Reference (`pipelines/`)

Volute includes over 70 production-grade stream processing pipelines across multiple technical verticals. Each pipeline is a fully self-contained Rhai module implementing real-time event ingestion, analytical computation, and reactive alert generation.

---

## 1. Financial Systems & Market Microstructure (`pipelines/fintech/`)

- **`options_greeks_surface.rhai`**:
  Black-Scholes analytical valuation for European calls/puts. Computes first-order (Delta, Vega, Theta, Rho), second-order (Gamma, Vanna, Volga), and third-order (Charm) derivatives. Implements Newton-Raphson with bisection fallback for implied volatility extraction and multi-leg risk profiling (straddles, iron condors, butterflies).
- **`portfolio_risk_engine.rhai`**:
  Parametric and historical Value at Risk (VaR), Conditional VaR (Expected Shortfall), sample covariance decomposition, macro historical stress testing (2008 Lehman collapse, 2020 liquidity shock), and maintenance margin monitoring.
- **`crypto_order_matching.rhai`**:
  Deterministic central limit order book (CLOB) engine supporting GTC, IOC, FOK orders, price-time priority execution, and trade tick emission.
- **`crypto_funding_rate_arbitrage.rhai`**:
  8-hour perpetual contract funding rate evaluation, premium index calculation, spot-perp cash-and-carry basis monitoring, and delta-neutral rebalancing.
- **`fx_cross_rates.rhai` & `fx_triangular_arbitrage.rhai`**:
  Direct triangular path arbitrage detection on directed negative-log exchange rate graphs, volume-weighted order book imbalance (VOBI), depth micro-price, and iceberg reload order detection.
- **`fixed_income_yield_curve.rhai`**:
  Nelson-Siegel and Svensson parametric yield curve fitting, zero-coupon discounting, cash flow bond pricing, Macaulay duration, modified duration, convexity, DV01, and 2Y-10Y yield curve inversion alerts.
- **`credit_risk_scoring_engine.rhai`**:
  Basel Internal Ratings-Based (IRB) capital requirements, logistic credit default probability (PD), Loss Given Default (LGD) workout modeling, Exposure at Default (EAD), and Risk-Weighted Assets (RWA).
- **`fix_protocol_codec.rhai` & `fix_fast_protocol.rhai`**:
  FIX 4.4 tag-value parser and FAST (FIX Adapted for STreaming) stop-bit integer decoder with delta and copy operators.
- **`iso8583_full_spec.rhai` & `iso20022_pacs_pain.rhai`**:
  Financial card transaction bitmaps and ISO 20022 XML payment clearance validators.
- **`swift_mt_parser.rhai`**:
  SWIFT MT103 and MT202 payment message block parsers.

---

## 2. Cybersecurity & Kernel Telemetry (`pipelines/security/`)

- **`linux_ebpf_security_telemetry.rhai`**:
  Kernel tracepoint telemetry parsing (sys_enter_execve, ptrace injection, bpf syscall loads, capability elevation).
- **`tls_cipher_suite_auditor.rhai`**:
  RFC 8446 (TLS 1.3) and RFC 5246 (TLS 1.2) handshake auditor, JA3 and JA3S client/server fingerprint hash calculation, and cipher security classification (SWEET32, POODLE, RC4, NULL ciphers).
- **`dns_over_https_auditor.rhai`**:
  DoH (RFC 8484) wire format parsing, Shannon entropy label evaluation for Domain Generation Algorithm (DGA) detection, fast-flux infrastructure alerts, and oversized DNS TXT exfiltration.
- **`oauth2_oidc_jwt_validator.rhai`**:
  RFC 7519 JSON Web Token validator, alg confusion prevention (RS256 vs HS256, "none" attack rejection), issuer/audience verification, and JTI replay cache.
- **`snort_suricata_rules.rhai`**:
  Network intrusion detection rule evaluator with multi-pattern fast-matching.
- **`sigma_rules_windows.rhai` & `sigma_rules_linux.rhai`**:
  Generic security log signatures matching Windows Security Event IDs and Linux auditd logs.
- **`mitre_attack_rules.rhai`**:
  Correlation rules mapped to MITRE ATT&CK enterprise tactics and techniques.
- **`cloud_iam_least_privilege.rhai` & `cloud_guardrails.rhai`**:
  CloudTrail and IAM policy document evaluation checking for wildcard permissions and security misconfigurations.
- **`ssh_brute_force.rhai` & `impossible_travel.rhai`**:
  Geographical distance velocity checks and failed authentication sliding window counters.

---

## 3. IoT & Industrial Telemetry (`pipelines/iot/`)

- **`opc_ua_binary_codec.rhai`**:
  IEC 62541 Part 6 binary message parsing (HEL, ACK, MSG), NodeId resolution, Variant data types, StatusCode quality flags, and four-level analog limit alarms (HH/H/L/LL) with deadband hysteresis.
- **`modbus_rtu.rhai`**:
  Industrial Modbus RTU frame decoder with CRC-16 table verification and coil/register mapping.
- **`dnp3_telemetry.rhai`**:
  Distributed Network Protocol 3 telemetry decoder for electrical substation automation.
- **`zigbee_zcl_telemetry.rhai`**:
  IEEE 802.15.4 Zigbee Cluster Library (ZCL) frame parser.
- **`coap_sensor_protocol.rhai`**:
  Constrained Application Protocol (RFC 7252) parser, delta-encoded option processing, and RFC 7641 Observe subscription tracking.
- **`bacnet_ip.rhai`**:
  Building automation BACnet/IP protocol codec for HVAC and physical access control.
- **`obd2_pid_decoder.rhai`**:
  Automotive CAN bus OBD-II diagnostic parameter identifier decoder (engine RPM, coolant temp, fuel trim).
- **`scada_substation_protection.rhai`**:
  Overcurrent and frequency trip relay monitoring for power grid distribution.

---

## 4. Telemetry & Observability (`pipelines/telemetry/`)

- **`distributed_tracing_sampler.rhai`**:
  W3C TraceContext (traceparent/tracestate) parser, Span Tree DAG builder, critical-path latency bottleneck isolation, and intelligent tail-based trace sampling.
- **`ebpf_network_flow_telemetry.rhai`**:
  Linux kernel TCP socket lifecycle tracking, RTT latency spike detection, TCP zero-window detection, and XDP packet drop counters.
- **`ebpf_tcp_rtt_histogram.rhai`**:
  Logarithmic power-of-two histogram accumulator, percentile estimation (p50, p90, p95, p99, p99.9), and jitter anomaly scoring.
- **`ebpf_page_cache_latency.rhai`**:
  Virtual memory tracepoint monitoring, page cache dirty ratio tracking, and direct memory reclaim stall alerts.
- **`opentelemetry_semantic_conventions.rhai` & `opentelemetry_collector_pipelines.rhai`**:
  OTel span attribute sanitization, PII masking, and metric transformation.
- **`statsd_metrics_parser.rhai` & `prometheus_metrics_registry.rhai`**:
  High-throughput metric stream decoders for counters, gauges, and histograms.
- **`sli_error_budget.rhai`**:
  Service Level Indicator (SLI) rolling window error budget depletion calculation.

---

## 5. Data Quality & Governance (`pipelines/data_quality/`)

- **`anomalous_drift_detector.rhai`**:
  Streaming Population Stability Index (PSI), Kolmogorov-Smirnov (KS) two-sample test statistic, Jensen-Shannon Divergence (JSD), and Wasserstein distance.
- **`schema_registry.rhai`**:
  Backward, forward, and full schema evolution validation for Avro and JSON streaming payloads.
- **`data_contract_validator.rhai` & `great_expectations.rhai`**:
  Declarative data quality rules checking null thresholds, numeric ranges, and regex patterns.

---

## 6. Networking & Infrastructure (`pipelines/networking/`)

- **`netflow_v9.rhai`**:
  Cisco NetFlow v9 binary export packet and template flowset parser.
- **`bgp_flowspec.rhai` & `bgp_evpn_telemetry.rhai`**:
  BGP FlowSpec (RFC 5575) mitigation rules and EVPN (RFC 7432) route validation.
- **`bgp_as_path_prepending.rhai`**:
  AS-Path sequence analysis, RFC 7908 route leak identification, and prepending audits.
- **`diameter_protocol.rhai`**:
  RFC 6733 3GPP LTE/5G Diameter credit control and policy charging parser.
- **`radius_aaa_protocol.rhai`**:
  RFC 2865/2866 RADIUS accounting and authentication packet decoder with session anomaly detection.
