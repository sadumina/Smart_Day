import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/project.dart';
import '../repositories/project_repository.dart';

class SupabaseProjectRepository implements ProjectRepository {
  SupabaseProjectRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Project>> list(String userId) async {
    final rows = await _client
        .from('projects')
        .select()
        .eq('user_id', userId)
        .order('name');
    return rows.map((row) => Project.fromJson(row)).toList();
  }

  @override
  Future<Project> create(Project project) async {
    final row = await _client
        .from('projects')
        .insert(_toJson(project))
        .select()
        .single();
    return Project.fromJson(row);
  }

  @override
  Future<Project> update(Project project) async {
    final row = await _client
        .from('projects')
        .update(_toJson(project))
        .eq('id', project.id)
        .select()
        .single();
    return Project.fromJson(row);
  }

  @override
  Future<void> delete(String projectId) {
    return _client.from('projects').delete().eq('id', projectId);
  }

  Map<String, dynamic> _toJson(Project project) {
    return {
      'id': project.id,
      'user_id': project.userId,
      'name': project.name,
      'color': project.color,
    };
  }
}
