/*
 * Arena-Allocated Prefix Tree (Trie)
 *
 * Implements prefix trie using indexed node arena for efficient value storage.
 */

// Initialize new Trie using arena indexing
fn new_trie() {
    let root_node = #{
        children: #{},
        is_terminal: false,
        value: ()
    };
    return #{
        nodes: [root_node],
        word_count: 0
    };
}

// Insert word into Trie arena
fn trie_insert(trie, word, value) {
    let curr_idx = 0;
    for i in 0..word.len() {
        let ch = word.sub_string(i, 1);
        if !trie.nodes[curr_idx].children.contains(ch) {
            let next_idx = trie.nodes.len();
            let new_node = #{
                children: #{},
                is_terminal: false,
                value: ()
            };
            trie.nodes.push(new_node);
            trie.nodes[curr_idx].children[ch] = next_idx;
            curr_idx = next_idx;
        } else {
            curr_idx = trie.nodes[curr_idx].children[ch];
        }
    }
    if !trie.nodes[curr_idx].is_terminal {
        trie.word_count += 1;
    }
    trie.nodes[curr_idx].is_terminal = true;
    trie.nodes[curr_idx].value = value;
    return trie;
}

// Search word in Trie; returns value or unit
fn trie_search(trie, word) {
    let curr_idx = 0;
    for i in 0..word.len() {
        let ch = word.sub_string(i, 1);
        if !trie.nodes[curr_idx].children.contains(ch) {
            return ();
        }
        curr_idx = trie.nodes[curr_idx].children[ch];
    }
    if trie.nodes[curr_idx].is_terminal {
        return trie.nodes[curr_idx].value;
    }
    return ();
}

// Check if any word starts with prefix
fn trie_starts_with(trie, prefix) {
    let curr_idx = 0;
    for i in 0..prefix.len() {
        let ch = prefix.sub_string(i, 1);
        if !trie.nodes[curr_idx].children.contains(ch) {
            return false;
        }
        curr_idx = trie.nodes[curr_idx].children[ch];
    }
    return true;
}
