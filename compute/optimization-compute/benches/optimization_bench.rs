use criterion::{black_box, criterion_group, criterion_main, BenchmarkId, Criterion};
use optimization_compute::{
    monte_carlo::{Distribution, MonteCarloEngine},
    nsga2::{NSGA2Config, NSGA2},
    Objective, MultiObjective,
};
use optimization_compute::objectives::ObjectiveKind;

// ── Helpers ───────────────────────────────────────────────────────────────────

fn two_min_objectives() -> MultiObjective {
    MultiObjective::new(vec![
        Objective { name: "f1".into(), kind: ObjectiveKind::Minimize, weight: 0.5 },
        Objective { name: "f2".into(), kind: ObjectiveKind::Minimize, weight: 0.5 },
    ])
    .unwrap()
}

/// ZDT1 two-objective test problem.
fn zdt1(x: &[f64]) -> Vec<f64> {
    let f1 = x[0];
    let n = x.len() as f64;
    let g = 1.0 + 9.0 * x[1..].iter().sum::<f64>() / (n - 1.0);
    let f2 = g * (1.0 - (f1 / g).sqrt());
    vec![f1, f2]
}

// ── NSGA-II ───────────────────────────────────────────────────────────────────

fn bench_nsga2(c: &mut Criterion) {
    let mut group = c.benchmark_group("nsga2");
    for (pop, gen) in [(50usize, 50usize), (100, 100), (200, 50)] {
        let config = NSGA2Config::new(pop, gen, 0.9, 0.1, vec![(0.0, 1.0); 5]);
        let objectives = two_min_objectives();
        group.bench_with_input(
            BenchmarkId::new("ZDT1", format!("pop{pop}_gen{gen}")),
            &(config, objectives),
            |b, (cfg, obj)| b.iter(|| black_box(NSGA2::evolve(&zdt1, obj, cfg, 42))),
        );
    }
    group.finish();
}

// ── Monte Carlo ───────────────────────────────────────────────────────────────

fn bench_monte_carlo(c: &mut Criterion) {
    let mut group = c.benchmark_group("monte_carlo");
    for n in [1000usize, 10_000, 100_000] {
        let engine = MonteCarloEngine::new(42);
        let dist = Distribution::new(5.0, 1.0).unwrap();
        group.bench_with_input(BenchmarkId::from_parameter(n), &n, |b, &n| {
            b.iter(|| {
                black_box(engine.sample_normal(&dist, n))
            })
        });
    }
    group.finish();
}

criterion_group!(benches, bench_nsga2, bench_monte_carlo);
criterion_main!(benches);
