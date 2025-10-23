import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../repos/courses_repo.dart';
import '../repos/tasks_repo.dart';
import '../../data/fakes/fake_courses_repo.dart';
import '../../data/fakes/fake_tasks_repo.dart';

List<SingleChildWidget> buildProviders() => [
  Provider<CoursesRepo>(create: (_) => FakeCoursesRepo()),
  Provider<TasksRepo>(create: (_) => FakeTasksRepo()),
];


/// Provider wiring (service locator).
/// - Chooses which repo implementations the app uses.
/// Currently: Fake repos -> in-memory dev data.
/// Future: flip to Firebase repos with one change here.