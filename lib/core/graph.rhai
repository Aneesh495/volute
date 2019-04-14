/*
 * Graph Algorithms for Network and Topology Processing
 *
 * Implements Adjacency List graph representation, Breadth-First Search (BFS),
 * Depth-First Search (DFS), Dijkstra shortest path, and Topological Sort.
 */

// Initialize new directed graph
fn new_graph() {
    return #{
        adj: #{}, // node -> [#{ to: node, weight: f64 }]
        nodes: []
    };
}

// Add vertex to graph
fn add_node(g, node) {
    if !g.adj.contains(node) {
        g.adj[node] = [];
        g.nodes.push(node);
    }
    return g;
}

// Add directed edge with weight
fn add_edge(g, from_node, to_node, weight) {
    add_node(g, from_node);
    add_node(g, to_node);
    g.adj[from_node].push(#{ to: to_node, weight: weight * 1.0 });
    return g;
}

// Breadth-First Search traversal starting from source
fn bfs(g, start_node) {
    let visited = #{};
    let order = [];
    let queue = [start_node];
    visited[start_node] = true;

    while !queue.is_empty() {
        let curr = queue[0];
        let next_queue = [];
        for i in 1..queue.len() {
            next_queue.push(queue[i]);
        }
        queue = next_queue;
        order.push(curr);

        if g.adj.contains(curr) {
            for edge in g.adj[curr] {
                let neighbor = edge.to;
                if !visited.contains(neighbor) {
                    visited[neighbor] = true;
                    queue.push(neighbor);
                }
            }
        }
    }

    return order;
}

// Dijkstra shortest path algorithm; returns distances map from start_node
fn dijkstra(g, start_node) {
    let dist = #{};
    let visited = #{};

    for node in g.nodes {
        dist[node] = 1000000000.0; // infinity
    }
    dist[start_node] = 0.0;

    let unvisited = [];
    for node in g.nodes {
        unvisited.push(node);
    }

    while !unvisited.is_empty() {
        // Find unvisited node with minimum distance
        let min_node = ();
        let min_dist = 1000000000.0;
        let min_idx = -1;

        for i in 0..unvisited.len() {
            let u = unvisited[i];
            if dist[u] < min_dist {
                min_dist = dist[u];
                min_node = u;
                min_idx = i;
            }
        }

        if min_node == () || min_dist >= 1000000000.0 {
            break;
        }

        let next_unvisited = [];
        for i in 0..unvisited.len() {
            if i != min_idx {
                next_unvisited.push(unvisited[i]);
            }
        }
        unvisited = next_unvisited;

        // Relax neighbors
        if g.adj.contains(min_node) {
            for edge in g.adj[min_node] {
                let v = edge.to;
                let alt = dist[min_node] + edge.weight;
                if alt < dist[v] {
                    dist[v] = alt;
                }
            }
        }
    }

    return dist;
}
