//
//  Generated code. Do not modify.
//  source: planning/v1/planning_workflow.proto
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
import 'planning_workflow.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'planning_workflow.pbenum.dart';

enum TransitionEvidence_EvidenceType {
  planningAcceptance, 
  layoutApproval, 
  electricalSignoff, 
  transmissionSignoff, 
  reviewApproval, 
  stakeholderApproval, 
  commissioningConfirmation, 
  notSet
}

/// TransitionEvidence wraps all possible evidence types.
class TransitionEvidence extends $pb.GeneratedMessage {
  factory TransitionEvidence({
    PlanningAcceptance? planningAcceptance,
    LayoutApproval? layoutApproval,
    ElectricalSignoff? electricalSignoff,
    TransmissionSignoff? transmissionSignoff,
    ReviewApproval? reviewApproval,
    StakeholderApproval? stakeholderApproval,
    CommissioningConfirmation? commissioningConfirmation,
  }) {
    final $result = create();
    if (planningAcceptance != null) {
      $result.planningAcceptance = planningAcceptance;
    }
    if (layoutApproval != null) {
      $result.layoutApproval = layoutApproval;
    }
    if (electricalSignoff != null) {
      $result.electricalSignoff = electricalSignoff;
    }
    if (transmissionSignoff != null) {
      $result.transmissionSignoff = transmissionSignoff;
    }
    if (reviewApproval != null) {
      $result.reviewApproval = reviewApproval;
    }
    if (stakeholderApproval != null) {
      $result.stakeholderApproval = stakeholderApproval;
    }
    if (commissioningConfirmation != null) {
      $result.commissioningConfirmation = commissioningConfirmation;
    }
    return $result;
  }
  TransitionEvidence._() : super();
  factory TransitionEvidence.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TransitionEvidence.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, TransitionEvidence_EvidenceType> _TransitionEvidence_EvidenceTypeByTag = {
    1 : TransitionEvidence_EvidenceType.planningAcceptance,
    2 : TransitionEvidence_EvidenceType.layoutApproval,
    3 : TransitionEvidence_EvidenceType.electricalSignoff,
    4 : TransitionEvidence_EvidenceType.transmissionSignoff,
    5 : TransitionEvidence_EvidenceType.reviewApproval,
    6 : TransitionEvidence_EvidenceType.stakeholderApproval,
    7 : TransitionEvidence_EvidenceType.commissioningConfirmation,
    0 : TransitionEvidence_EvidenceType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TransitionEvidence', package: const $pb.PackageName(_omitMessageNames ? '' : 'planning.v1'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7])
    ..aOM<PlanningAcceptance>(1, _omitFieldNames ? '' : 'planningAcceptance', subBuilder: PlanningAcceptance.create)
    ..aOM<LayoutApproval>(2, _omitFieldNames ? '' : 'layoutApproval', subBuilder: LayoutApproval.create)
    ..aOM<ElectricalSignoff>(3, _omitFieldNames ? '' : 'electricalSignoff', subBuilder: ElectricalSignoff.create)
    ..aOM<TransmissionSignoff>(4, _omitFieldNames ? '' : 'transmissionSignoff', subBuilder: TransmissionSignoff.create)
    ..aOM<ReviewApproval>(5, _omitFieldNames ? '' : 'reviewApproval', subBuilder: ReviewApproval.create)
    ..aOM<StakeholderApproval>(6, _omitFieldNames ? '' : 'stakeholderApproval', subBuilder: StakeholderApproval.create)
    ..aOM<CommissioningConfirmation>(7, _omitFieldNames ? '' : 'commissioningConfirmation', subBuilder: CommissioningConfirmation.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TransitionEvidence clone() => TransitionEvidence()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TransitionEvidence copyWith(void Function(TransitionEvidence) updates) => super.copyWith((message) => updates(message as TransitionEvidence)) as TransitionEvidence;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransitionEvidence create() => TransitionEvidence._();
  TransitionEvidence createEmptyInstance() => create();
  static $pb.PbList<TransitionEvidence> createRepeated() => $pb.PbList<TransitionEvidence>();
  @$core.pragma('dart2js:noInline')
  static TransitionEvidence getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TransitionEvidence>(create);
  static TransitionEvidence? _defaultInstance;

  TransitionEvidence_EvidenceType whichEvidenceType() => _TransitionEvidence_EvidenceTypeByTag[$_whichOneof(0)]!;
  void clearEvidenceType() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  PlanningAcceptance get planningAcceptance => $_getN(0);
  @$pb.TagNumber(1)
  set planningAcceptance(PlanningAcceptance v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPlanningAcceptance() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlanningAcceptance() => $_clearField(1);
  @$pb.TagNumber(1)
  PlanningAcceptance ensurePlanningAcceptance() => $_ensure(0);

  @$pb.TagNumber(2)
  LayoutApproval get layoutApproval => $_getN(1);
  @$pb.TagNumber(2)
  set layoutApproval(LayoutApproval v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasLayoutApproval() => $_has(1);
  @$pb.TagNumber(2)
  void clearLayoutApproval() => $_clearField(2);
  @$pb.TagNumber(2)
  LayoutApproval ensureLayoutApproval() => $_ensure(1);

  @$pb.TagNumber(3)
  ElectricalSignoff get electricalSignoff => $_getN(2);
  @$pb.TagNumber(3)
  set electricalSignoff(ElectricalSignoff v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasElectricalSignoff() => $_has(2);
  @$pb.TagNumber(3)
  void clearElectricalSignoff() => $_clearField(3);
  @$pb.TagNumber(3)
  ElectricalSignoff ensureElectricalSignoff() => $_ensure(2);

  @$pb.TagNumber(4)
  TransmissionSignoff get transmissionSignoff => $_getN(3);
  @$pb.TagNumber(4)
  set transmissionSignoff(TransmissionSignoff v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasTransmissionSignoff() => $_has(3);
  @$pb.TagNumber(4)
  void clearTransmissionSignoff() => $_clearField(4);
  @$pb.TagNumber(4)
  TransmissionSignoff ensureTransmissionSignoff() => $_ensure(3);

  @$pb.TagNumber(5)
  ReviewApproval get reviewApproval => $_getN(4);
  @$pb.TagNumber(5)
  set reviewApproval(ReviewApproval v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasReviewApproval() => $_has(4);
  @$pb.TagNumber(5)
  void clearReviewApproval() => $_clearField(5);
  @$pb.TagNumber(5)
  ReviewApproval ensureReviewApproval() => $_ensure(4);

  @$pb.TagNumber(6)
  StakeholderApproval get stakeholderApproval => $_getN(5);
  @$pb.TagNumber(6)
  set stakeholderApproval(StakeholderApproval v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasStakeholderApproval() => $_has(5);
  @$pb.TagNumber(6)
  void clearStakeholderApproval() => $_clearField(6);
  @$pb.TagNumber(6)
  StakeholderApproval ensureStakeholderApproval() => $_ensure(5);

  @$pb.TagNumber(7)
  CommissioningConfirmation get commissioningConfirmation => $_getN(6);
  @$pb.TagNumber(7)
  set commissioningConfirmation(CommissioningConfirmation v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasCommissioningConfirmation() => $_has(6);
  @$pb.TagNumber(7)
  void clearCommissioningConfirmation() => $_clearField(7);
  @$pb.TagNumber(7)
  CommissioningConfirmation ensureCommissioningConfirmation() => $_ensure(6);
}

/// PlanningAcceptance marks the boundary and planning inputs as accepted.
class PlanningAcceptance extends $pb.GeneratedMessage {
  factory PlanningAcceptance({
    $core.String? boundaryId,
    $core.String? acceptedByActorId,
    $0.Timestamp? acceptedAt,
    $core.String? notes,
  }) {
    final $result = create();
    if (boundaryId != null) {
      $result.boundaryId = boundaryId;
    }
    if (acceptedByActorId != null) {
      $result.acceptedByActorId = acceptedByActorId;
    }
    if (acceptedAt != null) {
      $result.acceptedAt = acceptedAt;
    }
    if (notes != null) {
      $result.notes = notes;
    }
    return $result;
  }
  PlanningAcceptance._() : super();
  factory PlanningAcceptance.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PlanningAcceptance.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PlanningAcceptance', package: const $pb.PackageName(_omitMessageNames ? '' : 'planning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'boundaryId')
    ..aOS(2, _omitFieldNames ? '' : 'acceptedByActorId')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'acceptedAt', subBuilder: $0.Timestamp.create)
    ..aOS(4, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PlanningAcceptance clone() => PlanningAcceptance()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PlanningAcceptance copyWith(void Function(PlanningAcceptance) updates) => super.copyWith((message) => updates(message as PlanningAcceptance)) as PlanningAcceptance;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlanningAcceptance create() => PlanningAcceptance._();
  PlanningAcceptance createEmptyInstance() => create();
  static $pb.PbList<PlanningAcceptance> createRepeated() => $pb.PbList<PlanningAcceptance>();
  @$core.pragma('dart2js:noInline')
  static PlanningAcceptance getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlanningAcceptance>(create);
  static PlanningAcceptance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get boundaryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set boundaryId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBoundaryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBoundaryId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get acceptedByActorId => $_getSZ(1);
  @$pb.TagNumber(2)
  set acceptedByActorId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAcceptedByActorId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAcceptedByActorId() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get acceptedAt => $_getN(2);
  @$pb.TagNumber(3)
  set acceptedAt($0.Timestamp v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasAcceptedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearAcceptedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureAcceptedAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get notes => $_getSZ(3);
  @$pb.TagNumber(4)
  set notes($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasNotes() => $_has(3);
  @$pb.TagNumber(4)
  void clearNotes() => $_clearField(4);
}

/// LayoutApproval evidence: ML candidate set complete and preferred candidate selected.
class LayoutApproval extends $pb.GeneratedMessage {
  factory LayoutApproval({
    $core.String? candidateId,
    $core.String? mlExperimentId,
    $core.String? approvedByActorId,
    $0.Timestamp? approvedAt,
    $core.double? candidateCompositeScore,
    $core.String? selectionRationale,
  }) {
    final $result = create();
    if (candidateId != null) {
      $result.candidateId = candidateId;
    }
    if (mlExperimentId != null) {
      $result.mlExperimentId = mlExperimentId;
    }
    if (approvedByActorId != null) {
      $result.approvedByActorId = approvedByActorId;
    }
    if (approvedAt != null) {
      $result.approvedAt = approvedAt;
    }
    if (candidateCompositeScore != null) {
      $result.candidateCompositeScore = candidateCompositeScore;
    }
    if (selectionRationale != null) {
      $result.selectionRationale = selectionRationale;
    }
    return $result;
  }
  LayoutApproval._() : super();
  factory LayoutApproval.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LayoutApproval.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LayoutApproval', package: const $pb.PackageName(_omitMessageNames ? '' : 'planning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'candidateId')
    ..aOS(2, _omitFieldNames ? '' : 'mlExperimentId')
    ..aOS(3, _omitFieldNames ? '' : 'approvedByActorId')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'approvedAt', subBuilder: $0.Timestamp.create)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'candidateCompositeScore', $pb.PbFieldType.OD)
    ..aOS(6, _omitFieldNames ? '' : 'selectionRationale')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LayoutApproval clone() => LayoutApproval()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LayoutApproval copyWith(void Function(LayoutApproval) updates) => super.copyWith((message) => updates(message as LayoutApproval)) as LayoutApproval;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LayoutApproval create() => LayoutApproval._();
  LayoutApproval createEmptyInstance() => create();
  static $pb.PbList<LayoutApproval> createRepeated() => $pb.PbList<LayoutApproval>();
  @$core.pragma('dart2js:noInline')
  static LayoutApproval getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LayoutApproval>(create);
  static LayoutApproval? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get candidateId => $_getSZ(0);
  @$pb.TagNumber(1)
  set candidateId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCandidateId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCandidateId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mlExperimentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set mlExperimentId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMlExperimentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMlExperimentId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get approvedByActorId => $_getSZ(2);
  @$pb.TagNumber(3)
  set approvedByActorId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasApprovedByActorId() => $_has(2);
  @$pb.TagNumber(3)
  void clearApprovedByActorId() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get approvedAt => $_getN(3);
  @$pb.TagNumber(4)
  set approvedAt($0.Timestamp v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasApprovedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearApprovedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureApprovedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.double get candidateCompositeScore => $_getN(4);
  @$pb.TagNumber(5)
  set candidateCompositeScore($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCandidateCompositeScore() => $_has(4);
  @$pb.TagNumber(5)
  void clearCandidateCompositeScore() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get selectionRationale => $_getSZ(5);
  @$pb.TagNumber(6)
  set selectionRationale($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSelectionRationale() => $_has(5);
  @$pb.TagNumber(6)
  void clearSelectionRationale() => $_clearField(6);
}

/// ElectricalSignoff evidence: Electrical validation passed.
class ElectricalSignoff extends $pb.GeneratedMessage {
  factory ElectricalSignoff({
    $core.String? layoutId,
    $core.String? electricalAnalysisId,
    $core.String? validatedByActorId,
    $0.Timestamp? validatedAt,
    $core.Iterable<$core.String>? violations,
    $core.double? electricalFeasibilityScore,
  }) {
    final $result = create();
    if (layoutId != null) {
      $result.layoutId = layoutId;
    }
    if (electricalAnalysisId != null) {
      $result.electricalAnalysisId = electricalAnalysisId;
    }
    if (validatedByActorId != null) {
      $result.validatedByActorId = validatedByActorId;
    }
    if (validatedAt != null) {
      $result.validatedAt = validatedAt;
    }
    if (violations != null) {
      $result.violations.addAll(violations);
    }
    if (electricalFeasibilityScore != null) {
      $result.electricalFeasibilityScore = electricalFeasibilityScore;
    }
    return $result;
  }
  ElectricalSignoff._() : super();
  factory ElectricalSignoff.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ElectricalSignoff.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ElectricalSignoff', package: const $pb.PackageName(_omitMessageNames ? '' : 'planning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'layoutId')
    ..aOS(2, _omitFieldNames ? '' : 'electricalAnalysisId')
    ..aOS(3, _omitFieldNames ? '' : 'validatedByActorId')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'validatedAt', subBuilder: $0.Timestamp.create)
    ..pPS(5, _omitFieldNames ? '' : 'violations')
    ..a<$core.double>(6, _omitFieldNames ? '' : 'electricalFeasibilityScore', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ElectricalSignoff clone() => ElectricalSignoff()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ElectricalSignoff copyWith(void Function(ElectricalSignoff) updates) => super.copyWith((message) => updates(message as ElectricalSignoff)) as ElectricalSignoff;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ElectricalSignoff create() => ElectricalSignoff._();
  ElectricalSignoff createEmptyInstance() => create();
  static $pb.PbList<ElectricalSignoff> createRepeated() => $pb.PbList<ElectricalSignoff>();
  @$core.pragma('dart2js:noInline')
  static ElectricalSignoff getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ElectricalSignoff>(create);
  static ElectricalSignoff? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get layoutId => $_getSZ(0);
  @$pb.TagNumber(1)
  set layoutId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLayoutId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLayoutId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get electricalAnalysisId => $_getSZ(1);
  @$pb.TagNumber(2)
  set electricalAnalysisId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasElectricalAnalysisId() => $_has(1);
  @$pb.TagNumber(2)
  void clearElectricalAnalysisId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get validatedByActorId => $_getSZ(2);
  @$pb.TagNumber(3)
  set validatedByActorId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasValidatedByActorId() => $_has(2);
  @$pb.TagNumber(3)
  void clearValidatedByActorId() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get validatedAt => $_getN(3);
  @$pb.TagNumber(4)
  set validatedAt($0.Timestamp v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasValidatedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearValidatedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureValidatedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get violations => $_getList(4);

  @$pb.TagNumber(6)
  $core.double get electricalFeasibilityScore => $_getN(5);
  @$pb.TagNumber(6)
  set electricalFeasibilityScore($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasElectricalFeasibilityScore() => $_has(5);
  @$pb.TagNumber(6)
  void clearElectricalFeasibilityScore() => $_clearField(6);
}

/// TransmissionSignoff evidence: Transmission routing and protection complete.
class TransmissionSignoff extends $pb.GeneratedMessage {
  factory TransmissionSignoff({
    $core.String? electricalLayoutId,
    $core.String? transmissionRouteId,
    $core.String? approvedByActorId,
    $0.Timestamp? approvedAt,
    $core.Iterable<$core.String>? protectionDevices,
    $core.int? faultIsolationPoints,
  }) {
    final $result = create();
    if (electricalLayoutId != null) {
      $result.electricalLayoutId = electricalLayoutId;
    }
    if (transmissionRouteId != null) {
      $result.transmissionRouteId = transmissionRouteId;
    }
    if (approvedByActorId != null) {
      $result.approvedByActorId = approvedByActorId;
    }
    if (approvedAt != null) {
      $result.approvedAt = approvedAt;
    }
    if (protectionDevices != null) {
      $result.protectionDevices.addAll(protectionDevices);
    }
    if (faultIsolationPoints != null) {
      $result.faultIsolationPoints = faultIsolationPoints;
    }
    return $result;
  }
  TransmissionSignoff._() : super();
  factory TransmissionSignoff.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TransmissionSignoff.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TransmissionSignoff', package: const $pb.PackageName(_omitMessageNames ? '' : 'planning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'electricalLayoutId')
    ..aOS(2, _omitFieldNames ? '' : 'transmissionRouteId')
    ..aOS(3, _omitFieldNames ? '' : 'approvedByActorId')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'approvedAt', subBuilder: $0.Timestamp.create)
    ..pPS(5, _omitFieldNames ? '' : 'protectionDevices')
    ..a<$core.int>(6, _omitFieldNames ? '' : 'faultIsolationPoints', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TransmissionSignoff clone() => TransmissionSignoff()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TransmissionSignoff copyWith(void Function(TransmissionSignoff) updates) => super.copyWith((message) => updates(message as TransmissionSignoff)) as TransmissionSignoff;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransmissionSignoff create() => TransmissionSignoff._();
  TransmissionSignoff createEmptyInstance() => create();
  static $pb.PbList<TransmissionSignoff> createRepeated() => $pb.PbList<TransmissionSignoff>();
  @$core.pragma('dart2js:noInline')
  static TransmissionSignoff getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TransmissionSignoff>(create);
  static TransmissionSignoff? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get electricalLayoutId => $_getSZ(0);
  @$pb.TagNumber(1)
  set electricalLayoutId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasElectricalLayoutId() => $_has(0);
  @$pb.TagNumber(1)
  void clearElectricalLayoutId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get transmissionRouteId => $_getSZ(1);
  @$pb.TagNumber(2)
  set transmissionRouteId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTransmissionRouteId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTransmissionRouteId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get approvedByActorId => $_getSZ(2);
  @$pb.TagNumber(3)
  set approvedByActorId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasApprovedByActorId() => $_has(2);
  @$pb.TagNumber(3)
  void clearApprovedByActorId() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get approvedAt => $_getN(3);
  @$pb.TagNumber(4)
  set approvedAt($0.Timestamp v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasApprovedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearApprovedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureApprovedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get protectionDevices => $_getList(4);

  @$pb.TagNumber(6)
  $core.int get faultIsolationPoints => $_getIZ(5);
  @$pb.TagNumber(6)
  set faultIsolationPoints($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasFaultIsolationPoints() => $_has(5);
  @$pb.TagNumber(6)
  void clearFaultIsolationPoints() => $_clearField(6);
}

/// ReviewApproval evidence: LOD 400 checklist passed + quality gate cleared.
class ReviewApproval extends $pb.GeneratedMessage {
  factory ReviewApproval({
    $core.String? transmissionRouteId,
    $core.String? lod400ChecklistId,
    $core.String? reviewedByActorId,
    $0.Timestamp? reviewedAt,
    $core.int? mandatoryItemsVerified,
    $core.Iterable<$core.String>? blockers,
    $core.double? qualityScore,
  }) {
    final $result = create();
    if (transmissionRouteId != null) {
      $result.transmissionRouteId = transmissionRouteId;
    }
    if (lod400ChecklistId != null) {
      $result.lod400ChecklistId = lod400ChecklistId;
    }
    if (reviewedByActorId != null) {
      $result.reviewedByActorId = reviewedByActorId;
    }
    if (reviewedAt != null) {
      $result.reviewedAt = reviewedAt;
    }
    if (mandatoryItemsVerified != null) {
      $result.mandatoryItemsVerified = mandatoryItemsVerified;
    }
    if (blockers != null) {
      $result.blockers.addAll(blockers);
    }
    if (qualityScore != null) {
      $result.qualityScore = qualityScore;
    }
    return $result;
  }
  ReviewApproval._() : super();
  factory ReviewApproval.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReviewApproval.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReviewApproval', package: const $pb.PackageName(_omitMessageNames ? '' : 'planning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'transmissionRouteId')
    ..aOS(2, _omitFieldNames ? '' : 'lod400ChecklistId', protoName: 'lod_400_checklist_id')
    ..aOS(3, _omitFieldNames ? '' : 'reviewedByActorId')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'reviewedAt', subBuilder: $0.Timestamp.create)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'mandatoryItemsVerified', $pb.PbFieldType.O3)
    ..pPS(6, _omitFieldNames ? '' : 'blockers')
    ..a<$core.double>(7, _omitFieldNames ? '' : 'qualityScore', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReviewApproval clone() => ReviewApproval()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReviewApproval copyWith(void Function(ReviewApproval) updates) => super.copyWith((message) => updates(message as ReviewApproval)) as ReviewApproval;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReviewApproval create() => ReviewApproval._();
  ReviewApproval createEmptyInstance() => create();
  static $pb.PbList<ReviewApproval> createRepeated() => $pb.PbList<ReviewApproval>();
  @$core.pragma('dart2js:noInline')
  static ReviewApproval getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReviewApproval>(create);
  static ReviewApproval? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get transmissionRouteId => $_getSZ(0);
  @$pb.TagNumber(1)
  set transmissionRouteId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTransmissionRouteId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransmissionRouteId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get lod400ChecklistId => $_getSZ(1);
  @$pb.TagNumber(2)
  set lod400ChecklistId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLod400ChecklistId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLod400ChecklistId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reviewedByActorId => $_getSZ(2);
  @$pb.TagNumber(3)
  set reviewedByActorId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasReviewedByActorId() => $_has(2);
  @$pb.TagNumber(3)
  void clearReviewedByActorId() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get reviewedAt => $_getN(3);
  @$pb.TagNumber(4)
  set reviewedAt($0.Timestamp v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasReviewedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearReviewedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureReviewedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get mandatoryItemsVerified => $_getIZ(4);
  @$pb.TagNumber(5)
  set mandatoryItemsVerified($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMandatoryItemsVerified() => $_has(4);
  @$pb.TagNumber(5)
  void clearMandatoryItemsVerified() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get blockers => $_getList(5);

  @$pb.TagNumber(7)
  $core.double get qualityScore => $_getN(6);
  @$pb.TagNumber(7)
  set qualityScore($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasQualityScore() => $_has(6);
  @$pb.TagNumber(7)
  void clearQualityScore() => $_clearField(7);
}

/// StakeholderApproval evidence: Manager/stakeholder approval for commissioning.
class StakeholderApproval extends $pb.GeneratedMessage {
  factory StakeholderApproval({
    $core.String? reviewApprovedLayoutId,
    $core.String? approvedByActorId,
    $core.String? actorRole,
    $0.Timestamp? approvedAt,
    $core.String? approvalNotes,
  }) {
    final $result = create();
    if (reviewApprovedLayoutId != null) {
      $result.reviewApprovedLayoutId = reviewApprovedLayoutId;
    }
    if (approvedByActorId != null) {
      $result.approvedByActorId = approvedByActorId;
    }
    if (actorRole != null) {
      $result.actorRole = actorRole;
    }
    if (approvedAt != null) {
      $result.approvedAt = approvedAt;
    }
    if (approvalNotes != null) {
      $result.approvalNotes = approvalNotes;
    }
    return $result;
  }
  StakeholderApproval._() : super();
  factory StakeholderApproval.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StakeholderApproval.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StakeholderApproval', package: const $pb.PackageName(_omitMessageNames ? '' : 'planning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reviewApprovedLayoutId')
    ..aOS(2, _omitFieldNames ? '' : 'approvedByActorId')
    ..aOS(3, _omitFieldNames ? '' : 'actorRole')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'approvedAt', subBuilder: $0.Timestamp.create)
    ..aOS(5, _omitFieldNames ? '' : 'approvalNotes')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StakeholderApproval clone() => StakeholderApproval()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StakeholderApproval copyWith(void Function(StakeholderApproval) updates) => super.copyWith((message) => updates(message as StakeholderApproval)) as StakeholderApproval;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StakeholderApproval create() => StakeholderApproval._();
  StakeholderApproval createEmptyInstance() => create();
  static $pb.PbList<StakeholderApproval> createRepeated() => $pb.PbList<StakeholderApproval>();
  @$core.pragma('dart2js:noInline')
  static StakeholderApproval getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StakeholderApproval>(create);
  static StakeholderApproval? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reviewApprovedLayoutId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reviewApprovedLayoutId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasReviewApprovedLayoutId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReviewApprovedLayoutId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get approvedByActorId => $_getSZ(1);
  @$pb.TagNumber(2)
  set approvedByActorId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasApprovedByActorId() => $_has(1);
  @$pb.TagNumber(2)
  void clearApprovedByActorId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get actorRole => $_getSZ(2);
  @$pb.TagNumber(3)
  set actorRole($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasActorRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearActorRole() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get approvedAt => $_getN(3);
  @$pb.TagNumber(4)
  set approvedAt($0.Timestamp v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasApprovedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearApprovedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureApprovedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get approvalNotes => $_getSZ(4);
  @$pb.TagNumber(5)
  set approvalNotes($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasApprovalNotes() => $_has(4);
  @$pb.TagNumber(5)
  void clearApprovalNotes() => $_clearField(5);
}

/// CommissioningConfirmation evidence: Twin provisioned and asset identities linked.
class CommissioningConfirmation extends $pb.GeneratedMessage {
  factory CommissioningConfirmation({
    $core.String? approvedProjectId,
    $core.String? twinId,
    $core.String? provisionedByActorId,
    $0.Timestamp? provisionedAt,
    $core.int? assetIdentityLinks,
  }) {
    final $result = create();
    if (approvedProjectId != null) {
      $result.approvedProjectId = approvedProjectId;
    }
    if (twinId != null) {
      $result.twinId = twinId;
    }
    if (provisionedByActorId != null) {
      $result.provisionedByActorId = provisionedByActorId;
    }
    if (provisionedAt != null) {
      $result.provisionedAt = provisionedAt;
    }
    if (assetIdentityLinks != null) {
      $result.assetIdentityLinks = assetIdentityLinks;
    }
    return $result;
  }
  CommissioningConfirmation._() : super();
  factory CommissioningConfirmation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CommissioningConfirmation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CommissioningConfirmation', package: const $pb.PackageName(_omitMessageNames ? '' : 'planning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'approvedProjectId')
    ..aOS(2, _omitFieldNames ? '' : 'twinId')
    ..aOS(3, _omitFieldNames ? '' : 'provisionedByActorId')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'provisionedAt', subBuilder: $0.Timestamp.create)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'assetIdentityLinks', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CommissioningConfirmation clone() => CommissioningConfirmation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CommissioningConfirmation copyWith(void Function(CommissioningConfirmation) updates) => super.copyWith((message) => updates(message as CommissioningConfirmation)) as CommissioningConfirmation;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommissioningConfirmation create() => CommissioningConfirmation._();
  CommissioningConfirmation createEmptyInstance() => create();
  static $pb.PbList<CommissioningConfirmation> createRepeated() => $pb.PbList<CommissioningConfirmation>();
  @$core.pragma('dart2js:noInline')
  static CommissioningConfirmation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CommissioningConfirmation>(create);
  static CommissioningConfirmation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get approvedProjectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set approvedProjectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasApprovedProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearApprovedProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get twinId => $_getSZ(1);
  @$pb.TagNumber(2)
  set twinId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTwinId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTwinId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get provisionedByActorId => $_getSZ(2);
  @$pb.TagNumber(3)
  set provisionedByActorId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasProvisionedByActorId() => $_has(2);
  @$pb.TagNumber(3)
  void clearProvisionedByActorId() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get provisionedAt => $_getN(3);
  @$pb.TagNumber(4)
  set provisionedAt($0.Timestamp v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasProvisionedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearProvisionedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureProvisionedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get assetIdentityLinks => $_getIZ(4);
  @$pb.TagNumber(5)
  set assetIdentityLinks($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasAssetIdentityLinks() => $_has(4);
  @$pb.TagNumber(5)
  void clearAssetIdentityLinks() => $_clearField(5);
}

/// PhaseTransition represents a single immutable transition record.
/// All transitions are logged and never deleted (audit trail).
class PhaseTransition extends $pb.GeneratedMessage {
  factory PhaseTransition({
    $core.String? id,
    $core.String? projectId,
    WorkflowPhase? fromPhase,
    WorkflowPhase? toPhase,
    TransitionEvidence? evidence,
    $0.Timestamp? occurredAt,
    $core.String? actorId,
    $core.String? reason,
    $core.bool? isRollback,
    $core.String? rollbackReason,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (fromPhase != null) {
      $result.fromPhase = fromPhase;
    }
    if (toPhase != null) {
      $result.toPhase = toPhase;
    }
    if (evidence != null) {
      $result.evidence = evidence;
    }
    if (occurredAt != null) {
      $result.occurredAt = occurredAt;
    }
    if (actorId != null) {
      $result.actorId = actorId;
    }
    if (reason != null) {
      $result.reason = reason;
    }
    if (isRollback != null) {
      $result.isRollback = isRollback;
    }
    if (rollbackReason != null) {
      $result.rollbackReason = rollbackReason;
    }
    return $result;
  }
  PhaseTransition._() : super();
  factory PhaseTransition.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PhaseTransition.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PhaseTransition', package: const $pb.PackageName(_omitMessageNames ? '' : 'planning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..e<WorkflowPhase>(3, _omitFieldNames ? '' : 'fromPhase', $pb.PbFieldType.OE, defaultOrMaker: WorkflowPhase.WORKFLOW_PHASE_UNSPECIFIED, valueOf: WorkflowPhase.valueOf, enumValues: WorkflowPhase.values)
    ..e<WorkflowPhase>(4, _omitFieldNames ? '' : 'toPhase', $pb.PbFieldType.OE, defaultOrMaker: WorkflowPhase.WORKFLOW_PHASE_UNSPECIFIED, valueOf: WorkflowPhase.valueOf, enumValues: WorkflowPhase.values)
    ..aOM<TransitionEvidence>(5, _omitFieldNames ? '' : 'evidence', subBuilder: TransitionEvidence.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'occurredAt', subBuilder: $0.Timestamp.create)
    ..aOS(7, _omitFieldNames ? '' : 'actorId')
    ..aOS(8, _omitFieldNames ? '' : 'reason')
    ..aOB(9, _omitFieldNames ? '' : 'isRollback')
    ..aOS(10, _omitFieldNames ? '' : 'rollbackReason')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PhaseTransition clone() => PhaseTransition()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PhaseTransition copyWith(void Function(PhaseTransition) updates) => super.copyWith((message) => updates(message as PhaseTransition)) as PhaseTransition;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PhaseTransition create() => PhaseTransition._();
  PhaseTransition createEmptyInstance() => create();
  static $pb.PbList<PhaseTransition> createRepeated() => $pb.PbList<PhaseTransition>();
  @$core.pragma('dart2js:noInline')
  static PhaseTransition getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PhaseTransition>(create);
  static PhaseTransition? _defaultInstance;

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
  WorkflowPhase get fromPhase => $_getN(2);
  @$pb.TagNumber(3)
  set fromPhase(WorkflowPhase v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasFromPhase() => $_has(2);
  @$pb.TagNumber(3)
  void clearFromPhase() => $_clearField(3);

  @$pb.TagNumber(4)
  WorkflowPhase get toPhase => $_getN(3);
  @$pb.TagNumber(4)
  set toPhase(WorkflowPhase v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasToPhase() => $_has(3);
  @$pb.TagNumber(4)
  void clearToPhase() => $_clearField(4);

  @$pb.TagNumber(5)
  TransitionEvidence get evidence => $_getN(4);
  @$pb.TagNumber(5)
  set evidence(TransitionEvidence v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasEvidence() => $_has(4);
  @$pb.TagNumber(5)
  void clearEvidence() => $_clearField(5);
  @$pb.TagNumber(5)
  TransitionEvidence ensureEvidence() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Timestamp get occurredAt => $_getN(5);
  @$pb.TagNumber(6)
  set occurredAt($0.Timestamp v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasOccurredAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearOccurredAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureOccurredAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get actorId => $_getSZ(6);
  @$pb.TagNumber(7)
  set actorId($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasActorId() => $_has(6);
  @$pb.TagNumber(7)
  void clearActorId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get reason => $_getSZ(7);
  @$pb.TagNumber(8)
  set reason($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasReason() => $_has(7);
  @$pb.TagNumber(8)
  void clearReason() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get isRollback => $_getBF(8);
  @$pb.TagNumber(9)
  set isRollback($core.bool v) { $_setBool(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasIsRollback() => $_has(8);
  @$pb.TagNumber(9)
  void clearIsRollback() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get rollbackReason => $_getSZ(9);
  @$pb.TagNumber(10)
  set rollbackReason($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasRollbackReason() => $_has(9);
  @$pb.TagNumber(10)
  void clearRollbackReason() => $_clearField(10);
}

class TransitionPhaseRequest extends $pb.GeneratedMessage {
  factory TransitionPhaseRequest({
    $core.String? projectId,
    WorkflowPhase? targetPhase,
    TransitionEvidence? evidence,
    $core.String? actorId,
    $core.String? reason,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (targetPhase != null) {
      $result.targetPhase = targetPhase;
    }
    if (evidence != null) {
      $result.evidence = evidence;
    }
    if (actorId != null) {
      $result.actorId = actorId;
    }
    if (reason != null) {
      $result.reason = reason;
    }
    return $result;
  }
  TransitionPhaseRequest._() : super();
  factory TransitionPhaseRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TransitionPhaseRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TransitionPhaseRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'planning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..e<WorkflowPhase>(2, _omitFieldNames ? '' : 'targetPhase', $pb.PbFieldType.OE, defaultOrMaker: WorkflowPhase.WORKFLOW_PHASE_UNSPECIFIED, valueOf: WorkflowPhase.valueOf, enumValues: WorkflowPhase.values)
    ..aOM<TransitionEvidence>(3, _omitFieldNames ? '' : 'evidence', subBuilder: TransitionEvidence.create)
    ..aOS(4, _omitFieldNames ? '' : 'actorId')
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TransitionPhaseRequest clone() => TransitionPhaseRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TransitionPhaseRequest copyWith(void Function(TransitionPhaseRequest) updates) => super.copyWith((message) => updates(message as TransitionPhaseRequest)) as TransitionPhaseRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransitionPhaseRequest create() => TransitionPhaseRequest._();
  TransitionPhaseRequest createEmptyInstance() => create();
  static $pb.PbList<TransitionPhaseRequest> createRepeated() => $pb.PbList<TransitionPhaseRequest>();
  @$core.pragma('dart2js:noInline')
  static TransitionPhaseRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TransitionPhaseRequest>(create);
  static TransitionPhaseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  WorkflowPhase get targetPhase => $_getN(1);
  @$pb.TagNumber(2)
  set targetPhase(WorkflowPhase v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasTargetPhase() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetPhase() => $_clearField(2);

  @$pb.TagNumber(3)
  TransitionEvidence get evidence => $_getN(2);
  @$pb.TagNumber(3)
  set evidence(TransitionEvidence v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasEvidence() => $_has(2);
  @$pb.TagNumber(3)
  void clearEvidence() => $_clearField(3);
  @$pb.TagNumber(3)
  TransitionEvidence ensureEvidence() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get actorId => $_getSZ(3);
  @$pb.TagNumber(4)
  set actorId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasActorId() => $_has(3);
  @$pb.TagNumber(4)
  void clearActorId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);
}

class TransitionPhaseResponse extends $pb.GeneratedMessage {
  factory TransitionPhaseResponse({
    $core.String? projectId,
    WorkflowPhase? previousPhase,
    WorkflowPhase? currentPhase,
    PhaseTransition? transitionRecord,
    $core.bool? wasNoop,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (previousPhase != null) {
      $result.previousPhase = previousPhase;
    }
    if (currentPhase != null) {
      $result.currentPhase = currentPhase;
    }
    if (transitionRecord != null) {
      $result.transitionRecord = transitionRecord;
    }
    if (wasNoop != null) {
      $result.wasNoop = wasNoop;
    }
    return $result;
  }
  TransitionPhaseResponse._() : super();
  factory TransitionPhaseResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TransitionPhaseResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TransitionPhaseResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'planning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..e<WorkflowPhase>(2, _omitFieldNames ? '' : 'previousPhase', $pb.PbFieldType.OE, defaultOrMaker: WorkflowPhase.WORKFLOW_PHASE_UNSPECIFIED, valueOf: WorkflowPhase.valueOf, enumValues: WorkflowPhase.values)
    ..e<WorkflowPhase>(3, _omitFieldNames ? '' : 'currentPhase', $pb.PbFieldType.OE, defaultOrMaker: WorkflowPhase.WORKFLOW_PHASE_UNSPECIFIED, valueOf: WorkflowPhase.valueOf, enumValues: WorkflowPhase.values)
    ..aOM<PhaseTransition>(4, _omitFieldNames ? '' : 'transitionRecord', subBuilder: PhaseTransition.create)
    ..aOB(5, _omitFieldNames ? '' : 'wasNoop')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TransitionPhaseResponse clone() => TransitionPhaseResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TransitionPhaseResponse copyWith(void Function(TransitionPhaseResponse) updates) => super.copyWith((message) => updates(message as TransitionPhaseResponse)) as TransitionPhaseResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransitionPhaseResponse create() => TransitionPhaseResponse._();
  TransitionPhaseResponse createEmptyInstance() => create();
  static $pb.PbList<TransitionPhaseResponse> createRepeated() => $pb.PbList<TransitionPhaseResponse>();
  @$core.pragma('dart2js:noInline')
  static TransitionPhaseResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TransitionPhaseResponse>(create);
  static TransitionPhaseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  WorkflowPhase get previousPhase => $_getN(1);
  @$pb.TagNumber(2)
  set previousPhase(WorkflowPhase v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPreviousPhase() => $_has(1);
  @$pb.TagNumber(2)
  void clearPreviousPhase() => $_clearField(2);

  @$pb.TagNumber(3)
  WorkflowPhase get currentPhase => $_getN(2);
  @$pb.TagNumber(3)
  set currentPhase(WorkflowPhase v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCurrentPhase() => $_has(2);
  @$pb.TagNumber(3)
  void clearCurrentPhase() => $_clearField(3);

  @$pb.TagNumber(4)
  PhaseTransition get transitionRecord => $_getN(3);
  @$pb.TagNumber(4)
  set transitionRecord(PhaseTransition v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasTransitionRecord() => $_has(3);
  @$pb.TagNumber(4)
  void clearTransitionRecord() => $_clearField(4);
  @$pb.TagNumber(4)
  PhaseTransition ensureTransitionRecord() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.bool get wasNoop => $_getBF(4);
  @$pb.TagNumber(5)
  set wasNoop($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasWasNoop() => $_has(4);
  @$pb.TagNumber(5)
  void clearWasNoop() => $_clearField(5);
}

class GetPhaseStateRequest extends $pb.GeneratedMessage {
  factory GetPhaseStateRequest({
    $core.String? projectId,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    return $result;
  }
  GetPhaseStateRequest._() : super();
  factory GetPhaseStateRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetPhaseStateRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetPhaseStateRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'planning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetPhaseStateRequest clone() => GetPhaseStateRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetPhaseStateRequest copyWith(void Function(GetPhaseStateRequest) updates) => super.copyWith((message) => updates(message as GetPhaseStateRequest)) as GetPhaseStateRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPhaseStateRequest create() => GetPhaseStateRequest._();
  GetPhaseStateRequest createEmptyInstance() => create();
  static $pb.PbList<GetPhaseStateRequest> createRepeated() => $pb.PbList<GetPhaseStateRequest>();
  @$core.pragma('dart2js:noInline')
  static GetPhaseStateRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetPhaseStateRequest>(create);
  static GetPhaseStateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);
}

class GetPhaseStateResponse extends $pb.GeneratedMessage {
  factory GetPhaseStateResponse({
    $core.String? projectId,
    WorkflowPhase? currentPhase,
    $0.Timestamp? phaseEnteredAt,
    PhaseTransition? lastTransition,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (currentPhase != null) {
      $result.currentPhase = currentPhase;
    }
    if (phaseEnteredAt != null) {
      $result.phaseEnteredAt = phaseEnteredAt;
    }
    if (lastTransition != null) {
      $result.lastTransition = lastTransition;
    }
    return $result;
  }
  GetPhaseStateResponse._() : super();
  factory GetPhaseStateResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetPhaseStateResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetPhaseStateResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'planning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..e<WorkflowPhase>(2, _omitFieldNames ? '' : 'currentPhase', $pb.PbFieldType.OE, defaultOrMaker: WorkflowPhase.WORKFLOW_PHASE_UNSPECIFIED, valueOf: WorkflowPhase.valueOf, enumValues: WorkflowPhase.values)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'phaseEnteredAt', subBuilder: $0.Timestamp.create)
    ..aOM<PhaseTransition>(4, _omitFieldNames ? '' : 'lastTransition', subBuilder: PhaseTransition.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetPhaseStateResponse clone() => GetPhaseStateResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetPhaseStateResponse copyWith(void Function(GetPhaseStateResponse) updates) => super.copyWith((message) => updates(message as GetPhaseStateResponse)) as GetPhaseStateResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPhaseStateResponse create() => GetPhaseStateResponse._();
  GetPhaseStateResponse createEmptyInstance() => create();
  static $pb.PbList<GetPhaseStateResponse> createRepeated() => $pb.PbList<GetPhaseStateResponse>();
  @$core.pragma('dart2js:noInline')
  static GetPhaseStateResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetPhaseStateResponse>(create);
  static GetPhaseStateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  WorkflowPhase get currentPhase => $_getN(1);
  @$pb.TagNumber(2)
  set currentPhase(WorkflowPhase v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCurrentPhase() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrentPhase() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get phaseEnteredAt => $_getN(2);
  @$pb.TagNumber(3)
  set phaseEnteredAt($0.Timestamp v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPhaseEnteredAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearPhaseEnteredAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensurePhaseEnteredAt() => $_ensure(2);

  @$pb.TagNumber(4)
  PhaseTransition get lastTransition => $_getN(3);
  @$pb.TagNumber(4)
  set lastTransition(PhaseTransition v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasLastTransition() => $_has(3);
  @$pb.TagNumber(4)
  void clearLastTransition() => $_clearField(4);
  @$pb.TagNumber(4)
  PhaseTransition ensureLastTransition() => $_ensure(3);
}

class ListPhaseTransitionsRequest extends $pb.GeneratedMessage {
  factory ListPhaseTransitionsRequest({
    $core.String? projectId,
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (pageSize != null) {
      $result.pageSize = pageSize;
    }
    if (pageToken != null) {
      $result.pageToken = pageToken;
    }
    return $result;
  }
  ListPhaseTransitionsRequest._() : super();
  factory ListPhaseTransitionsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListPhaseTransitionsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListPhaseTransitionsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'planning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'pageSize', $pb.PbFieldType.O3)
    ..aOS(3, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListPhaseTransitionsRequest clone() => ListPhaseTransitionsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListPhaseTransitionsRequest copyWith(void Function(ListPhaseTransitionsRequest) updates) => super.copyWith((message) => updates(message as ListPhaseTransitionsRequest)) as ListPhaseTransitionsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPhaseTransitionsRequest create() => ListPhaseTransitionsRequest._();
  ListPhaseTransitionsRequest createEmptyInstance() => create();
  static $pb.PbList<ListPhaseTransitionsRequest> createRepeated() => $pb.PbList<ListPhaseTransitionsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListPhaseTransitionsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListPhaseTransitionsRequest>(create);
  static ListPhaseTransitionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get pageToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set pageToken($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPageToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageToken() => $_clearField(3);
}

class ListPhaseTransitionsResponse extends $pb.GeneratedMessage {
  factory ListPhaseTransitionsResponse({
    $core.Iterable<PhaseTransition>? transitions,
    $core.String? nextPageToken,
  }) {
    final $result = create();
    if (transitions != null) {
      $result.transitions.addAll(transitions);
    }
    if (nextPageToken != null) {
      $result.nextPageToken = nextPageToken;
    }
    return $result;
  }
  ListPhaseTransitionsResponse._() : super();
  factory ListPhaseTransitionsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListPhaseTransitionsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListPhaseTransitionsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'planning.v1'), createEmptyInstance: create)
    ..pc<PhaseTransition>(1, _omitFieldNames ? '' : 'transitions', $pb.PbFieldType.PM, subBuilder: PhaseTransition.create)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListPhaseTransitionsResponse clone() => ListPhaseTransitionsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListPhaseTransitionsResponse copyWith(void Function(ListPhaseTransitionsResponse) updates) => super.copyWith((message) => updates(message as ListPhaseTransitionsResponse)) as ListPhaseTransitionsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPhaseTransitionsResponse create() => ListPhaseTransitionsResponse._();
  ListPhaseTransitionsResponse createEmptyInstance() => create();
  static $pb.PbList<ListPhaseTransitionsResponse> createRepeated() => $pb.PbList<ListPhaseTransitionsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListPhaseTransitionsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListPhaseTransitionsResponse>(create);
  static ListPhaseTransitionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PhaseTransition> get transitions => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);
}

class ValidatePhaseReadinessRequest extends $pb.GeneratedMessage {
  factory ValidatePhaseReadinessRequest({
    $core.String? projectId,
    WorkflowPhase? targetPhase,
    TransitionEvidence? evidence,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (targetPhase != null) {
      $result.targetPhase = targetPhase;
    }
    if (evidence != null) {
      $result.evidence = evidence;
    }
    return $result;
  }
  ValidatePhaseReadinessRequest._() : super();
  factory ValidatePhaseReadinessRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ValidatePhaseReadinessRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ValidatePhaseReadinessRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'planning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..e<WorkflowPhase>(2, _omitFieldNames ? '' : 'targetPhase', $pb.PbFieldType.OE, defaultOrMaker: WorkflowPhase.WORKFLOW_PHASE_UNSPECIFIED, valueOf: WorkflowPhase.valueOf, enumValues: WorkflowPhase.values)
    ..aOM<TransitionEvidence>(3, _omitFieldNames ? '' : 'evidence', subBuilder: TransitionEvidence.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ValidatePhaseReadinessRequest clone() => ValidatePhaseReadinessRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ValidatePhaseReadinessRequest copyWith(void Function(ValidatePhaseReadinessRequest) updates) => super.copyWith((message) => updates(message as ValidatePhaseReadinessRequest)) as ValidatePhaseReadinessRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ValidatePhaseReadinessRequest create() => ValidatePhaseReadinessRequest._();
  ValidatePhaseReadinessRequest createEmptyInstance() => create();
  static $pb.PbList<ValidatePhaseReadinessRequest> createRepeated() => $pb.PbList<ValidatePhaseReadinessRequest>();
  @$core.pragma('dart2js:noInline')
  static ValidatePhaseReadinessRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ValidatePhaseReadinessRequest>(create);
  static ValidatePhaseReadinessRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  WorkflowPhase get targetPhase => $_getN(1);
  @$pb.TagNumber(2)
  set targetPhase(WorkflowPhase v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasTargetPhase() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetPhase() => $_clearField(2);

  @$pb.TagNumber(3)
  TransitionEvidence get evidence => $_getN(2);
  @$pb.TagNumber(3)
  set evidence(TransitionEvidence v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasEvidence() => $_has(2);
  @$pb.TagNumber(3)
  void clearEvidence() => $_clearField(3);
  @$pb.TagNumber(3)
  TransitionEvidence ensureEvidence() => $_ensure(2);
}

class ValidatePhaseReadinessResponse extends $pb.GeneratedMessage {
  factory ValidatePhaseReadinessResponse({
    $core.String? projectId,
    WorkflowPhase? currentPhase,
    WorkflowPhase? targetPhase,
    $core.bool? isValid,
    $core.Iterable<$core.String>? blockerReasons,
    $0.Timestamp? canTransitionAfter,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (currentPhase != null) {
      $result.currentPhase = currentPhase;
    }
    if (targetPhase != null) {
      $result.targetPhase = targetPhase;
    }
    if (isValid != null) {
      $result.isValid = isValid;
    }
    if (blockerReasons != null) {
      $result.blockerReasons.addAll(blockerReasons);
    }
    if (canTransitionAfter != null) {
      $result.canTransitionAfter = canTransitionAfter;
    }
    return $result;
  }
  ValidatePhaseReadinessResponse._() : super();
  factory ValidatePhaseReadinessResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ValidatePhaseReadinessResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ValidatePhaseReadinessResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'planning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..e<WorkflowPhase>(2, _omitFieldNames ? '' : 'currentPhase', $pb.PbFieldType.OE, defaultOrMaker: WorkflowPhase.WORKFLOW_PHASE_UNSPECIFIED, valueOf: WorkflowPhase.valueOf, enumValues: WorkflowPhase.values)
    ..e<WorkflowPhase>(3, _omitFieldNames ? '' : 'targetPhase', $pb.PbFieldType.OE, defaultOrMaker: WorkflowPhase.WORKFLOW_PHASE_UNSPECIFIED, valueOf: WorkflowPhase.valueOf, enumValues: WorkflowPhase.values)
    ..aOB(4, _omitFieldNames ? '' : 'isValid')
    ..pPS(5, _omitFieldNames ? '' : 'blockerReasons')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'canTransitionAfter', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ValidatePhaseReadinessResponse clone() => ValidatePhaseReadinessResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ValidatePhaseReadinessResponse copyWith(void Function(ValidatePhaseReadinessResponse) updates) => super.copyWith((message) => updates(message as ValidatePhaseReadinessResponse)) as ValidatePhaseReadinessResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ValidatePhaseReadinessResponse create() => ValidatePhaseReadinessResponse._();
  ValidatePhaseReadinessResponse createEmptyInstance() => create();
  static $pb.PbList<ValidatePhaseReadinessResponse> createRepeated() => $pb.PbList<ValidatePhaseReadinessResponse>();
  @$core.pragma('dart2js:noInline')
  static ValidatePhaseReadinessResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ValidatePhaseReadinessResponse>(create);
  static ValidatePhaseReadinessResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  WorkflowPhase get currentPhase => $_getN(1);
  @$pb.TagNumber(2)
  set currentPhase(WorkflowPhase v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCurrentPhase() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrentPhase() => $_clearField(2);

  @$pb.TagNumber(3)
  WorkflowPhase get targetPhase => $_getN(2);
  @$pb.TagNumber(3)
  set targetPhase(WorkflowPhase v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasTargetPhase() => $_has(2);
  @$pb.TagNumber(3)
  void clearTargetPhase() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isValid => $_getBF(3);
  @$pb.TagNumber(4)
  set isValid($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIsValid() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsValid() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get blockerReasons => $_getList(4);

  @$pb.TagNumber(6)
  $0.Timestamp get canTransitionAfter => $_getN(5);
  @$pb.TagNumber(6)
  set canTransitionAfter($0.Timestamp v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasCanTransitionAfter() => $_has(5);
  @$pb.TagNumber(6)
  void clearCanTransitionAfter() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureCanTransitionAfter() => $_ensure(5);
}

/// WorkflowState represents the immutable state snapshot at any point.
class WorkflowState extends $pb.GeneratedMessage {
  factory WorkflowState({
    $core.String? projectId,
    WorkflowPhase? currentPhase,
    $0.Timestamp? phaseEnteredAt,
    $core.int? totalTransitions,
    $core.Iterable<$core.String>? activeBlockers,
    $core.String? actorBlockedSince,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (currentPhase != null) {
      $result.currentPhase = currentPhase;
    }
    if (phaseEnteredAt != null) {
      $result.phaseEnteredAt = phaseEnteredAt;
    }
    if (totalTransitions != null) {
      $result.totalTransitions = totalTransitions;
    }
    if (activeBlockers != null) {
      $result.activeBlockers.addAll(activeBlockers);
    }
    if (actorBlockedSince != null) {
      $result.actorBlockedSince = actorBlockedSince;
    }
    return $result;
  }
  WorkflowState._() : super();
  factory WorkflowState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WorkflowState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WorkflowState', package: const $pb.PackageName(_omitMessageNames ? '' : 'planning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..e<WorkflowPhase>(2, _omitFieldNames ? '' : 'currentPhase', $pb.PbFieldType.OE, defaultOrMaker: WorkflowPhase.WORKFLOW_PHASE_UNSPECIFIED, valueOf: WorkflowPhase.valueOf, enumValues: WorkflowPhase.values)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'phaseEnteredAt', subBuilder: $0.Timestamp.create)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'totalTransitions', $pb.PbFieldType.O3)
    ..pPS(5, _omitFieldNames ? '' : 'activeBlockers')
    ..aOS(6, _omitFieldNames ? '' : 'actorBlockedSince')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WorkflowState clone() => WorkflowState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WorkflowState copyWith(void Function(WorkflowState) updates) => super.copyWith((message) => updates(message as WorkflowState)) as WorkflowState;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WorkflowState create() => WorkflowState._();
  WorkflowState createEmptyInstance() => create();
  static $pb.PbList<WorkflowState> createRepeated() => $pb.PbList<WorkflowState>();
  @$core.pragma('dart2js:noInline')
  static WorkflowState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WorkflowState>(create);
  static WorkflowState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  WorkflowPhase get currentPhase => $_getN(1);
  @$pb.TagNumber(2)
  set currentPhase(WorkflowPhase v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCurrentPhase() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrentPhase() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get phaseEnteredAt => $_getN(2);
  @$pb.TagNumber(3)
  set phaseEnteredAt($0.Timestamp v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPhaseEnteredAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearPhaseEnteredAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensurePhaseEnteredAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get totalTransitions => $_getIZ(3);
  @$pb.TagNumber(4)
  set totalTransitions($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTotalTransitions() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalTransitions() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get activeBlockers => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get actorBlockedSince => $_getSZ(5);
  @$pb.TagNumber(6)
  set actorBlockedSince($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasActorBlockedSince() => $_has(5);
  @$pb.TagNumber(6)
  void clearActorBlockedSince() => $_clearField(6);
}

///  PlanningWorkflowService manages transitions through the planning, design,
///  validation, and approval workflow phases for solar projects.
///
///  The workflow is deterministic and sequential: projects progress from Planning
///  through LayoutReady, ElectricalReady, TransmissionReady, ReviewReady, Approved,
///  and finally CommissioningReady. Each transition is gated by predecessor phase
///  acceptance and validated evidence payloads.
class PlanningWorkflowServiceApi {
  $pb.RpcClient _client;
  PlanningWorkflowServiceApi(this._client);

  /// TransitionPhase transitions a project from its current phase to a new phase.
  /// The transition is idempotent: if already in the target phase, returns success
  /// with a "no-op" transition record. Backward transitions (rollback) are allowed
  /// only for phases before CommissioningReady.
  $async.Future<TransitionPhaseResponse> transitionPhase($pb.ClientContext? ctx, TransitionPhaseRequest request) =>
    _client.invoke<TransitionPhaseResponse>(ctx, 'PlanningWorkflowService', 'TransitionPhase', request, TransitionPhaseResponse())
  ;
  /// GetPhaseState retrieves the current phase and transition history for a project.
  $async.Future<GetPhaseStateResponse> getPhaseState($pb.ClientContext? ctx, GetPhaseStateRequest request) =>
    _client.invoke<GetPhaseStateResponse>(ctx, 'PlanningWorkflowService', 'GetPhaseState', request, GetPhaseStateResponse())
  ;
  /// ListPhaseTransitions returns all phase transitions for a project (immutable history).
  $async.Future<ListPhaseTransitionsResponse> listPhaseTransitions($pb.ClientContext? ctx, ListPhaseTransitionsRequest request) =>
    _client.invoke<ListPhaseTransitionsResponse>(ctx, 'PlanningWorkflowService', 'ListPhaseTransitions', request, ListPhaseTransitionsResponse())
  ;
  /// ValidatePhaseReadiness returns blocker reasons if a phase transition would fail,
  /// without actually performing the transition. Useful for UX validation.
  $async.Future<ValidatePhaseReadinessResponse> validatePhaseReadiness($pb.ClientContext? ctx, ValidatePhaseReadinessRequest request) =>
    _client.invoke<ValidatePhaseReadinessResponse>(ctx, 'PlanningWorkflowService', 'ValidatePhaseReadiness', request, ValidatePhaseReadinessResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
