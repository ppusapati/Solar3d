//
//  Generated code. Do not modify.
//  source: asset/v1/asset.proto
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

import 'asset.pb.dart' as $3;
import 'asset.pbjson.dart';

export 'asset.pb.dart';

abstract class AssetServiceBase extends $pb.GeneratedService {
  $async.Future<$3.CreateAssetResponse> createAsset($pb.ServerContext ctx, $3.CreateAssetRequest request);
  $async.Future<$3.GetAssetResponse> getAsset($pb.ServerContext ctx, $3.GetAssetRequest request);
  $async.Future<$3.ListAssetsResponse> listAssets($pb.ServerContext ctx, $3.ListAssetsRequest request);
  $async.Future<$3.UpdateAssetResponse> updateAsset($pb.ServerContext ctx, $3.UpdateAssetRequest request);
  $async.Future<$3.DeleteAssetResponse> deleteAsset($pb.ServerContext ctx, $3.DeleteAssetRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CreateAsset': return $3.CreateAssetRequest();
      case 'GetAsset': return $3.GetAssetRequest();
      case 'ListAssets': return $3.ListAssetsRequest();
      case 'UpdateAsset': return $3.UpdateAssetRequest();
      case 'DeleteAsset': return $3.DeleteAssetRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CreateAsset': return this.createAsset(ctx, request as $3.CreateAssetRequest);
      case 'GetAsset': return this.getAsset(ctx, request as $3.GetAssetRequest);
      case 'ListAssets': return this.listAssets(ctx, request as $3.ListAssetsRequest);
      case 'UpdateAsset': return this.updateAsset(ctx, request as $3.UpdateAssetRequest);
      case 'DeleteAsset': return this.deleteAsset(ctx, request as $3.DeleteAssetRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => AssetServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => AssetServiceBase$messageJson;
}

