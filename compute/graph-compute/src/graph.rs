use serde::{Deserialize, Serialize};
use std::cmp::Ordering;
use std::collections::{BinaryHeap, HashMap, HashSet};

pub type NodeId = usize;

#[derive(Debug, Clone, Copy, PartialEq, Serialize, Deserialize)]
pub struct Edge {
    pub u: NodeId,
    pub v: NodeId,
    pub weight: f64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Graph {
    pub node_count: usize,
    pub edges: Vec<Edge>,
}

impl Graph {
    pub fn new(node_count: usize, edges: Vec<Edge>) -> Result<Self, String> {
        if node_count == 0 {
            return Err("node_count must be positive".to_string());
        }

        for e in &edges {
            if e.u >= node_count || e.v >= node_count {
                return Err("edge endpoint out of bounds".to_string());
            }
            if e.weight.is_sign_negative() || !e.weight.is_finite() {
                return Err("edge weights must be finite and non-negative".to_string());
            }
        }

        Ok(Self { node_count, edges })
    }

    pub fn adjacency(&self) -> Vec<Vec<(NodeId, f64)>> {
        let mut adj = vec![Vec::new(); self.node_count];
        for e in &self.edges {
            adj[e.u].push((e.v, e.weight));
            adj[e.v].push((e.u, e.weight));
        }
        adj
    }
}

pub fn minimum_spanning_tree(graph: &Graph) -> Result<Vec<Edge>, String> {
    if graph.node_count == 1 {
        return Ok(Vec::new());
    }

    let mut edges = graph.edges.clone();
    edges.sort_by(|a, b| a.weight.partial_cmp(&b.weight).unwrap_or(Ordering::Equal));

    let mut dsu = DisjointSet::new(graph.node_count);
    let mut mst = Vec::with_capacity(graph.node_count.saturating_sub(1));

    for e in edges {
        if dsu.union(e.u, e.v) {
            mst.push(e);
            if mst.len() == graph.node_count - 1 {
                break;
            }
        }
    }

    if mst.len() != graph.node_count - 1 {
        return Err("graph is disconnected; MST does not exist".to_string());
    }

    Ok(mst)
}

pub fn approximate_steiner_tree(graph: &Graph, terminals: &[NodeId]) -> Result<Vec<Edge>, String> {
    if terminals.len() < 2 {
        return Err("at least two terminal nodes are required".to_string());
    }

    let terminal_set: HashSet<NodeId> = terminals.iter().copied().collect();
    if terminal_set.len() != terminals.len() {
        return Err("duplicate terminal node detected".to_string());
    }
    if terminals.iter().any(|&t| t >= graph.node_count) {
        return Err("terminal node out of bounds".to_string());
    }

    // Build metric closure among terminals using shortest paths.
    let mut metric_edges = Vec::new();
    let mut paths: HashMap<(NodeId, NodeId), Vec<NodeId>> = HashMap::new();
    for (i, &src) in terminals.iter().enumerate() {
        let (dist, prev) = dijkstra(graph, src);
        for (j, &dst) in terminals.iter().enumerate().skip(i + 1) {
            if !dist[dst].is_finite() {
                return Err("terminals are not mutually reachable".to_string());
            }
            metric_edges.push(Edge {
                u: i,
                v: j,
                weight: dist[dst],
            });
            paths.insert((src, dst), reconstruct_path(src, dst, &prev));
            paths.insert((dst, src), reconstruct_path(dst, src, &prev));
        }
    }

    let metric_graph = Graph::new(terminals.len(), metric_edges)?;
    let closure_mst = minimum_spanning_tree(&metric_graph)?;

    // Expand metric closure edges back to original graph paths.
    let mut expanded_edges: HashSet<(NodeId, NodeId)> = HashSet::new();
    for e in closure_mst {
        let src = terminals[e.u];
        let dst = terminals[e.v];
        let path = paths
            .get(&(src, dst))
            .ok_or("internal steiner path reconstruction failure")?;
        for pair in path.windows(2) {
            let a = pair[0].min(pair[1]);
            let b = pair[0].max(pair[1]);
            expanded_edges.insert((a, b));
        }
    }

    // Build subgraph and prune non-terminal leaves.
    let mut subgraph_edges = Vec::new();
    for &(a, b) in &expanded_edges {
        let weight = graph
            .edges
            .iter()
            .find_map(|e| {
                if (e.u == a && e.v == b) || (e.u == b && e.v == a) {
                    Some(e.weight)
                } else {
                    None
                }
            })
            .ok_or("expanded edge not found in original graph")?;

        subgraph_edges.push(Edge { u: a, v: b, weight });
    }

    Ok(prune_steiner_leaves(graph.node_count, subgraph_edges, &terminal_set))
}

fn prune_steiner_leaves(node_count: usize, edges: Vec<Edge>, terminals: &HashSet<NodeId>) -> Vec<Edge> {
    if edges.is_empty() {
        return edges;
    }

    let mut edge_list = edges;

    loop {
        let mut degree = vec![0usize; node_count];
        for e in &edge_list {
            degree[e.u] += 1;
            degree[e.v] += 1;
        }

        let leaves: HashSet<NodeId> = (0..node_count)
            .filter(|n| degree[*n] == 1 && !terminals.contains(n))
            .collect();

        if leaves.is_empty() {
            break;
        }

        edge_list.retain(|e| !leaves.contains(&e.u) && !leaves.contains(&e.v));
    }

    edge_list
}

fn dijkstra(graph: &Graph, source: NodeId) -> (Vec<f64>, Vec<Option<NodeId>>) {
    let adj = graph.adjacency();
    let mut dist = vec![f64::INFINITY; graph.node_count];
    let mut prev = vec![None; graph.node_count];

    let mut heap = BinaryHeap::new();
    dist[source] = 0.0;
    heap.push(State {
        cost: 0.0,
        node: source,
    });

    while let Some(State { cost, node }) = heap.pop() {
        if cost > dist[node] {
            continue;
        }

        for &(next, w) in &adj[node] {
            let new_cost = cost + w;
            if new_cost < dist[next] {
                dist[next] = new_cost;
                prev[next] = Some(node);
                heap.push(State {
                    cost: new_cost,
                    node: next,
                });
            }
        }
    }

    (dist, prev)
}

/// Result for a single-source-to-target shortest path query.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct ShortestPathResult {
    /// Total path distance.  `f64::INFINITY` if no path exists.
    pub distance: f64,
    /// Ordered list of node ids from `source` to `target` (inclusive).
    /// Empty if `source == target` or no path exists.
    pub path: Vec<NodeId>,
}

