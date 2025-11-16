import '../../common/models/homework.dart';
import '../../common/repos/homeworks_repo.dart';

class FakeHomeworksRepo implements HomeworksRepo {
  // --------- singleton boilerplate ----------
  FakeHomeworksRepo._internal();
  static final FakeHomeworksRepo _instance = FakeHomeworksRepo._internal();
  factory FakeHomeworksRepo() => _instance;
  // -----------------------------------------

  final List<Homework> _items = [
    Homework(
      id: 'h1',
      courseId: '1',
      title: 'Homework 1',
      date: '15.03.2025',
      time: '23:59',
    ),
    Homework(
      id: 'h2',
      courseId: '2',
      title: 'Homework 1',
      date: '01.04.2025',
      time: '23:59',
    ),
  ];

  @override
  List<Homework> getHomeworksForCourse(String courseId) =>
      _items.where((h) => h.courseId == courseId).toList();

  @override
  void addHomework(Homework homework) {
    _items.add(homework);
  }

  @override
  void removeHomework(String homeworkId) {
    _items.removeWhere((h) => h.id == homeworkId);
  }
}