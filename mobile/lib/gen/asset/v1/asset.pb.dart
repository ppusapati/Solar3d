//
//  Generated code. Do not modify.
//  source: asset/v1/asset.proto
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
import '../../packages/pagination.pb.dart' as $1;
import 'asset.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'asset.pbenum.dart';

class Asset extends $pb.GeneratedMessage {
  factory Asset({
    $core.String? id,
    $core.String? name,
    $core.String? manufacturer,
    $core.String? model,
    AssetCategory? category,
    Dimensions? dimensions,
    ElectricalParameters? electrical,
    $core.String? model3dPath,
    $core.String? datasheetPath,
    $core.String? metadataJson,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    if (manufacturer != null) {
      $result.manufacturer = manufacturer;
    }
    if (model != null) {
      $result.model = model;
    }
    if (category != null) {
      $result.category = category;
    }
    if (dimensions != null) {
      $result.dimensions = dimensions;
    }
    if (electrical != null) {
      $result.electrical = electrical;
    }
    if (model3dPath != null) {
      $result.model3dPath = model3dPath;
    }
    if (datasheetPath != null) {
      $result.datasheetPath = datasheetPath;
    }
    if (metadataJson != null) {
      $result.metadataJson = metadataJson;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      $result.updatedAt = updatedAt;
    }
    return $result;
  }
  Asset._() : super();
  factory Asset.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Asset.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Asset', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'manufacturer')
    ..aOS(4, _omitFieldNames ? '' : 'model')
    ..e<AssetCategory>(5, _omitFieldNames ? '' : 'category', $pb.PbFieldType.OE, defaultOrMaker: AssetCategory.ASSET_CATEGORY_UNSPECIFIED, valueOf: AssetCategory.valueOf, enumValues: AssetCategory.values)
    ..aOM<Dimensions>(6, _omitFieldNames ? '' : 'dimensions', subBuilder: Dimensions.create)
    ..aOM<ElectricalParameters>(7, _omitFieldNames ? '' : 'electrical', subBuilder: ElectricalParameters.create)
    ..aOS(8, _omitFieldNames ? '' : 'model3dPath', protoName: 'model_3d_path')
    ..aOS(9, _omitFieldNames ? '' : 'datasheetPath')
    ..aOS(10, _omitFieldNames ? '' : 'metadataJson')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'updatedAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Asset clone() => Asset()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Asset copyWith(void Function(Asset) updates) => super.copyWith((message) => updates(message as Asset)) as Asset;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Asset create() => Asset._();
  Asset createEmptyInstance() => create();
  static $pb.PbList<Asset> createRepeated() => $pb.PbList<Asset>();
  @$core.pragma('dart2js:noInline')
  static Asset getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Asset>(create);
  static Asset? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get manufacturer => $_getSZ(2);
  @$pb.TagNumber(3)
  set manufacturer($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasManufacturer() => $_has(2);
  @$pb.TagNumber(3)
  void clearManufacturer() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get model => $_getSZ(3);
  @$pb.TagNumber(4)
  set model($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasModel() => $_has(3);
  @$pb.TagNumber(4)
  void clearModel() => $_clearField(4);

  @$pb.TagNumber(5)
  AssetCategory get category => $_getN(4);
  @$pb.TagNumber(5)
  set category(AssetCategory v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasCategory() => $_has(4);
  @$pb.TagNumber(5)
  void clearCategory() => $_clearField(5);

  @$pb.TagNumber(6)
  Dimensions get dimensions => $_getN(5);
  @$pb.TagNumber(6)
  set dimensions(Dimensions v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasDimensions() => $_has(5);
  @$pb.TagNumber(6)
  void clearDimensions() => $_clearField(6);
  @$pb.TagNumber(6)
  Dimensions ensureDimensions() => $_ensure(5);

  @$pb.TagNumber(7)
  ElectricalParameters get electrical => $_getN(6);
  @$pb.TagNumber(7)
  set electrical(ElectricalParameters v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasElectrical() => $_has(6);
  @$pb.TagNumber(7)
  void clearElectrical() => $_clearField(7);
  @$pb.TagNumber(7)
  ElectricalParameters ensureElectrical() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get model3dPath => $_getSZ(7);
  @$pb.TagNumber(8)
  set model3dPath($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasModel3dPath() => $_has(7);
  @$pb.TagNumber(8)
  void clearModel3dPath() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get datasheetPath => $_getSZ(8);
  @$pb.TagNumber(9)
  set datasheetPath($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasDatasheetPath() => $_has(8);
  @$pb.TagNumber(9)
  void clearDatasheetPath() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get metadataJson => $_getSZ(9);
  @$pb.TagNumber(10)
  set metadataJson($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasMetadataJson() => $_has(9);
  @$pb.TagNumber(10)
  void clearMetadataJson() => $_clearField(10);

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

  @$pb.TagNumber(12)
  $0.Timestamp get updatedAt => $_getN(11);
  @$pb.TagNumber(12)
  set updatedAt($0.Timestamp v) { $_setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasUpdatedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearUpdatedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureUpdatedAt() => $_ensure(11);
}

class Dimensions extends $pb.GeneratedMessage {
  factory Dimensions({
    $core.double? widthMm,
    $core.double? heightMm,
    $core.double? depthMm,
    $core.double? weightKg,
    $core.int? cellCount,
    CellTechnology? cellTechnology,
    FrameType? frameType,
    $core.int? mountingHoleCount,
  }) {
    final $result = create();
    if (widthMm != null) {
      $result.widthMm = widthMm;
    }
    if (heightMm != null) {
      $result.heightMm = heightMm;
    }
    if (depthMm != null) {
      $result.depthMm = depthMm;
    }
    if (weightKg != null) {
      $result.weightKg = weightKg;
    }
    if (cellCount != null) {
      $result.cellCount = cellCount;
    }
    if (cellTechnology != null) {
      $result.cellTechnology = cellTechnology;
    }
    if (frameType != null) {
      $result.frameType = frameType;
    }
    if (mountingHoleCount != null) {
      $result.mountingHoleCount = mountingHoleCount;
    }
    return $result;
  }
  Dimensions._() : super();
  factory Dimensions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Dimensions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Dimensions', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'widthMm', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'heightMm', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'depthMm', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'weightKg', $pb.PbFieldType.OD)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'cellCount', $pb.PbFieldType.O3)
    ..e<CellTechnology>(6, _omitFieldNames ? '' : 'cellTechnology', $pb.PbFieldType.OE, defaultOrMaker: CellTechnology.CELL_TECHNOLOGY_UNSPECIFIED, valueOf: CellTechnology.valueOf, enumValues: CellTechnology.values)
    ..e<FrameType>(7, _omitFieldNames ? '' : 'frameType', $pb.PbFieldType.OE, defaultOrMaker: FrameType.FRAME_TYPE_UNSPECIFIED, valueOf: FrameType.valueOf, enumValues: FrameType.values)
    ..a<$core.int>(8, _omitFieldNames ? '' : 'mountingHoleCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Dimensions clone() => Dimensions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Dimensions copyWith(void Function(Dimensions) updates) => super.copyWith((message) => updates(message as Dimensions)) as Dimensions;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Dimensions create() => Dimensions._();
  Dimensions createEmptyInstance() => create();
  static $pb.PbList<Dimensions> createRepeated() => $pb.PbList<Dimensions>();
  @$core.pragma('dart2js:noInline')
  static Dimensions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Dimensions>(create);
  static Dimensions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get widthMm => $_getN(0);
  @$pb.TagNumber(1)
  set widthMm($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasWidthMm() => $_has(0);
  @$pb.TagNumber(1)
  void clearWidthMm() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get heightMm => $_getN(1);
  @$pb.TagNumber(2)
  set heightMm($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHeightMm() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeightMm() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get depthMm => $_getN(2);
  @$pb.TagNumber(3)
  set depthMm($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDepthMm() => $_has(2);
  @$pb.TagNumber(3)
  void clearDepthMm() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get weightKg => $_getN(3);
  @$pb.TagNumber(4)
  set weightKg($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasWeightKg() => $_has(3);
  @$pb.TagNumber(4)
  void clearWeightKg() => $_clearField(4);

  /// Panel-specific mechanical details used by structural + mounting calculations.
  @$pb.TagNumber(5)
  $core.int get cellCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set cellCount($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCellCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearCellCount() => $_clearField(5);

  @$pb.TagNumber(6)
  CellTechnology get cellTechnology => $_getN(5);
  @$pb.TagNumber(6)
  set cellTechnology(CellTechnology v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasCellTechnology() => $_has(5);
  @$pb.TagNumber(6)
  void clearCellTechnology() => $_clearField(6);

  @$pb.TagNumber(7)
  FrameType get frameType => $_getN(6);
  @$pb.TagNumber(7)
  set frameType(FrameType v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasFrameType() => $_has(6);
  @$pb.TagNumber(7)
  void clearFrameType() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get mountingHoleCount => $_getIZ(7);
  @$pb.TagNumber(8)
  set mountingHoleCount($core.int v) { $_setSignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasMountingHoleCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearMountingHoleCount() => $_clearField(8);
}

class ElectricalParameters extends $pb.GeneratedMessage {
  factory ElectricalParameters({
    $core.double? ratedPowerW,
    $core.double? voc,
    $core.double? isc,
    $core.double? vmp,
    $core.double? imp,
    $core.double? efficiency,
    $core.double? tempCoefficientPmax,
    $core.double? tempCoefficientVoc,
    $core.double? maxDcInputW,
    $core.double? maxAcOutputW,
    $core.int? mpptCount,
    $core.double? maxInputVoltage,
    $core.double? minInputVoltage,
    $core.int? maxStringsPerMppt,
    $core.double? kvaRating,
    $core.double? primaryVoltage,
    $core.double? secondaryVoltage,
    $core.double? tempCoefficientIsc,
    $core.double? noctC,
    $core.double? bifacialFactor,
    $core.double? maxSystemVoltage,
    $core.double? seriesFuseRatingA,
    $core.double? nominalPowerTolerancePct,
    $core.int? cellsInSeries,
    $core.int? cellsInParallel,
    $core.double? euroEfficiency,
    $core.double? cecEfficiency,
    $core.double? maxEfficiency,
    $core.double? mpptMinVoltage,
    $core.double? mpptMaxVoltage,
    $core.double? startupVoltage,
    $core.double? maxDcInputCurrentA,
    $core.double? maxOutputCurrentA,
    $core.double? ratedAcOutputW,
    $core.int? acPhaseCount,
    $core.double? acFrequencyHz,
    $core.double? nominalAcVoltage,
    $core.double? nightConsumptionW,
    $core.double? operatingTempMinC,
    $core.double? operatingTempMaxC,
    InverterTopology? topology,
    InverterGridType? gridType,
  }) {
    final $result = create();
    if (ratedPowerW != null) {
      $result.ratedPowerW = ratedPowerW;
    }
    if (voc != null) {
      $result.voc = voc;
    }
    if (isc != null) {
      $result.isc = isc;
    }
    if (vmp != null) {
      $result.vmp = vmp;
    }
    if (imp != null) {
      $result.imp = imp;
    }
    if (efficiency != null) {
      $result.efficiency = efficiency;
    }
    if (tempCoefficientPmax != null) {
      $result.tempCoefficientPmax = tempCoefficientPmax;
    }
    if (tempCoefficientVoc != null) {
      $result.tempCoefficientVoc = tempCoefficientVoc;
    }
    if (maxDcInputW != null) {
      $result.maxDcInputW = maxDcInputW;
    }
    if (maxAcOutputW != null) {
      $result.maxAcOutputW = maxAcOutputW;
    }
    if (mpptCount != null) {
      $result.mpptCount = mpptCount;
    }
    if (maxInputVoltage != null) {
      $result.maxInputVoltage = maxInputVoltage;
    }
    if (minInputVoltage != null) {
      $result.minInputVoltage = minInputVoltage;
    }
    if (maxStringsPerMppt != null) {
      $result.maxStringsPerMppt = maxStringsPerMppt;
    }
    if (kvaRating != null) {
      $result.kvaRating = kvaRating;
    }
    if (primaryVoltage != null) {
      $result.primaryVoltage = primaryVoltage;
    }
    if (secondaryVoltage != null) {
      $result.secondaryVoltage = secondaryVoltage;
    }
    if (tempCoefficientIsc != null) {
      $result.tempCoefficientIsc = tempCoefficientIsc;
    }
    if (noctC != null) {
      $result.noctC = noctC;
    }
    if (bifacialFactor != null) {
      $result.bifacialFactor = bifacialFactor;
    }
    if (maxSystemVoltage != null) {
      $result.maxSystemVoltage = maxSystemVoltage;
    }
    if (seriesFuseRatingA != null) {
      $result.seriesFuseRatingA = seriesFuseRatingA;
    }
    if (nominalPowerTolerancePct != null) {
      $result.nominalPowerTolerancePct = nominalPowerTolerancePct;
    }
    if (cellsInSeries != null) {
      $result.cellsInSeries = cellsInSeries;
    }
    if (cellsInParallel != null) {
      $result.cellsInParallel = cellsInParallel;
    }
    if (euroEfficiency != null) {
      $result.euroEfficiency = euroEfficiency;
    }
    if (cecEfficiency != null) {
      $result.cecEfficiency = cecEfficiency;
    }
    if (maxEfficiency != null) {
      $result.maxEfficiency = maxEfficiency;
    }
    if (mpptMinVoltage != null) {
      $result.mpptMinVoltage = mpptMinVoltage;
    }
    if (mpptMaxVoltage != null) {
      $result.mpptMaxVoltage = mpptMaxVoltage;
    }
    if (startupVoltage != null) {
      $result.startupVoltage = startupVoltage;
    }
    if (maxDcInputCurrentA != null) {
      $result.maxDcInputCurrentA = maxDcInputCurrentA;
    }
    if (maxOutputCurrentA != null) {
      $result.maxOutputCurrentA = maxOutputCurrentA;
    }
    if (ratedAcOutputW != null) {
      $result.ratedAcOutputW = ratedAcOutputW;
    }
    if (acPhaseCount != null) {
      $result.acPhaseCount = acPhaseCount;
    }
    if (acFrequencyHz != null) {
      $result.acFrequencyHz = acFrequencyHz;
    }
    if (nominalAcVoltage != null) {
      $result.nominalAcVoltage = nominalAcVoltage;
    }
    if (nightConsumptionW != null) {
      $result.nightConsumptionW = nightConsumptionW;
    }
    if (operatingTempMinC != null) {
      $result.operatingTempMinC = operatingTempMinC;
    }
    if (operatingTempMaxC != null) {
      $result.operatingTempMaxC = operatingTempMaxC;
    }
    if (topology != null) {
      $result.topology = topology;
    }
    if (gridType != null) {
      $result.gridType = gridType;
    }
    return $result;
  }
  ElectricalParameters._() : super();
  factory ElectricalParameters.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ElectricalParameters.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ElectricalParameters', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'ratedPowerW', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'voc', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'isc', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'vmp', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'imp', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'efficiency', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'tempCoefficientPmax', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'tempCoefficientVoc', $pb.PbFieldType.OD)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'maxDcInputW', $pb.PbFieldType.OD)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'maxAcOutputW', $pb.PbFieldType.OD)
    ..a<$core.int>(11, _omitFieldNames ? '' : 'mpptCount', $pb.PbFieldType.O3)
    ..a<$core.double>(12, _omitFieldNames ? '' : 'maxInputVoltage', $pb.PbFieldType.OD)
    ..a<$core.double>(13, _omitFieldNames ? '' : 'minInputVoltage', $pb.PbFieldType.OD)
    ..a<$core.int>(14, _omitFieldNames ? '' : 'maxStringsPerMppt', $pb.PbFieldType.O3)
    ..a<$core.double>(15, _omitFieldNames ? '' : 'kvaRating', $pb.PbFieldType.OD)
    ..a<$core.double>(16, _omitFieldNames ? '' : 'primaryVoltage', $pb.PbFieldType.OD)
    ..a<$core.double>(17, _omitFieldNames ? '' : 'secondaryVoltage', $pb.PbFieldType.OD)
    ..a<$core.double>(18, _omitFieldNames ? '' : 'tempCoefficientIsc', $pb.PbFieldType.OD)
    ..a<$core.double>(19, _omitFieldNames ? '' : 'noctC', $pb.PbFieldType.OD)
    ..a<$core.double>(20, _omitFieldNames ? '' : 'bifacialFactor', $pb.PbFieldType.OD)
    ..a<$core.double>(21, _omitFieldNames ? '' : 'maxSystemVoltage', $pb.PbFieldType.OD)
    ..a<$core.double>(22, _omitFieldNames ? '' : 'seriesFuseRatingA', $pb.PbFieldType.OD)
    ..a<$core.double>(23, _omitFieldNames ? '' : 'nominalPowerTolerancePct', $pb.PbFieldType.OD)
    ..a<$core.int>(24, _omitFieldNames ? '' : 'cellsInSeries', $pb.PbFieldType.O3)
    ..a<$core.int>(25, _omitFieldNames ? '' : 'cellsInParallel', $pb.PbFieldType.O3)
    ..a<$core.double>(26, _omitFieldNames ? '' : 'euroEfficiency', $pb.PbFieldType.OD)
    ..a<$core.double>(27, _omitFieldNames ? '' : 'cecEfficiency', $pb.PbFieldType.OD)
    ..a<$core.double>(28, _omitFieldNames ? '' : 'maxEfficiency', $pb.PbFieldType.OD)
    ..a<$core.double>(29, _omitFieldNames ? '' : 'mpptMinVoltage', $pb.PbFieldType.OD)
    ..a<$core.double>(30, _omitFieldNames ? '' : 'mpptMaxVoltage', $pb.PbFieldType.OD)
    ..a<$core.double>(31, _omitFieldNames ? '' : 'startupVoltage', $pb.PbFieldType.OD)
    ..a<$core.double>(32, _omitFieldNames ? '' : 'maxDcInputCurrentA', $pb.PbFieldType.OD)
    ..a<$core.double>(33, _omitFieldNames ? '' : 'maxOutputCurrentA', $pb.PbFieldType.OD)
    ..a<$core.double>(34, _omitFieldNames ? '' : 'ratedAcOutputW', $pb.PbFieldType.OD)
    ..a<$core.int>(35, _omitFieldNames ? '' : 'acPhaseCount', $pb.PbFieldType.O3)
    ..a<$core.double>(36, _omitFieldNames ? '' : 'acFrequencyHz', $pb.PbFieldType.OD)
    ..a<$core.double>(37, _omitFieldNames ? '' : 'nominalAcVoltage', $pb.PbFieldType.OD)
    ..a<$core.double>(38, _omitFieldNames ? '' : 'nightConsumptionW', $pb.PbFieldType.OD)
    ..a<$core.double>(39, _omitFieldNames ? '' : 'operatingTempMinC', $pb.PbFieldType.OD)
    ..a<$core.double>(40, _omitFieldNames ? '' : 'operatingTempMaxC', $pb.PbFieldType.OD)
    ..e<InverterTopology>(41, _omitFieldNames ? '' : 'topology', $pb.PbFieldType.OE, defaultOrMaker: InverterTopology.INVERTER_TOPOLOGY_UNSPECIFIED, valueOf: InverterTopology.valueOf, enumValues: InverterTopology.values)
    ..e<InverterGridType>(42, _omitFieldNames ? '' : 'gridType', $pb.PbFieldType.OE, defaultOrMaker: InverterGridType.INVERTER_GRID_TYPE_UNSPECIFIED, valueOf: InverterGridType.valueOf, enumValues: InverterGridType.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ElectricalParameters clone() => ElectricalParameters()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ElectricalParameters copyWith(void Function(ElectricalParameters) updates) => super.copyWith((message) => updates(message as ElectricalParameters)) as ElectricalParameters;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ElectricalParameters create() => ElectricalParameters._();
  ElectricalParameters createEmptyInstance() => create();
  static $pb.PbList<ElectricalParameters> createRepeated() => $pb.PbList<ElectricalParameters>();
  @$core.pragma('dart2js:noInline')
  static ElectricalParameters getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ElectricalParameters>(create);
  static ElectricalParameters? _defaultInstance;

  /// ========== Panel parameters (STC: 1000 W/m², 25°C, AM1.5) ==========
  @$pb.TagNumber(1)
  $core.double get ratedPowerW => $_getN(0);
  @$pb.TagNumber(1)
  set ratedPowerW($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRatedPowerW() => $_has(0);
  @$pb.TagNumber(1)
  void clearRatedPowerW() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get voc => $_getN(1);
  @$pb.TagNumber(2)
  set voc($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasVoc() => $_has(1);
  @$pb.TagNumber(2)
  void clearVoc() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get isc => $_getN(2);
  @$pb.TagNumber(3)
  set isc($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIsc() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsc() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get vmp => $_getN(3);
  @$pb.TagNumber(4)
  set vmp($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasVmp() => $_has(3);
  @$pb.TagNumber(4)
  void clearVmp() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get imp => $_getN(4);
  @$pb.TagNumber(5)
  set imp($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasImp() => $_has(4);
  @$pb.TagNumber(5)
  void clearImp() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get efficiency => $_getN(5);
  @$pb.TagNumber(6)
  set efficiency($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasEfficiency() => $_has(5);
  @$pb.TagNumber(6)
  void clearEfficiency() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get tempCoefficientPmax => $_getN(6);
  @$pb.TagNumber(7)
  set tempCoefficientPmax($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTempCoefficientPmax() => $_has(6);
  @$pb.TagNumber(7)
  void clearTempCoefficientPmax() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get tempCoefficientVoc => $_getN(7);
  @$pb.TagNumber(8)
  set tempCoefficientVoc($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasTempCoefficientVoc() => $_has(7);
  @$pb.TagNumber(8)
  void clearTempCoefficientVoc() => $_clearField(8);

  /// ========== Inverter parameters ==========
  @$pb.TagNumber(9)
  $core.double get maxDcInputW => $_getN(8);
  @$pb.TagNumber(9)
  set maxDcInputW($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasMaxDcInputW() => $_has(8);
  @$pb.TagNumber(9)
  void clearMaxDcInputW() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get maxAcOutputW => $_getN(9);
  @$pb.TagNumber(10)
  set maxAcOutputW($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasMaxAcOutputW() => $_has(9);
  @$pb.TagNumber(10)
  void clearMaxAcOutputW() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get mpptCount => $_getIZ(10);
  @$pb.TagNumber(11)
  set mpptCount($core.int v) { $_setSignedInt32(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasMpptCount() => $_has(10);
  @$pb.TagNumber(11)
  void clearMpptCount() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get maxInputVoltage => $_getN(11);
  @$pb.TagNumber(12)
  set maxInputVoltage($core.double v) { $_setDouble(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasMaxInputVoltage() => $_has(11);
  @$pb.TagNumber(12)
  void clearMaxInputVoltage() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get minInputVoltage => $_getN(12);
  @$pb.TagNumber(13)
  set minInputVoltage($core.double v) { $_setDouble(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasMinInputVoltage() => $_has(12);
  @$pb.TagNumber(13)
  void clearMinInputVoltage() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get maxStringsPerMppt => $_getIZ(13);
  @$pb.TagNumber(14)
  set maxStringsPerMppt($core.int v) { $_setSignedInt32(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasMaxStringsPerMppt() => $_has(13);
  @$pb.TagNumber(14)
  void clearMaxStringsPerMppt() => $_clearField(14);

  /// ========== Transformer parameters ==========
  @$pb.TagNumber(15)
  $core.double get kvaRating => $_getN(14);
  @$pb.TagNumber(15)
  set kvaRating($core.double v) { $_setDouble(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasKvaRating() => $_has(14);
  @$pb.TagNumber(15)
  void clearKvaRating() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.double get primaryVoltage => $_getN(15);
  @$pb.TagNumber(16)
  set primaryVoltage($core.double v) { $_setDouble(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasPrimaryVoltage() => $_has(15);
  @$pb.TagNumber(16)
  void clearPrimaryVoltage() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.double get secondaryVoltage => $_getN(16);
  @$pb.TagNumber(17)
  set secondaryVoltage($core.double v) { $_setDouble(16, v); }
  @$pb.TagNumber(17)
  $core.bool hasSecondaryVoltage() => $_has(16);
  @$pb.TagNumber(17)
  void clearSecondaryVoltage() => $_clearField(17);

  /// ========== Extended panel parameters (PAN-sourced) ==========
  @$pb.TagNumber(18)
  $core.double get tempCoefficientIsc => $_getN(17);
  @$pb.TagNumber(18)
  set tempCoefficientIsc($core.double v) { $_setDouble(17, v); }
  @$pb.TagNumber(18)
  $core.bool hasTempCoefficientIsc() => $_has(17);
  @$pb.TagNumber(18)
  void clearTempCoefficientIsc() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.double get noctC => $_getN(18);
  @$pb.TagNumber(19)
  set noctC($core.double v) { $_setDouble(18, v); }
  @$pb.TagNumber(19)
  $core.bool hasNoctC() => $_has(18);
  @$pb.TagNumber(19)
  void clearNoctC() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.double get bifacialFactor => $_getN(19);
  @$pb.TagNumber(20)
  set bifacialFactor($core.double v) { $_setDouble(19, v); }
  @$pb.TagNumber(20)
  $core.bool hasBifacialFactor() => $_has(19);
  @$pb.TagNumber(20)
  void clearBifacialFactor() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.double get maxSystemVoltage => $_getN(20);
  @$pb.TagNumber(21)
  set maxSystemVoltage($core.double v) { $_setDouble(20, v); }
  @$pb.TagNumber(21)
  $core.bool hasMaxSystemVoltage() => $_has(20);
  @$pb.TagNumber(21)
  void clearMaxSystemVoltage() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.double get seriesFuseRatingA => $_getN(21);
  @$pb.TagNumber(22)
  set seriesFuseRatingA($core.double v) { $_setDouble(21, v); }
  @$pb.TagNumber(22)
  $core.bool hasSeriesFuseRatingA() => $_has(21);
  @$pb.TagNumber(22)
  void clearSeriesFuseRatingA() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.double get nominalPowerTolerancePct => $_getN(22);
  @$pb.TagNumber(23)
  set nominalPowerTolerancePct($core.double v) { $_setDouble(22, v); }
  @$pb.TagNumber(23)
  $core.bool hasNominalPowerTolerancePct() => $_has(22);
  @$pb.TagNumber(23)
  void clearNominalPowerTolerancePct() => $_clearField(23);

  /// Cell-level reference for single-diode models. Populated from PAN; optional.
  @$pb.TagNumber(24)
  $core.int get cellsInSeries => $_getIZ(23);
  @$pb.TagNumber(24)
  set cellsInSeries($core.int v) { $_setSignedInt32(23, v); }
  @$pb.TagNumber(24)
  $core.bool hasCellsInSeries() => $_has(23);
  @$pb.TagNumber(24)
  void clearCellsInSeries() => $_clearField(24);

  @$pb.TagNumber(25)
  $core.int get cellsInParallel => $_getIZ(24);
  @$pb.TagNumber(25)
  set cellsInParallel($core.int v) { $_setSignedInt32(24, v); }
  @$pb.TagNumber(25)
  $core.bool hasCellsInParallel() => $_has(24);
  @$pb.TagNumber(25)
  void clearCellsInParallel() => $_clearField(25);

  /// ========== Extended inverter parameters (OND-sourced) ==========
  @$pb.TagNumber(26)
  $core.double get euroEfficiency => $_getN(25);
  @$pb.TagNumber(26)
  set euroEfficiency($core.double v) { $_setDouble(25, v); }
  @$pb.TagNumber(26)
  $core.bool hasEuroEfficiency() => $_has(25);
  @$pb.TagNumber(26)
  void clearEuroEfficiency() => $_clearField(26);

  @$pb.TagNumber(27)
  $core.double get cecEfficiency => $_getN(26);
  @$pb.TagNumber(27)
  set cecEfficiency($core.double v) { $_setDouble(26, v); }
  @$pb.TagNumber(27)
  $core.bool hasCecEfficiency() => $_has(26);
  @$pb.TagNumber(27)
  void clearCecEfficiency() => $_clearField(27);

  @$pb.TagNumber(28)
  $core.double get maxEfficiency => $_getN(27);
  @$pb.TagNumber(28)
  set maxEfficiency($core.double v) { $_setDouble(27, v); }
  @$pb.TagNumber(28)
  $core.bool hasMaxEfficiency() => $_has(27);
  @$pb.TagNumber(28)
  void clearMaxEfficiency() => $_clearField(28);

  @$pb.TagNumber(29)
  $core.double get mpptMinVoltage => $_getN(28);
  @$pb.TagNumber(29)
  set mpptMinVoltage($core.double v) { $_setDouble(28, v); }
  @$pb.TagNumber(29)
  $core.bool hasMpptMinVoltage() => $_has(28);
  @$pb.TagNumber(29)
  void clearMpptMinVoltage() => $_clearField(29);

  @$pb.TagNumber(30)
  $core.double get mpptMaxVoltage => $_getN(29);
  @$pb.TagNumber(30)
  set mpptMaxVoltage($core.double v) { $_setDouble(29, v); }
  @$pb.TagNumber(30)
  $core.bool hasMpptMaxVoltage() => $_has(29);
  @$pb.TagNumber(30)
  void clearMpptMaxVoltage() => $_clearField(30);

  @$pb.TagNumber(31)
  $core.double get startupVoltage => $_getN(30);
  @$pb.TagNumber(31)
  set startupVoltage($core.double v) { $_setDouble(30, v); }
  @$pb.TagNumber(31)
  $core.bool hasStartupVoltage() => $_has(30);
  @$pb.TagNumber(31)
  void clearStartupVoltage() => $_clearField(31);

  @$pb.TagNumber(32)
  $core.double get maxDcInputCurrentA => $_getN(31);
  @$pb.TagNumber(32)
  set maxDcInputCurrentA($core.double v) { $_setDouble(31, v); }
  @$pb.TagNumber(32)
  $core.bool hasMaxDcInputCurrentA() => $_has(31);
  @$pb.TagNumber(32)
  void clearMaxDcInputCurrentA() => $_clearField(32);

  @$pb.TagNumber(33)
  $core.double get maxOutputCurrentA => $_getN(32);
  @$pb.TagNumber(33)
  set maxOutputCurrentA($core.double v) { $_setDouble(32, v); }
  @$pb.TagNumber(33)
  $core.bool hasMaxOutputCurrentA() => $_has(32);
  @$pb.TagNumber(33)
  void clearMaxOutputCurrentA() => $_clearField(33);

  @$pb.TagNumber(34)
  $core.double get ratedAcOutputW => $_getN(33);
  @$pb.TagNumber(34)
  set ratedAcOutputW($core.double v) { $_setDouble(33, v); }
  @$pb.TagNumber(34)
  $core.bool hasRatedAcOutputW() => $_has(33);
  @$pb.TagNumber(34)
  void clearRatedAcOutputW() => $_clearField(34);

  @$pb.TagNumber(35)
  $core.int get acPhaseCount => $_getIZ(34);
  @$pb.TagNumber(35)
  set acPhaseCount($core.int v) { $_setSignedInt32(34, v); }
  @$pb.TagNumber(35)
  $core.bool hasAcPhaseCount() => $_has(34);
  @$pb.TagNumber(35)
  void clearAcPhaseCount() => $_clearField(35);

  @$pb.TagNumber(36)
  $core.double get acFrequencyHz => $_getN(35);
  @$pb.TagNumber(36)
  set acFrequencyHz($core.double v) { $_setDouble(35, v); }
  @$pb.TagNumber(36)
  $core.bool hasAcFrequencyHz() => $_has(35);
  @$pb.TagNumber(36)
  void clearAcFrequencyHz() => $_clearField(36);

  @$pb.TagNumber(37)
  $core.double get nominalAcVoltage => $_getN(36);
  @$pb.TagNumber(37)
  set nominalAcVoltage($core.double v) { $_setDouble(36, v); }
  @$pb.TagNumber(37)
  $core.bool hasNominalAcVoltage() => $_has(36);
  @$pb.TagNumber(37)
  void clearNominalAcVoltage() => $_clearField(37);

  @$pb.TagNumber(38)
  $core.double get nightConsumptionW => $_getN(37);
  @$pb.TagNumber(38)
  set nightConsumptionW($core.double v) { $_setDouble(37, v); }
  @$pb.TagNumber(38)
  $core.bool hasNightConsumptionW() => $_has(37);
  @$pb.TagNumber(38)
  void clearNightConsumptionW() => $_clearField(38);

  @$pb.TagNumber(39)
  $core.double get operatingTempMinC => $_getN(38);
  @$pb.TagNumber(39)
  set operatingTempMinC($core.double v) { $_setDouble(38, v); }
  @$pb.TagNumber(39)
  $core.bool hasOperatingTempMinC() => $_has(38);
  @$pb.TagNumber(39)
  void clearOperatingTempMinC() => $_clearField(39);

  @$pb.TagNumber(40)
  $core.double get operatingTempMaxC => $_getN(39);
  @$pb.TagNumber(40)
  set operatingTempMaxC($core.double v) { $_setDouble(39, v); }
  @$pb.TagNumber(40)
  $core.bool hasOperatingTempMaxC() => $_has(39);
  @$pb.TagNumber(40)
  void clearOperatingTempMaxC() => $_clearField(40);

  @$pb.TagNumber(41)
  InverterTopology get topology => $_getN(40);
  @$pb.TagNumber(41)
  set topology(InverterTopology v) { $_setField(41, v); }
  @$pb.TagNumber(41)
  $core.bool hasTopology() => $_has(40);
  @$pb.TagNumber(41)
  void clearTopology() => $_clearField(41);

  @$pb.TagNumber(42)
  InverterGridType get gridType => $_getN(41);
  @$pb.TagNumber(42)
  set gridType(InverterGridType v) { $_setField(42, v); }
  @$pb.TagNumber(42)
  $core.bool hasGridType() => $_has(41);
  @$pb.TagNumber(42)
  void clearGridType() => $_clearField(42);
}

class CreateAssetRequest extends $pb.GeneratedMessage {
  factory CreateAssetRequest({
    $core.String? name,
    $core.String? manufacturer,
    $core.String? model,
    AssetCategory? category,
    Dimensions? dimensions,
    ElectricalParameters? electrical,
    $core.String? model3dPath,
    $core.String? metadataJson,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (manufacturer != null) {
      $result.manufacturer = manufacturer;
    }
    if (model != null) {
      $result.model = model;
    }
    if (category != null) {
      $result.category = category;
    }
    if (dimensions != null) {
      $result.dimensions = dimensions;
    }
    if (electrical != null) {
      $result.electrical = electrical;
    }
    if (model3dPath != null) {
      $result.model3dPath = model3dPath;
    }
    if (metadataJson != null) {
      $result.metadataJson = metadataJson;
    }
    return $result;
  }
  CreateAssetRequest._() : super();
  factory CreateAssetRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateAssetRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateAssetRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'manufacturer')
    ..aOS(3, _omitFieldNames ? '' : 'model')
    ..e<AssetCategory>(4, _omitFieldNames ? '' : 'category', $pb.PbFieldType.OE, defaultOrMaker: AssetCategory.ASSET_CATEGORY_UNSPECIFIED, valueOf: AssetCategory.valueOf, enumValues: AssetCategory.values)
    ..aOM<Dimensions>(5, _omitFieldNames ? '' : 'dimensions', subBuilder: Dimensions.create)
    ..aOM<ElectricalParameters>(6, _omitFieldNames ? '' : 'electrical', subBuilder: ElectricalParameters.create)
    ..aOS(7, _omitFieldNames ? '' : 'model3dPath', protoName: 'model_3d_path')
    ..aOS(8, _omitFieldNames ? '' : 'metadataJson')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateAssetRequest clone() => CreateAssetRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateAssetRequest copyWith(void Function(CreateAssetRequest) updates) => super.copyWith((message) => updates(message as CreateAssetRequest)) as CreateAssetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateAssetRequest create() => CreateAssetRequest._();
  CreateAssetRequest createEmptyInstance() => create();
  static $pb.PbList<CreateAssetRequest> createRepeated() => $pb.PbList<CreateAssetRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateAssetRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateAssetRequest>(create);
  static CreateAssetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get manufacturer => $_getSZ(1);
  @$pb.TagNumber(2)
  set manufacturer($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasManufacturer() => $_has(1);
  @$pb.TagNumber(2)
  void clearManufacturer() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get model => $_getSZ(2);
  @$pb.TagNumber(3)
  set model($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasModel() => $_has(2);
  @$pb.TagNumber(3)
  void clearModel() => $_clearField(3);

  @$pb.TagNumber(4)
  AssetCategory get category => $_getN(3);
  @$pb.TagNumber(4)
  set category(AssetCategory v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasCategory() => $_has(3);
  @$pb.TagNumber(4)
  void clearCategory() => $_clearField(4);

  @$pb.TagNumber(5)
  Dimensions get dimensions => $_getN(4);
  @$pb.TagNumber(5)
  set dimensions(Dimensions v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasDimensions() => $_has(4);
  @$pb.TagNumber(5)
  void clearDimensions() => $_clearField(5);
  @$pb.TagNumber(5)
  Dimensions ensureDimensions() => $_ensure(4);

  @$pb.TagNumber(6)
  ElectricalParameters get electrical => $_getN(5);
  @$pb.TagNumber(6)
  set electrical(ElectricalParameters v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasElectrical() => $_has(5);
  @$pb.TagNumber(6)
  void clearElectrical() => $_clearField(6);
  @$pb.TagNumber(6)
  ElectricalParameters ensureElectrical() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get model3dPath => $_getSZ(6);
  @$pb.TagNumber(7)
  set model3dPath($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasModel3dPath() => $_has(6);
  @$pb.TagNumber(7)
  void clearModel3dPath() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get metadataJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set metadataJson($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasMetadataJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearMetadataJson() => $_clearField(8);
}

class CreateAssetResponse extends $pb.GeneratedMessage {
  factory CreateAssetResponse({
    Asset? asset,
  }) {
    final $result = create();
    if (asset != null) {
      $result.asset = asset;
    }
    return $result;
  }
  CreateAssetResponse._() : super();
  factory CreateAssetResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateAssetResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateAssetResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..aOM<Asset>(1, _omitFieldNames ? '' : 'asset', subBuilder: Asset.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateAssetResponse clone() => CreateAssetResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateAssetResponse copyWith(void Function(CreateAssetResponse) updates) => super.copyWith((message) => updates(message as CreateAssetResponse)) as CreateAssetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateAssetResponse create() => CreateAssetResponse._();
  CreateAssetResponse createEmptyInstance() => create();
  static $pb.PbList<CreateAssetResponse> createRepeated() => $pb.PbList<CreateAssetResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateAssetResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateAssetResponse>(create);
  static CreateAssetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Asset get asset => $_getN(0);
  @$pb.TagNumber(1)
  set asset(Asset v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAsset() => $_has(0);
  @$pb.TagNumber(1)
  void clearAsset() => $_clearField(1);
  @$pb.TagNumber(1)
  Asset ensureAsset() => $_ensure(0);
}

class GetAssetRequest extends $pb.GeneratedMessage {
  factory GetAssetRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  GetAssetRequest._() : super();
  factory GetAssetRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetAssetRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetAssetRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetAssetRequest clone() => GetAssetRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetAssetRequest copyWith(void Function(GetAssetRequest) updates) => super.copyWith((message) => updates(message as GetAssetRequest)) as GetAssetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAssetRequest create() => GetAssetRequest._();
  GetAssetRequest createEmptyInstance() => create();
  static $pb.PbList<GetAssetRequest> createRepeated() => $pb.PbList<GetAssetRequest>();
  @$core.pragma('dart2js:noInline')
  static GetAssetRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetAssetRequest>(create);
  static GetAssetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class GetAssetResponse extends $pb.GeneratedMessage {
  factory GetAssetResponse({
    Asset? asset,
  }) {
    final $result = create();
    if (asset != null) {
      $result.asset = asset;
    }
    return $result;
  }
  GetAssetResponse._() : super();
  factory GetAssetResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetAssetResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetAssetResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..aOM<Asset>(1, _omitFieldNames ? '' : 'asset', subBuilder: Asset.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetAssetResponse clone() => GetAssetResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetAssetResponse copyWith(void Function(GetAssetResponse) updates) => super.copyWith((message) => updates(message as GetAssetResponse)) as GetAssetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAssetResponse create() => GetAssetResponse._();
  GetAssetResponse createEmptyInstance() => create();
  static $pb.PbList<GetAssetResponse> createRepeated() => $pb.PbList<GetAssetResponse>();
  @$core.pragma('dart2js:noInline')
  static GetAssetResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetAssetResponse>(create);
  static GetAssetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Asset get asset => $_getN(0);
  @$pb.TagNumber(1)
  set asset(Asset v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAsset() => $_has(0);
  @$pb.TagNumber(1)
  void clearAsset() => $_clearField(1);
  @$pb.TagNumber(1)
  Asset ensureAsset() => $_ensure(0);
}

class ListAssetsRequest extends $pb.GeneratedMessage {
  factory ListAssetsRequest({
    AssetCategory? categoryFilter,
    $core.String? manufacturerFilter,
    $1.PaginationRequest? pagination,
  }) {
    final $result = create();
    if (categoryFilter != null) {
      $result.categoryFilter = categoryFilter;
    }
    if (manufacturerFilter != null) {
      $result.manufacturerFilter = manufacturerFilter;
    }
    if (pagination != null) {
      $result.pagination = pagination;
    }
    return $result;
  }
  ListAssetsRequest._() : super();
  factory ListAssetsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListAssetsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListAssetsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..e<AssetCategory>(1, _omitFieldNames ? '' : 'categoryFilter', $pb.PbFieldType.OE, defaultOrMaker: AssetCategory.ASSET_CATEGORY_UNSPECIFIED, valueOf: AssetCategory.valueOf, enumValues: AssetCategory.values)
    ..aOS(2, _omitFieldNames ? '' : 'manufacturerFilter')
    ..aOM<$1.PaginationRequest>(3, _omitFieldNames ? '' : 'pagination', subBuilder: $1.PaginationRequest.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListAssetsRequest clone() => ListAssetsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListAssetsRequest copyWith(void Function(ListAssetsRequest) updates) => super.copyWith((message) => updates(message as ListAssetsRequest)) as ListAssetsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAssetsRequest create() => ListAssetsRequest._();
  ListAssetsRequest createEmptyInstance() => create();
  static $pb.PbList<ListAssetsRequest> createRepeated() => $pb.PbList<ListAssetsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListAssetsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListAssetsRequest>(create);
  static ListAssetsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  AssetCategory get categoryFilter => $_getN(0);
  @$pb.TagNumber(1)
  set categoryFilter(AssetCategory v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCategoryFilter() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategoryFilter() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get manufacturerFilter => $_getSZ(1);
  @$pb.TagNumber(2)
  set manufacturerFilter($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasManufacturerFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearManufacturerFilter() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.PaginationRequest get pagination => $_getN(2);
  @$pb.TagNumber(3)
  set pagination($1.PaginationRequest v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(2);
  @$pb.TagNumber(3)
  void clearPagination() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.PaginationRequest ensurePagination() => $_ensure(2);
}

class ListAssetsResponse extends $pb.GeneratedMessage {
  factory ListAssetsResponse({
    $core.Iterable<Asset>? assets,
    $1.PaginationResponse? pagination,
  }) {
    final $result = create();
    if (assets != null) {
      $result.assets.addAll(assets);
    }
    if (pagination != null) {
      $result.pagination = pagination;
    }
    return $result;
  }
  ListAssetsResponse._() : super();
  factory ListAssetsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListAssetsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListAssetsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..pc<Asset>(1, _omitFieldNames ? '' : 'assets', $pb.PbFieldType.PM, subBuilder: Asset.create)
    ..aOM<$1.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination', subBuilder: $1.PaginationResponse.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListAssetsResponse clone() => ListAssetsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListAssetsResponse copyWith(void Function(ListAssetsResponse) updates) => super.copyWith((message) => updates(message as ListAssetsResponse)) as ListAssetsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAssetsResponse create() => ListAssetsResponse._();
  ListAssetsResponse createEmptyInstance() => create();
  static $pb.PbList<ListAssetsResponse> createRepeated() => $pb.PbList<ListAssetsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListAssetsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListAssetsResponse>(create);
  static ListAssetsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Asset> get assets => $_getList(0);

  @$pb.TagNumber(2)
  $1.PaginationResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.PaginationResponse v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginationResponse ensurePagination() => $_ensure(1);
}

class UpdateAssetRequest extends $pb.GeneratedMessage {
  factory UpdateAssetRequest({
    $core.String? id,
    $core.String? name,
    $core.String? manufacturer,
    $core.String? model,
    Dimensions? dimensions,
    ElectricalParameters? electrical,
    $core.String? model3dPath,
    $core.String? metadataJson,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    if (manufacturer != null) {
      $result.manufacturer = manufacturer;
    }
    if (model != null) {
      $result.model = model;
    }
    if (dimensions != null) {
      $result.dimensions = dimensions;
    }
    if (electrical != null) {
      $result.electrical = electrical;
    }
    if (model3dPath != null) {
      $result.model3dPath = model3dPath;
    }
    if (metadataJson != null) {
      $result.metadataJson = metadataJson;
    }
    return $result;
  }
  UpdateAssetRequest._() : super();
  factory UpdateAssetRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateAssetRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateAssetRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'manufacturer')
    ..aOS(4, _omitFieldNames ? '' : 'model')
    ..aOM<Dimensions>(5, _omitFieldNames ? '' : 'dimensions', subBuilder: Dimensions.create)
    ..aOM<ElectricalParameters>(6, _omitFieldNames ? '' : 'electrical', subBuilder: ElectricalParameters.create)
    ..aOS(7, _omitFieldNames ? '' : 'model3dPath', protoName: 'model_3d_path')
    ..aOS(8, _omitFieldNames ? '' : 'metadataJson')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateAssetRequest clone() => UpdateAssetRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateAssetRequest copyWith(void Function(UpdateAssetRequest) updates) => super.copyWith((message) => updates(message as UpdateAssetRequest)) as UpdateAssetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateAssetRequest create() => UpdateAssetRequest._();
  UpdateAssetRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateAssetRequest> createRepeated() => $pb.PbList<UpdateAssetRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateAssetRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateAssetRequest>(create);
  static UpdateAssetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get manufacturer => $_getSZ(2);
  @$pb.TagNumber(3)
  set manufacturer($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasManufacturer() => $_has(2);
  @$pb.TagNumber(3)
  void clearManufacturer() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get model => $_getSZ(3);
  @$pb.TagNumber(4)
  set model($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasModel() => $_has(3);
  @$pb.TagNumber(4)
  void clearModel() => $_clearField(4);

  @$pb.TagNumber(5)
  Dimensions get dimensions => $_getN(4);
  @$pb.TagNumber(5)
  set dimensions(Dimensions v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasDimensions() => $_has(4);
  @$pb.TagNumber(5)
  void clearDimensions() => $_clearField(5);
  @$pb.TagNumber(5)
  Dimensions ensureDimensions() => $_ensure(4);

  @$pb.TagNumber(6)
  ElectricalParameters get electrical => $_getN(5);
  @$pb.TagNumber(6)
  set electrical(ElectricalParameters v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasElectrical() => $_has(5);
  @$pb.TagNumber(6)
  void clearElectrical() => $_clearField(6);
  @$pb.TagNumber(6)
  ElectricalParameters ensureElectrical() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get model3dPath => $_getSZ(6);
  @$pb.TagNumber(7)
  set model3dPath($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasModel3dPath() => $_has(6);
  @$pb.TagNumber(7)
  void clearModel3dPath() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get metadataJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set metadataJson($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasMetadataJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearMetadataJson() => $_clearField(8);
}

class UpdateAssetResponse extends $pb.GeneratedMessage {
  factory UpdateAssetResponse({
    Asset? asset,
  }) {
    final $result = create();
    if (asset != null) {
      $result.asset = asset;
    }
    return $result;
  }
  UpdateAssetResponse._() : super();
  factory UpdateAssetResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateAssetResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateAssetResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..aOM<Asset>(1, _omitFieldNames ? '' : 'asset', subBuilder: Asset.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateAssetResponse clone() => UpdateAssetResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateAssetResponse copyWith(void Function(UpdateAssetResponse) updates) => super.copyWith((message) => updates(message as UpdateAssetResponse)) as UpdateAssetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateAssetResponse create() => UpdateAssetResponse._();
  UpdateAssetResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateAssetResponse> createRepeated() => $pb.PbList<UpdateAssetResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateAssetResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateAssetResponse>(create);
  static UpdateAssetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Asset get asset => $_getN(0);
  @$pb.TagNumber(1)
  set asset(Asset v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAsset() => $_has(0);
  @$pb.TagNumber(1)
  void clearAsset() => $_clearField(1);
  @$pb.TagNumber(1)
  Asset ensureAsset() => $_ensure(0);
}

class DeleteAssetRequest extends $pb.GeneratedMessage {
  factory DeleteAssetRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  DeleteAssetRequest._() : super();
  factory DeleteAssetRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteAssetRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteAssetRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteAssetRequest clone() => DeleteAssetRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteAssetRequest copyWith(void Function(DeleteAssetRequest) updates) => super.copyWith((message) => updates(message as DeleteAssetRequest)) as DeleteAssetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteAssetRequest create() => DeleteAssetRequest._();
  DeleteAssetRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteAssetRequest> createRepeated() => $pb.PbList<DeleteAssetRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteAssetRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteAssetRequest>(create);
  static DeleteAssetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class DeleteAssetResponse extends $pb.GeneratedMessage {
  factory DeleteAssetResponse() => create();
  DeleteAssetResponse._() : super();
  factory DeleteAssetResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteAssetResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteAssetResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteAssetResponse clone() => DeleteAssetResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteAssetResponse copyWith(void Function(DeleteAssetResponse) updates) => super.copyWith((message) => updates(message as DeleteAssetResponse)) as DeleteAssetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteAssetResponse create() => DeleteAssetResponse._();
  DeleteAssetResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteAssetResponse> createRepeated() => $pb.PbList<DeleteAssetResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteAssetResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteAssetResponse>(create);
  static DeleteAssetResponse? _defaultInstance;
}

class AssetServiceApi {
  $pb.RpcClient _client;
  AssetServiceApi(this._client);

  $async.Future<CreateAssetResponse> createAsset($pb.ClientContext? ctx, CreateAssetRequest request) =>
    _client.invoke<CreateAssetResponse>(ctx, 'AssetService', 'CreateAsset', request, CreateAssetResponse())
  ;
  $async.Future<GetAssetResponse> getAsset($pb.ClientContext? ctx, GetAssetRequest request) =>
    _client.invoke<GetAssetResponse>(ctx, 'AssetService', 'GetAsset', request, GetAssetResponse())
  ;
  $async.Future<ListAssetsResponse> listAssets($pb.ClientContext? ctx, ListAssetsRequest request) =>
    _client.invoke<ListAssetsResponse>(ctx, 'AssetService', 'ListAssets', request, ListAssetsResponse())
  ;
  $async.Future<UpdateAssetResponse> updateAsset($pb.ClientContext? ctx, UpdateAssetRequest request) =>
    _client.invoke<UpdateAssetResponse>(ctx, 'AssetService', 'UpdateAsset', request, UpdateAssetResponse())
  ;
  $async.Future<DeleteAssetResponse> deleteAsset($pb.ClientContext? ctx, DeleteAssetRequest request) =>
    _client.invoke<DeleteAssetResponse>(ctx, 'AssetService', 'DeleteAsset', request, DeleteAssetResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