/// Compute the shortest path between `source` and `target` using Dijkstra's
/// algorithm on a non-negative-weight undirected graph.
///
/// Returns `ShortestPathResult { distance: f64::INFINITY, path: vec![] }` when
/// no path exists.
pub fn shortest_path(graph: &Graph, source: NodeId, target: NodeId) -> Result<ShortestPathResult, String> {
    if source >= graph.node_count {
        return Err(format!("source node {} out of bounds", source));
    }
    if target >= graph.node_count {
        return Err(format!("target node {} out of bounds", target));
    }
    if source == target {
        return Ok(ShortestPathResult { distance: 0.0, path: vec![source] });
    }
    let (dist, prev) = dijkstra(graph, source);
    if !dist[target].is_finite() {
        return Ok(ShortestPathResult { distance: f64::INFINITY, path: vec![] });
    }
    Ok(ShortestPathResult {
        distance: dist[target],
        path: reconstruct_path(source, target, &prev),
    })
}

/// Return `true` iff the graph is connected (every node is reachable from node 0).
///
/// A single-node graph is trivially connected.
pub fn is_connected(graph: &Graph) -> bool {
    if graph.node_count <= 1 {
        return true;
    }
    let adj = graph.adjacency();
    let mut visited = vec![false; graph.node_count];
    let mut stack = vec![0usize];
    visited[0] = true;
    while let Some(u) = stack.pop() {
        for &(v, _) in &adj[u] {
            if !visited[v] {
                visited[v] = true;
                stack.push(v);
            }
        }
    }
    visited.iter().all(|&v| v)
}

