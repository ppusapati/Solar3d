import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/providers/bloc_providers.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/metric_card.dart';
import '../bloc/electrical_bloc.dart';

class ElectricalScreen extends ConsumerWidget {
  final String projectId;

  const ElectricalScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(electricalBlocProvider(projectId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Electrical Design'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context, bloc),
        icon: const Icon(Icons.add),
        label: const Text('New Network'),
      ),
      body: BlocBuilder<ElectricalBloc, ElectricalState>(
        bloc: bloc,
        builder: (context, state) {
          if (state.isLoading && state.networks.isEmpty) {
            return const LoadingWidget(message: 'Loading networks...');
          }

          if (state.error != null && state.networks.isEmpty) {
            return AppErrorWidget(
              message: state.error!,
              onRetry: () => bloc.add(LoadNetworks(projectId)),
            );
          }

          if (state.networks.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.electrical_services,
              title: 'No electrical networks',
              subtitle: 'Create a network to design stringing and inverters',
              actionLabel: 'Create Network',
              onAction: () => _showCreateDialog(context, bloc),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Active network overview
              if (state.activeNetwork != null) ...[
                Text('Active Network', style: AppTextStyles.heading3),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(state.activeNetwork!.name,
                            style: AppTextStyles.heading3),
                        const SizedBox(height: 12),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1.8,
                          children: [
                            MetricCard(
                              label: 'DC Capacity',
                              value: (state.activeNetwork!.totalDcCapacityKw /
                                      1000)
                                  .toStringAsFixed(2),
                              unit: 'MW',
                              icon: Icons.bolt,
                              iconColor: AppColors.primary,
                            ),
                            MetricCard(
                              label: 'AC Capacity',
                              value: (state.activeNetwork!.totalAcCapacityKw /
                                      1000)
                                  .toStringAsFixed(2),
                              unit: 'MW',
                              icon: Icons.power,
                              iconColor: AppColors.success,
                            ),
                            MetricCard(
                              label: 'DC/AC Ratio',
                              value: state.activeNetwork!.dcAcRatio
                                  .toStringAsFixed(2),
                              icon: Icons.compare_arrows,
                              iconColor: AppColors.secondary,
                            ),
                            MetricCard(
                              label: 'Strings',
                              value: '${state.activeNetwork!.totalStrings}',
                              icon: Icons.linear_scale,
                              iconColor: AppColors.warning,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: state.isGenerating
                                    ? null
                                    : () => bloc.add(AutoGenerateStrings(
                                        state.activeNetwork!.id)),
                                icon: state.isGenerating
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      )
                                    : const Icon(Icons.auto_awesome),
                                label: const Text('Auto-String'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => bloc.add(CalculateLosses(
                                    state.activeNetwork!.id)),
                                icon: const Icon(Icons.analytics),
                                label: const Text('Calc Losses'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Loss breakdown chart
              if (state.losses != null) ...[
                Text('Loss Analysis', style: AppTextStyles.heading3),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                              sections: [
                                _lossSection('Soiling',
                                    state.losses!.soilingPercent, Colors.brown),
                                _lossSection('Shading',
                                    state.losses!.shadingPercent, Colors.grey),
                                _lossSection(
                                    'Mismatch',
                                    state.losses!.mismatchPercent,
                                    Colors.orange),
                                _lossSection('Wiring',
                                    state.losses!.wiringPercent, Colors.red),
                                _lossSection(
                                    'Inverter',
                                    state.losses!.inverterPercent,
                                    Colors.purple),
                                _lossSection(
                                    'Transformer',
                                    state.losses!.transformerPercent,
                                    Colors.blue),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Total Loss: ${state.losses!.totalLossPercent.toStringAsFixed(1)}%',
                          style: AppTextStyles.subtitle
                              .copyWith(color: AppColors.error),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Strings list
              if (state.strings.isNotEmpty) ...[
                Text('Panel Strings (${state.strings.length})',
                    style: AppTextStyles.heading3),
                const SizedBox(height: 8),
                ...state.strings.map((s) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.linear_scale,
                            color: AppColors.secondary),
                        title: Text(s.name),
                        subtitle: Text(
                          '${s.panelCount} panels | '
                          '${s.voltageV.toStringAsFixed(0)}V | '
                          '${s.powerW.toStringAsFixed(0)}W',
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                    )),
              ],

              // All networks
              const SizedBox(height: 16),
              Text('All Networks', style: AppTextStyles.heading3),
              const SizedBox(height: 8),
              ...state.networks.map((net) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      selected: state.activeNetwork?.id == net.id,
                      leading: const CircleAvatar(
                        backgroundColor: Color(0x1AEF4444),
                        child: Icon(Icons.electrical_services,
                            color: AppColors.error),
                      ),
                      title: Text(net.name),
                      subtitle: Text(
                        '${net.totalStrings} strings | '
                        '${net.totalInverters} inverters',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => bloc.add(DeleteNetwork(net.id)),
                      ),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }

  PieChartSectionData _lossSection(
      String title, double value, Color color) {
    return PieChartSectionData(
      value: value,
      color: color,
      title: '${value.toStringAsFixed(1)}%',
      radius: 50,
      titleStyle: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  void _showCreateDialog(BuildContext context, ElectricalBloc bloc) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create Network'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Network Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) return;
              bloc.add(CreateNetwork(
                projectId: projectId,
                layoutId: '',
                name: nameController.text.trim(),
              ));
              Navigator.pop(ctx);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
