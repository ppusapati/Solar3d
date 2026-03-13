import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/models/project.dart';
import '../../../shared/providers/bloc_providers.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../bloc/project_bloc.dart';

class ProjectListScreen extends ConsumerStatefulWidget {
  const ProjectListScreen({super.key});

  @override
  ConsumerState<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends ConsumerState<ProjectListScreen> {
  String _searchQuery = '';
  String _statusFilter = 'ALL';

  @override
  void initState() {
    super.initState();
    ref.read(projectBlocProvider).add(LoadProjects());
  }

  List<Project> _filterProjects(List<Project> projects) {
    return projects.where((p) {
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (p.locationName
                  ?.toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ??
              false);
      final matchesStatus =
          _statusFilter == 'ALL' || p.status == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ref.watch(projectBlocProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search projects...',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context, bloc),
        icon: const Icon(Icons.add),
        label: const Text('New Project'),
      ),
      body: Column(
        children: [
          // Status filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                'ALL',
                'DRAFT',
                'DESIGN',
                'SIMULATION',
                'REVIEW',
                'APPROVED',
                'ARCHIVED'
              ]
                  .map((status) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          selected: _statusFilter == status,
                          label: Text(status),
                          onSelected: (_) =>
                              setState(() => _statusFilter = status),
                          selectedColor: status == 'ALL'
                              ? null
                              : AppColors.statusColor(status)
                                  .withOpacity(0.2),
                        ),
                      ))
                  .toList(),
            ),
          ),

          // Project list
          Expanded(
            child: BlocBuilder<ProjectBloc, ProjectState>(
              bloc: bloc,
              builder: (context, state) {
                if (state.isLoading && state.projects.isEmpty) {
                  return const LoadingWidget();
                }

                if (state.error != null && state.projects.isEmpty) {
                  return AppErrorWidget(
                    message: state.error!,
                    onRetry: () => bloc.add(LoadProjects()),
                  );
                }

                final filtered = _filterProjects(state.projects);

                if (filtered.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.solar_power_outlined,
                    title: _searchQuery.isNotEmpty
                        ? 'No matching projects'
                        : 'No projects yet',
                    subtitle: _searchQuery.isNotEmpty
                        ? 'Try a different search term'
                        : 'Create your first solar project',
                    actionLabel:
                        _searchQuery.isEmpty ? 'Create Project' : null,
                    onAction: _searchQuery.isEmpty
                        ? () => _showCreateDialog(context, bloc)
                        : null,
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => bloc.add(RefreshProjects()),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final project = filtered[index];
                      return _ProjectListTile(
                        project: project,
                        onTap: () =>
                            context.go('/projects/${project.id}'),
                        onDelete: () {
                          bloc.add(DeleteProject(project.id));
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context, ProjectBloc bloc) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final capacityController = TextEditingController();
    final locationController = TextEditingController();
    final clientController = TextEditingController();

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
            Text('New Project', style: AppTextStyles.heading3),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Project Name *'),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: capacityController,
              decoration:
                  const InputDecoration(labelText: 'Target Capacity (MW)'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: clientController,
              decoration: const InputDecoration(labelText: 'Client Name'),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) return;
                bloc.add(CreateProject(
                  name: nameController.text.trim(),
                  description: descController.text.trim().isNotEmpty
                      ? descController.text.trim()
                      : null,
                  targetCapacityMw:
                      double.tryParse(capacityController.text.trim()),
                  locationName: locationController.text.trim().isNotEmpty
                      ? locationController.text.trim()
                      : null,
                  clientName: clientController.text.trim().isNotEmpty
                      ? clientController.text.trim()
                      : null,
                ));
                Navigator.pop(ctx);
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectListTile extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ProjectListTile({
    required this.project,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(project.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Project?'),
            content: Text('Delete "${project.name}"? This cannot be undone.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel')),
              FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Delete')),
            ],
          ),
        );
      },
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          onTap: onTap,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor:
                AppColors.statusColor(project.status).withOpacity(0.15),
            child: Icon(
              Icons.solar_power,
              color: AppColors.statusColor(project.status),
            ),
          ),
          title: Text(project.name, style: AppTextStyles.subtitle),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (project.locationName != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(project.locationName!,
                          style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
              if (project.clientName != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.business,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(project.clientName!,
                          style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
              const SizedBox(height: 6),
              StatusBadge(status: project.status),
            ],
          ),
          trailing: project.targetCapacityMw != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      project.targetCapacityMw!.toStringAsFixed(1),
                      style: AppTextStyles.heading3,
                    ),
                    Text('MW', style: AppTextStyles.caption),
                  ],
                )
              : const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
