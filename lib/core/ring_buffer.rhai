/*
 * Circular Ring Buffer with Fixed Capacity
 *
 * Implements bounded FIFO buffer with overwrite semantics for streaming metrics.
 */

// Initialize circular buffer with maximum capacity
fn new_ring_buffer(capacity) {
    return #{
        capacity: capacity,
        buffer: [],
        head: 0,
        size: 0
    };
}

// Push item into ring buffer; overwrites oldest if full
fn rb_push(rb, item) {
    if rb.buffer.len() < rb.capacity {
        rb.buffer.push(item);
        rb.size += 1;
    } else {
        rb.buffer[rb.head] = item;
        rb.head = (rb.head + 1) % rb.capacity;
    }
    return rb;
}

// Get array of items in chronological order
fn rb_to_array(rb) {
    let result = [];
    if rb.size == 0 {
        return result;
    }
    if rb.buffer.len() < rb.capacity {
        for item in rb.buffer {
            result.push(item);
        }
    } else {
        for idx in 0..rb.capacity {
            let pos = (rb.head + idx) % rb.capacity;
            result.push(rb.buffer[pos]);
        }
    }
    return result;
}

// Clear ring buffer
fn rb_clear(rb) {
    rb.buffer = [];
    rb.head = 0;
    rb.size = 0;
    return rb;
}
