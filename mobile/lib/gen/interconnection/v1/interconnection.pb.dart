//
//  Generated code. Do not modify.
//  source: interconnection/v1/interconnection.proto
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

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class POI extends $pb.GeneratedMessage {
  factory POI({
    $core.String? id,
    $core.String? projectId,
    $core.String? utilityName,
    $core.String? feederId,
    $core.double? latitude,
    $core.double? longitude,
    $core.double? voltageKv,
    $core.double? availableCapacityMva,
    $core.double? faultCurrentKa,
    $core.String? interconnectionType,
    $0.Timestamp? createdAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (utilityName != null) {
      $result.utilityName = utilityName;
    }
    if (feederId != null) {
      $result.feederId = feederId;
    }
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (longitude != null) {
      $result.longitude = longitude;
    }
    if (voltageKv != null) {
      $result.voltageKv = voltageKv;
    }
    if (availableCapacityMva != null) {
      $result.availableCapacityMva = availableCapacityMva;
    }
    if (faultCurrentKa != null) {
      $result.faultCurrentKa = faultCurrentKa;
    }
    if (interconnectionType != null) {
      $result.interconnectionType = interconnectionType;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    return $result;
  }
  POI._() : super();
  factory POI.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory POI.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'POI', package: const $pb.PackageName(_omitMessageNames ? '' : 'interconnection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..aOS(3, _omitFieldNames ? '' : 'utilityName')
    ..aOS(4, _omitFieldNames ? '' : 'feederId')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'voltageKv', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'availableCapacityMva', $pb.PbFieldType.OD)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'faultCurrentKa', $pb.PbFieldType.OD)
    ..aOS(10, _omitFieldNames ? '' : 'interconnectionType')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  POI clone() => POI()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  POI copyWith(void Function(POI) updates) => super.copyWith((message) => updates(message as POI)) as POI;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static POI create() => POI._();
  POI createEmptyInstance() => create();
  static $pb.PbList<POI> createRepeated() => $pb.PbList<POI>();
  @$core.pragma('dart2js:noInline')
  static POI getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<POI>(create);
  static POI? _defaultInstance;

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
  $core.String get utilityName => $_getSZ(2);
  @$pb.TagNumber(3)
  set utilityName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUtilityName() => $_has(2);
  @$pb.TagNumber(3)
  void clearUtilityName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get feederId => $_getSZ(3);
  @$pb.TagNumber(4)
  set feederId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasFeederId() => $_has(3);
  @$pb.TagNumber(4)
  void clearFeederId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get latitude => $_getN(4);
  @$pb.TagNumber(5)
  set latitude($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasLatitude() => $_has(4);
  @$pb.TagNumber(5)
  void clearLatitude() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get longitude => $_getN(5);
  @$pb.TagNumber(6)
  set longitude($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLongitude() => $_has(5);
  @$pb.TagNumber(6)
  void clearLongitude() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get voltageKv => $_getN(6);
  @$pb.TagNumber(7)
  set voltageKv($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasVoltageKv() => $_has(6);
  @$pb.TagNumber(7)
  void clearVoltageKv() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get availableCapacityMva => $_getN(7);
  @$pb.TagNumber(8)
  set availableCapacityMva($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasAvailableCapacityMva() => $_has(7);
  @$pb.TagNumber(8)
  void clearAvailableCapacityMva() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get faultCurrentKa => $_getN(8);
  @$pb.TagNumber(9)
  set faultCurrentKa($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasFaultCurrentKa() => $_has(8);
  @$pb.TagNumber(9)
  void clearFaultCurrentKa() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get interconnectionType => $_getSZ(9);
  @$pb.TagNumber(10)
  set interconnectionType($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasInterconnectionType() => $_has(9);
  @$pb.TagNumber(10)
  void clearInterconnectionType() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Timestamp get createdAt => $_getN(10);
  @$pb.TagNumber(11)
  set createdAt($0.Timestamp v) { $_setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasCreatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearCreatedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureCreatedAt() => $_ensure(10);
}

class TransformerSizing extends $pb.GeneratedMessage {
  factory TransformerSizing({
    $core.double? recommendedKva,
    $core.double? primaryVoltageV,
    $core.double? secondaryVoltageV,
    $core.double? impedancePct,
    $core.String? configuration,
    $core.double? lossesKw,
  }) {
    final $result = create();
    if (recommendedKva != null) {
      $result.recommendedKva = recommendedKva;
    }
    if (primaryVoltageV != null) {
      $result.primaryVoltageV = primaryVoltageV;
    }
    if (secondaryVoltageV != null) {
      $result.secondaryVoltageV = secondaryVoltageV;
    }
    if (impedancePct != null) {
      $result.impedancePct = impedancePct;
    }
    if (configuration != null) {
      $result.configuration = configuration;
    }
    if (lossesKw != null) {
      $result.lossesKw = lossesKw;
    }
    return $result;
  }
  TransformerSizing._() : super();
  factory TransformerSizing.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TransformerSizing.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TransformerSizing', package: const $pb.PackageName(_omitMessageNames ? '' : 'interconnection.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'recommendedKva', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'primaryVoltageV', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'secondaryVoltageV', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'impedancePct', $pb.PbFieldType.OD)
    ..aOS(5, _omitFieldNames ? '' : 'configuration')
    ..a<$core.double>(6, _omitFieldNames ? '' : 'lossesKw', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TransformerSizing clone() => TransformerSizing()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TransformerSizing copyWith(void Function(TransformerSizing) updates) => super.copyWith((message) => updates(message as TransformerSizing)) as TransformerSizing;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransformerSizing create() => TransformerSizing._();
  TransformerSizing createEmptyInstance() => create();
  static $pb.PbList<TransformerSizing> createRepeated() => $pb.PbList<TransformerSizing>();
  @$core.pragma('dart2js:noInline')
  static TransformerSizing getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TransformerSizing>(create);
  static TransformerSizing? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get recommendedKva => $_getN(0);
  @$pb.TagNumber(1)
  set recommendedKva($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRecommendedKva() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecommendedKva() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get primaryVoltageV => $_getN(1);
  @$pb.TagNumber(2)
  set primaryVoltageV($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPrimaryVoltageV() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrimaryVoltageV() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get secondaryVoltageV => $_getN(2);
  @$pb.TagNumber(3)
  set secondaryVoltageV($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSecondaryVoltageV() => $_has(2);
  @$pb.TagNumber(3)
  void clearSecondaryVoltageV() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get impedancePct => $_getN(3);
  @$pb.TagNumber(4)
  set impedancePct($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasImpedancePct() => $_has(3);
  @$pb.TagNumber(4)
  void clearImpedancePct() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get configuration => $_getSZ(4);
  @$pb.TagNumber(5)
  set configuration($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasConfiguration() => $_has(4);
  @$pb.TagNumber(5)
  void clearConfiguration() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get lossesKw => $_getN(5);
  @$pb.TagNumber(6)
  set lossesKw($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLossesKw() => $_has(5);
  @$pb.TagNumber(6)
  void clearLossesKw() => $_clearField(6);
}

class ReactivePowerResult extends $pb.GeneratedMessage {
  factory ReactivePowerResult({
    $core.double? powerFactor,
    $core.double? reactivePowerKvar,
    $core.double? voltageRisePct,
    $core.bool? requiresCompensation,
    $core.double? recommendedCapacitorKvar,
    $core.String? ieee1547Category,
  }) {
    final $result = create();
    if (powerFactor != null) {
      $result.powerFactor = powerFactor;
    }
    if (reactivePowerKvar != null) {
      $result.reactivePowerKvar = reactivePowerKvar;
    }
    if (voltageRisePct != null) {
      $result.voltageRisePct = voltageRisePct;
    }
    if (requiresCompensation != null) {
      $result.requiresCompensation = requiresCompensation;
    }
    if (recommendedCapacitorKvar != null) {
      $result.recommendedCapacitorKvar = recommendedCapacitorKvar;
    }
    if (ieee1547Category != null) {
      $result.ieee1547Category = ieee1547Category;
    }
    return $result;
  }
  ReactivePowerResult._() : super();
  factory ReactivePowerResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReactivePowerResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReactivePowerResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'interconnection.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'powerFactor', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'reactivePowerKvar', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'voltageRisePct', $pb.PbFieldType.OD)
    ..aOB(4, _omitFieldNames ? '' : 'requiresCompensation')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'recommendedCapacitorKvar', $pb.PbFieldType.OD)
    ..aOS(6, _omitFieldNames ? '' : 'ieee1547Category')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReactivePowerResult clone() => ReactivePowerResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReactivePowerResult copyWith(void Function(ReactivePowerResult) updates) => super.copyWith((message) => updates(message as ReactivePowerResult)) as ReactivePowerResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReactivePowerResult create() => ReactivePowerResult._();
  ReactivePowerResult createEmptyInstance() => create();
  static $pb.PbList<ReactivePowerResult> createRepeated() => $pb.PbList<ReactivePowerResult>();
  @$core.pragma('dart2js:noInline')
  static ReactivePowerResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReactivePowerResult>(create);
  static ReactivePowerResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get powerFactor => $_getN(0);
  @$pb.TagNumber(1)
  set powerFactor($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPowerFactor() => $_has(0);
  @$pb.TagNumber(1)
  void clearPowerFactor() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get reactivePowerKvar => $_getN(1);
  @$pb.TagNumber(2)
  set reactivePowerKvar($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReactivePowerKvar() => $_has(1);
  @$pb.TagNumber(2)
  void clearReactivePowerKvar() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get voltageRisePct => $_getN(2);
  @$pb.TagNumber(3)
  set voltageRisePct($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasVoltageRisePct() => $_has(2);
  @$pb.TagNumber(3)
  void clearVoltageRisePct() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get requiresCompensation => $_getBF(3);
  @$pb.TagNumber(4)
  set requiresCompensation($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRequiresCompensation() => $_has(3);
  @$pb.TagNumber(4)
  void clearRequiresCompensation() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get recommendedCapacitorKvar => $_getN(4);
  @$pb.TagNumber(5)
  set recommendedCapacitorKvar($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRecommendedCapacitorKvar() => $_has(4);
  @$pb.TagNumber(5)
  void clearRecommendedCapacitorKvar() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get ieee1547Category => $_getSZ(5);
  @$pb.TagNumber(6)
  set ieee1547Category($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasIeee1547Category() => $_has(5);
  @$pb.TagNumber(6)
  void clearIeee1547Category() => $_clearField(6);
}

class ApplicationForm extends $pb.GeneratedMessage {
  factory ApplicationForm({
    $core.String? formType,
    $core.String? contentText,
    $core.List<$core.int>? contentPdf,
    $core.Iterable<$core.String>? requiredDocuments,
  }) {
    final $result = create();
    if (formType != null) {
      $result.formType = formType;
    }
    if (contentText != null) {
      $result.contentText = contentText;
    }
    if (contentPdf != null) {
      $result.contentPdf = contentPdf;
    }
    if (requiredDocuments != null) {
      $result.requiredDocuments.addAll(requiredDocuments);
    }
    return $result;
  }
  ApplicationForm._() : super();
  factory ApplicationForm.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApplicationForm.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApplicationForm', package: const $pb.PackageName(_omitMessageNames ? '' : 'interconnection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'formType')
    ..aOS(2, _omitFieldNames ? '' : 'contentText')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'contentPdf', $pb.PbFieldType.OY)
    ..pPS(4, _omitFieldNames ? '' : 'requiredDocuments')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApplicationForm clone() => ApplicationForm()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApplicationForm copyWith(void Function(ApplicationForm) updates) => super.copyWith((message) => updates(message as ApplicationForm)) as ApplicationForm;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplicationForm create() => ApplicationForm._();
  ApplicationForm createEmptyInstance() => create();
  static $pb.PbList<ApplicationForm> createRepeated() => $pb.PbList<ApplicationForm>();
  @$core.pragma('dart2js:noInline')
  static ApplicationForm getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApplicationForm>(create);
  static ApplicationForm? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get formType => $_getSZ(0);
  @$pb.TagNumber(1)
  set formType($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFormType() => $_has(0);
  @$pb.TagNumber(1)
  void clearFormType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get contentText => $_getSZ(1);
  @$pb.TagNumber(2)
  set contentText($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasContentText() => $_has(1);
  @$pb.TagNumber(2)
  void clearContentText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get contentPdf => $_getN(2);
  @$pb.TagNumber(3)
  set contentPdf($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasContentPdf() => $_has(2);
  @$pb.TagNumber(3)
  void clearContentPdf() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get requiredDocuments => $_getList(3);
}

class CreatePOIRequest extends $pb.GeneratedMessage {
  factory CreatePOIRequest({
    $core.String? projectId,
    $core.String? utilityName,
    $core.String? feederId,
    $core.double? latitude,
    $core.double? longitude,
    $core.double? voltageKv,
    $core.double? availableCapacityMva,
    $core.double? faultCurrentKa,
    $core.String? interconnectionType,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (utilityName != null) {
      $result.utilityName = utilityName;
    }
    if (feederId != null) {
      $result.feederId = feederId;
    }
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (longitude != null) {
      $result.longitude = longitude;
    }
    if (voltageKv != null) {
      $result.voltageKv = voltageKv;
    }
    if (availableCapacityMva != null) {
      $result.availableCapacityMva = availableCapacityMva;
    }
    if (faultCurrentKa != null) {
      $result.faultCurrentKa = faultCurrentKa;
    }
    if (interconnectionType != null) {
      $result.interconnectionType = interconnectionType;
    }
    return $result;
  }
  CreatePOIRequest._() : super();
  factory CreatePOIRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreatePOIRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreatePOIRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'interconnection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'utilityName')
    ..aOS(3, _omitFieldNames ? '' : 'feederId')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'voltageKv', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'availableCapacityMva', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'faultCurrentKa', $pb.PbFieldType.OD)
    ..aOS(9, _omitFieldNames ? '' : 'interconnectionType')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreatePOIRequest clone() => CreatePOIRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreatePOIRequest copyWith(void Function(CreatePOIRequest) updates) => super.copyWith((message) => updates(message as CreatePOIRequest)) as CreatePOIRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreatePOIRequest create() => CreatePOIRequest._();
  CreatePOIRequest createEmptyInstance() => create();
  static $pb.PbList<CreatePOIRequest> createRepeated() => $pb.PbList<CreatePOIRequest>();
  @$core.pragma('dart2js:noInline')
  static CreatePOIRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreatePOIRequest>(create);
  static CreatePOIRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get utilityName => $_getSZ(1);
  @$pb.TagNumber(2)
  set utilityName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUtilityName() => $_has(1);
  @$pb.TagNumber(2)
  void clearUtilityName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get feederId => $_getSZ(2);
  @$pb.TagNumber(3)
  set feederId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFeederId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFeederId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get latitude => $_getN(3);
  @$pb.TagNumber(4)
  set latitude($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasLatitude() => $_has(3);
  @$pb.TagNumber(4)
  void clearLatitude() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get longitude => $_getN(4);
  @$pb.TagNumber(5)
  set longitude($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasLongitude() => $_has(4);
  @$pb.TagNumber(5)
  void clearLongitude() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get voltageKv => $_getN(5);
  @$pb.TagNumber(6)
  set voltageKv($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasVoltageKv() => $_has(5);
  @$pb.TagNumber(6)
  void clearVoltageKv() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get availableCapacityMva => $_getN(6);
  @$pb.TagNumber(7)
  set availableCapacityMva($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasAvailableCapacityMva() => $_has(6);
  @$pb.TagNumber(7)
  void clearAvailableCapacityMva() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get faultCurrentKa => $_getN(7);
  @$pb.TagNumber(8)
  set faultCurrentKa($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasFaultCurrentKa() => $_has(7);
  @$pb.TagNumber(8)
  void clearFaultCurrentKa() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get interconnectionType => $_getSZ(8);
  @$pb.TagNumber(9)
  set interconnectionType($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasInterconnectionType() => $_has(8);
  @$pb.TagNumber(9)
  void clearInterconnectionType() => $_clearField(9);
}

class CreatePOIResponse extends $pb.GeneratedMessage {
  factory CreatePOIResponse({
    POI? poi,
  }) {
    final $result = create();
    if (poi != null) {
      $result.poi = poi;
    }
    return $result;
  }
  CreatePOIResponse._() : super();
  factory CreatePOIResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreatePOIResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreatePOIResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'interconnection.v1'), createEmptyInstance: create)
    ..aOM<POI>(1, _omitFieldNames ? '' : 'poi', subBuilder: POI.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreatePOIResponse clone() => CreatePOIResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreatePOIResponse copyWith(void Function(CreatePOIResponse) updates) => super.copyWith((message) => updates(message as CreatePOIResponse)) as CreatePOIResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreatePOIResponse create() => CreatePOIResponse._();
  CreatePOIResponse createEmptyInstance() => create();
  static $pb.PbList<CreatePOIResponse> createRepeated() => $pb.PbList<CreatePOIResponse>();
  @$core.pragma('dart2js:noInline')
  static CreatePOIResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreatePOIResponse>(create);
  static CreatePOIResponse? _defaultInstance;

  @$pb.TagNumber(1)
  POI get poi => $_getN(0);
  @$pb.TagNumber(1)
  set poi(POI v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPoi() => $_has(0);
  @$pb.TagNumber(1)
  void clearPoi() => $_clearField(1);
  @$pb.TagNumber(1)
  POI ensurePoi() => $_ensure(0);
}

class GetPOIRequest extends $pb.GeneratedMessage {
  factory GetPOIRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  GetPOIRequest._() : super();
  factory GetPOIRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetPOIRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetPOIRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'interconnection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetPOIRequest clone() => GetPOIRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetPOIRequest copyWith(void Function(GetPOIRequest) updates) => super.copyWith((message) => updates(message as GetPOIRequest)) as GetPOIRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPOIRequest create() => GetPOIRequest._();
  GetPOIRequest createEmptyInstance() => create();
  static $pb.PbList<GetPOIRequest> createRepeated() => $pb.PbList<GetPOIRequest>();
  @$core.pragma('dart2js:noInline')
  static GetPOIRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetPOIRequest>(create);
  static GetPOIRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class GetPOIResponse extends $pb.GeneratedMessage {
  factory GetPOIResponse({
    POI? poi,
  }) {
    final $result = create();
    if (poi != null) {
      $result.poi = poi;
    }
    return $result;
  }
  GetPOIResponse._() : super();
  factory GetPOIResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetPOIResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetPOIResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'interconnection.v1'), createEmptyInstance: create)
    ..aOM<POI>(1, _omitFieldNames ? '' : 'poi', subBuilder: POI.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetPOIResponse clone() => GetPOIResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetPOIResponse copyWith(void Function(GetPOIResponse) updates) => super.copyWith((message) => updates(message as GetPOIResponse)) as GetPOIResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPOIResponse create() => GetPOIResponse._();
  GetPOIResponse createEmptyInstance() => create();
  static $pb.PbList<GetPOIResponse> createRepeated() => $pb.PbList<GetPOIResponse>();
  @$core.pragma('dart2js:noInline')
  static GetPOIResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetPOIResponse>(create);
  static GetPOIResponse? _defaultInstance;

  @$pb.TagNumber(1)
  POI get poi => $_getN(0);
  @$pb.TagNumber(1)
  set poi(POI v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPoi() => $_has(0);
  @$pb.TagNumber(1)
  void clearPoi() => $_clearField(1);
  @$pb.TagNumber(1)
  POI ensurePoi() => $_ensure(0);
}

class ListPOIsRequest extends $pb.GeneratedMessage {
  factory ListPOIsRequest({
    $core.String? projectId,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    return $result;
  }
  ListPOIsRequest._() : super();
  factory ListPOIsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListPOIsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListPOIsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'interconnection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListPOIsRequest clone() => ListPOIsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListPOIsRequest copyWith(void Function(ListPOIsRequest) updates) => super.copyWith((message) => updates(message as ListPOIsRequest)) as ListPOIsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPOIsRequest create() => ListPOIsRequest._();
  ListPOIsRequest createEmptyInstance() => create();
  static $pb.PbList<ListPOIsRequest> createRepeated() => $pb.PbList<ListPOIsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListPOIsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListPOIsRequest>(create);
  static ListPOIsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);
}

class ListPOIsResponse extends $pb.GeneratedMessage {
  factory ListPOIsResponse({
    $core.Iterable<POI>? pois,
  }) {
    final $result = create();
    if (pois != null) {
      $result.pois.addAll(pois);
    }
    return $result;
  }
  ListPOIsResponse._() : super();
  factory ListPOIsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListPOIsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListPOIsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'interconnection.v1'), createEmptyInstance: create)
    ..pc<POI>(1, _omitFieldNames ? '' : 'pois', $pb.PbFieldType.PM, subBuilder: POI.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListPOIsResponse clone() => ListPOIsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListPOIsResponse copyWith(void Function(ListPOIsResponse) updates) => super.copyWith((message) => updates(message as ListPOIsResponse)) as ListPOIsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPOIsResponse create() => ListPOIsResponse._();
  ListPOIsResponse createEmptyInstance() => create();
  static $pb.PbList<ListPOIsResponse> createRepeated() => $pb.PbList<ListPOIsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListPOIsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListPOIsResponse>(create);
  static ListPOIsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<POI> get pois => $_getList(0);
}

class SizeTransformerRequest extends $pb.GeneratedMessage {
  factory SizeTransformerRequest({
    $core.String? poiId,
    $core.double? plantAcKw,
    $core.double? plantVoltageV,
  }) {
    final $result = create();
    if (poiId != null) {
      $result.poiId = poiId;
    }
    if (plantAcKw != null) {
      $result.plantAcKw = plantAcKw;
    }
    if (plantVoltageV != null) {
      $result.plantVoltageV = plantVoltageV;
    }
    return $result;
  }
  SizeTransformerRequest._() : super();
  factory SizeTransformerRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SizeTransformerRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SizeTransformerRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'interconnection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'poiId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'plantAcKw', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'plantVoltageV', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SizeTransformerRequest clone() => SizeTransformerRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SizeTransformerRequest copyWith(void Function(SizeTransformerRequest) updates) => super.copyWith((message) => updates(message as SizeTransformerRequest)) as SizeTransformerRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SizeTransformerRequest create() => SizeTransformerRequest._();
  SizeTransformerRequest createEmptyInstance() => create();
  static $pb.PbList<SizeTransformerRequest> createRepeated() => $pb.PbList<SizeTransformerRequest>();
  @$core.pragma('dart2js:noInline')
  static SizeTransformerRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SizeTransformerRequest>(create);
  static SizeTransformerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get poiId => $_getSZ(0);
  @$pb.TagNumber(1)
  set poiId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPoiId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPoiId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get plantAcKw => $_getN(1);
  @$pb.TagNumber(2)
  set plantAcKw($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPlantAcKw() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlantAcKw() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get plantVoltageV => $_getN(2);
  @$pb.TagNumber(3)
  set plantVoltageV($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPlantVoltageV() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlantVoltageV() => $_clearField(3);
}

class SizeTransformerResponse extends $pb.GeneratedMessage {
  factory SizeTransformerResponse({
    TransformerSizing? sizing,
  }) {
    final $result = create();
    if (sizing != null) {
      $result.sizing = sizing;
    }
    return $result;
  }
  SizeTransformerResponse._() : super();
  factory SizeTransformerResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SizeTransformerResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SizeTransformerResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'interconnection.v1'), createEmptyInstance: create)
    ..aOM<TransformerSizing>(1, _omitFieldNames ? '' : 'sizing', subBuilder: TransformerSizing.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SizeTransformerResponse clone() => SizeTransformerResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SizeTransformerResponse copyWith(void Function(SizeTransformerResponse) updates) => super.copyWith((message) => updates(message as SizeTransformerResponse)) as SizeTransformerResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SizeTransformerResponse create() => SizeTransformerResponse._();
  SizeTransformerResponse createEmptyInstance() => create();
  static $pb.PbList<SizeTransformerResponse> createRepeated() => $pb.PbList<SizeTransformerResponse>();
  @$core.pragma('dart2js:noInline')
  static SizeTransformerResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SizeTransformerResponse>(create);
  static SizeTransformerResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TransformerSizing get sizing => $_getN(0);
  @$pb.TagNumber(1)
  set sizing(TransformerSizing v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSizing() => $_has(0);
  @$pb.TagNumber(1)
  void clearSizing() => $_clearField(1);
  @$pb.TagNumber(1)
  TransformerSizing ensureSizing() => $_ensure(0);
}

class ReactivePowerStudyRequest extends $pb.GeneratedMessage {
  factory ReactivePowerStudyRequest({
    $core.String? poiId,
    $core.double? plantAcKw,
    $core.double? inverterPowerFactor,
    $core.double? lineImpedanceOhm,
  }) {
    final $result = create();
    if (poiId != null) {
      $result.poiId = poiId;
    }
    if (plantAcKw != null) {
      $result.plantAcKw = plantAcKw;
    }
    if (inverterPowerFactor != null) {
      $result.inverterPowerFactor = inverterPowerFactor;
    }
    if (lineImpedanceOhm != null) {
      $result.lineImpedanceOhm = lineImpedanceOhm;
    }
    return $result;
  }
  ReactivePowerStudyRequest._() : super();
  factory ReactivePowerStudyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReactivePowerStudyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReactivePowerStudyRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'interconnection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'poiId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'plantAcKw', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'inverterPowerFactor', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'lineImpedanceOhm', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReactivePowerStudyRequest clone() => ReactivePowerStudyRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReactivePowerStudyRequest copyWith(void Function(ReactivePowerStudyRequest) updates) => super.copyWith((message) => updates(message as ReactivePowerStudyRequest)) as ReactivePowerStudyRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReactivePowerStudyRequest create() => ReactivePowerStudyRequest._();
  ReactivePowerStudyRequest createEmptyInstance() => create();
  static $pb.PbList<ReactivePowerStudyRequest> createRepeated() => $pb.PbList<ReactivePowerStudyRequest>();
  @$core.pragma('dart2js:noInline')
  static ReactivePowerStudyRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReactivePowerStudyRequest>(create);
  static ReactivePowerStudyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get poiId => $_getSZ(0);
  @$pb.TagNumber(1)
  set poiId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPoiId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPoiId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get plantAcKw => $_getN(1);
  @$pb.TagNumber(2)
  set plantAcKw($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPlantAcKw() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlantAcKw() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get inverterPowerFactor => $_getN(2);
  @$pb.TagNumber(3)
  set inverterPowerFactor($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasInverterPowerFactor() => $_has(2);
  @$pb.TagNumber(3)
  void clearInverterPowerFactor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get lineImpedanceOhm => $_getN(3);
  @$pb.TagNumber(4)
  set lineImpedanceOhm($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasLineImpedanceOhm() => $_has(3);
  @$pb.TagNumber(4)
  void clearLineImpedanceOhm() => $_clearField(4);
}

class ReactivePowerStudyResponse extends $pb.GeneratedMessage {
  factory ReactivePowerStudyResponse({
    ReactivePowerResult? result,
  }) {
    final $result = create();
    if (result != null) {
      $result.result = result;
    }
    return $result;
  }
  ReactivePowerStudyResponse._() : super();
  factory ReactivePowerStudyResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReactivePowerStudyResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReactivePowerStudyResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'interconnection.v1'), createEmptyInstance: create)
    ..aOM<ReactivePowerResult>(1, _omitFieldNames ? '' : 'result', subBuilder: ReactivePowerResult.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReactivePowerStudyResponse clone() => ReactivePowerStudyResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReactivePowerStudyResponse copyWith(void Function(ReactivePowerStudyResponse) updates) => super.copyWith((message) => updates(message as ReactivePowerStudyResponse)) as ReactivePowerStudyResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReactivePowerStudyResponse create() => ReactivePowerStudyResponse._();
  ReactivePowerStudyResponse createEmptyInstance() => create();
  static $pb.PbList<ReactivePowerStudyResponse> createRepeated() => $pb.PbList<ReactivePowerStudyResponse>();
  @$core.pragma('dart2js:noInline')
  static ReactivePowerStudyResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReactivePowerStudyResponse>(create);
  static ReactivePowerStudyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ReactivePowerResult get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(ReactivePowerResult v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => $_clearField(1);
  @$pb.TagNumber(1)
  ReactivePowerResult ensureResult() => $_ensure(0);
}

class GenerateApplicationFormRequest extends $pb.GeneratedMessage {
  factory GenerateApplicationFormRequest({
    $core.String? poiId,
    $core.String? formType,
    $core.String? applicantName,
    $core.String? applicantAddress,
    $core.double? systemCapacityKw,
  }) {
    final $result = create();
    if (poiId != null) {
      $result.poiId = poiId;
    }
    if (formType != null) {
      $result.formType = formType;
    }
    if (applicantName != null) {
      $result.applicantName = applicantName;
    }
    if (applicantAddress != null) {
      $result.applicantAddress = applicantAddress;
    }
    if (systemCapacityKw != null) {
      $result.systemCapacityKw = systemCapacityKw;
    }
    return $result;
  }
  GenerateApplicationFormRequest._() : super();
  factory GenerateApplicationFormRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenerateApplicationFormRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GenerateApplicationFormRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'interconnection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'poiId')
    ..aOS(2, _omitFieldNames ? '' : 'formType')
    ..aOS(3, _omitFieldNames ? '' : 'applicantName')
    ..aOS(4, _omitFieldNames ? '' : 'applicantAddress')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'systemCapacityKw', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenerateApplicationFormRequest clone() => GenerateApplicationFormRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenerateApplicationFormRequest copyWith(void Function(GenerateApplicationFormRequest) updates) => super.copyWith((message) => updates(message as GenerateApplicationFormRequest)) as GenerateApplicationFormRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenerateApplicationFormRequest create() => GenerateApplicationFormRequest._();
  GenerateApplicationFormRequest createEmptyInstance() => create();
  static $pb.PbList<GenerateApplicationFormRequest> createRepeated() => $pb.PbList<GenerateApplicationFormRequest>();
  @$core.pragma('dart2js:noInline')
  static GenerateApplicationFormRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenerateApplicationFormRequest>(create);
  static GenerateApplicationFormRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get poiId => $_getSZ(0);
  @$pb.TagNumber(1)
  set poiId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPoiId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPoiId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get formType => $_getSZ(1);
  @$pb.TagNumber(2)
  set formType($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFormType() => $_has(1);
  @$pb.TagNumber(2)
  void clearFormType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get applicantName => $_getSZ(2);
  @$pb.TagNumber(3)
  set applicantName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasApplicantName() => $_has(2);
  @$pb.TagNumber(3)
  void clearApplicantName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get applicantAddress => $_getSZ(3);
  @$pb.TagNumber(4)
  set applicantAddress($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasApplicantAddress() => $_has(3);
  @$pb.TagNumber(4)
  void clearApplicantAddress() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get systemCapacityKw => $_getN(4);
  @$pb.TagNumber(5)
  set systemCapacityKw($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSystemCapacityKw() => $_has(4);
  @$pb.TagNumber(5)
  void clearSystemCapacityKw() => $_clearField(5);
}

class GenerateApplicationFormResponse extends $pb.GeneratedMessage {
  factory GenerateApplicationFormResponse({
    ApplicationForm? form,
  }) {
    final $result = create();
    if (form != null) {
      $result.form = form;
    }
    return $result;
  }
  GenerateApplicationFormResponse._() : super();
  factory GenerateApplicationFormResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenerateApplicationFormResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GenerateApplicationFormResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'interconnection.v1'), createEmptyInstance: create)
    ..aOM<ApplicationForm>(1, _omitFieldNames ? '' : 'form', subBuilder: ApplicationForm.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenerateApplicationFormResponse clone() => GenerateApplicationFormResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenerateApplicationFormResponse copyWith(void Function(GenerateApplicationFormResponse) updates) => super.copyWith((message) => updates(message as GenerateApplicationFormResponse)) as GenerateApplicationFormResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenerateApplicationFormResponse create() => GenerateApplicationFormResponse._();
  GenerateApplicationFormResponse createEmptyInstance() => create();
  static $pb.PbList<GenerateApplicationFormResponse> createRepeated() => $pb.PbList<GenerateApplicationFormResponse>();
  @$core.pragma('dart2js:noInline')
  static GenerateApplicationFormResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenerateApplicationFormResponse>(create);
  static GenerateApplicationFormResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ApplicationForm get form => $_getN(0);
  @$pb.TagNumber(1)
  set form(ApplicationForm v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasForm() => $_has(0);
  @$pb.TagNumber(1)
  void clearForm() => $_clearField(1);
  @$pb.TagNumber(1)
  ApplicationForm ensureForm() => $_ensure(0);
}

class DeletePOIRequest extends $pb.GeneratedMessage {
  factory DeletePOIRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  DeletePOIRequest._() : super();
  factory DeletePOIRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeletePOIRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeletePOIRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'interconnection.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeletePOIRequest clone() => DeletePOIRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeletePOIRequest copyWith(void Function(DeletePOIRequest) updates) => super.copyWith((message) => updates(message as DeletePOIRequest)) as DeletePOIRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeletePOIRequest create() => DeletePOIRequest._();
  DeletePOIRequest createEmptyInstance() => create();
  static $pb.PbList<DeletePOIRequest> createRepeated() => $pb.PbList<DeletePOIRequest>();
  @$core.pragma('dart2js:noInline')
  static DeletePOIRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeletePOIRequest>(create);
  static DeletePOIRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class DeletePOIResponse extends $pb.GeneratedMessage {
  factory DeletePOIResponse() => create();
  DeletePOIResponse._() : super();
  factory DeletePOIResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeletePOIResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeletePOIResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'interconnection.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeletePOIResponse clone() => DeletePOIResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeletePOIResponse copyWith(void Function(DeletePOIResponse) updates) => super.copyWith((message) => updates(message as DeletePOIResponse)) as DeletePOIResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeletePOIResponse create() => DeletePOIResponse._();
  DeletePOIResponse createEmptyInstance() => create();
  static $pb.PbList<DeletePOIResponse> createRepeated() => $pb.PbList<DeletePOIResponse>();
  @$core.pragma('dart2js:noInline')
  static DeletePOIResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeletePOIResponse>(create);
  static DeletePOIResponse? _defaultInstance;
}

/// InterconnectionService manages utility Point of Interconnection (POI)
/// modeling, transformer/substation sizing, reactive power studies, and
/// interconnection application form generation.
class InterconnectionServiceApi {
  $pb.RpcClient _client;
  InterconnectionServiceApi(this._client);

  $async.Future<CreatePOIResponse> createPOI($pb.ClientContext? ctx, CreatePOIRequest request) =>
    _client.invoke<CreatePOIResponse>(ctx, 'InterconnectionService', 'CreatePOI', request, CreatePOIResponse())
  ;
  $async.Future<GetPOIResponse> getPOI($pb.ClientContext? ctx, GetPOIRequest request) =>
    _client.invoke<GetPOIResponse>(ctx, 'InterconnectionService', 'GetPOI', request, GetPOIResponse())
  ;
  $async.Future<ListPOIsResponse> listPOIs($pb.ClientContext? ctx, ListPOIsRequest request) =>
    _client.invoke<ListPOIsResponse>(ctx, 'InterconnectionService', 'ListPOIs', request, ListPOIsResponse())
  ;
  $async.Future<SizeTransformerResponse> sizeTransformer($pb.ClientContext? ctx, SizeTransformerRequest request) =>
    _client.invoke<SizeTransformerResponse>(ctx, 'InterconnectionService', 'SizeTransformer', request, SizeTransformerResponse())
  ;
  $async.Future<ReactivePowerStudyResponse> reactivePowerStudy($pb.ClientContext? ctx, ReactivePowerStudyRequest request) =>
    _client.invoke<ReactivePowerStudyResponse>(ctx, 'InterconnectionService', 'ReactivePowerStudy', request, ReactivePowerStudyResponse())
  ;
  $async.Future<GenerateApplicationFormResponse> generateApplicationForm($pb.ClientContext? ctx, GenerateApplicationFormRequest request) =>
    _client.invoke<GenerateApplicationFormResponse>(ctx, 'InterconnectionService', 'GenerateApplicationForm', request, GenerateApplicationFormResponse())
  ;
  $async.Future<DeletePOIResponse> deletePOI($pb.ClientContext? ctx, DeletePOIRequest request) =>
    _client.invoke<DeletePOIResponse>(ctx, 'InterconnectionService', 'DeletePOI', request, DeletePOIResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
