//
//  Generated code. Do not modify.
//  source: asset/v1/asset.proto
//

import "package:connectrpc/connect.dart" as connect;
import "asset.pb.dart" as assetv1asset;

abstract final class AssetService {
  /// Fully-qualified name of the AssetService service.
  static const name = 'asset.v1.AssetService';

  static const createAsset = connect.Spec(
    '/$name/CreateAsset',
    connect.StreamType.unary,
    assetv1asset.CreateAssetRequest.new,
    assetv1asset.CreateAssetResponse.new,
  );

  static const getAsset = connect.Spec(
    '/$name/GetAsset',
    connect.StreamType.unary,
    assetv1asset.GetAssetRequest.new,
    assetv1asset.GetAssetResponse.new,
  );

  static const listAssets = connect.Spec(
    '/$name/ListAssets',
    connect.StreamType.unary,
    assetv1asset.ListAssetsRequest.new,
    assetv1asset.ListAssetsResponse.new,
  );

  static const updateAsset = connect.Spec(
    '/$name/UpdateAsset',
    connect.StreamType.unary,
    assetv1asset.UpdateAssetRequest.new,
    assetv1asset.UpdateAssetResponse.new,
  );

  static const deleteAsset = connect.Spec(
    '/$name/DeleteAsset',
    connect.StreamType.unary,
    assetv1asset.DeleteAssetRequest.new,
    assetv1asset.DeleteAssetResponse.new,
  );
}
