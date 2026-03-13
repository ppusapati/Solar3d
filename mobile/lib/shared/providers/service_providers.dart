import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/connectrpc/transport.dart';
import '../../core/connectrpc/services/project_service.dart';
import '../../core/connectrpc/services/layout_service.dart';
import '../../core/connectrpc/services/simulation_service.dart';
import '../../core/connectrpc/services/terrain_service.dart';
import '../../core/connectrpc/services/electrical_service.dart';
import '../../core/connectrpc/services/routing_service.dart';
import '../../core/connectrpc/services/report_service.dart';
import '../../core/connectrpc/services/asset_service.dart';

// Transport (singleton)
final connectRpcTransportProvider = Provider<ConnectRpcTransport>((ref) {
  final transport = ConnectRpcTransport();
  ref.onDispose(() => transport.dispose());
  return transport;
});

// Service clients (Riverpod provides DI)
final projectServiceProvider = Provider<ProjectServiceClient>((ref) {
  return ProjectServiceClient(ref.watch(connectRpcTransportProvider));
});

final layoutServiceProvider = Provider<LayoutServiceClient>((ref) {
  return LayoutServiceClient(ref.watch(connectRpcTransportProvider));
});

final simulationServiceProvider = Provider<SimulationServiceClient>((ref) {
  return SimulationServiceClient(ref.watch(connectRpcTransportProvider));
});

final terrainServiceProvider = Provider<TerrainServiceClient>((ref) {
  return TerrainServiceClient(ref.watch(connectRpcTransportProvider));
});

final electricalServiceProvider = Provider<ElectricalServiceClient>((ref) {
  return ElectricalServiceClient(ref.watch(connectRpcTransportProvider));
});

final routingServiceProvider = Provider<RoutingServiceClient>((ref) {
  return RoutingServiceClient(ref.watch(connectRpcTransportProvider));
});

final reportServiceProvider = Provider<ReportServiceClient>((ref) {
  return ReportServiceClient(ref.watch(connectRpcTransportProvider));
});

final assetServiceProvider = Provider<AssetServiceClient>((ref) {
  return AssetServiceClient(ref.watch(connectRpcTransportProvider));
});
