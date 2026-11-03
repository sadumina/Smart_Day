import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/task.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/priority_chip.dart';
import '../providers/task_providers.dart';
import 'task_form_sheet.dart';

class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  Future<void> _openForm(BuildContext context, [Task? task]) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => TaskFormSheet(task: task),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(todayTasksProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Add task'),
      ),
      body: tasks.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(todayTasksProvider),
        ),
        data: (items) => items.isEmpty
            ? const EmptyState(
                title: 'No tasks yet',
                message: 'Add your first task to start planning today.',
              )
            : RefreshIndicator(
                onRefresh: () => ref.refresh(todayTasksProvider.future),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final task = items[index];
                    return Dismissible(
                      key: ValueKey(task.id),
                      background: _SwipeBackground(
                        color: Colors.green,
                        icon: Icons.check,
                        alignment: Alignment.centerLeft,
                      ),
                      secondaryBackground: _SwipeBackground(
                        color: Colors.red,
                        icon: Icons.delete_outline,
                        alignment: Alignment.centerRight,
                      ),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          await ref
                              .read(taskRepositoryProvider)
                              .delete(task.id);
                        } else {
                          await ref
                              .read(taskRepositoryProvider)
                              .update(
                                task.copyWith(
                                  status: 'done',
                                  updatedAt: DateTime.now(),
                                ),
                              );
                        }
                        ref.invalidate(todayTasksProvider);
                        return true;
                      },
                      child: ListTile(
                        tileColor: Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: Text(task.title),
                        subtitle: task.description?.isNotEmpty == true
                            ? Text(task.description!)
                            : null,
                        leading: Icon(
                          task.status == 'done'
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: task.status == 'done'
                              ? Colors.green
                              : Theme.of(context).colorScheme.primary,
                        ),
                        trailing: PriorityChip(priority: task.priority.name),
                        onTap: () => _openForm(context, task),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}

class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({
    required this.color,
    required this.icon,
    required this.alignment,
  });

  final Color color;
  final IconData icon;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: color.withValues(alpha: 0.15),
      child: Icon(icon, color: color),
    );
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
