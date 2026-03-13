import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String status;
  final double? targetCapacityMw;
  final String? locationName;
  final String? clientName;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Project({
    required this.id,
    required this.name,
    this.description,
    required this.status,
    this.targetCapacityMw,
    this.locationName,
    this.clientName,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'DRAFT',
      targetCapacityMw: (json['target_capacity_mw'] as num?)?.toDouble(),
      locationName: json['location_name'] as String?,
      clientName: json['client_name'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'status': status,
        'target_capacity_mw': targetCapacityMw,
        'location_name': locationName,
        'client_name': clientName,
        'notes': notes,
      };

  Project copyWith({
    String? name,
    String? description,
    String? status,
    double? targetCapacityMw,
    String? locationName,
    String? clientName,
    String? notes,
  }) {
    return Project(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      targetCapacityMw: targetCapacityMw ?? this.targetCapacityMw,
      locationName: locationName ?? this.locationName,
      clientName: clientName ?? this.clientName,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, status, updatedAt];
}

class CreateProjectRequest {
  final String name;
  final String? description;
  final double? targetCapacityMw;
  final String? locationName;
  final String? clientName;

  const CreateProjectRequest({
    required this.name,
    this.description,
    this.targetCapacityMw,
    this.locationName,
    this.clientName,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (description != null) 'description': description,
        if (targetCapacityMw != null) 'target_capacity_mw': targetCapacityMw,
        if (locationName != null) 'location_name': locationName,
        if (clientName != null) 'client_name': clientName,
      };
}
