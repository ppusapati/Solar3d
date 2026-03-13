import 'package:equatable/equatable.dart';

class Report extends Equatable {
  final String id;
  final String projectId;
  final String name;
  final String reportType;
  final String format;
  final String status;
  final String? filePath;
  final DateTime createdAt;
  final DateTime? completedAt;

  const Report({
    required this.id,
    required this.projectId,
    required this.name,
    required this.reportType,
    required this.format,
    required this.status,
    this.filePath,
    required this.createdAt,
    this.completedAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as String,
      projectId: json['project_id'] as String,
      name: json['name'] as String,
      reportType: json['report_type'] as String,
      format: json['format'] as String,
      status: json['status'] as String,
      filePath: json['file_path'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  bool get isCompleted => status == 'COMPLETED';
  bool get isGenerating => status == 'GENERATING';

  @override
  List<Object?> get props => [id, reportType, status];
}

class BOMItem extends Equatable {
  final String name;
  final String category;
  final int quantity;
  final String? unit;
  final double? unitCost;
  final double? totalCost;

  const BOMItem({
    required this.name,
    required this.category,
    required this.quantity,
    this.unit,
    this.unitCost,
    this.totalCost,
  });

  factory BOMItem.fromJson(Map<String, dynamic> json) {
    return BOMItem(
      name: json['name'] as String,
      category: json['category'] as String,
      quantity: json['quantity'] as int,
      unit: json['unit'] as String?,
      unitCost: (json['unit_cost'] as num?)?.toDouble(),
      totalCost: (json['total_cost'] as num?)?.toDouble(),
    );
  }

  @override
  List<Object?> get props => [name, category, quantity];
}

class BillOfMaterials extends Equatable {
  final List<BOMItem> items;
  final double totalCost;

  const BillOfMaterials({
    required this.items,
    required this.totalCost,
  });

  factory BillOfMaterials.fromJson(Map<String, dynamic> json) {
    return BillOfMaterials(
      items: (json['items'] as List<dynamic>)
          .map((e) => BOMItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCost: (json['total_cost'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [items.length, totalCost];
}
