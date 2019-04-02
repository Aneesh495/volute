/*
 * Binary Min-Heap Priority Queue Implementation
 *
 * Implements binary heap with O(log N) push and pop operations,
 * peek, size checks, and in-place heapify.
 */

// Initialize new empty priority queue
fn new_priority_queue() {
    return #{
        data: [] // elements stored as #{ priority: f64, item: any }
    };
}

// Get number of elements in queue
fn pq_len(pq) {
    return pq.data.len();
}

// Check if queue is empty
fn pq_is_empty(pq) {
    return pq.data.is_empty();
}

// Push item with priority value into heap
fn pq_push(pq, priority_val, item) {
    let node = #{ priority: priority_val * 1.0, item: item };
    pq.data.push(node);
    let idx = pq.data.len() - 1;

    // Sift up
    while idx > 0 {
        let parent_idx = (idx - 1) / 2;
        if pq.data[idx].priority < pq.data[parent_idx].priority {
            let temp = pq.data[idx];
            pq.data[idx] = pq.data[parent_idx];
            pq.data[parent_idx] = temp;
            idx = parent_idx;
        } else {
            break;
        }
    }
    return pq;
}

// Peek at minimum element without removing
fn pq_peek(pq) {
    if pq.data.is_empty() {
        return ();
    }
    return pq.data[0].item;
}

// Pop minimum element from heap; returns [updated_pq, item_or_unit]
fn pq_pop(pq) {
    if pq.data.is_empty() {
        return [pq, ()];
    }
    let min_item = pq.data[0].item;
    let last = pq.data.pop();

    if pq.data.is_empty() {
        return [pq, min_item];
    }

    pq.data[0] = last;
    let idx = 0;
    let n = pq.data.len();

    // Sift down
    while true {
        let left = 2 * idx + 1;
        let right = 2 * idx + 2;
        let smallest = idx;

        if left < n && pq.data[left].priority < pq.data[smallest].priority {
            smallest = left;
        }
        if right < n && pq.data[right].priority < pq.data[smallest].priority {
            smallest = right;
        }

        if smallest != idx {
            let temp = pq.data[idx];
            pq.data[idx] = pq.data[smallest];
            pq.data[smallest] = temp;
            idx = smallest;
        } else {
            break;
        }
    }

    return [pq, min_item];
}
