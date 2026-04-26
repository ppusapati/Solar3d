//
//  Generated code. Do not modify.
//  source: commissioning/v1/commissioning.proto
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

import '../../google/protobuf/timestamp.pb.dart' as $0;
import '../../packages/pagination.pb.dart' as $1;
import 'commissioning.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'commissioning.pbenum.dart';

class CommissioningChecklist extends $pb.GeneratedMessage {
  factory CommissioningChecklist({
    $core.String? id,
    $core.String? projectId,
    $core.String? name,
    CommissioningStatus? status,
    $core.Iterable<ChecklistItem>? items,
    $core.Iterable<CommissioningSignoff>? signoffs,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
    $core.String? createdBy,
    $core.int? totalItems,
    $core.int? completedItems,
    $core.int? failedItems,
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
    if (status != null) {
      $result.status = status;
    }
    if (items != null) {
      $result.items.addAll(items);
    }
    if (signoffs != null) {
      $result.signoffs.addAll(signoffs);
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      $result.updatedAt = updatedAt;
    }
    if (createdBy != null) {
      $result.createdBy = createdBy;
    }
    if (totalItems != null) {
      $result.totalItems = totalItems;
    }
    if (completedItems != null) {
      $result.completedItems = completedItems;
    }
    if (failedItems != null) {
      $result.failedItems = failedItems;
    }
    return $result;
  }
  CommissioningChecklist._() : super();
  factory CommissioningChecklist.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CommissioningChecklist.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CommissioningChecklist', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..e<CommissioningStatus>(4, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: CommissioningStatus.COMMISSIONING_STATUS_UNSPECIFIED, valueOf: CommissioningStatus.valueOf, enumValues: CommissioningStatus.values)
    ..pc<ChecklistItem>(5, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM, subBuilder: ChecklistItem.create)
    ..pc<CommissioningSignoff>(6, _omitFieldNames ? '' : 'signoffs', $pb.PbFieldType.PM, subBuilder: CommissioningSignoff.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'updatedAt', subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'createdBy')
    ..a<$core.int>(10, _omitFieldNames ? '' : 'totalItems', $pb.PbFieldType.O3)
    ..a<$core.int>(11, _omitFieldNames ? '' : 'completedItems', $pb.PbFieldType.O3)
    ..a<$core.int>(12, _omitFieldNames ? '' : 'failedItems', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CommissioningChecklist clone() => CommissioningChecklist()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CommissioningChecklist copyWith(void Function(CommissioningChecklist) updates) => super.copyWith((message) => updates(message as CommissioningChecklist)) as CommissioningChecklist;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommissioningChecklist create() => CommissioningChecklist._();
  CommissioningChecklist createEmptyInstance() => create();
  static $pb.PbList<CommissioningChecklist> createRepeated() => $pb.PbList<CommissioningChecklist>();
  @$core.pragma('dart2js:noInline')
  static CommissioningChecklist getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CommissioningChecklist>(create);
  static CommissioningChecklist? _defaultInstance;

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
  CommissioningStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status(CommissioningStatus v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<ChecklistItem> get items => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<CommissioningSignoff> get signoffs => $_getList(5);

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
  $core.String get createdBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set createdBy($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasCreatedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedBy() => $_clearField(9);

  /// Derived counts (read-only)
  @$pb.TagNumber(10)
  $core.int get totalItems => $_getIZ(9);
  @$pb.TagNumber(10)
  set totalItems($core.int v) { $_setSignedInt32(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasTotalItems() => $_has(9);
  @$pb.TagNumber(10)
  void clearTotalItems() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get completedItems => $_getIZ(10);
  @$pb.TagNumber(11)
  set completedItems($core.int v) { $_setSignedInt32(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasCompletedItems() => $_has(10);
  @$pb.TagNumber(11)
  void clearCompletedItems() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get failedItems => $_getIZ(11);
  @$pb.TagNumber(12)
  set failedItems($core.int v) { $_setSignedInt32(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasFailedItems() => $_has(11);
  @$pb.TagNumber(12)
  void clearFailedItems() => $_clearField(12);
}

class ChecklistItem extends $pb.GeneratedMessage {
  factory ChecklistItem({
    $core.String? id,
    $core.String? checklistId,
    $core.String? description,
    ChecklistSection? section,
    ChecklistItemStatus? status,
    $core.bool? required,
    $core.String? completedBy,
    $0.Timestamp? completedAt,
    $core.String? notes,
    $core.int? sequence,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (checklistId != null) {
      $result.checklistId = checklistId;
    }
    if (description != null) {
      $result.description = description;
    }
    if (section != null) {
      $result.section = section;
    }
    if (status != null) {
      $result.status = status;
    }
    if (required != null) {
      $result.required = required;
    }
    if (completedBy != null) {
      $result.completedBy = completedBy;
    }
    if (completedAt != null) {
      $result.completedAt = completedAt;
    }
    if (notes != null) {
      $result.notes = notes;
    }
    if (sequence != null) {
      $result.sequence = sequence;
    }
    return $result;
  }
  ChecklistItem._() : super();
  factory ChecklistItem.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChecklistItem.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChecklistItem', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'checklistId')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..e<ChecklistSection>(4, _omitFieldNames ? '' : 'section', $pb.PbFieldType.OE, defaultOrMaker: ChecklistSection.CHECKLIST_SECTION_UNSPECIFIED, valueOf: ChecklistSection.valueOf, enumValues: ChecklistSection.values)
    ..e<ChecklistItemStatus>(5, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: ChecklistItemStatus.CHECKLIST_ITEM_STATUS_UNSPECIFIED, valueOf: ChecklistItemStatus.valueOf, enumValues: ChecklistItemStatus.values)
    ..aOB(6, _omitFieldNames ? '' : 'required')
    ..aOS(7, _omitFieldNames ? '' : 'completedBy')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'completedAt', subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'notes')
    ..a<$core.int>(10, _omitFieldNames ? '' : 'sequence', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChecklistItem clone() => ChecklistItem()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChecklistItem copyWith(void Function(ChecklistItem) updates) => super.copyWith((message) => updates(message as ChecklistItem)) as ChecklistItem;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChecklistItem create() => ChecklistItem._();
  ChecklistItem createEmptyInstance() => create();
  static $pb.PbList<ChecklistItem> createRepeated() => $pb.PbList<ChecklistItem>();
  @$core.pragma('dart2js:noInline')
  static ChecklistItem getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChecklistItem>(create);
  static ChecklistItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get checklistId => $_getSZ(1);
  @$pb.TagNumber(2)
  set checklistId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasChecklistId() => $_has(1);
  @$pb.TagNumber(2)
  void clearChecklistId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  ChecklistSection get section => $_getN(3);
  @$pb.TagNumber(4)
  set section(ChecklistSection v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasSection() => $_has(3);
  @$pb.TagNumber(4)
  void clearSection() => $_clearField(4);

  @$pb.TagNumber(5)
  ChecklistItemStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status(ChecklistItemStatus v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get required => $_getBF(5);
  @$pb.TagNumber(6)
  set required($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasRequired() => $_has(5);
  @$pb.TagNumber(6)
  void clearRequired() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get completedBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set completedBy($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasCompletedBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearCompletedBy() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get completedAt => $_getN(7);
  @$pb.TagNumber(8)
  set completedAt($0.Timestamp v) { $_setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasCompletedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCompletedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureCompletedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get notes => $_getSZ(8);
  @$pb.TagNumber(9)
  set notes($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasNotes() => $_has(8);
  @$pb.TagNumber(9)
  void clearNotes() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get sequence => $_getIZ(9);
  @$pb.TagNumber(10)
  set sequence($core.int v) { $_setSignedInt32(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasSequence() => $_has(9);
  @$pb.TagNumber(10)
  void clearSequence() => $_clearField(10);
}

class CommissioningSignoff extends $pb.GeneratedMessage {
  factory CommissioningSignoff({
    $core.String? id,
    $core.String? checklistId,
    $core.String? signedBy,
    $core.String? role,
    $core.String? comments,
    $0.Timestamp? signedAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (checklistId != null) {
      $result.checklistId = checklistId;
    }
    if (signedBy != null) {
      $result.signedBy = signedBy;
    }
    if (role != null) {
      $result.role = role;
    }
    if (comments != null) {
      $result.comments = comments;
    }
    if (signedAt != null) {
      $result.signedAt = signedAt;
    }
    return $result;
  }
  CommissioningSignoff._() : super();
  factory CommissioningSignoff.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CommissioningSignoff.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CommissioningSignoff', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'checklistId')
    ..aOS(3, _omitFieldNames ? '' : 'signedBy')
    ..aOS(4, _omitFieldNames ? '' : 'role')
    ..aOS(5, _omitFieldNames ? '' : 'comments')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'signedAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CommissioningSignoff clone() => CommissioningSignoff()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CommissioningSignoff copyWith(void Function(CommissioningSignoff) updates) => super.copyWith((message) => updates(message as CommissioningSignoff)) as CommissioningSignoff;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommissioningSignoff create() => CommissioningSignoff._();
  CommissioningSignoff createEmptyInstance() => create();
  static $pb.PbList<CommissioningSignoff> createRepeated() => $pb.PbList<CommissioningSignoff>();
  @$core.pragma('dart2js:noInline')
  static CommissioningSignoff getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CommissioningSignoff>(create);
  static CommissioningSignoff? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get checklistId => $_getSZ(1);
  @$pb.TagNumber(2)
  set checklistId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasChecklistId() => $_has(1);
  @$pb.TagNumber(2)
  void clearChecklistId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get signedBy => $_getSZ(2);
  @$pb.TagNumber(3)
  set signedBy($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSignedBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearSignedBy() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get role => $_getSZ(3);
  @$pb.TagNumber(4)
  set role($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRole() => $_has(3);
  @$pb.TagNumber(4)
  void clearRole() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get comments => $_getSZ(4);
  @$pb.TagNumber(5)
  set comments($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasComments() => $_has(4);
  @$pb.TagNumber(5)
  void clearComments() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get signedAt => $_getN(5);
  @$pb.TagNumber(6)
  set signedAt($0.Timestamp v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasSignedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearSignedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureSignedAt() => $_ensure(5);
}

class HandoverRecord extends $pb.GeneratedMessage {
  factory HandoverRecord({
    $core.String? id,
    $core.String? projectId,
    $core.String? checklistId,
    $core.String? handedOverBy,
    $core.String? receivedBy,
    $core.String? notes,
    $core.Iterable<$core.String>? artifactIds,
    $0.Timestamp? handoverDate,
    $0.Timestamp? createdAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (checklistId != null) {
      $result.checklistId = checklistId;
    }
    if (handedOverBy != null) {
      $result.handedOverBy = handedOverBy;
    }
    if (receivedBy != null) {
      $result.receivedBy = receivedBy;
    }
    if (notes != null) {
      $result.notes = notes;
    }
    if (artifactIds != null) {
      $result.artifactIds.addAll(artifactIds);
    }
    if (handoverDate != null) {
      $result.handoverDate = handoverDate;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    return $result;
  }
  HandoverRecord._() : super();
  factory HandoverRecord.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HandoverRecord.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HandoverRecord', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..aOS(3, _omitFieldNames ? '' : 'checklistId')
    ..aOS(4, _omitFieldNames ? '' : 'handedOverBy')
    ..aOS(5, _omitFieldNames ? '' : 'receivedBy')
    ..aOS(6, _omitFieldNames ? '' : 'notes')
    ..pPS(7, _omitFieldNames ? '' : 'artifactIds')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'handoverDate', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HandoverRecord clone() => HandoverRecord()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HandoverRecord copyWith(void Function(HandoverRecord) updates) => super.copyWith((message) => updates(message as HandoverRecord)) as HandoverRecord;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HandoverRecord create() => HandoverRecord._();
  HandoverRecord createEmptyInstance() => create();
  static $pb.PbList<HandoverRecord> createRepeated() => $pb.PbList<HandoverRecord>();
  @$core.pragma('dart2js:noInline')
  static HandoverRecord getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HandoverRecord>(create);
  static HandoverRecord? _defaultInstance;

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
  $core.String get checklistId => $_getSZ(2);
  @$pb.TagNumber(3)
  set checklistId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasChecklistId() => $_has(2);
  @$pb.TagNumber(3)
  void clearChecklistId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get handedOverBy => $_getSZ(3);
  @$pb.TagNumber(4)
  set handedOverBy($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHandedOverBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearHandedOverBy() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get receivedBy => $_getSZ(4);
  @$pb.TagNumber(5)
  set receivedBy($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasReceivedBy() => $_has(4);
  @$pb.TagNumber(5)
  void clearReceivedBy() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get notes => $_getSZ(5);
  @$pb.TagNumber(6)
  set notes($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasNotes() => $_has(5);
  @$pb.TagNumber(6)
  void clearNotes() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get artifactIds => $_getList(6);

  @$pb.TagNumber(8)
  $0.Timestamp get handoverDate => $_getN(7);
  @$pb.TagNumber(8)
  set handoverDate($0.Timestamp v) { $_setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasHandoverDate() => $_has(7);
  @$pb.TagNumber(8)
  void clearHandoverDate() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureHandoverDate() => $_ensure(7);

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

class AsBuiltArtifact extends $pb.GeneratedMessage {
  factory AsBuiltArtifact({
    $core.String? id,
    $core.String? projectId,
    $core.String? name,
    AsBuiltArtifactType? artifactType,
    $core.String? storageUrl,
    $core.String? uploadedBy,
    $0.Timestamp? uploadedAt,
    $core.String? description,
    $fixnum.Int64? fileSizeBytes,
    $core.String? revision,
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
    if (artifactType != null) {
      $result.artifactType = artifactType;
    }
    if (storageUrl != null) {
      $result.storageUrl = storageUrl;
    }
    if (uploadedBy != null) {
      $result.uploadedBy = uploadedBy;
    }
    if (uploadedAt != null) {
      $result.uploadedAt = uploadedAt;
    }
    if (description != null) {
      $result.description = description;
    }
    if (fileSizeBytes != null) {
      $result.fileSizeBytes = fileSizeBytes;
    }
    if (revision != null) {
      $result.revision = revision;
    }
    return $result;
  }
  AsBuiltArtifact._() : super();
  factory AsBuiltArtifact.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AsBuiltArtifact.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AsBuiltArtifact', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..e<AsBuiltArtifactType>(4, _omitFieldNames ? '' : 'artifactType', $pb.PbFieldType.OE, defaultOrMaker: AsBuiltArtifactType.AS_BUILT_ARTIFACT_TYPE_UNSPECIFIED, valueOf: AsBuiltArtifactType.valueOf, enumValues: AsBuiltArtifactType.values)
    ..aOS(5, _omitFieldNames ? '' : 'storageUrl')
    ..aOS(6, _omitFieldNames ? '' : 'uploadedBy')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'uploadedAt', subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'description')
    ..aInt64(9, _omitFieldNames ? '' : 'fileSizeBytes')
    ..aOS(10, _omitFieldNames ? '' : 'revision')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AsBuiltArtifact clone() => AsBuiltArtifact()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AsBuiltArtifact copyWith(void Function(AsBuiltArtifact) updates) => super.copyWith((message) => updates(message as AsBuiltArtifact)) as AsBuiltArtifact;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AsBuiltArtifact create() => AsBuiltArtifact._();
  AsBuiltArtifact createEmptyInstance() => create();
  static $pb.PbList<AsBuiltArtifact> createRepeated() => $pb.PbList<AsBuiltArtifact>();
  @$core.pragma('dart2js:noInline')
  static AsBuiltArtifact getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AsBuiltArtifact>(create);
  static AsBuiltArtifact? _defaultInstance;

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
  AsBuiltArtifactType get artifactType => $_getN(3);
  @$pb.TagNumber(4)
  set artifactType(AsBuiltArtifactType v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasArtifactType() => $_has(3);
  @$pb.TagNumber(4)
  void clearArtifactType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get storageUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set storageUrl($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasStorageUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearStorageUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get uploadedBy => $_getSZ(5);
  @$pb.TagNumber(6)
  set uploadedBy($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasUploadedBy() => $_has(5);
  @$pb.TagNumber(6)
  void clearUploadedBy() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get uploadedAt => $_getN(6);
  @$pb.TagNumber(7)
  set uploadedAt($0.Timestamp v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasUploadedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearUploadedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureUploadedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get description => $_getSZ(7);
  @$pb.TagNumber(8)
  set description($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasDescription() => $_has(7);
  @$pb.TagNumber(8)
  void clearDescription() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get fileSizeBytes => $_getI64(8);
  @$pb.TagNumber(9)
  set fileSizeBytes($fixnum.Int64 v) { $_setInt64(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasFileSizeBytes() => $_has(8);
  @$pb.TagNumber(9)
  void clearFileSizeBytes() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get revision => $_getSZ(9);
  @$pb.TagNumber(10)
  set revision($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasRevision() => $_has(9);
  @$pb.TagNumber(10)
  void clearRevision() => $_clearField(10);
}

class CreateChecklistRequest extends $pb.GeneratedMessage {
  factory CreateChecklistRequest({
    $core.String? projectId,
    $core.String? name,
    $core.String? createdBy,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (createdBy != null) {
      $result.createdBy = createdBy;
    }
    return $result;
  }
  CreateChecklistRequest._() : super();
  factory CreateChecklistRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateChecklistRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateChecklistRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'createdBy')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateChecklistRequest clone() => CreateChecklistRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateChecklistRequest copyWith(void Function(CreateChecklistRequest) updates) => super.copyWith((message) => updates(message as CreateChecklistRequest)) as CreateChecklistRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateChecklistRequest create() => CreateChecklistRequest._();
  CreateChecklistRequest createEmptyInstance() => create();
  static $pb.PbList<CreateChecklistRequest> createRepeated() => $pb.PbList<CreateChecklistRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateChecklistRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateChecklistRequest>(create);
  static CreateChecklistRequest? _defaultInstance;

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
  $core.String get createdBy => $_getSZ(2);
  @$pb.TagNumber(3)
  set createdBy($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCreatedBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatedBy() => $_clearField(3);
}

class CreateChecklistResponse extends $pb.GeneratedMessage {
  factory CreateChecklistResponse({
    CommissioningChecklist? checklist,
  }) {
    final $result = create();
    if (checklist != null) {
      $result.checklist = checklist;
    }
    return $result;
  }
  CreateChecklistResponse._() : super();
  factory CreateChecklistResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateChecklistResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateChecklistResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOM<CommissioningChecklist>(1, _omitFieldNames ? '' : 'checklist', subBuilder: CommissioningChecklist.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateChecklistResponse clone() => CreateChecklistResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateChecklistResponse copyWith(void Function(CreateChecklistResponse) updates) => super.copyWith((message) => updates(message as CreateChecklistResponse)) as CreateChecklistResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateChecklistResponse create() => CreateChecklistResponse._();
  CreateChecklistResponse createEmptyInstance() => create();
  static $pb.PbList<CreateChecklistResponse> createRepeated() => $pb.PbList<CreateChecklistResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateChecklistResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateChecklistResponse>(create);
  static CreateChecklistResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CommissioningChecklist get checklist => $_getN(0);
  @$pb.TagNumber(1)
  set checklist(CommissioningChecklist v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasChecklist() => $_has(0);
  @$pb.TagNumber(1)
  void clearChecklist() => $_clearField(1);
  @$pb.TagNumber(1)
  CommissioningChecklist ensureChecklist() => $_ensure(0);
}

class GetChecklistRequest extends $pb.GeneratedMessage {
  factory GetChecklistRequest({
    $core.String? checklistId,
  }) {
    final $result = create();
    if (checklistId != null) {
      $result.checklistId = checklistId;
    }
    return $result;
  }
  GetChecklistRequest._() : super();
  factory GetChecklistRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetChecklistRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetChecklistRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'checklistId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetChecklistRequest clone() => GetChecklistRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetChecklistRequest copyWith(void Function(GetChecklistRequest) updates) => super.copyWith((message) => updates(message as GetChecklistRequest)) as GetChecklistRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetChecklistRequest create() => GetChecklistRequest._();
  GetChecklistRequest createEmptyInstance() => create();
  static $pb.PbList<GetChecklistRequest> createRepeated() => $pb.PbList<GetChecklistRequest>();
  @$core.pragma('dart2js:noInline')
  static GetChecklistRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetChecklistRequest>(create);
  static GetChecklistRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get checklistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set checklistId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChecklistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChecklistId() => $_clearField(1);
}

class GetChecklistResponse extends $pb.GeneratedMessage {
  factory GetChecklistResponse({
    CommissioningChecklist? checklist,
  }) {
    final $result = create();
    if (checklist != null) {
      $result.checklist = checklist;
    }
    return $result;
  }
  GetChecklistResponse._() : super();
  factory GetChecklistResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetChecklistResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetChecklistResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOM<CommissioningChecklist>(1, _omitFieldNames ? '' : 'checklist', subBuilder: CommissioningChecklist.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetChecklistResponse clone() => GetChecklistResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetChecklistResponse copyWith(void Function(GetChecklistResponse) updates) => super.copyWith((message) => updates(message as GetChecklistResponse)) as GetChecklistResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetChecklistResponse create() => GetChecklistResponse._();
  GetChecklistResponse createEmptyInstance() => create();
  static $pb.PbList<GetChecklistResponse> createRepeated() => $pb.PbList<GetChecklistResponse>();
  @$core.pragma('dart2js:noInline')
  static GetChecklistResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetChecklistResponse>(create);
  static GetChecklistResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CommissioningChecklist get checklist => $_getN(0);
  @$pb.TagNumber(1)
  set checklist(CommissioningChecklist v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasChecklist() => $_has(0);
  @$pb.TagNumber(1)
  void clearChecklist() => $_clearField(1);
  @$pb.TagNumber(1)
  CommissioningChecklist ensureChecklist() => $_ensure(0);
}

class ListChecklistsRequest extends $pb.GeneratedMessage {
  factory ListChecklistsRequest({
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
  ListChecklistsRequest._() : super();
  factory ListChecklistsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListChecklistsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListChecklistsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOM<$1.PaginationRequest>(2, _omitFieldNames ? '' : 'pagination', subBuilder: $1.PaginationRequest.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListChecklistsRequest clone() => ListChecklistsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListChecklistsRequest copyWith(void Function(ListChecklistsRequest) updates) => super.copyWith((message) => updates(message as ListChecklistsRequest)) as ListChecklistsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListChecklistsRequest create() => ListChecklistsRequest._();
  ListChecklistsRequest createEmptyInstance() => create();
  static $pb.PbList<ListChecklistsRequest> createRepeated() => $pb.PbList<ListChecklistsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListChecklistsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListChecklistsRequest>(create);
  static ListChecklistsRequest? _defaultInstance;

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

class ListChecklistsResponse extends $pb.GeneratedMessage {
  factory ListChecklistsResponse({
    $core.Iterable<CommissioningChecklist>? checklists,
    $1.PaginationResponse? pagination,
  }) {
    final $result = create();
    if (checklists != null) {
      $result.checklists.addAll(checklists);
    }
    if (pagination != null) {
      $result.pagination = pagination;
    }
    return $result;
  }
  ListChecklistsResponse._() : super();
  factory ListChecklistsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListChecklistsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListChecklistsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..pc<CommissioningChecklist>(1, _omitFieldNames ? '' : 'checklists', $pb.PbFieldType.PM, subBuilder: CommissioningChecklist.create)
    ..aOM<$1.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination', subBuilder: $1.PaginationResponse.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListChecklistsResponse clone() => ListChecklistsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListChecklistsResponse copyWith(void Function(ListChecklistsResponse) updates) => super.copyWith((message) => updates(message as ListChecklistsResponse)) as ListChecklistsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListChecklistsResponse create() => ListChecklistsResponse._();
  ListChecklistsResponse createEmptyInstance() => create();
  static $pb.PbList<ListChecklistsResponse> createRepeated() => $pb.PbList<ListChecklistsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListChecklistsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListChecklistsResponse>(create);
  static ListChecklistsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CommissioningChecklist> get checklists => $_getList(0);

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

class AddChecklistItemRequest extends $pb.GeneratedMessage {
  factory AddChecklistItemRequest({
    $core.String? checklistId,
    $core.String? description,
    ChecklistSection? section,
    $core.bool? required,
    $core.int? sequence,
  }) {
    final $result = create();
    if (checklistId != null) {
      $result.checklistId = checklistId;
    }
    if (description != null) {
      $result.description = description;
    }
    if (section != null) {
      $result.section = section;
    }
    if (required != null) {
      $result.required = required;
    }
    if (sequence != null) {
      $result.sequence = sequence;
    }
    return $result;
  }
  AddChecklistItemRequest._() : super();
  factory AddChecklistItemRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddChecklistItemRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AddChecklistItemRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'checklistId')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..e<ChecklistSection>(3, _omitFieldNames ? '' : 'section', $pb.PbFieldType.OE, defaultOrMaker: ChecklistSection.CHECKLIST_SECTION_UNSPECIFIED, valueOf: ChecklistSection.valueOf, enumValues: ChecklistSection.values)
    ..aOB(4, _omitFieldNames ? '' : 'required')
    ..a<$core.int>(5, _omitFieldNames ? '' : 'sequence', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddChecklistItemRequest clone() => AddChecklistItemRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddChecklistItemRequest copyWith(void Function(AddChecklistItemRequest) updates) => super.copyWith((message) => updates(message as AddChecklistItemRequest)) as AddChecklistItemRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddChecklistItemRequest create() => AddChecklistItemRequest._();
  AddChecklistItemRequest createEmptyInstance() => create();
  static $pb.PbList<AddChecklistItemRequest> createRepeated() => $pb.PbList<AddChecklistItemRequest>();
  @$core.pragma('dart2js:noInline')
  static AddChecklistItemRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddChecklistItemRequest>(create);
  static AddChecklistItemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get checklistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set checklistId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChecklistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChecklistId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);

  @$pb.TagNumber(3)
  ChecklistSection get section => $_getN(2);
  @$pb.TagNumber(3)
  set section(ChecklistSection v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSection() => $_has(2);
  @$pb.TagNumber(3)
  void clearSection() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get required => $_getBF(3);
  @$pb.TagNumber(4)
  set required($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRequired() => $_has(3);
  @$pb.TagNumber(4)
  void clearRequired() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get sequence => $_getIZ(4);
  @$pb.TagNumber(5)
  set sequence($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSequence() => $_has(4);
  @$pb.TagNumber(5)
  void clearSequence() => $_clearField(5);
}

class AddChecklistItemResponse extends $pb.GeneratedMessage {
  factory AddChecklistItemResponse({
    ChecklistItem? item,
  }) {
    final $result = create();
    if (item != null) {
      $result.item = item;
    }
    return $result;
  }
  AddChecklistItemResponse._() : super();
  factory AddChecklistItemResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddChecklistItemResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AddChecklistItemResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOM<ChecklistItem>(1, _omitFieldNames ? '' : 'item', subBuilder: ChecklistItem.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddChecklistItemResponse clone() => AddChecklistItemResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddChecklistItemResponse copyWith(void Function(AddChecklistItemResponse) updates) => super.copyWith((message) => updates(message as AddChecklistItemResponse)) as AddChecklistItemResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddChecklistItemResponse create() => AddChecklistItemResponse._();
  AddChecklistItemResponse createEmptyInstance() => create();
  static $pb.PbList<AddChecklistItemResponse> createRepeated() => $pb.PbList<AddChecklistItemResponse>();
  @$core.pragma('dart2js:noInline')
  static AddChecklistItemResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddChecklistItemResponse>(create);
  static AddChecklistItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ChecklistItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(ChecklistItem v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  ChecklistItem ensureItem() => $_ensure(0);
}

class UpdateChecklistItemRequest extends $pb.GeneratedMessage {
  factory UpdateChecklistItemRequest({
    $core.String? itemId,
    ChecklistItemStatus? status,
    $core.String? completedBy,
    $core.String? notes,
  }) {
    final $result = create();
    if (itemId != null) {
      $result.itemId = itemId;
    }
    if (status != null) {
      $result.status = status;
    }
    if (completedBy != null) {
      $result.completedBy = completedBy;
    }
    if (notes != null) {
      $result.notes = notes;
    }
    return $result;
  }
  UpdateChecklistItemRequest._() : super();
  factory UpdateChecklistItemRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateChecklistItemRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateChecklistItemRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..e<ChecklistItemStatus>(2, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: ChecklistItemStatus.CHECKLIST_ITEM_STATUS_UNSPECIFIED, valueOf: ChecklistItemStatus.valueOf, enumValues: ChecklistItemStatus.values)
    ..aOS(3, _omitFieldNames ? '' : 'completedBy')
    ..aOS(4, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateChecklistItemRequest clone() => UpdateChecklistItemRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateChecklistItemRequest copyWith(void Function(UpdateChecklistItemRequest) updates) => super.copyWith((message) => updates(message as UpdateChecklistItemRequest)) as UpdateChecklistItemRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateChecklistItemRequest create() => UpdateChecklistItemRequest._();
  UpdateChecklistItemRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateChecklistItemRequest> createRepeated() => $pb.PbList<UpdateChecklistItemRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateChecklistItemRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateChecklistItemRequest>(create);
  static UpdateChecklistItemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  ChecklistItemStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(ChecklistItemStatus v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get completedBy => $_getSZ(2);
  @$pb.TagNumber(3)
  set completedBy($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCompletedBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearCompletedBy() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get notes => $_getSZ(3);
  @$pb.TagNumber(4)
  set notes($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasNotes() => $_has(3);
  @$pb.TagNumber(4)
  void clearNotes() => $_clearField(4);
}

class UpdateChecklistItemResponse extends $pb.GeneratedMessage {
  factory UpdateChecklistItemResponse({
    ChecklistItem? item,
  }) {
    final $result = create();
    if (item != null) {
      $result.item = item;
    }
    return $result;
  }
  UpdateChecklistItemResponse._() : super();
  factory UpdateChecklistItemResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateChecklistItemResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateChecklistItemResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOM<ChecklistItem>(1, _omitFieldNames ? '' : 'item', subBuilder: ChecklistItem.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateChecklistItemResponse clone() => UpdateChecklistItemResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateChecklistItemResponse copyWith(void Function(UpdateChecklistItemResponse) updates) => super.copyWith((message) => updates(message as UpdateChecklistItemResponse)) as UpdateChecklistItemResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateChecklistItemResponse create() => UpdateChecklistItemResponse._();
  UpdateChecklistItemResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateChecklistItemResponse> createRepeated() => $pb.PbList<UpdateChecklistItemResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateChecklistItemResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateChecklistItemResponse>(create);
  static UpdateChecklistItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ChecklistItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(ChecklistItem v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  ChecklistItem ensureItem() => $_ensure(0);
}

class SignOffChecklistRequest extends $pb.GeneratedMessage {
  factory SignOffChecklistRequest({
    $core.String? checklistId,
    $core.String? signedBy,
    $core.String? role,
    $core.String? comments,
  }) {
    final $result = create();
    if (checklistId != null) {
      $result.checklistId = checklistId;
    }
    if (signedBy != null) {
      $result.signedBy = signedBy;
    }
    if (role != null) {
      $result.role = role;
    }
    if (comments != null) {
      $result.comments = comments;
    }
    return $result;
  }
  SignOffChecklistRequest._() : super();
  factory SignOffChecklistRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SignOffChecklistRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SignOffChecklistRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'checklistId')
    ..aOS(2, _omitFieldNames ? '' : 'signedBy')
    ..aOS(3, _omitFieldNames ? '' : 'role')
    ..aOS(4, _omitFieldNames ? '' : 'comments')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SignOffChecklistRequest clone() => SignOffChecklistRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SignOffChecklistRequest copyWith(void Function(SignOffChecklistRequest) updates) => super.copyWith((message) => updates(message as SignOffChecklistRequest)) as SignOffChecklistRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignOffChecklistRequest create() => SignOffChecklistRequest._();
  SignOffChecklistRequest createEmptyInstance() => create();
  static $pb.PbList<SignOffChecklistRequest> createRepeated() => $pb.PbList<SignOffChecklistRequest>();
  @$core.pragma('dart2js:noInline')
  static SignOffChecklistRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SignOffChecklistRequest>(create);
  static SignOffChecklistRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get checklistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set checklistId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChecklistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChecklistId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get signedBy => $_getSZ(1);
  @$pb.TagNumber(2)
  set signedBy($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSignedBy() => $_has(1);
  @$pb.TagNumber(2)
  void clearSignedBy() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get role => $_getSZ(2);
  @$pb.TagNumber(3)
  set role($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get comments => $_getSZ(3);
  @$pb.TagNumber(4)
  set comments($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasComments() => $_has(3);
  @$pb.TagNumber(4)
  void clearComments() => $_clearField(4);
}

class SignOffChecklistResponse extends $pb.GeneratedMessage {
  factory SignOffChecklistResponse({
    CommissioningSignoff? signoff,
    CommissioningChecklist? updatedChecklist,
  }) {
    final $result = create();
    if (signoff != null) {
      $result.signoff = signoff;
    }
    if (updatedChecklist != null) {
      $result.updatedChecklist = updatedChecklist;
    }
    return $result;
  }
  SignOffChecklistResponse._() : super();
  factory SignOffChecklistResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SignOffChecklistResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SignOffChecklistResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOM<CommissioningSignoff>(1, _omitFieldNames ? '' : 'signoff', subBuilder: CommissioningSignoff.create)
    ..aOM<CommissioningChecklist>(2, _omitFieldNames ? '' : 'updatedChecklist', subBuilder: CommissioningChecklist.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SignOffChecklistResponse clone() => SignOffChecklistResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SignOffChecklistResponse copyWith(void Function(SignOffChecklistResponse) updates) => super.copyWith((message) => updates(message as SignOffChecklistResponse)) as SignOffChecklistResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignOffChecklistResponse create() => SignOffChecklistResponse._();
  SignOffChecklistResponse createEmptyInstance() => create();
  static $pb.PbList<SignOffChecklistResponse> createRepeated() => $pb.PbList<SignOffChecklistResponse>();
  @$core.pragma('dart2js:noInline')
  static SignOffChecklistResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SignOffChecklistResponse>(create);
  static SignOffChecklistResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CommissioningSignoff get signoff => $_getN(0);
  @$pb.TagNumber(1)
  set signoff(CommissioningSignoff v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSignoff() => $_has(0);
  @$pb.TagNumber(1)
  void clearSignoff() => $_clearField(1);
  @$pb.TagNumber(1)
  CommissioningSignoff ensureSignoff() => $_ensure(0);

  @$pb.TagNumber(2)
  CommissioningChecklist get updatedChecklist => $_getN(1);
  @$pb.TagNumber(2)
  set updatedChecklist(CommissioningChecklist v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasUpdatedChecklist() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdatedChecklist() => $_clearField(2);
  @$pb.TagNumber(2)
  CommissioningChecklist ensureUpdatedChecklist() => $_ensure(1);
}

class ListSignoffsRequest extends $pb.GeneratedMessage {
  factory ListSignoffsRequest({
    $core.String? checklistId,
    $1.PaginationRequest? pagination,
  }) {
    final $result = create();
    if (checklistId != null) {
      $result.checklistId = checklistId;
    }
    if (pagination != null) {
      $result.pagination = pagination;
    }
    return $result;
  }
  ListSignoffsRequest._() : super();
  factory ListSignoffsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListSignoffsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListSignoffsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'checklistId')
    ..aOM<$1.PaginationRequest>(2, _omitFieldNames ? '' : 'pagination', subBuilder: $1.PaginationRequest.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListSignoffsRequest clone() => ListSignoffsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListSignoffsRequest copyWith(void Function(ListSignoffsRequest) updates) => super.copyWith((message) => updates(message as ListSignoffsRequest)) as ListSignoffsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSignoffsRequest create() => ListSignoffsRequest._();
  ListSignoffsRequest createEmptyInstance() => create();
  static $pb.PbList<ListSignoffsRequest> createRepeated() => $pb.PbList<ListSignoffsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListSignoffsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListSignoffsRequest>(create);
  static ListSignoffsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get checklistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set checklistId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChecklistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChecklistId() => $_clearField(1);

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

class ListSignoffsResponse extends $pb.GeneratedMessage {
  factory ListSignoffsResponse({
    $core.Iterable<CommissioningSignoff>? signoffs,
    $1.PaginationResponse? pagination,
  }) {
    final $result = create();
    if (signoffs != null) {
      $result.signoffs.addAll(signoffs);
    }
    if (pagination != null) {
      $result.pagination = pagination;
    }
    return $result;
  }
  ListSignoffsResponse._() : super();
  factory ListSignoffsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListSignoffsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListSignoffsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..pc<CommissioningSignoff>(1, _omitFieldNames ? '' : 'signoffs', $pb.PbFieldType.PM, subBuilder: CommissioningSignoff.create)
    ..aOM<$1.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination', subBuilder: $1.PaginationResponse.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListSignoffsResponse clone() => ListSignoffsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListSignoffsResponse copyWith(void Function(ListSignoffsResponse) updates) => super.copyWith((message) => updates(message as ListSignoffsResponse)) as ListSignoffsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSignoffsResponse create() => ListSignoffsResponse._();
  ListSignoffsResponse createEmptyInstance() => create();
  static $pb.PbList<ListSignoffsResponse> createRepeated() => $pb.PbList<ListSignoffsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListSignoffsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListSignoffsResponse>(create);
  static ListSignoffsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CommissioningSignoff> get signoffs => $_getList(0);

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

class CreateHandoverRequest extends $pb.GeneratedMessage {
  factory CreateHandoverRequest({
    $core.String? projectId,
    $core.String? checklistId,
    $core.String? handedOverBy,
    $core.String? receivedBy,
    $core.String? notes,
    $core.Iterable<$core.String>? artifactIds,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (checklistId != null) {
      $result.checklistId = checklistId;
    }
    if (handedOverBy != null) {
      $result.handedOverBy = handedOverBy;
    }
    if (receivedBy != null) {
      $result.receivedBy = receivedBy;
    }
    if (notes != null) {
      $result.notes = notes;
    }
    if (artifactIds != null) {
      $result.artifactIds.addAll(artifactIds);
    }
    return $result;
  }
  CreateHandoverRequest._() : super();
  factory CreateHandoverRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateHandoverRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateHandoverRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'checklistId')
    ..aOS(3, _omitFieldNames ? '' : 'handedOverBy')
    ..aOS(4, _omitFieldNames ? '' : 'receivedBy')
    ..aOS(5, _omitFieldNames ? '' : 'notes')
    ..pPS(6, _omitFieldNames ? '' : 'artifactIds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateHandoverRequest clone() => CreateHandoverRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateHandoverRequest copyWith(void Function(CreateHandoverRequest) updates) => super.copyWith((message) => updates(message as CreateHandoverRequest)) as CreateHandoverRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateHandoverRequest create() => CreateHandoverRequest._();
  CreateHandoverRequest createEmptyInstance() => create();
  static $pb.PbList<CreateHandoverRequest> createRepeated() => $pb.PbList<CreateHandoverRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateHandoverRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateHandoverRequest>(create);
  static CreateHandoverRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get checklistId => $_getSZ(1);
  @$pb.TagNumber(2)
  set checklistId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasChecklistId() => $_has(1);
  @$pb.TagNumber(2)
  void clearChecklistId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get handedOverBy => $_getSZ(2);
  @$pb.TagNumber(3)
  set handedOverBy($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHandedOverBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearHandedOverBy() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get receivedBy => $_getSZ(3);
  @$pb.TagNumber(4)
  set receivedBy($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasReceivedBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearReceivedBy() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get notes => $_getSZ(4);
  @$pb.TagNumber(5)
  set notes($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasNotes() => $_has(4);
  @$pb.TagNumber(5)
  void clearNotes() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get artifactIds => $_getList(5);
}

class CreateHandoverResponse extends $pb.GeneratedMessage {
  factory CreateHandoverResponse({
    HandoverRecord? handover,
  }) {
    final $result = create();
    if (handover != null) {
      $result.handover = handover;
    }
    return $result;
  }
  CreateHandoverResponse._() : super();
  factory CreateHandoverResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateHandoverResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateHandoverResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOM<HandoverRecord>(1, _omitFieldNames ? '' : 'handover', subBuilder: HandoverRecord.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateHandoverResponse clone() => CreateHandoverResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateHandoverResponse copyWith(void Function(CreateHandoverResponse) updates) => super.copyWith((message) => updates(message as CreateHandoverResponse)) as CreateHandoverResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateHandoverResponse create() => CreateHandoverResponse._();
  CreateHandoverResponse createEmptyInstance() => create();
  static $pb.PbList<CreateHandoverResponse> createRepeated() => $pb.PbList<CreateHandoverResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateHandoverResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateHandoverResponse>(create);
  static CreateHandoverResponse? _defaultInstance;

  @$pb.TagNumber(1)
  HandoverRecord get handover => $_getN(0);
  @$pb.TagNumber(1)
  set handover(HandoverRecord v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasHandover() => $_has(0);
  @$pb.TagNumber(1)
  void clearHandover() => $_clearField(1);
  @$pb.TagNumber(1)
  HandoverRecord ensureHandover() => $_ensure(0);
}

class GetHandoverRequest extends $pb.GeneratedMessage {
  factory GetHandoverRequest({
    $core.String? handoverId,
  }) {
    final $result = create();
    if (handoverId != null) {
      $result.handoverId = handoverId;
    }
    return $result;
  }
  GetHandoverRequest._() : super();
  factory GetHandoverRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetHandoverRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetHandoverRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'handoverId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetHandoverRequest clone() => GetHandoverRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetHandoverRequest copyWith(void Function(GetHandoverRequest) updates) => super.copyWith((message) => updates(message as GetHandoverRequest)) as GetHandoverRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetHandoverRequest create() => GetHandoverRequest._();
  GetHandoverRequest createEmptyInstance() => create();
  static $pb.PbList<GetHandoverRequest> createRepeated() => $pb.PbList<GetHandoverRequest>();
  @$core.pragma('dart2js:noInline')
  static GetHandoverRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetHandoverRequest>(create);
  static GetHandoverRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get handoverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set handoverId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHandoverId() => $_has(0);
  @$pb.TagNumber(1)
  void clearHandoverId() => $_clearField(1);
}

class GetHandoverResponse extends $pb.GeneratedMessage {
  factory GetHandoverResponse({
    HandoverRecord? handover,
  }) {
    final $result = create();
    if (handover != null) {
      $result.handover = handover;
    }
    return $result;
  }
  GetHandoverResponse._() : super();
  factory GetHandoverResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetHandoverResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetHandoverResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOM<HandoverRecord>(1, _omitFieldNames ? '' : 'handover', subBuilder: HandoverRecord.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetHandoverResponse clone() => GetHandoverResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetHandoverResponse copyWith(void Function(GetHandoverResponse) updates) => super.copyWith((message) => updates(message as GetHandoverResponse)) as GetHandoverResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetHandoverResponse create() => GetHandoverResponse._();
  GetHandoverResponse createEmptyInstance() => create();
  static $pb.PbList<GetHandoverResponse> createRepeated() => $pb.PbList<GetHandoverResponse>();
  @$core.pragma('dart2js:noInline')
  static GetHandoverResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetHandoverResponse>(create);
  static GetHandoverResponse? _defaultInstance;

  @$pb.TagNumber(1)
  HandoverRecord get handover => $_getN(0);
  @$pb.TagNumber(1)
  set handover(HandoverRecord v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasHandover() => $_has(0);
  @$pb.TagNumber(1)
  void clearHandover() => $_clearField(1);
  @$pb.TagNumber(1)
  HandoverRecord ensureHandover() => $_ensure(0);
}

class RecordAsBuiltRequest extends $pb.GeneratedMessage {
  factory RecordAsBuiltRequest({
    $core.String? projectId,
    $core.String? name,
    AsBuiltArtifactType? artifactType,
    $core.String? storageUrl,
    $core.String? uploadedBy,
    $core.String? description,
    $fixnum.Int64? fileSizeBytes,
    $core.String? revision,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (artifactType != null) {
      $result.artifactType = artifactType;
    }
    if (storageUrl != null) {
      $result.storageUrl = storageUrl;
    }
    if (uploadedBy != null) {
      $result.uploadedBy = uploadedBy;
    }
    if (description != null) {
      $result.description = description;
    }
    if (fileSizeBytes != null) {
      $result.fileSizeBytes = fileSizeBytes;
    }
    if (revision != null) {
      $result.revision = revision;
    }
    return $result;
  }
  RecordAsBuiltRequest._() : super();
  factory RecordAsBuiltRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RecordAsBuiltRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RecordAsBuiltRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..e<AsBuiltArtifactType>(3, _omitFieldNames ? '' : 'artifactType', $pb.PbFieldType.OE, defaultOrMaker: AsBuiltArtifactType.AS_BUILT_ARTIFACT_TYPE_UNSPECIFIED, valueOf: AsBuiltArtifactType.valueOf, enumValues: AsBuiltArtifactType.values)
    ..aOS(4, _omitFieldNames ? '' : 'storageUrl')
    ..aOS(5, _omitFieldNames ? '' : 'uploadedBy')
    ..aOS(6, _omitFieldNames ? '' : 'description')
    ..aInt64(7, _omitFieldNames ? '' : 'fileSizeBytes')
    ..aOS(8, _omitFieldNames ? '' : 'revision')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RecordAsBuiltRequest clone() => RecordAsBuiltRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RecordAsBuiltRequest copyWith(void Function(RecordAsBuiltRequest) updates) => super.copyWith((message) => updates(message as RecordAsBuiltRequest)) as RecordAsBuiltRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordAsBuiltRequest create() => RecordAsBuiltRequest._();
  RecordAsBuiltRequest createEmptyInstance() => create();
  static $pb.PbList<RecordAsBuiltRequest> createRepeated() => $pb.PbList<RecordAsBuiltRequest>();
  @$core.pragma('dart2js:noInline')
  static RecordAsBuiltRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RecordAsBuiltRequest>(create);
  static RecordAsBuiltRequest? _defaultInstance;

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
  AsBuiltArtifactType get artifactType => $_getN(2);
  @$pb.TagNumber(3)
  set artifactType(AsBuiltArtifactType v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasArtifactType() => $_has(2);
  @$pb.TagNumber(3)
  void clearArtifactType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get storageUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set storageUrl($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasStorageUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearStorageUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get uploadedBy => $_getSZ(4);
  @$pb.TagNumber(5)
  set uploadedBy($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasUploadedBy() => $_has(4);
  @$pb.TagNumber(5)
  void clearUploadedBy() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get description => $_getSZ(5);
  @$pb.TagNumber(6)
  set description($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasDescription() => $_has(5);
  @$pb.TagNumber(6)
  void clearDescription() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get fileSizeBytes => $_getI64(6);
  @$pb.TagNumber(7)
  set fileSizeBytes($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasFileSizeBytes() => $_has(6);
  @$pb.TagNumber(7)
  void clearFileSizeBytes() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get revision => $_getSZ(7);
  @$pb.TagNumber(8)
  set revision($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasRevision() => $_has(7);
  @$pb.TagNumber(8)
  void clearRevision() => $_clearField(8);
}

class RecordAsBuiltResponse extends $pb.GeneratedMessage {
  factory RecordAsBuiltResponse({
    AsBuiltArtifact? artifact,
  }) {
    final $result = create();
    if (artifact != null) {
      $result.artifact = artifact;
    }
    return $result;
  }
  RecordAsBuiltResponse._() : super();
  factory RecordAsBuiltResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RecordAsBuiltResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RecordAsBuiltResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOM<AsBuiltArtifact>(1, _omitFieldNames ? '' : 'artifact', subBuilder: AsBuiltArtifact.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RecordAsBuiltResponse clone() => RecordAsBuiltResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RecordAsBuiltResponse copyWith(void Function(RecordAsBuiltResponse) updates) => super.copyWith((message) => updates(message as RecordAsBuiltResponse)) as RecordAsBuiltResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordAsBuiltResponse create() => RecordAsBuiltResponse._();
  RecordAsBuiltResponse createEmptyInstance() => create();
  static $pb.PbList<RecordAsBuiltResponse> createRepeated() => $pb.PbList<RecordAsBuiltResponse>();
  @$core.pragma('dart2js:noInline')
  static RecordAsBuiltResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RecordAsBuiltResponse>(create);
  static RecordAsBuiltResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AsBuiltArtifact get artifact => $_getN(0);
  @$pb.TagNumber(1)
  set artifact(AsBuiltArtifact v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasArtifact() => $_has(0);
  @$pb.TagNumber(1)
  void clearArtifact() => $_clearField(1);
  @$pb.TagNumber(1)
  AsBuiltArtifact ensureArtifact() => $_ensure(0);
}

class ListAsBuiltArtifactsRequest extends $pb.GeneratedMessage {
  factory ListAsBuiltArtifactsRequest({
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
  ListAsBuiltArtifactsRequest._() : super();
  factory ListAsBuiltArtifactsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListAsBuiltArtifactsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListAsBuiltArtifactsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOM<$1.PaginationRequest>(2, _omitFieldNames ? '' : 'pagination', subBuilder: $1.PaginationRequest.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListAsBuiltArtifactsRequest clone() => ListAsBuiltArtifactsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListAsBuiltArtifactsRequest copyWith(void Function(ListAsBuiltArtifactsRequest) updates) => super.copyWith((message) => updates(message as ListAsBuiltArtifactsRequest)) as ListAsBuiltArtifactsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAsBuiltArtifactsRequest create() => ListAsBuiltArtifactsRequest._();
  ListAsBuiltArtifactsRequest createEmptyInstance() => create();
  static $pb.PbList<ListAsBuiltArtifactsRequest> createRepeated() => $pb.PbList<ListAsBuiltArtifactsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListAsBuiltArtifactsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListAsBuiltArtifactsRequest>(create);
  static ListAsBuiltArtifactsRequest? _defaultInstance;

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

class ListAsBuiltArtifactsResponse extends $pb.GeneratedMessage {
  factory ListAsBuiltArtifactsResponse({
    $core.Iterable<AsBuiltArtifact>? artifacts,
    $1.PaginationResponse? pagination,
  }) {
    final $result = create();
    if (artifacts != null) {
      $result.artifacts.addAll(artifacts);
    }
    if (pagination != null) {
      $result.pagination = pagination;
    }
    return $result;
  }
  ListAsBuiltArtifactsResponse._() : super();
  factory ListAsBuiltArtifactsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListAsBuiltArtifactsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListAsBuiltArtifactsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..pc<AsBuiltArtifact>(1, _omitFieldNames ? '' : 'artifacts', $pb.PbFieldType.PM, subBuilder: AsBuiltArtifact.create)
    ..aOM<$1.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination', subBuilder: $1.PaginationResponse.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListAsBuiltArtifactsResponse clone() => ListAsBuiltArtifactsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListAsBuiltArtifactsResponse copyWith(void Function(ListAsBuiltArtifactsResponse) updates) => super.copyWith((message) => updates(message as ListAsBuiltArtifactsResponse)) as ListAsBuiltArtifactsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAsBuiltArtifactsResponse create() => ListAsBuiltArtifactsResponse._();
  ListAsBuiltArtifactsResponse createEmptyInstance() => create();
  static $pb.PbList<ListAsBuiltArtifactsResponse> createRepeated() => $pb.PbList<ListAsBuiltArtifactsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListAsBuiltArtifactsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListAsBuiltArtifactsResponse>(create);
  static ListAsBuiltArtifactsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AsBuiltArtifact> get artifacts => $_getList(0);

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

class GenerateCommissioningReportRequest extends $pb.GeneratedMessage {
  factory GenerateCommissioningReportRequest({
    $core.String? checklistId,
  }) {
    final $result = create();
    if (checklistId != null) {
      $result.checklistId = checklistId;
    }
    return $result;
  }
  GenerateCommissioningReportRequest._() : super();
  factory GenerateCommissioningReportRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenerateCommissioningReportRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GenerateCommissioningReportRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'checklistId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenerateCommissioningReportRequest clone() => GenerateCommissioningReportRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenerateCommissioningReportRequest copyWith(void Function(GenerateCommissioningReportRequest) updates) => super.copyWith((message) => updates(message as GenerateCommissioningReportRequest)) as GenerateCommissioningReportRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenerateCommissioningReportRequest create() => GenerateCommissioningReportRequest._();
  GenerateCommissioningReportRequest createEmptyInstance() => create();
  static $pb.PbList<GenerateCommissioningReportRequest> createRepeated() => $pb.PbList<GenerateCommissioningReportRequest>();
  @$core.pragma('dart2js:noInline')
  static GenerateCommissioningReportRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenerateCommissioningReportRequest>(create);
  static GenerateCommissioningReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get checklistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set checklistId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChecklistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChecklistId() => $_clearField(1);
}

class GenerateCommissioningReportResponse extends $pb.GeneratedMessage {
  factory GenerateCommissioningReportResponse({
    $core.String? reportText,
    $0.Timestamp? generatedAt,
  }) {
    final $result = create();
    if (reportText != null) {
      $result.reportText = reportText;
    }
    if (generatedAt != null) {
      $result.generatedAt = generatedAt;
    }
    return $result;
  }
  GenerateCommissioningReportResponse._() : super();
  factory GenerateCommissioningReportResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenerateCommissioningReportResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GenerateCommissioningReportResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'commissioning.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reportText')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'generatedAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenerateCommissioningReportResponse clone() => GenerateCommissioningReportResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenerateCommissioningReportResponse copyWith(void Function(GenerateCommissioningReportResponse) updates) => super.copyWith((message) => updates(message as GenerateCommissioningReportResponse)) as GenerateCommissioningReportResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenerateCommissioningReportResponse create() => GenerateCommissioningReportResponse._();
  GenerateCommissioningReportResponse createEmptyInstance() => create();
  static $pb.PbList<GenerateCommissioningReportResponse> createRepeated() => $pb.PbList<GenerateCommissioningReportResponse>();
  @$core.pragma('dart2js:noInline')
  static GenerateCommissioningReportResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenerateCommissioningReportResponse>(create);
  static GenerateCommissioningReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reportText => $_getSZ(0);
  @$pb.TagNumber(1)
  set reportText($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasReportText() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportText() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get generatedAt => $_getN(1);
  @$pb.TagNumber(2)
  set generatedAt($0.Timestamp v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasGeneratedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearGeneratedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureGeneratedAt() => $_ensure(1);
}

/// CommissioningService manages commissioning checklists, signoff workflows,
/// formal handover records, and as-built artifact registration for solar projects.
class CommissioningServiceApi {
  $pb.RpcClient _client;
  CommissioningServiceApi(this._client);

  /// Checklist lifecycle
  $async.Future<CreateChecklistResponse> createChecklist($pb.ClientContext? ctx, CreateChecklistRequest request) =>
    _client.invoke<CreateChecklistResponse>(ctx, 'CommissioningService', 'CreateChecklist', request, CreateChecklistResponse())
  ;
  $async.Future<GetChecklistResponse> getChecklist($pb.ClientContext? ctx, GetChecklistRequest request) =>
    _client.invoke<GetChecklistResponse>(ctx, 'CommissioningService', 'GetChecklist', request, GetChecklistResponse())
  ;
  $async.Future<ListChecklistsResponse> listChecklists($pb.ClientContext? ctx, ListChecklistsRequest request) =>
    _client.invoke<ListChecklistsResponse>(ctx, 'CommissioningService', 'ListChecklists', request, ListChecklistsResponse())
  ;
  /// Checklist item management
  $async.Future<AddChecklistItemResponse> addChecklistItem($pb.ClientContext? ctx, AddChecklistItemRequest request) =>
    _client.invoke<AddChecklistItemResponse>(ctx, 'CommissioningService', 'AddChecklistItem', request, AddChecklistItemResponse())
  ;
  $async.Future<UpdateChecklistItemResponse> updateChecklistItem($pb.ClientContext? ctx, UpdateChecklistItemRequest request) =>
    _client.invoke<UpdateChecklistItemResponse>(ctx, 'CommissioningService', 'UpdateChecklistItem', request, UpdateChecklistItemResponse())
  ;
  /// Engineer / contractor signoff
  $async.Future<SignOffChecklistResponse> signOffChecklist($pb.ClientContext? ctx, SignOffChecklistRequest request) =>
    _client.invoke<SignOffChecklistResponse>(ctx, 'CommissioningService', 'SignOffChecklist', request, SignOffChecklistResponse())
  ;
  $async.Future<ListSignoffsResponse> listSignoffs($pb.ClientContext? ctx, ListSignoffsRequest request) =>
    _client.invoke<ListSignoffsResponse>(ctx, 'CommissioningService', 'ListSignoffs', request, ListSignoffsResponse())
  ;
  /// Formal project handover
  $async.Future<CreateHandoverResponse> createHandover($pb.ClientContext? ctx, CreateHandoverRequest request) =>
    _client.invoke<CreateHandoverResponse>(ctx, 'CommissioningService', 'CreateHandover', request, CreateHandoverResponse())
  ;
  $async.Future<GetHandoverResponse> getHandover($pb.ClientContext? ctx, GetHandoverRequest request) =>
    _client.invoke<GetHandoverResponse>(ctx, 'CommissioningService', 'GetHandover', request, GetHandoverResponse())
  ;
  /// As-built artifact registry (URL-based; binary upload is a separate storage concern)
  $async.Future<RecordAsBuiltResponse> recordAsBuilt($pb.ClientContext? ctx, RecordAsBuiltRequest request) =>
    _client.invoke<RecordAsBuiltResponse>(ctx, 'CommissioningService', 'RecordAsBuilt', request, RecordAsBuiltResponse())
  ;
  $async.Future<ListAsBuiltArtifactsResponse> listAsBuiltArtifacts($pb.ClientContext? ctx, ListAsBuiltArtifactsRequest request) =>
    _client.invoke<ListAsBuiltArtifactsResponse>(ctx, 'CommissioningService', 'ListAsBuiltArtifacts', request, ListAsBuiltArtifactsResponse())
  ;
  /// Plain-text commissioning report covering all checklist items and signoffs
  $async.Future<GenerateCommissioningReportResponse> generateCommissioningReport($pb.ClientContext? ctx, GenerateCommissioningReportRequest request) =>
    _client.invoke<GenerateCommissioningReportResponse>(ctx, 'CommissioningService', 'GenerateCommissioningReport', request, GenerateCommissioningReportResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
