use criterion::{black_box, criterion_group, criterion_main, BenchmarkId, Criterion};
use graph_compute::{
    all_pairs_shortest_paths, approximate_steiner_tree, is_connected, minimum_spanning_tree,
    shortest_path, Edge, Graph,
};

// ── Helpers ───────────────────────────────────────────────────────────────────

/// Build a cycle graph with n nodes (each node connected to the next).
fn cycle_graph(n: usize) -> Graph {
    let edges: Vec<Edge> = (0..n)
        .map(|i| Edge {
            u: i,
            v: (i + 1) % n,
            weight: 1.0,
        })
        .collect();
    Graph::new(n, edges).expect("valid cycle graph")
}

/// Build a complete graph with n nodes (O(n²) edges).
fn complete_graph(n: usize) -> Graph {
    let mut edges = Vec::new();
    for i in 0..n {
        for j in (i + 1)..n {
            edges.push(Edge {
                u: i,
                v: j,
                weight: 1.0 + (i * n + j) as f64 * 0.01,
            });
        }
    }
    Graph::new(n, edges).expect("valid complete graph")
}

// ── Benchmarks ────────────────────────────────────────────────────────────────

fn bench_mst(c: &mut Criterion) {
    let mut group = c.benchmark_group("mst");
    for n in [50usize, 100, 200] {
        let g = complete_graph(n);
        group.bench_with_input(BenchmarkId::from_parameter(n), &g, |b, g| {
            b.iter(|| black_box(minimum_spanning_tree(g)))
        });
    }
    group.finish();
}

fn bench_shortest_path(c: &mut Criterion) {
    let mut group = c.benchmark_group("shortest_path");
    for n in [100usize, 500, 1000] {
        let g = cycle_graph(n);
        group.bench_with_input(BenchmarkId::from_parameter(n), &g, |b, g| {
            b.iter(|| black_box(shortest_path(g, 0, n / 2)))
        });
    }
    group.finish();
}

fn bench_is_connected(c: &mut Criterion) {
    let g = cycle_graph(500);
    c.bench_function("is_connected/500_nodes", |b| {
        b.iter(|| black_box(is_connected(&g)))
    });
}

fn bench_all_pairs(c: &mut Criterion) {
    let mut group = c.benchmark_group("all_pairs_shortest_paths");
    for n in [20usize, 50] {
        let g = complete_graph(n);
        group.bench_with_input(BenchmarkId::from_parameter(n), &g, |b, g| {
            b.iter(|| black_box(all_pairs_shortest_paths(g)))
        });
    }
    group.finish();
}

fn bench_steiner_tree(c: &mut Criterion) {
    let g = complete_graph(30);
    let terminals = vec![0, 10, 20, 29];
    c.bench_function("steiner_tree/30nodes_4terminals", |b| {
        b.iter(|| black_box(approximate_steiner_tree(&g, &terminals)))
    });
}

criterion_group!(
    benches,
    bench_mst,
    bench_shortest_path,
    bench_is_connected,
    bench_all_pairs,
    bench_steiner_tree,
);
criterion_main!(benches);