/// Compute all-pairs shortest-path distances using repeated Dijkstra.
///
/// Returns an `n × n` matrix where `dist[u][v]` is the shortest distance from
/// `u` to `v`, or `f64::INFINITY` if no path exists.
///
/// For dense graphs or graphs with >~500 nodes consider using Floyd-Warshall
/// instead; for sparse graphs this repeated-Dijkstra approach is typical.
pub fn all_pairs_shortest_paths(graph: &Graph) -> Vec<Vec<f64>> {
    (0..graph.node_count)
        .map(|src| {
            let (dist, _) = dijkstra(graph, src);
            dist
        })
        .collect()
}

fn reconstruct_path(source: NodeId, target: NodeId, prev: &[Option<NodeId>]) -> Vec<NodeId> {
    let mut path = Vec::new();
    let mut current = Some(target);

    while let Some(node) = current {
        path.push(node);
        if node == source {
            break;
        }
        current = prev[node];
    }

    path.reverse();
    path
}

#[derive(Clone, Copy)]
struct State {
    cost: f64,
    node: NodeId,
}

impl Eq for State {}

impl PartialEq for State {
    fn eq(&self, other: &Self) -> bool {
        self.cost == other.cost && self.node == other.node
    }
}

impl Ord for State {
    fn cmp(&self, other: &Self) -> Ordering {
        other
            .cost
            .partial_cmp(&self.cost)
            .unwrap_or(Ordering::Equal)
            .then_with(|| self.node.cmp(&other.node))
    }
}

impl PartialOrd for State {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

struct DisjointSet {
    parent: Vec<usize>,
    rank: Vec<usize>,
}

impl DisjointSet {
    fn new(n: usize) -> Self {
        Self {
            parent: (0..n).collect(),
            rank: vec![0; n],
        }
    }

    fn find(&mut self, x: usize) -> usize {
        if self.parent[x] != x {
            let p = self.parent[x];
            self.parent[x] = self.find(p);
        }
        self.parent[x]
    }

