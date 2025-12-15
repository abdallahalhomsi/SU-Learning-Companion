class FirebasePaths {
  // Users
  static String userDoc(String uid) => 'users/$uid';
  static String userCourses(String uid) => 'users/$uid/courses';

  static String courseDoc(String uid, String courseId) =>
      'users/$uid/courses/$courseId';

  static String exams(String uid, String courseId) => 'users/$uid/courses/$courseId/exams';
  static String homeworks(String uid, String courseId) => 'users/$uid/courses/$courseId/homeworks';
  static String notes(String uid, String courseId) => 'users/$uid/courses/$courseId/notes';

  static String flashGroups(String uid, String courseId) => 'users/$uid/courses/$courseId/flashcardGroups';
  static String flashCards(String uid, String courseId, String groupId) =>
      'users/$uid/courses/$courseId/flashcardGroups/$groupId/cards';

  // Global course catalog
  static String courses() => 'courses';
  static String course(String courseId) => 'courses/$courseId';

  // Global resources per course
  static String courseResources(String courseId) => 'courseResources/$courseId/items';
}
