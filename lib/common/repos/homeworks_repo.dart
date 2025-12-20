import '../models/homework.dart';

abstract class HomeworksRepo {

  Future<List<Homework>> getHomeworksForCourse(String courseId);


  Stream<List<Homework>> watchHomeworksForCourse(String courseId);


  Future<void> addHomework(Homework homework);


  Future<void> removeHomework(String courseId, String homeworkId);


  Future<void> updateHomework(Homework homework);
}
