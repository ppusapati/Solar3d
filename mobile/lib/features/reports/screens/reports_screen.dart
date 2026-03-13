import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/models/report.dart';
import '../../../shared/providers/bloc_providers.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/status_badge.dart';
import '../bloc/report_bloc.dart';

class ReportsScreen extends ConsumerWidget {
  final String projectId;

  const ReportsScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(reportBlocProvider(projectId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.add),
            onSelected: (type) => _generateReport(context, bloc, type),
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                  value: 'SITE_LAYOUT', child: Text('Site Layout')),
              const PopupMenuItem(
                  value: 'PANEL_LAYOUT', child: Text('Panel Layout')),
              const PopupMenuItem(
                  value: 'SYSTEM_CAPACITY',
                  child: Text('System Capacity')),
              const PopupMenuItem(
                  value: 'ELECTRICAL_DIAGRAM',
                  child: Text('Electrical Diagram')),
              const PopupMenuItem(
                  value: 'ENERGY_ESTIMATE',
                  child: Text('Energy Estimate')),
              const PopupMenuItem(
                  value: 'FULL_ENGINEERING',
                  child: Text('Full Engineering')),
            ],
          ),
        ],
      ),
      body: BlocBuilder<ReportBloc, ReportState>(
        bloc: bloc,
        builder: (context, state) {
          if (state.isLoading && state.reports.isEmpty) {
            return const LoadingWidget(message: 'Loading reports...');
          }

          if (state.error != null && state.reports.isEmpty) {
            return AppErrorWidget(
              message: state.error!,
              onRetry: () => bloc.add(LoadReports(projectId)),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Quick actions
              Text('Quick Actions', style: AppTextStyles.heading3),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.receipt_long,
                      label: 'Generate BOM',
                      isLoading: state.isGenerating,
                      onTap: () => bloc.add(GenerateBOM(projectId)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.picture_as_pdf,
                      label: 'Full Report',
                      isLoading: state.isGenerating,
                      onTap: () => _generateReport(
                          context, bloc, 'FULL_ENGINEERING'),
                    ),
                  ),
                ],
              ),

              // BOM
              if (state.bom != null) ...[
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Bill of Materials', style: AppTextStyles.heading3),
                    Text(
                      'Total: \$${state.bom!.totalCost.toStringAsFixed(0)}',
                      style: AppTextStyles.subtitle
                          .copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: state.bom!.items.map((item) => ListTile(
                          dense: true,
                          title: Text(item.name),
                          subtitle: Text(item.category),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('x${item.quantity}',
                                  style: AppTextStyles.subtitle),
                              if (item.totalCost != null)
                                Text(
                                    '\$${item.totalCost!.toStringAsFixed(0)}',
                                    style: AppTextStyles.bodySmall),
                            ],
                          ),
                        )).toList(),
                  ),
                ),
              ],

              // Reports list
              const SizedBox(height: 24),
              Text('Generated Reports', style: AppTextStyles.heading3),
              const SizedBox(height: 8),

              if (state.reports.isEmpty && state.bom == null)
                EmptyStateWidget(
                  icon: Icons.description_outlined,
                  title: 'No reports yet',
                  subtitle: 'Generate reports from the menu above',
                ),

              ...state.reports.map((report) => _ReportCard(
                    report: report,
                    onDelete: () => bloc.add(DeleteReport(report.id)),
                  )),
            ],
          );
        },
      ),
    );
  }

  void _generateReport(
      BuildContext context, ReportBloc bloc, String type) {
    String format = 'PDF';
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setInnerState) => AlertDialog(
          title: Text('Generate ${type.replaceAll('_', ' ')}'),
          content: DropdownButtonFormField<String>(
            value: format,
            decoration: const InputDecoration(labelText: 'Format'),
            items: ['PDF', 'CSV', 'EXCEL', 'JSON']
                .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                .toList(),
            onChanged: (v) => setInnerState(() => format = v!),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                bloc.add(GenerateReport(
                  projectId: projectId,
                  reportType: type,
                  format: format,
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
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isLoading;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              isLoading
                  ? const SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(icon, size: 32, color: AppColors.primary),
              const SizedBox(height: 8),
              Text(label, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final Report report;
  final VoidCallback onDelete;

  const _ReportCard({required this.report, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          _formatIcon(report.format),
          color: _formatColor(report.format),
          size: 32,
        ),
        title: Text(report.reportType.replaceAll('_', ' ')),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(report.format, style: AppTextStyles.bodySmall),
            const SizedBox(height: 4),
            StatusBadge(status: report.status),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (report.isCompleted)
              IconButton(
                icon: const Icon(Icons.download, color: AppColors.success),
                onPressed: () {},
              ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.grey),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  IconData _formatIcon(String format) {
    switch (format) {
      case 'PDF':
        return Icons.picture_as_pdf;
      case 'CSV':
        return Icons.table_chart;
      case 'EXCEL':
        return Icons.grid_on;
      case 'JSON':
        return Icons.data_object;
      default:
        return Icons.description;
    }
  }

  Color _formatColor(String format) {
    switch (format) {
      case 'PDF':
        return Colors.red;
      case 'CSV':
        return Colors.green;
      case 'EXCEL':
        return Colors.green.shade700;
      case 'JSON':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
