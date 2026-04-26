//
//  Generated code. Do not modify.
//  source: ml_orchestration/v1/ml_orchestration.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class FeatureExtraction extends $pb.GeneratedMessage {
  factory FeatureExtraction({
    $core.Iterable<$core.String>? selectedFeatures,
    $core.bool? normalize,
    $core.double? outlierPercentile,
  }) {
    final $result = create();
    if (selectedFeatures != null) {
      $result.selectedFeatures.addAll(selectedFeatures);
    }
    if (normalize != null) {
      $result.normalize = normalize;
    }
    if (outlierPercentile != null) {
      $result.outlierPercentile = outlierPercentile;
    }
    return $result;
  }
  FeatureExtraction._() : super();
  factory FeatureExtraction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FeatureExtraction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FeatureExtraction', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_orchestration.v1'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'selectedFeatures')
    ..aOB(2, _omitFieldNames ? '' : 'normalize')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'outlierPercentile', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FeatureExtraction clone() => FeatureExtraction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FeatureExtraction copyWith(void Function(FeatureExtraction) updates) => super.copyWith((message) => updates(message as FeatureExtraction)) as FeatureExtraction;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FeatureExtraction create() => FeatureExtraction._();
  FeatureExtraction createEmptyInstance() => create();
  static $pb.PbList<FeatureExtraction> createRepeated() => $pb.PbList<FeatureExtraction>();
  @$core.pragma('dart2js:noInline')
  static FeatureExtraction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FeatureExtraction>(create);
  static FeatureExtraction? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get selectedFeatures => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get normalize => $_getBF(1);
  @$pb.TagNumber(2)
  set normalize($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNormalize() => $_has(1);
  @$pb.TagNumber(2)
  void clearNormalize() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get outlierPercentile => $_getN(2);
  @$pb.TagNumber(3)
  set outlierPercentile($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOutlierPercentile() => $_has(2);
  @$pb.TagNumber(3)
  void clearOutlierPercentile() => $_clearField(3);
}

class DatasetWindow extends $pb.GeneratedMessage {
  factory DatasetWindow({
    $core.int? lookbackDays,
    $core.int? minSamplesPerSite,
    $core.bool? includeSynthetic,
  }) {
    final $result = create();
    if (lookbackDays != null) {
      $result.lookbackDays = lookbackDays;
    }
    if (minSamplesPerSite != null) {
      $result.minSamplesPerSite = minSamplesPerSite;
    }
    if (includeSynthetic != null) {
      $result.includeSynthetic = includeSynthetic;
    }
    return $result;
  }
  DatasetWindow._() : super();
  factory DatasetWindow.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DatasetWindow.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DatasetWindow', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_orchestration.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'lookbackDays', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'minSamplesPerSite', $pb.PbFieldType.O3)
    ..aOB(3, _omitFieldNames ? '' : 'includeSynthetic')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DatasetWindow clone() => DatasetWindow()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DatasetWindow copyWith(void Function(DatasetWindow) updates) => super.copyWith((message) => updates(message as DatasetWindow)) as DatasetWindow;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DatasetWindow create() => DatasetWindow._();
  DatasetWindow createEmptyInstance() => create();
  static $pb.PbList<DatasetWindow> createRepeated() => $pb.PbList<DatasetWindow>();
  @$core.pragma('dart2js:noInline')
  static DatasetWindow getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DatasetWindow>(create);
  static DatasetWindow? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get lookbackDays => $_getIZ(0);
  @$pb.TagNumber(1)
  set lookbackDays($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLookbackDays() => $_has(0);
  @$pb.TagNumber(1)
  void clearLookbackDays() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get minSamplesPerSite => $_getIZ(1);
  @$pb.TagNumber(2)
  set minSamplesPerSite($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMinSamplesPerSite() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinSamplesPerSite() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get includeSynthetic => $_getBF(2);
  @$pb.TagNumber(3)
  set includeSynthetic($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIncludeSynthetic() => $_has(2);
  @$pb.TagNumber(3)
  void clearIncludeSynthetic() => $_clearField(3);
}

class DatasetSplit extends $pb.GeneratedMessage {
  factory DatasetSplit({
    $core.double? trainRatio,
    $core.double? validationRatio,
    $core.double? testRatio,
    $core.bool? timeAware,
  }) {
    final $result = create();
    if (trainRatio != null) {
      $result.trainRatio = trainRatio;
    }
    if (validationRatio != null) {
      $result.validationRatio = validationRatio;
    }
    if (testRatio != null) {
      $result.testRatio = testRatio;
    }
    if (timeAware != null) {
      $result.timeAware = timeAware;
    }
    return $result;
  }
  DatasetSplit._() : super();
  factory DatasetSplit.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DatasetSplit.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DatasetSplit', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_orchestration.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'trainRatio', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'validationRatio', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'testRatio', $pb.PbFieldType.OD)
    ..aOB(4, _omitFieldNames ? '' : 'timeAware')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DatasetSplit clone() => DatasetSplit()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DatasetSplit copyWith(void Function(DatasetSplit) updates) => super.copyWith((message) => updates(message as DatasetSplit)) as DatasetSplit;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DatasetSplit create() => DatasetSplit._();
  DatasetSplit createEmptyInstance() => create();
  static $pb.PbList<DatasetSplit> createRepeated() => $pb.PbList<DatasetSplit>();
  @$core.pragma('dart2js:noInline')
  static DatasetSplit getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DatasetSplit>(create);
  static DatasetSplit? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get trainRatio => $_getN(0);
  @$pb.TagNumber(1)
  set trainRatio($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTrainRatio() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrainRatio() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get validationRatio => $_getN(1);
  @$pb.TagNumber(2)
  set validationRatio($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValidationRatio() => $_has(1);
  @$pb.TagNumber(2)
  void clearValidationRatio() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get testRatio => $_getN(2);
  @$pb.TagNumber(3)
  set testRatio($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTestRatio() => $_has(2);
  @$pb.TagNumber(3)
  void clearTestRatio() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get timeAware => $_getBF(3);
  @$pb.TagNumber(4)
  set timeAware($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTimeAware() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimeAware() => $_clearField(4);
}

class DatasetConfig extends $pb.GeneratedMessage {
  factory DatasetConfig({
    $core.String? version,
    DatasetWindow? window,
    DatasetSplit? split,
    FeatureExtraction? features,
    $core.String? feedbackSource,
  }) {
    final $result = create();
    if (version != null) {
      $result.version = version;
    }
    if (window != null) {
      $result.window = window;
    }
    if (split != null) {
      $result.split = split;
    }
    if (features != null) {
      $result.features = features;
    }
    if (feedbackSource != null) {
      $result.feedbackSource = feedbackSource;
    }
    return $result;
  }
  DatasetConfig._() : super();
  factory DatasetConfig.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DatasetConfig.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DatasetConfig', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_orchestration.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aOM<DatasetWindow>(2, _omitFieldNames ? '' : 'window', subBuilder: DatasetWindow.create)
    ..aOM<DatasetSplit>(3, _omitFieldNames ? '' : 'split', subBuilder: DatasetSplit.create)
    ..aOM<FeatureExtraction>(4, _omitFieldNames ? '' : 'features', subBuilder: FeatureExtraction.create)
    ..aOS(5, _omitFieldNames ? '' : 'feedbackSource')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DatasetConfig clone() => DatasetConfig()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DatasetConfig copyWith(void Function(DatasetConfig) updates) => super.copyWith((message) => updates(message as DatasetConfig)) as DatasetConfig;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DatasetConfig create() => DatasetConfig._();
  DatasetConfig createEmptyInstance() => create();
  static $pb.PbList<DatasetConfig> createRepeated() => $pb.PbList<DatasetConfig>();
  @$core.pragma('dart2js:noInline')
  static DatasetConfig getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DatasetConfig>(create);
  static DatasetConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get version => $_getSZ(0);
  @$pb.TagNumber(1)
  set version($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  DatasetWindow get window => $_getN(1);
  @$pb.TagNumber(2)
  set window(DatasetWindow v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasWindow() => $_has(1);
  @$pb.TagNumber(2)
  void clearWindow() => $_clearField(2);
  @$pb.TagNumber(2)
  DatasetWindow ensureWindow() => $_ensure(1);

  @$pb.TagNumber(3)
  DatasetSplit get split => $_getN(2);
  @$pb.TagNumber(3)
  set split(DatasetSplit v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSplit() => $_has(2);
  @$pb.TagNumber(3)
  void clearSplit() => $_clearField(3);
  @$pb.TagNumber(3)
  DatasetSplit ensureSplit() => $_ensure(2);

  @$pb.TagNumber(4)
  FeatureExtraction get features => $_getN(3);
  @$pb.TagNumber(4)
  set features(FeatureExtraction v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasFeatures() => $_has(3);
  @$pb.TagNumber(4)
  void clearFeatures() => $_clearField(4);
  @$pb.TagNumber(4)
  FeatureExtraction ensureFeatures() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get feedbackSource => $_getSZ(4);
  @$pb.TagNumber(5)
  set feedbackSource($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasFeedbackSource() => $_has(4);
  @$pb.TagNumber(5)
  void clearFeedbackSource() => $_clearField(5);
}

class TrainingHyperparams extends $pb.GeneratedMessage {
  factory TrainingHyperparams({
    $core.String? algorithm,
    $core.int? epochs,
    $core.int? batchSize,
    $core.double? learningRate,
    $core.double? regularizationL1,
    $core.double? regularizationL2,
    $core.double? dropoutRate,
    $pb.PbMap<$core.String, $core.String>? extraParams,
  }) {
    final $result = create();
    if (algorithm != null) {
      $result.algorithm = algorithm;
    }
    if (epochs != null) {
      $result.epochs = epochs;
    }
    if (batchSize != null) {
      $result.batchSize = batchSize;
    }
    if (learningRate != null) {
      $result.learningRate = learningRate;
    }
    if (regularizationL1 != null) {
      $result.regularizationL1 = regularizationL1;
    }
    if (regularizationL2 != null) {
      $result.regularizationL2 = regularizationL2;
    }
    if (dropoutRate != null) {
      $result.dropoutRate = dropoutRate;
    }
    if (extraParams != null) {
      $result.extraParams.addAll(extraParams);
    }
    return $result;
  }
  TrainingHyperparams._() : super();
  factory TrainingHyperparams.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrainingHyperparams.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TrainingHyperparams', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_orchestration.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'algorithm')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'epochs', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'batchSize', $pb.PbFieldType.O3)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'learningRate', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'regularizationL1', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'regularizationL2', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'dropoutRate', $pb.PbFieldType.OD)
    ..m<$core.String, $core.String>(8, _omitFieldNames ? '' : 'extraParams', entryClassName: 'TrainingHyperparams.ExtraParamsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('ml_orchestration.v1'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrainingHyperparams clone() => TrainingHyperparams()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrainingHyperparams copyWith(void Function(TrainingHyperparams) updates) => super.copyWith((message) => updates(message as TrainingHyperparams)) as TrainingHyperparams;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrainingHyperparams create() => TrainingHyperparams._();
  TrainingHyperparams createEmptyInstance() => create();
  static $pb.PbList<TrainingHyperparams> createRepeated() => $pb.PbList<TrainingHyperparams>();
  @$core.pragma('dart2js:noInline')
  static TrainingHyperparams getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrainingHyperparams>(create);
  static TrainingHyperparams? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get algorithm => $_getSZ(0);
  @$pb.TagNumber(1)
  set algorithm($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAlgorithm() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlgorithm() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get epochs => $_getIZ(1);
  @$pb.TagNumber(2)
  set epochs($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEpochs() => $_has(1);
  @$pb.TagNumber(2)
  void clearEpochs() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get batchSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set batchSize($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBatchSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearBatchSize() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get learningRate => $_getN(3);
  @$pb.TagNumber(4)
  set learningRate($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasLearningRate() => $_has(3);
  @$pb.TagNumber(4)
  void clearLearningRate() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get regularizationL1 => $_getN(4);
  @$pb.TagNumber(5)
  set regularizationL1($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRegularizationL1() => $_has(4);
  @$pb.TagNumber(5)
  void clearRegularizationL1() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get regularizationL2 => $_getN(5);
  @$pb.TagNumber(6)
  set regularizationL2($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasRegularizationL2() => $_has(5);
  @$pb.TagNumber(6)
  void clearRegularizationL2() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get dropoutRate => $_getN(6);
  @$pb.TagNumber(7)
  set dropoutRate($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasDropoutRate() => $_has(6);
  @$pb.TagNumber(7)
  void clearDropoutRate() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbMap<$core.String, $core.String> get extraParams => $_getMap(7);
}

class EarlyStoppingPolicy extends $pb.GeneratedMessage {
  factory EarlyStoppingPolicy({
    $core.int? patienceEpochs,
    $core.double? minDelta,
    $core.bool? monitorValidation,
  }) {
    final $result = create();
    if (patienceEpochs != null) {
      $result.patienceEpochs = patienceEpochs;
    }
    if (minDelta != null) {
      $result.minDelta = minDelta;
    }
    if (monitorValidation != null) {
      $result.monitorValidation = monitorValidation;
    }
    return $result;
  }
  EarlyStoppingPolicy._() : super();
  factory EarlyStoppingPolicy.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EarlyStoppingPolicy.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EarlyStoppingPolicy', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_orchestration.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'patienceEpochs', $pb.PbFieldType.O3)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'minDelta', $pb.PbFieldType.OD)
    ..aOB(3, _omitFieldNames ? '' : 'monitorValidation')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EarlyStoppingPolicy clone() => EarlyStoppingPolicy()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EarlyStoppingPolicy copyWith(void Function(EarlyStoppingPolicy) updates) => super.copyWith((message) => updates(message as EarlyStoppingPolicy)) as EarlyStoppingPolicy;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EarlyStoppingPolicy create() => EarlyStoppingPolicy._();
  EarlyStoppingPolicy createEmptyInstance() => create();
  static $pb.PbList<EarlyStoppingPolicy> createRepeated() => $pb.PbList<EarlyStoppingPolicy>();
  @$core.pragma('dart2js:noInline')
  static EarlyStoppingPolicy getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EarlyStoppingPolicy>(create);
  static EarlyStoppingPolicy? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get patienceEpochs => $_getIZ(0);
  @$pb.TagNumber(1)
  set patienceEpochs($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPatienceEpochs() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatienceEpochs() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get minDelta => $_getN(1);
  @$pb.TagNumber(2)
  set minDelta($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMinDelta() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinDelta() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get monitorValidation => $_getBF(2);
  @$pb.TagNumber(3)
  set monitorValidation($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMonitorValidation() => $_has(2);
  @$pb.TagNumber(3)
  void clearMonitorValidation() => $_clearField(3);
}

class SubmitTrainingJobRequest extends $pb.GeneratedMessage {
  factory SubmitTrainingJobRequest({
    $core.String? jobId,
    $core.String? taskType,
    DatasetConfig? datasetConfig,
    TrainingHyperparams? hyperparams,
    EarlyStoppingPolicy? stoppingPolicy,
    $core.String? triggeredBy,
    $core.String? commitHash,
    $pb.PbMap<$core.String, $core.String>? labels,
    $core.int? timeoutMinutes,
  }) {
    final $result = create();
    if (jobId != null) {
      $result.jobId = jobId;
    }
    if (taskType != null) {
      $result.taskType = taskType;
    }
    if (datasetConfig != null) {
      $result.datasetConfig = datasetConfig;
    }
    if (hyperparams != null) {
      $result.hyperparams = hyperparams;
    }
    if (stoppingPolicy != null) {
      $result.stoppingPolicy = stoppingPolicy;
    }
    if (triggeredBy != null) {
      $result.triggeredBy = triggeredBy;
    }
    if (commitHash != null) {
      $result.commitHash = commitHash;
    }
    if (labels != null) {
      $result.labels.addAll(labels);
    }
    if (timeoutMinutes != null) {
      $result.timeoutMinutes = timeoutMinutes;
    }
    return $result;
  }
  SubmitTrainingJobRequest._() : super();
  factory SubmitTrainingJobRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubmitTrainingJobRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitTrainingJobRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_orchestration.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'jobId')
    ..aOS(2, _omitFieldNames ? '' : 'taskType')
    ..aOM<DatasetConfig>(3, _omitFieldNames ? '' : 'datasetConfig', subBuilder: DatasetConfig.create)
    ..aOM<TrainingHyperparams>(4, _omitFieldNames ? '' : 'hyperparams', subBuilder: TrainingHyperparams.create)
    ..aOM<EarlyStoppingPolicy>(5, _omitFieldNames ? '' : 'stoppingPolicy', subBuilder: EarlyStoppingPolicy.create)
    ..aOS(6, _omitFieldNames ? '' : 'triggeredBy')
    ..aOS(7, _omitFieldNames ? '' : 'commitHash')
    ..m<$core.String, $core.String>(8, _omitFieldNames ? '' : 'labels', entryClassName: 'SubmitTrainingJobRequest.LabelsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('ml_orchestration.v1'))
    ..a<$core.int>(9, _omitFieldNames ? '' : 'timeoutMinutes', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubmitTrainingJobRequest clone() => SubmitTrainingJobRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubmitTrainingJobRequest copyWith(void Function(SubmitTrainingJobRequest) updates) => super.copyWith((message) => updates(message as SubmitTrainingJobRequest)) as SubmitTrainingJobRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitTrainingJobRequest create() => SubmitTrainingJobRequest._();
  SubmitTrainingJobRequest createEmptyInstance() => create();
  static $pb.PbList<SubmitTrainingJobRequest> createRepeated() => $pb.PbList<SubmitTrainingJobRequest>();
  @$core.pragma('dart2js:noInline')
  static SubmitTrainingJobRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubmitTrainingJobRequest>(create);
  static SubmitTrainingJobRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set jobId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get taskType => $_getSZ(1);
  @$pb.TagNumber(2)
  set taskType($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTaskType() => $_has(1);
  @$pb.TagNumber(2)
  void clearTaskType() => $_clearField(2);

  @$pb.TagNumber(3)
  DatasetConfig get datasetConfig => $_getN(2);
  @$pb.TagNumber(3)
  set datasetConfig(DatasetConfig v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasDatasetConfig() => $_has(2);
  @$pb.TagNumber(3)
  void clearDatasetConfig() => $_clearField(3);
  @$pb.TagNumber(3)
  DatasetConfig ensureDatasetConfig() => $_ensure(2);

  @$pb.TagNumber(4)
  TrainingHyperparams get hyperparams => $_getN(3);
  @$pb.TagNumber(4)
  set hyperparams(TrainingHyperparams v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasHyperparams() => $_has(3);
  @$pb.TagNumber(4)
  void clearHyperparams() => $_clearField(4);
  @$pb.TagNumber(4)
  TrainingHyperparams ensureHyperparams() => $_ensure(3);

  @$pb.TagNumber(5)
  EarlyStoppingPolicy get stoppingPolicy => $_getN(4);
  @$pb.TagNumber(5)
  set stoppingPolicy(EarlyStoppingPolicy v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasStoppingPolicy() => $_has(4);
  @$pb.TagNumber(5)
  void clearStoppingPolicy() => $_clearField(5);
  @$pb.TagNumber(5)
  EarlyStoppingPolicy ensureStoppingPolicy() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get triggeredBy => $_getSZ(5);
  @$pb.TagNumber(6)
  set triggeredBy($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTriggeredBy() => $_has(5);
  @$pb.TagNumber(6)
  void clearTriggeredBy() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get commitHash => $_getSZ(6);
  @$pb.TagNumber(7)
  set commitHash($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasCommitHash() => $_has(6);
  @$pb.TagNumber(7)
  void clearCommitHash() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbMap<$core.String, $core.String> get labels => $_getMap(7);

  @$pb.TagNumber(9)
  $core.int get timeoutMinutes => $_getIZ(8);
  @$pb.TagNumber(9)
  set timeoutMinutes($core.int v) { $_setSignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasTimeoutMinutes() => $_has(8);
  @$pb.TagNumber(9)
  void clearTimeoutMinutes() => $_clearField(9);
}

class SubmitTrainingJobResponse extends $pb.GeneratedMessage {
  factory SubmitTrainingJobResponse({
    $core.String? jobId,
    $core.String? status,
    $core.String? message,
    $fixnum.Int64? queuedAtMs,
  }) {
    final $result = create();
    if (jobId != null) {
      $result.jobId = jobId;
    }
    if (status != null) {
      $result.status = status;
    }
    if (message != null) {
      $result.message = message;
    }
    if (queuedAtMs != null) {
      $result.queuedAtMs = queuedAtMs;
    }
    return $result;
  }
  SubmitTrainingJobResponse._() : super();
  factory SubmitTrainingJobResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubmitTrainingJobResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitTrainingJobResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_orchestration.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'jobId')
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..aInt64(4, _omitFieldNames ? '' : 'queuedAtMs')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubmitTrainingJobResponse clone() => SubmitTrainingJobResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubmitTrainingJobResponse copyWith(void Function(SubmitTrainingJobResponse) updates) => super.copyWith((message) => updates(message as SubmitTrainingJobResponse)) as SubmitTrainingJobResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitTrainingJobResponse create() => SubmitTrainingJobResponse._();
  SubmitTrainingJobResponse createEmptyInstance() => create();
  static $pb.PbList<SubmitTrainingJobResponse> createRepeated() => $pb.PbList<SubmitTrainingJobResponse>();
  @$core.pragma('dart2js:noInline')
  static SubmitTrainingJobResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubmitTrainingJobResponse>(create);
  static SubmitTrainingJobResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set jobId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get queuedAtMs => $_getI64(3);
  @$pb.TagNumber(4)
  set queuedAtMs($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasQueuedAtMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearQueuedAtMs() => $_clearField(4);
}

class TrainingProgress extends $pb.GeneratedMessage {
  factory TrainingProgress({
    $core.int? currentEpoch,
    $core.int? totalEpochs,
    $core.double? completionPercent,
    $fixnum.Int64? elapsedSeconds,
    $fixnum.Int64? estimatedRemainingSeconds,
  }) {
    final $result = create();
    if (currentEpoch != null) {
      $result.currentEpoch = currentEpoch;
    }
    if (totalEpochs != null) {
      $result.totalEpochs = totalEpochs;
    }
    if (completionPercent != null) {
      $result.completionPercent = completionPercent;
    }
    if (elapsedSeconds != null) {
      $result.elapsedSeconds = elapsedSeconds;
    }
    if (estimatedRemainingSeconds != null) {
      $result.estimatedRemainingSeconds = estimatedRemainingSeconds;
    }
    return $result;
  }
  TrainingProgress._() : super();
  factory TrainingProgress.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrainingProgress.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TrainingProgress', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_orchestration.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'currentEpoch', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'totalEpochs', $pb.PbFieldType.O3)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'completionPercent', $pb.PbFieldType.OD)
    ..aInt64(4, _omitFieldNames ? '' : 'elapsedSeconds')
    ..aInt64(5, _omitFieldNames ? '' : 'estimatedRemainingSeconds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrainingProgress clone() => TrainingProgress()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrainingProgress copyWith(void Function(TrainingProgress) updates) => super.copyWith((message) => updates(message as TrainingProgress)) as TrainingProgress;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrainingProgress create() => TrainingProgress._();
  TrainingProgress createEmptyInstance() => create();
  static $pb.PbList<TrainingProgress> createRepeated() => $pb.PbList<TrainingProgress>();
  @$core.pragma('dart2js:noInline')
  static TrainingProgress getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrainingProgress>(create);
  static TrainingProgress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get currentEpoch => $_getIZ(0);
  @$pb.TagNumber(1)
  set currentEpoch($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCurrentEpoch() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentEpoch() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get totalEpochs => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalEpochs($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotalEpochs() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalEpochs() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get completionPercent => $_getN(2);
  @$pb.TagNumber(3)
  set completionPercent($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCompletionPercent() => $_has(2);
  @$pb.TagNumber(3)
  void clearCompletionPercent() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get elapsedSeconds => $_getI64(3);
  @$pb.TagNumber(4)
  set elapsedSeconds($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasElapsedSeconds() => $_has(3);
  @$pb.TagNumber(4)
  void clearElapsedSeconds() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get estimatedRemainingSeconds => $_getI64(4);
  @$pb.TagNumber(5)
  set estimatedRemainingSeconds($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasEstimatedRemainingSeconds() => $_has(4);
  @$pb.TagNumber(5)
  void clearEstimatedRemainingSeconds() => $_clearField(5);
}

class TrainingMetrics extends $pb.GeneratedMessage {
  factory TrainingMetrics({
    $core.double? trainLoss,
    $core.double? validationLoss,
    $core.double? testLoss,
    $core.double? testMae,
    $core.double? testRmse,
    $core.double? testR2Score,
    $core.double? testCoverageLower,
    $core.double? testCoverageUpper,
    $pb.PbMap<$core.String, $core.double>? customMetrics,
  }) {
    final $result = create();
    if (trainLoss != null) {
      $result.trainLoss = trainLoss;
    }
    if (validationLoss != null) {
      $result.validationLoss = validationLoss;
    }
    if (testLoss != null) {
      $result.testLoss = testLoss;
    }
    if (testMae != null) {
      $result.testMae = testMae;
    }
    if (testRmse != null) {
      $result.testRmse = testRmse;
    }
    if (testR2Score != null) {
      $result.testR2Score = testR2Score;
    }
    if (testCoverageLower != null) {
      $result.testCoverageLower = testCoverageLower;
    }
    if (testCoverageUpper != null) {
      $result.testCoverageUpper = testCoverageUpper;
    }
    if (customMetrics != null) {
      $result.customMetrics.addAll(customMetrics);
    }
    return $result;
  }
  TrainingMetrics._() : super();
  factory TrainingMetrics.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrainingMetrics.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TrainingMetrics', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_orchestration.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'trainLoss', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'validationLoss', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'testLoss', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'testMae', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'testRmse', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'testR2Score', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'testCoverageLower', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'testCoverageUpper', $pb.PbFieldType.OD)
    ..m<$core.String, $core.double>(9, _omitFieldNames ? '' : 'customMetrics', entryClassName: 'TrainingMetrics.CustomMetricsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OD, packageName: const $pb.PackageName('ml_orchestration.v1'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrainingMetrics clone() => TrainingMetrics()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrainingMetrics copyWith(void Function(TrainingMetrics) updates) => super.copyWith((message) => updates(message as TrainingMetrics)) as TrainingMetrics;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrainingMetrics create() => TrainingMetrics._();
  TrainingMetrics createEmptyInstance() => create();
  static $pb.PbList<TrainingMetrics> createRepeated() => $pb.PbList<TrainingMetrics>();
  @$core.pragma('dart2js:noInline')
  static TrainingMetrics getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrainingMetrics>(create);
  static TrainingMetrics? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get trainLoss => $_getN(0);
  @$pb.TagNumber(1)
  set trainLoss($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTrainLoss() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrainLoss() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get validationLoss => $_getN(1);
  @$pb.TagNumber(2)
  set validationLoss($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValidationLoss() => $_has(1);
  @$pb.TagNumber(2)
  void clearValidationLoss() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get testLoss => $_getN(2);
  @$pb.TagNumber(3)
  set testLoss($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTestLoss() => $_has(2);
  @$pb.TagNumber(3)
  void clearTestLoss() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get testMae => $_getN(3);
  @$pb.TagNumber(4)
  set testMae($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTestMae() => $_has(3);
  @$pb.TagNumber(4)
  void clearTestMae() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get testRmse => $_getN(4);
  @$pb.TagNumber(5)
  set testRmse($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTestRmse() => $_has(4);
  @$pb.TagNumber(5)
  void clearTestRmse() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get testR2Score => $_getN(5);
  @$pb.TagNumber(6)
  set testR2Score($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTestR2Score() => $_has(5);
  @$pb.TagNumber(6)
  void clearTestR2Score() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get testCoverageLower => $_getN(6);
  @$pb.TagNumber(7)
  set testCoverageLower($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTestCoverageLower() => $_has(6);
  @$pb.TagNumber(7)
  void clearTestCoverageLower() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get testCoverageUpper => $_getN(7);
  @$pb.TagNumber(8)
  set testCoverageUpper($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasTestCoverageUpper() => $_has(7);
  @$pb.TagNumber(8)
  void clearTestCoverageUpper() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbMap<$core.String, $core.double> get customMetrics => $_getMap(8);
}

class ModelArtifactInfo extends $pb.GeneratedMessage {
  factory ModelArtifactInfo({
    $core.String? path,
    $core.String? hash,
    $fixnum.Int64? sizeBytes,
    $core.String? format,
  }) {
    final $result = create();
    if (path != null) {
      $result.path = path;
    }
    if (hash != null) {
      $result.hash = hash;
    }
    if (sizeBytes != null) {
      $result.sizeBytes = sizeBytes;
    }
    if (format != null) {
      $result.format = format;
    }
    return $result;
  }
  ModelArtifactInfo._() : super();
  factory ModelArtifactInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ModelArtifactInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ModelArtifactInfo', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_orchestration.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..aOS(2, _omitFieldNames ? '' : 'hash')
    ..aInt64(3, _omitFieldNames ? '' : 'sizeBytes')
    ..aOS(4, _omitFieldNames ? '' : 'format')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ModelArtifactInfo clone() => ModelArtifactInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ModelArtifactInfo copyWith(void Function(ModelArtifactInfo) updates) => super.copyWith((message) => updates(message as ModelArtifactInfo)) as ModelArtifactInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ModelArtifactInfo create() => ModelArtifactInfo._();
  ModelArtifactInfo createEmptyInstance() => create();
  static $pb.PbList<ModelArtifactInfo> createRepeated() => $pb.PbList<ModelArtifactInfo>();
  @$core.pragma('dart2js:noInline')
  static ModelArtifactInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ModelArtifactInfo>(create);
  static ModelArtifactInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get hash => $_getSZ(1);
  @$pb.TagNumber(2)
  set hash($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearHash() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get sizeBytes => $_getI64(2);
  @$pb.TagNumber(3)
  set sizeBytes($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSizeBytes() => $_has(2);
  @$pb.TagNumber(3)
  void clearSizeBytes() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get format => $_getSZ(3);
  @$pb.TagNumber(4)
  set format($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasFormat() => $_has(3);
  @$pb.TagNumber(4)
  void clearFormat() => $_clearField(4);
}

class GetJobStatusRequest extends $pb.GeneratedMessage {
  factory GetJobStatusRequest({
    $core.String? jobId,
  }) {
    final $result = create();
    if (jobId != null) {
      $result.jobId = jobId;
    }
    return $result;
  }
  GetJobStatusRequest._() : super();
  factory GetJobStatusRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetJobStatusRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetJobStatusRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_orchestration.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'jobId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetJobStatusRequest clone() => GetJobStatusRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetJobStatusRequest copyWith(void Function(GetJobStatusRequest) updates) => super.copyWith((message) => updates(message as GetJobStatusRequest)) as GetJobStatusRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetJobStatusRequest create() => GetJobStatusRequest._();
  GetJobStatusRequest createEmptyInstance() => create();
  static $pb.PbList<GetJobStatusRequest> createRepeated() => $pb.PbList<GetJobStatusRequest>();
  @$core.pragma('dart2js:noInline')
  static GetJobStatusRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetJobStatusRequest>(create);
  static GetJobStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set jobId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);
}

class GetJobStatusResponse extends $pb.GeneratedMessage {
  factory GetJobStatusResponse({
    $core.String? jobId,
    $core.String? status,
    TrainingProgress? progress,
    TrainingMetrics? metrics,
    ModelArtifactInfo? artifact,
    $core.String? modelVersionId,
    $core.String? errorMessage,
    $fixnum.Int64? startedAtMs,
    $fixnum.Int64? completedAtMs,
    $pb.PbMap<$core.String, $core.String>? logs,
  }) {
    final $result = create();
    if (jobId != null) {
      $result.jobId = jobId;
    }
    if (status != null) {
      $result.status = status;
    }
    if (progress != null) {
      $result.progress = progress;
    }
    if (metrics != null) {
      $result.metrics = metrics;
    }
    if (artifact != null) {
      $result.artifact = artifact;
    }
    if (modelVersionId != null) {
      $result.modelVersionId = modelVersionId;
    }
    if (errorMessage != null) {
      $result.errorMessage = errorMessage;
    }
    if (startedAtMs != null) {
      $result.startedAtMs = startedAtMs;
    }
    if (completedAtMs != null) {
      $result.completedAtMs = completedAtMs;
    }
    if (logs != null) {
      $result.logs.addAll(logs);
    }
    return $result;
  }
  GetJobStatusResponse._() : super();
  factory GetJobStatusResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetJobStatusResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetJobStatusResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_orchestration.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'jobId')
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..aOM<TrainingProgress>(3, _omitFieldNames ? '' : 'progress', subBuilder: TrainingProgress.create)
    ..aOM<TrainingMetrics>(4, _omitFieldNames ? '' : 'metrics', subBuilder: TrainingMetrics.create)
    ..aOM<ModelArtifactInfo>(5, _omitFieldNames ? '' : 'artifact', subBuilder: ModelArtifactInfo.create)
    ..aOS(6, _omitFieldNames ? '' : 'modelVersionId')
    ..aOS(7, _omitFieldNames ? '' : 'errorMessage')
    ..aInt64(8, _omitFieldNames ? '' : 'startedAtMs')
    ..aInt64(9, _omitFieldNames ? '' : 'completedAtMs')
    ..m<$core.String, $core.String>(10, _omitFieldNames ? '' : 'logs', entryClassName: 'GetJobStatusResponse.LogsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('ml_orchestration.v1'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetJobStatusResponse clone() => GetJobStatusResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetJobStatusResponse copyWith(void Function(GetJobStatusResponse) updates) => super.copyWith((message) => updates(message as GetJobStatusResponse)) as GetJobStatusResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetJobStatusResponse create() => GetJobStatusResponse._();
  GetJobStatusResponse createEmptyInstance() => create();
  static $pb.PbList<GetJobStatusResponse> createRepeated() => $pb.PbList<GetJobStatusResponse>();
  @$core.pragma('dart2js:noInline')
  static GetJobStatusResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetJobStatusResponse>(create);
  static GetJobStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set jobId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  TrainingProgress get progress => $_getN(2);
  @$pb.TagNumber(3)
  set progress(TrainingProgress v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasProgress() => $_has(2);
  @$pb.TagNumber(3)
  void clearProgress() => $_clearField(3);
  @$pb.TagNumber(3)
  TrainingProgress ensureProgress() => $_ensure(2);

  @$pb.TagNumber(4)
  TrainingMetrics get metrics => $_getN(3);
  @$pb.TagNumber(4)
  set metrics(TrainingMetrics v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasMetrics() => $_has(3);
  @$pb.TagNumber(4)
  void clearMetrics() => $_clearField(4);
  @$pb.TagNumber(4)
  TrainingMetrics ensureMetrics() => $_ensure(3);

  @$pb.TagNumber(5)
  ModelArtifactInfo get artifact => $_getN(4);
  @$pb.TagNumber(5)
  set artifact(ModelArtifactInfo v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasArtifact() => $_has(4);
  @$pb.TagNumber(5)
  void clearArtifact() => $_clearField(5);
  @$pb.TagNumber(5)
  ModelArtifactInfo ensureArtifact() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get modelVersionId => $_getSZ(5);
  @$pb.TagNumber(6)
  set modelVersionId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasModelVersionId() => $_has(5);
  @$pb.TagNumber(6)
  void clearModelVersionId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get errorMessage => $_getSZ(6);
  @$pb.TagNumber(7)
  set errorMessage($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasErrorMessage() => $_has(6);
  @$pb.TagNumber(7)
  void clearErrorMessage() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get startedAtMs => $_getI64(7);
  @$pb.TagNumber(8)
  set startedAtMs($fixnum.Int64 v) { $_setInt64(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasStartedAtMs() => $_has(7);
  @$pb.TagNumber(8)
  void clearStartedAtMs() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get completedAtMs => $_getI64(8);
  @$pb.TagNumber(9)
  set completedAtMs($fixnum.Int64 v) { $_setInt64(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasCompletedAtMs() => $_has(8);
  @$pb.TagNumber(9)
  void clearCompletedAtMs() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbMap<$core.String, $core.String> get logs => $_getMap(9);
}

class CancelJobRequest extends $pb.GeneratedMessage {
  factory CancelJobRequest({
    $core.String? jobId,
    $core.String? reason,
    $core.String? cancelledBy,
  }) {
    final $result = create();
    if (jobId != null) {
      $result.jobId = jobId;
    }
    if (reason != null) {
      $result.reason = reason;
    }
    if (cancelledBy != null) {
      $result.cancelledBy = cancelledBy;
    }
    return $result;
  }
  CancelJobRequest._() : super();
  factory CancelJobRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CancelJobRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CancelJobRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_orchestration.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'jobId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aOS(3, _omitFieldNames ? '' : 'cancelledBy')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CancelJobRequest clone() => CancelJobRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CancelJobRequest copyWith(void Function(CancelJobRequest) updates) => super.copyWith((message) => updates(message as CancelJobRequest)) as CancelJobRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelJobRequest create() => CancelJobRequest._();
  CancelJobRequest createEmptyInstance() => create();
  static $pb.PbList<CancelJobRequest> createRepeated() => $pb.PbList<CancelJobRequest>();
  @$core.pragma('dart2js:noInline')
  static CancelJobRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CancelJobRequest>(create);
  static CancelJobRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set jobId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get cancelledBy => $_getSZ(2);
  @$pb.TagNumber(3)
  set cancelledBy($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCancelledBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearCancelledBy() => $_clearField(3);
}

class CancelJobResponse extends $pb.GeneratedMessage {
  factory CancelJobResponse({
    $core.String? jobId,
    $core.bool? cancelled,
    $core.String? message,
  }) {
    final $result = create();
    if (jobId != null) {
      $result.jobId = jobId;
    }
    if (cancelled != null) {
      $result.cancelled = cancelled;
    }
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  CancelJobResponse._() : super();
  factory CancelJobResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CancelJobResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CancelJobResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_orchestration.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'jobId')
    ..aOB(2, _omitFieldNames ? '' : 'cancelled')
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CancelJobResponse clone() => CancelJobResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CancelJobResponse copyWith(void Function(CancelJobResponse) updates) => super.copyWith((message) => updates(message as CancelJobResponse)) as CancelJobResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelJobResponse create() => CancelJobResponse._();
  CancelJobResponse createEmptyInstance() => create();
  static $pb.PbList<CancelJobResponse> createRepeated() => $pb.PbList<CancelJobResponse>();
  @$core.pragma('dart2js:noInline')
  static CancelJobResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CancelJobResponse>(create);
  static CancelJobResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set jobId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get cancelled => $_getBF(1);
  @$pb.TagNumber(2)
  set cancelled($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCancelled() => $_has(1);
  @$pb.TagNumber(2)
  void clearCancelled() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);
}

class JobHistoryFilter extends $pb.GeneratedMessage {
  factory JobHistoryFilter({
    $core.String? taskType,
    $core.String? status,
    $core.int? limit,
    $core.int? offset,
  }) {
    final $result = create();
    if (taskType != null) {
      $result.taskType = taskType;
    }
    if (status != null) {
      $result.status = status;
    }
    if (limit != null) {
      $result.limit = limit;
    }
    if (offset != null) {
      $result.offset = offset;
    }
    return $result;
  }
  JobHistoryFilter._() : super();
  factory JobHistoryFilter.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JobHistoryFilter.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'JobHistoryFilter', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_orchestration.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskType')
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'offset', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JobHistoryFilter clone() => JobHistoryFilter()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JobHistoryFilter copyWith(void Function(JobHistoryFilter) updates) => super.copyWith((message) => updates(message as JobHistoryFilter)) as JobHistoryFilter;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JobHistoryFilter create() => JobHistoryFilter._();
  JobHistoryFilter createEmptyInstance() => create();
  static $pb.PbList<JobHistoryFilter> createRepeated() => $pb.PbList<JobHistoryFilter>();
  @$core.pragma('dart2js:noInline')
  static JobHistoryFilter getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JobHistoryFilter>(create);
  static JobHistoryFilter? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get taskType => $_getSZ(0);
  @$pb.TagNumber(1)
  set taskType($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTaskType() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaskType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get offset => $_getIZ(3);
  @$pb.TagNumber(4)
  set offset($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasOffset() => $_has(3);
  @$pb.TagNumber(4)
  void clearOffset() => $_clearField(4);
}

class JobHistoryEntry extends $pb.GeneratedMessage {
  factory JobHistoryEntry({
    $core.String? jobId,
    $core.String? taskType,
    $core.String? status,
    $core.String? triggeredBy,
    $fixnum.Int64? createdAtMs,
    $fixnum.Int64? completedAtMs,
    $core.String? modelVersionId,
  }) {
    final $result = create();
    if (jobId != null) {
      $result.jobId = jobId;
    }
    if (taskType != null) {
      $result.taskType = taskType;
    }
    if (status != null) {
      $result.status = status;
    }
    if (triggeredBy != null) {
      $result.triggeredBy = triggeredBy;
    }
    if (createdAtMs != null) {
      $result.createdAtMs = createdAtMs;
    }
    if (completedAtMs != null) {
      $result.completedAtMs = completedAtMs;
    }
    if (modelVersionId != null) {
      $result.modelVersionId = modelVersionId;
    }
    return $result;
  }
  JobHistoryEntry._() : super();
  factory JobHistoryEntry.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JobHistoryEntry.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'JobHistoryEntry', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_orchestration.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'jobId')
    ..aOS(2, _omitFieldNames ? '' : 'taskType')
    ..aOS(3, _omitFieldNames ? '' : 'status')
    ..aOS(4, _omitFieldNames ? '' : 'triggeredBy')
    ..aInt64(5, _omitFieldNames ? '' : 'createdAtMs')
    ..aInt64(6, _omitFieldNames ? '' : 'completedAtMs')
    ..aOS(7, _omitFieldNames ? '' : 'modelVersionId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JobHistoryEntry clone() => JobHistoryEntry()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JobHistoryEntry copyWith(void Function(JobHistoryEntry) updates) => super.copyWith((message) => updates(message as JobHistoryEntry)) as JobHistoryEntry;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JobHistoryEntry create() => JobHistoryEntry._();
  JobHistoryEntry createEmptyInstance() => create();
  static $pb.PbList<JobHistoryEntry> createRepeated() => $pb.PbList<JobHistoryEntry>();
  @$core.pragma('dart2js:noInline')
  static JobHistoryEntry getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JobHistoryEntry>(create);
  static JobHistoryEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set jobId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get taskType => $_getSZ(1);
  @$pb.TagNumber(2)
  set taskType($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTaskType() => $_has(1);
  @$pb.TagNumber(2)
  void clearTaskType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get status => $_getSZ(2);
  @$pb.TagNumber(3)
  set status($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get triggeredBy => $_getSZ(3);
  @$pb.TagNumber(4)
  set triggeredBy($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTriggeredBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearTriggeredBy() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get createdAtMs => $_getI64(4);
  @$pb.TagNumber(5)
  set createdAtMs($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCreatedAtMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatedAtMs() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get completedAtMs => $_getI64(5);
  @$pb.TagNumber(6)
  set completedAtMs($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCompletedAtMs() => $_has(5);
  @$pb.TagNumber(6)
  void clearCompletedAtMs() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get modelVersionId => $_getSZ(6);
  @$pb.TagNumber(7)
  set modelVersionId($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasModelVersionId() => $_has(6);
  @$pb.TagNumber(7)
  void clearModelVersionId() => $_clearField(7);
}

class GetJobHistoryRequest extends $pb.GeneratedMessage {
  factory GetJobHistoryRequest({
    JobHistoryFilter? filter,
  }) {
    final $result = create();
    if (filter != null) {
      $result.filter = filter;
    }
    return $result;
  }
  GetJobHistoryRequest._() : super();
  factory GetJobHistoryRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetJobHistoryRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetJobHistoryRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_orchestration.v1'), createEmptyInstance: create)
    ..aOM<JobHistoryFilter>(1, _omitFieldNames ? '' : 'filter', subBuilder: JobHistoryFilter.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetJobHistoryRequest clone() => GetJobHistoryRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetJobHistoryRequest copyWith(void Function(GetJobHistoryRequest) updates) => super.copyWith((message) => updates(message as GetJobHistoryRequest)) as GetJobHistoryRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetJobHistoryRequest create() => GetJobHistoryRequest._();
  GetJobHistoryRequest createEmptyInstance() => create();
  static $pb.PbList<GetJobHistoryRequest> createRepeated() => $pb.PbList<GetJobHistoryRequest>();
  @$core.pragma('dart2js:noInline')
  static GetJobHistoryRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetJobHistoryRequest>(create);
  static GetJobHistoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  JobHistoryFilter get filter => $_getN(0);
  @$pb.TagNumber(1)
  set filter(JobHistoryFilter v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasFilter() => $_has(0);
  @$pb.TagNumber(1)
  void clearFilter() => $_clearField(1);
  @$pb.TagNumber(1)
  JobHistoryFilter ensureFilter() => $_ensure(0);
}

class GetJobHistoryResponse extends $pb.GeneratedMessage {
  factory GetJobHistoryResponse({
    $core.Iterable<JobHistoryEntry>? jobs,
    $core.int? totalCount,
  }) {
    final $result = create();
    if (jobs != null) {
      $result.jobs.addAll(jobs);
    }
    if (totalCount != null) {
      $result.totalCount = totalCount;
    }
    return $result;
  }
  GetJobHistoryResponse._() : super();
  factory GetJobHistoryResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetJobHistoryResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetJobHistoryResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_orchestration.v1'), createEmptyInstance: create)
    ..pc<JobHistoryEntry>(1, _omitFieldNames ? '' : 'jobs', $pb.PbFieldType.PM, subBuilder: JobHistoryEntry.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'totalCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetJobHistoryResponse clone() => GetJobHistoryResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetJobHistoryResponse copyWith(void Function(GetJobHistoryResponse) updates) => super.copyWith((message) => updates(message as GetJobHistoryResponse)) as GetJobHistoryResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetJobHistoryResponse create() => GetJobHistoryResponse._();
  GetJobHistoryResponse createEmptyInstance() => create();
  static $pb.PbList<GetJobHistoryResponse> createRepeated() => $pb.PbList<GetJobHistoryResponse>();
  @$core.pragma('dart2js:noInline')
  static GetJobHistoryResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetJobHistoryResponse>(create);
  static GetJobHistoryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<JobHistoryEntry> get jobs => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get totalCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalCount($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotalCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalCount() => $_clearField(2);
}

class MLOrchestrationServiceApi {
  $pb.RpcClient _client;
  MLOrchestrationServiceApi(this._client);

  $async.Future<SubmitTrainingJobResponse> submitTrainingJob($pb.ClientContext? ctx, SubmitTrainingJobRequest request) =>
    _client.invoke<SubmitTrainingJobResponse>(ctx, 'MLOrchestrationService', 'SubmitTrainingJob', request, SubmitTrainingJobResponse())
  ;
  $async.Future<GetJobStatusResponse> getJobStatus($pb.ClientContext? ctx, GetJobStatusRequest request) =>
    _client.invoke<GetJobStatusResponse>(ctx, 'MLOrchestrationService', 'GetJobStatus', request, GetJobStatusResponse())
  ;
  $async.Future<CancelJobResponse> cancelJob($pb.ClientContext? ctx, CancelJobRequest request) =>
    _client.invoke<CancelJobResponse>(ctx, 'MLOrchestrationService', 'CancelJob', request, CancelJobResponse())
  ;
  $async.Future<GetJobHistoryResponse> getJobHistory($pb.ClientContext? ctx, GetJobHistoryRequest request) =>
    _client.invoke<GetJobHistoryResponse>(ctx, 'MLOrchestrationService', 'GetJobHistory', request, GetJobHistoryResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
