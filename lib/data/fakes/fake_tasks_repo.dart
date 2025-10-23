import 'dart:async';
import '../../common/models/task.dart';
import '../../common/repos/tasks_repo.dart';

class FakeTasksRepo implements TasksRepo {
  final _ctrl = StreamController<List<Task>>.broadcast();
  final _store = <String, Task>{};

  FakeTasksRepo() {
    final now = DateTime.now();
    _store['t1']=Task(id:'t1',courseId:'c1',title:'HW1',type:TaskType.assignment,status:TaskStatus.todo,dueAt:now.add(const Duration(days:3)));
    _emit();
  }
  void _emit()=>_ctrl.add(_store.values.toList()..sort((a,b)=>a.dueAt.compareTo(b.dueAt)));
  @override Stream<List<Task>> watchAll({String? courseId}) =>
      _ctrl.stream.map((l)=>l.where((t)=>courseId==null||t.courseId==courseId).toList());
  @override Future<Task> create(Task t) async { final id='t${_store.length+1}';
  final nt=Task(id:id,courseId:t.courseId,title:t.title,type:t.type,status:t.status,dueAt:t.dueAt,notes:t.notes);
  _store[id]=nt; _emit(); return nt; }
  @override Future<void> update(Task t) async { _store[t.id]=t; _emit(); }
  @override Future<void> delete(String id) async { _store.remove(id); _emit(); }
}

/// In-memory TasksRepo for development.
/// - Seeds a sample task.
/// - Mirrors the real API so UI won’t change later.