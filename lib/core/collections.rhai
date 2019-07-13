/*
 * High-performance Functional Collections Library
 *
 * Implements pure streaming combinators for arrays and maps:
 * filter, map, fold, chunk, sliding windows, partitions, and groupings.
 */

// Filter array elements matching predicate
fn filter(arr, pred) {
    let result = [];
    for item in arr {
        if call(pred, item) {
            result.push(item);
        }
    }
    return result;
}

// Map transformation over array elements
fn map(arr, mapper) {
    let result = [];
    for item in arr {
        result.push(call(mapper, item));
    }
    return result;
}

// Left fold over array elements with accumulator
fn fold(arr, initial, folder) {
    let acc = initial;
    for item in arr {
        acc = call(folder, acc, item);
    }
    return acc;
}

// Reduce array elements without initial value
fn reduce(arr, reducer) {
    if arr.is_empty() {
        return ();
    }
    let acc = arr[0];
    for i in 1..arr.len() {
        acc = call(reducer, acc, arr[i]);
    }
    return acc;
}

// Partition array into two slices [matching, non_matching]
fn partition(arr, pred) {
    let matches = [];
    let non_matches = [];
    for item in arr {
        if call(pred, item) {
            matches.push(item);
        } else {
            non_matches.push(item);
        }
    }
    return [matches, non_matches];
}

// Chunk array into fixed-size windows
fn chunk(arr, size) {
    if size <= 0 {
        return [];
    }
    let result = [];
    let current = [];
    for item in arr {
        current.push(item);
        if current.len() == size {
            result.push(current);
            current = [];
        }
    }
    if !current.is_empty() {
        result.push(current);
    }
    return result;
}

// Sliding window over array elements
fn window(arr, size, step) {
    if size <= 0 || step <= 0 || arr.len() < size {
        return [];
    }
    let result = [];
    let i = 0;
    while i + size <= arr.len() {
        let win = [];
        for j in 0..size {
            win.push(arr[i + j]);
        }
        result.push(win);
        i += step;
    }
    return result;
}

// Group array elements by derived key string
fn group_by(arr, key_extractor) {
    let groups = #{};
    for item in arr {
        let key = call(key_extractor, item);
        if !groups.contains(key) {
            groups[key] = [];
        }
        groups[key].push(item);
    }
    return groups;
}

// Key array elements into a map by unique identifier
fn key_by(arr, key_extractor) {
    let keyed = #{};
    for item in arr {
        let key = call(key_extractor, item);
        keyed[key] = item;
    }
    return keyed;
}

// Compute frequency map of elements
fn frequencies(arr) {
    let freqs = #{};
    for item in arr {
        let key = item.to_string();
        if freqs.contains(key) {
            freqs[key] += 1;
        } else {
            freqs[key] = 1;
        }
    }
    return freqs;
}

// Zip two arrays into array of pairs
fn zip(arr_a, arr_b) {
    let result = [];
    let min_len = arr_a.len();
    if arr_b.len() < min_len {
        min_len = arr_b.len();
    }
    for i in 0..min_len {
        result.push([arr_a[i], arr_b[i]]);
    }
    return result;
}

// Deduplicate array elements while preserving order
fn distinct(arr) {
    let seen = #{};
    let result = [];
    for item in arr {
        let key = item.to_string();
        if !seen.contains(key) {
            seen[key] = true;
            result.push(item);
        }
    }
    return result;
}

// Flatten array of arrays by one depth level
fn flatten(nested) {
    let result = [];
    for sub in nested {
        if type_of(sub) == "array" {
            for item in sub {
                result.push(item);
            }
        } else {
            result.push(sub);
        }
    }
    return result;
}

// Flat-map array using mapping function that returns array
fn flat_map(arr, mapper) {
    let result = [];
    for item in arr {
        let mapped = call(mapper, item);
        if type_of(mapped) == "array" {
            for sub_item in mapped {
                result.push(sub_item);
            }
        } else {
            result.push(mapped);
        }
    }
    return result;
}

// Take first N elements
fn take(arr, count) {
    let result = [];
    let limit = count;
    if limit > arr.len() {
        limit = arr.len();
    }
    for i in 0..limit {
        result.push(arr[i]);
    }
    return result;
}

// Drop first N elements
fn drop(arr, count) {
    let result = [];
    if count >= arr.len() {
        return result;
    }
    for i in count..arr.len() {
        result.push(arr[i]);
    }
    return result;
}
