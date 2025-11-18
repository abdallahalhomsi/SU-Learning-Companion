// This abstract class defines the contract for a repository that manages Homeworks.
// It provides methods for retrieving, adding, and removing Homeworks.
import '../models/homework.dart';

abstract class HomeworksRepo {
  List<Homework> getHomeworksForCourse(String courseId);
  void addHomework(Homework homework);
  void removeHomework(String homeworkId);
}