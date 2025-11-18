/// Provider wiring (service locator).
/// - Chooses which repo implementations the app uses.
/// Currently: Fake repos -> in-memory dev data.
/// Future: flip to Firebase repos with one change here.
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../repos/courses_repo.dart';
import '../../data/fakes/fake_courses_repo.dart';
import '../repos/exams_repo.dart';
import '../repos/homeworks_repo.dart';
import '../../data/fakes/fake_exams_repo.dart';
import '../../data/fakes/fake_homeworks_repo.dart';

List<SingleChildWidget> buildProviders() => [
  Provider<CoursesRepo>(create: (_) => FakeCoursesRepo()),
  Provider<ExamsRepo>(create: (_) => FakeExamsRepo()),
  Provider<HomeworksRepo>(create: (_) => FakeHomeworksRepo()),
];


