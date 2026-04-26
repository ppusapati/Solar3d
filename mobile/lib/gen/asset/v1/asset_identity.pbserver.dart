//
//  Generated code. Do not modify.
//  source: asset/v1/asset_identity.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'asset_identity.pb.dart' as $4;
import 'asset_identity.pbjson.dart';

export 'asset_identity.pb.dart';

abstract class AssetIdentityServiceBase extends $pb.GeneratedService {
  $async.Future<$4.LinkAssetIdentityResponse> linkAssetIdentity($pb.ServerContext ctx, $4.LinkAssetIdentityRequest request);
  $async.Future<$4.GetAssetIdentityResponse> getAssetIdentity($pb.ServerContext ctx, $4.GetAssetIdentityRequest request);
  $async.Future<$4.ListAssetIdentitiesByProjectResponse> listAssetIdentitiesByProject($pb.ServerContext ctx, $4.ListAssetIdentitiesByProjectRequest request);
  $async.Future<$4.ListAssetIdentitiesByTwinResponse> listAssetIdentitiesByTwin($pb.ServerContext ctx, $4.ListAssetIdentitiesByTwinRequest request);
  $async.Future<$4.UpdateAssetIdentityResponse> updateAssetIdentity($pb.ServerContext ctx, $4.UpdateAssetIdentityRequest request);
  $async.Future<$4.UnlinkAssetIdentityResponse> unlinkAssetIdentity($pb.ServerContext ctx, $4.UnlinkAssetIdentityRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'LinkAssetIdentity': return $4.LinkAssetIdentityRequest();
      case 'GetAssetIdentity': return $4.GetAssetIdentityRequest();
      case 'ListAssetIdentitiesByProject': return $4.ListAssetIdentitiesByProjectRequest();
      case 'ListAssetIdentitiesByTwin': return $4.ListAssetIdentitiesByTwinRequest();
      case 'UpdateAssetIdentity': return $4.UpdateAssetIdentityRequest();
      case 'UnlinkAssetIdentity': return $4.UnlinkAssetIdentityRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'LinkAssetIdentity': return this.linkAssetIdentity(ctx, request as $4.LinkAssetIdentityRequest);
      case 'GetAssetIdentity': return this.getAssetIdentity(ctx, request as $4.GetAssetIdentityRequest);
      case 'ListAssetIdentitiesByProject': return this.listAssetIdentitiesByProject(ctx, request as $4.ListAssetIdentitiesByProjectRequest);
      case 'ListAssetIdentitiesByTwin': return this.listAssetIdentitiesByTwin(ctx, request as $4.ListAssetIdentitiesByTwinRequest);
      case 'UpdateAssetIdentity': return this.updateAssetIdentity(ctx, request as $4.UpdateAssetIdentityRequest);
      case 'UnlinkAssetIdentity': return this.unlinkAssetIdentity(ctx, request as $4.UnlinkAssetIdentityRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => AssetIdentityServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => AssetIdentityServiceBase$messageJson;
}