    fn union(&mut self, a: usize, b: usize) -> bool {
        let ra = self.find(a);
        let rb = self.find(b);
        if ra == rb {
            return false;
        }

        if self.rank[ra] < self.rank[rb] {
            self.parent[ra] = rb;
        } else if self.rank[ra] > self.rank[rb] {
            self.parent[rb] = ra;
        } else {
            self.parent[rb] = ra;
            self.rank[ra] += 1;
        }

        true
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn sample_graph() -> Graph {
        Graph::new(
            5,
            vec![
                Edge {
                    u: 0,
                    v: 1,
                    weight: 1.0,
                },
                Edge {
                    u: 1,
                    v: 2,
                    weight: 2.0,
                },
                Edge {
                    u: 0,
                    v: 2,
                    weight: 5.0,
                },
                Edge {
                    u: 2,
                    v: 3,
                    weight: 1.0,
                },
                Edge {
                    u: 3,
                    v: 4,
                    weight: 1.0,
                },
                Edge {
                    u: 1,
                    v: 4,
                    weight: 10.0,
                },
            ],
        )
        .expect("graph should be valid")
    }

    #[test]
    fn mst_returns_n_minus_one_edges() {
        let graph = sample_graph();
        let mst = minimum_spanning_tree(&graph).expect("mst exists");
        assert_eq!(mst.len(), graph.node_count - 1);

        let total: f64 = mst.iter().map(|e| e.weight).sum();
        assert!((total - 5.0).abs() < 1e-9);
    }

    #[test]
    fn steiner_tree_connects_terminals_with_low_cost() {
        let graph = sample_graph();
        let steiner = approximate_steiner_tree(&graph, &[0, 2, 4]).expect("steiner exists");

        let total: f64 = steiner.iter().map(|e| e.weight).sum();
        assert!(total <= 5.0 + 1e-9);

        let mut nodes = HashSet::new();
        for e in steiner {
            nodes.insert(e.u);
            nodes.insert(e.v);
        }

        assert!(nodes.contains(&0));
        assert!(nodes.contains(&2));
        assert!(nodes.contains(&4));
    }

    #[test]
    fn steiner_rejects_duplicate_terminals() {
        let graph = sample_graph();
        let err = approximate_steiner_tree(&graph, &[0, 0, 2]).unwrap_err();
        assert!(err.contains("duplicate"));
    }

    // ── shortest_path ─────────────────────────────────────────────────────────

    #[test]
    fn shortest_path_direct_edge() {
        let graph = sample_graph();
        let result = shortest_path(&graph, 0, 1).unwrap();
        assert!((result.distance - 1.0).abs() < 1e-9);
        assert_eq!(result.path, vec![0, 1]);
    }

    #[test]
    fn shortest_path_multi_hop() {
        // 0–1–2 costs 3.0, but direct 0–2 costs 5.0.
        let graph = sample_graph();
        let result = shortest_path(&graph, 0, 2).unwrap();
        assert!((result.distance - 3.0).abs() < 1e-9);
        assert_eq!(result.path, vec![0, 1, 2]);
    }

    #[test]
    fn shortest_path_source_equals_target() {
        let graph = sample_graph();
        let result = shortest_path(&graph, 2, 2).unwrap();
        assert!((result.distance - 0.0).abs() < 1e-9);
        assert_eq!(result.path, vec![2]);
    }

    #[test]
    fn shortest_path_no_path_returns_infinity() {
        // Disconnected graph: nodes 0–2 and isolated node 3.
        let g = Graph::new(
            4,
            vec![
                Edge { u: 0, v: 1, weight: 1.0 },
                Edge { u: 1, v: 2, weight: 1.0 },
            ],
        )
        .unwrap();
        let result = shortest_path(&g, 0, 3).unwrap();
        assert!(result.distance.is_infinite());
        assert!(result.path.is_empty());
    }

    #[test]
    fn shortest_path_rejects_out_of_bounds() {
        let graph = sample_graph();
        assert!(shortest_path(&graph, 0, 99).is_err());
        assert!(shortest_path(&graph, 99, 0).is_err());
    }

    // ── is_connected ──────────────────────────────────────────────────────────

    #[test]
    fn is_connected_connected_graph() {
        let graph = sample_graph();
        assert!(is_connected(&graph));
    }

    #[test]
    fn is_connected_disconnected_graph() {
        let g = Graph::new(
            4,
            vec![
                Edge { u: 0, v: 1, weight: 1.0 },
                Edge { u: 2, v: 3, weight: 1.0 },
            ],
        )
        .unwrap();
        assert!(!is_connected(&g));
    }

    #[test]
    fn is_connected_single_node() {
        let g = Graph::new(1, vec![]).unwrap();
        assert!(is_connected(&g));
    }

    // ── all_pairs_shortest_paths ──────────────────────────────────────────────

    #[test]
    fn all_pairs_shortest_paths_3node_path_graph() {
        // 0 –1.0– 1 –2.0– 2
        let g = Graph::new(
            3,
            vec![
                Edge { u: 0, v: 1, weight: 1.0 },
                Edge { u: 1, v: 2, weight: 2.0 },
            ],
        )
        .unwrap();
        let dist = all_pairs_shortest_paths(&g);
        assert!((dist[0][0] - 0.0).abs() < 1e-9);
        assert!((dist[0][1] - 1.0).abs() < 1e-9);
        assert!((dist[0][2] - 3.0).abs() < 1e-9);
        assert!((dist[1][0] - 1.0).abs() < 1e-9);
        assert!((dist[2][0] - 3.0).abs() < 1e-9);
    }

    #[test]
    fn all_pairs_symmetric_for_undirected_graph() {
        let graph = sample_graph();
        let dist = all_pairs_shortest_paths(&graph);
        let n = graph.node_count;
        for i in 0..n {
            for j in 0..n {
                assert!((dist[i][j] - dist[j][i]).abs() < 1e-9,
                    "dist[{i}][{j}]={} != dist[{j}][{i}]={}",
                    dist[i][j], dist[j][i]);
            }
        }
    }
}
