import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/project.dart';
import '../../../data/services/supabase_project_repository.dart';

final projectRepositoryProvider = Provider<SupabaseProjectRepository>(
  (ref) => SupabaseProjectRepository(Supabase.instance.client),
);

final projectsProvider = FutureProvider<List<Project>>((ref) {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return Future.value(const []);
  return ref.read(projectRepositoryProvider).list(user.id);
});
