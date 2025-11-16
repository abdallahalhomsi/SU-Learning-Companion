import '../../common/models/exam.dart';
import '../../common/repos/exams_repo.dart';

class FakeExamsRepo implements ExamsRepo {
  // ---------- singleton boilerplate ----------
  FakeExamsRepo._internal();                       // private constructor
  static final FakeExamsRepo _instance =
  FakeExamsRepo._internal();                   // single instance
  factory FakeExamsRepo() => _instance;           // always return same one
  // -------------------------------------------

  final List<Exam> _items = [
    Exam(
      id: 'e1',
      courseId: '1',
      title: 'Exam 1',
      date: '10.03.2025',
      time: '09:00',
    ),
    Exam(
      id: 'e2',
      courseId: '2',
      title: 'Exam 1',
      date: '25.05.2025',
      time: '13:00',
    ),
  ];

  @override
  List<Exam> getExamsForCourse(String courseId) =>
      _items.where((e) => e.courseId == courseId).toList();

  @override
  void addExam(Exam exam) {
    _items.add(exam);
  }

  @override
  void removeExam(String examId) {
    _items.removeWhere((e) => e.id == examId);
  }
}