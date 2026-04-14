use criterion::{black_box, criterion_group, criterion_main, Criterion, BenchmarkId};
use extended_compute::{FinancialAnalyzer, ClimateUncertaintyModel, TranspositionModel};

fn bench_financial_analysis(c: &mut Criterion) {
    let mut group = c.benchmark_group("financial_analysis");
    
    for size in [100, 500, 1000].iter() {
        group.bench_with_input(BenchmarkId::from_parameter(size), size, |b, &size| {
            let analyzer = FinancialAnalyzer::new();
            let irradiance_values = vec![500.0; size];
            let temperatures = vec![25.0; size];
            
            b.iter(|| {
                analyzer.analyze_project(
                    black_box(&irradiance_values),
                    black_box(&temperatures),
                    black_box(1000.0), // capacity_kw
                )
            });
        });
    }
    group.finish();
}

fn bench_climate_uncertainty(c: &mut Criterion) {
    let mut group = c.benchmark_group("climate_uncertainty");
    
    for size in [50, 200, 500].iter() {
        group.bench_with_input(BenchmarkId::from_parameter(size), size, |b, &size| {
            let model = ClimateUncertaintyModel::new(42); // Seeded for determinism
            let measurements = vec![10.0; size];
            
            b.iter(|| {
                model.compute_uncertainty(
                    black_box(&measurements),
                )
            });
        });
    }
    group.finish();
}

fn bench_solar_transposition(c: &mut Criterion) {
    let mut group = c.benchmark_group("solar_transposition");
    
    group.bench_function("transposition_fixed_poa", |b| {
        let model = TranspositionModel::new();
        let ghi = black_box(800.0);
        let zenith_angle = black_box(30.0);
        let azimuth = black_box(180.0);
        let surface_azimuth = black_box(180.0);
        let surface_tilt = black_box(30.0);
        
        b.iter(|| {
            model.compute_poa_irradiance(ghi, zenith_angle, azimuth, surface_azimuth, surface_tilt)
        });
    });
    
    group.finish();
}

criterion_group!(benches, bench_financial_analysis, bench_climate_uncertainty, bench_solar_transposition);
criterion_main!(benches);
