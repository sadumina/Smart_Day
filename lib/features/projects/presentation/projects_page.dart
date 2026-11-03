import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/project.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../tasks/providers/task_providers.dart';
import 'project_progress.dart';
import '../providers/project_providers.dart';
import 'project_form_sheet.dart';

class ProjectsPage extends ConsumerWidget {
  const ProjectsPage({super.key});

  Future<void> _openForm(BuildContext context, [Project? project]) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => ProjectFormSheet(project: project),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsProvider);
    final tasks = ref.watch(todayTasksProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Add project'),
      ),
      body: projects.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(projectsProvider),
        ),
        data: (items) => items.isEmpty
            ? const EmptyState(
                title: 'No projects yet',
                message: 'Create a project to group related work.',
                icon: Icons.folder_open_outlined,
              )
            : RefreshIndicator(
                onRefresh: () => ref.refresh(projectsProvider.future),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final project = items[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _parseColor(project.color),
                          child: const Icon(
                            Icons.folder_outlined,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(project.name),
                        subtitle: ProjectProgress(
                          project: project,
                          tasks: tasks.hasValue
                              ? tasks.value ?? const []
                              : const [],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              await _openForm(context, project);
                            } else {
                              await ref
                                  .read(projectRepositoryProvider)
                                  .delete(project.id);
                              ref.invalidate(projectsProvider);
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                        onTap: () => _openForm(context, project),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  Color _parseColor(String value) {
    final hex = value.replaceFirst('#', '');
    final normalized = hex.length == 6 ? 'FF$hex' : hex;
    final parsed = int.tryParse(normalized, radix: 16);
    return parsed == null ? Colors.indigo : Color(parsed);
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 44),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
