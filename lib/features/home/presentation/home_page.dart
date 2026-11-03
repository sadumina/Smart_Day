import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/progress_ring.dart';
import '../../tasks/providers/task_providers.dart';
import '../../tasks/presentation/task_form_sheet.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(todayTasksProvider);
    final firstName = 'there';
    return Scaffold(
      appBar: AppBar(
        title: Text('Good morning, $firstName'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (_) => const TaskFormSheet(),
        ),
        child: const Icon(Icons.add),
      ),
      body: tasks.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (items) {
          final done = items.where((task) => task.status == 'done').length;
          final progress = items.isEmpty ? 0.0 : done / items.length;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppCard(
                child: Row(
                  children: [
                    ProgressRing(
                      value: progress,
                      label: '$done/${items.length}',
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Today’s progress',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            items.isEmpty
                                ? 'Add a task to plan your day.'
                                : '$done tasks completed today.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Today’s tasks',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              if (items.isEmpty)
                const EmptyState(
                  title: 'Your task list is clear',
                  message: 'Use the + button to add something you want to do.',
                )
              else
                ...items
                    .take(5)
                    .map(
                      (task) => CheckboxListTile(
                        value: task.status == 'done',
                        title: Text(task.title),
                        contentPadding: EdgeInsets.zero,
                        onChanged: (_) async {
                          await ref
                              .read(taskRepositoryProvider)
                              .update(
                                task.copyWith(
                                  status: task.status == 'done'
                                      ? 'todo'
                                      : 'done',
                                  updatedAt: DateTime.now(),
                                ),
                              );
                          ref.invalidate(todayTasksProvider);
                        },
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
