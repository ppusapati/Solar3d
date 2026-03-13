import 'package:equatable/equatable.dart';

class Simulation extends Equatable {
  final String id;
  final String projectId;
  final String layoutId;
  final String name;
  final String simulationType;
  final String status;
  final SimulationParams params;
  final SimulationResult? result;
  final DateTime createdAt;
  final DateTime? completedAt;

  const Simulation({
    required this.id,
    required this.projectId,
    required this.layoutId,
    required this.name,
    required this.simulationType,
    required this.status,
    required this.params,
    this.result,
    required this.createdAt,
    this.completedAt,
  });

  factory Simulation.fromJson(Map<String, dynamic> json) {
    return Simulation(
      id: json['id'] as String,
      projectId: json['project_id'] as String,
      layoutId: json['layout_id'] as String,
      name: json['name'] as String,
      simulationType: json['simulation_type'] as String,
      status: json['status'] as String,
      params:
          SimulationParams.fromJson(json['params'] as Map<String, dynamic>),
      result: json['result'] != null
          ? SimulationResult.fromJson(json['result'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  bool get isCompleted => status == 'COMPLETED';
  bool get isRunning => status == 'RUNNING';
  bool get isPending => status == 'PENDING';
  bool get isFailed => status == 'FAILED';

  @override
  List<Object?> get props => [id, status, simulationType];
}

class SimulationParams extends Equatable {
  final String startTime;
  final String endTime;
  final int timeStepMinutes;
  final double latitude;
  final double longitude;
  final bool includeTerrainShading;
  final bool includePanelShading;

  const SimulationParams({
    required this.startTime,
    required this.endTime,
    this.timeStepMinutes = 60,
    required this.latitude,
    required this.longitude,
    this.includeTerrainShading = true,
    this.includePanelShading = true,
  });

  factory SimulationParams.fromJson(Map<String, dynamic> json) {
    return SimulationParams(
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      timeStepMinutes: json['time_step_minutes'] as int? ?? 60,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      includeTerrainShading: json['include_terrain_shading'] as bool? ?? true,
      includePanelShading: json['include_panel_shading'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'start_time': startTime,
        'end_time': endTime,
        'time_step_minutes': timeStepMinutes,
        'latitude': latitude,
        'longitude': longitude,
        'include_terrain_shading': includeTerrainShading,
        'include_panel_shading': includePanelShading,
      };

  @override
  List<Object?> get props => [startTime, endTime, latitude, longitude];
}

class SimulationResult extends Equatable {
  final double totalIrradianceKwhM2;
  final double annualYieldKwh;
  final double performanceRatio;
  final double shadingLossPercent;
  final String? resultFilePath;

  const SimulationResult({
    required this.totalIrradianceKwhM2,
    required this.annualYieldKwh,
    required this.performanceRatio,
    required this.shadingLossPercent,
    this.resultFilePath,
  });

  factory SimulationResult.fromJson(Map<String, dynamic> json) {
    return SimulationResult(
      totalIrradianceKwhM2:
          (json['total_irradiance_kwh_m2'] as num).toDouble(),
      annualYieldKwh: (json['annual_yield_kwh'] as num).toDouble(),
      performanceRatio: (json['performance_ratio'] as num).toDouble(),
      shadingLossPercent: (json['shading_loss_percent'] as num).toDouble(),
      resultFilePath: json['result_file_path'] as String?,
    );
  }

  @override
  List<Object?> get props =>
      [totalIrradianceKwhM2, annualYieldKwh, performanceRatio];
}

class SunPosition extends Equatable {
  final double azimuth;
  final double elevation;
  final double zenith;
  final double hourAngle;

  const SunPosition({
    required this.azimuth,
    required this.elevation,
    required this.zenith,
    required this.hourAngle,
  });

  factory SunPosition.fromJson(Map<String, dynamic> json) {
    return SunPosition(
      azimuth: (json['azimuth'] as num).toDouble(),
      elevation: (json['elevation'] as num).toDouble(),
      zenith: (json['zenith'] as num).toDouble(),
      hourAngle: (json['hour_angle'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [azimuth, elevation];
}
