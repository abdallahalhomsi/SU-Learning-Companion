import '../models/homework.dart';

abstract class HomeworksRepo {
  List<Homework> getHomeworksForCourse(String courseId);
  void addHomework(Homework homework);
  void removeHomework(String homeworkId);
}