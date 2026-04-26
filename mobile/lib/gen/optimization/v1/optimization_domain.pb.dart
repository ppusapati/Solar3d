//
//  Generated code. Do not modify.
//  source: optimization/v1/optimization_domain.proto
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
import 'optimization_domain.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'optimization_domain.pbenum.dart';

class DecisionVariable extends $pb.GeneratedMessage {
  factory DecisionVariable({
    $core.String? name,
    VariableType? variableType,
    $0.NumericRange? bounds,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (variableType != null) {
      $result.variableType = variableType;
    }
    if (bounds != null) {
      $result.bounds = bounds;
    }
    return $result;
  }
  DecisionVariable._() : super();
  factory DecisionVariable.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DecisionVariable.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DecisionVariable', package: const $pb.PackageName(_omitMessageNames ? '' : 'optimization.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..e<VariableType>(2, _omitFieldNames ? '' : 'variableType', $pb.PbFieldType.OE, defaultOrMaker: VariableType.VARIABLE_TYPE_UNSPECIFIED, valueOf: VariableType.valueOf, enumValues: VariableType.values)
    ..aOM<$0.NumericRange>(3, _omitFieldNames ? '' : 'bounds', subBuilder: $0.NumericRange.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DecisionVariable clone() => DecisionVariable()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DecisionVariable copyWith(void Function(DecisionVariable) updates) => super.copyWith((message) => updates(message as DecisionVariable)) as DecisionVariable;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DecisionVariable create() => DecisionVariable._();
  DecisionVariable createEmptyInstance() => create();
  static $pb.PbList<DecisionVariable> createRepeated() => $pb.PbList<DecisionVariable>();
  @$core.pragma('dart2js:noInline')
  static DecisionVariable getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DecisionVariable>(create);
  static DecisionVariable? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  VariableType get variableType => $_getN(1);
  @$pb.TagNumber(2)
  set variableType(VariableType v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasVariableType() => $_has(1);
  @$pb.TagNumber(2)
  void clearVariableType() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.NumericRange get bounds => $_getN(2);
  @$pb.TagNumber(3)
  set bounds($0.NumericRange v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasBounds() => $_has(2);
  @$pb.TagNumber(3)
  void clearBounds() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.NumericRange ensureBounds() => $_ensure(2);
}

class ObjectiveDefinition extends $pb.GeneratedMessage {
  factory ObjectiveDefinition({
    $core.String? name,
    ObjectiveKind? kind,
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
  ObjectiveDefinition._() : super();
  factory ObjectiveDefinition.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ObjectiveDefinition.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ObjectiveDefinition', package: const $pb.PackageName(_omitMessageNames ? '' : 'optimization.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..e<ObjectiveKind>(2, _omitFieldNames ? '' : 'kind', $pb.PbFieldType.OE, defaultOrMaker: ObjectiveKind.OBJECTIVE_KIND_UNSPECIFIED, valueOf: ObjectiveKind.valueOf, enumValues: ObjectiveKind.values)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'weight', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ObjectiveDefinition clone() => ObjectiveDefinition()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ObjectiveDefinition copyWith(void Function(ObjectiveDefinition) updates) => super.copyWith((message) => updates(message as ObjectiveDefinition)) as ObjectiveDefinition;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ObjectiveDefinition create() => ObjectiveDefinition._();
  ObjectiveDefinition createEmptyInstance() => create();
  static $pb.PbList<ObjectiveDefinition> createRepeated() => $pb.PbList<ObjectiveDefinition>();
  @$core.pragma('dart2js:noInline')
  static ObjectiveDefinition getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ObjectiveDefinition>(create);
  static ObjectiveDefinition? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  ObjectiveKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(ObjectiveKind v) { $_setField(2, v); }
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

class DistributionModel extends $pb.GeneratedMessage {
  factory DistributionModel({
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
  DistributionModel._() : super();
  factory DistributionModel.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DistributionModel.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DistributionModel', package: const $pb.PackageName(_omitMessageNames ? '' : 'optimization.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'mean', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'stdDev', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DistributionModel clone() => DistributionModel()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DistributionModel copyWith(void Function(DistributionModel) updates) => super.copyWith((message) => updates(message as DistributionModel)) as DistributionModel;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DistributionModel create() => DistributionModel._();
  DistributionModel createEmptyInstance() => create();
  static $pb.PbList<DistributionModel> createRepeated() => $pb.PbList<DistributionModel>();
  @$core.pragma('dart2js:noInline')
  static DistributionModel getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DistributionModel>(create);
  static DistributionModel? _defaultInstance;

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

class ConstraintDefinition extends $pb.GeneratedMessage {
  factory ConstraintDefinition({
    $core.String? name,
    $core.String? expression,
    $0.NumericRange? allowedRange,
    $core.bool? hardConstraint,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (expression != null) {
      $result.expression = expression;
    }
    if (allowedRange != null) {
      $result.allowedRange = allowedRange;
    }
    if (hardConstraint != null) {
      $result.hardConstraint = hardConstraint;
    }
    return $result;
  }
  ConstraintDefinition._() : super();
  factory ConstraintDefinition.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConstraintDefinition.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ConstraintDefinition', package: const $pb.PackageName(_omitMessageNames ? '' : 'optimization.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'expression')
    ..aOM<$0.NumericRange>(3, _omitFieldNames ? '' : 'allowedRange', subBuilder: $0.NumericRange.create)
    ..aOB(4, _omitFieldNames ? '' : 'hardConstraint')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConstraintDefinition clone() => ConstraintDefinition()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConstraintDefinition copyWith(void Function(ConstraintDefinition) updates) => super.copyWith((message) => updates(message as ConstraintDefinition)) as ConstraintDefinition;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConstraintDefinition create() => ConstraintDefinition._();
  ConstraintDefinition createEmptyInstance() => create();
  static $pb.PbList<ConstraintDefinition> createRepeated() => $pb.PbList<ConstraintDefinition>();
  @$core.pragma('dart2js:noInline')
  static ConstraintDefinition getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConstraintDefinition>(create);
  static ConstraintDefinition? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get expression => $_getSZ(1);
  @$pb.TagNumber(2)
  set expression($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasExpression() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpression() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.NumericRange get allowedRange => $_getN(2);
  @$pb.TagNumber(3)
  set allowedRange($0.NumericRange v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasAllowedRange() => $_has(2);
  @$pb.TagNumber(3)
  void clearAllowedRange() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.NumericRange ensureAllowedRange() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get hardConstraint => $_getBF(3);
  @$pb.TagNumber(4)
  set hardConstraint($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHardConstraint() => $_has(3);
  @$pb.TagNumber(4)
  void clearHardConstraint() => $_clearField(4);
}

class OptimizationProblem extends $pb.GeneratedMessage {
  factory OptimizationProblem({
    $core.String? problemId,
    $core.Iterable<DecisionVariable>? variables,
    $core.Iterable<ObjectiveDefinition>? objectives,
    $core.Iterable<ConstraintDefinition>? constraints,
    $fixnum.Int64? randomSeed,
    $core.int? maxIterations,
    $0.ContractMetadata? contract,
  }) {
    final $result = create();
    if (problemId != null) {
      $result.problemId = problemId;
    }
    if (variables != null) {
      $result.variables.addAll(variables);
    }
    if (objectives != null) {
      $result.objectives.addAll(objectives);
    }
    if (constraints != null) {
      $result.constraints.addAll(constraints);
    }
    if (randomSeed != null) {
      $result.randomSeed = randomSeed;
    }
    if (maxIterations != null) {
      $result.maxIterations = maxIterations;
    }
    if (contract != null) {
      $result.contract = contract;
    }
    return $result;
  }
  OptimizationProblem._() : super();
  factory OptimizationProblem.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OptimizationProblem.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OptimizationProblem', package: const $pb.PackageName(_omitMessageNames ? '' : 'optimization.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'problemId')
    ..pc<DecisionVariable>(2, _omitFieldNames ? '' : 'variables', $pb.PbFieldType.PM, subBuilder: DecisionVariable.create)
    ..pc<ObjectiveDefinition>(3, _omitFieldNames ? '' : 'objectives', $pb.PbFieldType.PM, subBuilder: ObjectiveDefinition.create)
    ..pc<ConstraintDefinition>(4, _omitFieldNames ? '' : 'constraints', $pb.PbFieldType.PM, subBuilder: ConstraintDefinition.create)
    ..aInt64(5, _omitFieldNames ? '' : 'randomSeed')
    ..a<$core.int>(6, _omitFieldNames ? '' : 'maxIterations', $pb.PbFieldType.O3)
    ..aOM<$0.ContractMetadata>(7, _omitFieldNames ? '' : 'contract', subBuilder: $0.ContractMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OptimizationProblem clone() => OptimizationProblem()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OptimizationProblem copyWith(void Function(OptimizationProblem) updates) => super.copyWith((message) => updates(message as OptimizationProblem)) as OptimizationProblem;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OptimizationProblem create() => OptimizationProblem._();
  OptimizationProblem createEmptyInstance() => create();
  static $pb.PbList<OptimizationProblem> createRepeated() => $pb.PbList<OptimizationProblem>();
  @$core.pragma('dart2js:noInline')
  static OptimizationProblem getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OptimizationProblem>(create);
  static OptimizationProblem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get problemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set problemId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProblemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProblemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<DecisionVariable> get variables => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<ObjectiveDefinition> get objectives => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<ConstraintDefinition> get constraints => $_getList(3);

  @$pb.TagNumber(5)
  $fixnum.Int64 get randomSeed => $_getI64(4);
  @$pb.TagNumber(5)
  set randomSeed($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRandomSeed() => $_has(4);
  @$pb.TagNumber(5)
  void clearRandomSeed() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get maxIterations => $_getIZ(5);
  @$pb.TagNumber(6)
  set maxIterations($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasMaxIterations() => $_has(5);
  @$pb.TagNumber(6)
  void clearMaxIterations() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.ContractMetadata get contract => $_getN(6);
  @$pb.TagNumber(7)
  set contract($0.ContractMetadata v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasContract() => $_has(6);
  @$pb.TagNumber(7)
  void clearContract() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.ContractMetadata ensureContract() => $_ensure(6);
}

class DistributionDefinition extends $pb.GeneratedMessage {
  factory DistributionDefinition({
    $core.String? name,
    DistributionModel? distribution,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (distribution != null) {
      $result.distribution = distribution;
    }
    return $result;
  }
  DistributionDefinition._() : super();
  factory DistributionDefinition.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DistributionDefinition.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DistributionDefinition', package: const $pb.PackageName(_omitMessageNames ? '' : 'optimization.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOM<DistributionModel>(2, _omitFieldNames ? '' : 'distribution', subBuilder: DistributionModel.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DistributionDefinition clone() => DistributionDefinition()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DistributionDefinition copyWith(void Function(DistributionDefinition) updates) => super.copyWith((message) => updates(message as DistributionDefinition)) as DistributionDefinition;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DistributionDefinition create() => DistributionDefinition._();
  DistributionDefinition createEmptyInstance() => create();
  static $pb.PbList<DistributionDefinition> createRepeated() => $pb.PbList<DistributionDefinition>();
  @$core.pragma('dart2js:noInline')
  static DistributionDefinition getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DistributionDefinition>(create);
  static DistributionDefinition? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  DistributionModel get distribution => $_getN(1);
  @$pb.TagNumber(2)
  set distribution(DistributionModel v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasDistribution() => $_has(1);
  @$pb.TagNumber(2)
  void clearDistribution() => $_clearField(2);
  @$pb.TagNumber(2)
  DistributionModel ensureDistribution() => $_ensure(1);
}

class UncertaintyModel extends $pb.GeneratedMessage {
  factory UncertaintyModel({
    $core.Iterable<DistributionDefinition>? distributions,
    $core.int? sampleCount,
    $fixnum.Int64? randomSeed,
    $0.ContractMetadata? contract,
  }) {
    final $result = create();
    if (distributions != null) {
      $result.distributions.addAll(distributions);
    }
    if (sampleCount != null) {
      $result.sampleCount = sampleCount;
    }
    if (randomSeed != null) {
      $result.randomSeed = randomSeed;
    }
    if (contract != null) {
      $result.contract = contract;
    }
    return $result;
  }
  UncertaintyModel._() : super();
  factory UncertaintyModel.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UncertaintyModel.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UncertaintyModel', package: const $pb.PackageName(_omitMessageNames ? '' : 'optimization.v1'), createEmptyInstance: create)
    ..pc<DistributionDefinition>(1, _omitFieldNames ? '' : 'distributions', $pb.PbFieldType.PM, subBuilder: DistributionDefinition.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'sampleCount', $pb.PbFieldType.O3)
    ..aInt64(3, _omitFieldNames ? '' : 'randomSeed')
    ..aOM<$0.ContractMetadata>(4, _omitFieldNames ? '' : 'contract', subBuilder: $0.ContractMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UncertaintyModel clone() => UncertaintyModel()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UncertaintyModel copyWith(void Function(UncertaintyModel) updates) => super.copyWith((message) => updates(message as UncertaintyModel)) as UncertaintyModel;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UncertaintyModel create() => UncertaintyModel._();
  UncertaintyModel createEmptyInstance() => create();
  static $pb.PbList<UncertaintyModel> createRepeated() => $pb.PbList<UncertaintyModel>();
  @$core.pragma('dart2js:noInline')
  static UncertaintyModel getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UncertaintyModel>(create);
  static UncertaintyModel? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DistributionDefinition> get distributions => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get sampleCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set sampleCount($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSampleCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearSampleCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get randomSeed => $_getI64(2);
  @$pb.TagNumber(3)
  set randomSeed($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRandomSeed() => $_has(2);
  @$pb.TagNumber(3)
  void clearRandomSeed() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.ContractMetadata get contract => $_getN(3);
  @$pb.TagNumber(4)
  set contract($0.ContractMetadata v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasContract() => $_has(3);
  @$pb.TagNumber(4)
  void clearContract() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.ContractMetadata ensureContract() => $_ensure(3);
}

class CandidateSolution extends $pb.GeneratedMessage {
  factory CandidateSolution({
    $core.String? candidateId,
    $pb.PbMap<$core.String, $core.double>? assignments,
    $pb.PbMap<$core.String, $core.double>? objectiveValues,
    $pb.PbMap<$core.String, $core.double>? constraintViolations,
  }) {
    final $result = create();
    if (candidateId != null) {
      $result.candidateId = candidateId;
    }
    if (assignments != null) {
      $result.assignments.addAll(assignments);
    }
    if (objectiveValues != null) {
      $result.objectiveValues.addAll(objectiveValues);
    }
    if (constraintViolations != null) {
      $result.constraintViolations.addAll(constraintViolations);
    }
    return $result;
  }
  CandidateSolution._() : super();
  factory CandidateSolution.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CandidateSolution.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CandidateSolution', package: const $pb.PackageName(_omitMessageNames ? '' : 'optimization.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'candidateId')
    ..m<$core.String, $core.double>(2, _omitFieldNames ? '' : 'assignments', entryClassName: 'CandidateSolution.AssignmentsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OD, packageName: const $pb.PackageName('optimization.v1'))
    ..m<$core.String, $core.double>(3, _omitFieldNames ? '' : 'objectiveValues', entryClassName: 'CandidateSolution.ObjectiveValuesEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OD, packageName: const $pb.PackageName('optimization.v1'))
    ..m<$core.String, $core.double>(4, _omitFieldNames ? '' : 'constraintViolations', entryClassName: 'CandidateSolution.ConstraintViolationsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OD, packageName: const $pb.PackageName('optimization.v1'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CandidateSolution clone() => CandidateSolution()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CandidateSolution copyWith(void Function(CandidateSolution) updates) => super.copyWith((message) => updates(message as CandidateSolution)) as CandidateSolution;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CandidateSolution create() => CandidateSolution._();
  CandidateSolution createEmptyInstance() => create();
  static $pb.PbList<CandidateSolution> createRepeated() => $pb.PbList<CandidateSolution>();
  @$core.pragma('dart2js:noInline')
  static CandidateSolution getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CandidateSolution>(create);
  static CandidateSolution? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get candidateId => $_getSZ(0);
  @$pb.TagNumber(1)
  set candidateId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCandidateId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCandidateId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, $core.double> get assignments => $_getMap(1);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.double> get objectiveValues => $_getMap(2);

  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, $core.double> get constraintViolations => $_getMap(3);
}

class MultiObjectiveOptimizationInput extends $pb.GeneratedMessage {
  factory MultiObjectiveOptimizationInput({
    OptimizationProblem? problem,
    $core.Iterable<CandidateSolution>? initialCandidates,
  }) {
    final $result = create();
    if (problem != null) {
      $result.problem = problem;
    }
    if (initialCandidates != null) {
      $result.initialCandidates.addAll(initialCandidates);
    }
    return $result;
  }
  MultiObjectiveOptimizationInput._() : super();
  factory MultiObjectiveOptimizationInput.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MultiObjectiveOptimizationInput.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MultiObjectiveOptimizationInput', package: const $pb.PackageName(_omitMessageNames ? '' : 'optimization.v1'), createEmptyInstance: create)
    ..aOM<OptimizationProblem>(1, _omitFieldNames ? '' : 'problem', subBuilder: OptimizationProblem.create)
    ..pc<CandidateSolution>(2, _omitFieldNames ? '' : 'initialCandidates', $pb.PbFieldType.PM, subBuilder: CandidateSolution.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MultiObjectiveOptimizationInput clone() => MultiObjectiveOptimizationInput()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MultiObjectiveOptimizationInput copyWith(void Function(MultiObjectiveOptimizationInput) updates) => super.copyWith((message) => updates(message as MultiObjectiveOptimizationInput)) as MultiObjectiveOptimizationInput;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MultiObjectiveOptimizationInput create() => MultiObjectiveOptimizationInput._();
  MultiObjectiveOptimizationInput createEmptyInstance() => create();
  static $pb.PbList<MultiObjectiveOptimizationInput> createRepeated() => $pb.PbList<MultiObjectiveOptimizationInput>();
  @$core.pragma('dart2js:noInline')
  static MultiObjectiveOptimizationInput getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MultiObjectiveOptimizationInput>(create);
  static MultiObjectiveOptimizationInput? _defaultInstance;

  @$pb.TagNumber(1)
  OptimizationProblem get problem => $_getN(0);
  @$pb.TagNumber(1)
  set problem(OptimizationProblem v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasProblem() => $_has(0);
  @$pb.TagNumber(1)
  void clearProblem() => $_clearField(1);
  @$pb.TagNumber(1)
  OptimizationProblem ensureProblem() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<CandidateSolution> get initialCandidates => $_getList(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
