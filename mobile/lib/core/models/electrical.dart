import 'package:equatable/equatable.dart';

class ElectricalNetwork extends Equatable {
  final String id;
  final String projectId;
  final String layoutId;
  final String name;
  final double totalDcCapacityKw;
  final double totalAcCapacityKw;
  final double dcAcRatio;
  final int totalStrings;
  final int totalInverters;
  final DateTime createdAt;

  const ElectricalNetwork({
    required this.id,
    required this.projectId,
    required this.layoutId,
    required this.name,
    required this.totalDcCapacityKw,
    required this.totalAcCapacityKw,
    required this.dcAcRatio,
    required this.totalStrings,
    required this.totalInverters,
    required this.createdAt,
  });

  factory ElectricalNetwork.fromJson(Map<String, dynamic> json) {
    return ElectricalNetwork(
      id: json['id'] as String,
      projectId: json['project_id'] as String,
      layoutId: json['layout_id'] as String,
      name: json['name'] as String,
      totalDcCapacityKw:
          (json['total_dc_capacity_kw'] as num?)?.toDouble() ?? 0,
      totalAcCapacityKw:
          (json['total_ac_capacity_kw'] as num?)?.toDouble() ?? 0,
      dcAcRatio: (json['dc_ac_ratio'] as num?)?.toDouble() ?? 0,
      totalStrings: json['total_strings'] as int? ?? 0,
      totalInverters: json['total_inverters'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  @override
  List<Object?> get props => [id, projectId, name];
}

class PanelString extends Equatable {
  final String id;
  final String networkId;
  final String? inverterGroupId;
  final String name;
  final int panelCount;
  final double voltageV;
  final double currentA;
  final double powerW;

  const PanelString({
    required this.id,
    required this.networkId,
    this.inverterGroupId,
    required this.name,
    required this.panelCount,
    required this.voltageV,
    required this.currentA,
    required this.powerW,
  });

  factory PanelString.fromJson(Map<String, dynamic> json) {
    return PanelString(
      id: json['id'] as String,
      networkId: json['network_id'] as String,
      inverterGroupId: json['inverter_group_id'] as String?,
      name: json['name'] as String,
      panelCount: json['panel_count'] as int,
      voltageV: (json['voltage_v'] as num).toDouble(),
      currentA: (json['current_a'] as num).toDouble(),
      powerW: (json['power_w'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [id, networkId, name];
}

class LossBreakdown extends Equatable {
  final double soilingPercent;
  final double shadingPercent;
  final double mismatchPercent;
  final double wiringPercent;
  final double inverterPercent;
  final double transformerPercent;
  final double totalLossPercent;

  const LossBreakdown({
    required this.soilingPercent,
    required this.shadingPercent,
    required this.mismatchPercent,
    required this.wiringPercent,
    required this.inverterPercent,
    required this.transformerPercent,
    required this.totalLossPercent,
  });

  factory LossBreakdown.fromJson(Map<String, dynamic> json) {
    return LossBreakdown(
      soilingPercent: (json['soiling_percent'] as num).toDouble(),
      shadingPercent: (json['shading_percent'] as num).toDouble(),
      mismatchPercent: (json['mismatch_percent'] as num).toDouble(),
      wiringPercent: (json['wiring_percent'] as num).toDouble(),
      inverterPercent: (json['inverter_percent'] as num).toDouble(),
      transformerPercent: (json['transformer_percent'] as num).toDouble(),
      totalLossPercent: (json['total_loss_percent'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [totalLossPercent];
}
