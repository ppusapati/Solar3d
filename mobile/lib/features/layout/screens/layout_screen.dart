import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/models/layout.dart';
import '../../../shared/providers/bloc_providers.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/metric_card.dart';
import '../bloc/layout_bloc.dart';

class LayoutScreen extends ConsumerWidget {
  final String projectId;

  const LayoutScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(layoutBlocProvider(projectId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Layout'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateDialog(context, bloc),
          ),
        ],
      ),
      body: BlocBuilder<LayoutBloc, LayoutState>(
        bloc: bloc,
        builder: (context, state) {
          if (state.isLoading && state.layouts.isEmpty) {
            return const LoadingWidget(message: 'Loading layouts...');
          }

          if (state.error != null && state.layouts.isEmpty) {
            return AppErrorWidget(
              message: state.error!,
              onRetry: () => bloc.add(LoadLayouts(projectId)),
            );
          }

          if (state.layouts.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.grid_view,
              title: 'No layouts yet',
              subtitle: 'Create a layout to start designing panel arrays',
              actionLabel: 'Create Layout',
              onAction: () => _showCreateDialog(context, bloc),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Active layout stats
              if (state.activeLayout != null) ...[
                Text('Active Layout', style: AppTextStyles.heading3),
                const SizedBox(height: 8),
                _LayoutDetailCard(
                  layout: state.activeLayout!,
                  isGenerating: state.isGenerating,
                  onGenerate: () =>
                      _showGenerateDialog(context, bloc, state.activeLayout!),
                ),
                const SizedBox(height: 8),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.6,
                  children: [
                    MetricCard(
                      label: 'Total Panels',
                      value: '${state.activeLayout!.totalPanels}',
                      icon: Icons.grid_view,
                      iconColor: AppColors.secondary,
                    ),
                    MetricCard(
                      label: 'Capacity',
                      value: (state.activeLayout!.totalCapacityKw / 1000)
                          .toStringAsFixed(2),
                      unit: 'MW',
                      icon: Icons.bolt,
                      iconColor: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],

              // Components section
              if (state.components.isNotEmpty) ...[
                Text('Components', style: AppTextStyles.heading3),
                const SizedBox(height: 8),
                ...state.components.map((c) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(
                          _componentIcon(c.componentType),
                          color: AppColors.secondary,
                        ),
                        title: Text(c.componentType),
                        subtitle: Text(
                          'Lat: ${c.position.latitude.toStringAsFixed(6)}, '
                          'Lng: ${c.position.longitude.toStringAsFixed(6)}',
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                    )),
                const SizedBox(height: 24),
              ],

              // All layouts
              Text('All Layouts', style: AppTextStyles.heading3),
              const SizedBox(height: 8),
              ...state.layouts.map((layout) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      selected: state.activeLayout?.id == layout.id,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.secondary.withOpacity(0.1),
                        child: const Icon(Icons.grid_view,
                            color: AppColors.secondary),
                      ),
                      title: Text(layout.name),
                      subtitle: Text(
                          '${layout.totalPanels} panels | ${(layout.totalCapacityKw / 1000).toStringAsFixed(2)} MW'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => bloc.add(DeleteLayout(layout.id)),
                      ),
                    ),
                  )),
            ],
          );
        },
      ),
      floatingActionButton: BlocBuilder<LayoutBloc, LayoutState>(
        bloc: bloc,
        builder: (context, state) {
          if (state.activeLayout == null) return const SizedBox();
          return FloatingActionButton.extended(
            onPressed: () => _showPlaceComponentDialog(
                context, bloc, state.activeLayout!.id),
            icon: const Icon(Icons.add_location),
            label: const Text('Place Component'),
          );
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context, LayoutBloc bloc) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create Layout'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Layout Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isEmpty) return;
              bloc.add(CreateLayout(
                projectId: projectId,
                name: controller.text.trim(),
              ));
              Navigator.pop(ctx);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showGenerateDialog(
      BuildContext context, LayoutBloc bloc, Layout layout) {
    final tiltController = TextEditingController(text: '25');
    final azimuthController = TextEditingController(text: '180');
    final rowSpacingController = TextEditingController(text: '5.0');
    final colSpacingController = TextEditingController(text: '0.02');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Generate Panel Array', style: AppTextStyles.heading3),
            const SizedBox(height: 16),
            TextField(
              controller: tiltController,
              decoration: const InputDecoration(labelText: 'Tilt Angle'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: azimuthController,
              decoration: const InputDecoration(labelText: 'Azimuth'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: rowSpacingController,
              decoration: const InputDecoration(labelText: 'Row Spacing (m)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: colSpacingController,
              decoration:
                  const InputDecoration(labelText: 'Column Spacing (m)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                bloc.add(GeneratePanelArray(
                  layoutId: layout.id,
                  params: PanelArrayParams(
                    panelWidth: 1.0,
                    panelHeight: 2.0,
                    tiltAngle:
                        double.tryParse(tiltController.text) ?? 25,
                    azimuth:
                        double.tryParse(azimuthController.text) ?? 180,
                    rowSpacing:
                        double.tryParse(rowSpacingController.text) ?? 5,
                    columnSpacing:
                        double.tryParse(colSpacingController.text) ?? 0.02,
                    fillAreaGeojson: '{}',
                  ),
                ));
                Navigator.pop(ctx);
              },
              child: const Text('Generate'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPlaceComponentDialog(
      BuildContext context, LayoutBloc bloc, String layoutId) {
    String selectedType = 'INVERTER';
    final latController = TextEditingController();
    final lngController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setInnerState) => Padding(
          padding: EdgeInsets.fromLTRB(
              24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Place Component', style: AppTextStyles.heading3),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(labelText: 'Type'),
                items: [
                  'PANEL',
                  'INVERTER',
                  'TRANSFORMER',
                  'JUNCTION_BOX',
                  'SUBSTATION',
                  'TRACKER',
                  'COMBINER_BOX',
                ]
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) =>
                    setInnerState(() => selectedType = v!),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: latController,
                decoration: const InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: lngController,
                decoration: const InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  final lat = double.tryParse(latController.text);
                  final lng = double.tryParse(lngController.text);
                  if (lat == null || lng == null) return;
                  bloc.add(PlaceComponent(
                    layoutId: layoutId,
                    componentType: selectedType,
                    position:
                        ComponentPosition(latitude: lat, longitude: lng),
                  ));
                  Navigator.pop(ctx);
                },
                child: const Text('Place'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _componentIcon(String type) {
    switch (type) {
      case 'INVERTER':
        return Icons.electrical_services;
      case 'TRANSFORMER':
        return Icons.transform;
      case 'JUNCTION_BOX':
        return Icons.inbox;
      case 'SUBSTATION':
        return Icons.factory;
      case 'TRACKER':
        return Icons.track_changes;
      case 'COMBINER_BOX':
        return Icons.merge;
      default:
        return Icons.memory;
    }
  }
}

class _LayoutDetailCard extends StatelessWidget {
  final Layout layout;
  final bool isGenerating;
  final VoidCallback onGenerate;

  const _LayoutDetailCard({
    required this.layout,
    required this.isGenerating,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(layout.name, style: AppTextStyles.heading3),
            const SizedBox(height: 8),
            Text(
              '${layout.tileCount} tiles | Created ${_formatDate(layout.createdAt)}',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: isGenerating
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : OutlinedButton.icon(
                      onPressed: onGenerate,
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Generate Panel Array'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
