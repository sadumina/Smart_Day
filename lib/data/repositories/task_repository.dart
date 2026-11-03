import '../models/task.dart';

abstract interface class TaskRepository {
  Future<List<Task>> list({
    required String userId,
    String? status,
    String? projectId,
  });

  Future<Task> create(Task task);
  Future<Task> update(Task task);
  Future<void> delete(String taskId);
}
