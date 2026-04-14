use criterion::{black_box, criterion_group, criterion_main, Criterion, BenchmarkId};
use solar_compute::{SunPosition, ShadowProjection, IrradianceCalculator};

fn bench_sun_position(c: &mut Criterion) {
    let mut group = c.benchmark_group("sun_position");
    
    group.bench_function("calculate_fixed_location", |b| {
        let sun_pos = SunPosition::new();
        let timestamp_seconds = black_box(1672531200.0);
        let latitude = black_box(40.7128);
        let longitude = black_box(-74.0060);
        
        b.iter(|| {
            sun_pos.calculate_solar_position(timestamp_seconds, latitude, longitude)
        });
    });
    
    group.bench_function("batch_calculations", |b| {
        let sun_pos = SunPosition::new();
        let latitude = black_box(40.7128);
        let longitude = black_box(-74.0060);
        
        b.iter(|| {
            for hour in 0..24 {
                let timestamp = 1672531200.0 + (hour as f64 * 3600.0);
                let _ = sun_pos.calculate_solar_position(timestamp, latitude, longitude);
            }
        });
    });
    
    group.finish();
}

fn bench_shadow_projection(c: &mut Criterion) {
    let mut group = c.benchmark_group("shadow_projection");
    
    for size in [10, 50, 100].iter() {
        group.bench_with_input(BenchmarkId::new("project_shadow", size), size, |b, &size| {
            let projector = ShadowProjection::new();
            let elevation_angle = black_box(45.0);
            let azimuth_angle = black_box(180.0);
            let object_height = black_box(10.0);
            
            let mut obstacles = Vec::new();
            for i in 0..size {
                obstacles.push((i as f64 * 2.0, i as f64 * 2.0, 5.0));
            }
            
            b.iter(|| {
                projector.cast_shadows(
                    black_box(&obstacles),
                    black_box(elevation_angle),
                    black_box(azimuth_angle),
                    black_box(object_height),
                )
            });
        });
    }
    
    group.finish();
}

fn bench_irradiance_calculation(c: &mut Criterion) {
    let mut group = c.benchmark_group("irradiance_calculation");
    
    let calc = IrradianceCalculator::new();
    
    group.bench_function("direct_normal_irradiance", |b| {
        let air_mass = black_box(1.5);
        let zenith_angle = black_box(30.0);
        
        b.iter(|| {
            calc.calculate_dni(air_mass, zenith_angle)
        });
    });
    
    group.bench_function("diffuse_horizontal_irradiance", |b| {
        let zenith_angle = black_box(30.0);
        let clearness_index = black_box(0.75);
        
        b.iter(|| {
            calc.calculate_dhi(zenith_angle, clearness_index)
        });
    });
    
    // Batch calculation (realistic use case)
    group.bench_function("batch_hourly_irradiance", |b| {
        b.iter(|| {
            let mut irradiances = Vec::new();
            for hour in 0..24 {
                let zenith = 40.0 + (hour as f64 * 5.0);
                let dhi = calc.calculate_dhi(zenith, 0.75);
                irradiances.push(dhi);
            }
            black_box(irradiances)
        });
    });
    
    group.finish();
}

criterion_group!(benches, bench_sun_position, bench_shadow_projection, bench_irradiance_calculation);
criterion_main!(benches);
