import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  ProfileRepository(this._client);

  final SupabaseClient _client;

  Future<String?> readDisplayName(String userId) async {
    final profile = await _client
        .from('profiles')
        .select('display_name')
        .eq('id', userId)
        .maybeSingle();
    return profile?['display_name'] as String?;
  }

  Future<void> save({
    required String userId,
    required String displayName,
  }) {
    return _client.from('profiles').upsert({
      'id': userId,
      'display_name': displayName,
    });
  }

  Future<void> delete(String userId) {
    return _client.from('profiles').delete().eq('id', userId);
  }
}
