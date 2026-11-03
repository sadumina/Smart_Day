import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/task.dart';
import '../../../data/services/supabase_task_repository.dart';

final taskRepositoryProvider = Provider<SupabaseTaskRepository>(
  (ref) => SupabaseTaskRepository(Supabase.instance.client),
);

final todayTasksProvider = FutureProvider<List<Task>>((ref) {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return Future.value(const []);
  return ref.read(taskRepositoryProvider).list(userId: user.id);
});
