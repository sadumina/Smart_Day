import 'package:freezed_annotation/freezed_annotation.dart';

import 'priority.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
abstract class Task with _$Task {
  const factory Task({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String title,
    String? description,
    @Default(Priority.medium) Priority priority,
    @JsonKey(name: 'due_at') DateTime? dueAt,
    @JsonKey(name: 'project_id') String? projectId,
    @Default('todo') String status,
    @JsonKey(name: 'completed_subtasks') @Default(0) int completedSubtasks,
    @JsonKey(name: 'total_subtasks') @Default(0) int totalSubtasks,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
