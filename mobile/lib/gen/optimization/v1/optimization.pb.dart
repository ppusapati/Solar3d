//
//  Generated code. Do not modify.
//  source: optimization/v1/optimization.proto
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

import 'optimization.pbenum.dart';
import 'optimization_domain.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'optimization.pbenum.dart';

class Objective extends $pb.GeneratedMessage {
  factory Objective({
    $core.String? name,
    Objective_ObjectiveKind? kind,
    $core.double? weight,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (kind != null) {
      $result.kind = kind;
    }
    if (weight != null) {
      $result.weight = weight;
    }
    return $result;
  }
  Objective._() : super();
  factory Objective.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Objective.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Objective', package: const $pb.PackageName(_omitMessageNames ? '' : 'optimization.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..e<Objective_ObjectiveKind>(2, _omitFieldNames ? '' : 'kind', $pb.PbFieldType.OE, defaultOrMaker: Objective_ObjectiveKind.MINIMIZE, valueOf: Objective_ObjectiveKind.valueOf, enumValues: Objective_ObjectiveKind.values)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'weight', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Objective clone() => Objective()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Objective copyWith(void Function(Objective) updates) => super.copyWith((message) => updates(message as Objective)) as Objective;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Objective create() => Objective._();
  Objective createEmptyInstance() => create();
  static $pb.PbList<Objective> createRepeated() => $pb.PbList<Objective>();
  @$core.pragma('dart2js:noInline')
  static Objective getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Objective>(create);
  static Objective? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  Objective_ObjectiveKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(Objective_ObjectiveKind v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get weight => $_getN(2);
  @$pb.TagNumber(3)
  set weight($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasWeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearWeight() => $_clearField(3);
}

class Solution extends $pb.GeneratedMessage {
  factory Solution({
    $core.int? id,
    $core.Iterable<$core.double>? variables,
    $core.Iterable<$core.double>? objectives,
    $core.double? rank,
    $core.double? crowdingDistance,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (variables != null) {
      $result.variables.addAll(variables);
    }
    if (objectives != null) {
      $result.objectives.addAll(objectives);
    }
    if (rank != null) {
      $result.rank = rank;
    }
    if (crowdingDistance != null) {
      $result.crowdingDistance = crowdingDistance;
    }
    return $result;
  }
  Solution._() : super();
  factory Solution.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Solution.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Solution', package: const $pb.PackageName(_omitMessageNames ? '' : 'optimization.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..p<$core.double>(2, _omitFieldNames ? '' : 'variables', $pb.PbFieldType.KD)
    ..p<$core.double>(3, _omitFieldNames ? '' : 'objectives', $pb.PbFieldType.KD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'rank', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'crowdingDistance', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Solution clone() => Solution()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Solution copyWith(void Function(Solution) updates) => super.copyWith((message) => updates(message as Solution)) as Solution;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Solution create() => Solution._();
  Solution createEmptyInstance() => create();
  static $pb.PbList<Solution> createRepeated() => $pb.PbList<Solution>();
  @$core.pragma('dart2js:noInline')
  static Solution getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Solution>(create);
  static Solution? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.double> get variables => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.double> get objectives => $_getList(2);

  @$pb.TagNumber(4)
  $core.double get rank => $_getN(3);
  @$pb.TagNumber(4)
  set rank($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRank() => $_has(3);
  @$pb.TagNumber(4)
  void clearRank() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get crowdingDistance => $_getN(4);
  @$pb.TagNumber(5)
  set crowdingDistance($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCrowdingDistance() => $_has(4);
  @$pb.TagNumber(5)
  void clearCrowdingDistance() => $_clearField(5);
}

class ParetoFrontierResponse extends $pb.GeneratedMessage {
  factory ParetoFrontierResponse({
    $core.Iterable<Solution>? solutions,
    $core.int? frontierSize,
    $core.Iterable<$core.int>? solutionIds,
  }) {
    final $result = create();
    if (solutions != null) {
      $result.solutions.addAll(solutions);
    }
    if (frontierSize != null) {
      $result.frontierSize = frontierSize;
    }
    if (solutionIds != null) {
      $result.solutionIds.addAll(solutionIds);
    }
    return $result;
  }
  ParetoFrontierResponse._() : super();
  factory ParetoFrontierResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ParetoFrontierResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ParetoFrontierResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'optimization.v1'), createEmptyInstance: create)
    ..pc<Solution>(1, _omitFieldNames ? '' : 'solutions', $pb.PbFieldType.PM, subBuilder: Solution.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'frontierSize', $pb.PbFieldType.O3)
    ..p<$core.int>(3, _omitFieldNames ? '' : 'solutionIds', $pb.PbFieldType.K3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ParetoFrontierResponse clone() => ParetoFrontierResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ParetoFrontierResponse copyWith(void Function(ParetoFrontierResponse) updates) => super.copyWith((message) => updates(message as ParetoFrontierResponse)) as ParetoFrontierResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ParetoFrontierResponse create() => ParetoFrontierResponse._();
  ParetoFrontierResponse createEmptyInstance() => create();
  static $pb.PbList<ParetoFrontierResponse> createRepeated() => $pb.PbList<ParetoFrontierResponse>();
  @$core.pragma('dart2js:noInline')
  static ParetoFrontierResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ParetoFrontierResponse>(create);
  static ParetoFrontierResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Solution> get solutions => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get frontierSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set frontierSize($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFrontierSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearFrontierSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.int> get solutionIds => $_getList(2);
}

class AddToFrontierRequest extends $pb.GeneratedMessage {
  factory AddToFrontierRequest({
    $core.Iterable<Objective>? objectives,
    Solution? newSolution,
    $1.MultiObjectiveOptimizationInput? input,
  }) {
    final $result = create();
    if (objectives != null) {
      $result.objectives.addAll(objectives);
    }
    if (newSolution != null) {
      $result.newSolution = newSolution;
    }
    if (input != null) {
      $result.input = input;
    }
    return $result;
  }
  AddToFrontierRequest._() : super();
  factory AddToFrontierRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddToFrontierRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AddToFrontierRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'optimization.v1'), createEmptyInstance: create)
    ..pc<Objective>(1, _omitFieldNames ? '' : 'objectives', $pb.PbFieldType.PM, subBuilder: Objective.create)
    ..aOM<Solution>(2, _omitFieldNames ? '' : 'newSolution', subBuilder: Solution.create)
    ..aOM<$1.MultiObjectiveOptimizationInput>(10, _omitFieldNames ? '' : 'input', subBuilder: $1.MultiObjectiveOptimizationInput.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddToFrontierRequest clone() => AddToFrontierRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddToFrontierRequest copyWith(void Function(AddToFrontierRequest) updates) => super.copyWith((message) => updates(message as AddToFrontierRequest)) as AddToFrontierRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddToFrontierRequest create() => AddToFrontierRequest._();
  AddToFrontierRequest createEmptyInstance() => create();
  static $pb.PbList<AddToFrontierRequest> createRepeated() => $pb.PbList<AddToFrontierRequest>();
  @$core.pragma('dart2js:noInline')
  static AddToFrontierRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddToFrontierRequest>(create);
  static AddToFrontierRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Objective> get objectives => $_getList(0);

  @$pb.TagNumber(2)
  Solution get newSolution => $_getN(1);
  @$pb.TagNumber(2)
  set newSolution(Solution v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasNewSolution() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewSolution() => $_clearField(2);
  @$pb.TagNumber(2)
  Solution ensureNewSolution() => $_ensure(1);

  @$pb.TagNumber(10)
  $1.MultiObjectiveOptimizationInput get input => $_getN(2);
  @$pb.TagNumber(10)
  set input($1.MultiObjectiveOptimizationInput v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasInput() => $_has(2);
  @$pb.TagNumber(10)
  void clearInput() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.MultiObjectiveOptimizationInput ensureInput() => $_ensure(2);
}

class Distribution extends $pb.GeneratedMessage {
  factory Distribution({
    $core.double? mean,
    $core.double? stdDev,
  }) {
    final $result = create();
    if (mean != null) {
      $result.mean = mean;
    }
    if (stdDev != null) {
      $result.stdDev = stdDev;
    }
    return $result;
  }
  Distribution._() : super();
  factory Distribution.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Distribution.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Distribution', package: const $pb.PackageName(_omitMessageNames ? '' : 'optimization.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'mean', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'stdDev', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Distribution clone() => Distribution()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Distribution copyWith(void Function(Distribution) updates) => super.copyWith((message) => updates(message as Distribution)) as Distribution;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Distribution create() => Distribution._();
  Distribution createEmptyInstance() => create();
  static $pb.PbList<Distribution> createRepeated() => $pb.PbList<Distribution>();
  @$core.pragma('dart2js:noInline')
  static Distribution getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Distribution>(create);
  static Distribution? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get mean => $_getN(0);
  @$pb.TagNumber(1)
  set mean($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMean() => $_has(0);
  @$pb.TagNumber(1)
  void clearMean() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get stdDev => $_getN(1);
  @$pb.TagNumber(2)
  set stdDev($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStdDev() => $_has(1);
  @$pb.TagNumber(2)
  void clearStdDev() => $_clearField(2);
}

class MonteCarloRequest extends $pb.GeneratedMessage {
  factory MonteCarloRequest({
    $core.Iterable<Distribution>? distributions,
    $core.int? numSamples,
    $fixnum.Int64? seed,
    $1.UncertaintyModel? uncertaintyModel,
  }) {
    final $result = create();
    if (distributions != null) {
      $result.distributions.addAll(distributions);
    }
    if (numSamples != null) {
      $result.numSamples = numSamples;
    }
    if (seed != null) {
      $result.seed = seed;
    }
    if (uncertaintyModel != null) {
      $result.uncertaintyModel = uncertaintyModel;
    }
    return $result;
  }
  MonteCarloRequest._() : super();
  factory MonteCarloRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MonteCarloRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MonteCarloRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'optimization.v1'), createEmptyInstance: create)
    ..pc<Distribution>(1, _omitFieldNames ? '' : 'distributions', $pb.PbFieldType.PM, subBuilder: Distribution.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'numSamples', $pb.PbFieldType.O3)
    ..aInt64(3, _omitFieldNames ? '' : 'seed')
    ..aOM<$1.UncertaintyModel>(10, _omitFieldNames ? '' : 'uncertaintyModel', subBuilder: $1.UncertaintyModel.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MonteCarloRequest clone() => MonteCarloRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MonteCarloRequest copyWith(void Function(MonteCarloRequest) updates) => super.copyWith((message) => updates(message as MonteCarloRequest)) as MonteCarloRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MonteCarloRequest create() => MonteCarloRequest._();
  MonteCarloRequest createEmptyInstance() => create();
  static $pb.PbList<MonteCarloRequest> createRepeated() => $pb.PbList<MonteCarloRequest>();
  @$core.pragma('dart2js:noInline')
  static MonteCarloRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MonteCarloRequest>(create);
  static MonteCarloRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Distribution> get distributions => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get numSamples => $_getIZ(1);
  @$pb.TagNumber(2)
  set numSamples($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNumSamples() => $_has(1);
  @$pb.TagNumber(2)
  void clearNumSamples() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get seed => $_getI64(2);
  @$pb.TagNumber(3)
  set seed($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSeed() => $_has(2);
  @$pb.TagNumber(3)
  void clearSeed() => $_clearField(3);

  @$pb.TagNumber(10)
  $1.UncertaintyModel get uncertaintyModel => $_getN(3);
  @$pb.TagNumber(10)
  set uncertaintyModel($1.UncertaintyModel v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasUncertaintyModel() => $_has(3);
  @$pb.TagNumber(10)
  void clearUncertaintyModel() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.UncertaintyModel ensureUncertaintyModel() => $_ensure(3);
}

class MonteCarloResponse extends $pb.GeneratedMessage {
  factory MonteCarloResponse({
    $core.double? mean,
    $core.double? stdDev,
    $core.double? p10,
    $core.double? p50,
    $core.double? p90,
    $core.double? minValue,
    $core.double? maxValue,
  }) {
    final $result = create();
    if (mean != null) {
      $result.mean = mean;
    }
    if (stdDev != null) {
      $result.stdDev = stdDev;
    }
    if (p10 != null) {
      $result.p10 = p10;
    }
    if (p50 != null) {
      $result.p50 = p50;
    }
    if (p90 != null) {
      $result.p90 = p90;
    }
    if (minValue != null) {
      $result.minValue = minValue;
    }
    if (maxValue != null) {
      $result.maxValue = maxValue;
    }
    return $result;
  }
  MonteCarloResponse._() : super();
  factory MonteCarloResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MonteCarloResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MonteCarloResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'optimization.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'mean', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'stdDev', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'p10', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'p50', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'p90', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'minValue', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'maxValue', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MonteCarloResponse clone() => MonteCarloResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MonteCarloResponse copyWith(void Function(MonteCarloResponse) updates) => super.copyWith((message) => updates(message as MonteCarloResponse)) as MonteCarloResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MonteCarloResponse create() => MonteCarloResponse._();
  MonteCarloResponse createEmptyInstance() => create();
  static $pb.PbList<MonteCarloResponse> createRepeated() => $pb.PbList<MonteCarloResponse>();
  @$core.pragma('dart2js:noInline')
  static MonteCarloResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MonteCarloResponse>(create);
  static MonteCarloResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get mean => $_getN(0);
  @$pb.TagNumber(1)
  set mean($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMean() => $_has(0);
  @$pb.TagNumber(1)
  void clearMean() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get stdDev => $_getN(1);
  @$pb.TagNumber(2)
  set stdDev($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStdDev() => $_has(1);
  @$pb.TagNumber(2)
  void clearStdDev() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get p10 => $_getN(2);
  @$pb.TagNumber(3)
  set p10($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasP10() => $_has(2);
  @$pb.TagNumber(3)
  void clearP10() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get p50 => $_getN(3);
  @$pb.TagNumber(4)
  set p50($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasP50() => $_has(3);
  @$pb.TagNumber(4)
  void clearP50() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get p90 => $_getN(4);
  @$pb.TagNumber(5)
  set p90($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasP90() => $_has(4);
  @$pb.TagNumber(5)
  void clearP90() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get minValue => $_getN(5);
  @$pb.TagNumber(6)
  set minValue($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasMinValue() => $_has(5);
  @$pb.TagNumber(6)
  void clearMinValue() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get maxValue => $_getN(6);
  @$pb.TagNumber(7)
  set maxValue($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasMaxValue() => $_has(6);
  @$pb.TagNumber(7)
  void clearMaxValue() => $_clearField(7);
}

class GARequest extends $pb.GeneratedMessage {
  factory GARequest({
    $core.int? populationSize,
    $core.int? generations,
    $core.double? crossoverRate,
    $core.double? mutationRate,
    $core.int? eliteCount,
    $fixnum.Int64? seed,
    $core.Iterable<$core.double>? initialPopulation,
    $1.OptimizationProblem? problem,
  }) {
    final $result = create();
    if (populationSize != null) {
      $result.populationSize = populationSize;
    }
    if (generations != null) {
      $result.generations = generations;
    }
    if (crossoverRate != null) {
      $result.crossoverRate = crossoverRate;
    }
    if (mutationRate != null) {
      $result.mutationRate = mutationRate;
    }
    if (eliteCount != null) {
      $result.eliteCount = eliteCount;
    }
    if (seed != null) {
      $result.seed = seed;
    }
    if (initialPopulation != null) {
      $result.initialPopulation.addAll(initialPopulation);
    }
    if (problem != null) {
      $result.problem = problem;
    }
    return $result;
  }
  GARequest._() : super();
  factory GARequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GARequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GARequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'optimization.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'populationSize', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'generations', $pb.PbFieldType.O3)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'crossoverRate', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'mutationRate', $pb.PbFieldType.OD)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'eliteCount', $pb.PbFieldType.O3)
    ..aInt64(6, _omitFieldNames ? '' : 'seed')
    ..p<$core.double>(7, _omitFieldNames ? '' : 'initialPopulation', $pb.PbFieldType.KD)
    ..aOM<$1.OptimizationProblem>(10, _omitFieldNames ? '' : 'problem', subBuilder: $1.OptimizationProblem.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GARequest clone() => GARequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GARequest copyWith(void Function(GARequest) updates) => super.copyWith((message) => updates(message as GARequest)) as GARequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GARequest create() => GARequest._();
  GARequest createEmptyInstance() => create();
  static $pb.PbList<GARequest> createRepeated() => $pb.PbList<GARequest>();
  @$core.pragma('dart2js:noInline')
  static GARequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GARequest>(create);
  static GARequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get populationSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set populationSize($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPopulationSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPopulationSize() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get generations => $_getIZ(1);
  @$pb.TagNumber(2)
  set generations($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGenerations() => $_has(1);
  @$pb.TagNumber(2)
  void clearGenerations() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get crossoverRate => $_getN(2);
  @$pb.TagNumber(3)
  set crossoverRate($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCrossoverRate() => $_has(2);
  @$pb.TagNumber(3)
  void clearCrossoverRate() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get mutationRate => $_getN(3);
  @$pb.TagNumber(4)
  set mutationRate($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMutationRate() => $_has(3);
  @$pb.TagNumber(4)
  void clearMutationRate() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get eliteCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set eliteCount($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasEliteCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearEliteCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get seed => $_getI64(5);
  @$pb.TagNumber(6)
  set seed($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSeed() => $_has(5);
  @$pb.TagNumber(6)
  void clearSeed() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.double> get initialPopulation => $_getList(6);

  @$pb.TagNumber(10)
  $1.OptimizationProblem get problem => $_getN(7);
  @$pb.TagNumber(10)
  set problem($1.OptimizationProblem v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasProblem() => $_has(7);
  @$pb.TagNumber(10)
  void clearProblem() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.OptimizationProblem ensureProblem() => $_ensure(7);
}

class GAResponse extends $pb.GeneratedMessage {
  factory GAResponse({
    $core.double? bestFitness,
    $core.Iterable<$core.double>? bestGenes,
    $core.int? generationsCompleted,
  }) {
    final $result = create();
    if (bestFitness != null) {
      $result.bestFitness = bestFitness;
    }
    if (bestGenes != null) {
      $result.bestGenes.addAll(bestGenes);
    }
    if (generationsCompleted != null) {
      $result.generationsCompleted = generationsCompleted;
    }
    return $result;
  }
  GAResponse._() : super();
  factory GAResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GAResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GAResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'optimization.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'bestFitness', $pb.PbFieldType.OD)
    ..p<$core.double>(2, _omitFieldNames ? '' : 'bestGenes', $pb.PbFieldType.KD)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'generationsCompleted', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GAResponse clone() => GAResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GAResponse copyWith(void Function(GAResponse) updates) => super.copyWith((message) => updates(message as GAResponse)) as GAResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GAResponse create() => GAResponse._();
  GAResponse createEmptyInstance() => create();
  static $pb.PbList<GAResponse> createRepeated() => $pb.PbList<GAResponse>();
  @$core.pragma('dart2js:noInline')
  static GAResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GAResponse>(create);
  static GAResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get bestFitness => $_getN(0);
  @$pb.TagNumber(1)
  set bestFitness($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBestFitness() => $_has(0);
  @$pb.TagNumber(1)
  void clearBestFitness() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.double> get bestGenes => $_getList(1);

  @$pb.TagNumber(3)
  $core.int get generationsCompleted => $_getIZ(2);
  @$pb.TagNumber(3)
  set generationsCompleted($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasGenerationsCompleted() => $_has(2);
  @$pb.TagNumber(3)
  void clearGenerationsCompleted() => $_clearField(3);
}

class SARequest extends $pb.GeneratedMessage {
  factory SARequest({
    $core.double? initialTemperature,
    $core.double? coolingRate,
    $core.int? iterations,
    $core.double? perturbationScale,
    $fixnum.Int64? seed,
    $core.Iterable<$core.double>? initialSolution,
    $1.OptimizationProblem? problem,
  }) {
    final $result = create();
    if (initialTemperature != null) {
      $result.initialTemperature = initialTemperature;
    }
    if (coolingRate != null) {
      $result.coolingRate = coolingRate;
    }
    if (iterations != null) {
      $result.iterations = iterations;
    }
    if (perturbationScale != null) {
      $result.perturbationScale = perturbationScale;
    }
    if (seed != null) {
      $result.seed = seed;
    }
    if (initialSolution != null) {
      $result.initialSolution.addAll(initialSolution);
    }
    if (problem != null) {
      $result.problem = problem;
    }
    return $result;
  }
  SARequest._() : super();
  factory SARequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SARequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SARequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'optimization.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'initialTemperature', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'coolingRate', $pb.PbFieldType.OD)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'iterations', $pb.PbFieldType.O3)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'perturbationScale', $pb.PbFieldType.OD)
    ..aInt64(5, _omitFieldNames ? '' : 'seed')
    ..p<$core.double>(6, _omitFieldNames ? '' : 'initialSolution', $pb.PbFieldType.KD)
    ..aOM<$1.OptimizationProblem>(10, _omitFieldNames ? '' : 'problem', subBuilder: $1.OptimizationProblem.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SARequest clone() => SARequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SARequest copyWith(void Function(SARequest) updates) => super.copyWith((message) => updates(message as SARequest)) as SARequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SARequest create() => SARequest._();
  SARequest createEmptyInstance() => create();
  static $pb.PbList<SARequest> createRepeated() => $pb.PbList<SARequest>();
  @$core.pragma('dart2js:noInline')
  static SARequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SARequest>(create);
  static SARequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get initialTemperature => $_getN(0);
  @$pb.TagNumber(1)
  set initialTemperature($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasInitialTemperature() => $_has(0);
  @$pb.TagNumber(1)
  void clearInitialTemperature() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get coolingRate => $_getN(1);
  @$pb.TagNumber(2)
  set coolingRate($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCoolingRate() => $_has(1);
  @$pb.TagNumber(2)
  void clearCoolingRate() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get iterations => $_getIZ(2);
  @$pb.TagNumber(3)
  set iterations($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIterations() => $_has(2);
  @$pb.TagNumber(3)
  void clearIterations() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get perturbationScale => $_getN(3);
  @$pb.TagNumber(4)
  set perturbationScale($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPerturbationScale() => $_has(3);
  @$pb.TagNumber(4)
  void clearPerturbationScale() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get seed => $_getI64(4);
  @$pb.TagNumber(5)
  set seed($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSeed() => $_has(4);
  @$pb.TagNumber(5)
  void clearSeed() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.double> get initialSolution => $_getList(5);

  @$pb.TagNumber(10)
  $1.OptimizationProblem get problem => $_getN(6);
  @$pb.TagNumber(10)
  set problem($1.OptimizationProblem v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasProblem() => $_has(6);
  @$pb.TagNumber(10)
  void clearProblem() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.OptimizationProblem ensureProblem() => $_ensure(6);
}

class SAResponse extends $pb.GeneratedMessage {
  factory SAResponse({
    $core.double? bestEnergy,
    $core.Iterable<$core.double>? bestSolution,
    $core.double? finalTemperature,
  }) {
    final $result = create();
    if (bestEnergy != null) {
      $result.bestEnergy = bestEnergy;
    }
    if (bestSolution != null) {
      $result.bestSolution.addAll(bestSolution);
    }
    if (finalTemperature != null) {
      $result.finalTemperature = finalTemperature;
    }
    return $result;
  }
  SAResponse._() : super();
  factory SAResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SAResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SAResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'optimization.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'bestEnergy', $pb.PbFieldType.OD)
    ..p<$core.double>(2, _omitFieldNames ? '' : 'bestSolution', $pb.PbFieldType.KD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'finalTemperature', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SAResponse clone() => SAResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SAResponse copyWith(void Function(SAResponse) updates) => super.copyWith((message) => updates(message as SAResponse)) as SAResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SAResponse create() => SAResponse._();
  SAResponse createEmptyInstance() => create();
  static $pb.PbList<SAResponse> createRepeated() => $pb.PbList<SAResponse>();
  @$core.pragma('dart2js:noInline')
  static SAResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SAResponse>(create);
  static SAResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get bestEnergy => $_getN(0);
  @$pb.TagNumber(1)
  set bestEnergy($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBestEnergy() => $_has(0);
  @$pb.TagNumber(1)
  void clearBestEnergy() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.double> get bestSolution => $_getList(1);

  @$pb.TagNumber(3)
  $core.double get finalTemperature => $_getN(2);
  @$pb.TagNumber(3)
  set finalTemperature($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFinalTemperature() => $_has(2);
  @$pb.TagNumber(3)
  void clearFinalTemperature() => $_clearField(3);
}

class PSORequest extends $pb.GeneratedMessage {
  factory PSORequest({
    $core.int? numParticles,
    $core.int? iterations,
    $core.double? c1,
    $core.double? c2,
    $core.double? w,
    $core.double? boundaryMin,
    $core.double? boundaryMax,
    $fixnum.Int64? seed,
    $1.OptimizationProblem? problem,
  }) {
    final $result = create();
    if (numParticles != null) {
      $result.numParticles = numParticles;
    }
    if (iterations != null) {
      $result.iterations = iterations;
    }
    if (c1 != null) {
      $result.c1 = c1;
    }
    if (c2 != null) {
      $result.c2 = c2;
    }
    if (w != null) {
      $result.w = w;
    }
    if (boundaryMin != null) {
      $result.boundaryMin = boundaryMin;
    }
    if (boundaryMax != null) {
      $result.boundaryMax = boundaryMax;
    }
    if (seed != null) {
      $result.seed = seed;
    }
    if (problem != null) {
      $result.problem = problem;
    }
    return $result;
  }
  PSORequest._() : super();
  factory PSORequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PSORequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PSORequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'optimization.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'numParticles', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'iterations', $pb.PbFieldType.O3)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'c1', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'c2', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'w', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'boundaryMin', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'boundaryMax', $pb.PbFieldType.OD)
    ..aInt64(8, _omitFieldNames ? '' : 'seed')
    ..aOM<$1.OptimizationProblem>(10, _omitFieldNames ? '' : 'problem', subBuilder: $1.OptimizationProblem.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PSORequest clone() => PSORequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PSORequest copyWith(void Function(PSORequest) updates) => super.copyWith((message) => updates(message as PSORequest)) as PSORequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PSORequest create() => PSORequest._();
  PSORequest createEmptyInstance() => create();
  static $pb.PbList<PSORequest> createRepeated() => $pb.PbList<PSORequest>();
  @$core.pragma('dart2js:noInline')
  static PSORequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PSORequest>(create);
  static PSORequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get numParticles => $_getIZ(0);
  @$pb.TagNumber(1)
  set numParticles($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNumParticles() => $_has(0);
  @$pb.TagNumber(1)
  void clearNumParticles() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get iterations => $_getIZ(1);
  @$pb.TagNumber(2)
  set iterations($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIterations() => $_has(1);
  @$pb.TagNumber(2)
  void clearIterations() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get c1 => $_getN(2);
  @$pb.TagNumber(3)
  set c1($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasC1() => $_has(2);
  @$pb.TagNumber(3)
  void clearC1() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get c2 => $_getN(3);
  @$pb.TagNumber(4)
  set c2($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasC2() => $_has(3);
  @$pb.TagNumber(4)
  void clearC2() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get w => $_getN(4);
  @$pb.TagNumber(5)
  set w($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasW() => $_has(4);
  @$pb.TagNumber(5)
  void clearW() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get boundaryMin => $_getN(5);
  @$pb.TagNumber(6)
  set boundaryMin($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasBoundaryMin() => $_has(5);
  @$pb.TagNumber(6)
  void clearBoundaryMin() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get boundaryMax => $_getN(6);
  @$pb.TagNumber(7)
  set boundaryMax($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasBoundaryMax() => $_has(6);
  @$pb.TagNumber(7)
  void clearBoundaryMax() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get seed => $_getI64(7);
  @$pb.TagNumber(8)
  set seed($fixnum.Int64 v) { $_setInt64(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasSeed() => $_has(7);
  @$pb.TagNumber(8)
  void clearSeed() => $_clearField(8);

  @$pb.TagNumber(10)
  $1.OptimizationProblem get problem => $_getN(8);
  @$pb.TagNumber(10)
  set problem($1.OptimizationProblem v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasProblem() => $_has(8);
  @$pb.TagNumber(10)
  void clearProblem() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.OptimizationProblem ensureProblem() => $_ensure(8);
}

class PSOResponse extends $pb.GeneratedMessage {
  factory PSOResponse({
    $core.double? bestPosition,
    $core.double? bestValue,
    $core.int? iterationsCompleted,
  }) {
    final $result = create();
    if (bestPosition != null) {
      $result.bestPosition = bestPosition;
    }
    if (bestValue != null) {
      $result.bestValue = bestValue;
    }
    if (iterationsCompleted != null) {
      $result.iterationsCompleted = iterationsCompleted;
    }
    return $result;
  }
  PSOResponse._() : super();
  factory PSOResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PSOResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PSOResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'optimization.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'bestPosition', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'bestValue', $pb.PbFieldType.OD)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'iterationsCompleted', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PSOResponse clone() => PSOResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PSOResponse copyWith(void Function(PSOResponse) updates) => super.copyWith((message) => updates(message as PSOResponse)) as PSOResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PSOResponse create() => PSOResponse._();
  PSOResponse createEmptyInstance() => create();
  static $pb.PbList<PSOResponse> createRepeated() => $pb.PbList<PSOResponse>();
  @$core.pragma('dart2js:noInline')
  static PSOResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PSOResponse>(create);
  static PSOResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get bestPosition => $_getN(0);
  @$pb.TagNumber(1)
  set bestPosition($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBestPosition() => $_has(0);
  @$pb.TagNumber(1)
  void clearBestPosition() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get bestValue => $_getN(1);
  @$pb.TagNumber(2)
  set bestValue($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBestValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearBestValue() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get iterationsCompleted => $_getIZ(2);
  @$pb.TagNumber(3)
  set iterationsCompleted($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIterationsCompleted() => $_has(2);
  @$pb.TagNumber(3)
  void clearIterationsCompleted() => $_clearField(3);
}

class OptimizationServiceApi {
  $pb.RpcClient _client;
  OptimizationServiceApi(this._client);

  $async.Future<ParetoFrontierResponse> paretoFrontier($pb.ClientContext? ctx, AddToFrontierRequest request) =>
    _client.invoke<ParetoFrontierResponse>(ctx, 'OptimizationService', 'ParetoFrontier', request, ParetoFrontierResponse())
  ;
  $async.Future<MonteCarloResponse> monteCarloSampling($pb.ClientContext? ctx, MonteCarloRequest request) =>
    _client.invoke<MonteCarloResponse>(ctx, 'OptimizationService', 'MonteCarloSampling', request, MonteCarloResponse())
  ;
  $async.Future<GAResponse> geneticAlgorithm($pb.ClientContext? ctx, GARequest request) =>
    _client.invoke<GAResponse>(ctx, 'OptimizationService', 'GeneticAlgorithm', request, GAResponse())
  ;
  $async.Future<SAResponse> simulatedAnnealing($pb.ClientContext? ctx, SARequest request) =>
    _client.invoke<SAResponse>(ctx, 'OptimizationService', 'SimulatedAnnealing', request, SAResponse())
  ;
  $async.Future<PSOResponse> particleSwarmOptimization($pb.ClientContext? ctx, PSORequest request) =>
    _client.invoke<PSOResponse>(ctx, 'OptimizationService', 'ParticleSwarmOptimization', request, PSOResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
