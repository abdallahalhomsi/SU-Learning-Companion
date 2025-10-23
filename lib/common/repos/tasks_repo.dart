import '../models/task.dart';
abstract class TasksRepo {
  Stream<List<Task>> watchAll({String? courseId});
  Future<Task> create(Task t);
  Future<void> update(Task t);
  Future<void> delete(String id);
}

/// Contract for tasks CRUD + streams.
/// Swappable backend via DI.