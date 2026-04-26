//
//  Generated code. Do not modify.
//  source: protection/v1/protection.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/timestamp.pb.dart' as $0;
import 'protection.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'protection.pbenum.dart';

class ProtectionStudy extends $pb.GeneratedMessage {
  factory ProtectionStudy({
    $core.String? id,
    $core.String? projectId,
    $core.String? name,
    $core.double? systemVoltageKv,
    $core.double? sourceImpedancePu,
    $core.double? mvaBase,
    $0.Timestamp? createdAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (systemVoltageKv != null) {
      $result.systemVoltageKv = systemVoltageKv;
    }
    if (sourceImpedancePu != null) {
      $result.sourceImpedancePu = sourceImpedancePu;
    }
    if (mvaBase != null) {
      $result.mvaBase = mvaBase;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    return $result;
  }
  ProtectionStudy._() : super();
  factory ProtectionStudy.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProtectionStudy.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ProtectionStudy', package: const $pb.PackageName(_omitMessageNames ? '' : 'protection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'systemVoltageKv', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'sourceImpedancePu', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'mvaBase', $pb.PbFieldType.OD)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProtectionStudy clone() => ProtectionStudy()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProtectionStudy copyWith(void Function(ProtectionStudy) updates) => super.copyWith((message) => updates(message as ProtectionStudy)) as ProtectionStudy;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProtectionStudy create() => ProtectionStudy._();
  ProtectionStudy createEmptyInstance() => create();
  static $pb.PbList<ProtectionStudy> createRepeated() => $pb.PbList<ProtectionStudy>();
  @$core.pragma('dart2js:noInline')
  static ProtectionStudy getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProtectionStudy>(create);
  static ProtectionStudy? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get projectId => $_getSZ(1);
  @$pb.TagNumber(2)
  set projectId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProjectId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProjectId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get systemVoltageKv => $_getN(3);
  @$pb.TagNumber(4)
  set systemVoltageKv($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSystemVoltageKv() => $_has(3);
  @$pb.TagNumber(4)
  void clearSystemVoltageKv() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get sourceImpedancePu => $_getN(4);
  @$pb.TagNumber(5)
  set sourceImpedancePu($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSourceImpedancePu() => $_has(4);
  @$pb.TagNumber(5)
  void clearSourceImpedancePu() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get mvaBase => $_getN(5);
  @$pb.TagNumber(6)
  set mvaBase($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasMvaBase() => $_has(5);
  @$pb.TagNumber(6)
  void clearMvaBase() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get createdAt => $_getN(6);
  @$pb.TagNumber(7)
  set createdAt($0.Timestamp v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasCreatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureCreatedAt() => $_ensure(6);
}

class ComputeShortCircuitRequest extends $pb.GeneratedMessage {
  factory ComputeShortCircuitRequest({
    $core.String? studyId,
    $core.double? voltageKv,
    $core.double? sourceImpedanceOhm,
    $core.double? cableResistanceOhm,
    $core.double? cableReactanceOhm,
    $core.double? zeroSeqImpedanceOhm,
    $core.bool? includeSingleLineToGround,
  }) {
    final $result = create();
    if (studyId != null) {
      $result.studyId = studyId;
    }
    if (voltageKv != null) {
      $result.voltageKv = voltageKv;
    }
    if (sourceImpedanceOhm != null) {
      $result.sourceImpedanceOhm = sourceImpedanceOhm;
    }
    if (cableResistanceOhm != null) {
      $result.cableResistanceOhm = cableResistanceOhm;
    }
    if (cableReactanceOhm != null) {
      $result.cableReactanceOhm = cableReactanceOhm;
    }
    if (zeroSeqImpedanceOhm != null) {
      $result.zeroSeqImpedanceOhm = zeroSeqImpedanceOhm;
    }
    if (includeSingleLineToGround != null) {
      $result.includeSingleLineToGround = includeSingleLineToGround;
    }
    return $result;
  }
  ComputeShortCircuitRequest._() : super();
  factory ComputeShortCircuitRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ComputeShortCircuitRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ComputeShortCircuitRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'protection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'studyId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'voltageKv', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'sourceImpedanceOhm', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'cableResistanceOhm', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'cableReactanceOhm', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'zeroSeqImpedanceOhm', $pb.PbFieldType.OD)
    ..aOB(7, _omitFieldNames ? '' : 'includeSingleLineToGround')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ComputeShortCircuitRequest clone() => ComputeShortCircuitRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ComputeShortCircuitRequest copyWith(void Function(ComputeShortCircuitRequest) updates) => super.copyWith((message) => updates(message as ComputeShortCircuitRequest)) as ComputeShortCircuitRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComputeShortCircuitRequest create() => ComputeShortCircuitRequest._();
  ComputeShortCircuitRequest createEmptyInstance() => create();
  static $pb.PbList<ComputeShortCircuitRequest> createRepeated() => $pb.PbList<ComputeShortCircuitRequest>();
  @$core.pragma('dart2js:noInline')
  static ComputeShortCircuitRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ComputeShortCircuitRequest>(create);
  static ComputeShortCircuitRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get studyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set studyId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStudyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStudyId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get voltageKv => $_getN(1);
  @$pb.TagNumber(2)
  set voltageKv($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasVoltageKv() => $_has(1);
  @$pb.TagNumber(2)
  void clearVoltageKv() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get sourceImpedanceOhm => $_getN(2);
  @$pb.TagNumber(3)
  set sourceImpedanceOhm($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSourceImpedanceOhm() => $_has(2);
  @$pb.TagNumber(3)
  void clearSourceImpedanceOhm() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get cableResistanceOhm => $_getN(3);
  @$pb.TagNumber(4)
  set cableResistanceOhm($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCableResistanceOhm() => $_has(3);
  @$pb.TagNumber(4)
  void clearCableResistanceOhm() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get cableReactanceOhm => $_getN(4);
  @$pb.TagNumber(5)
  set cableReactanceOhm($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCableReactanceOhm() => $_has(4);
  @$pb.TagNumber(5)
  void clearCableReactanceOhm() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get zeroSeqImpedanceOhm => $_getN(5);
  @$pb.TagNumber(6)
  set zeroSeqImpedanceOhm($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasZeroSeqImpedanceOhm() => $_has(5);
  @$pb.TagNumber(6)
  void clearZeroSeqImpedanceOhm() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get includeSingleLineToGround => $_getBF(6);
  @$pb.TagNumber(7)
  set includeSingleLineToGround($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasIncludeSingleLineToGround() => $_has(6);
  @$pb.TagNumber(7)
  void clearIncludeSingleLineToGround() => $_clearField(7);
}

class ComputeShortCircuitResponse extends $pb.GeneratedMessage {
  factory ComputeShortCircuitResponse({
    $core.String? studyId,
    $core.double? vLnKv,
    $core.double? zTotalPosSeqOhm,
    $core.double? iFault3phKa,
    $core.bool? slgComputed,
    $core.double? zTotalZeroSeqOhm,
    $core.double? iFaultSlgKa,
    $core.double? governingFaultKa,
    $core.String? equation,
  }) {
    final $result = create();
    if (studyId != null) {
      $result.studyId = studyId;
    }
    if (vLnKv != null) {
      $result.vLnKv = vLnKv;
    }
    if (zTotalPosSeqOhm != null) {
      $result.zTotalPosSeqOhm = zTotalPosSeqOhm;
    }
    if (iFault3phKa != null) {
      $result.iFault3phKa = iFault3phKa;
    }
    if (slgComputed != null) {
      $result.slgComputed = slgComputed;
    }
    if (zTotalZeroSeqOhm != null) {
      $result.zTotalZeroSeqOhm = zTotalZeroSeqOhm;
    }
    if (iFaultSlgKa != null) {
      $result.iFaultSlgKa = iFaultSlgKa;
    }
    if (governingFaultKa != null) {
      $result.governingFaultKa = governingFaultKa;
    }
    if (equation != null) {
      $result.equation = equation;
    }
    return $result;
  }
  ComputeShortCircuitResponse._() : super();
  factory ComputeShortCircuitResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ComputeShortCircuitResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ComputeShortCircuitResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'protection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'studyId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'vLnKv', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'zTotalPosSeqOhm', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'iFault3phKa', $pb.PbFieldType.OD, protoName: 'i_fault_3ph_ka')
    ..aOB(5, _omitFieldNames ? '' : 'slgComputed')
    ..a<$core.double>(6, _omitFieldNames ? '' : 'zTotalZeroSeqOhm', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'iFaultSlgKa', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'governingFaultKa', $pb.PbFieldType.OD)
    ..aOS(9, _omitFieldNames ? '' : 'equation')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ComputeShortCircuitResponse clone() => ComputeShortCircuitResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ComputeShortCircuitResponse copyWith(void Function(ComputeShortCircuitResponse) updates) => super.copyWith((message) => updates(message as ComputeShortCircuitResponse)) as ComputeShortCircuitResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComputeShortCircuitResponse create() => ComputeShortCircuitResponse._();
  ComputeShortCircuitResponse createEmptyInstance() => create();
  static $pb.PbList<ComputeShortCircuitResponse> createRepeated() => $pb.PbList<ComputeShortCircuitResponse>();
  @$core.pragma('dart2js:noInline')
  static ComputeShortCircuitResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ComputeShortCircuitResponse>(create);
  static ComputeShortCircuitResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get studyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set studyId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStudyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStudyId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get vLnKv => $_getN(1);
  @$pb.TagNumber(2)
  set vLnKv($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasVLnKv() => $_has(1);
  @$pb.TagNumber(2)
  void clearVLnKv() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get zTotalPosSeqOhm => $_getN(2);
  @$pb.TagNumber(3)
  set zTotalPosSeqOhm($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasZTotalPosSeqOhm() => $_has(2);
  @$pb.TagNumber(3)
  void clearZTotalPosSeqOhm() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get iFault3phKa => $_getN(3);
  @$pb.TagNumber(4)
  set iFault3phKa($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIFault3phKa() => $_has(3);
  @$pb.TagNumber(4)
  void clearIFault3phKa() => $_clearField(4);

  /// Single-line-to-ground (if requested)
  @$pb.TagNumber(5)
  $core.bool get slgComputed => $_getBF(4);
  @$pb.TagNumber(5)
  set slgComputed($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSlgComputed() => $_has(4);
  @$pb.TagNumber(5)
  void clearSlgComputed() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get zTotalZeroSeqOhm => $_getN(5);
  @$pb.TagNumber(6)
  set zTotalZeroSeqOhm($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasZTotalZeroSeqOhm() => $_has(5);
  @$pb.TagNumber(6)
  void clearZTotalZeroSeqOhm() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get iFaultSlgKa => $_getN(6);
  @$pb.TagNumber(7)
  set iFaultSlgKa($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasIFaultSlgKa() => $_has(6);
  @$pb.TagNumber(7)
  void clearIFaultSlgKa() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get governingFaultKa => $_getN(7);
  @$pb.TagNumber(8)
  set governingFaultKa($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasGoverningFaultKa() => $_has(7);
  @$pb.TagNumber(8)
  void clearGoverningFaultKa() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get equation => $_getSZ(8);
  @$pb.TagNumber(9)
  set equation($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasEquation() => $_has(8);
  @$pb.TagNumber(9)
  void clearEquation() => $_clearField(9);
}

class ComputeEarthFaultRequest extends $pb.GeneratedMessage {
  factory ComputeEarthFaultRequest({
    $core.String? studyId,
    $core.double? voltageKv,
    NeutralEarthing? earthingMethod,
    $core.double? ngrResistanceOhm,
    $core.double? cableResistanceOhm,
  }) {
    final $result = create();
    if (studyId != null) {
      $result.studyId = studyId;
    }
    if (voltageKv != null) {
      $result.voltageKv = voltageKv;
    }
    if (earthingMethod != null) {
      $result.earthingMethod = earthingMethod;
    }
    if (ngrResistanceOhm != null) {
      $result.ngrResistanceOhm = ngrResistanceOhm;
    }
    if (cableResistanceOhm != null) {
      $result.cableResistanceOhm = cableResistanceOhm;
    }
    return $result;
  }
  ComputeEarthFaultRequest._() : super();
  factory ComputeEarthFaultRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ComputeEarthFaultRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ComputeEarthFaultRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'protection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'studyId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'voltageKv', $pb.PbFieldType.OD)
    ..e<NeutralEarthing>(3, _omitFieldNames ? '' : 'earthingMethod', $pb.PbFieldType.OE, defaultOrMaker: NeutralEarthing.NEUTRAL_EARTHING_UNSPECIFIED, valueOf: NeutralEarthing.valueOf, enumValues: NeutralEarthing.values)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'ngrResistanceOhm', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'cableResistanceOhm', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ComputeEarthFaultRequest clone() => ComputeEarthFaultRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ComputeEarthFaultRequest copyWith(void Function(ComputeEarthFaultRequest) updates) => super.copyWith((message) => updates(message as ComputeEarthFaultRequest)) as ComputeEarthFaultRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComputeEarthFaultRequest create() => ComputeEarthFaultRequest._();
  ComputeEarthFaultRequest createEmptyInstance() => create();
  static $pb.PbList<ComputeEarthFaultRequest> createRepeated() => $pb.PbList<ComputeEarthFaultRequest>();
  @$core.pragma('dart2js:noInline')
  static ComputeEarthFaultRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ComputeEarthFaultRequest>(create);
  static ComputeEarthFaultRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get studyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set studyId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStudyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStudyId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get voltageKv => $_getN(1);
  @$pb.TagNumber(2)
  set voltageKv($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasVoltageKv() => $_has(1);
  @$pb.TagNumber(2)
  void clearVoltageKv() => $_clearField(2);

  @$pb.TagNumber(3)
  NeutralEarthing get earthingMethod => $_getN(2);
  @$pb.TagNumber(3)
  set earthingMethod(NeutralEarthing v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasEarthingMethod() => $_has(2);
  @$pb.TagNumber(3)
  void clearEarthingMethod() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get ngrResistanceOhm => $_getN(3);
  @$pb.TagNumber(4)
  set ngrResistanceOhm($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasNgrResistanceOhm() => $_has(3);
  @$pb.TagNumber(4)
  void clearNgrResistanceOhm() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get cableResistanceOhm => $_getN(4);
  @$pb.TagNumber(5)
  set cableResistanceOhm($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCableResistanceOhm() => $_has(4);
  @$pb.TagNumber(5)
  void clearCableResistanceOhm() => $_clearField(5);
}

class ComputeEarthFaultResponse extends $pb.GeneratedMessage {
  factory ComputeEarthFaultResponse({
    $core.String? studyId,
    NeutralEarthing? earthingMethod,
    $core.double? earthFaultCurrentKa,
    $core.double? touchVoltageV,
    $core.String? equation,
  }) {
    final $result = create();
    if (studyId != null) {
      $result.studyId = studyId;
    }
    if (earthingMethod != null) {
      $result.earthingMethod = earthingMethod;
    }
    if (earthFaultCurrentKa != null) {
      $result.earthFaultCurrentKa = earthFaultCurrentKa;
    }
    if (touchVoltageV != null) {
      $result.touchVoltageV = touchVoltageV;
    }
    if (equation != null) {
      $result.equation = equation;
    }
    return $result;
  }
  ComputeEarthFaultResponse._() : super();
  factory ComputeEarthFaultResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ComputeEarthFaultResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ComputeEarthFaultResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'protection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'studyId')
    ..e<NeutralEarthing>(2, _omitFieldNames ? '' : 'earthingMethod', $pb.PbFieldType.OE, defaultOrMaker: NeutralEarthing.NEUTRAL_EARTHING_UNSPECIFIED, valueOf: NeutralEarthing.valueOf, enumValues: NeutralEarthing.values)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'earthFaultCurrentKa', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'touchVoltageV', $pb.PbFieldType.OD)
    ..aOS(5, _omitFieldNames ? '' : 'equation')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ComputeEarthFaultResponse clone() => ComputeEarthFaultResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ComputeEarthFaultResponse copyWith(void Function(ComputeEarthFaultResponse) updates) => super.copyWith((message) => updates(message as ComputeEarthFaultResponse)) as ComputeEarthFaultResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComputeEarthFaultResponse create() => ComputeEarthFaultResponse._();
  ComputeEarthFaultResponse createEmptyInstance() => create();
  static $pb.PbList<ComputeEarthFaultResponse> createRepeated() => $pb.PbList<ComputeEarthFaultResponse>();
  @$core.pragma('dart2js:noInline')
  static ComputeEarthFaultResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ComputeEarthFaultResponse>(create);
  static ComputeEarthFaultResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get studyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set studyId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStudyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStudyId() => $_clearField(1);

  @$pb.TagNumber(2)
  NeutralEarthing get earthingMethod => $_getN(1);
  @$pb.TagNumber(2)
  set earthingMethod(NeutralEarthing v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasEarthingMethod() => $_has(1);
  @$pb.TagNumber(2)
  void clearEarthingMethod() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get earthFaultCurrentKa => $_getN(2);
  @$pb.TagNumber(3)
  set earthFaultCurrentKa($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasEarthFaultCurrentKa() => $_has(2);
  @$pb.TagNumber(3)
  void clearEarthFaultCurrentKa() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get touchVoltageV => $_getN(3);
  @$pb.TagNumber(4)
  set touchVoltageV($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTouchVoltageV() => $_has(3);
  @$pb.TagNumber(4)
  void clearTouchVoltageV() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get equation => $_getSZ(4);
  @$pb.TagNumber(5)
  set equation($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasEquation() => $_has(4);
  @$pb.TagNumber(5)
  void clearEquation() => $_clearField(5);
}

class SelectRelayRequest extends $pb.GeneratedMessage {
  factory SelectRelayRequest({
    $core.String? studyId,
    $core.double? faultCurrentKa,
    $core.double? loadCurrentA,
    RelayCharacteristic? preferredCharacteristic,
  }) {
    final $result = create();
    if (studyId != null) {
      $result.studyId = studyId;
    }
    if (faultCurrentKa != null) {
      $result.faultCurrentKa = faultCurrentKa;
    }
    if (loadCurrentA != null) {
      $result.loadCurrentA = loadCurrentA;
    }
    if (preferredCharacteristic != null) {
      $result.preferredCharacteristic = preferredCharacteristic;
    }
    return $result;
  }
  SelectRelayRequest._() : super();
  factory SelectRelayRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SelectRelayRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SelectRelayRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'protection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'studyId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'faultCurrentKa', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'loadCurrentA', $pb.PbFieldType.OD)
    ..e<RelayCharacteristic>(4, _omitFieldNames ? '' : 'preferredCharacteristic', $pb.PbFieldType.OE, defaultOrMaker: RelayCharacteristic.RELAY_CHARACTERISTIC_UNSPECIFIED, valueOf: RelayCharacteristic.valueOf, enumValues: RelayCharacteristic.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SelectRelayRequest clone() => SelectRelayRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SelectRelayRequest copyWith(void Function(SelectRelayRequest) updates) => super.copyWith((message) => updates(message as SelectRelayRequest)) as SelectRelayRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SelectRelayRequest create() => SelectRelayRequest._();
  SelectRelayRequest createEmptyInstance() => create();
  static $pb.PbList<SelectRelayRequest> createRepeated() => $pb.PbList<SelectRelayRequest>();
  @$core.pragma('dart2js:noInline')
  static SelectRelayRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SelectRelayRequest>(create);
  static SelectRelayRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get studyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set studyId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStudyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStudyId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get faultCurrentKa => $_getN(1);
  @$pb.TagNumber(2)
  set faultCurrentKa($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFaultCurrentKa() => $_has(1);
  @$pb.TagNumber(2)
  void clearFaultCurrentKa() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get loadCurrentA => $_getN(2);
  @$pb.TagNumber(3)
  set loadCurrentA($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLoadCurrentA() => $_has(2);
  @$pb.TagNumber(3)
  void clearLoadCurrentA() => $_clearField(3);

  /// preference
  @$pb.TagNumber(4)
  RelayCharacteristic get preferredCharacteristic => $_getN(3);
  @$pb.TagNumber(4)
  set preferredCharacteristic(RelayCharacteristic v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasPreferredCharacteristic() => $_has(3);
  @$pb.TagNumber(4)
  void clearPreferredCharacteristic() => $_clearField(4);
}

class RelaySelection extends $pb.GeneratedMessage {
  factory RelaySelection({
    $core.String? relayId,
    $core.String? makeModel,
    RelayCharacteristic? characteristic,
    $core.double? pickupCurrentA,
    $core.double? timeDialSetting,
    $core.String? rationale,
  }) {
    final $result = create();
    if (relayId != null) {
      $result.relayId = relayId;
    }
    if (makeModel != null) {
      $result.makeModel = makeModel;
    }
    if (characteristic != null) {
      $result.characteristic = characteristic;
    }
    if (pickupCurrentA != null) {
      $result.pickupCurrentA = pickupCurrentA;
    }
    if (timeDialSetting != null) {
      $result.timeDialSetting = timeDialSetting;
    }
    if (rationale != null) {
      $result.rationale = rationale;
    }
    return $result;
  }
  RelaySelection._() : super();
  factory RelaySelection.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RelaySelection.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RelaySelection', package: const $pb.PackageName(_omitMessageNames ? '' : 'protection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'relayId')
    ..aOS(2, _omitFieldNames ? '' : 'makeModel')
    ..e<RelayCharacteristic>(3, _omitFieldNames ? '' : 'characteristic', $pb.PbFieldType.OE, defaultOrMaker: RelayCharacteristic.RELAY_CHARACTERISTIC_UNSPECIFIED, valueOf: RelayCharacteristic.valueOf, enumValues: RelayCharacteristic.values)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'pickupCurrentA', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'timeDialSetting', $pb.PbFieldType.OD)
    ..aOS(6, _omitFieldNames ? '' : 'rationale')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RelaySelection clone() => RelaySelection()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RelaySelection copyWith(void Function(RelaySelection) updates) => super.copyWith((message) => updates(message as RelaySelection)) as RelaySelection;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RelaySelection create() => RelaySelection._();
  RelaySelection createEmptyInstance() => create();
  static $pb.PbList<RelaySelection> createRepeated() => $pb.PbList<RelaySelection>();
  @$core.pragma('dart2js:noInline')
  static RelaySelection getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RelaySelection>(create);
  static RelaySelection? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get relayId => $_getSZ(0);
  @$pb.TagNumber(1)
  set relayId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRelayId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRelayId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get makeModel => $_getSZ(1);
  @$pb.TagNumber(2)
  set makeModel($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMakeModel() => $_has(1);
  @$pb.TagNumber(2)
  void clearMakeModel() => $_clearField(2);

  @$pb.TagNumber(3)
  RelayCharacteristic get characteristic => $_getN(2);
  @$pb.TagNumber(3)
  set characteristic(RelayCharacteristic v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCharacteristic() => $_has(2);
  @$pb.TagNumber(3)
  void clearCharacteristic() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get pickupCurrentA => $_getN(3);
  @$pb.TagNumber(4)
  set pickupCurrentA($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPickupCurrentA() => $_has(3);
  @$pb.TagNumber(4)
  void clearPickupCurrentA() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get timeDialSetting => $_getN(4);
  @$pb.TagNumber(5)
  set timeDialSetting($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTimeDialSetting() => $_has(4);
  @$pb.TagNumber(5)
  void clearTimeDialSetting() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get rationale => $_getSZ(5);
  @$pb.TagNumber(6)
  set rationale($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasRationale() => $_has(5);
  @$pb.TagNumber(6)
  void clearRationale() => $_clearField(6);
}

class SelectRelayResponse extends $pb.GeneratedMessage {
  factory SelectRelayResponse({
    $core.String? studyId,
    RelaySelection? relay,
  }) {
    final $result = create();
    if (studyId != null) {
      $result.studyId = studyId;
    }
    if (relay != null) {
      $result.relay = relay;
    }
    return $result;
  }
  SelectRelayResponse._() : super();
  factory SelectRelayResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SelectRelayResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SelectRelayResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'protection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'studyId')
    ..aOM<RelaySelection>(2, _omitFieldNames ? '' : 'relay', subBuilder: RelaySelection.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SelectRelayResponse clone() => SelectRelayResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SelectRelayResponse copyWith(void Function(SelectRelayResponse) updates) => super.copyWith((message) => updates(message as SelectRelayResponse)) as SelectRelayResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SelectRelayResponse create() => SelectRelayResponse._();
  SelectRelayResponse createEmptyInstance() => create();
  static $pb.PbList<SelectRelayResponse> createRepeated() => $pb.PbList<SelectRelayResponse>();
  @$core.pragma('dart2js:noInline')
  static SelectRelayResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SelectRelayResponse>(create);
  static SelectRelayResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get studyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set studyId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStudyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStudyId() => $_clearField(1);

  @$pb.TagNumber(2)
  RelaySelection get relay => $_getN(1);
  @$pb.TagNumber(2)
  set relay(RelaySelection v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRelay() => $_has(1);
  @$pb.TagNumber(2)
  void clearRelay() => $_clearField(2);
  @$pb.TagNumber(2)
  RelaySelection ensureRelay() => $_ensure(1);
}

class ComputeRelaySettingsRequest extends $pb.GeneratedMessage {
  factory ComputeRelaySettingsRequest({
    $core.String? studyId,
    RelayCharacteristic? characteristic,
    $core.double? pickupCurrentA,
    $core.double? timeDialSetting,
    $core.double? faultCurrentA,
  }) {
    final $result = create();
    if (studyId != null) {
      $result.studyId = studyId;
    }
    if (characteristic != null) {
      $result.characteristic = characteristic;
    }
    if (pickupCurrentA != null) {
      $result.pickupCurrentA = pickupCurrentA;
    }
    if (timeDialSetting != null) {
      $result.timeDialSetting = timeDialSetting;
    }
    if (faultCurrentA != null) {
      $result.faultCurrentA = faultCurrentA;
    }
    return $result;
  }
  ComputeRelaySettingsRequest._() : super();
  factory ComputeRelaySettingsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ComputeRelaySettingsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ComputeRelaySettingsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'protection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'studyId')
    ..e<RelayCharacteristic>(2, _omitFieldNames ? '' : 'characteristic', $pb.PbFieldType.OE, defaultOrMaker: RelayCharacteristic.RELAY_CHARACTERISTIC_UNSPECIFIED, valueOf: RelayCharacteristic.valueOf, enumValues: RelayCharacteristic.values)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'pickupCurrentA', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'timeDialSetting', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'faultCurrentA', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ComputeRelaySettingsRequest clone() => ComputeRelaySettingsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ComputeRelaySettingsRequest copyWith(void Function(ComputeRelaySettingsRequest) updates) => super.copyWith((message) => updates(message as ComputeRelaySettingsRequest)) as ComputeRelaySettingsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComputeRelaySettingsRequest create() => ComputeRelaySettingsRequest._();
  ComputeRelaySettingsRequest createEmptyInstance() => create();
  static $pb.PbList<ComputeRelaySettingsRequest> createRepeated() => $pb.PbList<ComputeRelaySettingsRequest>();
  @$core.pragma('dart2js:noInline')
  static ComputeRelaySettingsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ComputeRelaySettingsRequest>(create);
  static ComputeRelaySettingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get studyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set studyId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStudyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStudyId() => $_clearField(1);

  @$pb.TagNumber(2)
  RelayCharacteristic get characteristic => $_getN(1);
  @$pb.TagNumber(2)
  set characteristic(RelayCharacteristic v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCharacteristic() => $_has(1);
  @$pb.TagNumber(2)
  void clearCharacteristic() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get pickupCurrentA => $_getN(2);
  @$pb.TagNumber(3)
  set pickupCurrentA($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPickupCurrentA() => $_has(2);
  @$pb.TagNumber(3)
  void clearPickupCurrentA() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get timeDialSetting => $_getN(3);
  @$pb.TagNumber(4)
  set timeDialSetting($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTimeDialSetting() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimeDialSetting() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get faultCurrentA => $_getN(4);
  @$pb.TagNumber(5)
  set faultCurrentA($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasFaultCurrentA() => $_has(4);
  @$pb.TagNumber(5)
  void clearFaultCurrentA() => $_clearField(5);
}

class ComputeRelaySettingsResponse extends $pb.GeneratedMessage {
  factory ComputeRelaySettingsResponse({
    $core.String? studyId,
    $core.double? multiplier,
    $core.double? operatingTimeS,
    RelayCharacteristic? characteristic,
    $core.String? equation,
  }) {
    final $result = create();
    if (studyId != null) {
      $result.studyId = studyId;
    }
    if (multiplier != null) {
      $result.multiplier = multiplier;
    }
    if (operatingTimeS != null) {
      $result.operatingTimeS = operatingTimeS;
    }
    if (characteristic != null) {
      $result.characteristic = characteristic;
    }
    if (equation != null) {
      $result.equation = equation;
    }
    return $result;
  }
  ComputeRelaySettingsResponse._() : super();
  factory ComputeRelaySettingsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ComputeRelaySettingsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ComputeRelaySettingsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'protection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'studyId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'multiplier', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'operatingTimeS', $pb.PbFieldType.OD)
    ..e<RelayCharacteristic>(4, _omitFieldNames ? '' : 'characteristic', $pb.PbFieldType.OE, defaultOrMaker: RelayCharacteristic.RELAY_CHARACTERISTIC_UNSPECIFIED, valueOf: RelayCharacteristic.valueOf, enumValues: RelayCharacteristic.values)
    ..aOS(5, _omitFieldNames ? '' : 'equation')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ComputeRelaySettingsResponse clone() => ComputeRelaySettingsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ComputeRelaySettingsResponse copyWith(void Function(ComputeRelaySettingsResponse) updates) => super.copyWith((message) => updates(message as ComputeRelaySettingsResponse)) as ComputeRelaySettingsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComputeRelaySettingsResponse create() => ComputeRelaySettingsResponse._();
  ComputeRelaySettingsResponse createEmptyInstance() => create();
  static $pb.PbList<ComputeRelaySettingsResponse> createRepeated() => $pb.PbList<ComputeRelaySettingsResponse>();
  @$core.pragma('dart2js:noInline')
  static ComputeRelaySettingsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ComputeRelaySettingsResponse>(create);
  static ComputeRelaySettingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get studyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set studyId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStudyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStudyId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get multiplier => $_getN(1);
  @$pb.TagNumber(2)
  set multiplier($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMultiplier() => $_has(1);
  @$pb.TagNumber(2)
  void clearMultiplier() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get operatingTimeS => $_getN(2);
  @$pb.TagNumber(3)
  set operatingTimeS($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOperatingTimeS() => $_has(2);
  @$pb.TagNumber(3)
  void clearOperatingTimeS() => $_clearField(3);

  @$pb.TagNumber(4)
  RelayCharacteristic get characteristic => $_getN(3);
  @$pb.TagNumber(4)
  set characteristic(RelayCharacteristic v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasCharacteristic() => $_has(3);
  @$pb.TagNumber(4)
  void clearCharacteristic() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get equation => $_getSZ(4);
  @$pb.TagNumber(5)
  set equation($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasEquation() => $_has(4);
  @$pb.TagNumber(5)
  void clearEquation() => $_clearField(5);
}

class CoordinationPair extends $pb.GeneratedMessage {
  factory CoordinationPair({
    $core.String? upstreamRelayId,
    $core.String? downstreamRelayId,
    $core.double? upstreamTimeS,
    $core.double? downstreamTimeS,
    $core.double? marginS,
  }) {
    final $result = create();
    if (upstreamRelayId != null) {
      $result.upstreamRelayId = upstreamRelayId;
    }
    if (downstreamRelayId != null) {
      $result.downstreamRelayId = downstreamRelayId;
    }
    if (upstreamTimeS != null) {
      $result.upstreamTimeS = upstreamTimeS;
    }
    if (downstreamTimeS != null) {
      $result.downstreamTimeS = downstreamTimeS;
    }
    if (marginS != null) {
      $result.marginS = marginS;
    }
    return $result;
  }
  CoordinationPair._() : super();
  factory CoordinationPair.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CoordinationPair.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CoordinationPair', package: const $pb.PackageName(_omitMessageNames ? '' : 'protection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'upstreamRelayId')
    ..aOS(2, _omitFieldNames ? '' : 'downstreamRelayId')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'upstreamTimeS', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'downstreamTimeS', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'marginS', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CoordinationPair clone() => CoordinationPair()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CoordinationPair copyWith(void Function(CoordinationPair) updates) => super.copyWith((message) => updates(message as CoordinationPair)) as CoordinationPair;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CoordinationPair create() => CoordinationPair._();
  CoordinationPair createEmptyInstance() => create();
  static $pb.PbList<CoordinationPair> createRepeated() => $pb.PbList<CoordinationPair>();
  @$core.pragma('dart2js:noInline')
  static CoordinationPair getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CoordinationPair>(create);
  static CoordinationPair? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get upstreamRelayId => $_getSZ(0);
  @$pb.TagNumber(1)
  set upstreamRelayId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUpstreamRelayId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpstreamRelayId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get downstreamRelayId => $_getSZ(1);
  @$pb.TagNumber(2)
  set downstreamRelayId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDownstreamRelayId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDownstreamRelayId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get upstreamTimeS => $_getN(2);
  @$pb.TagNumber(3)
  set upstreamTimeS($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUpstreamTimeS() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpstreamTimeS() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get downstreamTimeS => $_getN(3);
  @$pb.TagNumber(4)
  set downstreamTimeS($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDownstreamTimeS() => $_has(3);
  @$pb.TagNumber(4)
  void clearDownstreamTimeS() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get marginS => $_getN(4);
  @$pb.TagNumber(5)
  set marginS($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMarginS() => $_has(4);
  @$pb.TagNumber(5)
  void clearMarginS() => $_clearField(5);
}

class ValidateCoordinationRequest extends $pb.GeneratedMessage {
  factory ValidateCoordinationRequest({
    $core.String? studyId,
    $core.Iterable<CoordinationPair>? pairs,
    $core.double? minimumMarginS,
  }) {
    final $result = create();
    if (studyId != null) {
      $result.studyId = studyId;
    }
    if (pairs != null) {
      $result.pairs.addAll(pairs);
    }
    if (minimumMarginS != null) {
      $result.minimumMarginS = minimumMarginS;
    }
    return $result;
  }
  ValidateCoordinationRequest._() : super();
  factory ValidateCoordinationRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ValidateCoordinationRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ValidateCoordinationRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'protection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'studyId')
    ..pc<CoordinationPair>(2, _omitFieldNames ? '' : 'pairs', $pb.PbFieldType.PM, subBuilder: CoordinationPair.create)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'minimumMarginS', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ValidateCoordinationRequest clone() => ValidateCoordinationRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ValidateCoordinationRequest copyWith(void Function(ValidateCoordinationRequest) updates) => super.copyWith((message) => updates(message as ValidateCoordinationRequest)) as ValidateCoordinationRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ValidateCoordinationRequest create() => ValidateCoordinationRequest._();
  ValidateCoordinationRequest createEmptyInstance() => create();
  static $pb.PbList<ValidateCoordinationRequest> createRepeated() => $pb.PbList<ValidateCoordinationRequest>();
  @$core.pragma('dart2js:noInline')
  static ValidateCoordinationRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ValidateCoordinationRequest>(create);
  static ValidateCoordinationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get studyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set studyId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStudyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStudyId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<CoordinationPair> get pairs => $_getList(1);

  @$pb.TagNumber(3)
  $core.double get minimumMarginS => $_getN(2);
  @$pb.TagNumber(3)
  set minimumMarginS($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMinimumMarginS() => $_has(2);
  @$pb.TagNumber(3)
  void clearMinimumMarginS() => $_clearField(3);
}

class CoordinationViolation extends $pb.GeneratedMessage {
  factory CoordinationViolation({
    $core.String? upstreamRelayId,
    $core.String? downstreamRelayId,
    $core.double? marginS,
    $core.double? minimumRequiredS,
  }) {
    final $result = create();
    if (upstreamRelayId != null) {
      $result.upstreamRelayId = upstreamRelayId;
    }
    if (downstreamRelayId != null) {
      $result.downstreamRelayId = downstreamRelayId;
    }
    if (marginS != null) {
      $result.marginS = marginS;
    }
    if (minimumRequiredS != null) {
      $result.minimumRequiredS = minimumRequiredS;
    }
    return $result;
  }
  CoordinationViolation._() : super();
  factory CoordinationViolation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CoordinationViolation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CoordinationViolation', package: const $pb.PackageName(_omitMessageNames ? '' : 'protection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'upstreamRelayId')
    ..aOS(2, _omitFieldNames ? '' : 'downstreamRelayId')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'marginS', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'minimumRequiredS', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CoordinationViolation clone() => CoordinationViolation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CoordinationViolation copyWith(void Function(CoordinationViolation) updates) => super.copyWith((message) => updates(message as CoordinationViolation)) as CoordinationViolation;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CoordinationViolation create() => CoordinationViolation._();
  CoordinationViolation createEmptyInstance() => create();
  static $pb.PbList<CoordinationViolation> createRepeated() => $pb.PbList<CoordinationViolation>();
  @$core.pragma('dart2js:noInline')
  static CoordinationViolation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CoordinationViolation>(create);
  static CoordinationViolation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get upstreamRelayId => $_getSZ(0);
  @$pb.TagNumber(1)
  set upstreamRelayId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUpstreamRelayId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpstreamRelayId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get downstreamRelayId => $_getSZ(1);
  @$pb.TagNumber(2)
  set downstreamRelayId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDownstreamRelayId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDownstreamRelayId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get marginS => $_getN(2);
  @$pb.TagNumber(3)
  set marginS($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMarginS() => $_has(2);
  @$pb.TagNumber(3)
  void clearMarginS() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get minimumRequiredS => $_getN(3);
  @$pb.TagNumber(4)
  set minimumRequiredS($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMinimumRequiredS() => $_has(3);
  @$pb.TagNumber(4)
  void clearMinimumRequiredS() => $_clearField(4);
}

class ValidateCoordinationResponse extends $pb.GeneratedMessage {
  factory ValidateCoordinationResponse({
    $core.bool? valid,
    $core.Iterable<CoordinationViolation>? violations,
  }) {
    final $result = create();
    if (valid != null) {
      $result.valid = valid;
    }
    if (violations != null) {
      $result.violations.addAll(violations);
    }
    return $result;
  }
  ValidateCoordinationResponse._() : super();
  factory ValidateCoordinationResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ValidateCoordinationResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ValidateCoordinationResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'protection.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'valid')
    ..pc<CoordinationViolation>(2, _omitFieldNames ? '' : 'violations', $pb.PbFieldType.PM, subBuilder: CoordinationViolation.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ValidateCoordinationResponse clone() => ValidateCoordinationResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ValidateCoordinationResponse copyWith(void Function(ValidateCoordinationResponse) updates) => super.copyWith((message) => updates(message as ValidateCoordinationResponse)) as ValidateCoordinationResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ValidateCoordinationResponse create() => ValidateCoordinationResponse._();
  ValidateCoordinationResponse createEmptyInstance() => create();
  static $pb.PbList<ValidateCoordinationResponse> createRepeated() => $pb.PbList<ValidateCoordinationResponse>();
  @$core.pragma('dart2js:noInline')
  static ValidateCoordinationResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ValidateCoordinationResponse>(create);
  static ValidateCoordinationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get valid => $_getBF(0);
  @$pb.TagNumber(1)
  set valid($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasValid() => $_has(0);
  @$pb.TagNumber(1)
  void clearValid() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<CoordinationViolation> get violations => $_getList(1);
}

class GenerateProtectionReportRequest extends $pb.GeneratedMessage {
  factory GenerateProtectionReportRequest({
    $core.String? studyId,
  }) {
    final $result = create();
    if (studyId != null) {
      $result.studyId = studyId;
    }
    return $result;
  }
  GenerateProtectionReportRequest._() : super();
  factory GenerateProtectionReportRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenerateProtectionReportRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GenerateProtectionReportRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'protection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'studyId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenerateProtectionReportRequest clone() => GenerateProtectionReportRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenerateProtectionReportRequest copyWith(void Function(GenerateProtectionReportRequest) updates) => super.copyWith((message) => updates(message as GenerateProtectionReportRequest)) as GenerateProtectionReportRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenerateProtectionReportRequest create() => GenerateProtectionReportRequest._();
  GenerateProtectionReportRequest createEmptyInstance() => create();
  static $pb.PbList<GenerateProtectionReportRequest> createRepeated() => $pb.PbList<GenerateProtectionReportRequest>();
  @$core.pragma('dart2js:noInline')
  static GenerateProtectionReportRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenerateProtectionReportRequest>(create);
  static GenerateProtectionReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get studyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set studyId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStudyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStudyId() => $_clearField(1);
}

class GenerateProtectionReportResponse extends $pb.GeneratedMessage {
  factory GenerateProtectionReportResponse({
    $core.String? studyId,
    $core.String? reportText,
  }) {
    final $result = create();
    if (studyId != null) {
      $result.studyId = studyId;
    }
    if (reportText != null) {
      $result.reportText = reportText;
    }
    return $result;
  }
  GenerateProtectionReportResponse._() : super();
  factory GenerateProtectionReportResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenerateProtectionReportResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GenerateProtectionReportResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'protection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'studyId')
    ..aOS(2, _omitFieldNames ? '' : 'reportText')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenerateProtectionReportResponse clone() => GenerateProtectionReportResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenerateProtectionReportResponse copyWith(void Function(GenerateProtectionReportResponse) updates) => super.copyWith((message) => updates(message as GenerateProtectionReportResponse)) as GenerateProtectionReportResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenerateProtectionReportResponse create() => GenerateProtectionReportResponse._();
  GenerateProtectionReportResponse createEmptyInstance() => create();
  static $pb.PbList<GenerateProtectionReportResponse> createRepeated() => $pb.PbList<GenerateProtectionReportResponse>();
  @$core.pragma('dart2js:noInline')
  static GenerateProtectionReportResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenerateProtectionReportResponse>(create);
  static GenerateProtectionReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get studyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set studyId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStudyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStudyId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reportText => $_getSZ(1);
  @$pb.TagNumber(2)
  set reportText($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReportText() => $_has(1);
  @$pb.TagNumber(2)
  void clearReportText() => $_clearField(2);
}

class CreateStudyRequest extends $pb.GeneratedMessage {
  factory CreateStudyRequest({
    $core.String? projectId,
    $core.String? name,
    $core.double? systemVoltageKv,
    $core.double? sourceImpedancePu,
    $core.double? mvaBase,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (systemVoltageKv != null) {
      $result.systemVoltageKv = systemVoltageKv;
    }
    if (sourceImpedancePu != null) {
      $result.sourceImpedancePu = sourceImpedancePu;
    }
    if (mvaBase != null) {
      $result.mvaBase = mvaBase;
    }
    return $result;
  }
  CreateStudyRequest._() : super();
  factory CreateStudyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateStudyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateStudyRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'protection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'systemVoltageKv', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'sourceImpedancePu', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'mvaBase', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateStudyRequest clone() => CreateStudyRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateStudyRequest copyWith(void Function(CreateStudyRequest) updates) => super.copyWith((message) => updates(message as CreateStudyRequest)) as CreateStudyRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateStudyRequest create() => CreateStudyRequest._();
  CreateStudyRequest createEmptyInstance() => create();
  static $pb.PbList<CreateStudyRequest> createRepeated() => $pb.PbList<CreateStudyRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateStudyRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateStudyRequest>(create);
  static CreateStudyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get systemVoltageKv => $_getN(2);
  @$pb.TagNumber(3)
  set systemVoltageKv($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSystemVoltageKv() => $_has(2);
  @$pb.TagNumber(3)
  void clearSystemVoltageKv() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get sourceImpedancePu => $_getN(3);
  @$pb.TagNumber(4)
  set sourceImpedancePu($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSourceImpedancePu() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourceImpedancePu() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get mvaBase => $_getN(4);
  @$pb.TagNumber(5)
  set mvaBase($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMvaBase() => $_has(4);
  @$pb.TagNumber(5)
  void clearMvaBase() => $_clearField(5);
}

class CreateStudyResponse extends $pb.GeneratedMessage {
  factory CreateStudyResponse({
    ProtectionStudy? study,
  }) {
    final $result = create();
    if (study != null) {
      $result.study = study;
    }
    return $result;
  }
  CreateStudyResponse._() : super();
  factory CreateStudyResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateStudyResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateStudyResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'protection.v1'), createEmptyInstance: create)
    ..aOM<ProtectionStudy>(1, _omitFieldNames ? '' : 'study', subBuilder: ProtectionStudy.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateStudyResponse clone() => CreateStudyResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateStudyResponse copyWith(void Function(CreateStudyResponse) updates) => super.copyWith((message) => updates(message as CreateStudyResponse)) as CreateStudyResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateStudyResponse create() => CreateStudyResponse._();
  CreateStudyResponse createEmptyInstance() => create();
  static $pb.PbList<CreateStudyResponse> createRepeated() => $pb.PbList<CreateStudyResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateStudyResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateStudyResponse>(create);
  static CreateStudyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ProtectionStudy get study => $_getN(0);
  @$pb.TagNumber(1)
  set study(ProtectionStudy v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStudy() => $_has(0);
  @$pb.TagNumber(1)
  void clearStudy() => $_clearField(1);
  @$pb.TagNumber(1)
  ProtectionStudy ensureStudy() => $_ensure(0);
}

class GetStudyRequest extends $pb.GeneratedMessage {
  factory GetStudyRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  GetStudyRequest._() : super();
  factory GetStudyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetStudyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetStudyRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'protection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetStudyRequest clone() => GetStudyRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetStudyRequest copyWith(void Function(GetStudyRequest) updates) => super.copyWith((message) => updates(message as GetStudyRequest)) as GetStudyRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetStudyRequest create() => GetStudyRequest._();
  GetStudyRequest createEmptyInstance() => create();
  static $pb.PbList<GetStudyRequest> createRepeated() => $pb.PbList<GetStudyRequest>();
  @$core.pragma('dart2js:noInline')
  static GetStudyRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetStudyRequest>(create);
  static GetStudyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class GetStudyResponse extends $pb.GeneratedMessage {
  factory GetStudyResponse({
    ProtectionStudy? study,
  }) {
    final $result = create();
    if (study != null) {
      $result.study = study;
    }
    return $result;
  }
  GetStudyResponse._() : super();
  factory GetStudyResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetStudyResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetStudyResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'protection.v1'), createEmptyInstance: create)
    ..aOM<ProtectionStudy>(1, _omitFieldNames ? '' : 'study', subBuilder: ProtectionStudy.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetStudyResponse clone() => GetStudyResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetStudyResponse copyWith(void Function(GetStudyResponse) updates) => super.copyWith((message) => updates(message as GetStudyResponse)) as GetStudyResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetStudyResponse create() => GetStudyResponse._();
  GetStudyResponse createEmptyInstance() => create();
  static $pb.PbList<GetStudyResponse> createRepeated() => $pb.PbList<GetStudyResponse>();
  @$core.pragma('dart2js:noInline')
  static GetStudyResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetStudyResponse>(create);
  static GetStudyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ProtectionStudy get study => $_getN(0);
  @$pb.TagNumber(1)
  set study(ProtectionStudy v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStudy() => $_has(0);
  @$pb.TagNumber(1)
  void clearStudy() => $_clearField(1);
  @$pb.TagNumber(1)
  ProtectionStudy ensureStudy() => $_ensure(0);
}

class ListStudiesRequest extends $pb.GeneratedMessage {
  factory ListStudiesRequest({
    $core.String? projectId,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    return $result;
  }
  ListStudiesRequest._() : super();
  factory ListStudiesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListStudiesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListStudiesRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'protection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListStudiesRequest clone() => ListStudiesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListStudiesRequest copyWith(void Function(ListStudiesRequest) updates) => super.copyWith((message) => updates(message as ListStudiesRequest)) as ListStudiesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListStudiesRequest create() => ListStudiesRequest._();
  ListStudiesRequest createEmptyInstance() => create();
  static $pb.PbList<ListStudiesRequest> createRepeated() => $pb.PbList<ListStudiesRequest>();
  @$core.pragma('dart2js:noInline')
  static ListStudiesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListStudiesRequest>(create);
  static ListStudiesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);
}

class ListStudiesResponse extends $pb.GeneratedMessage {
  factory ListStudiesResponse({
    $core.Iterable<ProtectionStudy>? studies,
  }) {
    final $result = create();
    if (studies != null) {
      $result.studies.addAll(studies);
    }
    return $result;
  }
  ListStudiesResponse._() : super();
  factory ListStudiesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListStudiesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListStudiesResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'protection.v1'), createEmptyInstance: create)
    ..pc<ProtectionStudy>(1, _omitFieldNames ? '' : 'studies', $pb.PbFieldType.PM, subBuilder: ProtectionStudy.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListStudiesResponse clone() => ListStudiesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListStudiesResponse copyWith(void Function(ListStudiesResponse) updates) => super.copyWith((message) => updates(message as ListStudiesResponse)) as ListStudiesResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListStudiesResponse create() => ListStudiesResponse._();
  ListStudiesResponse createEmptyInstance() => create();
  static $pb.PbList<ListStudiesResponse> createRepeated() => $pb.PbList<ListStudiesResponse>();
  @$core.pragma('dart2js:noInline')
  static ListStudiesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListStudiesResponse>(create);
  static ListStudiesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ProtectionStudy> get studies => $_getList(0);
}

class DeleteStudyRequest extends $pb.GeneratedMessage {
  factory DeleteStudyRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  DeleteStudyRequest._() : super();
  factory DeleteStudyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteStudyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteStudyRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'protection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteStudyRequest clone() => DeleteStudyRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteStudyRequest copyWith(void Function(DeleteStudyRequest) updates) => super.copyWith((message) => updates(message as DeleteStudyRequest)) as DeleteStudyRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteStudyRequest create() => DeleteStudyRequest._();
  DeleteStudyRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteStudyRequest> createRepeated() => $pb.PbList<DeleteStudyRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteStudyRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteStudyRequest>(create);
  static DeleteStudyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class DeleteStudyResponse extends $pb.GeneratedMessage {
  factory DeleteStudyResponse() => create();
  DeleteStudyResponse._() : super();
  factory DeleteStudyResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteStudyResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteStudyResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'protection.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteStudyResponse clone() => DeleteStudyResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteStudyResponse copyWith(void Function(DeleteStudyResponse) updates) => super.copyWith((message) => updates(message as DeleteStudyResponse)) as DeleteStudyResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteStudyResponse create() => DeleteStudyResponse._();
  DeleteStudyResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteStudyResponse> createRepeated() => $pb.PbList<DeleteStudyResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteStudyResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteStudyResponse>(create);
  static DeleteStudyResponse? _defaultInstance;
}

/// ProtectionService implements IEC 60909 short-circuit and IEC 60255 protective
/// relay studies for solar plant HV/MV networks.
class ProtectionServiceApi {
  $pb.RpcClient _client;
  ProtectionServiceApi(this._client);

  /// Study management
  $async.Future<CreateStudyResponse> createStudy($pb.ClientContext? ctx, CreateStudyRequest request) =>
    _client.invoke<CreateStudyResponse>(ctx, 'ProtectionService', 'CreateStudy', request, CreateStudyResponse())
  ;
  $async.Future<GetStudyResponse> getStudy($pb.ClientContext? ctx, GetStudyRequest request) =>
    _client.invoke<GetStudyResponse>(ctx, 'ProtectionService', 'GetStudy', request, GetStudyResponse())
  ;
  $async.Future<ListStudiesResponse> listStudies($pb.ClientContext? ctx, ListStudiesRequest request) =>
    _client.invoke<ListStudiesResponse>(ctx, 'ProtectionService', 'ListStudies', request, ListStudiesResponse())
  ;
  $async.Future<DeleteStudyResponse> deleteStudy($pb.ClientContext? ctx, DeleteStudyRequest request) =>
    _client.invoke<DeleteStudyResponse>(ctx, 'ProtectionService', 'DeleteStudy', request, DeleteStudyResponse())
  ;
  /// Fault calculations
  $async.Future<ComputeShortCircuitResponse> computeShortCircuit($pb.ClientContext? ctx, ComputeShortCircuitRequest request) =>
    _client.invoke<ComputeShortCircuitResponse>(ctx, 'ProtectionService', 'ComputeShortCircuit', request, ComputeShortCircuitResponse())
  ;
  $async.Future<ComputeEarthFaultResponse> computeEarthFault($pb.ClientContext? ctx, ComputeEarthFaultRequest request) =>
    _client.invoke<ComputeEarthFaultResponse>(ctx, 'ProtectionService', 'ComputeEarthFault', request, ComputeEarthFaultResponse())
  ;
  /// Relay selection and settings
  $async.Future<SelectRelayResponse> selectRelay($pb.ClientContext? ctx, SelectRelayRequest request) =>
    _client.invoke<SelectRelayResponse>(ctx, 'ProtectionService', 'SelectRelay', request, SelectRelayResponse())
  ;
  $async.Future<ComputeRelaySettingsResponse> computeRelaySettings($pb.ClientContext? ctx, ComputeRelaySettingsRequest request) =>
    _client.invoke<ComputeRelaySettingsResponse>(ctx, 'ProtectionService', 'ComputeRelaySettings', request, ComputeRelaySettingsResponse())
  ;
  /// Coordination check across upstream/downstream hierarchy
  $async.Future<ValidateCoordinationResponse> validateCoordination($pb.ClientContext? ctx, ValidateCoordinationRequest request) =>
    _client.invoke<ValidateCoordinationResponse>(ctx, 'ProtectionService', 'ValidateCoordination', request, ValidateCoordinationResponse())
  ;
  /// Plain-text protection study report
  $async.Future<GenerateProtectionReportResponse> generateProtectionReport($pb.ClientContext? ctx, GenerateProtectionReportRequest request) =>
    _client.invoke<GenerateProtectionReportResponse>(ctx, 'ProtectionService', 'GenerateProtectionReport', request, GenerateProtectionReportResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
