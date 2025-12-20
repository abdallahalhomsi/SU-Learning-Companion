import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/homework.dart';
import '../repos/homeworks_repo.dart';

class HomeworksProvider extends ChangeNotifier {
  final HomeworksRepo _repo;
  HomeworksProvider(this._repo);

  StreamSubscription<List<Homework>>? _sub;

  List<Homework> _items = [];
  bool _loading = false;
  String? _error;

  List<Homework> get items => _items;
  bool get isLoading => _loading;
  String? get error => _error;

  void bindCourse(String courseId) {
    _sub?.cancel();
    _loading = true;
    _error = null;
    notifyListeners();

    _sub = _repo.watchHomeworksForCourse(courseId).listen(
          (data) {
        _items = data;
        _loading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _loading = false;
        _error = e.toString();
        notifyListeners();
      },
    );
  }

  Future<void> add(Homework h) => _repo.addHomework(h);
  Future<void> update(Homework h) => _repo.updateHomework(h);
  Future<void> remove(String courseId, String hwId) => _repo.removeHomework(courseId, hwId);

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
