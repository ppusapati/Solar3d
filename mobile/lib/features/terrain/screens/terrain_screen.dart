import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/models/terrain.dart';
import '../../../shared/providers/service_providers.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../shared/widgets/empty_state_widget.dart';

class TerrainScreen extends ConsumerStatefulWidget {
  final String projectId;

  const TerrainScreen({super.key, required this.projectId});

  @override
  ConsumerState<TerrainScreen> createState() => _TerrainScreenState();
}

class _TerrainScreenState extends ConsumerState<TerrainScreen> {
  List<TerrainLayer> _layers = [];
  bool _isLoading = true;
  String? _error;
  bool _isComputing = false;

  @override
  void initState() {
    super.initState();
    _loadLayers();
  }

  Future<void> _loadLayers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final terrainService = ref.read(terrainServiceProvider);
      _layers = await terrainService.listTerrainLayers(widget.projectId);
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _computeSlope(String layerId) async {
    setState(() => _isComputing = true);
    try {
      final terrainService = ref.read(terrainServiceProvider);
      await terrainService.computeSlope(layerId);
      await _loadLayers();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to compute slope: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isComputing = false);
    }
  }

  Future<void> _computeAspect(String layerId) async {
    setState(() => _isComputing = true);
    try {
      final terrainService = ref.read(terrainServiceProvider);
      await terrainService.computeAspect(layerId);
      await _loadLayers();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to compute aspect: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isComputing = false);
    }
  }

  Future<void> _deleteLayer(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Layer'),
        content:
            const Text('Are you sure you want to delete this terrain layer?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      final terrainService = ref.read(terrainServiceProvider);
      await terrainService.deleteTerrainLayer(id);
      await _loadLayers();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terrain'),
        actions: [
          if (_isComputing)
            const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLayers,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Loading terrain layers...');
    }
    if (_error != null) {
      return AppErrorWidget(message: _error!, onRetry: _loadLayers);
    }
    if (_layers.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.terrain,
        title: 'No terrain data',
        subtitle: 'Upload terrain data from the web application',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadLayers,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _layers.length,
        itemBuilder: (context, index) {
          final layer = _layers[index];
          return _TerrainLayerCard(
            layer: layer,
            onComputeSlope: () => _computeSlope(layer.id),
            onComputeAspect: () => _computeAspect(layer.id),
            onDelete: () => _deleteLayer(layer.id),
          );
        },
      ),
    );
  }
}

class _TerrainLayerCard extends StatelessWidget {
  final TerrainLayer layer;
  final VoidCallback onComputeSlope;
  final VoidCallback onComputeAspect;
  final VoidCallback onDelete;

  const _TerrainLayerCard({
    required this.layer,
    required this.onComputeSlope,
    required this.onComputeAspect,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_layerTypeIcon, color: _layerTypeColor, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(layer.name, style: AppTextStyles.subtitle),
                      Text(
                        layer.layerType.replaceAll('_', ' ').toUpperCase(),
                        style: AppTextStyles.caption
                            .copyWith(color: _layerTypeColor),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (layer.resolutionM != null)
                  _InfoChip(
                      'Resolution', '${layer.resolutionM!.toStringAsFixed(0)}m'),
                if (layer.crs != null) _InfoChip('CRS', layer.crs!),
                if (layer.minElevation != null && layer.maxElevation != null)
                  _InfoChip('Elevation',
                      '${layer.minElevation!.toStringAsFixed(0)} - ${layer.maxElevation!.toStringAsFixed(0)}m'),
              ],
            ),
            if (layer.bounds != null) ...[
              const SizedBox(height: 8),
              Text(
                'Bounds: ${layer.bounds!.minX.toStringAsFixed(4)}, ${layer.bounds!.minY.toStringAsFixed(4)} to ${layer.bounds!.maxX.toStringAsFixed(4)}, ${layer.bounds!.maxY.toStringAsFixed(4)}',
                style: AppTextStyles.bodySmall
                    .copyWith(color: Colors.grey.shade600),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: onComputeSlope,
                  icon: const Icon(Icons.trending_up, size: 16),
                  label: const Text('Slope'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: onComputeAspect,
                  icon: const Icon(Icons.explore, size: 16),
                  label: const Text('Aspect'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData get _layerTypeIcon {
    switch (layer.layerType) {
      case 'ELEVATION':
        return Icons.terrain;
      case 'SLOPE':
        return Icons.trending_up;
      case 'ASPECT':
        return Icons.explore;
      case 'HILLSHADE':
        return Icons.wb_sunny;
      default:
        return Icons.layers;
    }
  }

  Color get _layerTypeColor {
    switch (layer.layerType) {
      case 'ELEVATION':
        return AppColors.secondary;
      case 'SLOPE':
        return AppColors.warning;
      case 'ASPECT':
        return AppColors.success;
      case 'HILLSHADE':
        return AppColors.primary;
      default:
        return Colors.grey;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _InfoChip(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label: $value',
        style: AppTextStyles.caption,
      ),
    );
  }
}
