use criterion::{black_box, criterion_group, criterion_main, BenchmarkId, Criterion};
use terrain_compute::{compute_aspect_grid, compute_slope_grid, AStarRouter, ElevationGrid};

fn bench_elevation_grid(c: &mut Criterion) {
    let mut group = c.benchmark_group("elevation_grid");

    for size in [10, 50, 100].iter() {
        group.bench_with_input(BenchmarkId::new("create_grid", size), size, |b, &size| {
            let elevations = vec![vec![500.0 + (i as f64 * 0.1); size]; size];

            b.iter(|| {
                let _grid = ElevationGrid::new(
                    black_box(elevations.clone()),
                    black_box(1.0), // resolution in meters
                );
            });
        });
    }

    for size in [10, 50, 100].iter() {
        group.bench_with_input(
            BenchmarkId::new("interpolate_elevation", size),
            size,
            |b, &size| {
                let elevations = vec![vec![500.0; size]; size];
                let grid = ElevationGrid::new(elevations, 1.0);

                b.iter(|| {
                    let _ = grid.interpolate_elevation(
                        black_box(size as f64 / 2.0),
                        black_box(size as f64 / 2.0),
                    );
                });
            },
        );
    }

    group.finish();
}

fn bench_slope_computation(c: &mut Criterion) {
    let mut group = c.benchmark_group("slope_computation");

    for size in [10, 50, 100].iter() {
        group.bench_with_input(
            BenchmarkId::new("compute_slope_grid", size),
            size,
            |b, &size| {
                let elevations =
                    vec![vec![500.0 + (i as f64 * 0.01) + (j as f64 * 0.01); size]; size];

                b.iter(|| {
                    black_box(compute_slope_grid(
                        black_box(&elevations),
                        black_box(1.0), // resolution
                    ))
                });
            },
        );
    }

    group.finish();
}

fn bench_aspect_computation(c: &mut Criterion) {
    let mut group = c.benchmark_group("aspect_computation");

    for size in [10, 50, 100].iter() {
        group.bench_with_input(
            BenchmarkId::new("compute_aspect_grid", size),
            size,
            |b, &size| {
                let elevations = vec![vec![500.0 + (i as f64 * 0.01); size]; size];

                b.iter(|| {
                    black_box(compute_aspect_grid(
                        black_box(&elevations),
                        black_box(1.0), // resolution
                    ))
                });
            },
        );
    }

    group.finish();
}

fn bench_astar_pathfinding(c: &mut Criterion) {
    let mut group = c.benchmark_group("astar_pathfinding");

    for grid_size in [10, 25, 50].iter() {
        group.bench_with_input(
            BenchmarkId::new("route_path", grid_size),
            grid_size,
            |b, &grid_size| {
                let elevations = vec![vec![500.0; grid_size]; grid_size];
                let router = AStarRouter::new(elevations, 1.0);

                let start = black_box((1.0, 1.0));
                let goal = black_box((grid_size as f64 - 2.0, grid_size as f64 - 2.0));

                b.iter(|| {
                    let _ = router.find_path(start, goal);
                });
            },
        );
    }

    group.finish();
}

fn bench_cost_evaluation(c: &mut Criterion) {
    let mut group = c.benchmark_group("cost_evaluation");

    group.bench_function("evaluate_cell_cost", |b| {
        let router = AStarRouter::new(vec![vec![500.0; 50]; 50], 1.0);

        let from = black_box((10.0, 10.0));
        let to = black_box((11.0, 10.0));

        b.iter(|| {
            let _ = router.evaluate_cost(from, to);
        });
    });

    group.finish();
}

criterion_group!(
    benches,
    bench_elevation_grid,
    bench_slope_computation,
    bench_aspect_computation,
    bench_astar_pathfinding,
    bench_cost_evaluation
);
criterion_main!(benches);
