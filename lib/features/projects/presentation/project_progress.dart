import 'package:flutter/material.dart';

import '../../../data/models/project.dart';
import '../../../data/models/task.dart';

class ProjectProgress extends StatelessWidget {
  const ProjectProgress({
    required this.project,
    required this.tasks,
    super.key,
  });

  final Project project;
  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    final projectTasks = tasks
        .where((task) => task.projectId == project.id)
        .toList();
    final completed = projectTasks
        .where((task) => task.status == 'done')
        .length;
    final progress = projectTasks.isEmpty
        ? 0.0
        : completed / projectTasks.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          projectTasks.isEmpty
              ? 'No tasks yet'
              : '$completed of ${projectTasks.length} tasks complete',
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: progress,
          minHeight: 6,
          borderRadius: BorderRadius.circular(8),
        ),
      ],
    );
  }
}
