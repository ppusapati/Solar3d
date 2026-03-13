import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/providers/bloc_providers.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../shared/widgets/metric_card.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../projects/bloc/project_bloc.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(projectBlocProvider).add(LoadProjects());
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ref.watch(projectBlocProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solar3D'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _showSettings(context),
          ),
        ],
      ),
      body: BlocBuilder<ProjectBloc, ProjectState>(
        bloc: bloc,
        builder: (context, state) {
          if (state.isLoading && state.projects.isEmpty) {
            return const LoadingWidget(message: 'Loading projects...');
          }

          if (state.error != null && state.projects.isEmpty) {
            return AppErrorWidget(
              message: state.error!,
              onRetry: () => bloc.add(LoadProjects()),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => bloc.add(RefreshProjects()),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Summary Cards
                Text('Overview', style: AppTextStyles.heading2),
                const SizedBox(height: 12),
                _buildSummaryCards(state),
                const SizedBox(height: 24),

                // Recent Projects
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Projects', style: AppTextStyles.heading3),
                    TextButton(
                      onPressed: () => context.go('/projects'),
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...state.projects.take(5).map(
                      (project) => _ProjectCard(
                        project: project,
                        onTap: () =>
                            context.go('/projects/${project.id}'),
                      ),
                    ),

                if (state.projects.isEmpty)
                  _EmptyDashboard(
                    onCreateProject: () => context.go('/projects'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(ProjectState state) {
    final totalProjects = state.projects.length;
    final activeProjects =
        state.projects.where((p) => p.status != 'ARCHIVED').length;
    final totalCapacity = state.projects
        .where((p) => p.targetCapacityMw != null)
        .fold<double>(0, (sum, p) => sum + (p.targetCapacityMw ?? 0));

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.5,
      children: [
        MetricCard(
          label: 'Total Projects',
          value: '$totalProjects',
          icon: Icons.folder_outlined,
          iconColor: AppColors.secondary,
        ),
        MetricCard(
          label: 'Active',
          value: '$activeProjects',
          icon: Icons.play_circle_outline,
          iconColor: AppColors.success,
        ),
        MetricCard(
          label: 'Total Capacity',
          value: totalCapacity.toStringAsFixed(1),
          unit: 'MW',
          icon: Icons.bolt,
          iconColor: AppColors.primary,
        ),
        MetricCard(
          label: 'In Review',
          value: '${state.projects.where((p) => p.status == 'REVIEW').length}',
          icon: Icons.rate_review_outlined,
          iconColor: AppColors.warning,
        ),
      ],
    );
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings', style: AppTextStyles.heading3),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.cloud_outlined),
              title: const Text('Server URL'),
              subtitle: const Text('Configure API endpoint'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode_outlined),
              title: const Text('Theme'),
              subtitle: const Text('System default'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              subtitle: const Text('Solar3D Mobile v1.0.0'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final dynamic project;
  final VoidCallback onTap;

  const _ProjectCard({required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: const Icon(Icons.solar_power, color: AppColors.primary),
        ),
        title: Text(
          project.name,
          style: AppTextStyles.subtitle,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (project.locationName != null)
              Text(project.locationName, style: AppTextStyles.bodySmall),
            const SizedBox(height: 4),
            StatusBadge(status: project.status),
          ],
        ),
        trailing: project.targetCapacityMw != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${project.targetCapacityMw?.toStringAsFixed(1)}',
                    style: AppTextStyles.subtitle,
                  ),
                  Text('MW', style: AppTextStyles.caption),
                ],
              )
            : null,
      ),
    );
  }
}

class _EmptyDashboard extends StatelessWidget {
  final VoidCallback onCreateProject;

  const _EmptyDashboard({required this.onCreateProject});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.solar_power, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No projects yet',
            style: AppTextStyles.heading3.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first solar project to get started',
            style: AppTextStyles.body.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onCreateProject,
            icon: const Icon(Icons.add),
            label: const Text('Create Project'),
          ),
        ],
      ),
    );
  }
}
