//
//  Generated code. Do not modify.
//  source: ml_inference/v1/features.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../common/v1/primitives.pb.dart' as $0;
import '../../google/protobuf/timestamp.pb.dart' as $1;
import 'features.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'features.pbenum.dart';

class FeatureSpec extends $pb.GeneratedMessage {
  factory FeatureSpec({
    $core.String? name,
    FeatureDataType? dataType,
    $core.bool? required,
    $core.String? unit,
    $0.NumericRange? expectedRange,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (dataType != null) {
      $result.dataType = dataType;
    }
    if (required != null) {
      $result.required = required;
    }
    if (unit != null) {
      $result.unit = unit;
    }
    if (expectedRange != null) {
      $result.expectedRange = expectedRange;
    }
    return $result;
  }
  FeatureSpec._() : super();
  factory FeatureSpec.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FeatureSpec.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FeatureSpec', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..e<FeatureDataType>(2, _omitFieldNames ? '' : 'dataType', $pb.PbFieldType.OE, defaultOrMaker: FeatureDataType.FEATURE_DATA_TYPE_UNSPECIFIED, valueOf: FeatureDataType.valueOf, enumValues: FeatureDataType.values)
    ..aOB(3, _omitFieldNames ? '' : 'required')
    ..aOS(4, _omitFieldNames ? '' : 'unit')
    ..aOM<$0.NumericRange>(5, _omitFieldNames ? '' : 'expectedRange', subBuilder: $0.NumericRange.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FeatureSpec clone() => FeatureSpec()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FeatureSpec copyWith(void Function(FeatureSpec) updates) => super.copyWith((message) => updates(message as FeatureSpec)) as FeatureSpec;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FeatureSpec create() => FeatureSpec._();
  FeatureSpec createEmptyInstance() => create();
  static $pb.PbList<FeatureSpec> createRepeated() => $pb.PbList<FeatureSpec>();
  @$core.pragma('dart2js:noInline')
  static FeatureSpec getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FeatureSpec>(create);
  static FeatureSpec? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  FeatureDataType get dataType => $_getN(1);
  @$pb.TagNumber(2)
  set dataType(FeatureDataType v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasDataType() => $_has(1);
  @$pb.TagNumber(2)
  void clearDataType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get required => $_getBF(2);
  @$pb.TagNumber(3)
  set required($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRequired() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequired() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get unit => $_getSZ(3);
  @$pb.TagNumber(4)
  set unit($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasUnit() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnit() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.NumericRange get expectedRange => $_getN(4);
  @$pb.TagNumber(5)
  set expectedRange($0.NumericRange v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasExpectedRange() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpectedRange() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.NumericRange ensureExpectedRange() => $_ensure(4);
}

class FeatureSchema extends $pb.GeneratedMessage {
  factory FeatureSchema({
    $core.String? schemaId,
    $core.String? schemaHash,
    $core.String? taskType,
    $core.Iterable<FeatureSpec>? features,
    $1.Timestamp? createdAt,
    $0.ContractMetadata? contract,
  }) {
    final $result = create();
    if (schemaId != null) {
      $result.schemaId = schemaId;
    }
    if (schemaHash != null) {
      $result.schemaHash = schemaHash;
    }
    if (taskType != null) {
      $result.taskType = taskType;
    }
    if (features != null) {
      $result.features.addAll(features);
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (contract != null) {
      $result.contract = contract;
    }
    return $result;
  }
  FeatureSchema._() : super();
  factory FeatureSchema.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FeatureSchema.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FeatureSchema', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'schemaId')
    ..aOS(2, _omitFieldNames ? '' : 'schemaHash')
    ..aOS(3, _omitFieldNames ? '' : 'taskType')
    ..pc<FeatureSpec>(4, _omitFieldNames ? '' : 'features', $pb.PbFieldType.PM, subBuilder: FeatureSpec.create)
    ..aOM<$1.Timestamp>(5, _omitFieldNames ? '' : 'createdAt', subBuilder: $1.Timestamp.create)
    ..aOM<$0.ContractMetadata>(6, _omitFieldNames ? '' : 'contract', subBuilder: $0.ContractMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FeatureSchema clone() => FeatureSchema()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FeatureSchema copyWith(void Function(FeatureSchema) updates) => super.copyWith((message) => updates(message as FeatureSchema)) as FeatureSchema;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FeatureSchema create() => FeatureSchema._();
  FeatureSchema createEmptyInstance() => create();
  static $pb.PbList<FeatureSchema> createRepeated() => $pb.PbList<FeatureSchema>();
  @$core.pragma('dart2js:noInline')
  static FeatureSchema getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FeatureSchema>(create);
  static FeatureSchema? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get schemaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set schemaId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSchemaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSchemaId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get schemaHash => $_getSZ(1);
  @$pb.TagNumber(2)
  set schemaHash($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSchemaHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearSchemaHash() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get taskType => $_getSZ(2);
  @$pb.TagNumber(3)
  set taskType($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTaskType() => $_has(2);
  @$pb.TagNumber(3)
  void clearTaskType() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<FeatureSpec> get features => $_getList(3);

  @$pb.TagNumber(5)
  $1.Timestamp get createdAt => $_getN(4);
  @$pb.TagNumber(5)
  set createdAt($1.Timestamp v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasCreatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Timestamp ensureCreatedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.ContractMetadata get contract => $_getN(5);
  @$pb.TagNumber(6)
  set contract($0.ContractMetadata v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasContract() => $_has(5);
  @$pb.TagNumber(6)
  void clearContract() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.ContractMetadata ensureContract() => $_ensure(5);
}

enum FeatureValue_Value {
  doubleValue, 
  int64Value, 
  boolValue, 
  stringValue, 
  notSet
}

class FeatureValue extends $pb.GeneratedMessage {
  factory FeatureValue({
    $core.String? name,
    $core.double? doubleValue,
    $fixnum.Int64? int64Value,
    $core.bool? boolValue,
    $core.String? stringValue,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (doubleValue != null) {
      $result.doubleValue = doubleValue;
    }
    if (int64Value != null) {
      $result.int64Value = int64Value;
    }
    if (boolValue != null) {
      $result.boolValue = boolValue;
    }
    if (stringValue != null) {
      $result.stringValue = stringValue;
    }
    return $result;
  }
  FeatureValue._() : super();
  factory FeatureValue.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FeatureValue.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, FeatureValue_Value> _FeatureValue_ValueByTag = {
    2 : FeatureValue_Value.doubleValue,
    3 : FeatureValue_Value.int64Value,
    4 : FeatureValue_Value.boolValue,
    5 : FeatureValue_Value.stringValue,
    0 : FeatureValue_Value.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FeatureValue', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5])
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'doubleValue', $pb.PbFieldType.OD)
    ..aInt64(3, _omitFieldNames ? '' : 'int64Value')
    ..aOB(4, _omitFieldNames ? '' : 'boolValue')
    ..aOS(5, _omitFieldNames ? '' : 'stringValue')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FeatureValue clone() => FeatureValue()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FeatureValue copyWith(void Function(FeatureValue) updates) => super.copyWith((message) => updates(message as FeatureValue)) as FeatureValue;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FeatureValue create() => FeatureValue._();
  FeatureValue createEmptyInstance() => create();
  static $pb.PbList<FeatureValue> createRepeated() => $pb.PbList<FeatureValue>();
  @$core.pragma('dart2js:noInline')
  static FeatureValue getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FeatureValue>(create);
  static FeatureValue? _defaultInstance;

  FeatureValue_Value whichValue() => _FeatureValue_ValueByTag[$_whichOneof(0)]!;
  void clearValue() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get doubleValue => $_getN(1);
  @$pb.TagNumber(2)
  set doubleValue($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDoubleValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearDoubleValue() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get int64Value => $_getI64(2);
  @$pb.TagNumber(3)
  set int64Value($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasInt64Value() => $_has(2);
  @$pb.TagNumber(3)
  void clearInt64Value() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get boolValue => $_getBF(3);
  @$pb.TagNumber(4)
  set boolValue($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBoolValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearBoolValue() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get stringValue => $_getSZ(4);
  @$pb.TagNumber(5)
  set stringValue($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasStringValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearStringValue() => $_clearField(5);
}

class FeaturePayload extends $pb.GeneratedMessage {
  factory FeaturePayload({
    $core.String? payloadId,
    $core.String? taskType,
    FeatureSchema? schema,
    $core.Iterable<FeatureValue>? values,
    $1.Timestamp? observedAt,
    $core.String? siteId,
  }) {
    final $result = create();
    if (payloadId != null) {
      $result.payloadId = payloadId;
    }
    if (taskType != null) {
      $result.taskType = taskType;
    }
    if (schema != null) {
      $result.schema = schema;
    }
    if (values != null) {
      $result.values.addAll(values);
    }
    if (observedAt != null) {
      $result.observedAt = observedAt;
    }
    if (siteId != null) {
      $result.siteId = siteId;
    }
    return $result;
  }
  FeaturePayload._() : super();
  factory FeaturePayload.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FeaturePayload.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FeaturePayload', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'payloadId')
    ..aOS(2, _omitFieldNames ? '' : 'taskType')
    ..aOM<FeatureSchema>(3, _omitFieldNames ? '' : 'schema', subBuilder: FeatureSchema.create)
    ..pc<FeatureValue>(4, _omitFieldNames ? '' : 'values', $pb.PbFieldType.PM, subBuilder: FeatureValue.create)
    ..aOM<$1.Timestamp>(5, _omitFieldNames ? '' : 'observedAt', subBuilder: $1.Timestamp.create)
    ..aOS(6, _omitFieldNames ? '' : 'siteId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FeaturePayload clone() => FeaturePayload()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FeaturePayload copyWith(void Function(FeaturePayload) updates) => super.copyWith((message) => updates(message as FeaturePayload)) as FeaturePayload;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FeaturePayload create() => FeaturePayload._();
  FeaturePayload createEmptyInstance() => create();
  static $pb.PbList<FeaturePayload> createRepeated() => $pb.PbList<FeaturePayload>();
  @$core.pragma('dart2js:noInline')
  static FeaturePayload getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FeaturePayload>(create);
  static FeaturePayload? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get payloadId => $_getSZ(0);
  @$pb.TagNumber(1)
  set payloadId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPayloadId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayloadId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get taskType => $_getSZ(1);
  @$pb.TagNumber(2)
  set taskType($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTaskType() => $_has(1);
  @$pb.TagNumber(2)
  void clearTaskType() => $_clearField(2);

  @$pb.TagNumber(3)
  FeatureSchema get schema => $_getN(2);
  @$pb.TagNumber(3)
  set schema(FeatureSchema v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSchema() => $_has(2);
  @$pb.TagNumber(3)
  void clearSchema() => $_clearField(3);
  @$pb.TagNumber(3)
  FeatureSchema ensureSchema() => $_ensure(2);

  @$pb.TagNumber(4)
  $pb.PbList<FeatureValue> get values => $_getList(3);

  @$pb.TagNumber(5)
  $1.Timestamp get observedAt => $_getN(4);
  @$pb.TagNumber(5)
  set observedAt($1.Timestamp v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasObservedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearObservedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Timestamp ensureObservedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get siteId => $_getSZ(5);
  @$pb.TagNumber(6)
  set siteId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSiteId() => $_has(5);
  @$pb.TagNumber(6)
  void clearSiteId() => $_clearField(6);
}

class LabeledFeatureSample extends $pb.GeneratedMessage {
  factory LabeledFeatureSample({
    $core.String? sampleId,
    FeaturePayload? payload,
    $core.double? label,
    $core.String? labelSource,
    $1.Timestamp? labeledAt,
  }) {
    final $result = create();
    if (sampleId != null) {
      $result.sampleId = sampleId;
    }
    if (payload != null) {
      $result.payload = payload;
    }
    if (label != null) {
      $result.label = label;
    }
    if (labelSource != null) {
      $result.labelSource = labelSource;
    }
    if (labeledAt != null) {
      $result.labeledAt = labeledAt;
    }
    return $result;
  }
  LabeledFeatureSample._() : super();
  factory LabeledFeatureSample.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LabeledFeatureSample.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LabeledFeatureSample', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sampleId')
    ..aOM<FeaturePayload>(2, _omitFieldNames ? '' : 'payload', subBuilder: FeaturePayload.create)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'label', $pb.PbFieldType.OD)
    ..aOS(4, _omitFieldNames ? '' : 'labelSource')
    ..aOM<$1.Timestamp>(5, _omitFieldNames ? '' : 'labeledAt', subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LabeledFeatureSample clone() => LabeledFeatureSample()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LabeledFeatureSample copyWith(void Function(LabeledFeatureSample) updates) => super.copyWith((message) => updates(message as LabeledFeatureSample)) as LabeledFeatureSample;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LabeledFeatureSample create() => LabeledFeatureSample._();
  LabeledFeatureSample createEmptyInstance() => create();
  static $pb.PbList<LabeledFeatureSample> createRepeated() => $pb.PbList<LabeledFeatureSample>();
  @$core.pragma('dart2js:noInline')
  static LabeledFeatureSample getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LabeledFeatureSample>(create);
  static LabeledFeatureSample? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sampleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sampleId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSampleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleId() => $_clearField(1);

  @$pb.TagNumber(2)
  FeaturePayload get payload => $_getN(1);
  @$pb.TagNumber(2)
  set payload(FeaturePayload v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPayload() => $_has(1);
  @$pb.TagNumber(2)
  void clearPayload() => $_clearField(2);
  @$pb.TagNumber(2)
  FeaturePayload ensurePayload() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.double get label => $_getN(2);
  @$pb.TagNumber(3)
  set label($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLabel() => $_has(2);
  @$pb.TagNumber(3)
  void clearLabel() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get labelSource => $_getSZ(3);
  @$pb.TagNumber(4)
  set labelSource($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasLabelSource() => $_has(3);
  @$pb.TagNumber(4)
  void clearLabelSource() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.Timestamp get labeledAt => $_getN(4);
  @$pb.TagNumber(5)
  set labeledAt($1.Timestamp v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasLabeledAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearLabeledAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Timestamp ensureLabeledAt() => $_ensure(4);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
