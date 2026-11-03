import 'package:freezed_annotation/freezed_annotation.dart';

import 'priority.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
abstract class Task with _$Task {
  const factory Task({
    required String id,
    required String userId,
    required String title,
    String? description,
    @Default(Priority.medium) Priority priority,
    DateTime? dueAt,
    String? projectId,
    @Default('todo') String status,
    @Default(0) int completedSubtasks,
    @Default(0) int totalSubtasks,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
