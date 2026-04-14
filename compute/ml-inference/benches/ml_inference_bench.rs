use criterion::{black_box, criterion_group, criterion_main, Criterion, BenchmarkId};
use ml_inference::{
    RegistryService, FeatureSchema, YieldForecaster, AnomalyDetector, DegradationForecaster,
    pure_registry_ops,
};
use std::collections::HashMap;

fn bench_registry_operations(c: &mut Criterion) {
    let mut group = c.benchmark_group("registry_operations");
    
    // Benchmark schema validation (pure operation)
    group.bench_function("validate_schema", |b| {
        let schema = FeatureSchema {
            hash: "h1".to_string(),
            version: 1,
            feature_names: vec!["f1".to_string(), "f2".to_string(), "f3".to_string()],
            feature_dtypes: vec!["f64".to_string(), "f64".to_string(), "f64".to_string()],
            normalization_params: None,
        };
        
        b.iter(|| {
            pure_registry_ops::validate_schema(black_box(&schema))
        });
    });
    
    // Benchmark feature validation with different feature counts
    for size in [10, 100, 1000].iter() {
        group.bench_with_input(BenchmarkId::new("validate_features", size), size, |b, &size| {
            let feature_names: Vec<_> = (0..size).map(|i| format!("f{}", i)).collect();
            let feature_dtypes = vec!["f64".to_string(); size];
            let schema = FeatureSchema {
                hash: "h1".to_string(),
                version: 1,
                feature_names: feature_names.clone(),
                feature_dtypes,
                normalization_params: None,
            };
            let features = vec![25.0; size];
            
            b.iter(|| {
                pure_registry_ops::validate_features(
                    black_box(&schema),
                    black_box(&features),
                )
            });
        });
    }
    
    group.finish();
}

fn bench_feature_normalization(c: &mut Criterion) {
    let mut group = c.benchmark_group("feature_normalization");
    
    for size in [10, 50, 100].iter() {
        group.bench_with_input(BenchmarkId::new("normalize_features", size), size, |b, &size| {
            let feature_names: Vec<_> = (0..size).map(|i| format!("f{}", i)).collect();
            let mut params = HashMap::new();
            for i in 0..size {
                params.insert(format!("f{}_mean", i), 20.0 + i as f64);
                params.insert(format!("f{}_std", i), 5.0);
            }
            
            let schema = FeatureSchema {
                hash: "h1".to_string(),
                version: 1,
                feature_names,
                feature_dtypes: vec!["f64".to_string(); size],
                normalization_params: Some(params),
            };
            
            let features = vec![25.0; size];
            
            b.iter(|| {
                pure_registry_ops::normalize_features(
                    black_box(&features),
                    black_box(&schema),
                )
            });
        });
    }
    
    group.finish();
}

fn bench_yield_forecasting(c: &mut Criterion) {
    let mut group = c.benchmark_group("yield_forecasting");
    
    group.bench_function("forecast_yield", |b| {
        let forecaster = YieldForecaster::new();
        let features = black_box(vec![
            100.0, 25.0, 15.0, 0.8, 500.0, 200.0, 1.1, 0.95
        ]);
        
        b.iter(|| {
            forecaster.forecast(features.clone())
        });
    });
    
    group.finish();
}

fn bench_anomaly_detection(c: &mut Criterion) {
    let mut group = c.benchmark_group("anomaly_detection");
    
    group.bench_function("detect_anomaly", |b| {
        let detector = AnomalyDetector::new();
        let features = black_box(vec![
            100.0, 25.0, 15.0, 0.8, 500.0
        ]);
        
        b.iter(|| {
            detector.detect(features.clone())
        });
    });
    
    group.finish();
}

fn bench_degradation_forecasting(c: &mut Criterion) {
    let mut group = c.benchmark_group("degradation_forecasting");
    
    group.bench_function("forecast_degradation", |b| {
        let forecaster = DegradationForecaster::new();
        let historical_efficiency = black_box(vec![0.95, 0.945, 0.94, 0.935, 0.93]);
        
        b.iter(|| {
            forecaster.forecast_rul(historical_efficiency.clone())
        });
    });
    
    group.finish();
}

criterion_group!(
    benches,
    bench_registry_operations,
    bench_feature_normalization,
    bench_yield_forecasting,
    bench_anomaly_detection,
    bench_degradation_forecasting
);
criterion_main!(benches);
