// lib/common/di/locator.dart
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../repos/courses_repo.dart';
import '../repos/exams_repo.dart';
import '../repos/homeworks_repo.dart';
import '../repos/notes_repo.dart';

import '../repos/firestore_courses_repo.dart';
import '../repos/firestore_exams_repo.dart';
import '../repos/firestore_homeworks_repo.dart';
import '../repos/firestore_notes_repo.dart';

List<SingleChildWidget> buildProviders() => [
  Provider<CoursesRepo>(create: (_) => FirestoreCoursesRepo()),
  Provider<ExamsRepo>(create: (_) => FirestoreExamsRepo()),
  Provider<HomeworksRepo>(create: (_) => FirestoreHomeworksRepo()),
  Provider<NotesRepo>(create: (_) => FirestoreNotesRepo()),
];
