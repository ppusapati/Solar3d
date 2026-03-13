import '../../models/asset.dart';
import '../transport.dart';

class AssetServiceClient {
  static const _service = 'asset.v1.AssetService';
  final ConnectRpcTransport _transport;

  AssetServiceClient(this._transport);

  Future<Asset> createAsset(Map<String, dynamic> assetData) async {
    final response = await _transport.unary(
      service: _service,
      method: 'CreateAsset',
      request: assetData,
    );
    return Asset.fromJson(response['asset'] as Map<String, dynamic>);
  }

  Future<Asset> getAsset(String id) async {
    final response = await _transport.unary(
      service: _service,
      method: 'GetAsset',
      request: {'id': id},
    );
    return Asset.fromJson(response['asset'] as Map<String, dynamic>);
  }

  Future<List<Asset>> listAssets({String? category}) async {
    final response = await _transport.unary(
      service: _service,
      method: 'ListAssets',
      request: {
        if (category != null) 'category': category,
      },
    );
    final list = response['assets'] as List<dynamic>? ?? [];
    return list
        .map((e) => Asset.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Asset> updateAsset(
      String id, Map<String, dynamic> updates) async {
    final response = await _transport.unary(
      service: _service,
      method: 'UpdateAsset',
      request: {'id': id, ...updates},
    );
    return Asset.fromJson(response['asset'] as Map<String, dynamic>);
  }

  Future<void> deleteAsset(String id) async {
    await _transport.unary(
      service: _service,
      method: 'DeleteAsset',
      request: {'id': id},
    );
  }
}
