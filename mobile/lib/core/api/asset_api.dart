import '../models/asset.dart';
import 'api_client.dart';

class AssetApi {
  final ApiClient _client;

  AssetApi(this._client);

  Future<List<Asset>> listAssets({String? category}) async {
    return _client.get(
      '/api/v1/assets',
      queryParameters: {
        if (category != null) 'category': category,
      },
      parser: (data) {
        final list = data['assets'] as List<dynamic>? ?? [];
        return list
            .map((e) => Asset.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<Asset> getAsset(String id) async {
    return _client.get(
      '/api/v1/assets/$id',
      parser: (data) => Asset.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Asset> createAsset(Asset asset) async {
    return _client.post(
      '/api/v1/assets',
      data: asset.toJson(),
      parser: (data) => Asset.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<void> deleteAsset(String id) async {
    await _client.delete('/api/v1/assets/$id');
  }
}
