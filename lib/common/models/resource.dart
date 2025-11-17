class Resource {
  final String id;
  final String courseId;
  String title;
  String description;
  String link;
  final DateTime createdAt;

  Resource({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.link,
    required this.createdAt,
  });
}