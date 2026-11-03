import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/task.dart';
import '../repositories/task_repository.dart';

class SupabaseTaskRepository implements TaskRepository {
  SupabaseTaskRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Task>> list({
    required String userId,
    String? status,
    String? projectId,
  }) async {
    var query = _client.from('tasks').select().eq('user_id', userId);
    if (status != null) query = query.eq('status', status);
    if (projectId != null) query = query.eq('project_id', projectId);
    final rows = await query.order('due_at', ascending: true);
    return rows.map((row) => Task.fromJson(row)).toList();
  }

  @override
  Future<Task> create(Task task) async {
    final row = await _client
        .from('tasks')
        .insert(_toJson(task))
        .select()
        .single();
    return Task.fromJson(row);
  }

  @override
  Future<Task> update(Task task) async {
    final row = await _client
        .from('tasks')
        .update(_toJson(task))
        .eq('id', task.id)
        .select()
        .single();
    return Task.fromJson(row);
  }

  @override
  Future<void> delete(String taskId) {
    return _client.from('tasks').delete().eq('id', taskId);
  }

  Map<String, dynamic> _toJson(Task task) {
    final json = task.toJson()
      ..remove('createdAt')
      ..remove('updatedAt')
      ..['user_id'] = task.userId
      ..['project_id'] = task.projectId
      ..['due_at'] = task.dueAt?.toIso8601String()
      ..['completed_subtasks'] = task.completedSubtasks
      ..['total_subtasks'] = task.totalSubtasks;
    json.remove('userId');
    json.remove('projectId');
    json.remove('dueAt');
    json.remove('completedSubtasks');
    json.remove('totalSubtasks');
    return json;
  }
}
