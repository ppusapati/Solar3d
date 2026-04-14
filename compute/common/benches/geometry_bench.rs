use criterion::{black_box, criterion_group, criterion_main, BenchmarkId, Criterion};
use common::{
    clip_polygon_convex, convex_hull, point_in_polygon, polygon_area_signed, LineSegment,
    Point2D, Polygon, segment_intersection,
};

// ── Helpers ───────────────────────────────────────────────────────────────────

fn square_poly(side: f64) -> Polygon {
    Polygon {
        ring: vec![
            Point2D { x: 0.0, y: 0.0 },
            Point2D { x: side, y: 0.0 },
            Point2D { x: side, y: side },
            Point2D { x: 0.0, y: side },
        ],
    }
}

fn make_points(n: usize) -> Vec<Point2D> {
    (0..n)
        .map(|i| {
            let t = i as f64 / n as f64;
            Point2D {
                x: t * 100.0,
                y: (t * 6.28318).sin() * 50.0 + 50.0,
            }
        })
        .collect()
}

// ── Benchmarks ────────────────────────────────────────────────────────────────

fn bench_point_in_polygon(c: &mut Criterion) {
    let poly = square_poly(100.0);
    let points: Vec<Point2D> = (0..1000)
        .map(|i| Point2D {
            x: (i % 200) as f64 - 50.0,
            y: (i / 200) as f64 * 10.0,
        })
        .collect();

    c.bench_function("point_in_polygon/1000_queries", |b| {
        b.iter(|| {
            for &p in &points {
                black_box(point_in_polygon(p, &poly));
            }
        })
    });
}

fn bench_convex_hull(c: &mut Criterion) {
    let mut group = c.benchmark_group("convex_hull");
    for n in [100usize, 500, 1000, 5000] {
        let pts = make_points(n);
        group.bench_with_input(BenchmarkId::from_parameter(n), &pts, |b, pts| {
            b.iter(|| black_box(convex_hull(pts)))
        });
    }
    group.finish();
}

fn bench_clip_polygon(c: &mut Criterion) {
    let subject = square_poly(10.0);
    let clip = Polygon {
        ring: vec![
            Point2D { x: 5.0, y: 5.0 },
            Point2D { x: 15.0, y: 5.0 },
            Point2D { x: 15.0, y: 15.0 },
            Point2D { x: 5.0, y: 15.0 },
        ],
    };
    c.bench_function("clip_polygon_convex", |b| {
        b.iter(|| black_box(clip_polygon_convex(&subject, &clip)))
    });
}

fn bench_segment_intersection(c: &mut Criterion) {
    let s1 = LineSegment {
        a: Point2D { x: 0.0, y: 0.0 },
        b: Point2D { x: 10.0, y: 10.0 },
    };
    let s2 = LineSegment {
        a: Point2D { x: 0.0, y: 10.0 },
        b: Point2D { x: 10.0, y: 0.0 },
    };
    c.bench_function("segment_intersection", |b| {
        b.iter(|| black_box(segment_intersection(s1, s2)))
    });
}

fn bench_polygon_area(c: &mut Criterion) {
    let poly = square_poly(100.0);
    c.bench_function("polygon_area_signed", |b| {
        b.iter(|| black_box(polygon_area_signed(&poly)))
    });
}

criterion_group!(
    benches,
    bench_point_in_polygon,
    bench_convex_hull,
    bench_clip_polygon,
    bench_segment_intersection,
    bench_polygon_area,
);
criterion_main!(benches);
