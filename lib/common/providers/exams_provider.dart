import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/exam.dart';
import '../repos/exams_repo.dart';

class ExamsProvider extends ChangeNotifier {
  final ExamsRepo _repo;
  ExamsProvider(this._repo);

  StreamSubscription<List<Exam>>? _sub;

  List<Exam> _items = [];
  bool _loading = false;
  String? _error;

  List<Exam> get items => _items;
  bool get isLoading => _loading;
  String? get error => _error;

  void bindCourse(String courseId) {
    _sub?.cancel();
    _loading = true;
    _error = null;
    notifyListeners();

    _sub = _repo.watchExamsForCourse(courseId).listen(
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

  Future<void> add(Exam e) => _repo.addExam(e);
  Future<void> update(Exam e) => _repo.updateExam(e);
  Future<void> remove(String courseId, String examId) => _repo.removeExam(courseId, examId);

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
