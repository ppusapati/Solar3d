import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/providers/bloc_providers.dart';
import '../../../shared/providers/service_providers.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/metric_card.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../projects/bloc/project_bloc.dart';

class ProjectDetailScreen extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  ConsumerState<ProjectDetailScreen> createState() =>
      _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends ConsumerState<ProjectDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final bloc = ref.watch(projectBlocProvider);

    return BlocBuilder<ProjectBloc, ProjectState>(
      bloc: bloc,
      builder: (context, state) {
        final project = state.projects
            .where((p) => p.id == widget.projectId)
            .firstOrNull;

        if (project == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const LoadingWidget(message: 'Loading project...'),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(project.name),
            actions: [
              PopupMenuButton(
                itemBuilder: (ctx) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Edit'),
                      dense: true,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete, color: Colors.red),
                      title: Text('Delete', style: TextStyle(color: Colors.red)),
                      dense: true,
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'delete') {
                    _confirmDelete(context, bloc);
                  }
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Project Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(project.name,
                                style: AppTextStyles.heading2),
                          ),
                          StatusBadge(status: project.status),
                        ],
                      ),
                      if (project.description != null) ...[
                        const SizedBox(height: 8),
                        Text(project.description!,
                            style: AppTextStyles.body),
                      ],
                      const Divider(height: 24),
                      if (project.locationName != null)
                        _InfoRow(
                            icon: Icons.location_on,
                            label: 'Location',
                            value: project.locationName!),
                      if (project.clientName != null)
                        _InfoRow(
                            icon: Icons.business,
                            label: 'Client',
                            value: project.clientName!),
                      if (project.targetCapacityMw != null)
                        _InfoRow(
                            icon: Icons.bolt,
                            label: 'Target Capacity',
                            value:
                                '${project.targetCapacityMw!.toStringAsFixed(1)} MW'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Quick Stats
              Text('Quick Stats', style: AppTextStyles.heading3),
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
                    label: 'Capacity',
                    value: project.targetCapacityMw?.toStringAsFixed(1) ??
                        '-',
                    unit: 'MW',
                    icon: Icons.bolt,
                    iconColor: AppColors.primary,
                  ),
                  MetricCard(
                    label: 'Status',
                    value: project.status,
                    icon: Icons.info_outline,
                    iconColor: AppColors.statusColor(project.status),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Module Navigation
              Text('Modules', style: AppTextStyles.heading3),
              const SizedBox(height: 12),
              _ModuleTile(
                icon: Icons.map,
                title: 'Site Map',
                subtitle: 'View and edit site layout on map',
                color: AppColors.secondary,
                onTap: () =>
                    context.go('/projects/${widget.projectId}/map'),
              ),
              _ModuleTile(
                icon: Icons.grid_view,
                title: 'Panel Layout',
                subtitle: 'Design panel arrays and place components',
                color: AppColors.primary,
                onTap: () =>
                    context.go('/projects/${widget.projectId}/layout'),
              ),
              _ModuleTile(
                icon: Icons.science,
                title: 'Simulation',
                subtitle: 'Run shadow, irradiance and yield simulations',
                color: AppColors.statusSimulation,
                onTap: () => context
                    .go('/projects/${widget.projectId}/simulation'),
              ),
              _ModuleTile(
                icon: Icons.electrical_services,
                title: 'Electrical',
                subtitle: 'Design electrical network and stringing',
                color: AppColors.error,
                onTap: () => context
                    .go('/projects/${widget.projectId}/electrical'),
              ),
              _ModuleTile(
                icon: Icons.description,
                title: 'Reports',
                subtitle: 'Generate reports, BOM and exports',
                color: AppColors.success,
                onTap: () => context
                    .go('/projects/${widget.projectId}/reports'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, ProjectBloc bloc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Project?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              bloc.add(DeleteProject(widget.projectId));
              Navigator.pop(ctx);
              context.go('/projects');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label: ', style: AppTextStyles.bodySmall),
          Expanded(
              child: Text(value, style: AppTextStyles.body)),
        ],
      ),
    );
  }
}

class _ModuleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ModuleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: AppTextStyles.subtitle),
        subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
