// repositories/resources_repo.dart
import '../models/resource.dart';

abstract class ResourcesRepo {
  Future<List<Resource>> getResourcesByCourse(String courseId);
  Future<Resource> getResourceById(String id);
  Future<void> addResource(Resource resource);
  Future<void> updateResource(Resource resource);
  Future<void> deleteResource(String id);
}

class FakeResourcesRepo implements ResourcesRepo {
 
  FakeResourcesRepo._internal();
  static final FakeResourcesRepo _instance = FakeResourcesRepo._internal();
  factory FakeResourcesRepo() => _instance;
  
  final List<Resource> _resources = [
    // original mock resources ...
  ];
  // models/resource.dart
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'courseId': courseId,
        'title': title,
        'description': description,
        'link': link,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Resource.fromJson(Map<String, dynamic> json) => Resource(
        id: json['id'],
        courseId: json['courseId'],
        title: json['title'],
        description: json['description'],
        link: json['link'],
        createdAt: DateTime.parse(json['createdAt']),
      );
}


  @override
  Future<List<Resource>> getResourcesByCourse(String courseId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _resources
        .where((r) => r.courseId == courseId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<Resource> getResourceById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _resources.firstWhere((r) => r.id == id);
  }

  @override
  Future<void> addResource(Resource resource) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _resources.add(resource);
  }

  @override
  Future<void> updateResource(Resource resource) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _resources.indexWhere((r) => r.id == resource.id);
    if (index != -1) _resources[index] = resource;
  }

  @override
  Future<void> deleteResource(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _resources.removeWhere((r) => r.id == id);
  }
}

