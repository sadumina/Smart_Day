import '../models/focus_session.dart';

abstract interface class FocusRepository {
  Future<List<FocusSession>> list(String userId);
  Future<FocusSession> create(FocusSession session);
}
