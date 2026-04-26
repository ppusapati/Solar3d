//
//  Generated code. Do not modify.
//  source: structural/v1/structural.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ReviewState extends $pb.ProtobufEnum {
  static const ReviewState REVIEW_STATE_UNSPECIFIED = ReviewState._(0, _omitEnumNames ? '' : 'REVIEW_STATE_UNSPECIFIED');
  static const ReviewState REVIEW_STATE_DRAFT = ReviewState._(1, _omitEnumNames ? '' : 'REVIEW_STATE_DRAFT');
  static const ReviewState REVIEW_STATE_SUBMITTED = ReviewState._(2, _omitEnumNames ? '' : 'REVIEW_STATE_SUBMITTED');
  static const ReviewState REVIEW_STATE_APPROVED = ReviewState._(3, _omitEnumNames ? '' : 'REVIEW_STATE_APPROVED');
  static const ReviewState REVIEW_STATE_REJECTED = ReviewState._(4, _omitEnumNames ? '' : 'REVIEW_STATE_REJECTED');

  static const $core.List<ReviewState> values = <ReviewState> [
    REVIEW_STATE_UNSPECIFIED,
    REVIEW_STATE_DRAFT,
    REVIEW_STATE_SUBMITTED,
    REVIEW_STATE_APPROVED,
    REVIEW_STATE_REJECTED,
  ];

  static final $core.Map<$core.int, ReviewState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ReviewState? valueOf($core.int value) => _byValue[value];

  const ReviewState._(super.v, super.n);
}

class ExposureCategory extends $pb.ProtobufEnum {
  static const ExposureCategory EXPOSURE_CATEGORY_UNSPECIFIED = ExposureCategory._(0, _omitEnumNames ? '' : 'EXPOSURE_CATEGORY_UNSPECIFIED');
  static const ExposureCategory EXPOSURE_CATEGORY_B = ExposureCategory._(1, _omitEnumNames ? '' : 'EXPOSURE_CATEGORY_B');
  static const ExposureCategory EXPOSURE_CATEGORY_C = ExposureCategory._(2, _omitEnumNames ? '' : 'EXPOSURE_CATEGORY_C');
  static const ExposureCategory EXPOSURE_CATEGORY_D = ExposureCategory._(3, _omitEnumNames ? '' : 'EXPOSURE_CATEGORY_D');

  static const $core.List<ExposureCategory> values = <ExposureCategory> [
    EXPOSURE_CATEGORY_UNSPECIFIED,
    EXPOSURE_CATEGORY_B,
    EXPOSURE_CATEGORY_C,
    EXPOSURE_CATEGORY_D,
  ];

  static final $core.Map<$core.int, ExposureCategory> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ExposureCategory? valueOf($core.int value) => _byValue[value];

  const ExposureCategory._(super.v, super.n);
}

class FoundationType extends $pb.ProtobufEnum {
  static const FoundationType FOUNDATION_TYPE_UNSPECIFIED = FoundationType._(0, _omitEnumNames ? '' : 'FOUNDATION_TYPE_UNSPECIFIED');
  static const FoundationType FOUNDATION_TYPE_DRIVEN_PILE = FoundationType._(1, _omitEnumNames ? '' : 'FOUNDATION_TYPE_DRIVEN_PILE');
  static const FoundationType FOUNDATION_TYPE_CONCRETE_PILE = FoundationType._(2, _omitEnumNames ? '' : 'FOUNDATION_TYPE_CONCRETE_PILE');
  static const FoundationType FOUNDATION_TYPE_BALLAST = FoundationType._(3, _omitEnumNames ? '' : 'FOUNDATION_TYPE_BALLAST');
  static const FoundationType FOUNDATION_TYPE_SCREW_PILE = FoundationType._(4, _omitEnumNames ? '' : 'FOUNDATION_TYPE_SCREW_PILE');

  static const $core.List<FoundationType> values = <FoundationType> [
    FOUNDATION_TYPE_UNSPECIFIED,
    FOUNDATION_TYPE_DRIVEN_PILE,
    FOUNDATION_TYPE_CONCRETE_PILE,
    FOUNDATION_TYPE_BALLAST,
    FOUNDATION_TYPE_SCREW_PILE,
  ];

  static final $core.Map<$core.int, FoundationType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static FoundationType? valueOf($core.int value) => _byValue[value];

  const FoundationType._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
