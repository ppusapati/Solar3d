import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/models/simulation.dart';
import '../../../shared/providers/bloc_providers.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/metric_card.dart';
import '../../../shared/widgets/status_badge.dart';
import '../bloc/simulation_bloc.dart';

class SimulationScreen extends ConsumerWidget {
  final String projectId;

  const SimulationScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(simulationBlocProvider(projectId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulations'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context, bloc),
        icon: const Icon(Icons.science),
        label: const Text('New Simulation'),
      ),
      body: BlocBuilder<SimulationBloc, SimulationState>(
        bloc: bloc,
        builder: (context, state) {
          if (state.isLoading && state.simulations.isEmpty) {
            return const LoadingWidget(message: 'Loading simulations...');
          }

          if (state.error != null && state.simulations.isEmpty) {
            return AppErrorWidget(
              message: state.error!,
              onRetry: () => bloc.add(LoadSimulations(projectId)),
            );
          }

          if (state.simulations.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.science_outlined,
              title: 'No simulations yet',
              subtitle:
                  'Run simulations to analyze shading, irradiance and yield',
              actionLabel: 'Create Simulation',
              onAction: () => _showCreateDialog(context, bloc),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Running simulation indicator
              if (state.isRunning) ...[
                Card(
                  color: AppColors.statusSimulation.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Simulation Running',
                                  style: AppTextStyles.subtitle),
                              Text('Processing results...',
                                  style: AppTextStyles.bodySmall),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              ...state.simulations.map((sim) => _SimulationCard(
                    simulation: sim,
                    onRun: () => bloc.add(RunSimulation(sim.id)),
                    onDelete: () => bloc.add(DeleteSimulation(sim.id)),
                  )),
            ],
          );
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context, SimulationBloc bloc) {
    final nameController = TextEditingController();
    String simType = 'SHADOW';

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
              Text('New Simulation', style: AppTextStyles.heading3),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration:
                    const InputDecoration(labelText: 'Simulation Name'),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: simType,
                decoration:
                    const InputDecoration(labelText: 'Simulation Type'),
                items: [
                  'SHADOW',
                  'IRRADIANCE',
                  'ANNUAL_YIELD',
                ]
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t.replaceAll('_', ' ')),
                        ))
                    .toList(),
                onChanged: (v) => setInnerState(() => simType = v!),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  if (nameController.text.trim().isEmpty) return;
                  bloc.add(CreateSimulation(
                    projectId: projectId,
                    layoutId: '',
                    name: nameController.text.trim(),
                    simulationType: simType,
                    params: SimulationParams(
                      startTime: DateTime.now()
                          .subtract(const Duration(days: 182))
                          .toIso8601String(),
                      endTime: DateTime.now().toIso8601String(),
                      latitude: 0,
                      longitude: 0,
                    ),
                  ));
                  Navigator.pop(ctx);
                },
                child: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimulationCard extends StatelessWidget {
  final Simulation simulation;
  final VoidCallback onRun;
  final VoidCallback onDelete;

  const _SimulationCard({
    required this.simulation,
    required this.onRun,
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
                Icon(
                  _simTypeIcon(simulation.simulationType),
                  color: AppColors.statusSimulation,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(simulation.name, style: AppTextStyles.subtitle),
                ),
                StatusBadge(status: simulation.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              simulation.simulationType.replaceAll('_', ' '),
              style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
            ),

            // Results
            if (simulation.result != null) ...[
              const Divider(height: 24),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2.0,
                children: [
                  _ResultMetric(
                    label: 'Annual Yield',
                    value:
                        '${(simulation.result!.annualYieldKwh / 1000).toStringAsFixed(0)}',
                    unit: 'MWh',
                  ),
                  _ResultMetric(
                    label: 'Performance Ratio',
                    value:
                        '${(simulation.result!.performanceRatio * 100).toStringAsFixed(1)}',
                    unit: '%',
                  ),
                  _ResultMetric(
                    label: 'Irradiance',
                    value: simulation.result!.totalIrradianceKwhM2
                        .toStringAsFixed(0),
                    unit: 'kWh/m\u00B2',
                  ),
                  _ResultMetric(
                    label: 'Shading Loss',
                    value: simulation.result!.shadingLossPercent
                        .toStringAsFixed(1),
                    unit: '%',
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!simulation.isCompleted && !simulation.isRunning)
                  FilledButton.icon(
                    onPressed: onRun,
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: const Text('Run'),
                  ),
                if (simulation.isRunning)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                const Spacer(),
                IconButton(
                  icon:
                      const Icon(Icons.delete_outline, color: Colors.grey),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _simTypeIcon(String type) {
    switch (type) {
      case 'SHADOW':
        return Icons.wb_shade;
      case 'IRRADIANCE':
        return Icons.wb_sunny;
      case 'ANNUAL_YIELD':
        return Icons.show_chart;
      default:
        return Icons.science;
    }
  }
}

class _ResultMetric extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _ResultMetric({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppTextStyles.caption),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value,
                style: AppTextStyles.heading3
                    .copyWith(color: AppColors.primary)),
            const SizedBox(width: 2),
            Text(unit, style: AppTextStyles.bodySmall),
          ],
        ),
      ],
    );
  }
}
