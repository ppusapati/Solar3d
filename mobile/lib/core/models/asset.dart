import 'package:equatable/equatable.dart';

class Asset extends Equatable {
  final String id;
  final String name;
  final String category;
  final String? manufacturer;
  final String? model;
  final Dimensions? dimensions;
  final ElectricalParameters? electricalParams;
  final DateTime createdAt;

  const Asset({
    required this.id,
    required this.name,
    required this.category,
    this.manufacturer,
    this.model,
    this.dimensions,
    this.electricalParams,
    required this.createdAt,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      manufacturer: json['manufacturer'] as String?,
      model: json['model'] as String?,
      dimensions: json['dimensions'] != null
          ? Dimensions.fromJson(json['dimensions'] as Map<String, dynamic>)
          : null,
      electricalParams: json['electrical_parameters'] != null
          ? ElectricalParameters.fromJson(
              json['electrical_parameters'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'category': category,
        if (manufacturer != null) 'manufacturer': manufacturer,
        if (model != null) 'model': model,
        if (dimensions != null) 'dimensions': dimensions!.toJson(),
        if (electricalParams != null)
          'electrical_parameters': electricalParams!.toJson(),
      };

  @override
  List<Object?> get props => [id, name, category];
}

class Dimensions extends Equatable {
  final double lengthM;
  final double widthM;
  final double? heightM;
  final double? weightKg;

  const Dimensions({
    required this.lengthM,
    required this.widthM,
    this.heightM,
    this.weightKg,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      lengthM: (json['length_m'] as num).toDouble(),
      widthM: (json['width_m'] as num).toDouble(),
      heightM: (json['height_m'] as num?)?.toDouble(),
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'length_m': lengthM,
        'width_m': widthM,
        if (heightM != null) 'height_m': heightM,
        if (weightKg != null) 'weight_kg': weightKg,
      };

  @override
  List<Object?> get props => [lengthM, widthM];
}

class ElectricalParameters extends Equatable {
  final double? ratedPowerW;
  final double? voltageV;
  final double? currentA;
  final double? efficiencyPercent;

  const ElectricalParameters({
    this.ratedPowerW,
    this.voltageV,
    this.currentA,
    this.efficiencyPercent,
  });

  factory ElectricalParameters.fromJson(Map<String, dynamic> json) {
    return ElectricalParameters(
      ratedPowerW: (json['rated_power_w'] as num?)?.toDouble(),
      voltageV: (json['voltage_v'] as num?)?.toDouble(),
      currentA: (json['current_a'] as num?)?.toDouble(),
      efficiencyPercent: (json['efficiency_percent'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (ratedPowerW != null) 'rated_power_w': ratedPowerW,
        if (voltageV != null) 'voltage_v': voltageV,
        if (currentA != null) 'current_a': currentA,
        if (efficiencyPercent != null)
          'efficiency_percent': efficiencyPercent,
      };

  @override
  List<Object?> get props => [ratedPowerW, voltageV];
}
