//
//  Generated code. Do not modify.
//  source: project/v1/project.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ProjectStatus extends $pb.ProtobufEnum {
  static const ProjectStatus PROJECT_STATUS_UNSPECIFIED = ProjectStatus._(0, _omitEnumNames ? '' : 'PROJECT_STATUS_UNSPECIFIED');
  static const ProjectStatus PROJECT_STATUS_DRAFT = ProjectStatus._(1, _omitEnumNames ? '' : 'PROJECT_STATUS_DRAFT');
  static const ProjectStatus PROJECT_STATUS_DESIGN = ProjectStatus._(2, _omitEnumNames ? '' : 'PROJECT_STATUS_DESIGN');
  static const ProjectStatus PROJECT_STATUS_SIMULATION = ProjectStatus._(3, _omitEnumNames ? '' : 'PROJECT_STATUS_SIMULATION');
  static const ProjectStatus PROJECT_STATUS_REVIEW = ProjectStatus._(4, _omitEnumNames ? '' : 'PROJECT_STATUS_REVIEW');
  static const ProjectStatus PROJECT_STATUS_APPROVED = ProjectStatus._(5, _omitEnumNames ? '' : 'PROJECT_STATUS_APPROVED');
  static const ProjectStatus PROJECT_STATUS_ARCHIVED = ProjectStatus._(6, _omitEnumNames ? '' : 'PROJECT_STATUS_ARCHIVED');

  static const $core.List<ProjectStatus> values = <ProjectStatus> [
    PROJECT_STATUS_UNSPECIFIED,
    PROJECT_STATUS_DRAFT,
    PROJECT_STATUS_DESIGN,
    PROJECT_STATUS_SIMULATION,
    PROJECT_STATUS_REVIEW,
    PROJECT_STATUS_APPROVED,
    PROJECT_STATUS_ARCHIVED,
  ];

  static final $core.Map<$core.int, ProjectStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ProjectStatus? valueOf($core.int value) => _byValue[value];

  const ProjectStatus._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
