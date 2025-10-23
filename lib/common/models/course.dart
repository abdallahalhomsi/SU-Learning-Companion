class Course {
  final String id, code, name, term;
  final String? instructor;
  final DateTime createdAt;
  Course({required this.id,required this.code,required this.name,required this.term,this.instructor,required this.createdAt});
  Map<String,dynamic> toMap()=>{'code':code,'name':name,'term':term,'instructor':instructor,'createdAt':createdAt.toIso8601String()};
  factory Course.fromMap(String id, Map<String,dynamic> m)=>Course(
      id:id, code:m['code'], name:m['name'], term:m['term'],
      instructor:m['instructor'], createdAt:DateTime.parse(m['createdAt']));
}

/// Data model: Course.
/// - No Flutter imports.
/// - toMap/fromMap for storage.
/// Future: add fields if needed (section, room).