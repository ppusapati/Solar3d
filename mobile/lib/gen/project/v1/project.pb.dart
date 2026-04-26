//
//  Generated code. Do not modify.
//  source: project/v1/project.proto
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
import '../../planning/v1/planning_workflow.pb.dart' as $2;
import '../../planning/v1/planning_workflow.pbenum.dart' as $2;
import 'project.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'project.pbenum.dart';

class Project extends $pb.GeneratedMessage {
  factory Project({
    $core.String? id,
    $core.String? name,
    $core.String? description,
    ProjectStatus? status,
    Site? site,
    ProjectMetadata? metadata,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
    $2.WorkflowPhase? workflowPhase,
    $0.Timestamp? phaseEnteredAt,
    $core.Iterable<PhaseTransitionHistoryEntry>? transitionHistory,
    $core.Iterable<$core.String>? activeBlockers,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    if (description != null) {
      $result.description = description;
    }
    if (status != null) {
      $result.status = status;
    }
    if (site != null) {
      $result.site = site;
    }
    if (metadata != null) {
      $result.metadata = metadata;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      $result.updatedAt = updatedAt;
    }
    if (workflowPhase != null) {
      $result.workflowPhase = workflowPhase;
    }
    if (phaseEnteredAt != null) {
      $result.phaseEnteredAt = phaseEnteredAt;
    }
    if (transitionHistory != null) {
      $result.transitionHistory.addAll(transitionHistory);
    }
    if (activeBlockers != null) {
      $result.activeBlockers.addAll(activeBlockers);
    }
    return $result;
  }
  Project._() : super();
  factory Project.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Project.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Project', package: const $pb.PackageName(_omitMessageNames ? '' : 'project.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..e<ProjectStatus>(4, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: ProjectStatus.PROJECT_STATUS_UNSPECIFIED, valueOf: ProjectStatus.valueOf, enumValues: ProjectStatus.values)
    ..aOM<Site>(5, _omitFieldNames ? '' : 'site', subBuilder: Site.create)
    ..aOM<ProjectMetadata>(6, _omitFieldNames ? '' : 'metadata', subBuilder: ProjectMetadata.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'updatedAt', subBuilder: $0.Timestamp.create)
    ..e<$2.WorkflowPhase>(9, _omitFieldNames ? '' : 'workflowPhase', $pb.PbFieldType.OE, defaultOrMaker: $2.WorkflowPhase.WORKFLOW_PHASE_UNSPECIFIED, valueOf: $2.WorkflowPhase.valueOf, enumValues: $2.WorkflowPhase.values)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'phaseEnteredAt', subBuilder: $0.Timestamp.create)
    ..pc<PhaseTransitionHistoryEntry>(11, _omitFieldNames ? '' : 'transitionHistory', $pb.PbFieldType.PM, subBuilder: PhaseTransitionHistoryEntry.create)
    ..pPS(12, _omitFieldNames ? '' : 'activeBlockers')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Project clone() => Project()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Project copyWith(void Function(Project) updates) => super.copyWith((message) => updates(message as Project)) as Project;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Project create() => Project._();
  Project createEmptyInstance() => create();
  static $pb.PbList<Project> createRepeated() => $pb.PbList<Project>();
  @$core.pragma('dart2js:noInline')
  static Project getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Project>(create);
  static Project? _defaultInstance;

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
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  ProjectStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status(ProjectStatus v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  Site get site => $_getN(4);
  @$pb.TagNumber(5)
  set site(Site v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasSite() => $_has(4);
  @$pb.TagNumber(5)
  void clearSite() => $_clearField(5);
  @$pb.TagNumber(5)
  Site ensureSite() => $_ensure(4);

  @$pb.TagNumber(6)
  ProjectMetadata get metadata => $_getN(5);
  @$pb.TagNumber(6)
  set metadata(ProjectMetadata v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasMetadata() => $_has(5);
  @$pb.TagNumber(6)
  void clearMetadata() => $_clearField(6);
  @$pb.TagNumber(6)
  ProjectMetadata ensureMetadata() => $_ensure(5);

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

  @$pb.TagNumber(8)
  $0.Timestamp get updatedAt => $_getN(7);
  @$pb.TagNumber(8)
  set updatedAt($0.Timestamp v) { $_setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasUpdatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearUpdatedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureUpdatedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $2.WorkflowPhase get workflowPhase => $_getN(8);
  @$pb.TagNumber(9)
  set workflowPhase($2.WorkflowPhase v) { $_setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasWorkflowPhase() => $_has(8);
  @$pb.TagNumber(9)
  void clearWorkflowPhase() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get phaseEnteredAt => $_getN(9);
  @$pb.TagNumber(10)
  set phaseEnteredAt($0.Timestamp v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasPhaseEnteredAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearPhaseEnteredAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensurePhaseEnteredAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $pb.PbList<PhaseTransitionHistoryEntry> get transitionHistory => $_getList(10);

  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get activeBlockers => $_getList(11);
}

class Site extends $pb.GeneratedMessage {
  factory Site({
    $core.String? id,
    $core.String? projectId,
    $core.String? name,
    $core.String? boundaryGeojson,
    $core.double? areaSqm,
    $core.double? latitude,
    $core.double? longitude,
    $core.String? timezone,
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
    if (boundaryGeojson != null) {
      $result.boundaryGeojson = boundaryGeojson;
    }
    if (areaSqm != null) {
      $result.areaSqm = areaSqm;
    }
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (longitude != null) {
      $result.longitude = longitude;
    }
    if (timezone != null) {
      $result.timezone = timezone;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    return $result;
  }
  Site._() : super();
  factory Site.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Site.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Site', package: const $pb.PackageName(_omitMessageNames ? '' : 'project.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'boundaryGeojson')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'areaSqm', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..aOS(8, _omitFieldNames ? '' : 'timezone')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Site clone() => Site()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Site copyWith(void Function(Site) updates) => super.copyWith((message) => updates(message as Site)) as Site;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Site create() => Site._();
  Site createEmptyInstance() => create();
  static $pb.PbList<Site> createRepeated() => $pb.PbList<Site>();
  @$core.pragma('dart2js:noInline')
  static Site getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Site>(create);
  static Site? _defaultInstance;

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

  /// GeoJSON polygon boundary
  @$pb.TagNumber(4)
  $core.String get boundaryGeojson => $_getSZ(3);
  @$pb.TagNumber(4)
  set boundaryGeojson($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBoundaryGeojson() => $_has(3);
  @$pb.TagNumber(4)
  void clearBoundaryGeojson() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get areaSqm => $_getN(4);
  @$pb.TagNumber(5)
  set areaSqm($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasAreaSqm() => $_has(4);
  @$pb.TagNumber(5)
  void clearAreaSqm() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get latitude => $_getN(5);
  @$pb.TagNumber(6)
  set latitude($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLatitude() => $_has(5);
  @$pb.TagNumber(6)
  void clearLatitude() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get longitude => $_getN(6);
  @$pb.TagNumber(7)
  set longitude($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasLongitude() => $_has(6);
  @$pb.TagNumber(7)
  void clearLongitude() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get timezone => $_getSZ(7);
  @$pb.TagNumber(8)
  set timezone($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasTimezone() => $_has(7);
  @$pb.TagNumber(8)
  void clearTimezone() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get createdAt => $_getN(8);
  @$pb.TagNumber(9)
  set createdAt($0.Timestamp v) { $_setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasCreatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureCreatedAt() => $_ensure(8);
}

class ProjectMetadata extends $pb.GeneratedMessage {
  factory ProjectMetadata({
    $core.double? targetCapacityMw,
    $core.String? locationName,
    $core.String? clientName,
    $core.String? notes,
  }) {
    final $result = create();
    if (targetCapacityMw != null) {
      $result.targetCapacityMw = targetCapacityMw;
    }
    if (locationName != null) {
      $result.locationName = locationName;
    }
    if (clientName != null) {
      $result.clientName = clientName;
    }
    if (notes != null) {
      $result.notes = notes;
    }
    return $result;
  }
  ProjectMetadata._() : super();
  factory ProjectMetadata.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProjectMetadata.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ProjectMetadata', package: const $pb.PackageName(_omitMessageNames ? '' : 'project.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'targetCapacityMw', $pb.PbFieldType.OD)
    ..aOS(2, _omitFieldNames ? '' : 'locationName')
    ..aOS(3, _omitFieldNames ? '' : 'clientName')
    ..aOS(4, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProjectMetadata clone() => ProjectMetadata()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProjectMetadata copyWith(void Function(ProjectMetadata) updates) => super.copyWith((message) => updates(message as ProjectMetadata)) as ProjectMetadata;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProjectMetadata create() => ProjectMetadata._();
  ProjectMetadata createEmptyInstance() => create();
  static $pb.PbList<ProjectMetadata> createRepeated() => $pb.PbList<ProjectMetadata>();
  @$core.pragma('dart2js:noInline')
  static ProjectMetadata getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProjectMetadata>(create);
  static ProjectMetadata? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get targetCapacityMw => $_getN(0);
  @$pb.TagNumber(1)
  set targetCapacityMw($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTargetCapacityMw() => $_has(0);
  @$pb.TagNumber(1)
  void clearTargetCapacityMw() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get locationName => $_getSZ(1);
  @$pb.TagNumber(2)
  set locationName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLocationName() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocationName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get clientName => $_getSZ(2);
  @$pb.TagNumber(3)
  set clientName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasClientName() => $_has(2);
  @$pb.TagNumber(3)
  void clearClientName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get notes => $_getSZ(3);
  @$pb.TagNumber(4)
  set notes($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasNotes() => $_has(3);
  @$pb.TagNumber(4)
  void clearNotes() => $_clearField(4);
}

class CreateProjectRequest extends $pb.GeneratedMessage {
  factory CreateProjectRequest({
    $core.String? name,
    $core.String? description,
    ProjectMetadata? metadata,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (description != null) {
      $result.description = description;
    }
    if (metadata != null) {
      $result.metadata = metadata;
    }
    return $result;
  }
  CreateProjectRequest._() : super();
  factory CreateProjectRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateProjectRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateProjectRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'project.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..aOM<ProjectMetadata>(3, _omitFieldNames ? '' : 'metadata', subBuilder: ProjectMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateProjectRequest clone() => CreateProjectRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateProjectRequest copyWith(void Function(CreateProjectRequest) updates) => super.copyWith((message) => updates(message as CreateProjectRequest)) as CreateProjectRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateProjectRequest create() => CreateProjectRequest._();
  CreateProjectRequest createEmptyInstance() => create();
  static $pb.PbList<CreateProjectRequest> createRepeated() => $pb.PbList<CreateProjectRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateProjectRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateProjectRequest>(create);
  static CreateProjectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);

  @$pb.TagNumber(3)
  ProjectMetadata get metadata => $_getN(2);
  @$pb.TagNumber(3)
  set metadata(ProjectMetadata v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasMetadata() => $_has(2);
  @$pb.TagNumber(3)
  void clearMetadata() => $_clearField(3);
  @$pb.TagNumber(3)
  ProjectMetadata ensureMetadata() => $_ensure(2);
}

class CreateProjectResponse extends $pb.GeneratedMessage {
  factory CreateProjectResponse({
    Project? project,
  }) {
    final $result = create();
    if (project != null) {
      $result.project = project;
    }
    return $result;
  }
  CreateProjectResponse._() : super();
  factory CreateProjectResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateProjectResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateProjectResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'project.v1'), createEmptyInstance: create)
    ..aOM<Project>(1, _omitFieldNames ? '' : 'project', subBuilder: Project.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateProjectResponse clone() => CreateProjectResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateProjectResponse copyWith(void Function(CreateProjectResponse) updates) => super.copyWith((message) => updates(message as CreateProjectResponse)) as CreateProjectResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateProjectResponse create() => CreateProjectResponse._();
  CreateProjectResponse createEmptyInstance() => create();
  static $pb.PbList<CreateProjectResponse> createRepeated() => $pb.PbList<CreateProjectResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateProjectResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateProjectResponse>(create);
  static CreateProjectResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Project get project => $_getN(0);
  @$pb.TagNumber(1)
  set project(Project v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasProject() => $_has(0);
  @$pb.TagNumber(1)
  void clearProject() => $_clearField(1);
  @$pb.TagNumber(1)
  Project ensureProject() => $_ensure(0);
}

class GetProjectRequest extends $pb.GeneratedMessage {
  factory GetProjectRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  GetProjectRequest._() : super();
  factory GetProjectRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetProjectRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetProjectRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'project.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetProjectRequest clone() => GetProjectRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetProjectRequest copyWith(void Function(GetProjectRequest) updates) => super.copyWith((message) => updates(message as GetProjectRequest)) as GetProjectRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetProjectRequest create() => GetProjectRequest._();
  GetProjectRequest createEmptyInstance() => create();
  static $pb.PbList<GetProjectRequest> createRepeated() => $pb.PbList<GetProjectRequest>();
  @$core.pragma('dart2js:noInline')
  static GetProjectRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetProjectRequest>(create);
  static GetProjectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class GetProjectResponse extends $pb.GeneratedMessage {
  factory GetProjectResponse({
    Project? project,
  }) {
    final $result = create();
    if (project != null) {
      $result.project = project;
    }
    return $result;
  }
  GetProjectResponse._() : super();
  factory GetProjectResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetProjectResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetProjectResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'project.v1'), createEmptyInstance: create)
    ..aOM<Project>(1, _omitFieldNames ? '' : 'project', subBuilder: Project.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetProjectResponse clone() => GetProjectResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetProjectResponse copyWith(void Function(GetProjectResponse) updates) => super.copyWith((message) => updates(message as GetProjectResponse)) as GetProjectResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetProjectResponse create() => GetProjectResponse._();
  GetProjectResponse createEmptyInstance() => create();
  static $pb.PbList<GetProjectResponse> createRepeated() => $pb.PbList<GetProjectResponse>();
  @$core.pragma('dart2js:noInline')
  static GetProjectResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetProjectResponse>(create);
  static GetProjectResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Project get project => $_getN(0);
  @$pb.TagNumber(1)
  set project(Project v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasProject() => $_has(0);
  @$pb.TagNumber(1)
  void clearProject() => $_clearField(1);
  @$pb.TagNumber(1)
  Project ensureProject() => $_ensure(0);
}

class ListProjectsRequest extends $pb.GeneratedMessage {
  factory ListProjectsRequest({
    ProjectStatus? statusFilter,
    $1.PaginationRequest? pagination,
  }) {
    final $result = create();
    if (statusFilter != null) {
      $result.statusFilter = statusFilter;
    }
    if (pagination != null) {
      $result.pagination = pagination;
    }
    return $result;
  }
  ListProjectsRequest._() : super();
  factory ListProjectsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListProjectsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListProjectsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'project.v1'), createEmptyInstance: create)
    ..e<ProjectStatus>(1, _omitFieldNames ? '' : 'statusFilter', $pb.PbFieldType.OE, defaultOrMaker: ProjectStatus.PROJECT_STATUS_UNSPECIFIED, valueOf: ProjectStatus.valueOf, enumValues: ProjectStatus.values)
    ..aOM<$1.PaginationRequest>(2, _omitFieldNames ? '' : 'pagination', subBuilder: $1.PaginationRequest.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListProjectsRequest clone() => ListProjectsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListProjectsRequest copyWith(void Function(ListProjectsRequest) updates) => super.copyWith((message) => updates(message as ListProjectsRequest)) as ListProjectsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListProjectsRequest create() => ListProjectsRequest._();
  ListProjectsRequest createEmptyInstance() => create();
  static $pb.PbList<ListProjectsRequest> createRepeated() => $pb.PbList<ListProjectsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListProjectsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListProjectsRequest>(create);
  static ListProjectsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  ProjectStatus get statusFilter => $_getN(0);
  @$pb.TagNumber(1)
  set statusFilter(ProjectStatus v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatusFilter() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatusFilter() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.PaginationRequest get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.PaginationRequest v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginationRequest ensurePagination() => $_ensure(1);
}

class ListProjectsResponse extends $pb.GeneratedMessage {
  factory ListProjectsResponse({
    $core.Iterable<Project>? projects,
    $1.PaginationResponse? pagination,
  }) {
    final $result = create();
    if (projects != null) {
      $result.projects.addAll(projects);
    }
    if (pagination != null) {
      $result.pagination = pagination;
    }
    return $result;
  }
  ListProjectsResponse._() : super();
  factory ListProjectsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListProjectsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListProjectsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'project.v1'), createEmptyInstance: create)
    ..pc<Project>(1, _omitFieldNames ? '' : 'projects', $pb.PbFieldType.PM, subBuilder: Project.create)
    ..aOM<$1.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination', subBuilder: $1.PaginationResponse.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListProjectsResponse clone() => ListProjectsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListProjectsResponse copyWith(void Function(ListProjectsResponse) updates) => super.copyWith((message) => updates(message as ListProjectsResponse)) as ListProjectsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListProjectsResponse create() => ListProjectsResponse._();
  ListProjectsResponse createEmptyInstance() => create();
  static $pb.PbList<ListProjectsResponse> createRepeated() => $pb.PbList<ListProjectsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListProjectsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListProjectsResponse>(create);
  static ListProjectsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Project> get projects => $_getList(0);

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

class UpdateProjectRequest extends $pb.GeneratedMessage {
  factory UpdateProjectRequest({
    $core.String? id,
    $core.String? name,
    $core.String? description,
    ProjectStatus? status,
    ProjectMetadata? metadata,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    if (description != null) {
      $result.description = description;
    }
    if (status != null) {
      $result.status = status;
    }
    if (metadata != null) {
      $result.metadata = metadata;
    }
    return $result;
  }
  UpdateProjectRequest._() : super();
  factory UpdateProjectRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateProjectRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateProjectRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'project.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..e<ProjectStatus>(4, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: ProjectStatus.PROJECT_STATUS_UNSPECIFIED, valueOf: ProjectStatus.valueOf, enumValues: ProjectStatus.values)
    ..aOM<ProjectMetadata>(5, _omitFieldNames ? '' : 'metadata', subBuilder: ProjectMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateProjectRequest clone() => UpdateProjectRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateProjectRequest copyWith(void Function(UpdateProjectRequest) updates) => super.copyWith((message) => updates(message as UpdateProjectRequest)) as UpdateProjectRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateProjectRequest create() => UpdateProjectRequest._();
  UpdateProjectRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateProjectRequest> createRepeated() => $pb.PbList<UpdateProjectRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateProjectRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateProjectRequest>(create);
  static UpdateProjectRequest? _defaultInstance;

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
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  ProjectStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status(ProjectStatus v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  ProjectMetadata get metadata => $_getN(4);
  @$pb.TagNumber(5)
  set metadata(ProjectMetadata v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasMetadata() => $_has(4);
  @$pb.TagNumber(5)
  void clearMetadata() => $_clearField(5);
  @$pb.TagNumber(5)
  ProjectMetadata ensureMetadata() => $_ensure(4);
}

class UpdateProjectResponse extends $pb.GeneratedMessage {
  factory UpdateProjectResponse({
    Project? project,
  }) {
    final $result = create();
    if (project != null) {
      $result.project = project;
    }
    return $result;
  }
  UpdateProjectResponse._() : super();
  factory UpdateProjectResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateProjectResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateProjectResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'project.v1'), createEmptyInstance: create)
    ..aOM<Project>(1, _omitFieldNames ? '' : 'project', subBuilder: Project.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateProjectResponse clone() => UpdateProjectResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateProjectResponse copyWith(void Function(UpdateProjectResponse) updates) => super.copyWith((message) => updates(message as UpdateProjectResponse)) as UpdateProjectResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateProjectResponse create() => UpdateProjectResponse._();
  UpdateProjectResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateProjectResponse> createRepeated() => $pb.PbList<UpdateProjectResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateProjectResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateProjectResponse>(create);
  static UpdateProjectResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Project get project => $_getN(0);
  @$pb.TagNumber(1)
  set project(Project v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasProject() => $_has(0);
  @$pb.TagNumber(1)
  void clearProject() => $_clearField(1);
  @$pb.TagNumber(1)
  Project ensureProject() => $_ensure(0);
}

class DeleteProjectRequest extends $pb.GeneratedMessage {
  factory DeleteProjectRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  DeleteProjectRequest._() : super();
  factory DeleteProjectRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteProjectRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteProjectRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'project.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteProjectRequest clone() => DeleteProjectRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteProjectRequest copyWith(void Function(DeleteProjectRequest) updates) => super.copyWith((message) => updates(message as DeleteProjectRequest)) as DeleteProjectRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteProjectRequest create() => DeleteProjectRequest._();
  DeleteProjectRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteProjectRequest> createRepeated() => $pb.PbList<DeleteProjectRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteProjectRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteProjectRequest>(create);
  static DeleteProjectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class DeleteProjectResponse extends $pb.GeneratedMessage {
  factory DeleteProjectResponse() => create();
  DeleteProjectResponse._() : super();
  factory DeleteProjectResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteProjectResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteProjectResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'project.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteProjectResponse clone() => DeleteProjectResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteProjectResponse copyWith(void Function(DeleteProjectResponse) updates) => super.copyWith((message) => updates(message as DeleteProjectResponse)) as DeleteProjectResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteProjectResponse create() => DeleteProjectResponse._();
  DeleteProjectResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteProjectResponse> createRepeated() => $pb.PbList<DeleteProjectResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteProjectResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteProjectResponse>(create);
  static DeleteProjectResponse? _defaultInstance;
}

class PhaseTransitionHistoryEntry extends $pb.GeneratedMessage {
  factory PhaseTransitionHistoryEntry({
    $core.String? id,
    $2.WorkflowPhase? fromPhase,
    $2.WorkflowPhase? toPhase,
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
    if (fromPhase != null) {
      $result.fromPhase = fromPhase;
    }
    if (toPhase != null) {
      $result.toPhase = toPhase;
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
  PhaseTransitionHistoryEntry._() : super();
  factory PhaseTransitionHistoryEntry.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PhaseTransitionHistoryEntry.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PhaseTransitionHistoryEntry', package: const $pb.PackageName(_omitMessageNames ? '' : 'project.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..e<$2.WorkflowPhase>(2, _omitFieldNames ? '' : 'fromPhase', $pb.PbFieldType.OE, defaultOrMaker: $2.WorkflowPhase.WORKFLOW_PHASE_UNSPECIFIED, valueOf: $2.WorkflowPhase.valueOf, enumValues: $2.WorkflowPhase.values)
    ..e<$2.WorkflowPhase>(3, _omitFieldNames ? '' : 'toPhase', $pb.PbFieldType.OE, defaultOrMaker: $2.WorkflowPhase.WORKFLOW_PHASE_UNSPECIFIED, valueOf: $2.WorkflowPhase.valueOf, enumValues: $2.WorkflowPhase.values)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'occurredAt', subBuilder: $0.Timestamp.create)
    ..aOS(5, _omitFieldNames ? '' : 'actorId')
    ..aOS(6, _omitFieldNames ? '' : 'reason')
    ..aOB(7, _omitFieldNames ? '' : 'isRollback')
    ..aOS(8, _omitFieldNames ? '' : 'rollbackReason')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PhaseTransitionHistoryEntry clone() => PhaseTransitionHistoryEntry()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PhaseTransitionHistoryEntry copyWith(void Function(PhaseTransitionHistoryEntry) updates) => super.copyWith((message) => updates(message as PhaseTransitionHistoryEntry)) as PhaseTransitionHistoryEntry;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PhaseTransitionHistoryEntry create() => PhaseTransitionHistoryEntry._();
  PhaseTransitionHistoryEntry createEmptyInstance() => create();
  static $pb.PbList<PhaseTransitionHistoryEntry> createRepeated() => $pb.PbList<PhaseTransitionHistoryEntry>();
  @$core.pragma('dart2js:noInline')
  static PhaseTransitionHistoryEntry getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PhaseTransitionHistoryEntry>(create);
  static PhaseTransitionHistoryEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.WorkflowPhase get fromPhase => $_getN(1);
  @$pb.TagNumber(2)
  set fromPhase($2.WorkflowPhase v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasFromPhase() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromPhase() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.WorkflowPhase get toPhase => $_getN(2);
  @$pb.TagNumber(3)
  set toPhase($2.WorkflowPhase v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasToPhase() => $_has(2);
  @$pb.TagNumber(3)
  void clearToPhase() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get occurredAt => $_getN(3);
  @$pb.TagNumber(4)
  set occurredAt($0.Timestamp v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasOccurredAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearOccurredAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureOccurredAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get actorId => $_getSZ(4);
  @$pb.TagNumber(5)
  set actorId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasActorId() => $_has(4);
  @$pb.TagNumber(5)
  void clearActorId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get reason => $_getSZ(5);
  @$pb.TagNumber(6)
  set reason($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearReason() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isRollback => $_getBF(6);
  @$pb.TagNumber(7)
  set isRollback($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasIsRollback() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsRollback() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get rollbackReason => $_getSZ(7);
  @$pb.TagNumber(8)
  set rollbackReason($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasRollbackReason() => $_has(7);
  @$pb.TagNumber(8)
  void clearRollbackReason() => $_clearField(8);
}

class TransitionPhaseRequest extends $pb.GeneratedMessage {
  factory TransitionPhaseRequest({
    $core.String? projectId,
    $2.WorkflowPhase? targetPhase,
    $2.TransitionEvidence? evidence,
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

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TransitionPhaseRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'project.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..e<$2.WorkflowPhase>(2, _omitFieldNames ? '' : 'targetPhase', $pb.PbFieldType.OE, defaultOrMaker: $2.WorkflowPhase.WORKFLOW_PHASE_UNSPECIFIED, valueOf: $2.WorkflowPhase.valueOf, enumValues: $2.WorkflowPhase.values)
    ..aOM<$2.TransitionEvidence>(3, _omitFieldNames ? '' : 'evidence', subBuilder: $2.TransitionEvidence.create)
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
  $2.WorkflowPhase get targetPhase => $_getN(1);
  @$pb.TagNumber(2)
  set targetPhase($2.WorkflowPhase v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasTargetPhase() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetPhase() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.TransitionEvidence get evidence => $_getN(2);
  @$pb.TagNumber(3)
  set evidence($2.TransitionEvidence v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasEvidence() => $_has(2);
  @$pb.TagNumber(3)
  void clearEvidence() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.TransitionEvidence ensureEvidence() => $_ensure(2);

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
    $2.WorkflowPhase? previousPhase,
    $2.WorkflowPhase? currentPhase,
    PhaseTransitionHistoryEntry? transitionRecord,
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

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TransitionPhaseResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'project.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..e<$2.WorkflowPhase>(2, _omitFieldNames ? '' : 'previousPhase', $pb.PbFieldType.OE, defaultOrMaker: $2.WorkflowPhase.WORKFLOW_PHASE_UNSPECIFIED, valueOf: $2.WorkflowPhase.valueOf, enumValues: $2.WorkflowPhase.values)
    ..e<$2.WorkflowPhase>(3, _omitFieldNames ? '' : 'currentPhase', $pb.PbFieldType.OE, defaultOrMaker: $2.WorkflowPhase.WORKFLOW_PHASE_UNSPECIFIED, valueOf: $2.WorkflowPhase.valueOf, enumValues: $2.WorkflowPhase.values)
    ..aOM<PhaseTransitionHistoryEntry>(4, _omitFieldNames ? '' : 'transitionRecord', subBuilder: PhaseTransitionHistoryEntry.create)
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
  $2.WorkflowPhase get previousPhase => $_getN(1);
  @$pb.TagNumber(2)
  set previousPhase($2.WorkflowPhase v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPreviousPhase() => $_has(1);
  @$pb.TagNumber(2)
  void clearPreviousPhase() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.WorkflowPhase get currentPhase => $_getN(2);
  @$pb.TagNumber(3)
  set currentPhase($2.WorkflowPhase v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCurrentPhase() => $_has(2);
  @$pb.TagNumber(3)
  void clearCurrentPhase() => $_clearField(3);

  @$pb.TagNumber(4)
  PhaseTransitionHistoryEntry get transitionRecord => $_getN(3);
  @$pb.TagNumber(4)
  set transitionRecord(PhaseTransitionHistoryEntry v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasTransitionRecord() => $_has(3);
  @$pb.TagNumber(4)
  void clearTransitionRecord() => $_clearField(4);
  @$pb.TagNumber(4)
  PhaseTransitionHistoryEntry ensureTransitionRecord() => $_ensure(3);

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

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetPhaseStateRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'project.v1'), createEmptyInstance: create)
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
    $2.WorkflowPhase? currentPhase,
    $0.Timestamp? phaseEnteredAt,
    PhaseTransitionHistoryEntry? lastTransition,
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

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetPhaseStateResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'project.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..e<$2.WorkflowPhase>(2, _omitFieldNames ? '' : 'currentPhase', $pb.PbFieldType.OE, defaultOrMaker: $2.WorkflowPhase.WORKFLOW_PHASE_UNSPECIFIED, valueOf: $2.WorkflowPhase.valueOf, enumValues: $2.WorkflowPhase.values)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'phaseEnteredAt', subBuilder: $0.Timestamp.create)
    ..aOM<PhaseTransitionHistoryEntry>(4, _omitFieldNames ? '' : 'lastTransition', subBuilder: PhaseTransitionHistoryEntry.create)
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
  $2.WorkflowPhase get currentPhase => $_getN(1);
  @$pb.TagNumber(2)
  set currentPhase($2.WorkflowPhase v) { $_setField(2, v); }
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
  PhaseTransitionHistoryEntry get lastTransition => $_getN(3);
  @$pb.TagNumber(4)
  set lastTransition(PhaseTransitionHistoryEntry v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasLastTransition() => $_has(3);
  @$pb.TagNumber(4)
  void clearLastTransition() => $_clearField(4);
  @$pb.TagNumber(4)
  PhaseTransitionHistoryEntry ensureLastTransition() => $_ensure(3);
}

class ListPhaseTransitionsRequest extends $pb.GeneratedMessage {
  factory ListPhaseTransitionsRequest({
    $core.String? projectId,
    $1.PaginationRequest? pagination,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (pagination != null) {
      $result.pagination = pagination;
    }
    return $result;
  }
  ListPhaseTransitionsRequest._() : super();
  factory ListPhaseTransitionsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListPhaseTransitionsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListPhaseTransitionsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'project.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOM<$1.PaginationRequest>(2, _omitFieldNames ? '' : 'pagination', subBuilder: $1.PaginationRequest.create)
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
  $1.PaginationRequest get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.PaginationRequest v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginationRequest ensurePagination() => $_ensure(1);
}

class ListPhaseTransitionsResponse extends $pb.GeneratedMessage {
  factory ListPhaseTransitionsResponse({
    $core.Iterable<PhaseTransitionHistoryEntry>? transitions,
    $1.PaginationResponse? pagination,
  }) {
    final $result = create();
    if (transitions != null) {
      $result.transitions.addAll(transitions);
    }
    if (pagination != null) {
      $result.pagination = pagination;
    }
    return $result;
  }
  ListPhaseTransitionsResponse._() : super();
  factory ListPhaseTransitionsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListPhaseTransitionsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListPhaseTransitionsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'project.v1'), createEmptyInstance: create)
    ..pc<PhaseTransitionHistoryEntry>(1, _omitFieldNames ? '' : 'transitions', $pb.PbFieldType.PM, subBuilder: PhaseTransitionHistoryEntry.create)
    ..aOM<$1.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination', subBuilder: $1.PaginationResponse.create)
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
  $pb.PbList<PhaseTransitionHistoryEntry> get transitions => $_getList(0);

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

class ValidatePhaseReadinessRequest extends $pb.GeneratedMessage {
  factory ValidatePhaseReadinessRequest({
    $core.String? projectId,
    $2.WorkflowPhase? targetPhase,
    $2.TransitionEvidence? evidence,
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

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ValidatePhaseReadinessRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'project.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..e<$2.WorkflowPhase>(2, _omitFieldNames ? '' : 'targetPhase', $pb.PbFieldType.OE, defaultOrMaker: $2.WorkflowPhase.WORKFLOW_PHASE_UNSPECIFIED, valueOf: $2.WorkflowPhase.valueOf, enumValues: $2.WorkflowPhase.values)
    ..aOM<$2.TransitionEvidence>(3, _omitFieldNames ? '' : 'evidence', subBuilder: $2.TransitionEvidence.create)
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
  $2.WorkflowPhase get targetPhase => $_getN(1);
  @$pb.TagNumber(2)
  set targetPhase($2.WorkflowPhase v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasTargetPhase() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetPhase() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.TransitionEvidence get evidence => $_getN(2);
  @$pb.TagNumber(3)
  set evidence($2.TransitionEvidence v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasEvidence() => $_has(2);
  @$pb.TagNumber(3)
  void clearEvidence() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.TransitionEvidence ensureEvidence() => $_ensure(2);
}

class ValidatePhaseReadinessResponse extends $pb.GeneratedMessage {
  factory ValidatePhaseReadinessResponse({
    $core.String? projectId,
    $2.WorkflowPhase? currentPhase,
    $2.WorkflowPhase? targetPhase,
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

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ValidatePhaseReadinessResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'project.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..e<$2.WorkflowPhase>(2, _omitFieldNames ? '' : 'currentPhase', $pb.PbFieldType.OE, defaultOrMaker: $2.WorkflowPhase.WORKFLOW_PHASE_UNSPECIFIED, valueOf: $2.WorkflowPhase.valueOf, enumValues: $2.WorkflowPhase.values)
    ..e<$2.WorkflowPhase>(3, _omitFieldNames ? '' : 'targetPhase', $pb.PbFieldType.OE, defaultOrMaker: $2.WorkflowPhase.WORKFLOW_PHASE_UNSPECIFIED, valueOf: $2.WorkflowPhase.valueOf, enumValues: $2.WorkflowPhase.values)
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
  $2.WorkflowPhase get currentPhase => $_getN(1);
  @$pb.TagNumber(2)
  set currentPhase($2.WorkflowPhase v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCurrentPhase() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrentPhase() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.WorkflowPhase get targetPhase => $_getN(2);
  @$pb.TagNumber(3)
  set targetPhase($2.WorkflowPhase v) { $_setField(3, v); }
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

class ProjectServiceApi {
  $pb.RpcClient _client;
  ProjectServiceApi(this._client);

  $async.Future<CreateProjectResponse> createProject($pb.ClientContext? ctx, CreateProjectRequest request) =>
    _client.invoke<CreateProjectResponse>(ctx, 'ProjectService', 'CreateProject', request, CreateProjectResponse())
  ;
  $async.Future<GetProjectResponse> getProject($pb.ClientContext? ctx, GetProjectRequest request) =>
    _client.invoke<GetProjectResponse>(ctx, 'ProjectService', 'GetProject', request, GetProjectResponse())
  ;
  $async.Future<ListProjectsResponse> listProjects($pb.ClientContext? ctx, ListProjectsRequest request) =>
    _client.invoke<ListProjectsResponse>(ctx, 'ProjectService', 'ListProjects', request, ListProjectsResponse())
  ;
  $async.Future<UpdateProjectResponse> updateProject($pb.ClientContext? ctx, UpdateProjectRequest request) =>
    _client.invoke<UpdateProjectResponse>(ctx, 'ProjectService', 'UpdateProject', request, UpdateProjectResponse())
  ;
  $async.Future<DeleteProjectResponse> deleteProject($pb.ClientContext? ctx, DeleteProjectRequest request) =>
    _client.invoke<DeleteProjectResponse>(ctx, 'ProjectService', 'DeleteProject', request, DeleteProjectResponse())
  ;
  $async.Future<TransitionPhaseResponse> transitionPhase($pb.ClientContext? ctx, TransitionPhaseRequest request) =>
    _client.invoke<TransitionPhaseResponse>(ctx, 'ProjectService', 'TransitionPhase', request, TransitionPhaseResponse())
  ;
  $async.Future<GetPhaseStateResponse> getPhaseState($pb.ClientContext? ctx, GetPhaseStateRequest request) =>
    _client.invoke<GetPhaseStateResponse>(ctx, 'ProjectService', 'GetPhaseState', request, GetPhaseStateResponse())
  ;
  $async.Future<ListPhaseTransitionsResponse> listPhaseTransitions($pb.ClientContext? ctx, ListPhaseTransitionsRequest request) =>
    _client.invoke<ListPhaseTransitionsResponse>(ctx, 'ProjectService', 'ListPhaseTransitions', request, ListPhaseTransitionsResponse())
  ;
  $async.Future<ValidatePhaseReadinessResponse> validatePhaseReadiness($pb.ClientContext? ctx, ValidatePhaseReadinessRequest request) =>
    _client.invoke<ValidatePhaseReadinessResponse>(ctx, 'ProjectService', 'ValidatePhaseReadiness', request, ValidatePhaseReadinessResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
