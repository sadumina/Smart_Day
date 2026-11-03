// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FocusSession _$FocusSessionFromJson(Map<String, dynamic> json) =>
    _FocusSession(
      id: json['id'] as String,
      userId: json['userId'] as String,
      taskId: json['taskId'] as String?,
      projectId: json['projectId'] as String?,
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$FocusSessionToJson(_FocusSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'taskId': instance.taskId,
      'projectId': instance.projectId,
      'durationMinutes': instance.durationMinutes,
      'startedAt': instance.startedAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };
