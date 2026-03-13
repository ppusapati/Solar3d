# Solar3D Mobile

Flutter mobile application for the Solar3D EPC Platform. Supports both iOS and Android.

## Architecture

- **State Management**: Riverpod (DI + simple state) + Bloc (complex business logic)
- **API Communication**: ConnectRPC (protocol buffers over HTTP)
- **Navigation**: GoRouter with shell routes
- **UI**: Material 3 with custom solar theme

## Project Structure

```
lib/
├── main.dart
├── core/
│   ├── api/              # REST API client (legacy)
│   ├── config/           # App configuration
│   ├── connectrpc/       # ConnectRPC transport & service clients
│   │   ├── transport.dart
│   │   └── services/     # 8 service clients matching backend
│   ├── models/           # Data models (Project, Layout, Simulation, etc.)
│   ├── theme/            # App theme, colors, text styles
│   └── utils/            # Formatters, validators
├── features/
│   ├── dashboard/        # Dashboard overview
│   ├── projects/         # Project CRUD
│   ├── layout/           # Panel layout design
│   ├── simulation/       # Shadow/irradiance/yield simulations
│   ├── electrical/       # Electrical network design
│   ├── reports/          # Report generation & BOM
│   ├── map/              # Interactive site map
│   ├── terrain/          # Terrain management
│   └── routing/          # Cable/road routing
└── shared/
    ├── providers/        # Riverpod providers (services + blocs)
    └── widgets/          # Shared UI components
```

## Backend Services (ConnectRPC)

All 8 backend gRPC services are connected:

| Service | Methods | Description |
|---------|---------|-------------|
| ProjectService | 5 | Project CRUD |
| LayoutService | 11 | Panel layout, tiles, components |
| SimulationService | 7 | Shadow, irradiance, yield sims |
| TerrainService | 8 | DEM upload, elevation, slope |
| ElectricalService | 12 | Networks, strings, inverters |
| RoutingService | 6 | Cable/road routing |
| ReportService | 6 | Reports, BOM, exports |
| AssetService | 5 | Equipment catalog |

## Getting Started

```bash
cd mobile
flutter pub get
flutter run
```

### Configure Server

Set the API base URL in app settings, or via environment:
```bash
flutter run --dart-define=API_BASE_URL=http://your-server:8080
```

## Requirements

- Flutter 3.2+
- Dart 3.2+
- iOS 14+ / Android API 21+
