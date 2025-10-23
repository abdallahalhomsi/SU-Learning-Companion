import 'dart:async';
import '../../common/models/course.dart';
import '../../common/repos/courses_repo.dart';

class FakeCoursesRepo implements CoursesRepo {
  final _ctrl = StreamController<List<Course>>.broadcast();
  final _store = <String, Course>{};

  FakeCoursesRepo() {
    final now = DateTime.now();
    _store['c1']=Course(id:'c1',code:'CS310',name:'Mobile Dev',term:'2025F',createdAt:now);
    _emit();
  }
  void _emit()=>_ctrl.add(_store.values.toList()..sort((a,b)=>a.code.compareTo(b.code)));
  @override Stream<List<Course>> watchAll()=>_ctrl.stream;
  @override Future<Course> create(Course c) async { final id='c${_store.length+1}';
  final nc=Course(id:id,code:c.code,name:c.name,term:c.term,instructor:c.instructor,createdAt:c.createdAt);
  _store[id]=nc; _emit(); return nc; }
  @override Future<void> update(Course c) async { _store[c.id]=c; _emit(); }
  @override Future<void> delete(String id) async { _store.remove(id); _emit(); }
}


/// In-memory CoursesRepo for development.
/// - Streams a mutable Map snapshot.
/// - No persistence; resets on app restart.
/// Future: remove/keep for unit tests.