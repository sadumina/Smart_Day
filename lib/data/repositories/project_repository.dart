import '../models/project.dart';

abstract interface class ProjectRepository {
  Future<List<Project>> list(String userId);
  Future<Project> create(Project project);
  Future<Project> update(Project project);
  Future<void> delete(String projectId);
}
