enum TaskType { assignment, exam, quiz, other }
enum TaskStatus { todo, done }

class Task {
  final String id, courseId, title;
  final TaskType type;
  final TaskStatus status;
  final DateTime dueAt;
  final String? notes;
  Task({required this.id,required this.courseId,required this.title,required this.type,required this.status,required this.dueAt,this.notes});
  Map<String,dynamic> toMap()=>{'courseId':courseId,'title':title,'type':type.name,'status':status.name,'dueAt':dueAt.toIso8601String(),'notes':notes};
  factory Task.fromMap(String id, Map<String,dynamic> m)=>Task(
      id:id, courseId:m['courseId'], title:m['title'],
      type:TaskType.values.firstWhere((e)=>e.name==m['type']),
      status:TaskStatus.values.firstWhere((e)=>e.name==m['status']),
      dueAt:DateTime.parse(m['dueAt']), notes:m['notes']);}



/// Data model: Task.
/// - Enum types for kind and status.
/// - toMap/fromMap for storage.
/// Future: add priority, reminders.