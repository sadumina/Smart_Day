import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/focus_session.dart';
import '../repositories/focus_repository.dart';

class SupabaseFocusRepository implements FocusRepository {
  SupabaseFocusRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<FocusSession>> list(String userId) async {
    final rows = await _client
        .from('focus_sessions')
        .select()
        .eq('user_id', userId)
        .order('started_at', ascending: false);
    return rows.map((row) => FocusSession.fromJson(row)).toList();
  }

  @override
  Future<FocusSession> create(FocusSession session) async {
    final row = await _client
        .from('focus_sessions')
        .insert({
          'id': session.id,
          'user_id': session.userId,
          'task_id': session.taskId,
          'project_id': session.projectId,
          'duration_minutes': session.durationMinutes,
          'started_at': session.startedAt.toIso8601String(),
          'completed_at': session.completedAt?.toIso8601String(),
        })
        .select()
        .single();
    return FocusSession.fromJson(row);
  }
}
