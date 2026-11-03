// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Task _$TaskFromJson(Map<String, dynamic> json) => _Task(
  id: json['id'] as String,
  userId: json['userId'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  priority:
      $enumDecodeNullable(_$PriorityEnumMap, json['priority']) ??
      Priority.medium,
  dueAt: json['dueAt'] == null ? null : DateTime.parse(json['dueAt'] as String),
  projectId: json['projectId'] as String?,
  status: json['status'] as String? ?? 'todo',
  completedSubtasks: (json['completedSubtasks'] as num?)?.toInt() ?? 0,
  totalSubtasks: (json['totalSubtasks'] as num?)?.toInt() ?? 0,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TaskToJson(_Task instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'title': instance.title,
  'description': instance.description,
  'priority': _$PriorityEnumMap[instance.priority]!,
  'dueAt': instance.dueAt?.toIso8601String(),
  'projectId': instance.projectId,
  'status': instance.status,
  'completedSubtasks': instance.completedSubtasks,
  'totalSubtasks': instance.totalSubtasks,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$PriorityEnumMap = {
  Priority.high: 'high',
  Priority.medium: 'medium',
  Priority.low: 'low',
};
