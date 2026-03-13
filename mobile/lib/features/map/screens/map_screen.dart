import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/providers/service_providers.dart';

class MapScreen extends ConsumerStatefulWidget {
  final String projectId;

  const MapScreen({super.key, required this.projectId});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();
  String _activeLayer = 'satellite';
  bool _showPanels = true;
  bool _showBoundary = true;
  bool _showComponents = true;
  String _activeTool = 'pan';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Site Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.layers),
            onPressed: _showLayerSelector,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(34.0522, -118.2437),
              initialZoom: 15,
              onTap: (tapPosition, latLng) {
                if (_activeTool == 'place-component') {
                  _onPlaceComponent(latLng);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.solar3d.mobile',
              ),
            ],
          ),

          // Tool bar (bottom)
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ToolButton(
                      icon: Icons.pan_tool,
                      label: 'Pan',
                      isActive: _activeTool == 'pan',
                      onTap: () => setState(() => _activeTool = 'pan'),
                    ),
                    _ToolButton(
                      icon: Icons.crop_square,
                      label: 'Boundary',
                      isActive: _activeTool == 'draw-boundary',
                      onTap: () =>
                          setState(() => _activeTool = 'draw-boundary'),
                    ),
                    _ToolButton(
                      icon: Icons.grid_view,
                      label: 'Area',
                      isActive: _activeTool == 'draw-area',
                      onTap: () =>
                          setState(() => _activeTool = 'draw-area'),
                    ),
                    _ToolButton(
                      icon: Icons.add_location,
                      label: 'Place',
                      isActive: _activeTool == 'place-component',
                      onTap: () =>
                          setState(() => _activeTool = 'place-component'),
                    ),
                    _ToolButton(
                      icon: Icons.straighten,
                      label: 'Measure',
                      isActive: _activeTool == 'measure',
                      onTap: () =>
                          setState(() => _activeTool = 'measure'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Zoom controls
          Positioned(
            right: 16,
            top: 16,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'zoom_in',
                  onPressed: () => _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom + 1,
                  ),
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'zoom_out',
                  onPressed: () => _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom - 1,
                  ),
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'my_location',
                  onPressed: () {},
                  child: const Icon(Icons.my_location),
                ),
              ],
            ),
          ),

          // Layer visibility chips
          Positioned(
            top: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilterChip(
                  selected: _showPanels,
                  label: const Text('Panels'),
                  onSelected: (v) => setState(() => _showPanels = v),
                  selectedColor: AppColors.panelColor.withOpacity(0.2),
                  avatar: Icon(Icons.grid_view,
                      size: 16,
                      color: _showPanels
                          ? AppColors.panelColor
                          : Colors.grey),
                ),
                const SizedBox(height: 4),
                FilterChip(
                  selected: _showBoundary,
                  label: const Text('Boundary'),
                  onSelected: (v) => setState(() => _showBoundary = v),
                  selectedColor: AppColors.boundaryColor.withOpacity(0.2),
                  avatar: Icon(Icons.crop_square,
                      size: 16,
                      color: _showBoundary
                          ? AppColors.boundaryColor
                          : Colors.grey),
                ),
                const SizedBox(height: 4),
                FilterChip(
                  selected: _showComponents,
                  label: const Text('Components'),
                  onSelected: (v) => setState(() => _showComponents = v),
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  avatar: Icon(Icons.memory,
                      size: 16,
                      color: _showComponents
                          ? AppColors.primary
                          : Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLayerSelector() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Map Layers', style: AppTextStyles.heading3),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.satellite),
              title: const Text('Satellite'),
              selected: _activeLayer == 'satellite',
              onTap: () {
                setState(() => _activeLayer = 'satellite');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.terrain),
              title: const Text('Terrain'),
              selected: _activeLayer == 'terrain',
              onTap: () {
                setState(() => _activeLayer = 'terrain');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Street Map'),
              selected: _activeLayer == 'street',
              onTap: () {
                setState(() => _activeLayer = 'street');
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onPlaceComponent(LatLng position) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Component placed at ${position.latitude.toStringAsFixed(6)}, '
          '${position.longitude.toStringAsFixed(6)}',
        ),
        action: SnackBarAction(label: 'Undo', onPressed: () {}),
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ToolButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive ? AppColors.primary : Colors.grey,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? AppColors.primary : Colors.grey,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
