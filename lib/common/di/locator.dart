// lib/common/di/locator.dart
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../repos/courses_repo.dart';
import '../repos/exams_repo.dart';
import '../repos/homeworks_repo.dart';
import '../repos/notes_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../repos/firestore_courses_repo.dart';
import '../repos/firestore_exams_repo.dart';
import '../repos/firestore_homeworks_repo.dart';
import '../repos/firestore_notes_repo.dart';
import '../repos/flashcards_repo.dart';
import '../repos/firestore_flashcards_repo.dart';
import 'package:su_learning_companion/common/repos/resources_repo.dart';
import 'package:su_learning_companion/common/repos/firestore_resources_repo.dart';
import 'package:su_learning_companion/common/providers/auth_provider.dart';


List<SingleChildWidget> buildProviders() => [
  Provider<CoursesRepo>(create: (_) => FirestoreCoursesRepo()),
  Provider<ExamsRepo>(create: (_) => FirestoreExamsRepo()),
  Provider<HomeworksRepo>(create: (_) => FirestoreHomeworksRepo()),
  Provider<NotesRepo>(create: (_) => FirestoreNotesRepo()),
  Provider<ResourcesRepo>(create: (_) => FirestoreResourcesRepo()),
  Provider<FlashcardsRepo>(create: (_) => FirestoreFlashcardsRepo()),
  ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),

];
