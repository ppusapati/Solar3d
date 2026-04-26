//
//  Generated code. Do not modify.
//  source: asset/v1/asset.proto
//

import "package:connectrpc/connect.dart" as connect;
import "asset.pb.dart" as assetv1asset;
import "asset.connect.spec.dart" as specs;

extension type AssetServiceClient (connect.Transport _transport) {
  Future<assetv1asset.CreateAssetResponse> createAsset(
    assetv1asset.CreateAssetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AssetService.createAsset,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<assetv1asset.GetAssetResponse> getAsset(
    assetv1asset.GetAssetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AssetService.getAsset,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<assetv1asset.ListAssetsResponse> listAssets(
    assetv1asset.ListAssetsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AssetService.listAssets,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<assetv1asset.UpdateAssetResponse> updateAsset(
    assetv1asset.UpdateAssetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AssetService.updateAsset,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<assetv1asset.DeleteAssetResponse> deleteAsset(
    assetv1asset.DeleteAssetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AssetService.deleteAsset,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
