/*
 * Prefix Tree (Trie) Data Structure
 *
 * Implements string insertion, exact lookup, prefix matching,
 * and autocomplete suggestions.
 */

// Initialize new Trie node
fn new_trie_node() {
    return #{
        children: #{}, // char -> node
        is_terminal: false,
        value: ()
    };
}

// Initialize new empty Trie
fn new_trie() {
    return #{
        root: new_trie_node(),
        word_count: 0
    };
}

// Insert word and associated value into Trie
fn trie_insert(trie, word, value) {
    let curr = trie.root;
    for i in 0..word.len() {
        let ch = word.sub_string(i, 1);
        if !curr.children.contains(ch) {
            curr.children[ch] = new_trie_node();
        }
        curr = curr.children[ch];
    }
    if !curr.is_terminal {
        trie.word_count += 1;
    }
    curr.is_terminal = true;
    curr.value = value;
    return trie;
}

// Search for exact word; returns value or unit
fn trie_search(trie, word) {
    let curr = trie.root;
    for i in 0..word.len() {
        let ch = word.sub_string(i, 1);
        if !curr.children.contains(ch) {
            return ();
        }
        curr = curr.children[ch];
    }
    if curr.is_terminal {
        return curr.value;
    }
    return ();
}

// Check if any word starts with prefix
fn trie_starts_with(trie, prefix) {
    let curr = trie.root;
    for i in 0..prefix.len() {
        let ch = prefix.sub_string(i, 1);
        if !curr.children.contains(ch) {
            return false;
        }
        curr = curr.children[ch];
    }
    return true;
}
