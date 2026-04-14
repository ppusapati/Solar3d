use criterion::{black_box, criterion_group, criterion_main, BenchmarkId, Criterion};
use common::Point2D;
use geo_compute::{
    clustering::{dbscan, kmeans},
    kdtree::KdTree,
    proximity::nearest_point,
};

// ── Helpers ───────────────────────────────────────────────────────────────────

fn grid_points(n: usize) -> Vec<Point2D> {
    let side = (n as f64).sqrt().ceil() as usize;
    (0..n)
        .map(|i| Point2D {
            x: (i % side) as f64,
            y: (i / side) as f64,
        })
        .collect()
}

fn two_blob_points(n: usize) -> Vec<Point2D> {
    let half = n / 2;
    (0..half)
        .flat_map(|i| {
            let t = i as f64 * 0.1;
            vec![
                Point2D { x: t, y: t * 0.5 },
                Point2D { x: t + 100.0, y: t * 0.5 + 100.0 },
            ]
        })
        .take(n)
        .collect()
}

// ── KD-tree ───────────────────────────────────────────────────────────────────

fn bench_kdtree_build(c: &mut Criterion) {
    let mut group = c.benchmark_group("kdtree/build");
    for n in [100usize, 500, 1000] {
        let pts = grid_points(n);
        group.bench_with_input(BenchmarkId::from_parameter(n), &pts, |b, pts| {
            b.iter(|| black_box(KdTree::build(pts)))
        });
    }
    group.finish();
}

fn bench_kdtree_nearest(c: &mut Criterion) {
    let pts = grid_points(1000);
        let tree = KdTree::build(&pts);
    let query = Point2D { x: 15.5, y: 15.5 };
    c.bench_function("kdtree/nearest_1000pts", |b| {
        b.iter(|| black_box(tree.nearest(&query)))
    });
}

fn bench_kdtree_k_nearest(c: &mut Criterion) {
    let pts = grid_points(1000);
        let tree = KdTree::build(&pts);
    let query = Point2D { x: 15.5, y: 15.5 };
    c.bench_function("kdtree/k_nearest_10_in_1000pts", |b| {
        b.iter(|| black_box(tree.k_nearest(&query, 10)))
    });
}

fn bench_kdtree_radius(c: &mut Criterion) {
    let pts = grid_points(1000);
        let tree = KdTree::build(&pts);
    let query = Point2D { x: 15.0, y: 15.0 };
    c.bench_function("kdtree/within_radius_5_in_1000pts", |b| {
        b.iter(|| black_box(tree.within_radius(&query, 5.0)))
    });
}

// ── Clustering ────────────────────────────────────────────────────────────────

fn bench_dbscan(c: &mut Criterion) {
    let mut group = c.benchmark_group("dbscan");
    for n in [100usize, 500] {
        let pts = two_blob_points(n);
        group.bench_with_input(BenchmarkId::from_parameter(n), &pts, |b, pts| {
            b.iter(|| black_box(dbscan(pts, 5.0, 3)))
        });
    }
    group.finish();
}

fn bench_kmeans(c: &mut Criterion) {
    let mut group = c.benchmark_group("kmeans");
    for n in [100usize, 500] {
        let pts = two_blob_points(n);
        group.bench_with_input(BenchmarkId::from_parameter(n), &pts, |b, pts| {
            b.iter(|| black_box(kmeans(pts, 2, 50, 42)))
        });
    }
    group.finish();
}

// ── Proximity (linear scan baseline) ─────────────────────────────────────────

fn bench_nearest_point_linear(c: &mut Criterion) {
    let pts = grid_points(1000);
    let query = Point2D { x: 15.5, y: 15.5 };
    c.bench_function("proximity/nearest_linear_1000pts", |b| {
        b.iter(|| black_box(nearest_point(query, &pts)))
    });
}

criterion_group!(
    benches,
    bench_kdtree_build,
    bench_kdtree_nearest,
    bench_kdtree_k_nearest,
    bench_kdtree_radius,
    bench_dbscan,
    bench_kmeans,
    bench_nearest_point_linear,
);
criterion_main!(benches);
