# Volute Architecture: Technical Deep-Dive

Volute is a high-throughput, embeddable stream processing and reactive complex event processing (CEP) engine. At its core, Volute couples a high-performance Rust execution substrate with a dynamic, sandboxed Rhai rule scripting layer.

This document describes the internal subsystems of Volute: the sandboxed execution environment, the AST compilation cache, the zero-copy value mapping bridge, the windowing mechanics, and the complex event processing pattern engine.

```
                           +----------------------------------+
                           |       Inbound Event Stream       |
                           |   (Kafka, WebSocket, PCAP, IPC)  |
                           +-----------------+----------------+
                                             |
                                             v
                           +-----------------+----------------+
                           |        Volute Event Bus          |
                           |    Topic Demux & Timestamping    |
                           +-----------------+----------------+
                                             |
                     +-----------------------+-----------------------+
                     |                       |                       |
                     v                       v                       v
           +------------------+    +------------------+    +------------------+
           | Filter Pipeline  |    | Window Aggregator|    |  CEP State Graph |
           |  (Rhai Sandboxed)|    |  (Tumbling/Slide)|    |  (Temporal NFA)  |
           +---------+--------+    +---------+--------+    +---------+--------+
                     |                       |                       |
                     +-----------------------+-----------------------+
                                             |
                                             v
                           +-----------------+----------------+
                           |     Enriched Reactive Alert      |
                           |   (gRPC, Webhook, Disk WAL)      |
                           +----------------------------------+
```

---

## 1. Sandboxed Engine Subsystem

Volute executes domain business logic, cryptographic verification, and state transitions inside an isolated Rhai runtime environment. The engine is configured with strict compute boundaries to guarantee safety and determinism:

1. **Recursion and Expression Depth**:
   Rhai expression depth limits are explicitly tuned to support deep algebraic models and abstract syntax trees without stack exhaustion:
   ```rust
   engine.set_max_expr_depths(256, 256);
   ```

2. **Operation Budgets**:
   To prevent denial-of-service conditions or infinite loops in user-defined scripts, execution budgets can be enforced per event evaluation:
   ```rust
   engine.set_max_operations(100_000);
   ```

3. **Filesystem and OS Isolation**:
   The engine does not expose arbitrary OS syscalls, environment variable inspection, or direct network socket creation to scripts. All network, crypto, and statistical primitives are exposed exclusively through deterministic native Rust packages.

---

## 2. AST Compilation and Caching Layer

Compiling a script from source text to an Abstract Syntax Tree (AST) involves lexical analysis, parsing, and semantic validation. In stream processing environments where thousands of events arrive per second, compiling the script per event would create unacceptable CPU overhead.

Volute utilizes a concurrent `RwLock<HashMap<String, AST>>` cache inside `VoluteEngine`:

```
 [Script Text] -> [Compile & Parse] -> [Store in AST Cache]
                                              |
 [Inbound Event] ----------------------> [Execute AST] -> [Output]
```

- **Cache Hit**: Lock is acquired in read mode (`read()`), bypassing parser passes completely.
- **Cache Miss**: Lock upgrades to write mode (`write()`), the AST is generated and placed into the cache, and subsequent worker threads execute the cached representation.

---

## 3. Rust-Rhai Value Bridge

The Volute value bridge translates between Rust's strongly typed `Event` payload representation and Rhai's dynamic runtime `Dynamic` values.

### Type Translation Matrix

| Rust EventValue | Rhai Native Type | Memory Semantics |
| :--- | :--- | :--- |
| `EventValue::Null` | `()` (Unit) | Zero-copy |
| `EventValue::Bool(b)` | `bool` | Primitive copy (1 byte) |
| `EventValue::Int(i)` | `i64` | Primitive copy (8 bytes) |
| `EventValue::Float(f)` | `f64` | Primitive copy (8 bytes) |
| `EventValue::String(s)` | `ImmutableString` | Heap allocated string ref |
| `EventValue::Array(v)` | `rhai::Array` | Vector of `Dynamic` elements |
| `EventValue::Map(m)` | `rhai::Map` | Key-value dictionary |

### Copy-on-Write and Arena Allocation

Rhai passes maps and arrays by value (copy-on-write). Mutating an item inside a deeply nested map creates a local clone unless properly structured.

For data structures that require high-frequency pointer mutations (e.g. Radix Tries, B-trees, or Directed Graphs), Volute employs an **Arena Index Pattern**:

```
Arena Vector: [ Node 0, Node 1, Node 2, Node 3, ... ]
Node 0: { children: { "a": 1, "b": 2 }, value: () }
Node 1: { children: { "p": 3 }, value: 100 }
```

By referencing array indices rather than direct references, mutations occur through direct indexing without deep tree cloning.

---

## 4. Pipeline Topology and Windowing Mechanics

Volute pipelines are composed of discrete stages executed sequentially or in parallel branches:

```
[Inbound Event] -> [Stage: Filter] -> [Stage: Transform] -> [Stage: Window] -> [Output]
```

### Window Implementations (`src/pipeline/window.rs`)

1. **Tumbling Windows**:
   Non-overlapping, fixed-duration time intervals. When the current event timestamp exceeds the window boundary, all accumulated events are flushed and a fresh window is opened.

2. **Sliding Windows**:
   Overlapping time intervals defined by window length and slide duration. Old events are evicted once they fall behind `current_timestamp - window_size`.

3. **Count Windows**:
   Fixed-size buffers that trigger when the event count reaches the threshold `N`, regardless of wall-clock time.

---

## 5. Complex Event Processing (CEP) State Engine

The CEP engine (`lib/cep/evaluator.rhai`) evaluates temporal sequences across streaming events:

- `FOLLOWED_BY`: Event A followed by Event B within duration T.
- `NOT`: Absence of an expected confirmation event within duration T.
- `COUNT_THRESHOLD`: At least N matching events within time window W.

State transitions are modeled as a Non-Deterministic Finite Automaton (NFA) tracking active match candidates with expiry timeouts. When all predicate transitions are satisfied, a composite alert event is emitted.
